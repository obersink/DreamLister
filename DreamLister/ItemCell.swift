//
//  ItemCell.swift
//  DreamLister
//
//  Created by Simon Zhen on 5/5/17.
//  Copyright © 2017 Simon Zhen. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(item: Item) {
        itemTitleLabel.text = item.title
        priceLabel.text = "\(item.price)"
        detailsLabel.text = item.details
    }

}
