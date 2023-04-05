//
//  GatewayTableViewCell.swift
//  Flipr
//
//  Created by Ajeesh on 04/04/23.
//  Copyright © 2023 I See U. All rights reserved.
//

import UIKit

protocol GatewayTableViewCellDelegate {
    func addGateway(cell: GatewayTableViewCell, gateWay: String)
}

class GatewayTableViewCell: UITableViewCell {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var gatewayNameLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    var delegate: GatewayTableViewCellDelegate?
    var info:UserGateway?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addAction(_ sender: UIButton) {
        self.delegate?.addGateway(cell: self, gateWay: gatewayNameLabel.text ?? "")
    }
}
