//
//  ProfileCell.swift
//  I-valleyBuffte
//
//  Created by azzaz on 6/12/18.
//  Copyright © 2018 azzaz. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    @IBOutlet weak var lblOrderName: UILabel!

    @IBOutlet weak var lblOrderPrice: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblPlaced: UILabel!
    @IBOutlet weak var lblConfirmed: UILabel!
    @IBOutlet weak var lblOrderCost: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
