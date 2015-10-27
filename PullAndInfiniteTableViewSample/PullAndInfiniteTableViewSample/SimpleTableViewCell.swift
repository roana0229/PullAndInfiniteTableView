//
//  SimpleTableViewCell.swift
//  PullToRefreshAndInfiniteScrolling
//
//  Created by 堤下薫 on 2015/10/22.
//  Copyright © 2015年 roana0229. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
