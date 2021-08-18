//
//  SetUpViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/5/6.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class SignUpViewController: UIViewController,UITextFieldDelegate {


    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    @IBAction func creatAccountAction(_ sender: Any) {
        let ref = Database.database().reference()

            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                // 有錯誤
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    print("SignUp Failed")
                    
                    let errorCode = AuthErrorCode(rawValue: firebaseError._code)
                    switch errorCode! {
                    case .emailAlreadyInUse:
                        print("帳號已註冊")
                    default: break
                        
                    }
                    // 跳出Alert
                    let alert = UIAlertController(title: "註冊錯誤", message: firebaseError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                // read data once
             
                ref.child("users").child(user!.user.uid).setValue(["password":self.passwordTextField.text,"email": self.emailTextField.text])
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/藥物名稱").setValue("暫無藥物")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/重量/test01").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/重量/test02").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/濕度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/溫度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/吃藥時間").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/藥物名稱").setValue("暫無藥物")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/重量/test01").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/重量/test02").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/濕度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/溫度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/吃藥時間").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/藥物名稱").setValue("暫無藥物")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/重量/test01").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/重量/test02").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/濕度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/溫度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/吃藥時間").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/藥物名稱").setValue("暫無藥物")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/重量/test01").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/重量/test02").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/濕度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/溫度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/吃藥時間").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/藥物名稱").setValue("暫無藥物")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/重量/test01").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/重量/test02").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/濕度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/溫度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/吃藥時間").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/藥物名稱").setValue("暫無藥物")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/重量/test01").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/重量/test02").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/濕度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/溫度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/吃藥時間").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/是否睡前服用").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/姓名").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/性別").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/生日").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/早餐時間").setValue("07:00")
                ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/午餐時間").setValue("12:00")
                ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/晚餐時間").setValue("19:00")
                ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/睡覺時間").setValue("00:00")
                
                ref.child("users/\(Auth.auth().currentUser!.uid)/MedNotice").setValue("False")
                ref.child("users/\(Auth.auth().currentUser!.uid)/boxes").setValue("尚未設定")
                
                ref.child("users/\(Auth.auth().currentUser!.uid)/Parentemail").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/Status").setValue("未知")//登入狀態
                print("SignUp Success")
                // 跳到login view
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let initialViewController = (self.storyboard?.instantiateViewController(withIdentifier: "FirstLoad"))! as UIViewController
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
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


/*原本登入
 @IBAction func creatAccountAction(_ sender: Any) {
 if emailTextField.text == "" {
 let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
 
 let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
 alertController.addAction(defaultAction)
 
 present(alertController, animated: true, completion: nil)
 
 } else {
 Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
 
 if error == nil {
 print("You have successfully signed up")
 //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
 
 
 } else {
 let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
 
 let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
 alertController.addAction(defaultAction)
 
 self.present(alertController, animated: true, completion: nil)
 }
 }
 }*/

/*品硯版本
 let ref = Database.database().reference()
 if let email = email.text, let pass = passwd.text {
 Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
 // 有錯誤
 if let firebaseError = error {
 print(firebaseError.localizedDescription)
 print("SignUp Failed")
 
 let errorCode = AuthErrorCode(rawValue: firebaseError._code)
 switch errorCode! {
 case .emailAlreadyInUse:
 print("帳號已註冊")
 default: break
 
 }
 // 跳出Alert
 let alert = UIAlertController(title: "註冊錯誤", message: firebaseError.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
 alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
 self.present(alert, animated: true, completion: nil)
 
 return
 }
 // read data once
 ref.child("users").child((user?.uid)!).setValue(["name": self.name.text!,"email": email, "role": "customer"])
 print("SignUp Success")
 // 跳到login view
 let appDelegate = UIApplication.shared.delegate as! AppDelegate
 
 let initialViewController = (self.storyboard?.instantiateViewController(withIdentifier: "LoginView"))! as UIViewController
 appDelegate.window?.rootViewController = initialViewController
 appDelegate.window?.makeKeyAndVisible()
 }
 }
 */
