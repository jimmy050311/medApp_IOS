//
//  ParentEmailViewController.swift
//  medicine
//
//  Created by amkdajmal on 2020/11/1.
//  Copyright © 2020 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ParentEmailViewController: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func Confirm(_ sender: Any) {
        
        if EmailTextField.text != "test@yahoo.com"{
            let controller = UIAlertController(title: "錯誤!", message: "請輸入正確帳號", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }else{
            //輸入完綁定的帳號
            let controller = UIAlertController(title: "再次確認", message: "欲綁定的帳號為：" + EmailTextField.text!, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default) { (_) in
                self.ref.child("users/\(Auth.auth().currentUser!.uid)/Parentemail").setValue(self.EmailTextField.text!)
                self.ref.child("users/\(Auth.auth().currentUser!.uid)/Status").setValue("家屬")
                self.performSegue(withIdentifier: "finishparent", sender: self)
            }
            controller.addAction(okAction)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
        }
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {  //按空白關鍵盤
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //按return關鍵盤
        textField.resignFirstResponder()
        return true
    }
    
}
