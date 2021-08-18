//
//  MedTextCell.swift
//  medicine
//
//  Created by amkdajmal on 2020/10/31.
//  Copyright © 2020 amkdajmal. All rights reserved.
//

import UIKit

class MedTextCell: UITableViewCell {
    
    @IBOutlet weak var thumbimage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc1: UILabel!
    @IBOutlet weak var desc2: UILabel!
    @IBOutlet weak var desc3: UILabel!
    
    
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
