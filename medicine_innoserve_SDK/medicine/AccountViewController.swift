//
//  AccountViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/11/23.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AccountViewController: UIViewController {

    
    @IBOutlet weak var BoxidTextField: UITextField!
    @IBOutlet weak var EmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "帳戶"
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
            let name = DataSnapshot.value as! String
            self.BoxidTextField.text = name
        }
        ref.child("users").child(Auth.auth().currentUser!.uid).child("email").observeSingleEvent(of: .value) { (DataSnapshot) in
            let email = DataSnapshot.value as! String
            self.EmailLabel.text = email
        }
        
        //test
//        for a in 0...83{
//            ref.child("users/\(Auth.auth().currentUser!.uid)/array2/\(a)").setValue(a)
//        }
//
//
//        var array1 = [Int]()
//        for i in 0...83{
//            ref.child("users").child(Auth.auth().currentUser!.uid).child("array2").child(String(i)).observeSingleEvent(of: .value) { (DataSnapshot) in
//                let name = DataSnapshot.value as! Int
//                array1.append(name)
//                print("\(array1)")
//            }
//        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func SaveButton(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child("users/\(Auth.auth().currentUser!.uid)/boxes").setValue(BoxidTextField.text!)
    }
    
}
