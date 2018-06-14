//
//  ItemTableViewCell.swift
//  P_L_Tech_Test
//
//  Created by Sean Carlin on 11/06/2018.
//  Copyright © 2018 Sean Carlin. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

	@IBOutlet weak var itemIdLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subTitleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
