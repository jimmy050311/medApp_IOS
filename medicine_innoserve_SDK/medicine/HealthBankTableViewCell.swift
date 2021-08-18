//
//  HealthBankTableViewCell.swift
//  medicine
//
//  Created by amkdajmal on 2020/12/6.
//  Copyright © 2020 amkdajmal. All rights reserved.
//

import UIKit
class HealthBankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var DateText: UILabel!
    @IBOutlet weak var NameText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
