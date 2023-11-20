//
//  SampleView.swift
//  ColorStrip
//
//  Created by Vishnu T Vijay on 11/11/23.
//

import UIKit

protocol StripsViewDelegate {
    func selectedStripColors(stripView: StripsView, colors: [Color?], selectedItemsOrder: [Int: Int])
}

class StripsView: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bigPalette: UICollectionView!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var smallPalette: UICollectionView!
    
    var delegate: StripsViewDelegate?
    var dynamicWidth: CGFloat = 0
    var numberOfRows: Int = 7
    var allColors = [Color]()
    var selectedIndices = [Int: Int]()
    
    var selectedRows = [Int?]()

    var selectedColors = [Color?]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        numberOfRows = AppSharedData.sharedInstance.selectedStripOption
        if numberOfRows == 7{
            selectedColors = [nil,nil,nil,nil,nil,nil,nil]
            selectedRows = [nil,nil,nil,nil,nil,nil,nil]

        }else{
            selectedColors = [nil,nil,nil,nil,nil,nil]
            selectedRows = [nil,nil,nil,nil,nil,nil]
        }
//        selectedColors.reserveCapacity(numberOfRows)
        Bundle.main.loadNibNamed("StripsView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        bigPalette.register(UINib(nibName: "PaletteCollectionViewCell", bundle: nil),
                            forCellWithReuseIdentifier: "PaletteCollectionViewCell")
        smallPalette.register(UINib(nibName: "PaletteCollectionViewCell", bundle: nil),
                              forCellWithReuseIdentifier: "PaletteCollectionViewCell")
        containerView.layer.cornerRadius = 10
        
        validateButton.layer.cornerRadius = 10
        if numberOfRows == 7 {
            validateButton.setTitle("4427:67592".localized, for: .normal)
            validateButton.backgroundColor = UIColor.init(hexString: "FE4DAF")
        } else {
            validateButton.setTitle("4427:67674".localized, for: .normal)
            validateButton.backgroundColor = UIColor.init(hexString: "124DFF")
        }
//        validateButton.setTitle(numberOfRows == 7 ? "Validate Strip7" : "Validate Strip6",
//                                for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dynamicWidth = self.frame.width * 0.80
        print(self.frame.width)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 15, right: 0)
        let calculatedSize = (dynamicWidth - 80) / 10
        layout.itemSize = CGSize(width: calculatedSize,
                                 height: calculatedSize)
        bigPalette.setCollectionViewLayout(layout, animated: false)
        bigPalette.reloadData()
        
        let layoutSmall = UICollectionViewFlowLayout()
        layoutSmall.scrollDirection = .vertical
        layoutSmall.minimumInteritemSpacing = 5
        layoutSmall.minimumLineSpacing = 10

        layoutSmall.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 15, right: 0)
        layoutSmall.itemSize = CGSize(width: calculatedSize,
                                 height: calculatedSize)
        smallPalette.setCollectionViewLayout(layoutSmall, animated: false)
        smallPalette.reloadData()
        smallPalette.contentInset = UIEdgeInsets(top: 13, left: 0, bottom: 10, right: 0)
        smallPalette.layer.cornerRadius = 15

    }
    
    @IBAction func validateStripSelected(_ sender: UIButton) {
        
        for (key,value) in selectedIndices {
            print("\(key) = \(value)")
        }
        if selectedRows.contains(where: {$0 == nil}) {
            return
        }

        delegate?.selectedStripColors(stripView: self, colors: selectedColors,selectedItemsOrder: selectedIndices)
    }
}

extension StripsView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bigPalette {
            return 10
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaletteCollectionViewCell", for: indexPath) as! PaletteCollectionViewCell
        cell.layer.cornerRadius = 3
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 0.4
//        cell.layer.masksToBounds = false
        
        if collectionView == bigPalette {
            let color = allColors[(indexPath.section * 10) + indexPath.row]
            let derivedColor = color.uiColor
            if selectedIndices[indexPath.section] == indexPath.row {
                cell.selectedCell = true
            } else {
                cell.selectedCell = false
            }
            cell.backgroundColor = derivedColor
        } else {
            cell.backgroundColor = UIColor.init(hexString: "CBD6E7")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == bigPalette else { return }
        let oldItemRowNumber = selectedIndices[indexPath.section]
        selectedIndices[indexPath.section] = indexPath.row
        var indexPathsToReload = [IndexPath(row: indexPath.row, section: indexPath.section)]
        if let previousRow = oldItemRowNumber {
            indexPathsToReload.append(IndexPath(row: previousRow, section: indexPath.section))
        }
        collectionView.reloadItems(at: indexPathsToReload)
        let color = allColors[(indexPath.section * 10) + indexPath.row]
        let cell = smallPalette.cellForItem(at: IndexPath(row: 0, section: indexPath.section))
        selectedColors.insert(color, at: indexPath.section)
//        selectedRows.insert(1, at: indexPath.section)
        selectedRows[indexPath.section] = 1
        cell?.backgroundColor = color.uiColor
        
    }
}

//extension StripsView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let calculatedItemSize = self.bounds.width / 10
//        return CGSize(width: calculatedItemSize,
//                      height: calculatedItemSize)
//    }
//}
