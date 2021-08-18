//
//  mymedTableViewCell.swift
//  medicine
//
//  Created by amkdajmal on 2019/7/23.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MyMedTableViewCell: UITableViewCell{

    
    @IBOutlet weak var MyMedName: UILabel!
    @IBOutlet weak var Add: UIButton!
    

    var delegate: SwiftDelegate?
    var mymedlist = [MyMed]()
    let ref = Database.database().reference()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
}
    
    
       @IBAction func likeAction(_ sender: Any) {
        delegate?.DidTap(_sender: self)

        
       // var  cell = mymedlist[indexPath.row].商品名
        
       // print(cell)
    }
}

