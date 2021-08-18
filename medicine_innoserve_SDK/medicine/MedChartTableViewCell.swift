//
//  MedChartTableViewCell.swift
//  medicine
//
//  Created by amkdajmal on 2020/10/31.
//  Copyright © 2020 amkdajmal. All rights reserved.
//

import UIKit

class MedChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var medLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
