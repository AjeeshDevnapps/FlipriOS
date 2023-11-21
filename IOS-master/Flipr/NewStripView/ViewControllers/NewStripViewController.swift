//
//  ViewController.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 11/11/23.
//

import UIKit
import JGProgressHUD

class NewStripViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var colors: [Color]?
    var numberOfRows = 7
    var strip = Strip()
    var recalibration = false
    var isPresentView = false
    var isFromExpertView = false
    var isNewFlowwithIntro = false

    

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .systemGray5
        tableView.backgroundColor = .clear
        colors = loadColorsFromJSONFile()
        tableView.register(UINib(nibName: "LabelTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "LabelTableViewCell")
        tableView.separatorColor = .clear
        let titleLabel = UILabel()
        titleLabel.text = numberOfRows == 7 ? "Strip7" : "Strip6"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 30.0, weight: .bold) // Adjust font size and weight as needed
        titleLabel.sizeToFit() // Adjust the size of the label based on its content
        
        // Create a custom view to hold the title label
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleView.addSubview(titleLabel)
        
        // Set the custom view as the titleView of the navigationItem
        navigationItem.titleView = titleView

    }

    func loadColorsFromJSONFile() -> [Color]? {
        // Get the path to the JSON file
        let filename =  numberOfRows == 7 ? "Colors" : "Colors6"
        
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
            print("Unable to find Colors.json")
            return nil
        }

        // Read the content of the file
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            
            // Decode JSON data into an array of Color objects
            let decoder = JSONDecoder()
            let colorBase = try decoder.decode(ColorBase.self, from: data)
            
            return colorBase.colors
        } catch {
            print("Error loading JSON data: \(error)")
            return nil
        }
    }
}

extension NewStripViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell") as! LabelTableViewCell
            cell.contentLabel.text = "4427:66027".localized
            cell.contentImage.image = UIImage(named: "handIcon")
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell") as! LabelTableViewCell
            cell.contentLabel.text = "4427:66439".localized
            cell.contentImage.image = UIImage(named: "sun")

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StripTableViewCell") as! StripTableViewCell
            cell.backgroundColor = .clear
            cell.stripView.delegate = self
            cell.stripView.numberOfRows = numberOfRows
            if let colors = colors {
                cell.stripView.allColors = colors
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return UITableView.automaticDimension
        case 1: return UITableView.automaticDimension
        case 2: return 450
        default: return 0
        }
    }
}

extension NewStripViewController: StripsViewDelegate {
   
    func selectedStripColors(stripView: StripsView, colors: [Color?],selectedItemsOrder: [Int: Int]) {
        
        for (key,value) in selectedItemsOrder {
            print("\(key) = \(value)")
            if key == 0{
                strip.hydrotimetricTitle = Double(value + 1)
            }
            if key == 1{
                strip.totalChlore = Double(value + 1)
            }
            if key == 2{
                strip.chloreBrome = Double(value + 1)
            }
            if key == 3{
                strip.pH = Double(value + 1)
            }
            if key == 4{
                strip.alcalinity = Double(value + 1)
            }
            if key == 5{
                strip.cyanudricAcid = Double(value + 1)
            }
            if key == 6{
                strip.totalBr = Double(value + 1)
            }
        }
        
        
       
//        print(colors)
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.view)

        self.strip.send(completion: { (error) in
            if error != nil {
                if error?.code == 401 {
                    hud?.dismiss(afterDelay: 0)
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    hud?.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud?.textLabel.text = error?.localizedDescription
                    hud?.dismiss(afterDelay: 3)
                }
            } else {
                NotificationCenter.default.post(name: K.Notifications.PlaceCreated, object: nil)
                hud?.dismiss(afterDelay: 3)
                if self.recalibration {
                    NotificationCenter.default.post(name: FliprLogDidChanged, object: nil)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showGWInfoView()
//                        self.showFliprSuccessScreen()
//                        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StartViewControllerID") {
//                            self.navigationController?.pushViewController(viewController, animated: true)
//                        }
                }
                
            }
            
//            self.doneButton.hideActivityIndicator()
//                self.doneButtonWidthConstraint.constant = 200
//                UIView.animate(withDuration: 0.25, animations: {
//                    self.view.layoutIfNeeded()
//                })
        })
    }
    
    func showGWInfoView(){
        if isFromExpertView{
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            if AppSharedData.sharedInstance.isFlipr3{
                showGatewaySetup()
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let dashboard = storyboard.instantiateViewController(withIdentifier: "DashboardViewControllerID")
                dashboard.modalTransitionStyle = .flipHorizontal
                dashboard.modalPresentationStyle = .fullScreen
                self.present(dashboard, animated: true, completion: {
                    self.navigationController?.popToRootViewController(animated: false)
                })
            }
        }
        
   
    }
    
    func showGatewaySetup(){
        let storyboard = UIStoryboard(name: "FliprDevice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddGatewayIntroViewController") as! AddGatewayIntroViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
