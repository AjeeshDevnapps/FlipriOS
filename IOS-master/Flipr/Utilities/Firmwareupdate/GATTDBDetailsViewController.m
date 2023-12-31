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

#import "GATTDBDetailsViewController.h"
//#import "GATTDBDescriptorListViewController.h"
#import "CyCBManager.h"
#import "Utilities.h"
//#import "MRHexKeyboard.h"
#import "ResourceHandler.h"
#import "Constants.h"
#import "LoggerHandler.h"
#import "NSData+hexString.h"
#import "NSString+hex.h"
#import "UIAlertController+Additions.h"
#import "FirmwareUpgradeHomeViewController.h"
#import "CBPeripheralExt.h"

#import "Flipr-Swift.h"

//#import "ProgressHandler.h"

#define DESCRIPTOR_LIST_SEGUE       @"descriptorListSegue"

#define HEX_ALERTVIEW_TAG       101
#define ASCII_ALERTVIEW_TAG     102


#define ASCIIT_TEXFIELD_TAG     103
#define HEX_TEXTFIELD_TAG       104

/*!
 *  @class GATTDBDetailsViewController
 *
 *  @discussion Class to handle the characteristic value display and characteristic property related operations
 *
 */
@interface GATTDBDetailsViewController ()<cbCharacteristicManagerDelegate, UITextFieldDelegate, AlertControllerDelegate,cbDiscoveryManagerDelegate>
{
//    MRHexKeyboard *hexKeyboard;
    UIAlertController *hexDialog, *asciiDialog;
    UITextField *hexDialogTextField, *asciiDialogTextField;
    
    void(^characteristicWriteCompletionHandler)(BOOL success,NSError *error);
    UIActivityIndicatorView *spinner;
    NSTimer *exitTimer;
    BOOL appEnterToInactive;

}

/* Datafields */
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *characteristicNameLabel;

@property (weak, nonatomic) IBOutlet UITextField *ASCIIValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *hexValueTextField;

@property (weak, nonatomic) IBOutlet UILabel *dateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *descriptorButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

/* Buttons and related constraints  */
@property (weak, nonatomic) IBOutlet UIButton *readButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *readButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *readButtonCentreXConstraint;

@property (weak, nonatomic) IBOutlet UIButton *writeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeButtonCentreXConstraint;

@property (weak, nonatomic) IBOutlet UIButton *notifyButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notifyButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notifyButtonCentreXConstraint;

@property (weak, nonatomic) IBOutlet UIButton *indicateButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicateButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicateButtonCentreXConstraint;


@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end

@implementation GATTDBDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.msgLabel.text = LOCALIZEDSTRING(@"Wait");
    appEnterToInactive = FALSE;

    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(receiveTestNotification:)
        name:@"DisconncetionDevice"
        object:nil];
    [self addAppStateNotifications];
    exitTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                                                     target:self
                                                                                   selector:@selector(exitProcess)
                                                                                   userInfo:nil
                                                                                    repeats:NO];

    _descriptorButton.hidden = YES;
    [self checkDescriptorsForCharacteristic:[[CyCBManager sharedManager] myCharacteristic]];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    spinner.center = self.view.center;
    spinner.tag = 12;
    [self.view addSubview:spinner];
    [spinner startAnimating];
}



- (void)viewWillAppear:(BOOL)animated
{
    [self initView];
    [super viewWillAppear:animated];
    [[super navBarTitleLabel] setText:@"Upgrade Flipr 1/2"];
//    self.title = @"Upgrade Flipr 1/2";
    [[CyCBManager sharedManager] setCbCharacteristicDelegate:self];
    self.navigationItem.hidesBackButton = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [spinner stopAnimating];

    //TODO(SAHO)
    //[hexDialog dismissWithClickedButtonIndex:0 animated:NO];
}


-(void)viewDidAppear:(BOOL)animated{
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self writeHexValue];

    });

}

-(void)addAppStateNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didAppActive)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didAppInactive)
                                                     name:UIApplicationWillResignActiveNotification object:nil];

}


- (void)didAppInactive {
    if (exitTimer){
        [exitTimer invalidate];
    }
    appEnterToInactive = TRUE;
}

- (void)didAppActive {
    if (appEnterToInactive){
        if (exitTimer){
            [exitTimer invalidate];
        }
        exitTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                                                         target:self
                                                                                       selector:@selector(exitProcess)
                                                                                       userInfo:nil
                                                                                        repeats:NO];
    }
}


-(void)exitProcess {
    [exitTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    FirmwareUpgradeFailureViewController *errorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FirmwareUpgradeFailureViewController"];
    [self.navigationController pushViewController:errorVC animated:YES];

}

- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.

    if ([[notification name] isEqualToString:@"DisconncetionDevice"])
        NSLog (@"Successfully received the test notification!");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self reConnectDevice];
    /*
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
    
    */
}

-(void)reConnectDevice
{
    [[CyCBManager sharedManager] disconnectPeripheral:[[CyCBManager sharedManager] myPeripheral]];
    [[CyCBManager sharedManager] setCbDiscoveryDelegate:self];
    
    // Start scanning for devices
    [[CyCBManager sharedManager] startScanning];
}



-(void)discoveryDidRefresh
{
    __weak __typeof(self) wself = self;
    [self searchBLEPeripheralsNamesForSubString:[[CyCBManager sharedManager] selectedDevice] onFinish:^(NSArray *filteredPeripheralList) {
        __strong __typeof(self) sself = wself;
        if (sself) {
            [[CyCBManager sharedManager] setCbDiscoveryDelegate:nil];
            [self connectPeripheral];
        }
    }];
    
    
}

- (void) searchBLEPeripheralsNamesForSubString:(NSString *)searchString onFinish:(void(^)(NSArray *filteredPeripheralList))finish
{
    if (searchString) {
        searchString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    NSMutableArray *filteredPeripheralList = [NSMutableArray new];
    for (CBPeripheralExt *peripheral in [[CyCBManager sharedManager] foundPeripherals])
    {
        if (peripheral.mPeripheral.name.length > 0){
            if ([[peripheral.mPeripheral.name lowercaseString] rangeOfString:[searchString lowercaseString]].location != NSNotFound) {
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

- (void) bluetoothStateUpdatedToState:(BOOL)state{
    NSLog(@"Error gatdb");
}


-(void)connectPeripheral {
    const NSArray<CBPeripheralExt *> *model = [[CyCBManager sharedManager] foundPeripherals];
    BOOL ok = model.count > 0;
    
    
    for (NSInteger i = 0; i < model.count; ++i) {
        if ([model[i].mPeripheral.name isEqual:[[CyCBManager sharedManager] selectedDevice]]) {
            CBPeripheralExt *modelItem = model[i];

           // [[ProgressHandler sharedInstance] showWithTitle:LOCALIZEDSTRING(@"connecting") detail:modelItem.mPeripheral.name];
            [[CyCBManager sharedManager] connectPeripheral:modelItem.mPeripheral completionHandler:^(BOOL success, NSError *error) {
//                [[ProgressHandler sharedInstance] hideProgressView];
                if(success) {
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
                            [exitTimer invalidate];
                            [[CyCBManager sharedManager] setMyService:bootLoaderService];
                            FirmwareUpgradeHomeViewController *selectionVC = [self.storyboard instantiateViewControllerWithIdentifier:FILE_SEL_VIEW_SB_ID];
                            [self.navigationController pushViewController:selectionVC animated:YES];
                        }
                } else {
                    if(error) {
                        NSString *errorString = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
                        if(errorString.length) {
//                            [self.view makeToast:errorString];
                        } else {
//                            [self.view makeToast:LOCALIZEDSTRING(@"unknownError")];
                        }
                        //testing case 
                    }
                }
            }];


        }
    }
    
    
    if (!ok) {
//        [self.view makeToast:LOCALIZEDSTRING(@"unknownError")];
        [[CyCBManager sharedManager] refreshPeripherals];
    }
}

/*!
 *  @method initView
 *
 *  @discussion Method to initilize the view when user enters the screen
 *
 */
-(void) initView
{
    // update characteristic and service name labels
    
    _serviceNameLabel.text = [ResourceHandler getServiceNameForUUID:[[CyCBManager sharedManager] myService].UUID];
    _characteristicNameLabel.text = [ResourceHandler getCharacteristicNameForUUID:[[CyCBManager sharedManager] myCharacteristic].UUID];
    
    // Adding buttons
    
    _readButtonCentreXConstraint.constant = 2 *self.view.frame.size.width;
    _writeButtonCentreXConstraint.constant = 2 *self.view.frame.size.width;
    _notifyButtonCentreXConstraint.constant = 2 *self.view.frame.size.width;
    _indicateButtonCentreXConstraint.constant = 2 *self.view.frame.size.width;
    
    int propertyCount = (int)[[CyCBManager sharedManager] characteristicProperties].count;
    int buttonWidth = self.view.frame.size.width/propertyCount;
    float centerXConstant;
    
    /* Setting the property button position and width */
    
    centerXConstant = -1 *((buttonWidth * (propertyCount - 1))*0.5);
    
    for (NSString *property in [[CyCBManager sharedManager] characteristicProperties])
    {
        if ([property isEqual:READ])
        {
            _readButtonCentreXConstraint.constant = centerXConstant;
            _readButtonWidthConstraint.constant = buttonWidth;
        }
        
        if ([property isEqual:WRITE])
        {
            _writeButtonCentreXConstraint.constant = centerXConstant;
            _writeButtonWidthConstraint.constant = buttonWidth;
        }
        
        if ([property isEqual:NOTIFY])
        {
            _notifyButtonCentreXConstraint.constant = centerXConstant;
            _notifyButtonWidthConstraint.constant = buttonWidth;
            
            if ([[CyCBManager sharedManager] myCharacteristic].isNotifying)
            {
                _notifyButton.selected = YES;
            }
            else
            {
                _notifyButton.selected = NO;
            }
        }
        
        if ([property isEqual:INDICATE])
        {
            _indicateButtonCentreXConstraint.constant = centerXConstant;
            _indicateButtonWidthConstraint.constant = buttonWidth;
            
            if ([[CyCBManager sharedManager] myCharacteristic].isNotifying)
            {
                _indicateButton.selected = YES;
            }
            else
            {
                _indicateButton.selected = NO;
            }
        }
        
        centerXConstant += buttonWidth;
    }
}

/*!
 *  @method checkDescriptorsForCharacteristic:
 *
 *  @discussion Method to initialize discovering descriptors for characteristic
 *
 */
-(void) checkDescriptorsForCharacteristic:(CBCharacteristic *)characteristic
{
    [[[CyCBManager sharedManager] myPeripheral] discoverDescriptorsForCharacteristic:characteristic];
}

/*!
 *  @method readButtonClicked:
 *
 *  @discussion Method to handle the read button click
 *
 */
- (IBAction)readButtonClicked:(UIButton *)sender
{
    [sender setSelected:YES];
    [[[CyCBManager sharedManager] myPeripheral] readValueForCharacteristic:[[CyCBManager sharedManager] myCharacteristic]];
    [self logButtonAction:READ_REQUEST]; // Log
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [sender setSelected:NO];
    });
}

/*!
 *  @method writeButtonClicked :
 *
 *  @discussion Method to handle the write button click
 *
 */
- (IBAction)writeButtonClicked:(UIButton *)sender
{
    /* Show hex keyboard and textfield */
    [self showHexKeyboard];
}

/*!
 *  @method showHexKeyboard
 *
 *  @discussion Method to initilaize and show the hex keyboard
 *
 */
-(void) showHexKeyboard {
//    if (!hexKeyboard) {
//        hexKeyboard = [[MRHexKeyboard alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, KEYBOARD_HEIGHT)];
//    }
//    else {
//        [hexKeyboard changeViewFrameSizeToFrame:CGRectMake(0, 0, self.view.frame.size.width, KEYBOARD_HEIGHT)];
//    }
//
//    if (!hexDialog) {
//        hexDialog = [UIAlertController alertWithTitle:LOCALIZEDSTRING(@"enterHexAlert") message:@"" delegate:self cancelButtonTitle:OPT_CANCEL otherButtonTitles:OPT_OK, nil];
//        hexDialog.tag = HEX_ALERTVIEW_TAG;
//        [hexDialog addTextFieldWithConfigurationHandler:nil];
//    }
//
//    hexDialogTextField = hexDialog.textFields[0];
//    hexDialogTextField.inputView = [hexKeyboard initWithTextField:hexDialogTextField];
//    hexDialogTextField.text = [NSString stringWithString:_hexValueTextField.text];
//    hexKeyboard.orientation = [UIDevice currentDevice].orientation;
//    hexKeyboard.isPresent = YES;
//    [self addDoneButton];
//    [hexDialog presentInParent:nil];
}

/*!
 *  @method showASCIIKeyboard
 *
 *  @discussion Method to show enter ASCII alert and related keyboard
 *
 */
-(void) showASCIIKeyboard {
    
    if (!asciiDialog) {
        asciiDialog = [UIAlertController alertWithTitle:LOCALIZEDSTRING(@"enterASCIIAlert") message:@"" delegate:self cancelButtonTitle:OPT_CANCEL otherButtonTitles:OPT_OK, nil];
        asciiDialog.tag = ASCII_ALERTVIEW_TAG;
        [asciiDialog addTextFieldWithConfigurationHandler:nil];
    }
    
    asciiDialogTextField = asciiDialog.textFields[0];
    asciiDialogTextField.text = _ASCIIValueTextField.text;
    [asciiDialog presentInParent:nil];
}

/*!
 *  @method notifyButtonClicked:
 *
 *  @discussion Method to handle notify button click
 *
 */
- (IBAction)notifyButtonClicked:(UIButton *)sender
{
    if (!sender.selected)
    {
        sender.selected = YES;
        [[[CyCBManager sharedManager] myPeripheral] setNotifyValue:YES forCharacteristic:[[CyCBManager sharedManager] myCharacteristic]];
        [self logButtonAction:START_NOTIFY];
    }
    else
    {
        sender.selected = NO;
        [[[CyCBManager sharedManager] myPeripheral] setNotifyValue:NO forCharacteristic:[[CyCBManager sharedManager] myCharacteristic]];
        [self logButtonAction:STOP_NOTIFY];
    }
}

/*!
 *  @method indicateButtonClicked:
 *
 *  @discussion Method to handle indicate button click
 *
 */
- (IBAction)indicateButtonClicked:(UIButton *)sender
{
    if (!sender.selected)
    {
        sender.selected = YES;
        [[[CyCBManager sharedManager] myPeripheral] setNotifyValue:YES forCharacteristic:[[CyCBManager sharedManager] myCharacteristic]];
        [self logButtonAction:START_INDICATE];
    }
    else
    {
        sender.selected = NO;
        [[[CyCBManager sharedManager] myPeripheral] setNotifyValue:NO forCharacteristic:[[CyCBManager sharedManager] myCharacteristic]];
        [self logButtonAction:STOP_INDICATE];
    }
}

/*!
 *  @method descriptorButtonClicked:
 *
 *  @discussion Method to handle descriptor button click
 *
 */
- (IBAction)descriptorButtonClicked:(UIButton *)sender
{
    [self performSegueWithIdentifier:DESCRIPTOR_LIST_SEGUE sender:self];
}

/*!
 *  @method updateUIWithHexValue: AndASCIIValue:
 *
 *  @discussion Method to update datafields
 *
 */
-(void) updateUIWithHexValue:(NSString *)hexValue ASCIIValue:(NSString *)ASCIIValue
{
    _hexValueTextField.text = [NSString stringWithString:hexValue];
    _ASCIIValueTextField.text = ASCIIValue;
    _dateValueLabel.text = [Utilities getTodayDateString];
    _timeValueLabel.text = [Utilities getTodayTimeString];
}

/*!
 *  @method writeCharacteristic:data:completionHandler:
 *
 *  @discussion Write data to the device
 *
 */
-(void) writeCharacteristic:(CBCharacteristic *)characteristic data:(NSData *)data completionHandler:(void(^) (BOOL success, NSError *error))handler {
    characteristicWriteCompletionHandler = handler;
    if ((characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0) {
        [[[CyCBManager sharedManager] myPeripheral] writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        characteristicWriteCompletionHandler (YES,nil);
    } else {
        [[[CyCBManager sharedManager] myPeripheral] writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    __weak __typeof(self) wself = self;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        __strong __typeof(self) sself = wself;
        if (sself) {
            if (IS_IPAD) {
                [sself initView];
//                if (sself->hexKeyboard) {
//                    if (sself->hexKeyboard.orientation == UIDeviceOrientationFaceUp  && sself->hexKeyboard.isPresent) {
//                        sself->hexKeyboard.orientation = [UIDevice currentDevice].orientation;
//                    }
//
//                    if ([UIDevice currentDevice].orientation != UIDeviceOrientationFaceUp && sself->hexKeyboard.orientation != [UIDevice currentDevice].orientation && sself->hexKeyboard.isPresent) {
//                        [sself->hexKeyboard changeViewFrameSizeToFrame:CGRectMake(0, 0, sself.view.frame.size.width, KEYBOARD_HEIGHT)];
//                        sself->hexKeyboard.orientation = [UIDevice currentDevice].orientation;
//                    }
//                }
            }
        }
    } completion:nil];
}

#pragma mark - CBCharacteristicManagerDelegate Methods

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[[CyCBManager sharedManager] myCharacteristic].UUID])
    {
        // Show descriptor button only when descriptors exist for the characteristic
        if (characteristic.descriptors.count > 0)
        {
            [[CyCBManager sharedManager] setCharacteristicDescriptors:characteristic.descriptors];
            _descriptorButton.hidden = NO;
        }
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error == nil) {
        
        if (characteristic == [[CyCBManager sharedManager] myCharacteristic])
        {
            NSData *data = [characteristic value];
            NSString *hexValue = @"";
            if (data) {
                hexValue = [data hexString];
            }
            NSString *ASCIIValue = [Utilities ASCIIStringFromData:characteristic.value];
            [self updateUIWithHexValue:hexValue ASCIIValue:ASCIIValue];
            
            if ([[CyCBManager sharedManager] myCharacteristic].isNotifying)
            {
                if (_indicateButton.selected)
                {
                    [self logOperation:INDICATE_RESPONSE forCharacteristic:characteristic withData:characteristic.value];
                }
                else if (_notifyButton.selected)
                {
                    [self logOperation:NOTIFY_RESPONSE forCharacteristic:characteristic withData:characteristic.value];
                }
            }
            else
            {
                [self logOperation:READ_RESPONSE forCharacteristic:characteristic withData:characteristic.value];
            }
        }
        else {
            if (characteristic.isNotifying) {
                [self logOperation:NOTIFY_RESPONSE forCharacteristic:characteristic withData:characteristic.value];
            }
        }
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[[CyCBManager sharedManager] myCharacteristic].UUID])
    {
        if (error == nil)
        {
            [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:[[CyCBManager sharedManager] myService].UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:[[CyCBManager sharedManager] myCharacteristic].UUID] descriptor:nil operation:[NSString stringWithFormat:@"%@- %@",WRITE_REQUEST_STATUS,WRITE_SUCCESS]];
            characteristicWriteCompletionHandler (YES,error);
        }
        else
        {
            [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:[[CyCBManager sharedManager] myService].UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:[[CyCBManager sharedManager] myCharacteristic].UUID] descriptor:nil operation:[NSString stringWithFormat:@"%@- %@%@",WRITE_REQUEST_STATUS,WRITE_ERROR,[error.userInfo objectForKey:NSLocalizedDescriptionKey]]];
            
            characteristicWriteCompletionHandler(NO,error);
        }
    }
}


-(void) writeHexValue{
    
    NSString *hexString = @"0x01";
    NSData *writeData = [Utilities dataFromHexString:[hexString undecoratedHexString]];
    
    if (writeData.length) {
        NSString *ASCIIString = [Utilities ASCIIStringFromData:writeData];
        
        // Write data to the device
        [self logOperation:WRITE_REQUEST forCharacteristic:[[CyCBManager sharedManager] myCharacteristic] withData:writeData];
        [self writeCharacteristic:[[CyCBManager sharedManager] myCharacteristic] data:writeData completionHandler:^(BOOL success, NSError *error) {
            
            if (success) {
                [self updateUIWithHexValue:hexString ASCIIValue:ASCIIString];
            } else {
                [self updateUIWithHexValue:@"" ASCIIValue:@""];
            }
        }];
    }
}

#pragma mark - AlertControllerDelegate

/*!
 *  @method alertController: clickedButtonAtIndex:
 *
 *  @discussion Method invoked when user click a button after enerting hex value
 *
 */
- (void)alertController:(nonnull UIAlertController *)alertController clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertController.tag == HEX_ALERTVIEW_TAG) {
        if (buttonIndex == alertController.firstOtherButtonIndex) { //OK button
            UITextField *textField = [[alertController textFields] objectAtIndex:0];
            
            //Apply padding with 0 if necessary
            textField.text = [textField.text decoratedHexStringLSB:YES];
            
            NSString *hexString = textField.text;
            NSData *writeData = [Utilities dataFromHexString:[hexString undecoratedHexString]];
            
            if (writeData.length) {
                NSString *ASCIIString = [Utilities ASCIIStringFromData:writeData];
                
                // Write data to the device
                [self logOperation:WRITE_REQUEST forCharacteristic:[[CyCBManager sharedManager] myCharacteristic] withData:writeData];
                [self writeCharacteristic:[[CyCBManager sharedManager] myCharacteristic] data:writeData completionHandler:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        [self updateUIWithHexValue:hexString ASCIIValue:ASCIIString];
                    } else {
                        [self updateUIWithHexValue:@"" ASCIIValue:@""];
                        [[UIAlertController alertWithTitle:APP_NAME message:[NSString stringWithFormat:@"Error occured in writing data.\n Error:%@\n Please try again.",[[error userInfo] valueForKey:NSLocalizedDescriptionKey]]] presentInParent:nil];
                    }
                }];
            }
        }
//        hexKeyboard.isPresent = NO;
    } else if (alertController.tag == ASCII_ALERTVIEW_TAG) {
        if (buttonIndex == alertController.firstOtherButtonIndex) {//OK button
            UITextField *textField = [[alertController textFields] objectAtIndex:0];
            NSString *asciiString = textField.text;
            NSString *hexString = [asciiString asciiToHex];
            NSData *writeData = [Utilities dataFromHexString:[hexString undecoratedHexString]];
            
            if (writeData.length) {
                // Write data to the device
                [self logOperation:WRITE_REQUEST forCharacteristic:[[CyCBManager sharedManager] myCharacteristic] withData:writeData];
                [self writeCharacteristic:[[CyCBManager sharedManager] myCharacteristic] data:writeData completionHandler:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        [self updateUIWithHexValue:hexString ASCIIValue:asciiString];
                    } else {
                        [self updateUIWithHexValue:@"" ASCIIValue:@""];
                        [[UIAlertController alertWithTitle:APP_NAME message:[NSString stringWithFormat:@"Error occured in writing data.\n Error:%@\n Please try again.",[[error userInfo] valueForKey:NSLocalizedDescriptionKey]]] presentInParent:nil];
                    }
                }];
            }
        }
    }
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:DESCRIPTOR_LIST_SEGUE]) {
//        GATTDBDescriptorListViewController * listVC = segue.destinationViewController;
//        listVC.serviceName = [ResourceHandler getServiceNameForUUID:[[CyCBManager sharedManager] myService].UUID];
//        listVC.characteristicName = [ResourceHandler getCharacteristicNameForUUID:[[CyCBManager sharedManager] myCharacteristic].UUID];
//    }
}

#pragma mark - Utility Methods

/*!
 *  @method addDoneButton:
 *
 *  @discussion Method to add a done button on top of the keyboard when displayed
 *
 */
- (void)addDoneButton {
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem * flexBarButton= [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(doneButtonPressed)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    hexDialogTextField.inputAccessoryView = keyboardToolbar;
}

/*!
 *  @method doneButtonPressed
 *
 *  @discussion Method to get notified when the custom done button on top of keyboard is tapped
 *
 */
- (void)doneButtonPressed {
    [hexDialogTextField resignFirstResponder];
    [self.view endEditing:YES];
}

/*!
 *  @method logButtonAction:
 *
 *  @discussion Method to log details of various operations
 *
 */
-(void) logButtonAction:(NSString *)action
{
    [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:[[CyCBManager sharedManager] myService].UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:[[CyCBManager sharedManager] myCharacteristic].UUID] descriptor:nil operation:action];
}

/*!
 *  @method logOperation: forCharacteristic: andData:
 *
 *  @discussion Method to log characteristic value
 *
 */
-(void) logOperation:(NSString *)operation forCharacteristic:(CBCharacteristic *)characteristic withData:(NSData *)data
{
    [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:characteristic.service.UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:characteristic.UUID] descriptor:nil operation:[NSString stringWithFormat:@"%@%@ %@",operation,DATA_SEPERATOR,[Utilities convertDataToLoggerFormat:data]]];
}

#pragma mark - UITextfield delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (!([[CyCBManager sharedManager] myCharacteristic].properties & CBCharacteristicPropertyWrite || [[CyCBManager sharedManager] myCharacteristic].properties & CBCharacteristicPropertyWriteWithoutResponse)) {
        return NO;
    }
    
    if (textField.tag == ASCIIT_TEXFIELD_TAG) {
        [self showASCIIKeyboard];
        return NO;
    }else if (textField.tag == HEX_TEXTFIELD_TAG) {
        [self showHexKeyboard];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return NO;
}

@end
