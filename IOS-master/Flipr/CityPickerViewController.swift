//
//  CityPickerViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 22/03/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit
import MapKit

class Location {
    var locality = ""
    var administrativeArea = ""
    var latitude = 0.0
    var longitude = 0.0
    var placeMark:CLPlacemark?
    
    static func flipr() -> Location? {
        if let serializedLocation = UserDefaults.standard.object(forKey: "flipr_location") as? [String : Any] {
            let location = Location()
            location.locality = serializedLocation["locality"] as! String
            location.administrativeArea = serializedLocation["administrativeArea"] as! String
            location.latitude = serializedLocation["latitude"] as! Double
            location.longitude = serializedLocation["longitude"] as! Double
            return location
        }
        return nil
    }
    
    func saveAsFlipr() {
        UserDefaults.standard.set(["locality":locality,"administrativeArea":administrativeArea,"latitude":latitude,"longitude":longitude], forKey: "flipr_location")
    }
}

class CityPickerViewController: UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var matchingItems:[MKMapItem] = []
    var locations:[Location] = []
    
    var completionBlock:(_: (_ value:City,_ latitude:Double?,_ longitude: Double?) -> Void)?
    
    func completion(block: @escaping (_ value:City,_ latitude:Double?,_ longitude: Double?) -> Void) {
        completionBlock = block
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchBar.becomeFirstResponder()
        searchBar.placeholder = "Search a city...".localized
        
        if let location = Location.flipr() {
            searchBar.text = location.locality
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return locations.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserLocationCell", for: indexPath)
            if let label = cell.viewWithTag(2) as? UILabel {
                label.textColor = self.view.tintColor
                label.text = "Use current location".localized
            }
            if let icon = cell.viewWithTag(1) as? UIImageView {
                icon.tintColor = self.view.tintColor;
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let location = self.locations[indexPath.row]
       
        cell.textLabel?.text = location.locality + ", " + location.administrativeArea
 
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            useCurrentLocation()
        } else {
            if locations.count>0 {
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = .checkmark
                let location = locations[indexPath.row]
                location.saveAsFlipr()
                searchBar.resignFirstResponder()
                navigationController?.popViewController(animated: true)
                //NotificationCenter.default.post(name: FliprLocationDidChange, object: nil)
                
                let city = City.init(name: location.locality, latitude: location.latitude, longitude: location.longitude)
                if let code = location.placeMark?.isoCountryCode {
                    city.countryCode = code
                }
                if let code = location.placeMark?.postalCode {
                    city.zipCode = code
                }
                self.completionBlock?(city,nil,nil)
            }
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
                        self.completionBlock?(city,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude)
                        
                        let location = Location()
                        location.locality = locality
                        location.administrativeArea = administrativeArea
                        location.latitude = (placeMark.location?.coordinate.latitude)!
                        location.longitude = (placeMark.location?.coordinate.longitude)!
                        location.saveAsFlipr()
                        
                        self.searchBar.text = placeMark.locality
                        self.searchBar.resignFirstResponder()
                        self.navigationController?.popViewController(animated: true)
                        //NotificationCenter.default.post(name: FliprLocationDidChange, object: nil)
                        
                    } else {
                        print("Wrong address")
                    }
                }
            }
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count >= 3 {
            guard
                let searchBarText = searchBar.text else { return }
            self.searchAndDisplayAddresses(searchBarText)
        } else {
            locations.removeAll()
            tableView.reloadData()
        }
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
