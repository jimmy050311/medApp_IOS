//
//  MyDetailViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/7/31.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GameKit
class MyDetailViewController: UIViewController {
    
    var infoFromViewOne1:String?
    var infoFromViewOne2:String? 
    var infoFromViewOne3:String?
    var infoFromViewOne4:String?
    var infoFromViewOne5:String?
    
    @IBOutlet weak var MyMedicineName: UILabel!
    @IBOutlet weak var MyScientificName: UILabel!
    @IBOutlet weak var MySideeffect: UILabel!
    @IBOutlet weak var MyAdaptation: UILabel!
    @IBOutlet weak var MyMedicineNumber: UILabel!
    @IBOutlet weak var AddBoxButton: UIButton!
    @IBOutlet weak var RemoveMyButton: UIButton!
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyMedicineName.text = infoFromViewOne1
        MyScientificName.text = infoFromViewOne2
        MySideeffect.text = infoFromViewOne3
        MyAdaptation.text = infoFromViewOne4
        MyMedicineNumber.text = infoFromViewOne5
        // Do any additional setup after loading the view.
        
        AddBoxButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        AddBoxButton.layer.cornerRadius = 25
        AddBoxButton.layer.borderWidth = 1
        AddBoxButton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
        
        RemoveMyButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        RemoveMyButton.layer.cornerRadius = 25
        RemoveMyButton.layer.borderWidth = 1
        RemoveMyButton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "家屬"{
                self.AddBoxButton.isHidden = true
            }else{
                self.AddBoxButton.isHidden = false
            }
        }
        
    }
    @IBAction func join(_ sender: Any) {
        let mann = MyMedicineName.text
        let ref = Database.database().reference()
        let controller = UIAlertController(title: "請選擇要加入的藥盒位置", message: "將" + mann! + "加入藥盒？" , preferredStyle: .actionSheet)
        let names = ["1","2","3","4","5","6"]
        for name in names {
            let action = UIAlertAction(title: name, style: .default) { (action) in
                print(action.title)
                switch action.title  {
                case "1":
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let YN = DataSnapshot.value as! String
                        
                        if YN != "暫無藥物"
                        {
                            let controller = UIAlertController(title: "第一格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + mann! , preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                               
                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/藥物名稱").setValue(mann)
                                let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                for name in names {
                                    let action = UIAlertAction(title: name, style: .default) { (action) in
                                        print(action.title)
                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/吃藥時間").setValue(action.title)
                                        if action.title != "睡前"
                                        {
                                            let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                            let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("是")
                                                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                            controller.addAction(okAction)
                                            let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("否")
                                                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                            controller.addAction(cancelAction)
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                        else
                                        {
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("是")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        
                                    }
                                    controller.addAction(action)
                                }
                                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                controller.addAction(cancelAction)
                                self.present(controller, animated: true, completion: nil)
                            }
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            controller.addAction(okAction)
                            self.present(controller, animated: true, completion: nil)
                        }
                        else
                        {
                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/藥物名稱").setValue(mann)
                            let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                            let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                            for name in names {
                                let action = UIAlertAction(title: name, style: .default) { (action) in
                                    print(action.title)
                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/吃藥時間").setValue(action.title)
                                    if action.title != "睡前"
                                    {
                                        let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("是")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        controller.addAction(okAction)
                                        let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("否")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        controller.addAction(cancelAction)
                                        self.present(controller, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("是")
                                        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                    }
                                    
                                }
                                controller.addAction(action)
                            }
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            self.present(controller, animated: true, completion: nil)
                        }
                    }
                    
                case "2":
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let YN = DataSnapshot.value as! String

                        if YN != "暫無藥物"
                        {
                            let controller = UIAlertController(title: "第二格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + mann! , preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                
                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/藥物名稱").setValue(mann)
                                let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                for name in names {
                                    let action = UIAlertAction(title: name, style: .default) { (action) in
                                        print(action.title)
                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/吃藥時間").setValue(action.title)
                                        if action.title != "睡前"
                                        {
                                            let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                            let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("是")
                                                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                            controller.addAction(okAction)
                                            let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("否")
                                                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                            controller.addAction(cancelAction)
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                        else
                                        {
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("是")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        
                                    }
                                    controller.addAction(action)
                                }
                                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                controller.addAction(cancelAction)
                                self.present(controller, animated: true, completion: nil)
                            }
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            controller.addAction(okAction)
                            self.present(controller, animated: true, completion: nil)
                        }
                        else
                        {
                           
                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/藥物名稱").setValue(mann)
                            let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                            let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                            for name in names {
                                let action = UIAlertAction(title: name, style: .default) { (action) in
                                    print(action.title)
                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/吃藥時間").setValue(action.title)
                                    if action.title != "睡前"
                                    {
                                        let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("是")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        controller.addAction(okAction)
                                        let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("否")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        controller.addAction(cancelAction)
                                        self.present(controller, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("是")
                                        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                    }
                                    
                                }
                                controller.addAction(action)
                            }
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            self.present(controller, animated: true, completion: nil)
                        }
                    }
                case "3":
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let YN = DataSnapshot.value as! String

                        if YN != "暫無藥物"
                        {
                            let controller = UIAlertController(title: "第三格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + mann! , preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/藥物名稱").setValue(mann)
                                let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                for name in names {
                                    let action = UIAlertAction(title: name, style: .default) { (action) in
                                        print(action.title)
                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/吃藥時間").setValue(action.title)
                                        if action.title != "睡前"
                                        {
                                            let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                            let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("是")
                                                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                            controller.addAction(okAction)
                                            let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("否")
                                                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                            controller.addAction(cancelAction)
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                        else
                                        {
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("是")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        
                                    }
                                    controller.addAction(action)
                                }
                                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                controller.addAction(cancelAction)
                                self.present(controller, animated: true, completion: nil)
                            }
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            controller.addAction(okAction)
                            self.present(controller, animated: true, completion: nil)
                        }
                        else
                        {
                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/藥物名稱").setValue(mann)
                            let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                            let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                            for name in names {
                                let action = UIAlertAction(title: name, style: .default) { (action) in
                                    print(action.title)
                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/吃藥時間").setValue(action.title)
                                    if action.title != "睡前"
                                    {
                                        let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("是")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        controller.addAction(okAction)
                                        let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("否")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        controller.addAction(cancelAction)
                                        self.present(controller, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("是")
                                        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                    }
                                    
                                }
                                controller.addAction(action)
                            }
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            self.present(controller, animated: true, completion: nil)
                        }}
                case "4":
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let YN = DataSnapshot.value as! String

                        if YN != "暫無藥物"
                        {
                            let controller = UIAlertController(title: "第四格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + mann! , preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/藥物名稱").setValue(mann)
                                let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                for name in names {
                                    let action = UIAlertAction(title: name, style: .default) { (action) in
                                        print(action.title)
                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/吃藥時間").setValue(action.title)
                                        if action.title != "睡前"
                                        {
                                            let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                            let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("是")
                                                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                            controller.addAction(okAction)
                                            let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("否")
                                                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                            controller.addAction(cancelAction)
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                        else
                                        {
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("是")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        
                                    }
                                    controller.addAction(action)
                                }
                                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                controller.addAction(cancelAction)
                                self.present(controller, animated: true, completion: nil)
                            }
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            controller.addAction(okAction)
                            self.present(controller, animated: true, completion: nil)
                        }
                        else
                        {
                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/藥物名稱").setValue(mann)
                            let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                            let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                            for name in names {
                                let action = UIAlertAction(title: name, style: .default) { (action) in
                                    print(action.title)
                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/吃藥時間").setValue(action.title)
                                    if action.title != "睡前"
                                    {
                                        let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("是")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        controller.addAction(okAction)
                                        let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("否")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        controller.addAction(cancelAction)
                                        self.present(controller, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("是")
                                        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                    }
                                    
                                }
                                controller.addAction(action)
                            }
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            self.present(controller, animated: true, completion: nil)
                        }}
                case "5":
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let YN = DataSnapshot.value as! String

                        if YN != "暫無藥物"
                        {
                            let controller = UIAlertController(title: "第五格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + mann! , preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/藥物名稱").setValue(mann)
                                let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                for name in names {
                                    let action = UIAlertAction(title: name, style: .default) { (action) in
                                        print(action.title)
                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/吃藥時間").setValue(action.title)
                                        if action.title != "睡前"
                                        {
                                            let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                            let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("是")
                                                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                            controller.addAction(okAction)
                                            let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("否")
                                                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                            controller.addAction(cancelAction)
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                        else
                                        {
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("是")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        
                                    }
                                    controller.addAction(action)
                                }
                                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                controller.addAction(cancelAction)
                                self.present(controller, animated: true, completion: nil)
                            }
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            controller.addAction(okAction)
                            self.present(controller, animated: true, completion: nil)
                        }
                        else
                        {
                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/藥物名稱").setValue(mann)
                            let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                            let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                            for name in names {
                                let action = UIAlertAction(title: name, style: .default) { (action) in
                                    print(action.title)
                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/吃藥時間").setValue(action.title)
                                    if action.title != "睡前"
                                    {
                                        let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("是")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        controller.addAction(okAction)
                                        let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("否")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        controller.addAction(cancelAction)
                                        self.present(controller, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("是")
                                        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                    }
                                    
                                }
                                controller.addAction(action)
                            }
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            self.present(controller, animated: true, completion: nil)
                        }}
                case "6":
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let YN = DataSnapshot.value as! String

                        if YN != "暫無藥物"
                        {
                            let controller = UIAlertController(title: "第六格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + mann! , preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/藥物名稱").setValue(mann)
                                let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                for name in names {
                                    let action = UIAlertAction(title: name, style: .default) { (action) in
                                        print(action.title)
                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/吃藥時間").setValue(action.title)
                                        if action.title != "睡前"
                                        {
                                            let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                            let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/是否睡前服用").setValue("是")
                                                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                            controller.addAction(okAction)
                                            let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/是否睡前服用").setValue("否")
                                                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                            controller.addAction(cancelAction)
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                        else
                                        {
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/是否睡前服用").setValue("是")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        
                                    }
                                    controller.addAction(action)
                                }
                                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                controller.addAction(cancelAction)
                                self.present(controller, animated: true, completion: nil)
                            }
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            controller.addAction(okAction)
                            self.present(controller, animated: true, completion: nil)
                        }
                        else
                        {
                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/藥物名稱").setValue(mann)
                            let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                            let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                            for name in names {
                                let action = UIAlertAction(title: name, style: .default) { (action) in
                                    print(action.title)
                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/吃藥時間").setValue(action.title)
                                    if action.title != "睡前"
                                    {
                                        let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/是否睡前服用").setValue("是")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        controller.addAction(okAction)
                                        let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/是否睡前服用").setValue("否")
                                            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                        controller.addAction(cancelAction)
                                        self.present(controller, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/是否睡前服用").setValue("是")
                                        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
                                            self.present(controller, animated: true, completion: nil)
                                        }
                                    }
                                    
                                }
                                controller.addAction(action)
                            }
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            self.present(controller, animated: true, completion: nil)
                        }}
                default:
                    print("不可能啦")
                }}
            controller.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
        
        // handler: { action in self.performSegue(withIdentifier: "addbox", sender: self) }  跳轉回第一頁
    }

    @IBAction func getoutmymed(_ sender: Any) {
        
        var ref = Database.database().reference()
        self.ref.child("users").child(Auth.auth().currentUser!.uid).child("MyMedicine").child(String(describing: self.MySideeffect.text)).setValue(nil)
        //let alert = UIAlertController(title: "愛你呦><", message: "您已成功將藥物移除我的最愛", preferredStyle: .alert)  //顯示不出來的東東
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "nice") {
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}
