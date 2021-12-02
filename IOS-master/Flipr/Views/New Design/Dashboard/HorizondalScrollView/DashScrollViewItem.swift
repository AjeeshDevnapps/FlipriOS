//
//  DashScrollViewItem.swift
//  Flipr
//
//  Created by Vishnu T Vijay on 22/10/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

enum StatusType {
    case weather
    case pH
    case temperature
    case redox
}

class DashScrollViewItem: UIView {

    @IBOutlet var contenView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var valueStrings = [Double?]()
    var dates = [String?]()
    var statusType: StatusType = .weather {
        didSet {
            updateTitle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }
    
    func initSubViews() {
        let nib = UINib(nibName: "DashScrollViewItem", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contenView.frame = bounds
        addSubview(contenView)
        
        let cell = UINib(nibName: "DashCollectionViewCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: "DashCollectionViewCell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.roundCorner(corner: 12)
        collectionView.clipsToBounds = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func updateTitle() {
        var title = ""
        switch statusType {
        case .pH: title = "Taux de pH sur les 7 derniers jours"
        case .temperature: title = "Température de l'eau sur les 7 derniers jours"
        case .redox: title = "Taux de Redox sur les 7 derniers jours"
        default: title = ""
        }
        titleLabel.text = title
    }
}

extension DashScrollViewItem: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashCollectionViewCell", for: indexPath) as! DashCollectionViewCell
        cell.value.text = ""
        cell.date.text = ""
        cell.date.textColor = UIColor.init(hexString: "97A3B6")

        switch statusType {
        case .pH:
            cell.textWrappingView.layer.cornerRadius = 4
            cell.textWrappingView.layer.borderWidth = 1
            cell.textWrappingView.layer.borderColor = UIColor.init(hexString: "97A3B6").cgColor
            cell.value.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.value.textColor = UIColor.init(hexString: "97A3B6")
            if !valueStrings.isEmpty {
                cell.value.text = (valueStrings[indexPath.section] ?? 0).fixedFraction(digits: 2).toString
            }
        case .temperature:
            cell.textWrappingView.layer.cornerRadius = 4
            cell.textWrappingView.layer.borderWidth = 1
            cell.textWrappingView.layer.borderColor = UIColor.init(hexString: "97A3B6").cgColor
            cell.value.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            cell.value.textColor = UIColor.init(hexString: "28A8F5")
            if !valueStrings.isEmpty {
                cell.value.text = "\((valueStrings[indexPath.section] ?? 0).fixedFraction(digits: 0).toString)°"
            }
        case .redox:
            cell.textWrappingView.layer.cornerRadius = 4
            cell.textWrappingView.layer.borderWidth = 1
            cell.textWrappingView.layer.borderColor = UIColor.init(hexString: "97A3B6").cgColor
            cell.value.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.value.textColor = UIColor.init(hexString: "97A3B6")
            if !valueStrings.isEmpty {
                cell.value.text = (valueStrings[indexPath.section] ?? 0).fixedFraction(digits: 0).toString
            }
        default: return UICollectionViewCell()
        }
        if !dates.isEmpty {
            if let date = dates[indexPath.section] {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                if let givenDate = formatter.date(from: date) {
                    formatter.dateFormat = "dd/MM"
                    cell.date.text = formatter.string(from: givenDate)
                }
            }
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCell", for: indexPath)
            header.removeSubviews()
            if !valueStrings.isEmpty {
                let value = (valueStrings[indexPath.section] ?? 0).fixedFraction(digits: 1)
                var image: UIImage? = UIImage()
                if (indexPath.section - 1 >= 0) {
                    let previous = (valueStrings[indexPath.section - 1] ?? 0).fixedFraction(digits: 1)
                    if value > previous {
                        image = UIImage(named: "arrow-up-right (1)")
                    } else if value < previous {
                        image = UIImage(named: "arrow-up-right")
                    } else {
                        image = UIImage(named: "arrow-up-right (2)")
                    }
                }
                let imageView = UIImageView(image: image)
                var headerFrame = header.bounds
                headerFrame.size.height = collectionView.frame.height / 2
                imageView.frame = headerFrame
                imageView.contentMode = .center
                header.addSubview(imageView)
            }else{
                
            }
            return header
        default:  fatalError("Unexpected element kind")
        }
    }
}

extension DashScrollViewItem: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if statusType == .temperature {
            return CGSize(width: (self.width - 98) / 7, height: collectionView.frame.height)
        }
        return CGSize(width: (self.width - 110) / 7, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        }
        if statusType == .temperature {
            return CGSize(width: 13, height: collectionView.bounds.height)
        }
        return CGSize(width: 15, height: collectionView.bounds.height)
    }
}

