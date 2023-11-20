//
//  StripTestSecondViewController.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 16/11/23.
//

import UIKit

class StripTestSecondViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    var isPresentedFlow = false
    var recalibration = false
    var noStripTest = false
    var isAddingNewDevice = false
    var isNewFlowwithIntro = false
    var isFromExpertView = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Strip Test"
        let titleLabel = UILabel()
        titleLabel.text = "Strip Test"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 30.0, weight: .bold) // Adjust font size and weight as needed
        titleLabel.sizeToFit() // Adjust the size of the label based on its content
        
        // Create a custom view to hold the title label
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleView.addSubview(titleLabel)
        
        // Set the custom view as the titleView of the navigationItem
        navigationItem.titleView = titleView
        
        tableView.register(UINib(nibName: "StripImagwTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "StripImagwTableViewCell")
        tableView.register(UINib(nibName: "LabelTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "LabelTableViewCell")
        tableView.separatorColor = .clear

        // Do any additional setup after loading the view.
    }
    
    @IBAction func newStrip7Tabs(_ sender: UIButton) {
        let newStrip7TabController = storyboard?.instantiateViewController(withIdentifier: "NewStripViewController") as! NewStripViewController
        newStrip7TabController.numberOfRows = 7
        navigationController?.pushViewController(newStrip7TabController, animated: true)
    }
    
    @IBAction func newStrip6Tabs(_ sender: Any) {
        let newStrip7TabController = storyboard?.instantiateViewController(withIdentifier: "NewStripViewController") as! NewStripViewController
        newStrip7TabController.numberOfRows = 6
        navigationController?.pushViewController(newStrip7TabController, animated: true)

    }
    
    @IBAction func manualEntry(_ sender: UIButton) {
    }
    
}

extension StripTestSecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StripImagwTableViewCell", for: indexPath) as! StripImagwTableViewCell
            cell.cellImageView.image = UIImage(named: "StripTypeSelection")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as! LabelTableViewCell
            cell.contentLabel.text = "We've upgraded our test strips. The old version had 6 reactive tabs, while the new one has 7. To choose, simply click the corresponding button in the app."
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 120
        case 1: return UITableView.automaticDimension
        default: return 0
        }
    }
}
