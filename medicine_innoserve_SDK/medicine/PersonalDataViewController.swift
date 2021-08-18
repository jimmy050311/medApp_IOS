//
//  PersonalDataViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/7/30.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class PersonalDataViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    
    @IBOutlet weak var TextField_1: UITextField!
    @IBOutlet weak var TextField_2: UITextField!
    @IBOutlet weak var TextField_3: UITextField!
    @IBOutlet weak var TextField_4: UITextField!
    @IBOutlet weak var TextField_5: UITextField!
    @IBOutlet weak var TextField_6: UITextField!    
    @IBOutlet weak var TextField_7: UITextField!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var BoxidTextField: UITextField!
    @IBOutlet weak var ParentTextField: UITextField!
    @IBOutlet weak var ParentLabel: UILabel!
    
    
    
    var uid = ""
    let uniqueString = NSUUID().uuidString
    
    let PickerView2 = UIPickerView()
    //let PickerView7 = UIPickerView()
    let datePickerView3 = UIDatePicker()
    let datePickerView4 = UIDatePicker()
    let datePickerView5 = UIDatePicker()
    let datePickerView6 = UIDatePicker()
    let datePickerView7 = UIDatePicker()
    
    let gender = ["男","女"]
    let cycle = ["一天一次","一天兩次","一天三次","一天四次"]
    
    @IBOutlet weak var finishbutton: UIButton!
    @IBOutlet weak var editbutton: UIButton!
    
    //var formatter = DateFormatter()
    var formatter: DateFormatter! = nil
    override func viewDidLoad() {
        var ref = Database.database().reference()
        super.viewDidLoad()
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "病患"{
                self.ParentTextField.isHidden = true
                self.ParentLabel.isHidden = true
            }else{
                self.ParentTextField.isHidden = false
                self.ParentLabel.isHidden = false
            }
        }
        
        navigationItem.title = "個人資料"
        let BtnItem3 = UIBarButtonItem.init(title: "＜設定", style: .done, target: self, action: #selector(titleBarButtonItemMethod))
        self.navigationItem.leftBarButtonItem = BtnItem3

        
        finishbutton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        finishbutton.layer.cornerRadius = 25
        finishbutton.layer.borderWidth = 1
        finishbutton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
        editbutton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        editbutton.layer.cornerRadius = 25
        editbutton.layer.borderWidth = 1
        editbutton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
        
        BoxidTextField.delegate = self
        TextField_1.delegate = self
        //隱藏按鈕 讓使用者不能輸入
        finishbutton.isHidden = true
        editbutton.isHidden = false
        BoxidTextField.isUserInteractionEnabled = false
        TextField_1.isUserInteractionEnabled = false
        TextField_2.isUserInteractionEnabled = false
        TextField_3.isUserInteractionEnabled = false
        TextField_4.isUserInteractionEnabled = false
        TextField_5.isUserInteractionEnabled = false
        TextField_6.isUserInteractionEnabled = false
        TextField_7.isUserInteractionEnabled = false
        ParentTextField.isUserInteractionEnabled = false
        
//        BoxidTextField.borderStyle = UITextField.BorderStyle(rawValue: 0)!
//        TextField_1.borderStyle = UITextField.BorderStyle(rawValue: 0)!
//        TextField_2.borderStyle = UITextField.BorderStyle(rawValue: 0)!
//        TextField_3.borderStyle = UITextField.BorderStyle(rawValue: 0)!
//        TextField_4.borderStyle = UITextField.BorderStyle(rawValue: 0)!
//        TextField_5.borderStyle = UITextField.BorderStyle(rawValue: 0)!
//        TextField_6.borderStyle = UITextField.BorderStyle(rawValue: 0)!
//        TextField_7.borderStyle = UITextField.BorderStyle(rawValue: 0)!
        
        
        //讀資料庫資料
       
        ref.child("users").child(Auth.auth().currentUser!.uid).child("email").observeSingleEvent(of: .value) { (DataSnapshot) in
            let email = DataSnapshot.value as! String
            self.EmailLabel.text = email
        }
        ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
            let name = DataSnapshot.value as! String
            self.BoxidTextField.text = name
        }
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("姓名").observeSingleEvent(of: .value) { (DataSnapshot) in
            let name = DataSnapshot.value as! String
            self.TextField_1.text = name
        }
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("性別").observeSingleEvent(of: .value) { (DataSnapshot) in
            let gender = DataSnapshot.value as! String
            self.TextField_2.text = gender
        }
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("生日").observeSingleEvent(of: .value) { (DataSnapshot) in
            let brith = DataSnapshot.value as! String
            self.TextField_3.text = brith
        }
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("早餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let br = DataSnapshot.value as! String
            self.TextField_4.text = br
        }
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("午餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let lu = DataSnapshot.value as! String
            self.TextField_5.text = lu
        }
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("晚餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let di = DataSnapshot.value as! String
            self.TextField_6.text = di
        }
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("睡覺時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let sl = DataSnapshot.value as! String
            self.TextField_7.text = sl
        }
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Parentemail").observeSingleEvent(of: .value) { (DataSnapshot) in
            let pe = DataSnapshot.value as! String
            self.ParentTextField.text = pe
        }
            
        
        PickerView2.delegate = self
        PickerView2.dataSource = self
//        PickerView7.delegate = self
//        PickerView7.dataSource = self
        
        TextField_2.inputView = PickerView2
//        TextField_7.inputView = PickerView7

        
        //生日
        formatter = DateFormatter()
        datePickerView3.datePickerMode = .date
        datePickerView3.date = NSDate() as Date
        datePickerView3.locale = NSLocale(localeIdentifier: "zh_TW") as Locale
        datePickerView3.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        TextField_3.inputView = datePickerView3
        TextField_3.tag = 200
        
        //早餐時間

        datePickerView4.datePickerMode = .time
        datePickerView4.date = NSDate() as Date
        datePickerView4.locale = NSLocale(localeIdentifier: "zh_TW") as Locale
        //TextField_4.text = formatter.string(from: datePickerView4.date)  //預設值
        datePickerView4.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        TextField_4.inputView = datePickerView4
        TextField_4.tag = 300
        
        //午餐時間

        datePickerView5.datePickerMode = .time
        datePickerView5.date = NSDate() as Date
        datePickerView5.locale = NSLocale(localeIdentifier: "zh_TW") as Locale
        //TextField_5.text = formatter.string(from: datePickerView5.date)  //預設值
        datePickerView5.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        TextField_5.inputView = datePickerView5
        TextField_5.tag = 400
        
        //晚餐時間

        datePickerView6.datePickerMode = .time
        datePickerView6.date = NSDate() as Date
        datePickerView6.locale = NSLocale(localeIdentifier: "zh_TW") as Locale
        //TextField_6.text = formatter.string(from: datePickerView6.date)  //預設值
        datePickerView6.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        TextField_6.inputView = datePickerView6
        TextField_6.tag = 500
        
        
        //睡覺時間
        
        datePickerView7.datePickerMode = .time
        datePickerView7.date = NSDate() as Date
        datePickerView7.locale = NSLocale(localeIdentifier: "zh_TW") as Locale
        //TextField_7.text = formatter.string(from: datePickerView7.date)  //預設值
        datePickerView7.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        TextField_7.inputView = datePickerView7
        TextField_7.tag = 600
        
        /*if let user = Auth.auth().currentUser{
            uid = user.uid
        }*/

        //let tap = UITapGestureRecognizer(target: self, action: #selector(PersonalDataViewController.hideKeyboard(tapG:)))
        //tap.cancelsTouchesInView = false
        //self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func titleBarButtonItemMethod(sender: UIBarButtonItem) {
        
        
        if finishbutton.isHidden == false{//未儲存
            let controller = UIAlertController(title: "警告", message: "您尚未儲存\n請問是否要離開", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
            controller.addAction(okAction)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            self.present(controller, animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)//回上頁
        }

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewDataSource 必須實作的方法：
    // UIPickerView 各列有多少行資料
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        // 返回陣列 meals 的成員數量
        if pickerView == PickerView2{
            return gender.count
        }
//        else if pickerView == PickerView7{
//            return cycle.count}
        else{
           
            return 0
        }
        
    }
    
    // UIPickerView 每個選項顯示的資料
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        // 設置為陣列 meals 的第 row 項資料
        if pickerView == PickerView2{
            return gender[row]
        }
//        else if pickerView == PickerView7{
//            return cycle[row]
//        }
        else{
            return nil
        }
      
    }
    
    // UIPickerView 改變選擇後執行的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 依據元件的 tag 取得 UITextField
        if pickerView == PickerView2{
            self.TextField_2.text = gender[row]
            //self.view.endEditing(false)  自動關閉
        }
//        else if pickerView == PickerView7{
//            self.TextField_7.text = cycle[row]
//            //self.view.endEditing(false)
//        }
    }
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        // 依據元件的 tag 取得 UITextField
        
        let TextField_3 = self.view?.viewWithTag(200) as? UITextField
        let TextField_4 = self.view?.viewWithTag(300) as? UITextField
        let TextField_5 = self.view?.viewWithTag(400) as? UITextField
        let TextField_6 = self.view?.viewWithTag(500) as? UITextField
        let TextField_7 = self.view?.viewWithTag(600) as? UITextField
        
        if TextField_3!.isFirstResponder{
            formatter.dateFormat = "yyyy-MM-dd"
            TextField_3?.text = formatter.string(from: sender.date)
        }
        if TextField_4!.isFirstResponder{
            formatter.dateFormat = "HH : mm"
            TextField_4?.text = formatter.string(from: sender.date)
        }
        if TextField_5!.isFirstResponder{
            formatter.dateFormat = "HH : mm"
            TextField_5?.text = formatter.string(from: sender.date)
        }
        if TextField_6!.isFirstResponder{
            formatter.dateFormat = "HH : mm"
            TextField_6?.text = formatter.string(from: sender.date)
        }
        if TextField_7!.isFirstResponder{
            formatter.dateFormat = "HH : mm"
            TextField_7?.text = formatter.string(from: sender.date)
        }
        
        
        //self.view.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {  //按空白關鍵盤
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //按return關鍵盤
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    @IBAction func Finish(_ sender: UIButton) {
        
        let ref = Database.database().reference()
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "病患"{
                if self.BoxidTextField.text != "amkdajdal"{
                    let alert = UIAlertController(title: "錯誤", message: "查無此藥盒", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else if self.BoxidTextField.text == "amkdajdal"{
                    ref.child("users/\(Auth.auth().currentUser!.uid)/boxes").setValue(self.BoxidTextField.text!)
                    if self.TextField_1.text != "" {
                        ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/姓名").setValue(self.TextField_1.text!)
                        ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/性別").setValue(self.TextField_2.text!)
                        ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/生日").setValue(self.TextField_3.text!)
                        ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/早餐時間").setValue(self.TextField_4.text!)
                        ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/午餐時間").setValue(self.TextField_5.text!)
                        ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/晚餐時間").setValue(self.TextField_6.text!)
                        ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/睡覺時間").setValue(self.TextField_7.text!)
                        //ref.child("users/\(Auth.auth().currentUser!.uid)/Parentemail").setValue(ParentTextField.text!)
                        self.finishbutton.isHidden = true
                        self.editbutton.isHidden = false
                        
                        self.BoxidTextField.isUserInteractionEnabled = false
                        self.TextField_1.isUserInteractionEnabled = false
                        self.TextField_2.isUserInteractionEnabled = false
                        self.TextField_3.isUserInteractionEnabled = false
                        self.TextField_4.isUserInteractionEnabled = false
                        self.TextField_5.isUserInteractionEnabled = false
                        self.TextField_6.isUserInteractionEnabled = false
                        self.TextField_7.isUserInteractionEnabled = false
                        self.ParentTextField.isUserInteractionEnabled = false
                    }else{
                        let alert = UIAlertController(title: "錯誤", message: "請輸入姓名", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }else{
                if self.BoxidTextField.text != "amkdajdal"{
                    let alert = UIAlertController(title: "錯誤", message: "查無此藥盒", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else if self.BoxidTextField.text == "amkdajdal"{
                    if self.ParentTextField.text == "test@yahoo.com"{
                        ref.child("users/\(Auth.auth().currentUser!.uid)/boxes").setValue(self.BoxidTextField.text!)
                        if self.TextField_1.text != "" {
                            ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/姓名").setValue(self.TextField_1.text!)
                            ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/性別").setValue(self.TextField_2.text!)
                            ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/生日").setValue(self.TextField_3.text!)
                            ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/早餐時間").setValue(self.TextField_4.text!)
                            ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/午餐時間").setValue(self.TextField_5.text!)
                            ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/晚餐時間").setValue(self.TextField_6.text!)
                            ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/睡覺時間").setValue(self.TextField_7.text!)
                            ref.child("users/\(Auth.auth().currentUser!.uid)/Parentemail").setValue(self.ParentTextField.text!)
                            self.finishbutton.isHidden = true
                            self.editbutton.isHidden = false
                            
                            self.BoxidTextField.isUserInteractionEnabled = false
                            self.TextField_1.isUserInteractionEnabled = false
                            self.TextField_2.isUserInteractionEnabled = false
                            self.TextField_3.isUserInteractionEnabled = false
                            self.TextField_4.isUserInteractionEnabled = false
                            self.TextField_5.isUserInteractionEnabled = false
                            self.TextField_6.isUserInteractionEnabled = false
                            self.TextField_7.isUserInteractionEnabled = false
                            self.ParentTextField.isUserInteractionEnabled = false
                        }else{
                            let alert = UIAlertController(title: "錯誤", message: "請輸入姓名", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        let alert = UIAlertController(title: "錯誤", message: "家屬帳號錯誤", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)

                    }
                }
            }
        }
        
//        if BoxidTextField.text != "amkdajdal"{
//            let alert = UIAlertController(title: "錯誤", message: "查無此藥盒", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }else if BoxidTextField.text == "amkdajdal"{
//            if ParentTextField.text == "test@yahoo.com"{
//                ref.child("users/\(Auth.auth().currentUser!.uid)/boxes").setValue(BoxidTextField.text!)
//                if TextField_1.text != "" {
//                    ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/姓名").setValue(TextField_1.text!)
//                    ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/性別").setValue(TextField_2.text!)
//                    ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/生日").setValue(TextField_3.text!)
//                    ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/早餐時間").setValue(TextField_4.text!)
//                    ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/午餐時間").setValue(TextField_5.text!)
//                    ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/晚餐時間").setValue(TextField_6.text!)
//                    ref.child("users/\(Auth.auth().currentUser!.uid)/personal_details/睡覺時間").setValue(TextField_7.text!)
//                    ref.child("users/\(Auth.auth().currentUser!.uid)/Parentemail").setValue(ParentTextField.text!)
//                    finishbutton.isHidden = true
//                    editbutton.isHidden = false
//
//                    BoxidTextField.isUserInteractionEnabled = false
//                    TextField_1.isUserInteractionEnabled = false
//                    TextField_2.isUserInteractionEnabled = false
//                    TextField_3.isUserInteractionEnabled = false
//                    TextField_4.isUserInteractionEnabled = false
//                    TextField_5.isUserInteractionEnabled = false
//                    TextField_6.isUserInteractionEnabled = false
//                    TextField_7.isUserInteractionEnabled = false
//                    ParentTextField.isUserInteractionEnabled = false
//                }else{
//                    let alert = UIAlertController(title: "錯誤", message: "請輸入姓名", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }else{
//                let alert = UIAlertController(title: "錯誤", message: "家屬帳號錯誤", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//
//            }
//        }
    }
    @IBAction func Editbutton(_ sender: Any) {
        //打開按鈕、文字盒
        finishbutton.isHidden = false
        editbutton.isHidden = true
        BoxidTextField.isUserInteractionEnabled = true
        TextField_1.isUserInteractionEnabled = true
        TextField_2.isUserInteractionEnabled = true
        TextField_3.isUserInteractionEnabled = true
        TextField_4.isUserInteractionEnabled = true
        TextField_5.isUserInteractionEnabled = true
        TextField_6.isUserInteractionEnabled = true
        TextField_7.isUserInteractionEnabled = true
        ParentTextField.isUserInteractionEnabled = true
        
        BoxidTextField.borderStyle = UITextField.BorderStyle(rawValue: 3)!
        TextField_1.borderStyle = UITextField.BorderStyle(rawValue: 3)!
        TextField_2.borderStyle = UITextField.BorderStyle(rawValue: 3)!
        TextField_3.borderStyle = UITextField.BorderStyle(rawValue: 3)!
        TextField_4.borderStyle = UITextField.BorderStyle(rawValue: 3)!
        TextField_5.borderStyle = UITextField.BorderStyle(rawValue: 3)!
        TextField_6.borderStyle = UITextField.BorderStyle(rawValue: 3)!
        TextField_7.borderStyle = UITextField.BorderStyle(rawValue: 3)!
        ParentTextField.borderStyle = UITextField.BorderStyle(rawValue: 3)!
    }
    
}



