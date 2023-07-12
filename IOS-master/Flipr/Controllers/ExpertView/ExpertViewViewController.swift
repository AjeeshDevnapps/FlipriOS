//
//  ExpertViewViewController.swift
//  Flipr
//
//  Created by Ajish on 12/07/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

enum ExpertViewCellOrder: Int{
    case infoCell
    case calibration
    case stripTest
    case trend
    case threshold
}

class ExpertViewViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var cellOrder = [ExpertViewCellOrder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createOrder()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
//        tableView.contentInset =  UIEdgeInsets.init(top: 64, left: 0, bottom: 0, right: 0)
//        tableView.scrollIndicatorInsets = UIEdgeInsets.init(top: 54, left: 0, bottom: 0, right: 0)

        // Do any additional setup after loading the view.
    }
    
    
    func createOrder(){
        cellOrder.append(.infoCell)
        cellOrder.append(.calibration)

    }
}


extension ExpertViewViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellOrder.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch (cellOrder[indexPath.row]) {
            case .infoCell:
            let cell =  tableView.dequeueReusableCell(withIdentifier:"ExpertviewInfoTableViewCell",
                                                      for: indexPath) as! ExpertviewInfoTableViewCell
            return cell
            
            case .calibration:
            let cell =  tableView.dequeueReusableCell(withIdentifier:"ExpertviewCalibrationInfoTableViewCell",
                                                  for: indexPath) as! ExpertviewCalibrationInfoTableViewCell
            return cell

        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier:"ExpertviewInfoTableViewCell",
                                                      for: indexPath) as! ExpertviewInfoTableViewCell
            return cell

        }
        
      
        
    }
    
}
