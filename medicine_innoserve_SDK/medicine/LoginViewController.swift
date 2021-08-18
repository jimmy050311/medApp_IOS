//
//  LoginViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/5/6.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //emailTextField.text = "test@yahoo.com"
        //passwordTextField.text = "666666"
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstLoad")
                self.present(vc!, animated: true, completion: nil)
            }
        }
    }
    

    
    @IBAction func loginaction(_ sender: Any) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            // 提示用戶是不是忘記輸入 textfield ？
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {

                    // 登入成功，打印 ("You have successfully logged in")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstLoad")
                    self.present(vc!, animated: true, completion: nil)
                    //Go to the HomeViewController if the login is sucessful
                    

                    
                } else {
                    
                    // 提示用戶從 firebase 返回了一個錯誤。
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

