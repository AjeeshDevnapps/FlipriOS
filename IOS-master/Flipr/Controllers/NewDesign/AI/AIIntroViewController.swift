//
//  AIIntroViewController.swift
//  Flipr
//
//  Created by Ajeesh on 29/06/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

class AIIntroViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 44.0;

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
  
}

extension AIIntroViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AITnCableViewCell") as! AITnCableViewCell
        //        let network = networks[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
        
}
