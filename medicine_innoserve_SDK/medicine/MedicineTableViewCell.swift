//
//  File.swift
//  medicine
//
//  Created by amkdajmal on 2019/6/3.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameMed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
