//
//  HealthDetailViewController.swift
//  medicine
//
//  Created by amkdajmal on 2020/12/6.
//  Copyright © 2020 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HealthDetailViewController: UIViewController {

    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var SickLabel: UILabel!
    @IBOutlet weak var MoneyLabel: UILabel!
    @IBOutlet weak var MedLabel1: UILabel!
    @IBOutlet weak var MedLabel2: UILabel!
    @IBOutlet weak var MedLabel3: UILabel!
    @IBOutlet weak var MedLabel4: UILabel!
    @IBOutlet weak var MedLabel5: UILabel!
    @IBOutlet weak var MedLabel6: UILabel!
    @IBOutlet weak var MedLabel7: UILabel!
    @IBOutlet weak var MedLabel8: UILabel!
    @IBOutlet weak var MedLabel9: UILabel!
    @IBOutlet weak var MedLabel10: UILabel!
    
    
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button4: UIButton!
    @IBOutlet weak var Button5: UIButton!
    @IBOutlet weak var Button6: UIButton!
    @IBOutlet weak var Button7: UIButton!
    @IBOutlet weak var Button8: UIButton!
    @IBOutlet weak var Button9: UIButton!
    @IBOutlet weak var Button10: UIButton!
    
    
    var infoFromViewOne1:String?
    var infoFromViewOne2:String?
    var infoFromViewOne3:String?
    var infoFromViewOne4:String?
    var infoFromViewOne5:[String]?
    
    var x1 : String?
    var x2 : String?
    var x3 : String?
    var x4 : String?
    var x5 : String?
    var x6 : String?
    var x7 : String?
    var x8 : String?
    var x9 : String?
    var x10 : String?
    
    override func viewDidLoad() {
    super.viewDidLoad()
        DateLabel.text = infoFromViewOne1
        NameLabel.text = infoFromViewOne2
        SickLabel.text = infoFromViewOne3
        MoneyLabel.text = infoFromViewOne4
        
        for _ in 1...(10-infoFromViewOne5!.count){
            infoFromViewOne5?.append("")
        }
        
        x1 = infoFromViewOne5?[0]
        x2 = infoFromViewOne5?[1]
        x3 = infoFromViewOne5?[2]
        x4 = infoFromViewOne5?[3]
        x5 = infoFromViewOne5?[4]
        x6 = infoFromViewOne5?[5]
        x7 = infoFromViewOne5?[6]
        x8 = infoFromViewOne5?[7]
        x9 = infoFromViewOne5?[8]
        x10 = infoFromViewOne5?[9]
        
        MedLabel1.text = x1
        MedLabel2.text = x2
        MedLabel3.text = x3
        MedLabel4.text = x4
        MedLabel5.text = x5
        MedLabel6.text = x6
        MedLabel7.text = x7
        MedLabel8.text = x8
        MedLabel9.text = x9
        MedLabel10.text = x10
        
        if x1 == ""{
            Button1.isHidden = true
        }
        if x2 == ""{
            Button2.isHidden = true
        }
        if x3 == ""{
            Button3.isHidden = true
        }
        if x4 == ""{
            Button4.isHidden = true
        }
        if x5 == ""{
            Button5.isHidden = true
        }
        if x6 == ""{
            Button6.isHidden = true
        }
        if x7 == ""{
            Button7.isHidden = true
        }
        if x8 == ""{
            Button8.isHidden = true
        }
        if x9 == ""{
            Button9.isHidden = true
        }
        if x10 == ""{
            Button10.isHidden = true
        }
        
    }
    
    @IBAction func ButtonAct1(_ sender: Any) {
        AddMed(x: x1!)
    }
    @IBAction func ButtonAct2(_ sender: Any) {
        AddMed(x: x2!)
    }
    @IBAction func ButtonAct3(_ sender: Any) {
        AddMed(x: x3!)
    }
    @IBAction func ButtonAct4(_ sender: Any) {
        AddMed(x: x4!)
    }
    @IBAction func ButtonAct5(_ sender: Any) {
        AddMed(x: x5!)
    }
    @IBAction func ButtonAct6(_ sender: Any) {
        AddMed(x: x6!)
    }
    @IBAction func ButtonAct7(_ sender: Any) {
        AddMed(x: x7!)
    }
    @IBAction func ButtonAct8(_ sender: Any) {
        AddMed(x: x8!)
    }
    @IBAction func ButtonAct9(_ sender: Any) {
        AddMed(x: x9!)
    }
    @IBAction func ButtonAct10(_ sender: Any) {
        AddMed(x: x10!)
    }
    
    func AddMed(x : String){
        var ref = Database.database().reference()
        var one : String = "1"
        var two : String = "2"
        var three : String = "3"
        var four : String = "4"
        var five : String = "5"
        var six : String = "6"
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
            let onebox = DataSnapshot.value as! String
            if onebox != "暫無藥物"{
                one = "1（\(onebox)）"
            }else{
                one = "1"
            }
            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                let twobox = DataSnapshot.value as! String
                if twobox != "暫無藥物"{
                    two = "2（\(twobox)）"
                }else{
                    two = "2"
                }
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let threebox = DataSnapshot.value as! String
                    if threebox != "暫無藥物"{
                        three = "3（\(threebox)）"
                    }else{
                        three = "3"
                    }
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let fourbox = DataSnapshot.value as! String
                        if fourbox != "暫無藥物"{
                            four = "4（\(fourbox)）"
                        }else{
                            four = "4"
                        }
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let fivebox = DataSnapshot.value as! String
                            if fivebox != "暫無藥物"{
                                five = "5（\(fivebox)）"
                            }else{
                                five = "5"
                            }
                            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                let sixbox = DataSnapshot.value as! String
                                if sixbox != "暫無藥物"{
                                    six = "6（\(sixbox)）"
                                }else{
                                    six = "6"
                                }
                                let controller = UIAlertController(title: "請選擇要加入的藥盒位置", message: "將" + x
                                    + "加入藥盒？" , preferredStyle: .actionSheet)
                                let names = [one,two,three,four,five,six]
                                for name in names {
                                    let action = UIAlertAction(title: name, style: .default) { (action) in
                                        print(action.title)
                                        switch action.title  {
                                        case one:
                                           ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                let YN = DataSnapshot.value as! String
                                            
                                            if YN != "暫無藥物"
                                            {
                                                let controller = UIAlertController(title: "第一格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + x , preferredStyle: .alert)
                                                let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                                    //self.Btn1.setTitle(cell, for: .normal)
                                                    //self.Btn1.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/藥物名稱").setValue(x)
                                                    let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                                    let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                                    for name in names {
                                                        let action = UIAlertAction(title: name, style: .default) { (action) in
                                                            //print(action.title)
                                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/吃藥時間").setValue(action.title)
                                                            if action.title != "睡前"
                                                            {
                                                                let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                                                let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("是")
                                                                }
                                                                controller.addAction(okAction)
                                                                let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("否")
                                                                }
                                                                controller.addAction(cancelAction)
                                                                self.present(controller, animated: true, completion: nil)
                                                            }
                                                            else
                                                            {
                                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("是")
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
                                            //self.Btn1.setTitle(cell, for: .normal)
                                            //self.Btn1.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/藥物名稱").setValue(x)
                                                let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                                let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                                for name in names {
                                                    let action = UIAlertAction(title: name, style: .default) { (action) in
                                                        //print(action.title)
                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/吃藥時間").setValue(action.title)
                                                        if action.title != "睡前"
                                                        {
                                                            let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                                            let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("是")
                                                            }
                                                            controller.addAction(okAction)
                                                            let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("否")
                                                            }
                                                            controller.addAction(cancelAction)
                                                            self.present(controller, animated: true, completion: nil)
                                                        }
                                                        else
                                                        {
                                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("是")
                                                        }
                                                    }
                                                    controller.addAction(action)
                                                }
                                                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                                controller.addAction(cancelAction)
                                                self.present(controller, animated: true, completion: nil)
                                            }
                                        }
                                            
                                        case two:
                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                let YN = DataSnapshot.value as! String
                                                
                                                if YN != "暫無藥物"
                                                {
                                                    let controller = UIAlertController(title: "第二格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + x , preferredStyle: .alert)
                                                    let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                                        //self.Btn2.setTitle(cell, for: .normal)
                                                        //self.Btn2.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/藥物名稱").setValue(x)
                                                        let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                                        let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                                        for name in names {
                                                            let action = UIAlertAction(title: name, style: .default) { (action) in
                                                                //print(action.title)
                                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/吃藥時間").setValue(action.title)
                                                                if action.title != "睡前"
                                                                {
                                                                    let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                                                    let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("是")
                                                                    }
                                                                    controller.addAction(okAction)
                                                                    let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("否")
                                                                    }
                                                                    controller.addAction(cancelAction)
                                                                    self.present(controller, animated: true, completion: nil)
                                                                }
                                                                else
                                                                {
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("是")
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
                                                    //self.Btn2.setTitle(cell, for: .normal)
                                                    //self.Btn2.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/藥物名稱").setValue(x)
                                                    let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                                    let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                                    for name in names {
                                                        let action = UIAlertAction(title: name, style: .default) { (action) in
                                                            //print(action.title)
                                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/吃藥時間").setValue(action.title)
                                                            if action.title != "睡前"
                                                            {
                                                                let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                                                let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("是")
                                                                }
                                                                controller.addAction(okAction)
                                                                let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("否")
                                                                }
                                                                controller.addAction(cancelAction)
                                                                self.present(controller, animated: true, completion: nil)
                                                            }
                                                            else
                                                            {
                                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("是")
                                                            }
                                                        }
                                                        controller.addAction(action)
                                                    }
                                                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                                    controller.addAction(cancelAction)
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                        case three:
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                    let YN = DataSnapshot.value as! String
                                                    if YN != "暫無藥物"
                                                    {
                                                        let controller = UIAlertController(title: "第三格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + x , preferredStyle: .alert)
                                                        let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                                            //self.Btn3.setTitle(cell, for: .normal)
                                                            //self.Btn3.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/藥物名稱").setValue(x)
                                                            let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                                            let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                                            for name in names {
                                                                let action = UIAlertAction(title: name, style: .default) { (action) in
                                                                    //print(action.title)
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/吃藥時間").setValue(action.title)
                                                                    if action.title != "睡前"
                                                                    {
                                                                        let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                                                        let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("是")
                                                                        }
                                                                        controller.addAction(okAction)
                                                                        let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("否")
                                                                        }
                                                                        controller.addAction(cancelAction)
                                                                        self.present(controller, animated: true, completion: nil)
                                                                    }
                                                                    else
                                                                    {
                                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("是")
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
                                                        //self.Btn3.setTitle(cell, for: .normal)
                                                        //self.Btn3.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/藥物名稱").setValue(x)
                                                        let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                                        let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                                        for name in names {
                                                            let action = UIAlertAction(title: name, style: .default) { (action) in
                                                                //print(action.title)
                                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/吃藥時間").setValue(action.title)
                                                                if action.title != "睡前"
                                                                {
                                                                    let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                                                    let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("是")
                                                                    }
                                                                    controller.addAction(okAction)
                                                                    let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("否")
                                                                    }
                                                                    controller.addAction(cancelAction)
                                                                    self.present(controller, animated: true, completion: nil)
                                                                }
                                                                else
                                                                {
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("是")
                                                                }
                                                            }
                                                            controller.addAction(action)
                                                        }
                                                        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                                        controller.addAction(cancelAction)
                                                        self.present(controller, animated: true, completion: nil)
                                                    }}
                                        case four:
                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                let YN = DataSnapshot.value as! String
                                                if YN != "暫無藥物"
                                                {
                                                    let controller = UIAlertController(title: "第四格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + x , preferredStyle: .alert)
                                                    let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                                        //self.Btn4.setTitle(cell, for: .normal)
                                                        //self.Btn4.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/藥物名稱").setValue(x)
                                                        let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                                        let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                                        for name in names {
                                                            let action = UIAlertAction(title: name, style: .default) { (action) in
                                                                //print(action.title)
                                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/吃藥時間").setValue(action.title)
                                                                if action.title != "睡前"
                                                                {
                                                                    let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                                                    let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("是")
                                                                    }
                                                                    controller.addAction(okAction)
                                                                    let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("否")
                                                                    }
                                                                    controller.addAction(cancelAction)
                                                                    self.present(controller, animated: true, completion: nil)
                                                                }
                                                                else
                                                                {
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("是")
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
                                                    //self.Btn4.setTitle(cell, for: .normal)
                                                    //self.Btn4.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/藥物名稱").setValue(x)
                                                    let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                                    let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                                    for name in names {
                                                        let action = UIAlertAction(title: name, style: .default) { (action) in
                                                            //print(action.title)
                                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/吃藥時間").setValue(action.title)
                                                            if action.title != "睡前"
                                                            {
                                                                let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                                                let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("是")
                                                                }
                                                                controller.addAction(okAction)
                                                                let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("否")
                                                                }
                                                                controller.addAction(cancelAction)
                                                                self.present(controller, animated: true, completion: nil)
                                                            }
                                                            else
                                                            {
                                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("是")
                                                            }
                                                        }
                                                        controller.addAction(action)
                                                    }
                                                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                                    controller.addAction(cancelAction)
                                                    self.present(controller, animated: true, completion: nil)
                                                }}
                                        case five:
                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                let YN = DataSnapshot.value as! String
                                                if YN != "暫無藥物"
                                                {
                                                    let controller = UIAlertController(title: "第五格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + x , preferredStyle: .alert)
                                                    let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                                        //self.Btn5.setTitle(cell, for: .normal)
                                                        //self.Btn5.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/藥物名稱").setValue(x)
                                                        let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                                        let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                                        for name in names {
                                                            let action = UIAlertAction(title: name, style: .default) { (action) in
                                                                //print(action.title)
                                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/吃藥時間").setValue(action.title)
                                                                if action.title != "睡前"
                                                                {
                                                                    let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                                                    let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("是")
                                                                    }
                                                                    controller.addAction(okAction)
                                                                    let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("否")
                                                                    }
                                                                    controller.addAction(cancelAction)
                                                                    self.present(controller, animated: true, completion: nil)
                                                                }
                                                                else
                                                                {
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("是")
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
                                                    //self.Btn5.setTitle(cell, for: .normal)
                                                    //self.Btn5.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/藥物名稱").setValue(x)
                                                    let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                                    let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                                    for name in names {
                                                        let action = UIAlertAction(title: name, style: .default) { (action) in
                                                            //print(action.title)
                                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/吃藥時間").setValue(action.title)
                                                            if action.title != "睡前"
                                                            {
                                                                let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                                                let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("是")
                                                                }
                                                                controller.addAction(okAction)
                                                                let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("否")
                                                                }
                                                                controller.addAction(cancelAction)
                                                                self.present(controller, animated: true, completion: nil)
                                                            }
                                                            else
                                                            {
                                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("是")
                                                            }
                                                        }
                                                        controller.addAction(action)
                                                    }
                                                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                                    controller.addAction(cancelAction)
                                                    self.present(controller, animated: true, completion: nil)
                                                }}
                                        case six:
                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                let YN = DataSnapshot.value as! String
                                                if YN != "暫無藥物"
                                                {
                                                    let controller = UIAlertController(title: "第六格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + x , preferredStyle: .alert)
                                                    let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                                        //self.Btn6.setTitle(cell, for: .normal)
                                                        //self.Btn6.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/藥物名稱").setValue(x)
                                                        let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
                                                        let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
                                                        for name in names {
                                                            let action = UIAlertAction(title: name, style: .default) { (action) in
                                                                //print(action.title)
                                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/吃藥時間").setValue(action.title)
                                                                if action.title != "睡前"
                                                                {
                                                                    let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
                                                                    let okAction = UIAlertAction(title: "是", style: .default) { (_) in
                                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/是否睡前服用").setValue("是")
                                                                    }
                                                                    controller.addAction(okAction)
                                                                    let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/是否睡前服用").setValue("否")
                                                                    }
                                                                    controller.addAction(cancelAction)
                                                                    self.present(controller, animated: true, completion: nil)
                                                                }
                                                                else
                                                                {
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/是否睡前服用").setValue("是")
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
                                                    //self.Btn6.setTitle(cell, for: .normal)
                                                    //self.Btn6.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/藥物名稱").setValue(x)
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
                                                                }
                                                                controller.addAction(okAction)
                                                                let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
                                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/是否睡前服用").setValue("否")
                                                                }
                                                                controller.addAction(cancelAction)
                                                                self.present(controller, animated: true, completion: nil)
                                                            }
                                                            else
                                                            {
                                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/是否睡前服用").setValue("是")
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
                                self.present(controller, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        
        
    }
    }
}
