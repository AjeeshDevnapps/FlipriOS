//
//  NewDashboardViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 14/06/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class NewDashboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var otherTableCellHeights:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}


extension NewDashboardViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 84
        }
        
        if indexPath.row == 1 {
            return 100
        }
        else if indexPath.row == 2 {
            let viewHeight = self.view.frame.height
            otherTableCellHeights = 184
            var waveCellHeight = viewHeight - (otherTableCellHeights + 72)
            if waveCellHeight < 500{
                waveCellHeight = 500
            }else{
                
            }
            return waveCellHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier:"WeatherCell",
                                                     for: indexPath)
            return cell

        }
        
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier:"TempInfoCell",
                                                     for: indexPath)
            return cell

        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"WaveTableViewCell",
                                                     for: indexPath) as! WaveTableViewCell
            return cell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    @IBAction func alertsActivationSwitchValueChanged(_ sender: UISwitch) {
        
    }
    
    
}
