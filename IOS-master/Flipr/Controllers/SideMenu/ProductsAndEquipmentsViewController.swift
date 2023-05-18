//
//  ProductsAndEquipmentsViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 16/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit


extension UISegmentedControl
{
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.white)
    {
        let defaultAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }

    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 12), color: UIColor = UIColor.red)
    {
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}


class ProductsAndEquipmentsViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    let eqpsVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "EquipmentTableViewController") as! EquipmentTableViewController
    let prodVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "ProductTableViewControllerID") as! ProductTableViewController
    let leftButton = UIButton(type: UIButton.ButtonType.custom)
    let rightButton = UIButton(type: UIButton.ButtonType.custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        // Do any additional setup after loading the view.
    }
    

    func setupView(){
        
        segmentControl.setTitle("Products".localized, forSegmentAt: 0)
        segmentControl.setTitle("Equipments".localized, forSegmentAt: 1)

        
        let navigationBar = navigationController?.navigationBar
        navigationBar?.shadowColor = .clear
        segmentControl.addTarget(self, action: #selector(ProductsAndEquipmentsViewController.indexChanged(_:)), for: .valueChanged)
        segmentControl.defaultConfiguration(font: UIFont.boldSystemFont(ofSize: 17), color: UIColor.white)
        segmentControl.selectedConfiguration(font: UIFont.boldSystemFont(ofSize: 17), color: UIColor.white)
        eqpsVC.view.frame = self.containerView.bounds
        self.containerView.addSubview(eqpsVC.view)
        prodVC.view.frame = self.containerView.bounds
        self.containerView.addSubview(prodVC.view)
        self.addLeftBarButton()
        self.addRightBarButton()

        
//         let prodVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "ProductTableViewControllerID") as? ProductTableViewController
//        {
////            vc.selection = true
////            vc.delegate = self
////            navigationController?.show(vc, sender: self)
//        }


    }
    
    
    func addLeftBarButton(){
        if segmentControl.selectedSegmentIndex == 0 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftBarButtonTapped))

        }else{
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftBarButtonTapped))
//            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(leftBarButtonTapped))
        }
    }
    
    func addRightBarButton(){
        if segmentControl.selectedSegmentIndex == 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonTapped))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "".localized, style: .plain, target: self, action: #selector(rightBarButtonTapped))
        }
    }
    
    
    @objc func leftBarButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func rightBarButtonTapped(){
        if segmentControl.selectedSegmentIndex == 0 {
            prodVC.addProduct()
        }else{
            eqpsVC.save()
        }
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
    
        if segmentControl.selectedSegmentIndex == 0 {
            self.containerView.bringSubviewToFront(self.prodVC.view)
            self.addLeftBarButton()
            self.addRightBarButton()
//            self.title = "Leaves"
        } else{
            self.containerView.bringSubviewToFront(self.eqpsVC.view)
            self.addLeftBarButton()
            self.addRightBarButton()

//            self.title = "Regularization"
        }
    }
   

}
