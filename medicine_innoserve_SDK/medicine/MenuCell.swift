//
//  MenuCell.swift
//  medicine
//
//  Created by amkdajmal on 2020/10/31.
//  Copyright © 2020 amkdajmal. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var menutitle: UILabel!
    @IBOutlet weak var box: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

