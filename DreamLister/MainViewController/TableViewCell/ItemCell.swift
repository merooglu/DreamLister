//
//  MainCell.swift
//  DreamLister
//
//  Created by Mehmet Eroğlu on 10.03.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var tumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
