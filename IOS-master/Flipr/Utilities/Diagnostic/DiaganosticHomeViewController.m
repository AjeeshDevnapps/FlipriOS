/*
 * (c) 2014-2020, Cypress Semiconductor Corporation or a subsidiary of 
 * Cypress Semiconductor Corporation.  All rights reserved.
 * 
 * This software, including source code, documentation and related 
 * materials ("Software"),  is owned by Cypress Semiconductor Corporation 
 * or one of its subsidiaries ("Cypress") and is protected by and subject to 
 * worldwide patent protection (United States and foreign), 
 * United States copyright laws and international treaty provisions.  
 * Therefore, you may use this Software only as provided in the license 
 * agreement accompanying the software package from which you 
 * obtained this Software ("EULA").
 * If no EULA applies, Cypress hereby grants you a personal, non-exclusive, 
 * non-transferable license to copy, modify, and compile the Software 
 * source code solely for use in connection with Cypress's 
 * integrated circuit products.  Any reproduction, modification, translation, 
 * compilation, or representation of this Software except as specified 
 * above is prohibited without the express written permission of Cypress.
 * 
 * Disclaimer: THIS SOFTWARE IS PROVIDED AS-IS, WITH NO WARRANTY OF ANY KIND, 
 * EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, NONINFRINGEMENT, IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. Cypress 
 * reserves the right to make changes to the Software without notice. Cypress 
 * does not assume any liability arising out of the application or use of the 
 * Software or any product or circuit described in the Software. Cypress does 
 * not authorize its products for use in any products where a malfunction or 
 * failure of the Cypress product may reasonably be expected to result in 
 * significant property damage, injury or death ("High Risk Product"). By 
 * including Cypress's product in a High Risk Product, the manufacturer 
 * of such system or application assumes all risk of such use and in doing 
 * so agrees to indemnify Cypress against all liability.
 */

#import "DiaganosticHomeViewController.h"
#import "ScannedPeripheralTableViewCell.h"
#import "CyCBManager.h"
#import "CBPeripheralExt.h"
//#import "ProgressHandler.h"
#import "Utilities.h"
//#import "UIView+Toast.h"
#import "UIAlertController+Additions.h"
#import "Constants.h"
//#import "GATTDBServiceListViewController.h"
#import "FirmwareUpgradeHomeViewController.h"
#import "GATTDBDetailsViewController.h"
#import "Flipr-Swift.h"

#import "JGProgressHUD.h"

#define CAROUSEL_SEGUE              @"CarouselViewID"
#define PERIPHERAL_CELL_IDENTIFIER  @"peripheralCell"

/*!
 *  @class HomeViewController
 *
 *  @discussion Class to handle the available device listing and connection
 *
 */
@interface DiaganosticHomeViewController ()<UITableViewDataSource, UITableViewDelegate, cbDiscoveryManagerDelegate, UISearchBarDelegate,cbCharacteristicManagerDelegate>
{
    __weak IBOutlet UILabel *refreshingStatusLabel;
    UIRefreshControl *refreshPeripheralListControl;
    BOOL isBluetoothON, isSearchActive;
    NSArray *searchResults;
    BOOL isBootLoaderConnection;
    BOOL isBootLoaderConnectingOnprogress;

    NSString *fliprName;
    NSArray *characteristicArray;
    JGProgressHUD *hud;
    NSTimer *fliprFetchTimer;


}

@property (weak, nonatomic) IBOutlet UITableView *scannedPeripheralsTableView;
@property (weak, nonatomic) IBOutlet UIButton *dataRecoveryButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIStackView *bleStackView;



@end

@implementation DiaganosticHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    fliprName = @"Flipr 00197BF2";
    fliprName = AppSharedData.sharedInstance.getCurrentFliprSerial;
    hud = [[JGProgressHUD alloc] init];
    hud.textLabel.text = LOCALIZEDSTRING(@"Connecting");
    [self.dataRecoveryButton setTitle:LOCALIZEDSTRING(@"Next") forState:UIControlStateNormal];
//    self.descLabel.text = LOCALIZEDSTRING(@"The update instructions.");
    self.descLabel.text = @"";

//    [HUD showInView:self.view];
//    hud.indicatorView = JGProgressHUDErrorIndicatorView();
//    hud.textLabel.text = error?.localizedDescription;

    isBootLoaderConnectingOnprogress = FALSE;
    self.closeButton.layer.cornerRadius = 12;
    self.dataRecoveryButton.layer.cornerRadius = 12;

    
    [self.errorLabel setHidden:TRUE];
    [self.dataRecoveryButton setUserInteractionEnabled:FALSE];
    self.dataRecoveryButton.backgroundColor = [UIColor colorWithRed:0.804 green:0.835 blue:0.878 alpha:1.0f];
    [self.dataRecoveryButton setTitleColor:[UIColor colorWithRed:0.067 green:0.09 blue:0.161 alpha:1.0f] forState:UIControlStateNormal];

//    [self.dataRecoveryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(bluetoothOFFNotification:)
        name:@"BluetoothDisconncetion"
        object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(bluetoothOnNotification:)
        name:@"BluetoothConncetionOn"
        object:nil];

//    [self.closeButton setTitle:@"BUTTON_CLOSE" forState:UIControlStateNormal];
//    isSearchActive = TRUE;
    // Do any additional setup after loading the view, typically from a nib.
    [self addRefreshControl];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:LOCALIZEDSTRING(@"OTAUpgradeStatus")] boolValue]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOCALIZEDSTRING(@"OTAUpgradeStatus")];
        
        [[UIAlertController alertWithTitle:APP_NAME message:LOCALIZEDSTRING(@"OTAAppUpgradePendingWarning") delegate:nil cancelButtonTitle:OPT_OK otherButtonTitles:nil, nil] presentInParent:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.bleStackView setHidden:TRUE];

//    [self addSearchButtonToNavBar];
    [[self navBarTitleLabel] setText:@"Diagnostic"];
    
//    if (!fliprFetchTimer){
        fliprFetchTimer = [NSTimer scheduledTimerWithTimeInterval:20.0
                                                                                         target:self
                                                                                       selector:@selector(notDetectedFlipr)
                                                                                       userInfo:nil
                                                                                        repeats:NO];

//    }

//    self.title = @"Upgrade Flipr";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   // [[CyCBManager sharedManager] disconnectPeripheral:[[CyCBManager sharedManager] myPeripheral]];
    [[CyCBManager sharedManager] setCbDiscoveryDelegate:self];
    
    // Start scanning for devices
    [[CyCBManager sharedManager] startScanning];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[CyCBManager sharedManager] stopScanning];
    [super removeSearchButtonFromNavBar];
}


-(void)notDetectedFlipr {
   // [self helpView];
    
    AppSharedData.sharedInstance.diagnosticErrorCount =  AppSharedData.sharedInstance.diagnosticErrorCount + 1;
    DiagnosticErrorViewController *successVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DiagnosticErrorViewController"];
    [self.navigationController pushViewController:successVC animated:YES];

//    if (AppSharedData.sharedInstance.diagnosticErrorCount > 2){
//        AppSharedData.sharedInstance.diagnosticErrorCount = 0;
//        DiagnosticErrorViewController *successVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DiagnosticErrorViewController"];
//        [self.navigationController pushViewController:successVC animated:YES];
//    }else{
//        DiagnosticErrorViewController *successVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DiagnosticErrorViewController"];
//        [self.navigationController pushViewController:successVC animated:YES];
//
//    }
    
}

- (void) bluetoothOFFNotification:(NSNotification *) notification
{
    isBluetoothON = FALSE;
    self.iconImageView.image = [UIImage imageNamed:@"diagnosticIcon"];
    self.descLabel.text = LOCALIZEDSTRING(@"Bluetooth connection error");

}

- (void) bluetoothOnNotification:(NSNotification *) notification
{
    isBluetoothON = TRUE;
    self.iconImageView.image = [UIImage imageNamed:@"diagnosticIcon"];
    self.descLabel.text = LOCALIZEDSTRING(@"The update instructions.");

}

- (IBAction)recoveryBtnTouched:(UIButton *)sender{
    [self showDataRecoverScreen];
}

-(void)showDataRecoverScreen{
    FlipValueReadingViewController *successVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FlipValueReadingViewController"];
    [self.navigationController pushViewController:successVC animated:YES];

}

-(void)helpView{
    DiagnosticHelpViewController *successVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DiagnosticHelpViewController"];
    [self.navigationController pushViewController:successVC animated:YES];

}

- (IBAction)closeBtnTouched:(UIButton *)sender{
    [self dismissViewControllerAnimated:TRUE completion:nil];
   
}

#pragma mark - UISearchBarDelegate
// called when text starts editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearchActive = YES;
}

// called when text ends editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    //    isSearchActive = NO;
}

// called before text changes
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *searchString = text.length == 0 ? [searchBar.text substringToIndex:searchBar.text.length-1] : [NSString stringWithFormat:@"%@%@",searchBar.text, text];
    if (searchString.length == 0) {
        isSearchActive = NO;
        [_scannedPeripheralsTableView reloadData];
    } else {
        isSearchActive = YES;
        __weak __typeof(self) wself = self;
        [self searchBLEPeripheralsNamesForSubString:searchString onFinish:^(NSArray *filteredPeripheralList) {
            __strong __typeof(self) sself = wself;
            if (sself) {
                sself->searchResults = [[NSArray alloc] initWithArray:filteredPeripheralList];
                [sself.scannedPeripheralsTableView reloadData];
            }
        }];
    }
    return YES;
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Search Filter Method

- (void) searchBLEPeripheralsNamesForSubString:(NSString *)searchString onFinish:(void(^)(NSArray *filteredPeripheralList))finish
{
    if (searchString) {
        searchString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    NSMutableArray *filteredPeripheralList = [NSMutableArray new];
    for (CBPeripheralExt *peripheral in [[CyCBManager sharedManager] foundPeripherals])
    {
        if (peripheral.mPeripheral.name.length > 0){
            if ([[peripheral.mPeripheral.name lowercaseString] containsString:[searchString lowercaseString]] == true ){
                //&& [[peripheral.mPeripheral.name lowercaseString] rangeOfString:[@"HUB" lowercaseString]].location == NSNotFound) {
                [filteredPeripheralList addObject:peripheral];
            }
        }
        else
        {
            if ([[LOCALIZEDSTRING(@"unknownPeripheral") lowercaseString] rangeOfString:[searchString lowercaseString]].location != NSNotFound) {
                [filteredPeripheralList addObject:peripheral];
            }
        }
    }
    finish((NSArray *)filteredPeripheralList);
}

#pragma mark - RefreshControl
/*!
 *  @method addRefreshControl
 *
 *  @discussion Method to add a control for pull to refresh functonality .
 *
 */
-(void)addRefreshControl
{
    refreshPeripheralListControl = [[UIRefreshControl alloc] init];
    [refreshPeripheralListControl addTarget:self action:@selector(refreshPeripheralList:) forControlEvents:UIControlEventValueChanged];
    [_scannedPeripheralsTableView addSubview:refreshPeripheralListControl];
}

#pragma mark - TableView Datasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    return isBluetoothON ? LOCALIZEDSTRING(@"Pull down to refresh...") : LOCALIZEDSTRING(@"Bluetooth is not Turn On") ;
    return isBluetoothON ? LOCALIZEDSTRING(@"Pull down to refresh...") : LOCALIZEDSTRING(@"Pull down to refresh...") ;

}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textColor = [UIColor blueColor]; //5584A6
    [header.textLabel setTextColor:[UIColor colorWithRed:0.04 green:0.22 blue:0.48 alpha:1.0]];
    header.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isBluetoothON) {
        if (searchResults.count < 1){
//            [self.errorLabel setHidden:FALSE];
//            [self.descLabel setHidden:TRUE];
        }else{
//            [self.descLabel setHidden:FALSE];
//            [self.errorLabel setHidden:TRUE];
        }
        if (isSearchActive) {
            return searchResults.count;
        }
        return searchResults.count;
//        return [[[CyCBManager sharedManager] foundPeripherals] count];
    }else{
//        [self.errorLabel setHidden:FALSE];
    }
    
    
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [fliprFetchTimer invalidate];
//    [self.bleStackView setHidden:FALSE];
    [self.iconImageView setHidden:FALSE];
    [self.dataRecoveryButton setUserInteractionEnabled:TRUE];
    self.dataRecoveryButton.backgroundColor = [UIColor colorWithRed:0.067 green:0.09 blue:0.161 alpha:1.0f];
    [self.dataRecoveryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    ScannedPeripheralTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:PERIPHERAL_CELL_IDENTIFIER];
    cell.isDiagnostic = true;
    NSArray<CBPeripheralExt *> *array = nil;
    if (isSearchActive) {
        array = searchResults;
    } else {
//        array = [[CyCBManager sharedManager] foundPeripherals];
        array = searchResults;

    }
    CBPeripheralExt *peripheral = array[indexPath.row];
    [cell setDiscoveredPeripheralDataFromPeripheral:peripheral];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *cellBGImageView=[[UIImageView alloc]initWithFrame:cell.bounds];
    UIImage *buttonImage = [[UIImage imageNamed:CELL_BG_IMAGE]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(2, 10, 2, 10)];
    [cellBGImageView setImage:buttonImage];
    cell.backgroundView=cellBGImageView;
}

#pragma mark - TableView Delegates

/*!
 *  @method tableView: didSelectRowAtIndexPath:
 *
 *  @discussion Method to handle the device selection
 *
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (isBluetoothON) {
//        [hud showInView:self.scannedPeripheralsTableView];
//        [[NSNotificationCenter defaultCenter]
//            postNotificationName:@"fr.isee-u.FirmwereUpgradeStarted"
//            object:self];
//
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        [self connectPeripheral:indexPath.row];
//    }
}
#pragma mark -Table Update

/*!
 *  @method refreshPeripheralList:
 *
 *  @discussion Method to refresh the device list
 *
 */
-(void)refreshPeripheralList:(UIRefreshControl*) refreshControl {
    if(refreshControl) {
        self.searchBar.text = @""; // Reset filter
        isSearchActive = NO;
        [refreshControl endRefreshing];
        [[CyCBManager sharedManager] refreshPeripherals];
    }
}

#pragma mark - TableView Refresh

/*!
 *  @method reloadPeripheralTable
 *
 *  @discussion Method to reload the device list
 *
 */
-(void)reloadPeripheralTable
{
    if (!isSearchActive) {
        [_scannedPeripheralsTableView reloadData];
    }
}

-(void)discoveryDidRefresh
{
    
    __weak __typeof(self) wself = self;
    [self searchBLEPeripheralsNamesForSubString:fliprName onFinish:^(NSArray *filteredPeripheralList) {
        __strong __typeof(self) sself = wself;
        if (sself) {
            sself->searchResults = [[NSArray alloc] initWithArray:filteredPeripheralList];
            [sself.scannedPeripheralsTableView reloadData];
        }
    }];
    
    [self reloadPeripheralTable];
    if (isBootLoaderConnection == TRUE){
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self connectForBootloader];
//        });
        
        
//        if (isBootLoaderConnectingOnprogress == FALSE){
//            isBootLoaderConnectingOnprogress = TRUE;
//            [self connectPeripheral:0];
//        }
    }
}


-(void)connectForBootloader{
    if (isBootLoaderConnectingOnprogress == FALSE){
        isBootLoaderConnectingOnprogress = TRUE;
        [self connectPeripheral:0];
    }
}

#pragma mark - BlueTooth Turned Off Delegate

/*!
 *  @method bluetoothStateUpdatedToState:
 *
 *  @discussion Method to be called when state of Bluetooth changes
 *
 */
-(void)bluetoothStateUpdatedToState:(BOOL)state
{
    isBluetoothON = state;
    [self reloadPeripheralTable];
    isBluetoothON ? [_scannedPeripheralsTableView setScrollEnabled:YES] : [_scannedPeripheralsTableView setScrollEnabled:NO];
}

#pragma mark - Connect Peripheral

/*!
 *  @method connectPeripheral:
 *
 *  @discussion Method to connect the selected peripheral
 *
 */
-(void)connectPeripheral:(NSInteger)index {
    const NSArray<CBPeripheralExt *> *model = [[CyCBManager sharedManager] foundPeripherals];
    BOOL ok = model.count > 0;
    if (ok) {
        NSInteger modelIndex = -1;
        if (isSearchActive) {
            CBPeripheralExt *viewItem = searchResults[index];
            for (NSInteger i = 0; i < model.count; ++i) {
                if ([model[i].mPeripheral.identifier isEqual:viewItem.mPeripheral.identifier]) {
                    modelIndex = i;
                    break;
                }
            }
        } else {
            modelIndex = index;
        }
        
        ok = modelIndex >= 0;
        if (ok) {
            CBPeripheralExt *modelItem = searchResults[modelIndex];
//            [[ProgressHandler sharedInstance] showWithTitle:LOCALIZEDSTRING(@"connecting") detail:modelItem.mPeripheral.name];
            
            [[CyCBManager sharedManager] connectPeripheral:modelItem.mPeripheral completionHandler:^(BOOL success, NSError *error) {
//                [[ProgressHandler sharedInstance] hideProgressView];
                if(success) {
//                    [self performSegueWithIdentifier:CAROUSEL_SEGUE sender:self];

                    if (self->isBootLoaderConnection == TRUE){
                        BOOL isFoundBootLoader = false;
                        CBService *bootLoaderService;
                        for (CBService *service in [[CyCBManager sharedManager] foundServices])
                        {
                            if ([service.UUID isEqual:CUSTOM_BOOT_LOADER_SERVICE_UUID])
                            {
                                bootLoaderService = service;
                                isFoundBootLoader = YES;
                                break;
                            }
                        }
                        if (isFoundBootLoader == true){
                            [[CyCBManager sharedManager] setMyService:bootLoaderService];
                            FirmwareUpgradeHomeViewController *selectionVC = [self.storyboard instantiateViewControllerWithIdentifier:FILE_SEL_VIEW_SB_ID];
                            [self.navigationController pushViewController:selectionVC animated:YES];
                        }
                    }else{
                        
                        [[CyCBManager sharedManager] setSelectedDevice:modelItem.mPeripheral.name];
                        CBMutableService *gattDBService=[[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:GENERIC_ACCESS_SERVICE_UUID] primary:YES];
                        
                        [[CyCBManager sharedManager] setMyService:gattDBService] ;
//                        self->isBootLoaderConnection = TRUE;
                        /*
                        GATTDBServiceListViewController *servicesVC = [self.storyboard instantiateViewControllerWithIdentifier:GATTDB_VIEW_SB_ID];
                        [self.navigationController pushViewController:servicesVC animated:YES];
                        self->isBootLoaderConnection = TRUE;
                        
*/
                      
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self showHexWrite];
//
//                        });
                    }
                    

                } else {
                    if(error) {
                        NSString *errorString = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
                        if(errorString.length) {
//                            [self.view makeToast:errorString];
                        } else {
//                            [self.view makeToast:LOCALIZEDSTRING(@"unknownError")];
                        }
                    }
                }
            }];
        }
    }
    
    if (!ok) {
//        [self.view makeToast:LOCALIZEDSTRING(@"unknownError")];
        [[CyCBManager sharedManager] refreshPeripherals];
        
        hud.textLabel.text = LOCALIZEDSTRING(@"Connecting Failed");
        [hud dismissAfterDelay:3.0];
    }
}

-(void)showHexWrite{
    

    
    
    NSArray *servicesArray = [[[CyCBManager sharedManager] foundServices] copy]; // Getting the available services
    if (servicesArray.count > 3){
        
        [[CyCBManager sharedManager] setMyService:[servicesArray objectAtIndex:3]];
    }
    
    [self getcharcteristicsForService:[[CyCBManager sharedManager] myService]];

    
/*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        GATTDBDetailsViewController *writeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GATTDBDetailsViewControllerID"];
        [self.navigationController pushViewController:writeVC animated:YES];

    });
    
    */
  
}

-(void) handleCharacteristicNotifications
{
    NSString *message = @"";
    BOOL indicationsDisabled = NO, notificationsDisabled = NO;
    
    for (CBService *service in [[CyCBManager sharedManager] foundServices])
    {
        for (CBCharacteristic *characteristic in service.characteristics) {
            
            if (characteristic.isNotifying){
                
                if ((characteristic.properties & CBCharacteristicPropertyNotify) != 0) {
                    message = NOTIFY_DISABLED;
                    
                    notificationsDisabled = YES;
                    [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:characteristic.service.UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:characteristic.UUID] descriptor:nil operation:STOP_NOTIFY];
                }
                else
                {
                    message = INDICATE_DISABLED;
                    indicationsDisabled = YES;
                    
                    [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:characteristic.service.UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:characteristic.UUID] descriptor:nil operation:STOP_INDICATE];
                }
                
                [[[CyCBManager sharedManager] myPeripheral] setNotifyValue:NO forCharacteristic:characteristic];
            }
        }
    }
    
    if (indicationsDisabled && notificationsDisabled)
    {
        message = INDICATE_AND_NOTIFY_DISABLED;
    }
    
    // Showing the toast message
    if (![message isEqual:@""])
    {
//        if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[CarouselViewController class]])
//        {
//            CarouselViewController *carouselVC = [self.navigationController.viewControllers lastObject];
//            [carouselVC.view makeToast:message];
//        }
    }
}

-(void) getcharcteristicsForService:(CBService *)service
{
    [[CyCBManager sharedManager] setCbCharacteristicDelegate:self];
    [[[CyCBManager sharedManager] myPeripheral] discoverCharacteristics:nil forService:service];
}

#pragma mark - CBCharacteristicManagerDelegate Methods

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:[[CyCBManager sharedManager] myService].UUID])
         {
             [hud dismissAfterDelay:0.0];

             characteristicArray = [service.characteristics copy];
             [[CyCBManager sharedManager] setMyCharacteristic:[characteristicArray objectAtIndex:0]];
             [[CyCBManager sharedManager] setCharacteristicProperties:[self getPropertiesForCharacteristic:[characteristicArray objectAtIndex:0]]];
             GATTDBDetailsViewController *writeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GATTDBDetailsViewControllerID"];
             [self.navigationController pushViewController:writeVC animated:YES];


//             [_characteristicListTableView reloadData];
         }
}

-(NSMutableArray *) getPropertiesForCharacteristic:(CBCharacteristic *)characteristic {
    
    NSMutableArray *propertyList = [NSMutableArray array];
    
    if ((characteristic.properties & CBCharacteristicPropertyRead) != 0) {
        [propertyList addObject:READ];
    }
    if (((characteristic.properties & CBCharacteristicPropertyWrite) != 0) || ((characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0) ) {
       [propertyList addObject:WRITE];;
    }
    if ((characteristic.properties & CBCharacteristicPropertyNotify) != 0) {
       [propertyList addObject:NOTIFY];;
    }
    if ((characteristic.properties & CBCharacteristicPropertyIndicate) != 0) {
       [propertyList addObject:INDICATE];;
    }
    
    return propertyList;
}


@end
