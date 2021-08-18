//
//  ViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/5/6.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FirstLoadViewController: UIViewController {

    @IBOutlet weak var PatientButton: UIButton!
    @IBOutlet weak var ParentButton: UIButton!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PatientButton.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.3529411765, blue: 0.337254902, alpha: 1)
        PatientButton.layer.cornerRadius = 25
        PatientButton.layer.borderWidth = 1
        PatientButton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
        
        ParentButton.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.3529411765, blue: 0.337254902, alpha: 1)
        ParentButton.layer.cornerRadius = 25
        ParentButton.layer.borderWidth = 1
        ParentButton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
    }
    
    @IBAction func iampaient(_ sender: Any) {
                self.ref.child("users/\(Auth.auth().currentUser!.uid)/Status").setValue("病患")
                self.performSegue(withIdentifier: "gotoapp", sender: self)
    }
    

    @IBAction func iamparent(_ sender: Any) {
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Parentemail").observeSingleEvent(of: .value) { (DataSnapshot) in
        let name = DataSnapshot.value as! String
            if name == "尚未設定"{
                self.performSegue(withIdentifier: "gotoparentemail", sender: self)
            }else{
                self.performSegue(withIdentifier: "gotoapp", sender: self)
                self.ref.child("users/\(Auth.auth().currentUser!.uid)/Status").setValue("家屬")
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




