//
//  NewPoolSimpleListViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 29/08/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit
import MapKit

class NewPoolSimpleListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var isTextField = false
    var inputType: UIKeyboardType = .numberPad
    var listItems = [String]()
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#eeeee4")
        tableView.backgroundColor = .clear
        setCustomBackbtn()
    }
    
    override func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
//    func searchAndDisplayAddresses(_ searchText: String) {
//        
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = searchText
//        let search = MKLocalSearch(request: request)
//        search.start { response, _ in
//            guard let response = response else {
//                return
//            }
//            print("response.mapItems: \(response.mapItems)")
//            self.matchingItems = response.mapItems
//            
//            self.locations.removeAll()
//            
//            for item in response.mapItems {
//                if let locality = item.placemark.locality, let administrativeArea = item.placemark.administrativeArea {
//                    
//                    let location = Location()
//                    location.locality = locality
//                    location.administrativeArea = administrativeArea
//                    location.latitude = item.placemark.coordinate.latitude
//                    location.longitude = item.placemark.coordinate.longitude
//                    location.placeMark = item.placemark
//                    
//                    print("Ahahahah => item.placemark.postalCode: \(item.placemark.postalCode)")
//                    
//                    var notIn = true
//                    for inLocation in self.locations {
//                        if inLocation.locality == locality && inLocation.administrativeArea == administrativeArea {
//                            notIn = false
//                        }
//                    }
//                    if notIn { self.locations.append(location) }
//                }
//            }
//            
//            DispatchQueue.main.async(execute: { () -> Void in
//
////                self.placeListTblVw.reloadData()
//                
//            })
//        }
//    }
}

extension NewPoolSimpleListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isTextField {
            return 1
        }
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isTextField {
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewPoolTextFieldTableViewCell", for: indexPath) as! NewPoolTextFieldTableViewCell
            tableViewCell.inputType = self.inputType
            return tableViewCell
        } else {
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewPoolSimpleListViewControllerCell", for: indexPath)
            
            if #available(iOS 14.0, *) {
                var content = tableViewCell.defaultContentConfiguration()
                
                content.text = listItems[indexPath.row]
                
                content.prefersSideBySideTextAndSecondaryText = true
                content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 16)
                tableViewCell.contentConfiguration = content
            } else {
                tableViewCell.textLabel?.text = listItems[indexPath.row]
            }
            
            tableViewCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
            if indexPath.row == selectedIndex {
                tableViewCell.accessoryView = UIImageView(image: UIImage(named: "check_icon1"))
            } else {
                tableViewCell.accessoryView = nil
            }
            return tableViewCell
        }
    }
}

extension NewPoolSimpleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isTextField {
            selectedIndex = indexPath.row
            tableView.reloadData()
        }
    }
}