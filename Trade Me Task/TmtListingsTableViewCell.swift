//
//  TmtListingsTableViewCell.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 20/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import UIKit

class TmtListingsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var listingImageView: UIImageView!
    @IBOutlet weak var listingCityLabel: UILabel!
    @IBOutlet weak var listingTimeLabel: UILabel!
    @IBOutlet weak var listingNameLabel: UILabel!
    @IBOutlet weak var listingPriceLabel: UILabel!
    
    // MARK: - init from storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
