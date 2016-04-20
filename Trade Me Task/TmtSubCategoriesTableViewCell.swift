//
//  TmtSubCategoriesTableViewCell.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 20/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import UIKit

class TmtSubCategoriesTableViewCell: UITableViewCell {

    // MARK: -outlets
    
    @IBOutlet weak var labelSubCategoryName: UILabel!
    
    @IBOutlet weak var labelSubCategoryItemCount: UILabel!
    
    
    // MAKR: -init from storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
