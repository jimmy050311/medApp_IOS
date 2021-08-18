//
//  ConversationViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/11/9.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//
//睡前那面
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class BeforeBedViewController: UIViewController{
    
    @IBOutlet weak var Box1Label: UILabel!
    @IBOutlet weak var Box2Label: UILabel!
    @IBOutlet weak var Box3Label: UILabel!
    @IBOutlet weak var Box4Label: UILabel!
    @IBOutlet weak var Box5Label: UILabel!
    @IBOutlet weak var Box6Label: UILabel!
    @IBOutlet weak var Box1Button: CheckBox!
    @IBOutlet weak var Box2Button: CheckBox!
    @IBOutlet weak var Box3Button: CheckBox!
    @IBOutlet weak var Box4Button: CheckBox!
    @IBOutlet weak var Box5Button: CheckBox!
    @IBOutlet weak var Box6Button: CheckBox!
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
            if box1time != "睡前"{
                self.Box1Label.isHidden = true
                self.Box1Button.isHidden = true
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box1sleep = DataSnapshot.value as! String
                    if box1sleep == "是"{
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
                                        self.Box1Label.isHidden = true
                                        self.Box1Button.isHidden = true
                                    }else if box1lastdata - box1lastseconddata <= 400 {
                                        print("go to eat box 1")
                                        self.Box1Label.isHidden = false
                                        self.Box1Button.isHidden = false
                                    }
                                })
                            }else{
                                print("尚未設定")
                            }
                        }
                    }else if box1sleep == "否"{
                        self.Box1Label.isHidden = true
                        self.Box1Button.isHidden = true
                    }
                }
            }else if box1time == "睡前"{
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
                                self.Box1Label.isHidden = true
                                self.Box1Button.isHidden = true
                            }else if box1lastdata - box1lastseconddata <= 400 {
                                print("go to eat box 1")
                                self.Box1Label.isHidden = false
                                self.Box1Button.isHidden = false
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
            if box2time != "睡前"{
                self.Box2Label.isHidden = true
                self.Box2Button.isHidden = true
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box2sleep = DataSnapshot.value as! String
                    if box2sleep == "是"{
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
                                        self.Box2Label.isHidden = true
                                        self.Box2Button.isHidden = true
                                    }else if box2lastdata - box2lastseconddata <= 400 {
                                        print("go to eat box 2")
                                        self.Box2Label.isHidden = false
                                        self.Box2Button.isHidden = false
                                    }
                                })
                            }else{
                                print("尚未設定")
                            }
                        }
                    }else if box2sleep == "否"{
                        self.Box2Label.isHidden = true
                        self.Box2Button.isHidden = true
                    }
                }
            }else if box2time == "睡前"{
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
                                self.Box2Label.isHidden = true
                                self.Box2Button.isHidden = true
                            }else if box2lastdata - box2lastseconddata <= 400 {
                                print("go to eat box 2")
                                self.Box2Label.isHidden = false
                                self.Box2Button.isHidden = false
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
            if box3time != "睡前"{
                self.Box3Label.isHidden = true
                self.Box3Button.isHidden = true
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box3sleep = DataSnapshot.value as! String
                    if box3sleep == "是"{
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
                                        self.Box3Label.isHidden = true
                                        self.Box3Button.isHidden = true
                                    }else if box3lastdata - box3lastseconddata <= 1300 {  //B群
                                        print("go to eat box 3")
                                        self.Box3Label.isHidden = false
                                        self.Box3Button.isHidden = false
                                    }
                                })
                            }else{
                                print("尚未設定")
                            }
                        }
                    }else if box3sleep == "否"{
                        self.Box3Label.isHidden = true
                        self.Box3Button.isHidden = true
                    }
                }
            }else if box3time == "睡前"{
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
                                self.Box3Label.isHidden = true
                                self.Box3Button.isHidden = true
                            }else if box3lastdata - box3lastseconddata <= 1300 {  //B群
                                print("go to eat box 3")
                                self.Box3Label.isHidden = false
                                self.Box3Button.isHidden = false
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
            if box4time != "睡前"{
                self.Box4Label.isHidden = true
                self.Box4Button.isHidden = true
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box4sleep = DataSnapshot.value as! String
                    if box4sleep == "是"{
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
                                    if box4lastdata - box4lastseconddata > 5 {
                                        print("alreadly ate box 4")
                                        self.Box4Label.isHidden = true
                                        self.Box4Button.isHidden = true
                                    }else if box4lastdata - box4lastseconddata <= 5 {
                                        print("go to eat box 4")
                                        self.Box4Label.isHidden = false
                                        self.Box4Button.isHidden = false
                                    }
                                })
                            }else{
                                print("尚未設定")
                            }
                        }
                    }else if box4sleep == "否"{
                        self.Box4Label.isHidden = true
                        self.Box4Button.isHidden = true
                    }
                }
            }else if box4time == "睡前"{
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
                                self.Box4Label.isHidden = true
                                self.Box4Button.isHidden = true
                            }else if box4lastseconddata - box4lastdata <= 5 {
                                print("go to eat box 4")
                                self.Box4Label.isHidden = false
                                self.Box4Button.isHidden = false
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
            if box5time != "睡前"{
                self.Box5Label.isHidden = true
                self.Box5Button.isHidden = true
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box5sleep = DataSnapshot.value as! String
                    if box5sleep == "是"{
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
                                        self.Box5Label.isHidden = true
                                        self.Box5Button.isHidden = true
                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                        print("go to eat box 5")
                                        self.Box5Label.isHidden = false
                                        self.Box5Button.isHidden = false
                                    }
                                })
                            }else{
                                print("尚未設定")
                            }
                        }
                    }else if box5sleep == "否"{
                        self.Box5Label.isHidden = true
                        self.Box5Button.isHidden = true
                    }
                }
            }else if box5time == "睡前"{
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
                                self.Box5Label.isHidden = true
                                self.Box5Button.isHidden = true
                            }else if box5lastseconddata - box5lastdata <= 5 {
                                print("go to eat box 5")
                                self.Box5Label.isHidden = false
                                self.Box5Button.isHidden = false
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
            if box6time != "睡前"{
                self.Box6Label.isHidden = true
                self.Box6Button.isHidden = true
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box6sleep = DataSnapshot.value as! String
                    if box6sleep == "是"{
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
                                        self.Box6Label.isHidden = true
                                        self.Box6Button.isHidden = true
                                    }else if box6lastseconddata - box6lastdata <= 5 {
                                        print("go to eat box 6")
                                        self.Box6Label.isHidden = false
                                        self.Box6Button.isHidden = false
                                    }
                                })
                            }else{
                                print("尚未設定")
                            }
                        }
                    }else if box6sleep == "否"{
                        self.Box6Label.isHidden = true
                        self.Box6Button.isHidden = true
                    }
                }
            }else if box6time == "睡前"{
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
                            self.Box6Label.isHidden = true
                            self.Box6Button.isHidden = true
                        }else if box6lastseconddata - box6lastdata <= 5 {
                            print("go to eat box 6")
                            self.Box6Label.isHidden = false
                            self.Box6Button.isHidden = false
                        }
                    })
                }else{
                    print("尚未設定")
                }
                }
                
            }
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

        let ref = Database.database().reference()
        
        if Box1Button.isHidden == false{
            if Box1Button.isChecked == true{
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
            if Box1Button.isChecked == false{
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
        if Box2Button.isHidden == false{
            if Box2Button.isChecked == true{
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
            if Box2Button.isChecked == false{
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
        if Box3Button.isHidden == false{
            if Box3Button.isChecked == true{
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
            if Box3Button.isChecked == false{
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
        if Box4Button.isHidden == false{
            if Box4Button.isChecked == true{
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
            if Box4Button.isChecked == false{
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
        if Box5Button.isHidden == false{
            if Box5Button.isChecked == true{
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
            if Box5Button.isChecked == false{
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
        if Box6Button.isHidden == false{
            if Box6Button.isChecked == true{
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
            if Box6Button.isChecked == false{
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
        
        
        
//        ref.child("users/\(Auth.auth().currentUser!.uid)/med_history/日期").childByAutoId().setValue("\(dateString1)")
//        ref.child("users/\(Auth.auth().currentUser!.uid)/med_history/是否吃藥").setValue("是")
//        ref.child("users/\(Auth.auth().currentUser!.uid)/med_history/時間").setValue("\(dateString2)")

    }
    
    @IBAction func Checkall(_ sender: Any) {
        if AllButton.isChecked == false{
            self.Box1Button.isChecked = true
            self.Box2Button.isChecked = true
            self.Box3Button.isChecked = true
            self.Box4Button.isChecked = true
            self.Box5Button.isChecked = true
            self.Box6Button.isChecked = true
        }else if AllButton.isChecked == true{
            self.Box1Button.isChecked = false
            self.Box2Button.isChecked = false
            self.Box3Button.isChecked = false
            self.Box4Button.isChecked = false
            self.Box5Button.isChecked = false
            self.Box6Button.isChecked = false
        }
    }
    
}

