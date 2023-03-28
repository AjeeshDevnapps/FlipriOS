//
//  GateWayListingViewController.swift
//  Flipr
//
//  Created by Ajeesh on 27/03/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit
import Network




class GateWayListingViewController: UIViewController {
    
    var gateWays = [NWEndpoint]()

    override func viewDidLoad() {
        super.viewDidLoad()
        findFliprGatways()
        // Do any additional setup after loading the view.
    }
    

   
    func findFliprGatways(){
        
        let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
        monitor.pathUpdateHandler = { path in
            if #available(iOS 13.0, *) {
                for item in path.gateways{
                    self.gateWays.append(item)
                }
                print(path.gateways)
            } else {
                // Fallback on earlier versions
            }
        }
        monitor.start(queue: DispatchQueue(label: "nwpathmonitor.queue"))
        
    }
    

}
