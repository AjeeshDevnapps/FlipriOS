//
//  OnboardingCollectionViewCell.swift
//  Flipr
//
//  Created by Ajeesh T S on 27/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    var page: Int = 0 {
        didSet {
            changeView()
        }
    }
    
    
    func changeView() {
        var imageName: String
        var titleString: String
        var subTitle: String
        switch page {
        case 0:
            imageName = "Hub-Onboarding-Step-4".localized
            titleString = "Flipr Smart Control".localized
            subTitle = "Mettez votre piscine à la pointe de la technologie. Grâce à l'intelligence artificielle, et à sa connexion avec le Flipr Start, Flipr Hub s'occupe de tout.".localized
        case 1:
            imageName = "Hub-Onboarding-Step-1".localized
            titleString = "Allumez et éteignez vos équipements comme bon vous semble.".localized
            subTitle = "Passez facilement du mode manuel au mode programmation sans avoir à modifier quoi que ce soit sur vos équipements.".localized
        case 2:
            imageName = "Hub-Onboarding-Step-2".localized
            titleString = "Programmez chaque équipement".localized
            subTitle = "Vous pouvez les modifier à tout moment, en fonction des conseils de Flipr Hub.".localized
        case 3:
            imageName = "Hub-Onboarding-Step-3".localized
            titleString = "Contrôlez votre piscine à distance".localized
            subTitle = "Même à l’autre bout du monde, contrôlez votre piscine depuis l’application grâce au Wi-Fi.".localized

        default:
            imageName = "Hub-Onboarding-Step-2".localized
            titleString = "Contrôlez votre piscine à distance".localized
            subTitle = "Même à l’autre bout du monde, contrôlez votre piscine depuis l’application grâce au Wi-Fi.".localized

        }
        imageView.image = UIImage(named: imageName)
        titleLabel.text = titleString
        subTitleLabel.text = subTitle
    }
}
