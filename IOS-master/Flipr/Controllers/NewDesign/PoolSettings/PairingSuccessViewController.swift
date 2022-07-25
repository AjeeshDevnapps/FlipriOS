//
//  PairingSuccessViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 21/04/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class PairingSuccessViewController: BaseViewController {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewTitleLbl: UILabel!
    @IBOutlet weak var viewSubTitleLbl: UILabel!
    @IBOutlet weak var submitBtb: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9476600289, green: 0.9772188067, blue: 0.9940286279, alpha: 1)
        imgView.roundCorner(corner: 12)
        submitBtb.roundCorner(corner: 12)
        setCustomBackbtn()
        viewTitleLbl.text = "Félicitations, Flipr Start est prêt !".localized
        viewSubTitleLbl.text = "Vous pouvez accédez à vos analyses et profitez d’une belle piscine, l’esprit tranquille.".localized
        submitBtb.setTitle("C’est parti !".localized, for: .normal)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func submit(_ sender: UIButton) {
        showDashboard()
        /*
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        let dashboard = mainSB.instantiateViewController(withIdentifier: "DashboardViewControllerID")
        dashboard.modalTransitionStyle = .flipHorizontal
        dashboard.modalPresentationStyle = .fullScreen
        self.present(dashboard, animated: true, completion: {
        })
        */
    }
    
    func showDashboard(){
        let theme = EmptyStateViewTheme.shared
        theme.activityIndicatorType = .ballZigZag
        self.view.showEmptyStateViewLoading(title: "Launch of the 1st measure".localized, message: "Connecting to flipr...".localized, theme: theme)
        
        BLEManager.shared.startMeasure { (error) in
            
            BLEManager.shared.doAcq = false
            
            if error != nil {
                self.showError(title: "Error".localized, message: error?.localizedDescription)
                self.view.hideStateView()
            }
            self.showIntialDashBoard()
        }
    }
    
    
    func showIntialDashBoard(){
        UserDefaults.standard.set(Date(), forKey:"FirstMeasureStartDate")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboard = storyboard.instantiateViewController(withIdentifier: "DashboardViewControllerID")
        dashboard.modalTransitionStyle = .flipHorizontal
        dashboard.modalPresentationStyle = .fullScreen
        self.present(dashboard, animated: true, completion: {
            self.navigationController?.popToRootViewController(animated: false)
        })
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        goBack()
    }
}
