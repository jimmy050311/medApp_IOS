//
//  ClassifierViewController.swift
//  medicine
//
//  Created by amkdajmal on 2020/9/9.
//  Copyright © 2020 amkdajmal. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Firebase
import FirebaseDatabase

class ClassifierViewController: UIViewController, UIGestureRecognizerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var ClassifierImage: UIImageView!
    @IBOutlet weak var ClassifierText: UILabel!
    @IBOutlet weak var AddBoxButton: UIButton!
    @IBOutlet weak var NewButton: UIButton!
    
    var model : Medicine19!  //辨識Model 15可以
    var nameText : String = ""
    var answer : String = "Others"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref = Database.database().reference()
        
        AddBoxButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        AddBoxButton.layer.cornerRadius = 20
        AddBoxButton.layer.borderWidth = 1
        AddBoxButton.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            
        NewButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        NewButton.layer.cornerRadius = 20
        NewButton.layer.borderWidth = 1
        NewButton.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "家屬"{
                self.AddBoxButton.isHidden = true
            }else{
                self.AddBoxButton.isHidden = false
            }
        }
        
        if nameText == "從相簿選擇" {
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = .photoLibrary
            present(picker, animated: true)
        } else if nameText == "從相機拍攝" {
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                return
            }
            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.sourceType = .camera
            cameraPicker.allowsEditing = true
            self.present(cameraPicker, animated: true, completion: nil)
        }
        
        if answer == "Others"{
            AddBoxButton.isEnabled = false
        } else {
            AddBoxButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model = Medicine19()  //辨識Model 15可以
        print("aaaaaaa")
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
        print("cancel")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            return
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
                
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3 
                
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
                
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        ClassifierImage.image = newImage
        
        
        guard let prediction = try? model.prediction(image: pixelBuffer!) else {
            return
        }
//        var count = Int(prediction.classLabelProbs[prediction.classLabel]!) * 100
//        print(count)
        ClassifierText.text = "本藥物最有可能是\(prediction.classLabel) : \(round(prediction.classLabelProbs[prediction.classLabel]! * 100)) %."
        if round(prediction.classLabelProbs[prediction.classLabel]! * 100) != 100{
            var myArr = Array(prediction.classLabelProbs.keys)
            var sortedKeys = myArr.sorted() {
                var obj1 = prediction.classLabelProbs[$0] // get ob associated w/ key 1
                var obj2 = prediction.classLabelProbs[$1] // get ob associated w/ key 2
                return obj1! > obj2!
            }
            ClassifierText.text! += "\n第二名：\(sortedKeys[1])"
        }
        //print("\(prediction.classLabelProbs)")
                
        answer = prediction.classLabel
        if answer == "Others"{
            AddBoxButton.isEnabled = false
        } else {
            AddBoxButton.isEnabled = true
        }


    }
    @IBAction func AddToBox(_ sender: Any) {
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
                                let controller = UIAlertController(title: "請選擇要加入的藥盒位置", message: "將" + self.answer + "加入藥盒？" , preferredStyle: .actionSheet)
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
                                                let controller = UIAlertController(title: "第一格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + self.answer , preferredStyle: .alert)
                                                let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                                    //self.Btn1.setTitle(cell, for: .normal)
                                                    //self.Btn1.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/藥物名稱").setValue(self.answer)
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
                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/藥物名稱").setValue(self.answer)
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
                                                    let controller = UIAlertController(title: "第二格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + self.answer , preferredStyle: .alert)
                                                    let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                                        //self.Btn2.setTitle(cell, for: .normal)
                                                        //self.Btn2.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/藥物名稱").setValue(self.answer)
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
                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/藥物名稱").setValue(self.answer)
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
                                                        let controller = UIAlertController(title: "第三格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + self.answer , preferredStyle: .alert)
                                                        let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                                            //self.Btn3.setTitle(cell, for: .normal)
                                                            //self.Btn3.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/藥物名稱").setValue(self.answer)
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
                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/藥物名稱").setValue(self.answer)
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
                                                    let controller = UIAlertController(title: "第四格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + self.answer , preferredStyle: .alert)
                                                    let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                                        //self.Btn4.setTitle(cell, for: .normal)
                                                        //self.Btn4.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/藥物名稱").setValue(self.answer)
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
                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/藥物名稱").setValue(self.answer)
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
                                                    let controller = UIAlertController(title: "第五格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + self.answer , preferredStyle: .alert)
                                                    let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                                        //self.Btn5.setTitle(cell, for: .normal)
                                                        //self.Btn5.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/藥物名稱").setValue(self.answer)
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
                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/藥物名稱").setValue(self.answer)
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
                                                    let controller = UIAlertController(title: "第六格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + self.answer , preferredStyle: .alert)
                                                    let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                                        //self.Btn6.setTitle(cell, for: .normal)
                                                        //self.Btn6.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/藥物名稱").setValue(self.answer)
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
                                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/藥物名稱").setValue(self.answer)
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
    
    @IBAction func Reset(_ sender: Any) {
        let controller = UIAlertController(title: "藥物辨識", message: "請選擇欲辨識藥物圖片來源?\n" + "請選擇白色為底的圖片", preferredStyle: .actionSheet)
        let names = ["從相機拍攝", "從相簿選擇"]
        for name in names {
           let action = UIAlertAction(title: name, style: .default) { (action) in
              print(action.title)
              switch action.title  {
                 case "從相機拍攝":
                    print("camera")
                    if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                        return
                    }

                    let cameraPicker = UIImagePickerController()
                    cameraPicker.delegate = self
                    cameraPicker.sourceType = .camera
                    cameraPicker.allowsEditing = true
                    self.present(cameraPicker, animated: true, completion: nil)
                 case "從相簿選擇":
                    print("photo")
                    let picker = UIImagePickerController()
                    picker.allowsEditing = false
                    picker.delegate = self
                    picker.sourceType = .photoLibrary
                    self.present(picker, animated: true)
                 default:
                    print("不可能啦")
            }
            }
           controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
        
        
    }
}

