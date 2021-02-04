//
//  StockTableViewCell.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 26/06/2017.
//  Copyright © 2017 I See U. All rights reserved.
//

import UIKit

class StockButton: UIButton {
    var stock:Stock?
}

class StockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var quantityProgressView: UIProgressView!
    @IBOutlet weak var deleteButton: StockButton?
    @IBOutlet weak var editButton: StockButton?
    
    var stock:Stock? {
        didSet {
            self.productTypeLabel.text = stock?.product.productType.name
            self.productTypeLabel.textColor = .white
            
            if let productName = stock?.product.name {
                self.productNameLabel.text = productName
                self.productBrandLabel.text = stock?.product.brand?.name
                self.productBrandLabel.textColor = K.Color.DarkBlue
            } else {
                self.productNameLabel.text = "Product".localized + " N°\(String(describing: stock!.product.EAN))"
                self.productBrandLabel.text = "In the process of referencing...".localized
                self.productBrandLabel.textColor = K.Color.DarkBlue
            }
            self.quantityProgressView.setProgress(Float((stock?.percentageLeft)!), animated: true)
            
            self.deleteButton?.stock = stock
            self.editButton?.stock = stock
            
            quantityProgressView.layer.cornerRadius = 4
            quantityProgressView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
