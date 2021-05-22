//
//  PoolLocationViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 21/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import JGProgressHUD

class PoolLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var placeListTblVw: UITableView!
    @IBOutlet weak var useCurrentBtn: UIButton!
    @IBOutlet weak var searchTF: CustomTextField!
    @IBOutlet weak var viewTItleLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var poolSelectionSgmntCtrl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myPoolBtn: UIButton!
    
    let locationManager = CLLocationManager()
    var matchingItems:[MKMapItem] = []
    var locations:[Location] = []
    var selectedCity: City?
    var completionBlock:(_: (_ value:City,_ latitude:Double?,_ longitude: Double?) -> Void)?
    var poolLocationValues = [FormValue]()

    func completion(block: @escaping (_ value:City,_ latitude:Double?,_ longitude: Double?) -> Void) {
        completionBlock = block
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        setCustomBackbtn()
        mapView.bringSubviewToFront(poolSelectionSgmntCtrl)
        mapView.bringSubviewToFront(searchTF)
        mapView.bringSubviewToFront(placeListTblVw)
        mapView.bringSubviewToFront(useCurrentBtn)
        mapView.delegate = self
        mapView.mapType = .satellite
        mapView.roundCorner(corner: 12)
        mapView.layer.masksToBounds = true
        searchTF.externalDelegate = self
        let img = UIImage(named: "map-pin")
//        searchTF.addPaddingLeftButton(target: self, img!, padding: 30, action: #selector(mapIconClickTF))
//        searchTF.editRectLeftPadding = 40
        searchTF.becomeFirstResponder()
        searchTF.placeholder = "Search a city...".localized
        searchTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        useCurrentBtn.roundCorner(corner: 5)
        if let location = Location.flipr() {
            searchTF.text = location.locality
        }
        submitBtn.roundCorner(corner: 12)
        poolSelectionSgmntCtrl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: UIControl.State.selected)
        poolSelectionSgmntCtrl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: UIControl.State.normal)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        placeListTblVw.layer.cornerRadius = 12
        placeListTblVw.layer.masksToBounds = true
        if #available(iOS 11.0, *) {
            placeListTblVw.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap(gestureRecognizer:)))
            gestureRecognizer.delegate = self
            mapView.addGestureRecognizer(gestureRecognizer)
        
        if let currentPosition = PoolSettings.shared.situation {
            poolSelectionSgmntCtrl.selectedSegmentIndex = currentPosition.id == 2 ? 0 : 1
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view != self.searchTF && touch.view != poolSelectionSgmntCtrl && touch.view != submitBtn && touch.view != useCurrentBtn && placeListTblVw.isHidden else { return false }
        return true
    }
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        self.annotateInLoc(location: coordinate)
        let geocoder = CLGeocoder()
        let locationDetails = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(locationDetails) { (placemarks, error) in
            if let places = placemarks {
                if let locality = places.first?.locality {
                    self.searchTF.text = locality
                }
            }
        }
    }
    
    @objc func mapIconClickTF() {
        
    }
    
    @objc func textFieldDidChange() {
        if (searchTF.text?.count ?? 0) >= 3 {
            guard let searchBarText = searchTF.text else { return }
            self.searchAndDisplayAddresses(searchBarText)
        } else {
            locations.removeAll()
            placeListTblVw.reloadData()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "Union")
        }
        
        return annotationView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isHidden = locations.count == 0
        return locations.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        let location = self.locations[indexPath.row]
       
        cell.textLabel?.text = location.locality + ", " + location.administrativeArea
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if locations.count > 0 {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            let location = locations[indexPath.row]
//            location.saveAsFlipr()
            searchTF.resignFirstResponder()
            tableView.isHidden = true
//            navigationController?.popViewController(animated: true)
            //NotificationCenter.default.post(name: FliprLocationDidChange, object: nil)
            
            let city = City.init(name: location.locality, latitude: location.latitude, longitude: location.longitude)
            if let code = location.placeMark?.isoCountryCode {
                city.countryCode = code
            }
            if let code = location.placeMark?.postalCode {
                city.zipCode = code
            }
            self.selectedCity = city
            
            let selectedLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            self.annotateInLoc(location: selectedLocation)
            searchTF.text = location.locality
//            let viewRegion = MKCoordinateRegion(center: selectedLocation, latitudinalMeters: 500, longitudinalMeters: 500)
//            mapView.setRegion(viewRegion, animated: false)
            mapView.showsUserLocation = true
            self.completionBlock?(city,nil,nil)
        }
    }
    
    func annotateInLoc(location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        let selectedLocation = location
        annotation.coordinate = selectedLocation
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(mapView.annotations, animated: true)
        
        let viewRegion = MKCoordinateRegion(center: selectedLocation, span: mapView.region.span)
        self.mapView.setRegion(viewRegion, animated: true)
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
                        self.completionBlock?(city,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude)
                        
                        let location = Location()
                        location.locality = locality
                        location.administrativeArea = administrativeArea
                        location.latitude = (placeMark.location?.coordinate.latitude)!
                        location.longitude = (placeMark.location?.coordinate.longitude)!
//                        location.saveAsFlipr()
                        let annotation = MKPointAnnotation()

                        let currentLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                        annotation.coordinate = currentLocation
                        self.mapView.removeAnnotations(self.mapView.annotations)
                        self.mapView.addAnnotation(annotation)
                        
                        self.searchTF.text = placeMark.locality
                        self.searchTF.resignFirstResponder()
                        let viewRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 500, longitudinalMeters: 500)
                        self.mapView.setRegion(viewRegion, animated: false)
                        self.mapView.showsUserLocation = true

//                        self.navigationController?.popViewController(animated: true)
                        //NotificationCenter.default.post(name: FliprLocationDidChange, object: nil)
                        
                    } else {
                        print("Wrong address")
                    }
                }
            }
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

                self.placeListTblVw.reloadData()
                
            })
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        goBack()
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        PoolSettings.shared.city = self.selectedCity
        let formValue: FormValue?
        if poolSelectionSgmntCtrl.selectedSegmentIndex == 0 {
            formValue = FormValue(id: 2, label: poolSelectionSgmntCtrl.titleForSegment(at: 0) ?? "Outdoor")
        } else {
            formValue = FormValue(id: 1, label: poolSelectionSgmntCtrl.titleForSegment(at: 1) ?? "Indoor")
        }
        PoolSettings.shared.situation = formValue
    }
    
    @IBAction func useCurrentLocation(_ sender: UIButton) {
        useCurrentLocation()
    }
    
    @IBAction func poolTypeChanged(_ sender: UISegmentedControl) {
    }
    
    
    func getPoolLocations() {
        let hud = JGProgressHUD(style:.dark)
        hud?.show(in: self.navigationController!.view)
        Alamofire.request(Router.getFormValues(apiPath: "locations")).validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
            hud?.dismiss()
            switch response.result {
                
            case .success(let value):
                
                print(value)
                
                if let JSON = value as? [[String:Any]] {
                    print("JSON: \(JSON)")
                    
                    var formValues = [FormValue]()
                    
                    for value in JSON {
                        if let formValue = FormValue.init(withJSON: value) {
                            formValues.append(formValue)
                        }
                    }
                    let outdoorIndex = formValues.firstIndex(where: {$0.id == 2})
                    let indoorIndex = formValues.firstIndex(where: {$0.id == 1})
                    self.poolLocationValues.append(contentsOf: [formValues[outdoorIndex ?? 2], formValues[indoorIndex ?? 1]])
//
//                    self.poolSelectionSgmntCtrl.setTitle(formValues[outdoorIndex ?? 2].label, forSegmentAt: 0)
//                    self.poolSelectionSgmntCtrl.setTitle(formValues[indoorIndex ?? 1].label, forSegmentAt: 1)
//
//                    if let current = PoolSettings.shared.situation {
//                        self.poolSelectionSgmntCtrl.selectedSegmentIndex = self.poolLocationValues.firstIndex(where: { $0.id == current.id}) ?? 0
//                    }

                }
                
            case .failure(let error):
                
                if let serverError = User.serverError(response: response) {
                    print(serverError.localizedDescription)
                } else {
                    print(error.localizedDescription)
                }
            }
            
        })
    }
}
