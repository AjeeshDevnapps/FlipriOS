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
        switch statusType {
        case .pH:
            cell.textWrappingView.layer.cornerRadius = 4
            cell.textWrappingView.layer.borderWidth = 1
            cell.textWrappingView.layer.borderColor = UIColor.gray.cgColor
            cell.value.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.value.textColor = UIColor.gray
            cell.value.text = "7.2"
        case .temperature:
            cell.textWrappingView.layer.cornerRadius = 0
            cell.textWrappingView.layer.borderWidth = 0
            cell.textWrappingView.layer.borderColor = UIColor.gray.cgColor
            cell.value.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            cell.value.textColor = UIColor.cyan
            cell.value.text = "25°"
        case .redox:
            cell.textWrappingView.layer.cornerRadius = 4
            cell.textWrappingView.layer.borderWidth = 1
            cell.textWrappingView.layer.borderColor = UIColor.gray.cgColor
            cell.value.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.value.textColor = UIColor.gray
            cell.value.text = "2.1"
        default: return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCell", for: indexPath)
            let imageView = UIImageView(image: UIImage(named: "arrow-up-right"))
            var headerFrame = header.bounds
            headerFrame.size.height = collectionView.frame.height / 2
            imageView.frame = headerFrame
            imageView.contentMode = .center
            
            header.addSubview(imageView)
            return header
        default:  fatalError("Unexpected element kind")
        }
    }
}

extension DashScrollViewItem: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.width - 110) / 7, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        }
        return CGSize(width: 15, height: collectionView.bounds.height)
    }
}

