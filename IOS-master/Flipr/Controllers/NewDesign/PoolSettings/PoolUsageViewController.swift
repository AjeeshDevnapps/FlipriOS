//
//  PoolUsageViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 21/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

enum PoolUsageType: Int {
    case privatePool = 1
    case publicPool = 2
}

class PoolUsageViewController: BaseViewController {

    @IBOutlet weak var verticalSpacingConstant: NSLayoutConstraint!
    @IBOutlet weak var viewSubTitleLbl: UILabel!
    @IBOutlet weak var privateVw: UIView!
    @IBOutlet weak var publicVw: UIView!
    @IBOutlet weak var privateTitleLbl: UILabel!
    @IBOutlet weak var viewTitleLbl: UILabel!
    @IBOutlet weak var checkPrivateVw: UIImageView!
    @IBOutlet weak var publicTitleLbl: UILabel!
    @IBOutlet weak var checkPublicVw: UIImageView!
    @IBOutlet weak var numberOfUserLbl: UILabel!
    @IBOutlet weak var totalNumberLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var poolBtn: UIButton!

    var selectedPoolType: PoolUsageType = .privatePool
    var totalUsers: Int = PoolSettings.shared.numberOfUsers ?? 0 {
        didSet {
            totalNumberLbl.text = "\(totalUsers)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        viewTitleLbl.text  = "Usage".localized
        poolBtn.setTitle("My pool".localized, for: .normal)
        submitBtn.setTitle("Suivant".localized, for: .normal)

        let privateTxt  = "My pool".localized  + "\n privée".localized
        let publicText  = "My pool".localized  + "\n collective".localized
        privateTitleLbl.text  = privateTxt
        publicTitleLbl.text  = publicText
        viewSubTitleLbl.text  = "Vous utilisez Flipr chez vous dans votre piscine privée".localized
        numberOfUserLbl.text  = "Nombre d’utilisateurs habituels".localized
        viewTitleLbl.text  = "Usage".localized

        
        setCustomBackbtn()
        submitBtn.roundCorner(corner: 12)
        publicVw.roundCorner(corner: 12)
        privateVw.roundCorner(corner: 12)
        checkPublicVw.roundCorner(corner: 3)
        checkPrivateVw.roundCorner(corner: 3)
        
        let tapGesturePrivate = UITapGestureRecognizer(target: self, action: #selector(tappedOnView))
        privateVw.addGestureRecognizer(tapGesturePrivate)
        
        let tapGesturePublic = UITapGestureRecognizer(target: self, action: #selector(tappedOnView))
        publicVw.addGestureRecognizer(tapGesturePublic)
        
        totalNumberLbl.text = "\(PoolSettings.shared.numberOfUsers ?? 0)"
        selectedPoolType = PoolSettings.shared.isPublic ? .publicPool : .privatePool
        updatePoolSelection()
        
        if UIScreen.main.bounds.height < 600 {
            verticalSpacingConstant.constant = 20
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tappedOnView(_ sender: UITapGestureRecognizer) {
        guard let selectedPoolTag = sender.view?.tag else { return }
        guard let selected = PoolUsageType(rawValue: selectedPoolTag) else { return }
        selectedPoolType = selected
        updatePoolSelection()
    }
    
    func updatePoolSelection() {
        if selectedPoolType == .privatePool {
            checkPrivateVw.isHidden = false
            privateVw.backgroundColor = #colorLiteral(red: 0.05167797208, green: 0.06986602396, blue: 0.1340825856, alpha: 1)
            privateTitleLbl.textColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.9998808503, alpha: 1)

            checkPublicVw.isHidden = true
            publicVw.backgroundColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.9998808503, alpha: 1)
            publicTitleLbl.textColor = #colorLiteral(red: 0.05167797208, green: 0.06986602396, blue: 0.1340825856, alpha: 1)
        } else {
            checkPrivateVw.isHidden = true
            publicVw.backgroundColor = #colorLiteral(red: 0.05167797208, green: 0.06986602396, blue: 0.1340825856, alpha: 1)
            publicTitleLbl.textColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.9998808503, alpha: 1)

            checkPublicVw.isHidden = false
            privateVw.backgroundColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.9998808503, alpha: 1)
            privateTitleLbl.textColor = #colorLiteral(red: 0.05167797208, green: 0.06986602396, blue: 0.1340825856, alpha: 1)
        }
    }
    
    @IBAction func addUser(_ sender: UIButton) {
        totalUsers += 1
    }
    
    @IBAction func reduceUser(_ sender: UIButton) {
        guard totalUsers > 0 else { return }
        totalUsers -= 1
    }
    
    @IBAction func submit(_ sender: UIButton) {
//        if totalUsers > 0{
            PoolSettings.shared.numberOfUsers = totalUsers
            PoolSettings.shared.isPublic = selectedPoolType == .publicPool
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PoolCharacteristicsViewController") as! PoolCharacteristicsViewController
        self.navigationController?.pushViewController(vc)
//        }else{
//            self.showError(title: "Error".localized, message: "Please add number of users")
//        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        goBack()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
