//
//  NewPoolLocationViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 29/08/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import UIKit
import MapKit

class NewPoolLocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    var matchingItems:[MKMapItem] = []
    var locations:[Location] = []
    var selectedCity: City?
    var completionBlock:(_: (_ value:City,_ latitude:Double?,_ longitude: Double?) -> Void)?
    func completion(block: @escaping (_ value:City,_ latitude:Double?,_ longitude: Double?) -> Void) {
        completionBlock = block
    }
    let locationManager = CLLocationManager()
    var isSelectedLocation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = UIColor(hexString: "#EFEFEF")
        tableView.backgroundColor = .clear
        if AppSharedData.sharedInstance.isAddPlaceFlow{
//            self.navigationItem.setHidesBackButton(true, animated: true)
            self.submitButton.isHidden = false
        }else{
            self.submitButton.isHidden = true
            setCustomBackbtn()
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.submitButton.isHidden = true

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func valueChanged(_ sender: UITextField) {
        if (textField.text?.count ?? 0) >= 3 {
            guard let searchBarText = textField.text else { return }
            self.searchAndDisplayAddresses(searchBarText)
        } else {
            locations.removeAll()
            tableView.reloadData()
        }
    }
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        if AppSharedData.sharedInstance.isAddPlaceFlow{
            if self.selectedCity != nil{
                let listVC = self.storyboard?.instantiateViewController(withIdentifier: "WatrInputViewController") as! WatrInputViewController
                listVC.order = 0
                listVC.title = NewPoolTitles.Characteristics.Volume.rawValue
                navigationController?.pushViewController(listVC, animated: true)
            }
        }else{
            
        }
        
    }
    
    
    func showLocationSelectionVC(){
        let sb = UIStoryboard(name: "NewPool", bundle: nil)
        if let locationVC = sb.instantiateViewController(withIdentifier: "NewPoolLocationViewController") as? NewPoolLocationViewController {
            locationVC.title = "Location".localized
            navigationController?.pushViewController(locationVC)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            useCurrentLocation()
        }
    }
    
    func useCurrentLocation() {
        
        if let currentLocation = locationManager.location {
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) -> Void in
                
                if error != nil {
                    print("Error getting location: \(error)")
                } else {
                    let placeArray = placemarks as [CLPlacemark]!
                    var placeMark: CLPlacemark!
                    placeMark = placeArray?[0]
                    
                    if let locality = placeMark.locality, let administrativeArea = placeMark.administrativeArea {
                        
                        let city = City.init(name: locality, latitude: (placeMark.location?.coordinate.latitude)!, longitude: (placeMark.location?.coordinate.longitude)!)
                        if let code = placeMark.isoCountryCode {
                            city.countryCode = code
                        }
                        if let code = placeMark.postalCode {
                            city.zipCode = code
                        }
                        self.selectedCity = city
                        if AppSharedData.sharedInstance.isAddPlaceFlow{
                            AppSharedData.sharedInstance.addPlaceInfo.latitude = currentLocation.coordinate.latitude
                            AppSharedData.sharedInstance.addPlaceInfo.longitude = currentLocation.coordinate.longitude
                            AppSharedData.sharedInstance.addPlaceInfo.city = city
                            if self.isSelectedLocation{
                                self.submitAction(self.submitButton)
                            }

                        }else{
                            self.completionBlock?(city,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude)
                        }
                        
                        let location = Location()
                        location.locality = locality
                        location.administrativeArea = administrativeArea
                        location.latitude = (placeMark.location?.coordinate.latitude)!
                        location.longitude = (placeMark.location?.coordinate.longitude)!
//                        location.saveAsFlipr()
                        let annotation = MKPointAnnotation()

                        let currentLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                        annotation.coordinate = currentLocation
                        
                        self.textField.text = placeMark.locality
                        self.textField.resignFirstResponder()

//                        self.navigationController?.popViewController(animated: true)
                        //NotificationCenter.default.post(name: FliprLocationDidChange, object: nil)
                        
                    } else {
                        print("Wrong address")
                    }
                }
            }
        }
    }
    
    @objc func textFieldDidChange() {
    }
    
    func searchAndDisplayAddresses(_ searchText: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            print("response.mapItems: \(response.mapItems)")
            self.matchingItems = response.mapItems
            self.locations.removeAll()
            for item in response.mapItems {
                if let locality = item.placemark.locality, let administrativeArea = item.placemark.administrativeArea {
                    let location = Location()
                    location.locality = locality
                    location.administrativeArea = administrativeArea
                    location.latitude = item.placemark.coordinate.latitude
                    location.longitude = item.placemark.coordinate.longitude
                    location.placeMark = item.placemark
                    print("Ahahahah => item.placemark.postalCode: \(item.placemark.postalCode)")
                    var notIn = true
                    for inLocation in self.locations {
                        if inLocation.locality == locality && inLocation.administrativeArea == administrativeArea {
                            notIn = false
                        }
                    }
                    if notIn { self.locations.append(location) }
                }
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
}


extension NewPoolLocationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return locations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentLocationCell")
            
            if #available(iOS 14.0, *) {
                var content = cell?.defaultContentConfiguration()
                content?.image = UIImage(systemName: "location")
                content?.text = "Utiliser le position actuelle".localized
                content?.textProperties.color = UIColor.init(hexString: "56A4C3")
                content?.imageProperties.tintColor = UIColor.init(hexString: "56A4C3")
                cell?.textLabel?.textAlignment = .center
                cell?.contentConfiguration = content
                cell?.contentView.backgroundColor = UIColor.init(hexString: "EFEFEF")
            } else {
                // Fallback on earlier versions
                cell?.imageView?.image = UIImage(named: "location")
                cell?.textLabel?.text = "Utiliser le position actuelle".localized
                cell?.textLabel?.textColor = UIColor.init(hexString: "56A4C3")
                cell?.imageView?.tintColor = UIColor.init(hexString: "56A4C3")
                cell?.textLabel?.textAlignment = .center
                cell?.contentView.backgroundColor = UIColor.init(hexString: "EFEFEF")
            }
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")
            cell?.textLabel?.text = locations[indexPath.row].locality
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.textColor = UIColor.init(hexString: "254156")

            return cell!
        }
    }
}


extension NewPoolLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0{
//
//        }
//        else {
            if indexPath.section == 0 {
                self.isSelectedLocation = true
                useCurrentLocation()
            }else{
                let city = City(name: locations[indexPath.row].locality, latitude: (locations[indexPath.row].latitude), longitude: (locations[indexPath.row].longitude))
                if let code = locations[indexPath.row].placeMark?.isoCountryCode {
                    city.countryCode = code
                }
                if let code = locations[indexPath.row].placeMark?.postalCode {
                    city.zipCode = code
                }
                self.selectedCity = city
                textField.text = locations[indexPath.row].locality
                
                if AppSharedData.sharedInstance.isAddPlaceFlow{
                    AppSharedData.sharedInstance.addPlaceInfo.latitude = city.latitude
                    AppSharedData.sharedInstance.addPlaceInfo.longitude = city.longitude
                    AppSharedData.sharedInstance.addPlaceInfo.city = city
                    self.submitAction(self.submitButton)
                }else{
                    self.completionBlock?(city,locations[indexPath.row].latitude,locations[indexPath.row].longitude)
                }
            }
           
        }
//    }
}
