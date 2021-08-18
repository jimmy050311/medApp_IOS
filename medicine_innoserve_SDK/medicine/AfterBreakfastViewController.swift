//
//  AfterBreakfastViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/11/25.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//
//早餐後那面
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AfterBreakfastViewController: UIViewController{
    
    @IBOutlet weak var box1Label: UILabel!
    @IBOutlet weak var box2Label: UILabel!
    @IBOutlet weak var box3Label: UILabel!
    @IBOutlet weak var box4Label: UILabel!
    @IBOutlet weak var box5Label: UILabel!
    @IBOutlet weak var box6Label: UILabel!
    @IBOutlet weak var box1Button: CheckBox!
    @IBOutlet weak var box2Button: CheckBox!
    @IBOutlet weak var box3Button: CheckBox!
    @IBOutlet weak var box4Button: CheckBox!
    @IBOutlet weak var box5Button: CheckBox!
    @IBOutlet weak var box6Button: CheckBox!
    @IBOutlet weak var AllButton: CheckBox!
    @IBOutlet weak var ConfirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfirmButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ConfirmButton.layer.cornerRadius = 25
        ConfirmButton.layer.borderWidth = 1
        ConfirmButton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
        let ref = Database.database().reference()
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let box1time = DataSnapshot.value as! String
            print("\(box1time)")
            if box1time != "三餐飯後"{
                if box1time != "早晚飯後"{
                    self.box1Label.isHidden = true
                    self.box1Button.isHidden = true
                }else if box1time == "早晚飯後"{
                    let userID = Auth.auth().currentUser?.uid
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let boxid = DataSnapshot.value as! String
                        if boxid == "amkdajdal"{
                            ref.child("boxes").child(boxid).child("ONE").observeSingleEvent(of: .value, with: { snapshot in
                                let box1array = snapshot.value as! NSArray
                                var box1objCArray = NSMutableArray(array: box1array)
                                let box1swiftArray: [Double] = box1objCArray.compactMap({ $0 as? Double })
                                let box1lastdata = box1swiftArray[(box1swiftArray.count) - 1]
                                let box1lastseconddata = box1swiftArray[(box1swiftArray.count) - 2]
                                if box1lastdata - box1lastseconddata > 400 {
                                    print("alreadly ate box 1")
                                    self.box1Label.isHidden = true
                                    self.box1Button.isHidden = true
                                }else if box1lastdata - box1lastseconddata <= 400 {
                                    print("go to eat box 1")
                                    self.box1Label.isHidden = false
                                    self.box1Button.isHidden = false
                                }
                            })
                        }else{
                            print("尚未設定")
                        }
                    }
                }
            }else if box1time == "三餐飯後"{
                let userID = Auth.auth().currentUser?.uid
                ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let boxid = DataSnapshot.value as! String
                    if boxid == "amkdajdal"{
                        ref.child("boxes").child(boxid).child("ONE").observeSingleEvent(of: .value, with: { snapshot in
                            let box1array = snapshot.value as! NSArray
                            var box1objCArray = NSMutableArray(array: box1array)
                            let box1swiftArray: [Double] = box1objCArray.compactMap({ $0 as? Double })
                            let box1lastdata = box1swiftArray[(box1swiftArray.count) - 1]
                            let box1lastseconddata = box1swiftArray[(box1swiftArray.count) - 2]
                            if box1lastdata - box1lastseconddata > 400 {
                                print("alreadly ate box 1")
                                self.box1Label.isHidden = true
                                self.box1Button.isHidden = true
                            }else if box1lastdata - box1lastseconddata <= 400 {
                                print("go to eat box 1")
                                self.box1Label.isHidden = false
                                self.box1Button.isHidden = false
                            }
                        })
                    }else{
                        print("尚未設定")
                    }
                }
            }
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let box2time = DataSnapshot.value as! String
            print("\(box2time)")
            if box2time != "三餐飯後"{
                if box2time != "早晚飯後"{
                    self.box2Label.isHidden = true
                    self.box2Button.isHidden = true
                }else if box2time == "早晚飯後"{
                    let userID = Auth.auth().currentUser?.uid
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let boxid = DataSnapshot.value as! String
                        if boxid == "amkdajdal"{
                            ref.child("boxes").child(boxid).child("TWO").observeSingleEvent(of: .value, with: { snapshot in
                                let box2array = snapshot.value as! NSArray
                                var box2objCArray = NSMutableArray(array: box2array)
                                let box2swiftArray: [Double] = box2objCArray.compactMap({ $0 as? Double })
                                let box2lastdata = box2swiftArray[(box2swiftArray.count) - 1]
                                let box2lastseconddata = box2swiftArray[(box2swiftArray.count) - 2]
                                if box2lastdata - box2lastseconddata > 400 {
                                    print("alreadly ate box 2")
                                    self.box2Label.isHidden = true
                                    self.box2Button.isHidden = true
                                }else if box2lastdata - box2lastseconddata <= 400 {
                                    print("go to eat box 2")
                                    self.box2Label.isHidden = false
                                    self.box2Button.isHidden = false
                                }
                            })
                        }else{
                            print("尚未設定")
                        }
                    }
                }
            }else if box2time == "三餐飯後"{
                let userID = Auth.auth().currentUser?.uid
                ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let boxid = DataSnapshot.value as! String
                    if boxid == "amkdajdal"{
                        ref.child("boxes").child(boxid).child("TWO").observeSingleEvent(of: .value, with: { snapshot in
                            let box2array = snapshot.value as! NSArray
                            var box2objCArray = NSMutableArray(array: box2array)
                            let box2swiftArray: [Double] = box2objCArray.compactMap({ $0 as? Double })
                            let box2lastdata = box2swiftArray[(box2swiftArray.count) - 1]
                            let box2lastseconddata = box2swiftArray[(box2swiftArray.count) - 2]
                            if box2lastdata - box2lastseconddata > 400 {
                                print("alreadly ate box 2")
                                self.box2Label.isHidden = true
                                self.box2Button.isHidden = true
                            }else if box2lastdata - box2lastseconddata <= 400 {
                                print("go to eat box 2")
                                self.box2Label.isHidden = false
                                self.box2Button.isHidden = false
                            }
                        })
                    }else{
                        print("尚未設定")
                    }
                }
            }
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let box3time = DataSnapshot.value as! String
            print("\(box3time)")
            if box3time != "三餐飯後"{
                if box3time != "早晚飯後"{
                    self.box3Label.isHidden = true
                    self.box3Button.isHidden = true
                }else if box3time == "早晚飯後"{
                    let userID = Auth.auth().currentUser?.uid
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let boxid = DataSnapshot.value as! String
                        if boxid == "amkdajdal"{
                            ref.child("boxes").child(boxid).child("THREE").observeSingleEvent(of: .value, with: { snapshot in
                                let box3array = snapshot.value as! NSArray
                                var box3objCArray = NSMutableArray(array: box3array)
                                let box3swiftArray: [Double] = box3objCArray.compactMap({ $0 as? Double })
                                let box3lastdata = box3swiftArray[(box3swiftArray.count) - 1]
                                let box3lastseconddata = box3swiftArray[(box3swiftArray.count) - 2]
                                if box3lastdata - box3lastseconddata > 1300 {  //B群
                                    print("alreadly ate box 3")
                                    self.box3Label.isHidden = true
                                    self.box3Button.isHidden = true
                                }else if box3lastdata - box3lastseconddata <= 1300 {  //B群
                                    print("go to eat box 3")
                                    self.box3Label.isHidden = false
                                    self.box3Button.isHidden = false
                                }
                            })
                        }else{
                            print("尚未設定")
                        }
                    }
                }
            }else if box3time == "三餐飯後"{
                let userID = Auth.auth().currentUser?.uid
                ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let boxid = DataSnapshot.value as! String
                    if boxid == "amkdajdal"{
                        ref.child("boxes").child(boxid).child("THREE").observeSingleEvent(of: .value, with: { snapshot in
                            let box3array = snapshot.value as! NSArray
                            var box3objCArray = NSMutableArray(array: box3array)
                            let box3swiftArray: [Double] = box3objCArray.compactMap({ $0 as? Double })
                            let box3lastdata = box3swiftArray[(box3swiftArray.count) - 1]
                            let box3lastseconddata = box3swiftArray[(box3swiftArray.count) - 2]
                            if box3lastdata - box3lastseconddata > 1300 {  //B群
                                print("alreadly ate box 3")
                                self.box3Label.isHidden = true
                                self.box3Button.isHidden = true
                            }else if box3lastdata - box3lastseconddata <= 1300 {  //B群
                                print("go to eat box 3")
                                self.box3Label.isHidden = false
                                self.box3Button.isHidden = false
                            }
                        })
                    }else{
                        print("尚未設定")
                    }
                }
            }
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let box4time = DataSnapshot.value as! String
            print("\(box4time)")
            if box4time != "三餐飯後"{
                if box4time != "早晚飯後"{
                    self.box4Label.isHidden = true
                    self.box4Button.isHidden = true
                }else if box4time == "早晚飯後"{
                    let userID = Auth.auth().currentUser?.uid
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let boxid = DataSnapshot.value as! String
                        if boxid == "amkdajdal"{
                            ref.child("boxes").child(boxid).child("FOUR").observeSingleEvent(of: .value, with: { snapshot in
                                let box4array = snapshot.value as! NSArray
                                var box4objCArray = NSMutableArray(array: box4array)
                                let box4swiftArray: [Double] = box4objCArray.compactMap({ $0 as? Double })
                                let box4lastdata = box4swiftArray[(box4swiftArray.count) - 1]
                                let box4lastseconddata = box4swiftArray[(box4swiftArray.count) - 2]
                                if box4lastseconddata - box4lastdata > 5 {
                                    print("alreadly ate box 4")
                                    self.box4Label.isHidden = true
                                    self.box4Button.isHidden = true
                                }else if box4lastseconddata - box4lastdata <= 5 {
                                    print("go to eat box 4")
                                    self.box4Label.isHidden = false
                                    self.box4Button.isHidden = false
                                }
                            })
                        }else{
                            print("尚未設定")
                        }
                    }
                }
            }else if box4time == "三餐飯後"{
                let userID = Auth.auth().currentUser?.uid
                ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let boxid = DataSnapshot.value as! String
                    if boxid == "amkdajdal"{
                        ref.child("boxes").child(boxid).child("FOUR").observeSingleEvent(of: .value, with: { snapshot in
                            let box4array = snapshot.value as! NSArray
                            var box4objCArray = NSMutableArray(array: box4array)
                            let box4swiftArray: [Double] = box4objCArray.compactMap({ $0 as? Double })
                            let box4lastdata = box4swiftArray[(box4swiftArray.count) - 1]
                            let box4lastseconddata = box4swiftArray[(box4swiftArray.count) - 2]
                            if box4lastseconddata - box4lastdata > 5 {
                                print("alreadly ate box 4")
                                self.box4Label.isHidden = true
                                self.box4Button.isHidden = true
                            }else if box4lastseconddata - box4lastdata <= 5 {
                                print("go to eat box 4")
                                self.box4Label.isHidden = false
                                self.box4Button.isHidden = false
                            }
                        })
                    }else{
                        print("尚未設定")
                    }
                }
            }
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let box5time = DataSnapshot.value as! String
            print("\(box5time)")
            if box5time != "三餐飯後"{
                if box5time != "早晚飯後"{
                    self.box5Label.isHidden = true
                    self.box5Button.isHidden = true
                }else if box5time == "早晚飯後"{
                    let userID = Auth.auth().currentUser?.uid
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let boxid = DataSnapshot.value as! String
                        if boxid == "amkdajdal"{
                            ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                let box5array = snapshot.value as! NSArray
                                var box5objCArray = NSMutableArray(array: box5array)
                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                if box5lastseconddata - box5lastdata > 5 {
                                    print("alreadly ate box 5")
                                    self.box5Label.isHidden = true
                                    self.box5Button.isHidden = true
                                }else if box5lastseconddata - box5lastdata <= 5 {
                                    print("go to eat box 5")
                                    self.box5Label.isHidden = false
                                    self.box5Button.isHidden = false
                                }
                            })
                        }else{
                            print("尚未設定")
                        }
                    }
                }
            }else if box5time == "三餐飯後"{
                let userID = Auth.auth().currentUser?.uid
                ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let boxid = DataSnapshot.value as! String
                    if boxid == "amkdajdal"{
                        ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                            let box5array = snapshot.value as! NSArray
                            var box5objCArray = NSMutableArray(array: box5array)
                            let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                            let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                            let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                            if box5lastseconddata - box5lastdata > 5 {
                                print("alreadly ate box 5")
                                self.box5Label.isHidden = true
                                self.box5Button.isHidden = true
                            }else if box5lastseconddata - box5lastdata <= 5 {
                                print("go to eat box 5")
                                self.box5Label.isHidden = false
                                self.box5Button.isHidden = false
                            }
                        })
                    }else{
                        print("尚未設定")
                    }
                }
            }
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let box6time = DataSnapshot.value as! String
            print("\(box6time)")
            if box6time != "三餐飯後"{
                if box6time != "早晚飯後"{
                    self.box6Label.isHidden = true
                    self.box6Button.isHidden = true
                }else if box6time == "早晚飯後"{
                    let userID = Auth.auth().currentUser?.uid
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let boxid = DataSnapshot.value as! String
                        if boxid == "amkdajdal"{
                            ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                let box6array = snapshot.value as! NSArray
                                var box6objCArray = NSMutableArray(array: box6array)
                                let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                if box6lastseconddata - box6lastdata > 5 {
                                    print("alreadly ate box 6")
                                    self.box6Label.isHidden = true
                                    self.box6Button.isHidden = true
                                }else if box6lastseconddata - box6lastdata <= 5 {
                                    print("go to eat box 6")
                                    self.box6Label.isHidden = false
                                    self.box6Button.isHidden = false
                                }
                            })
                        }else{
                            print("尚未設定")
                        }
                    }
                }
            }else if box6time == "三餐飯後"{
                let userID = Auth.auth().currentUser?.uid
                ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let boxid = DataSnapshot.value as! String
                    if boxid == "amkdajdal"{
                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                            let box6array = snapshot.value as! NSArray
                            var box6objCArray = NSMutableArray(array: box6array)
                            let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                            let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                            let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                            if box6lastseconddata - box6lastdata > 5 {
                                print("alreadly ate box 6")
                                self.box6Label.isHidden = true
                                self.box6Button.isHidden = true
                            }else if box6lastseconddata - box6lastdata <= 5 {
                                print("go to eat box 6")
                                self.box6Label.isHidden = false
                                self.box6Button.isHidden = false
                            }
                        })
                    }else{
                        print("尚未設定")
                    }
                }
            }
        }
    }
    
    @IBAction func Checkall(_ sender: Any) {
        if AllButton.isChecked == false{
            self.box1Button.isChecked = true
            self.box2Button.isChecked = true
            self.box3Button.isChecked = true
            self.box4Button.isChecked = true
            self.box5Button.isChecked = true
            self.box6Button.isChecked = true
        }else if AllButton.isChecked == true{
            self.box1Button.isChecked = false
            self.box2Button.isChecked = false
            self.box3Button.isChecked = false
            self.box4Button.isChecked = false
            self.box5Button.isChecked = false
            self.box6Button.isChecked = false
        }
    }
    @IBAction func ieatit(_ sender: Any) {
        // 建立時間格式
        let now:Date = Date()
        let dateFormat1:DateFormatter = DateFormatter()
        let dateFormat2:DateFormatter = DateFormatter()
        dateFormat1.dateFormat = "yy/MM/dd"
        dateFormat2.dateFormat = "HH:mm"
        // 將當下時間轉換成設定的時間格式
        
        let dateString1:String = dateFormat1.string(from: now)
        let dateString2:String = dateFormat2.string(from: now)
        print("現在時間：\(dateString1)") // 現在時間：2018年01月29日 15:34:23 //不明原因print不出來
        print("aaaaaaaaaaaa")      //不明原因print不出來
        
        let ref = Database.database().reference()
        if box1Button.isHidden == false{
            if box1Button.isChecked == true{
                let autoid = ref.childByAutoId().key
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box1").child(autoid!).child("Date").setValue("\(dateString1)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box1").child(autoid!).child("Take").setValue("是")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box1").child(autoid!).child("Time").setValue("\(dateString2)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box1").child(autoid!).child("count").setValue("1")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box1").child(autoid!).child("Name").setValue("\(name)")
                }
            }
            if box1Button.isChecked == false{
                let autoid = ref.childByAutoId().key
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box1").child(autoid!).child("Date").setValue("\(dateString1)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box1").child(autoid!).child("Take").setValue("否")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box1").child(autoid!).child("Time").setValue("\(dateString2)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box1").child(autoid!).child("count").setValue("1")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box1").child(autoid!).child("Name").setValue("\(name)")
                }
            }
        }
        if box2Button.isHidden == false{
            if box2Button.isChecked == true{
                let autoid = ref.childByAutoId().key
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box2").child(autoid!).child("Date").setValue("\(dateString1)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box2").child(autoid!).child("Take").setValue("是")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box2").child(autoid!).child("Time").setValue("\(dateString2)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box2").child(autoid!).child("count").setValue("2")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box2").child(autoid!).child("Name").setValue("\(name)")
                }
            }
            if box2Button.isChecked == false{
                let autoid = ref.childByAutoId().key
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box2").child(autoid!).child("Date").setValue("\(dateString1)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box2").child(autoid!).child("Take").setValue("否")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box2").child(autoid!).child("Time").setValue("\(dateString2)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box2").child(autoid!).child("count").setValue("2")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box2").child(autoid!).child("Name").setValue("\(name)")
                }
            }
        }
        if box3Button.isHidden == false{
            if box3Button.isChecked == true{
                let autoid = ref.childByAutoId().key
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box3").child(autoid!).child("Date").setValue("\(dateString1)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box3").child(autoid!).child("Take").setValue("是")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box3").child(autoid!).child("Time").setValue("\(dateString2)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box3").child(autoid!).child("count").setValue("3")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box3").child(autoid!).child("Name").setValue("\(name)")
                }
            }
            if box3Button.isChecked == false{
                let autoid = ref.childByAutoId().key
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box3").child(autoid!).child("Date").setValue("\(dateString1)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box3").child(autoid!).child("Take").setValue("否")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box3").child(autoid!).child("Time").setValue("\(dateString2)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box3").child(autoid!).child("count").setValue("3")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box3").child(autoid!).child("Name").setValue("\(name)")
                }
            }
        }
        if box4Button.isHidden == false{
            if box4Button.isChecked == true{
                let autoid = ref.childByAutoId().key
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box4").child(autoid!).child("Date").setValue("\(dateString1)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box4").child(autoid!).child("Take").setValue("是")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box4").child(autoid!).child("Time").setValue("\(dateString2)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box4").child(autoid!).child("count").setValue("4")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box4").child(autoid!).child("Name").setValue("\(name)")
                }
            }
            if box4Button.isChecked == false{
                let autoid = ref.childByAutoId().key
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box4").child(autoid!).child("Date").setValue("\(dateString1)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box4").child(autoid!).child("Take").setValue("否")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box4").child(autoid!).child("Time").setValue("\(dateString2)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box4").child(autoid!).child("count").setValue("4")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box4").child(autoid!).child("Name").setValue("\(name)")
                }
            }
        }
        if box5Button.isHidden == false{
            if box5Button.isChecked == true{
                let autoid = ref.childByAutoId().key
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box5").child(autoid!).child("Take").setValue("是")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box5").child(autoid!).child("count").setValue("3")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box5").child(autoid!).child("Name").setValue("\(name)")
                }
            }
            if box5Button.isChecked == false{
                let autoid = ref.childByAutoId().key
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box5").child(autoid!).child("Take").setValue("否")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box5").child(autoid!).child("count").setValue("3")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box5").child(autoid!).child("Name").setValue("\(name)")
                }
            }
        }
        if box6Button.isHidden == false{
            if box6Button.isChecked == true{
                let autoid = ref.childByAutoId().key
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box6").child(autoid!).child("Take").setValue("是")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box6").child(autoid!).child("count").setValue("3")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box6").child(autoid!).child("Name").setValue("\(name)")
                }
            }
            if box6Button.isChecked == false{
                let autoid = ref.childByAutoId().key
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box6").child(autoid!).child("Take").setValue("否")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box6").child(autoid!).child("count").setValue("3")
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child("box6").child(autoid!).child("Name").setValue("\(name)")
                }
            }
        }
    }
}
