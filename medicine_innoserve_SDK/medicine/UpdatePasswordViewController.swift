//
//  UpdatePasswordViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/12/8.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class UpdatePasswordViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var OldTextField: UITextField!
    @IBOutlet weak var NewTextField: UITextField!
    @IBOutlet weak var ConfirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "更改密碼"
        ConfirmButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ConfirmButton.layer.cornerRadius = 25
        ConfirmButton.layer.borderWidth = 1
        ConfirmButton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
        OldTextField.delegate = self
        NewTextField.delegate = self
    }
    @IBAction func Confirm(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("password").observeSingleEvent(of: .value) { (DataSnapshot) in
            let oldpassword = DataSnapshot.value as! String
            if self.OldTextField.text! == oldpassword{
                var isInputValid = (self.NewTextField.text?.count ?? 0) > 0
                print(isInputValid)
                if isInputValid == true{
                    Auth.auth().currentUser!.updatePassword(to: self.NewTextField.text!, completion: nil)
                    ref.child("users/\(Auth.auth().currentUser!.uid)/password").setValue(self.NewTextField.text!)

                    let alertController = UIAlertController(title: "通知", message: "您已成功更改密碼", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    self.OldTextField.text = ""
                    self.NewTextField.text = ""
                }else if isInputValid == false{
                    let alertController = UIAlertController(title: "錯誤", message: "請輸入新密碼", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }else if self.OldTextField.text! != oldpassword{
                let alertController = UIAlertController(title: "錯誤", message: "舊密碼輸入錯誤", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {  //按return關鍵盤
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {  //按空白關鍵盤
        self.view.endEditing(true)
    }
}
