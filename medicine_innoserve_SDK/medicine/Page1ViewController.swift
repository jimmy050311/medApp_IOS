//
//  Page1ViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/5/20.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Foundation
import UserNotifications

protocol SwiftDelegate{
    func DidTap(_sender:MyMedTableViewCell)
    
}

class Page1ViewController: UIViewController, SwiftDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UISearchResultsUpdating, UISearchBarDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
   
    
    @IBOutlet weak var MyMedicineTableView: UITableView!
    
    
    @IBAction func AddMyBox(_ gestureRecognizer: UILongPressGestureRecognizer) {
        print("okokokokokok")
    }
    
    var timer1: Timer?
    var timer2: Timer?
    var timer3: Timer?
    var searchController: UISearchController!
    var ref: DatabaseReference!
    var mymedlist = [MyMed]()
    var refHandle: UInt!
    var ff = ""
    var refreshControl:UIRefreshControl!
    var fullSize :CGSize!
    var myUIView :UIView!
    var anotherUIView :UIView!
    
    var searchmyResults: [String] = [String] () // 搜尋結果集合
    var searchmymedicinename: [String] = [] // 被搜尋的藥品名
    var isShowMySearchResult: Bool = false // 是否顯示搜尋的結果
    
    var titletext : String = ""

    @IBOutlet weak var Btn1: UIButton!
    @IBOutlet weak var Btn2: UIButton!
    @IBOutlet weak var Btn3: UIButton!
    @IBOutlet weak var Btn4: UIButton!
    @IBOutlet weak var Btn5: UIButton!
    @IBOutlet weak var Btn6: UIButton!
    @IBOutlet weak var RemoveboxButton: UIButton!
    @IBOutlet weak var Removebox1Button: UIButton!
    @IBOutlet weak var Removebox2Button: UIButton!
    @IBOutlet weak var Removebox3Button: UIButton!
    @IBOutlet weak var Removebox4Button: UIButton!
    @IBOutlet weak var Removebox5Button: UIButton!
    @IBOutlet weak var Removebox6Button: UIButton!
    @IBOutlet weak var TemLabel: UILabel!
    @IBOutlet weak var HumLabel: UILabel!
    @IBOutlet weak var AlertLabel: UILabel!
    @IBOutlet weak var ClassfierButton: UIButton!
    
    
    @IBOutlet weak var noticeswitch: UISwitch!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        ClassfierButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ClassfierButton.layer.cornerRadius = 20
        ClassfierButton.layer.borderWidth = 1
        ClassfierButton.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "家屬"{
                self.RemoveboxButton.isHidden = true
                self.noticeswitch.isHidden = true
                self.AlertLabel.isHidden = true
                self.noticeswitch.setOn(false, animated: true)
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            }else{
                self.RemoveboxButton.isHidden = false
                self.noticeswitch.isHidden = false
                self.AlertLabel.isHidden = false
            }
        }

        RemoveboxButton.backgroundColor = #colorLiteral(red: 1, green: 0.8980392157, blue: 0.8509803922, alpha: 1)
        RemoveboxButton.layer.cornerRadius = 5
        RemoveboxButton.layer.borderWidth = 2
        RemoveboxButton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
        Removebox1Button.isHidden = true
        Removebox2Button.isHidden = true
        Removebox3Button.isHidden = true
        Removebox4Button.isHidden = true
        Removebox5Button.isHidden = true
        Removebox6Button.isHidden = true
        
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in  //讀濕度
//            let boxid = DataSnapshot.value as! String
//            if boxid == "amkdajdal"{
//                self.ref.child("boxes").child(boxid).child("Humidity").observeSingleEvent(of: .value, with: { snapshot in
//
//                    let a = snapshot.value as! NSArray
//                    print(a)
//                    var objCArray = NSMutableArray(array: a)
//                    let swiftArray: [Double] = objCArray.compactMap({ $0 as? Double })
//                    let b = (a as Array).filter {$0 is Double}
//
//                    print(swiftArray[(swiftArray.count) - 1])
//                    self.HumLabel.text = "濕度：\(swiftArray[(swiftArray.count) - 1])"
//                })
//            }else{
//                print("尚未設定")
//            }
//        }
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in  //讀溫度
//            let boxid = DataSnapshot.value as! String
//            if boxid == "amkdajdal"{
//                self.ref.child("boxes").child(boxid).child("Temperature").observeSingleEvent(of: .value, with: { snapshot in
//
//                    let a = snapshot.value as! NSArray
//                    print(a)
//                    var objCArray = NSMutableArray(array: a)
//                    let swiftArray: [Double] = objCArray.compactMap({ $0 as? Double })
//                    let b = (a as Array).filter {$0 is Double}
//
//                    print(swiftArray[(swiftArray.count) - 1])
//                    self.TemLabel.text = "溫度：\(swiftArray[(swiftArray.count) - 1])"
//                })
//            }else{
//                print("尚未設定")
//            }
//        }
        
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("MedNotice").observeSingleEvent(of: .value) { (DataSnapshot) in
            let name = DataSnapshot.value as! String
            if name == "True"{
                var ref = Database.database().reference()
                self.noticeswitch.setOn(true, animated: true)
                ref.child("users/\(Auth.auth().currentUser!.uid)/MedNotice").setValue("True")
                print("打開")
                
                let userID = Auth.auth().currentUser?.uid
                
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box1
                    let eattime = DataSnapshot.value as! String
                    if eattime == "三餐飯前"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                            }
                        }
                    }else if eattime == "三餐飯後"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                            }
                        }
                    }else if eattime == "早晚飯前"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                            }
                        }
                    }else if eattime == "早晚飯後"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                            }
                        }
                    }else if eattime == "睡前"{
                        self.NotificBeforeSleep()  //呼叫睡前的通知
                    }
                    
                }
                
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box2
                    let eattime = DataSnapshot.value as! String
                    if eattime == "三餐飯前"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                            }
                        }
                    }else if eattime == "三餐飯後"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                            }
                        }
                    }else if eattime == "早晚飯前"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                            }
                        }
                    }else if eattime == "早晚飯後"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                            }
                        }
                    }else if eattime == "睡前"{
                        self.NotificBeforeSleep()  //呼叫睡前的通知
                    }
                    
                }
                
                
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box3
                    let eattime = DataSnapshot.value as! String
                    if eattime == "三餐飯前"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                            }
                        }
                    }else if eattime == "三餐飯後"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                            }
                        }
                    }else if eattime == "早晚飯前"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                            }
                        }
                    }else if eattime == "早晚飯後"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                            }
                        }
                    }else if eattime == "睡前"{
                        self.NotificBeforeSleep()  //呼叫睡前的通知
                    }
                    
                }
                
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box4
                    let eattime = DataSnapshot.value as! String
                    if eattime == "三餐飯前"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                            }
                        }
                    }else if eattime == "三餐飯後"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                            }
                        }
                    }else if eattime == "早晚飯前"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                            }
                        }
                    }else if eattime == "早晚飯後"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                            }
                        }
                    }else if eattime == "睡前"{
                        self.NotificBeforeSleep()  //呼叫睡前的通知
                    }
                    
                }
                
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box5
                    let eattime = DataSnapshot.value as! String
                    if eattime == "三餐飯前"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                            }
                        }
                    }else if eattime == "三餐飯後"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                            }
                        }
                    }else if eattime == "早晚飯前"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                            }
                        }
                    }else if eattime == "早晚飯後"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                            }
                        }
                    }else if eattime == "睡前"{
                        self.NotificBeforeSleep()  //呼叫睡前的通知
                    }
                    
                }
                
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box6
                    let eattime = DataSnapshot.value as! String
                    if eattime == "三餐飯前"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                            }
                        }
                    }else if eattime == "三餐飯後"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                            }
                        }
                    }else if eattime == "早晚飯前"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                            }
                        }
                    }else if eattime == "早晚飯後"{
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let eatbeforebed = DataSnapshot.value as! String
                            if eatbeforebed == "是"{
                                self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                            }else if eatbeforebed == "否"{
                                self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                            }
                        }
                    }else if eattime == "睡前"{
                        self.NotificBeforeSleep()  //呼叫睡前的通知
                    }
                    
                }
            }else{
                self.noticeswitch.setOn(false, animated: true)
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            }
        }
        
        MyMedicineTableView.delegate = self
        MyMedicineTableView.dataSource = self
        
        //mymedname()
        isShowMySearchResult = false
        appear()
        MyMedicineTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0);   //讓底部兩格顯示出來
        searchController = UISearchController(searchResultsController:nil)
        MyMedicineTableView.tableHeaderView = searchController.searchBar   //添加搜尋列
        refreshControl = UIRefreshControl()  //下拉更新
//        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow]  //更新顯示的文字顏色
//        refreshControl.attributedTitle = NSAttributedString(string: "正在更新", attributes: attributes)   //更新顯示文字
        fullSize = UIScreen.main.bounds.size//取得螢幕大小
        
        //LikeBtn.isHidden = true
        /*let longPress = UILongPressGestureRecognizer(target: self, action: #selector(Page1ViewController.handleLongPress))*/
        /*MyMedicineTableView.addGestureRecognizer(longPress)*/
        refreshControl.addTarget(self, action: #selector(appear), for: UIControl.Event.valueChanged)
        MyMedicineTableView.addSubview(refreshControl)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = true  // 預設為true，若是沒改為false，則在搜尋時整個TableView的背景顏色會變成灰底的
        self.searchController.hidesNavigationBarDuringPresentation = false
        //readht()
        searchController.searchBar.showsBookmarkButton = true
        self.searchController.searchBar.placeholder = "搜索藥物名稱"
        readmymed()
        //readweight()
        
        //self.timer1 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(readmymed), userInfo: nil, repeats: true)   //要解開註解
        //self.timer2 = Timer.scheduledTimer(timeInterval: 1800, target: self, selector: #selector(readweight), userInfo: nil, repeats: true)   //5要改1800 要解開註解
        //self.timer3 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(readht), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {   //每次切換到這頁會執行
        super.viewWillAppear(animated)
        ref = Database.database().reference()
        print("page1")
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "家屬"{
                self.ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box1Na = DataSnapshot.value as! String
                    self.Btn1.setTitle(box1Na, for: .normal)
                }
                self.ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box2Na = DataSnapshot.value as! String
                    self.Btn2.setTitle(box2Na, for: .normal)
                }
                self.ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box3Na = DataSnapshot.value as! String
                    self.Btn3.setTitle(box3Na, for: .normal)
                }
                self.ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box4Na = DataSnapshot.value as! String
                    self.Btn4.setTitle(box4Na, for: .normal)
                }
                self.ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box5Na = DataSnapshot.value as! String
                    self.Btn5.setTitle(box5Na, for: .normal)
                }
                self.ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box6Na = DataSnapshot.value as! String
                    self.Btn6.setTitle(box6Na, for: .normal)
                }
            }else{
                self.ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box1Na = DataSnapshot.value as! String
                    self.Btn1.setTitle(box1Na, for: .normal)
                }
                self.ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box2Na = DataSnapshot.value as! String
                    self.Btn2.setTitle(box2Na, for: .normal)
                }
                self.ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box3Na = DataSnapshot.value as! String
                    self.Btn3.setTitle(box3Na, for: .normal)
                }
                self.ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box4Na = DataSnapshot.value as! String
                    self.Btn4.setTitle(box4Na, for: .normal)
                }
                self.ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box5Na = DataSnapshot.value as! String
                    self.Btn5.setTitle(box5Na, for: .normal)
                }
                self.ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box6Na = DataSnapshot.value as! String
                    self.Btn6.setTitle(box6Na, for: .normal)
                }
            }
        }
       //appear()

        
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let box1Na = DataSnapshot.value as! String
//            self.Btn1.setTitle(box1Na, for: .normal)
//        }
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let box2Na = DataSnapshot.value as! String
//            self.Btn2.setTitle(box2Na, for: .normal)
//        }
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let box3Na = DataSnapshot.value as! String
//            self.Btn3.setTitle(box3Na, for: .normal)
//        }
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let box4Na = DataSnapshot.value as! String
//            self.Btn4.setTitle(box4Na, for: .normal)
//        }
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let box5Na = DataSnapshot.value as! String
//            self.Btn5.setTitle(box5Na, for: .normal)
//        }
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let box6Na = DataSnapshot.value as! String
//            self.Btn6.setTitle(box6Na, for: .normal)
//        }
    }
    
    @objc func fakehumid(){
        var ref = Database.database().reference()
    }

    @objc func readht(){
        var ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in  //讀濕度
            let boxid = DataSnapshot.value as! String
            if boxid == "amkdajdal"{
                self.ref.child("boxes").child(boxid).child("Humidity").observeSingleEvent(of: .value, with: { snapshot in
                    
                    let a = snapshot.value as! NSArray
                    print(a)
                    var objCArray = NSMutableArray(array: a)
                    let swiftArray: [Double] = objCArray.compactMap({ $0 as? Double })
                    let b = (a as Array).filter {$0 is Double}
                    
                    print(swiftArray[(swiftArray.count) - 1])
                    self.HumLabel.text = "濕度：\(swiftArray[(swiftArray.count) - 1])"
                })
            }else{
                print("尚未設定")
            }
        }
        ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in  //讀溫度
            let boxid = DataSnapshot.value as! String
            if boxid == "amkdajdal"{
                self.ref.child("boxes").child(boxid).child("Temperature").observeSingleEvent(of: .value, with: { snapshot in
                    
                    let a = snapshot.value as! NSArray
                    print(a)
                    var objCArray = NSMutableArray(array: a)
                    let swiftArray: [Double] = objCArray.compactMap({ $0 as? Double })
                    let b = (a as Array).filter {$0 is Double}
                    
                    print(swiftArray[(swiftArray.count) - 1])
                    self.TemLabel.text = "溫度：\(swiftArray[(swiftArray.count) - 1])"
                })
            }else{
                print("尚未設定")
            }
        }
    }
    
    @objc func readweight(){
        var ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        let now:Date = Date()
        let dateFormat1:DateFormatter = DateFormatter()
        let dateFormat2:DateFormatter = DateFormatter()
        dateFormat1.dateFormat = "yyyy年MM月dd日"
        dateFormat2.dateFormat = "HH:mm:ss"
        let dateString1:String = dateFormat1.string(from: now)
        let dateString2:String = dateFormat2.string(from: now)
        if userID == nil{
            print("停止重複執行2")
            self.timer2?.invalidate()
        }else{
            ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in  //讀boxid
                let boxid = DataSnapshot.value as! String
                if boxid == "amkdajdal"{
                    ref.child("boxes").child(boxid).child("ONE").observeSingleEvent(of: .value, with: { snapshot in
                    let box1array = snapshot.value as! NSArray
                    var box1objCArray = NSMutableArray(array: box1array)
                    let box1swiftArray: [Double] = box1objCArray.compactMap({ $0 as? Double })
                    let box1lastdata = box1swiftArray[(box1swiftArray.count) - 1]
                    let box1lastseconddata = box1swiftArray[(box1swiftArray.count) - 2]
                    if box1lastdata - box1lastseconddata > 400 {  //吃藥之後 重量數據會增加 所以最後減倒數第二會大於重量
                    print("alreadly ate box 1")
                    let autoid = ref.childByAutoId().key
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box1").child(autoid!).child("Date").setValue("\(dateString1)")
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box1").child(autoid!).child("Take").setValue("已服藥")
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box1").child(autoid!).child("Time").setValue("\(dateString2)")
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let name = DataSnapshot.value as! String
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box1").child(autoid!).child("Name").setValue("\(name)")
                    }
                    if self.noticeswitch.isOn == true{
                        ref.child("boxes").child(boxid).child("TWO").observeSingleEvent(of: .value, with: { snapshot in
                            let box2array = snapshot.value as! NSArray
                            var box2objCArray = NSMutableArray(array: box2array)
                            let box2swiftArray: [Double] = box2objCArray.compactMap({ $0 as? Double })
                            let box2lastdata = box2swiftArray[(box2swiftArray.count) - 1]
                            let box2lastseconddata = box2swiftArray[(box2swiftArray.count) - 2]
                            if box2lastdata - box2lastseconddata > 400 {
                                print("alreadly ate box 2")
                                let autoid = ref.childByAutoId().key
                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box2").child(autoid!).child("Date").setValue("\(dateString1)")
                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box2").child(autoid!).child("Take").setValue("已服藥")
                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box2").child(autoid!).child("Time").setValue("\(dateString2)")
                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                    let name = DataSnapshot.value as! String
                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box2").child(autoid!).child("Name").setValue("\(name)")
                                }
                                ref.child("boxes").child(boxid).child("THREE").observeSingleEvent(of: .value, with: { snapshot in
                                    let box3array = snapshot.value as! NSArray
                                    var box3objCArray = NSMutableArray(array: box3array)
                                    let box3swiftArray: [Double] = box3objCArray.compactMap({ $0 as? Double })
                                    let box3lastdata = box3swiftArray[(box3swiftArray.count) - 1]
                                    let box3lastseconddata = box3swiftArray[(box3swiftArray.count) - 2]
                                    if box3lastdata - box3lastseconddata > 1300 {  //B群
                                        print("alreadly ate box 3")
                                        let autoid = ref.childByAutoId().key
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Date").setValue("\(dateString1)")
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Take").setValue("已服藥")
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Time").setValue("\(dateString2)")
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                            let name = DataSnapshot.value as! String
                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Name").setValue("\(name)")
                                        }
                                        ref.child("boxes").child(boxid).child("FOUR").observeSingleEvent(of: .value, with: { snapshot in
                                        let box4array = snapshot.value as! NSArray
                                        var box4objCArray = NSMutableArray(array: box4array)
                                        let box4swiftArray: [Double] = box4objCArray.compactMap({ $0 as? Double })
                                        let box4lastdata = box4swiftArray[(box4swiftArray.count) - 1]
                                        let box4lastseconddata = box4swiftArray[(box4swiftArray.count) - 2]
                                            if box4lastseconddata - box4lastdata > 5 {
                                                print("alreadly ate box 4")
                                                let autoid = ref.childByAutoId().key
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Date").setValue("\(dateString1)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Take").setValue("已服藥")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Time").setValue("\(dateString2)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                    let name = DataSnapshot.value as! String
                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Name").setValue("\(name)")
                                                }
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests() //都吃了關通知
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }else if box4lastseconddata - box4lastdata <= 5{
                                                print("go to eat box 4")
                                                self.box4notify()
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }else if box3lastdata - box3lastseconddata <= 1300 {  //B群
                                        print("go to eat box 3")
                                        self.box3notify()
                                        ref.child("boxes").child(boxid).child("FOUR").observeSingleEvent(of: .value, with: { snapshot in
                                        let box4array = snapshot.value as! NSArray
                                        var box4objCArray = NSMutableArray(array: box4array)
                                        let box4swiftArray: [Double] = box4objCArray.compactMap({ $0 as? Double })
                                        let box4lastdata = box4swiftArray[(box4swiftArray.count) - 1]
                                        let box4lastseconddata = box4swiftArray[(box4swiftArray.count) - 2]
                                            if box4lastseconddata - box4lastdata > 5 {
                                                print("alreadly ate box 4")
                                                let autoid = ref.childByAutoId().key
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Date").setValue("\(dateString1)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Take").setValue("已服藥")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Time").setValue("\(dateString2)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                    let name = DataSnapshot.value as! String
                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Name").setValue("\(name)")
                                                }
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }else if box4lastseconddata - box4lastdata <= 5{
                                                print("go to eat box 4")
                                                self.box4notify()
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box1swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }
                                })
                            }else if box2lastdata - box2lastseconddata <= 400 {
                                print("go to eat box 2")
                                self.box2notify()
                                ref.child("boxes").child(boxid).child("THREE").observeSingleEvent(of: .value, with: { snapshot in
                                let box3array = snapshot.value as! NSArray
                                var box3objCArray = NSMutableArray(array: box3array)
                                let box3swiftArray: [Double] = box3objCArray.compactMap({ $0 as? Double })
                                let box3lastdata = box3swiftArray[(box3swiftArray.count) - 1]
                                let box3lastseconddata = box3swiftArray[(box3swiftArray.count) - 2]
                                    if box3lastdata - box3lastseconddata > 1300 {  //B群
                                        print("alreadly ate box 3")
                                        let autoid = ref.childByAutoId().key
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Date").setValue("\(dateString1)")
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Take").setValue("已服藥")
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Time").setValue("\(dateString2)")
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                            let name = DataSnapshot.value as! String
                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Name").setValue("\(name)")
                                        }
                                        ref.child("boxes").child(boxid).child("FOUR").observeSingleEvent(of: .value, with: { snapshot in
                                        let box4array = snapshot.value as! NSArray
                                        var box4objCArray = NSMutableArray(array: box4array)
                                        let box4swiftArray: [Double] = box4objCArray.compactMap({ $0 as? Double })
                                        let box4lastdata = box4swiftArray[(box4swiftArray.count) - 1]
                                        let box4lastseconddata = box4swiftArray[(box4swiftArray.count) - 2]
                                            if box4lastseconddata - box4lastdata > 5 {
                                                print("alreadly ate box 4")
                                                let autoid = ref.childByAutoId().key
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Date").setValue("\(dateString1)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Take").setValue("已服藥")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Time").setValue("\(dateString2)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                    let name = DataSnapshot.value as! String
                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Name").setValue("\(name)")
                                                }
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }else if box4lastseconddata - box4lastdata <= 5{
                                                print("go to eat box 4")
                                                self.box4notify()
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }else if box3lastdata - box3lastseconddata <= 1300 {  //B群
                                        print("go to eat box 3")
                                        self.box3notify()
                                        ref.child("boxes").child(boxid).child("FOUR").observeSingleEvent(of: .value, with: { snapshot in
                                        let box4array = snapshot.value as! NSArray
                                        var box4objCArray = NSMutableArray(array: box4array)
                                        let box4swiftArray: [Double] = box4objCArray.compactMap({ $0 as? Double })
                                        let box4lastdata = box4swiftArray[(box4swiftArray.count) - 1]
                                        let box4lastseconddata = box4swiftArray[(box4swiftArray.count) - 2]
                                            if box4lastseconddata - box4lastdata > 5 {
                                                print("alreadly ate box 4")
                                                let autoid = ref.childByAutoId().key
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Date").setValue("\(dateString1)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Take").setValue("已服藥")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Time").setValue("\(dateString2)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                    let name = DataSnapshot.value as! String
                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Name").setValue("\(name)")
                                                }
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }else if box4lastseconddata - box4lastdata <= 5{
                                                print("go to eat box 4")
                                                self.box4notify()
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }
                                })
                            }
                        })
                    }else if self.noticeswitch.isOn == false{
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()   //關閉通知
                    }
                }else if box1lastdata - box1lastseconddata <= 400 {
                    print("go to eat box 1")
                    self.box1notify()
                    if self.noticeswitch.isOn == true{
                        ref.child("boxes").child(boxid).child("TWO").observeSingleEvent(of: .value, with: { snapshot in
                        let box2array = snapshot.value as! NSArray
                        var box2objCArray = NSMutableArray(array: box2array)
                        let box2swiftArray: [Double] = box2objCArray.compactMap({ $0 as? Double })
                        let box2lastdata = box2swiftArray[(box2swiftArray.count) - 1]
                        let box2lastseconddata = box2swiftArray[(box2swiftArray.count) - 2]
                            if box2lastdata - box2lastseconddata > 400 {
                                print("alreadly ate box 2")
                                let autoid = ref.childByAutoId().key
                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box2").child(autoid!).child("Date").setValue("\(dateString1)")
                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box2").child(autoid!).child("Take").setValue("已服藥")
                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box2").child(autoid!).child("Time").setValue("\(dateString2)")
                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                    let name = DataSnapshot.value as! String
                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box2").child(autoid!).child("Name").setValue("\(name)")
                                }
                                ref.child("boxes").child(boxid).child("THREE").observeSingleEvent(of: .value, with: { snapshot in
                                let box3array = snapshot.value as! NSArray
                                var box3objCArray = NSMutableArray(array: box3array)
                                let box3swiftArray: [Double] = box3objCArray.compactMap({ $0 as? Double })
                                let box3lastdata = box3swiftArray[(box3swiftArray.count) - 1]
                                let box3lastseconddata = box3swiftArray[(box3swiftArray.count) - 2]
                                    if box3lastdata - box3lastseconddata > 1300 {  //B群
                                        print("alreadly ate box 3")
                                        let autoid = ref.childByAutoId().key
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Date").setValue("\(dateString1)")
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Take").setValue("已服藥")
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Time").setValue("\(dateString2)")
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                            let name = DataSnapshot.value as! String
                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Name").setValue("\(name)")
                                        }
                                        ref.child("boxes").child(boxid).child("FOUR").observeSingleEvent(of: .value, with: { snapshot in
                                        let box4array = snapshot.value as! NSArray
                                        var box4objCArray = NSMutableArray(array: box4array)
                                        let box4swiftArray: [Double] = box4objCArray.compactMap({ $0 as? Double })
                                        let box4lastdata = box4swiftArray[(box4swiftArray.count) - 1]
                                        let box4lastseconddata = box4swiftArray[(box4swiftArray.count) - 2]
                                            if box4lastseconddata - box4lastdata > 5 {
                                                print("alreadly ate box 4")
                                                let autoid = ref.childByAutoId().key
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Date").setValue("\(dateString1)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Take").setValue("已服藥")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Time").setValue("\(dateString2)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                    let name = DataSnapshot.value as! String
                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Name").setValue("\(name)")
                                                }
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }else if box4lastseconddata - box4lastdata <= 5{
                                                print("go to eat box 4")
                                                self.box4notify()
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }else if box3lastdata - box3lastseconddata <= 1300 {  //B群
                                        print("go to eat box 3")
                                        self.box3notify()
                                        ref.child("boxes").child(boxid).child("FOUR").observeSingleEvent(of: .value, with: { snapshot in
                                        let box4array = snapshot.value as! NSArray
                                        var box4objCArray = NSMutableArray(array: box4array)
                                        let box4swiftArray: [Double] = box4objCArray.compactMap({ $0 as? Double })
                                        let box4lastdata = box4swiftArray[(box4swiftArray.count) - 1]
                                        let box4lastseconddata = box4swiftArray[(box4swiftArray.count) - 2]
                                            if box4lastseconddata - box4lastdata > 5 {
                                                print("alreadly ate box 4")
                                                let autoid = ref.childByAutoId().key
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Date").setValue("\(dateString1)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Take").setValue("已服藥")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Time").setValue("\(dateString2)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                    let name = DataSnapshot.value as! String
                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Name").setValue("\(name)")
                                                }
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }else if box4lastseconddata - box4lastdata <= 5{
                                                print("go to eat box 4")
                                                self.box4notify()
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }
                                })
                            }else if box2lastdata - box2lastseconddata <= 400 {
                                print("go to eat box 2")
                                self.box2notify()
                                ref.child("boxes").child(boxid).child("THREE").observeSingleEvent(of: .value, with: { snapshot in
                                let box3array = snapshot.value as! NSArray
                                var box3objCArray = NSMutableArray(array: box3array)
                                let box3swiftArray: [Double] = box3objCArray.compactMap({ $0 as? Double })
                                let box3lastdata = box3swiftArray[(box3swiftArray.count) - 1]
                                let box3lastseconddata = box3swiftArray[(box3swiftArray.count) - 2]
                                    if box3lastdata - box3lastseconddata > 1300 {  //B群
                                        print("alreadly ate box 3")
                                        let autoid = ref.childByAutoId().key
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Date").setValue("\(dateString1)")
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Take").setValue("已服藥")
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Time").setValue("\(dateString2)")
                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                            let name = DataSnapshot.value as! String
                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box3").child(autoid!).child("Name").setValue("\(name)")
                                        }
                                        ref.child("boxes").child(boxid).child("FOUR").observeSingleEvent(of: .value, with: { snapshot in
                                        let box4array = snapshot.value as! NSArray
                                        var box4objCArray = NSMutableArray(array: box4array)
                                        let box4swiftArray: [Double] = box4objCArray.compactMap({ $0 as? Double })
                                        let box4lastdata = box4swiftArray[(box4swiftArray.count) - 1]
                                        let box4lastseconddata = box4swiftArray[(box4swiftArray.count) - 2]
                                            if box4lastseconddata - box4lastdata > 5 {
                                                print("alreadly ate box 4")
                                                let autoid = ref.childByAutoId().key
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Date").setValue("\(dateString1)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Take").setValue("已服藥")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Time").setValue("\(dateString2)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                    let name = DataSnapshot.value as! String
                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Name").setValue("\(name)")
                                                }
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }else if box4lastseconddata - box4lastdata <= 5{
                                                print("go to eat box 4")
                                                self.box4notify()
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }else if box3lastdata - box3lastseconddata <= 1300 {  //B群
                                        print("go to eat box 3")
                                        self.box3notify()
                                        ref.child("boxes").child(boxid).child("FOUR").observeSingleEvent(of: .value, with: { snapshot in
                                        let box4array = snapshot.value as! NSArray
                                        var box4objCArray = NSMutableArray(array: box4array)
                                        let box4swiftArray: [Double] = box4objCArray.compactMap({ $0 as? Double })
                                        let box4lastdata = box4swiftArray[(box4swiftArray.count) - 1]
                                        let box4lastseconddata = box4swiftArray[(box4swiftArray.count) - 2]
                                            if box4lastseconddata - box4lastdata > 5 {
                                                print("alreadly ate box 4")
                                                let autoid = ref.childByAutoId().key
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Date").setValue("\(dateString1)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Take").setValue("已服藥")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Time").setValue("\(dateString2)")
                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                    let name = DataSnapshot.value as! String
                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box4").child(autoid!).child("Name").setValue("\(name)")
                                                }
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }else if box4lastseconddata - box4lastdata <= 5{
                                                print("go to eat box 4")
                                                self.box4notify()
                                                ref.child("boxes").child(boxid).child("FIVE").observeSingleEvent(of: .value, with: { snapshot in
                                                let box5array = snapshot.value as! NSArray
                                                var box5objCArray = NSMutableArray(array: box5array)
                                                let box5swiftArray: [Double] = box5objCArray.compactMap({ $0 as? Double })
                                                let box5lastdata = box5swiftArray[(box5swiftArray.count) - 1]
                                                let box5lastseconddata = box5swiftArray[(box5swiftArray.count) - 2]
                                                    if box5lastseconddata - box5lastdata > 5 {
                                                        print("alreadly ate box 5")
                                                        let autoid = ref.childByAutoId().key
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Date").setValue("\(dateString1)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Take").setValue("已服藥")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Time").setValue("\(dateString2)")
                                                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                            let name = DataSnapshot.value as! String
                                                            ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box5").child(autoid!).child("Name").setValue("\(name)")
                                                        }
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }else if box5lastseconddata - box5lastdata <= 5 {
                                                        print("go to eat box 5")
                                                        self.box5notifty()
                                                        ref.child("boxes").child(boxid).child("SIX").observeSingleEvent(of: .value, with: { snapshot in
                                                        let box6array = snapshot.value as! NSArray
                                                        var box6objCArray = NSMutableArray(array: box6array)
                                                        let box6swiftArray: [Double] = box6objCArray.compactMap({ $0 as? Double })
                                                        let box6lastdata = box6swiftArray[(box6swiftArray.count) - 1]
                                                        let box6lastseconddata = box6swiftArray[(box6swiftArray.count) - 2]
                                                            if box6lastseconddata - box6lastdata > 5 {
                                                                print("alreadly ate box 6")
                                                                let autoid = ref.childByAutoId().key
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Date").setValue("\(dateString1)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Take").setValue("已服藥")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Time").setValue("\(dateString2)")
                                                                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                                                                    let name = DataSnapshot.value as! String
                                                                    ref.child("users").child(Auth.auth().currentUser!.uid).child("med_history").child("box6").child(autoid!).child("Name").setValue("\(name)")
                                                                }
                                                            }else if box6lastseconddata - box6lastdata <= 5 {
                                                                print("go to eat box 6")
                                                                self.box6notify()
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }
                                })
                            }
                        })
                    }else if self.noticeswitch.isOn == false{
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()   //關閉通知
                    }//關通知
                }//else if box1lastseconddata - box1lastdata <= 5{
            })//讀重量裡面
                }else{
                    print("尚未設定")
                }
                
            }//boxid
            
        }//userid != nil
        
    }//func weight
    
   
    
    func box1notify(){
        var ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box1
            let eattime = DataSnapshot.value as! String
            if eattime == "三餐飯前"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                    }
                }
            }else if eattime == "三餐飯後"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                    }
                }
            }else if eattime == "早晚飯前"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                    }
                }
            }else if eattime == "早晚飯後"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                    }
                }
            }else if eattime == "睡前"{
                self.NotificBeforeSleep()  //呼叫睡前的通知
            }
        }
    }
    
    func box2notify(){
        var ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box2
            let eattime = DataSnapshot.value as! String
            if eattime == "三餐飯前"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                    }
                }
            }else if eattime == "三餐飯後"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                    }
                }
            }else if eattime == "早晚飯前"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                    }
                }
            }else if eattime == "早晚飯後"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                    }
                }
            }else if eattime == "睡前"{
                self.NotificBeforeSleep()  //呼叫睡前的通知
            }
        }
    }
    
    func box3notify(){
        var ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box3
            let eattime = DataSnapshot.value as! String
            if eattime == "三餐飯前"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                    }
                }
            }else if eattime == "三餐飯後"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                    }
                }
            }else if eattime == "早晚飯前"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                    }
                }
            }else if eattime == "早晚飯後"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                    }
                }
            }else if eattime == "睡前"{
                self.NotificBeforeSleep()  //呼叫睡前的通知
            }
        }
    }
    
    func box4notify(){
        var ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box4
            let eattime = DataSnapshot.value as! String
            if eattime == "三餐飯前"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                    }
                }
            }else if eattime == "三餐飯後"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                    }
                }
            }else if eattime == "早晚飯前"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                    }
                }
            }else if eattime == "早晚飯後"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                    }
                }
            }else if eattime == "睡前"{
                self.NotificBeforeSleep()  //呼叫睡前的通知
            }
        }
    }
    
    func box5notifty(){
        var ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box5
            let eattime = DataSnapshot.value as! String
            if eattime == "三餐飯前"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                    }
                }
            }else if eattime == "三餐飯後"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                    }
                }
            }else if eattime == "早晚飯前"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                    }
                }
            }else if eattime == "早晚飯後"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                    }
                }
            }else if eattime == "睡前"{
                self.NotificBeforeSleep()  //呼叫睡前的通知
            }
        }
    }
    
    func box6notify(){
        var ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box6
            let eattime = DataSnapshot.value as! String
            if eattime == "三餐飯前"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                    }
                }
            }else if eattime == "三餐飯後"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                    }
                }
            }else if eattime == "早晚飯前"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                    }
                }
            }else if eattime == "早晚飯後"{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let eatbeforebed = DataSnapshot.value as! String
                    if eatbeforebed == "是"{
                        self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                    }else if eatbeforebed == "否"{
                        self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                    }
                }
            }else if eattime == "睡前"{
                self.NotificBeforeSleep()  //呼叫睡前的通知
            }
        }
    }
    
    @objc func readmymed(){
        print("reloadmymed")
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        if userID == nil{
            print("停止重複執行1")
            self.timer1?.invalidate()
        }else{
            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box1Na = DataSnapshot.value as! String
                self.Btn1.setTitle(box1Na, for: .normal)
            }
            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box2Na = DataSnapshot.value as! String
                self.Btn2.setTitle(box2Na, for: .normal)
            }
            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box3Na = DataSnapshot.value as! String
                self.Btn3.setTitle(box3Na, for: .normal)
            }
            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box4Na = DataSnapshot.value as! String
                self.Btn4.setTitle(box4Na, for: .normal)
            }
            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box5Na = DataSnapshot.value as! String
                self.Btn5.setTitle(box5Na, for: .normal)
            }
            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box6Na = DataSnapshot.value as! String
                self.Btn6.setTitle(box6Na, for: .normal)
            }
        }
    }
    
    func filterDataSource() {
        // 使用高階函數來過濾掉陣列裡的資料
        self.searchmyResults = searchmymedicinename.filter({ (mymedicinesearched) -> Bool in
            return mymedicinesearched.lowercased().range(of: self.searchController.searchBar.text!.lowercased()) != nil
        })
        
        if self.searchmyResults.count > 0 {
            self.isShowMySearchResult = true
            self.MyMedicineTableView.separatorStyle = UITableViewCell.SeparatorStyle.init(rawValue: 1)! // 顯示TableView的格線
        } else {
            self.MyMedicineTableView.separatorStyle = UITableViewCell.SeparatorStyle.none // 移除TableView的格線
            // 可加入一個查找不到的資料的label來告知使用者查不到資料...
            // ...
        }
        
        self.MyMedicineTableView.reloadData()
    }
   
    func updateSearchResults(for searchController: UISearchController) {
        // 若是沒有輸入任何文字或輸入空白則直接返回不做搜尋的動作
        if self.searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            return
        }
        
        self.filterDataSource()
    }
    
    @objc func appear(){
        if mymedlist.count != 0{
            for i in 0...(mymedlist.count-1)
            {mymedlist.remove(at: 0)}}
        refHandle = ref.child("users").child(Auth.auth().currentUser!.uid).child("MyMedicine").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject]{
//                print("dictionary is \(dictionary)")
                let medDetail = MyMed()
                medDetail.setValuesForKeys(dictionary)
                self.mymedlist.append(medDetail)
//                print("aaaaaaaaaaaaaa")
//                print(snapshot.value)
                DispatchQueue.main.async {
                    self.MyMedicineTableView.reloadData()
                    self.refreshControl!.endRefreshing()
                }
            }
        })
        //self.refreshControl.endRefreshing()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isShowMySearchResult {
            //print(searchResults.count)
            return self.searchmyResults.count
        } else {
            //print(mymedlist.count)
            return mymedlist.count
        }
        //return mymedlist.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyMedTableViewCell
        //var cell: UITableViewCell? = MedicineTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell") as! MyMedTableViewCell
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "家屬"{
                cell.Add.isHidden = true
            }else{
                cell.Add.isHidden = false
//                cell.Add.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                cell.Add.layer.cornerRadius = 12
//                cell.Add.layer.borderWidth = 1
//                cell.Add.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
        
        if self.isShowMySearchResult {
            // 若是有查詢結果則顯示查詢結果集合裡的資料
            //cell.textLabel?.text = String(searchmyResults[indexPath.row])
            cell.MyMedName.text = String(searchmyResults[indexPath.row])
        } else {
            cell.textLabel?.text = nil
            cell.MyMedName.text = mymedlist[indexPath.row].中文品名
            searchmymedicinename.append(mymedlist[indexPath.row].中文品名!)
            let a = Set(searchmymedicinename)
            searchmymedicinename = Array(a)
            cell.delegate = self as? SwiftDelegate
            
            //searchmedicinename.append(medlist[indexPath.row].商品名!)
        }
        return cell
        
    }
    
    func DidTap(_sender sender:MyMedTableViewCell){
        guard let tappedIndexPath = MyMedicineTableView.indexPath(for: sender) else {return}
        
        let ref = Database.database().reference()
        print(sender)
        print("=============")
        print(tappedIndexPath) 
        print("hello:" + ff)
      
        var cell = mymedlist[tappedIndexPath.row].中文品名!
        //print("asbagaga")
        let controller = UIAlertController(title: "請選擇要加入的藥盒位置", message: "將" + cell + "加入藥盒？" , preferredStyle: .actionSheet)
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
                        let controller = UIAlertController(title: "第一格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + cell , preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                            self.Btn1.setTitle(cell, for: .normal)
                            //self.Btn1.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/藥物名稱").setValue(cell)
                            
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
                    self.Btn1.setTitle(cell, for: .normal)
                    //self.Btn1.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/藥物名稱").setValue(cell)
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
                    
                case "2":
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let YN = DataSnapshot.value as! String
                        
                        if YN != "暫無藥物"
                        {
                            let controller = UIAlertController(title: "第二格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + cell , preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                self.Btn2.setTitle(cell, for: .normal)
                                //self.Btn2.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/藥物名稱").setValue(cell)
                                
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
                            self.Btn2.setTitle(cell, for: .normal)
                            //self.Btn2.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/藥物名稱").setValue(cell)
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
                case "3":
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let YN = DataSnapshot.value as! String
                            
                            if YN != "暫無藥物"
                            {
                                let controller = UIAlertController(title: "第三格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + cell , preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                    self.Btn3.setTitle(cell, for: .normal)
                                    //self.Btn3.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                    ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/藥物名稱").setValue(cell)
                                    
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
                                self.Btn3.setTitle(cell, for: .normal)
                                //self.Btn3.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/藥物名稱").setValue(cell)
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
                case "4":
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let YN = DataSnapshot.value as! String
                        
                        if YN != "暫無藥物"
                        {
                            let controller = UIAlertController(title: "第四格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + cell , preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                self.Btn4.setTitle(cell, for: .normal)
                                //self.Btn4.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/藥物名稱").setValue(cell)
                                
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
                            self.Btn4.setTitle(cell, for: .normal)
                            //self.Btn4.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/藥物名稱").setValue(cell)
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
                case "5":
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let YN = DataSnapshot.value as! String
                        
                        if YN != "暫無藥物"
                        {
                            let controller = UIAlertController(title: "第五格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + cell , preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                self.Btn5.setTitle(cell, for: .normal)
                                //self.Btn5.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/藥物名稱").setValue(cell)
                                
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
                            self.Btn5.setTitle(cell, for: .normal)
                            //self.Btn5.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/藥物名稱").setValue(cell)
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
                case "6":
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let YN = DataSnapshot.value as! String
                        
                        if YN != "暫無藥物"
                        {
                            let controller = UIAlertController(title: "第六格已有藥物", message: "是否將原藥物" + "\n" +  YN + "\n" + "更換為" + cell , preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                                self.Btn6.setTitle(cell, for: .normal)
                                //self.Btn6.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/藥物名稱").setValue(cell)
                                
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
                                
                            }
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            controller.addAction(okAction)
                            self.present(controller, animated: true, completion: nil)
                        }
                        else
                        {
                            self.Btn6.setTitle(cell, for: .normal)
                            //self.Btn6.titleLabel?.font = UIFont.systemFont(ofSize: 9)
                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/藥物名稱").setValue(cell)
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
        present(controller, animated: true, completion: nil)
        
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showmydetail", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showmydetail"{
            if let dvc = segue.destination as? MyDetailViewController{
                searchController.isActive = false  //換頁隱藏搜尋欄
                let selectedIndexPath = MyMedicineTableView.indexPathForSelectedRow
                if let selectedRow = selectedIndexPath?.row{
//                    dvc.infoFromViewOne1 = mymedlist[selectedRow].商品名
//                    dvc.infoFromViewOne2 = mymedlist[selectedRow].學名
//                    dvc.infoFromViewOne3 = mymedlist[selectedRow].副作用
//                    dvc.infoFromViewOne4 = mymedlist[selectedRow].適應症
//                    dvc.infoFromViewOne5 = mymedlist[selectedRow].商品代號
                    dvc.infoFromViewOne1 = mymedlist[selectedRow].中文品名
                    dvc.infoFromViewOne2 = mymedlist[selectedRow].英文品名
                    dvc.infoFromViewOne3 = mymedlist[selectedRow].許可證字號
                    dvc.infoFromViewOne4 = mymedlist[selectedRow].仿單圖檔連結
                    dvc.infoFromViewOne5 = mymedlist[selectedRow].外盒圖檔連結
                }
            }
        }
        if segue.identifier == "gotoclassifier1"
        {
            let controller = segue.destination as! ClassifierViewController
            controller.nameText = String(titletext)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 依個人需求決定如何實作
        isShowMySearchResult = false
        appear()
        
    }
    
    @IBAction func Switch(_ sender: UIButton) {
        viewDidLoad()
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in  //讀濕度
            let boxid = DataSnapshot.value as! String
            if boxid == "amkdajdal"{
                self.ref.child("boxes").child(boxid).child("ONE").observeSingleEvent(of: .value, with: { snapshot in
                    let box1array = snapshot.value as! NSArray
                    print(box1array)
                    var box1objCArray = NSMutableArray(array: box1array)
                    let box1swiftArray: [Double] = box1objCArray.compactMap({ $0 as? Double })
                    let box1lastdata = box1swiftArray[(box1swiftArray.count) - 1]
                    let box1lastseconddata = box1swiftArray[(box1swiftArray.count) - 2]
                    if box1lastseconddata - box1lastdata > 5 {
                        print("alreadly ate box 1")

                    }else if box1lastseconddata - box1lastdata <= 5 {
                        print("go to eat box 1")
                    }
                })
            }else{print("尚未設定")}
        }
//
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let boxid = DataSnapshot.value as! String
//            print(boxid)
//            self.ref.child("boxes").child(boxid).child("one").child("0").observeSingleEvent(of: .value, with: { (snapshot) in
//            let box1value = snapshot.value as? NSDictionary
//                print("box1:\(box1value)")
//            let box1dic:[Int:Double] = box1value as! Dictionary
//            let box1sortedByKey = box1dic.values.sorted(by: <)  //把重量從小到大排序
//            let box1lastdata = box1sortedByKey[0]
//            let box1lastseconddata = box1sortedByKey[1]
//            if box1lastseconddata - box1lastdata > 5 {
//                print("alreadly ate box 1")
//
//            }else if box1lastseconddata - box1lastdata <= 5 {
//                print("go to eat box 1")
//                self.box6notify()
//            }
//
//            })
//        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("重量").observeSingleEvent(of: .value, with: { (snapshot) in
        let box6value = snapshot.value as? NSDictionary
            print("\(box6value)")
        let box6dic:[String:Double] = box6value as! Dictionary
        let box6sortedByKey = box6dic.values.sorted(by: <)  //把重量從小到大排序
        let box6lastdata = box6sortedByKey[0]
        let box6lastseconddata = box6sortedByKey[1]
            if box6lastseconddata - box6lastdata > 5 {
                print("aaaaa")
            }else{
                print("bbbbb")
            }
            
        })
        
        
    }
    
    @IBAction func Notification(_ sender: Any) {  //試做按了按鈕讀取box1的重量  拿來用移除藥盒藥物
        
        if RemoveboxButton.titleLabel!.text == "移除藥盒藥物"{
            if Btn1.titleLabel!.text == "暫無藥物"{
                Removebox1Button.isHidden = true
            }else if Btn1.titleLabel!.text != "暫無藥物"{
                Removebox1Button.isHidden = false
            }
            
            if Btn2.titleLabel!.text == "暫無藥物"{
                Removebox2Button.isHidden = true
            }else if Btn2.titleLabel!.text != "暫無藥物"{
                Removebox2Button.isHidden = false
            }
            
            if Btn3.titleLabel!.text == "暫無藥物"{
                Removebox3Button.isHidden = true
            }else if Btn3.titleLabel!.text != "暫無藥物"{
                Removebox3Button.isHidden = false
            }
            
            if Btn4.titleLabel!.text == "暫無藥物"{
                Removebox4Button.isHidden = true
            }else if Btn4.titleLabel!.text != "暫無藥物"{
                Removebox4Button.isHidden = false
            }
            
            if Btn5.titleLabel!.text == "暫無藥物"{
                Removebox5Button.isHidden = true
            }else if Btn5.titleLabel!.text != "暫無藥物"{
                Removebox5Button.isHidden = false
            }
            
            if Btn6.titleLabel!.text == "暫無藥物"{
                Removebox6Button.isHidden = true
            }else if Btn6.titleLabel!.text != "暫無藥物"{
                Removebox6Button.isHidden = false
            }
            RemoveboxButton.setTitle("完成", for: .normal)
        }else if RemoveboxButton.titleLabel!.text == "完成"{
            RemoveboxButton.setTitle("移除藥盒藥物", for: .normal)
            Removebox1Button.isHidden = true
            Removebox2Button.isHidden = true
            Removebox3Button.isHidden = true
            Removebox4Button.isHidden = true
            Removebox5Button.isHidden = true
            Removebox6Button.isHidden = true
        }
    }
    
    @IBAction func Removebox1(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
            let box1name = DataSnapshot.value as! String
            let alertController = UIAlertController(
                title: "提醒",
                message:
                "目前第一格所放置的藥物為：\n" + box1name + "\n" +
                    "請問是否要刪除"
                ,preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "是",
                style: .destructive)
            { (_) in
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/藥物名稱").setValue("暫無藥物")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/重量/test01").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/重量/test02").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/濕度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/溫度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/吃藥時間").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("尚未設定")
                self.Removebox1Button.isHidden = true
            }
            alertController.addAction(okAction)
            let cancelAction = UIAlertAction(title: "否", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(
                alertController,
                animated: true,
                completion: nil)
        }
    }
    
    @IBAction func Removebox2(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
            let box2name = DataSnapshot.value as! String
            let alertController = UIAlertController(
                title: "提醒",
                message:
                "目前第二格所放置的藥物為：\n" + box2name + "\n" +
                "請問是否要刪除"
                ,preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "是",
                style: .destructive)
            { (_) in
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/藥物名稱").setValue("暫無藥物")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/重量/test01").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/重量/test02").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/濕度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/溫度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/吃藥時間").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box2/是否睡前服用").setValue("尚未設定")
                self.Removebox2Button.isHidden = true
            }
            alertController.addAction(okAction)
            let cancelAction = UIAlertAction(title: "否", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(
                alertController,
                animated: true,
                completion: nil)
        }
    }
    
    @IBAction func Removebox3(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
            let box3name = DataSnapshot.value as! String
            let alertController = UIAlertController(
                title: "提醒",
                message:
                "目前第三格所放置的藥物為：\n" + box3name + "\n" +
                "請問是否要刪除"
                ,preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "是",
                style: .destructive)
            { (_) in
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/藥物名稱").setValue("暫無藥物")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/重量/test01").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/重量/test02").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/濕度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/溫度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/吃藥時間").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box3/是否睡前服用").setValue("尚未設定")
                self.Removebox3Button.isHidden = true
            }
            alertController.addAction(okAction)
            let cancelAction = UIAlertAction(title: "否", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(
                alertController,
                animated: true,
                completion: nil)
        }
    }
    
    @IBAction func Removebox4(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
            let box4name = DataSnapshot.value as! String
            let alertController = UIAlertController(
                title: "提醒",
                message:
                "目前第四格所放置的藥物為：\n" + box4name + "\n" +
                "請問是否要刪除"
                ,preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "是",
                style: .destructive)
            { (_) in
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/藥物名稱").setValue("暫無藥物")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/重量/test01").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/重量/test02").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/濕度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/溫度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/吃藥時間").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box4/是否睡前服用").setValue("尚未設定")
                self.Removebox4Button.isHidden = true
            }
            alertController.addAction(okAction)
            let cancelAction = UIAlertAction(title: "否", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(
                alertController,
                animated: true,
                completion: nil)
        }
    }
    
    @IBAction func Removebox5(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
            let box5name = DataSnapshot.value as! String
            let alertController = UIAlertController(
                title: "提醒",
                message:
                "目前第五格所放置的藥物為：\n" + box5name + "\n" +
                "請問是否要刪除"
                ,preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "是",
                style: .destructive)
            { (_) in
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/藥物名稱").setValue("暫無藥物")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/重量/test01").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/重量/test02").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/濕度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/溫度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/吃藥時間").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box5/是否睡前服用").setValue("尚未設定")
                self.Removebox5Button.isHidden = true
            }
            alertController.addAction(okAction)
            let cancelAction = UIAlertAction(title: "否", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(
                alertController,
                animated: true,
                completion: nil)
        }
    }
    
    @IBAction func Removebox6(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
            let box6name = DataSnapshot.value as! String
            let alertController = UIAlertController(
                title: "提醒",
                message:
                "目前第六格所放置的藥物為：\n" + box6name + "\n" +
                "請問是否要刪除"
                ,preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "是",
                style: .destructive)
            { (_) in
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/藥物名稱").setValue("暫無藥物")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/重量/test01").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/重量/test02").setValue(9999999)
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/濕度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/溫度").setValue("")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/吃藥時間").setValue("尚未設定")
                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box6/是否睡前服用").setValue("尚未設定")
                self.Removebox6Button.isHidden = true
            }
            alertController.addAction(okAction)
            let cancelAction = UIAlertAction(title: "否", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(
                alertController,
                animated: true,
                completion: nil)
        }
    }
    
    
    @IBAction func Btn001(_ sender: Any) {
        let ref = Database.database().reference()
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("溫度").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let box1tem = DataSnapshot.value as! String
//            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("濕度").observeSingleEvent(of: .value) { (DataSnapshot) in
//                let box1hum = DataSnapshot.value as! String
                //        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("重量").observeSingleEvent(of: .value) { (DataSnapshot) in
                //            let box1wei = DataSnapshot.value as! String
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "家屬"{
                ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box1name = DataSnapshot.value as! String
                    ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box1").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let box1time = DataSnapshot.value as! String
                        ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let box1sleep = DataSnapshot.value as! String
                            
                            let alertController = UIAlertController(
                                title: "第一格 資訊",
                                message:
                                "目前第一格所放置的藥物為：" + box1name + "\n" +
                                    //" \n藥盒溫度：" + box1tem  +
                                    //" \n藥盒濕度：" + box1hum  +
                                    " \n鬧鐘時間：" + box1time +
                                    " \n睡前是否需要吃藥：" + box1sleep
                                //+" \n藥盒重量：" + box1wei,//+ box1tem,
                                ,preferredStyle: .alert)
                            
                            
                            // 建立[送出]按鈕
                            let okAction = UIAlertAction(
                                title: "OK",
                                style: .default)

                            alertController.addAction(okAction)
                            
                            // 顯示提示框
                            self.present(
                                alertController,
                                animated: true,
                                completion: nil)
                        }}}
            }else{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box1name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let box1time = DataSnapshot.value as! String
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let box1sleep = DataSnapshot.value as! String
                            
                            let alertController = UIAlertController(
                                title: "第一格 資訊",
                                message:
                                "目前第一格所放置的藥物為：" + box1name + "\n" +
                                    //" \n藥盒溫度：" + box1tem  +
                                    //" \n藥盒濕度：" + box1hum  +
                                    " \n鬧鐘時間：" + box1time +
                                    " \n睡前是否需要吃藥：" + box1sleep
                                //+" \n藥盒重量：" + box1wei,//+ box1tem,
                                ,preferredStyle: .alert)
                            
                            
                            // 建立[送出]按鈕
                            let okAction = UIAlertAction(
                                title: "設定鬧鐘",
                                style: .destructive)
                            { (_) in
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
                            alertController.addAction(okAction)
                            
                            let cancelAction = UIAlertAction(title: "我知道了", style: .cancel, handler: nil)
                            alertController.addAction(cancelAction)
                            
                            // 顯示提示框
                            self.present(
                                alertController,
                                animated: true,
                                completion: nil)
                        }}}
            }
        }
//                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
//                    let box1name = DataSnapshot.value as! String
//                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
//                        let box1time = DataSnapshot.value as! String
//                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
//                            let box1sleep = DataSnapshot.value as! String
//
//                            let alertController = UIAlertController(
//                                title: "第一格 資訊",
//                                message:
//                                "目前第一格所放置的藥物為：" + box1name + "\n" +
//                                    //" \n藥盒溫度：" + box1tem  +
//                                    //" \n藥盒濕度：" + box1hum  +
//                                    " \n鬧鐘時間：" + box1time +
//                                    " \n睡前是否需要吃藥：" + box1sleep
//                                //+" \n藥盒重量：" + box1wei,//+ box1tem,
//                                ,preferredStyle: .alert)
//
//
//                            // 建立[送出]按鈕
//                            let okAction = UIAlertAction(
//                                title: "設定鬧鐘",
//                                style: .destructive)
//                            { (_) in
//                                let controller = UIAlertController(title: "食用時間設定", message: "請選取食用時間", preferredStyle: .actionSheet)
//                                let names = ["三餐飯前", "三餐飯後", "早晚飯前", "早晚飯後", "睡前"]
//                                for name in names {
//                                    let action = UIAlertAction(title: name, style: .default) { (action) in
//                                        print(action.title)
//                                        ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/吃藥時間").setValue(action.title)
//
//                                        if action.title != "睡前"
//                                        {
//                                            let controller = UIAlertController(title: "", message: "請問睡前是否需要服用藥物?", preferredStyle: .alert)
//                                            let okAction = UIAlertAction(title: "是", style: .default) { (_) in
//                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("是")
//                                            }
//                                            controller.addAction(okAction)
//                                            let cancelAction = UIAlertAction(title: "否", style: .cancel){ (_) in
//                                                ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("否")
//                                            }
//                                            controller.addAction(cancelAction)
//                                            self.present(controller, animated: true, completion: nil)
//                                        }
//                                        else
//                                        {
//                                            ref.child("users/\(Auth.auth().currentUser!.uid)/BoxStatus/box1/是否睡前服用").setValue("是")
//                                        }
//                                    }
//                                    controller.addAction(action)
//                                }
//                                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//                                controller.addAction(cancelAction)
//                                self.present(controller, animated: true, completion: nil)
//                            }
//                            alertController.addAction(okAction)
//
//                            let cancelAction = UIAlertAction(title: "我知道了", style: .cancel, handler: nil)
//                            alertController.addAction(cancelAction)
//
//                            // 顯示提示框
//                            self.present(
//                                alertController,
//                                animated: true,
//                                completion: nil)
//                        }}}
    }
    
    
    
    
    @IBAction func Btn002(_ sender: Any) {
        let ref = Database.database().reference()
        //ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("溫度").observeSingleEvent(of: .value) { (DataSnapshot) in
        //let box2tem = DataSnapshot.value as! String
        //ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("濕度").observeSingleEvent(of: .value) { (DataSnapshot) in
        //let box2hum = DataSnapshot.value as! String
        // ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("重量").observeSingleEvent(of: .value) { (DataSnapshot) in
        //let box2wei = DataSnapshot.value as! String
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "家屬"{
                ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box2name = DataSnapshot.value as! String
                ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box2").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box2time = DataSnapshot.value as! String
                ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box2sleep = DataSnapshot.value as! String
                    let alertController = UIAlertController(
                    title: "第二格 資訊",
                            message:
                            "目前第二格所放置的藥物為：" + box2name + "\n" +
                                //" \n藥盒溫度：" + box2tem  +
                                //" \n藥盒濕度：" + box2hum  +
                                " \n鬧鐘時間：" + box2time +
                                " \n睡前是否需要吃藥：" + box2sleep,
                                //+" \n藥盒重量：" + box2wei,//+ box1tem,
                            preferredStyle: .alert)
                                
                                
                                // 建立[送出]按鈕
                                let okAction = UIAlertAction(
                                    title: "OK",
                                    style: .default)

                                alertController.addAction(okAction)
                                
                                
                                // 顯示提示框
                                self.present(
                                    alertController,
                                    animated: true,
                                    completion: nil)
                    }}}//}
            }else{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box2name = DataSnapshot.value as! String
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box2time = DataSnapshot.value as! String
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box2sleep = DataSnapshot.value as! String
                    let alertController = UIAlertController(
                    title: "第二格 資訊",
                            message:
                            "目前第二格所放置的藥物為：" + box2name + "\n" +
                                //" \n藥盒溫度：" + box2tem  +
                                //" \n藥盒濕度：" + box2hum  +
                                " \n鬧鐘時間：" + box2time +
                                " \n睡前是否需要吃藥：" + box2sleep,
                                //+" \n藥盒重量：" + box2wei,//+ box1tem,
                            preferredStyle: .alert)
                                
                                
                                // 建立[送出]按鈕
                                let okAction = UIAlertAction(
                                    title: "設定鬧鐘",
                                    style: .destructive)
                                { (_) in
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
                                alertController.addAction(okAction)
                                
                                let cancelAction = UIAlertAction(title: "我知道了", style: .cancel, handler: nil)
                                alertController.addAction(cancelAction)
                                
                                // 顯示提示框
                                self.present(
                                    alertController,
                                    animated: true,
                                    completion: nil)
                    }}}//}
            }
        }

    }
    
    @IBAction func Btn003(_ sender: Any) {
        let ref = Database.database().reference()
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("溫度").observeSingleEvent(of: .value) { (DataSnapshot) in
//        let box3tem = DataSnapshot.value as! String
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("濕度").observeSingleEvent(of: .value) { (DataSnapshot) in
//        let box3hum = DataSnapshot.value as! String
                //ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("重量").observeSingleEvent(of: .value) { (DataSnapshot) in
                    //let box3wei = DataSnapshot.value as! String
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "家屬"{
                ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box3name = DataSnapshot.value as! String
                ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box3").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box3time = DataSnapshot.value as! String
                ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box3sleep = DataSnapshot.value as! String
                                let alertController = UIAlertController(
                                    title: "第三格 資訊",
                                    message:
                                    "目前第三格所放置的藥物為：" + box3name + "\n" +
                                        //" \n藥盒溫度：" + box3tem  +
                                        //" \n藥盒濕度：" + box3hum +
                                        " \n鬧鐘時間：" + box3time +
                                        " \n睡前是否需要吃藥：" + box3sleep,
                                        //+" \n藥盒重量：" + box3wei,//+ box1tem,
                                    preferredStyle: .alert)
                                
                                
                                // 建立[送出]按鈕
                                let okAction = UIAlertAction(
                                    title: "OK",
                                    style: .default)

                                alertController.addAction(okAction)
                                

                                
                                // 顯示提示框
                                self.present(
                                    alertController,
                                    animated: true,
                                    completion: nil)
                    }}}//}
            }else{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box3name = DataSnapshot.value as! String
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box3time = DataSnapshot.value as! String
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                let box3sleep = DataSnapshot.value as! String
                                let alertController = UIAlertController(
                                    title: "第三格 資訊",
                                    message:
                                    "目前第三格所放置的藥物為：" + box3name + "\n" +
                                        //" \n藥盒溫度：" + box3tem  +
                                        //" \n藥盒濕度：" + box3hum +
                                        " \n鬧鐘時間：" + box3time +
                                        " \n睡前是否需要吃藥：" + box3sleep,
                                        //+" \n藥盒重量：" + box3wei,//+ box1tem,
                                    preferredStyle: .alert)
                                
                                
                                // 建立[送出]按鈕
                                let okAction = UIAlertAction(
                                    title: "設定鬧鐘",
                                    style: .destructive)
                                { (_) in
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
                                alertController.addAction(okAction)
                                
                                let cancelAction = UIAlertAction(title: "我知道了", style: .cancel, handler: nil)
                                alertController.addAction(cancelAction)
                                
                                // 顯示提示框
                                self.present(
                                    alertController,
                                    animated: true,
                                    completion: nil)
                    }}}//}
            }
        }
        

    }
    
    
    @IBAction func Btn004(_ sender: Any) {
        let ref = Database.database().reference()
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("溫度").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let box4tem = DataSnapshot.value as! String
//            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("濕度").observeSingleEvent(of: .value) { (DataSnapshot) in
//                let box4hum = DataSnapshot.value as! String
                //ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("重量").observeSingleEvent(of: .value) { (DataSnapshot) in
                    //let box4wei = DataSnapshot.value as! String
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "家屬"{
                ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box4name = DataSnapshot.value as! String
                    ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box4").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let box4time = DataSnapshot.value as! String
                        ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let box4sleep = DataSnapshot.value as! String
                    let alertController = UIAlertController(
                        title: "第四格 資訊",
                        message:
                        "目前第四格所放置的藥物為：" + box4name + "\n" +
                            //" \n藥盒溫度：" + box4tem  +
                            //" \n藥盒濕度：" + box4hum +
                            " \n鬧鐘時間：" + box4time +
                            " \n睡前是否需要吃藥：" + box4sleep,
                            //+" \n藥盒重量：" + box4wei,//+ box1tem,
                        preferredStyle: .alert)
                    
                    
                    // 建立[送出]按鈕
                    let okAction = UIAlertAction(
                        title: "OK",
                        style: .default)

                    alertController.addAction(okAction)
                    

                    // 顯示提示框
                    self.present(
                        alertController,
                        animated: true,
                        completion: nil)
                        }}}//}
            }else{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box4name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let box4time = DataSnapshot.value as! String
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let box4sleep = DataSnapshot.value as! String
                    let alertController = UIAlertController(
                        title: "第四格 資訊",
                        message:
                        "目前第四格所放置的藥物為：" + box4name + "\n" +
                            //" \n藥盒溫度：" + box4tem  +
                            //" \n藥盒濕度：" + box4hum +
                            " \n鬧鐘時間：" + box4time +
                            " \n睡前是否需要吃藥：" + box4sleep,
                            //+" \n藥盒重量：" + box4wei,//+ box1tem,
                        preferredStyle: .alert)
                    
                    
                    // 建立[送出]按鈕
                    let okAction = UIAlertAction(
                        title: "設定鬧鐘",
                        style: .destructive)
                    { (_) in
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
                    alertController.addAction(okAction)
                    
                    let cancelAction = UIAlertAction(title: "我知道了", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    
                    // 顯示提示框
                    self.present(
                        alertController,
                        animated: true,
                        completion: nil)
                        }}}//}
            }
        }
        

        
    }
    
    
    @IBAction func Btn005(_ sender: Any) {
        let ref = Database.database().reference()
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("溫度").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let box5tem = DataSnapshot.value as! String
//            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("濕度").observeSingleEvent(of: .value) { (DataSnapshot) in
//                let box5hum = DataSnapshot.value as! String
                //ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("重量").observeSingleEvent(of: .value) { (DataSnapshot) in
                    //let box5wei = DataSnapshot.value as! String
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "家屬"{
                ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box5name = DataSnapshot.value as! String
                    ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box5").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let box5time = DataSnapshot.value as! String
                        ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let box5sleep = DataSnapshot.value as! String
                    let alertController = UIAlertController(
                        title: "第五格 資訊",
                        message:
                        "目前第五格所放置的藥物為：" + box5name + "\n" +
                            //" \n藥盒溫度：" + box5tem  +
                            //" \n藥盒濕度：" + box5hum +
                            " \n鬧鐘時間：" + box5time +
                            " \n睡前是否需要吃藥：" + box5sleep,
                            //+" \n藥盒重量：" + box5wei,//+ box1tem,
                        preferredStyle: .alert)
                    
                    
                    // 建立[送出]按鈕
                    let okAction = UIAlertAction(
                        title: "OK",
                        style: .default)

                    alertController.addAction(okAction)
                    
                    
                    // 顯示提示框
                    self.present(
                        alertController,
                        animated: true,
                        completion: nil)
                        }}}//}
            }else{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box5name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let box5time = DataSnapshot.value as! String
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let box5sleep = DataSnapshot.value as! String
                    let alertController = UIAlertController(
                        title: "第五格 資訊",
                        message:
                        "目前第五格所放置的藥物為：" + box5name + "\n" +
                            //" \n藥盒溫度：" + box5tem  +
                            //" \n藥盒濕度：" + box5hum +
                            " \n鬧鐘時間：" + box5time +
                            " \n睡前是否需要吃藥：" + box5sleep,
                            //+" \n藥盒重量：" + box5wei,//+ box1tem,
                        preferredStyle: .alert)
                    
                    
                    // 建立[送出]按鈕
                    let okAction = UIAlertAction(
                        title: "設定鬧鐘",
                        style: .destructive)
                    { (_) in
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
                    alertController.addAction(okAction)
                    
                    let cancelAction = UIAlertAction(title: "我知道了", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    
                    // 顯示提示框
                    self.present(
                        alertController,
                        animated: true,
                        completion: nil)
                        }}}//}
            }
        }
        

    }
    
    @IBAction func Btn006(_ sender: Any) {
        let ref = Database.database().reference()
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("溫度").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let box6tem = DataSnapshot.value as! String
//            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("濕度").observeSingleEvent(of: .value) { (DataSnapshot) in
//                let box6hum = DataSnapshot.value as! String
                //ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("重量").observeSingleEvent(of: .value) { (DataSnapshot) in
                   // let box6wei = DataSnapshot.value as! String
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "家屬"{
                ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box6name = DataSnapshot.value as! String
                    ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box6").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let box6time = DataSnapshot.value as! String
                        ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let box6sleep = DataSnapshot.value as! String
                    let alertController = UIAlertController(
                        title: "第六格 資訊",
                        message:
                        "目前第六格所放置的藥物為：" + box6name + "\n" +
                            //" \n藥盒溫度：" + box6tem  +
                            //" \n藥盒濕度：" + box6hum  +
                            " \n鬧鐘時間：" + box6time +
                            " \n睡前是否需要吃藥：" + box6sleep,
                            //+" \n藥盒重量：" + box6wei,//+ box1tem,
                        preferredStyle: .alert)
                    
                    
                    // 建立[送出]按鈕
                    let okAction = UIAlertAction(
                        title: "OK",
                        style: .default)

                    alertController.addAction(okAction)

                    
                    // 顯示提示框
                    self.present(
                        alertController,
                        animated: true,
                        completion: nil)
                        }}}//}
            }else{
                ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("藥物名稱").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let box6name = DataSnapshot.value as! String
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let box6time = DataSnapshot.value as! String
                        ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                            let box6sleep = DataSnapshot.value as! String
                    let alertController = UIAlertController(
                        title: "第六格 資訊",
                        message:
                        "目前第六格所放置的藥物為：" + box6name + "\n" +
                            //" \n藥盒溫度：" + box6tem  +
                            //" \n藥盒濕度：" + box6hum  +
                            " \n鬧鐘時間：" + box6time +
                            " \n睡前是否需要吃藥：" + box6sleep,
                            //+" \n藥盒重量：" + box6wei,//+ box1tem,
                        preferredStyle: .alert)
                    
                    
                    // 建立[送出]按鈕
                    let okAction = UIAlertAction(
                        title: "設定鬧鐘",
                        style: .destructive)
                    { (_) in
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
                    alertController.addAction(okAction)
                    
                    let cancelAction = UIAlertAction(title: "我知道了", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    
                    // 顯示提示框
                    self.present(
                        alertController,
                        animated: true,
                        completion: nil)
                        }}}//}
            }
        }
        

    }
    
    @IBAction func EatSwitch(_ sender: Any) {
        //let tempSwitch = sender as! UISwitch
        let ref = Database.database().reference()
        
        if noticeswitch.isOn {
            ref.child("users/\(Auth.auth().currentUser!.uid)/MedNotice").setValue("True")
            print("打開")
            
            let userID = Auth.auth().currentUser?.uid
            
            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box1
                let eattime = DataSnapshot.value as! String
                if eattime == "三餐飯前"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                        }
                    }
                }else if eattime == "三餐飯後"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                        }
                    }
                }else if eattime == "早晚飯前"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                        }
                    }
                }else if eattime == "早晚飯後"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box1").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                        }
                    }
                }else if eattime == "睡前"{
                    self.NotificBeforeSleep()  //呼叫睡前的通知
                }

            }

            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box2
                let eattime = DataSnapshot.value as! String
                if eattime == "三餐飯前"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                        }
                    }
                }else if eattime == "三餐飯後"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                        }
                    }
                }else if eattime == "早晚飯前"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                        }
                    }
                }else if eattime == "早晚飯後"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box2").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                        }
                    }
                }else if eattime == "睡前"{
                    self.NotificBeforeSleep()  //呼叫睡前的通知
                }
                
            }


            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box3
                let eattime = DataSnapshot.value as! String
                if eattime == "三餐飯前"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                        }
                    }
                }else if eattime == "三餐飯後"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                        }
                    }
                }else if eattime == "早晚飯前"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                        }
                    }
                }else if eattime == "早晚飯後"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box3").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                        }
                    }
                }else if eattime == "睡前"{
                    self.NotificBeforeSleep()  //呼叫睡前的通知
                }
                
            }
            
            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box4
                let eattime = DataSnapshot.value as! String
                if eattime == "三餐飯前"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                        }
                    }
                }else if eattime == "三餐飯後"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                        }
                    }
                }else if eattime == "早晚飯前"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                        }
                    }
                }else if eattime == "早晚飯後"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box4").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                        }
                    }
                }else if eattime == "睡前"{
                    self.NotificBeforeSleep()  //呼叫睡前的通知
                }
                
            }
            
            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box5
                let eattime = DataSnapshot.value as! String
                if eattime == "三餐飯前"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                        }
                    }
                }else if eattime == "三餐飯後"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                        }
                    }
                }else if eattime == "早晚飯前"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                        }
                    }
                }else if eattime == "早晚飯後"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box5").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                        }
                    }
                }else if eattime == "睡前"{
                    self.NotificBeforeSleep()  //呼叫睡前的通知
                }
                
            }
            
            ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("吃藥時間").observeSingleEvent(of: .value) { (DataSnapshot) in     //box6
                let eattime = DataSnapshot.value as! String
                if eattime == "三餐飯前"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificThreeBeforeYes()  //呼叫三餐飯前睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificThreeBeforeNo() //呼叫三餐飯前的通知
                        }
                    }
                }else if eattime == "三餐飯後"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificThreeAfterYes()  //呼叫三餐飯後睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificThreeAfterNo() //呼叫三餐飯後的通知
                        }
                    }
                }else if eattime == "早晚飯前"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificTwoBeforeYes()  //呼叫早晚飯前睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificTwoBeforeNo() //呼叫早晚飯前的通知
                        }
                    }
                }else if eattime == "早晚飯後"{
                    ref.child("users").child(Auth.auth().currentUser!.uid).child("BoxStatus").child("box6").child("是否睡前服用").observeSingleEvent(of: .value) { (DataSnapshot) in
                        let eatbeforebed = DataSnapshot.value as! String
                        if eatbeforebed == "是"{
                            self.NotificTwoAfterYes()  //呼叫早晚飯後睡前的通知
                        }else if eatbeforebed == "否"{
                            self.NotificTwoAfterNo() //呼叫早晚飯後的通知
                        }
                    }
                }else if eattime == "睡前"{
                    self.NotificBeforeSleep()  //呼叫睡前的通知
                }
                
            }
            
        } else {
            ref.child("users/\(Auth.auth().currentUser!.uid)/MedNotice").setValue("False")
            print("關掉")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    
    func NotificThreeBeforeYes(){
        print("三餐飯前睡前")
        let content = UNMutableNotificationContent()
        content.title = "吃藥通知"
        content.body = "該吃藥囉！"
        content.badge = 1
        content.categoryIdentifier = "luckyMessage"
        
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("早餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let breakfasttime = DataSnapshot.value as! String
            print("\(breakfasttime)")

            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date1 = dateFormatter.date(from: breakfasttime)
            date1! = date1! - 1800

            let beforebreakfasttime = dateFormatter.string(from: date1!)
            print("\(beforebreakfasttime)")

            let breakfastdate = Date(timeIntervalSinceNow: 3600)
            var breakfasttriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: breakfastdate)  //每日重複

            let breakfasthour = beforebreakfasttime.prefix(2)
            print("\(breakfasthour)")
            if breakfasthour != nil{
                //triggerDate.hour = Int(breakfasthour)
                breakfasttriggerDaily.hour = Int(breakfasthour)
            }

            let breakfastminute = beforebreakfasttime.suffix(2)
            print("\(breakfastminute)")
            if breakfastminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                breakfasttriggerDaily.minute = Int(breakfastminute)
            }

            breakfasttriggerDaily.second = 00
            content.title = "早餐前吃藥通知"
            let trigger1 = UNCalendarNotificationTrigger(dateMatching: breakfasttriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request1 = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger1)
            UNUserNotificationCenter.current().add(request1, withCompletionHandler: nil)

        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("午餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let lunchtime = DataSnapshot.value as! String
            print("\(lunchtime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date2 = dateFormatter.date(from: lunchtime)
            date2! = date2! - 1800
            
            let beforelunchtime = dateFormatter.string(from: date2!)
            print("\(beforelunchtime)")
            
            let lunchdate = Date(timeIntervalSinceNow: 3600)
            var lunchtriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: lunchdate)  //每日重複
            
            let lunchhour = beforelunchtime.prefix(2)
            print("\(lunchhour)")
            if lunchhour != nil{
                //triggerDate.hour = Int(breakfasthour)
                lunchtriggerDaily.hour = Int(lunchhour)
            }
            
            let lunchminute = beforelunchtime.suffix(2)
            print("\(lunchminute)")
            if lunchminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                lunchtriggerDaily.minute = Int(lunchminute)
            }
            
            lunchtriggerDaily.second = 00
            content.title = "午餐前吃藥通知"
            let trigger2 = UNCalendarNotificationTrigger(dateMatching: lunchtriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request2 = UNNotificationRequest(identifier: "notification2", content: content, trigger: trigger2)
            UNUserNotificationCenter.current().add(request2, withCompletionHandler: nil)
            
        }
 
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("晚餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let dinnertime = DataSnapshot.value as! String
            print("\(dinnertime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date3 = dateFormatter.date(from: dinnertime)
            date3! = date3! - 1800
            
            let beforedinnertime = dateFormatter.string(from: date3!)
            print("\(beforedinnertime)")
            
            let dinnerdate = Date(timeIntervalSinceNow: 3600)
            var dinnertriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: dinnerdate)  //每日重複
            
            let dinnerhour = beforedinnertime.prefix(2)
            print("\(dinnerhour)")
            if dinnerhour != nil{
                //triggerDate.hour = Int(breakfasthour)
                dinnertriggerDaily.hour = Int(dinnerhour)
            }
            
            let dinnerminute = beforedinnertime.suffix(2)
            print("\(dinnerminute)")
            if dinnerminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                dinnertriggerDaily.minute = Int(dinnerminute)
            }
            
            dinnertriggerDaily.second = 00
            content.title = "晚餐前吃藥通知"
            let trigger3 = UNCalendarNotificationTrigger(dateMatching: dinnertriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request3 = UNNotificationRequest(identifier: "notification3", content: content, trigger: trigger3)
            UNUserNotificationCenter.current().add(request3, withCompletionHandler: nil)
            
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("睡覺時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let sleeptime = DataSnapshot.value as! String
            print("\(sleeptime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date4 = dateFormatter.date(from: sleeptime)
            date4! = date4! - 1800
            
            let beforesleeptime = dateFormatter.string(from: date4!)
            print("\(beforesleeptime)")
            
            let sleepdate = Date(timeIntervalSinceNow: 3600)
            var sleeptriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: sleepdate)  //每日重複
            
            let sleephour = beforesleeptime.prefix(2)
            print("\(sleephour)")
            if sleephour != nil{
                //triggerDate.hour = Int(breakfasthour)
                sleeptriggerDaily.hour = Int(sleephour)
            }
            
            let sleepminute = beforesleeptime.suffix(2)
            print("\(sleepminute)")
            if sleepminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                sleeptriggerDaily.minute = Int(sleepminute)
            }
            
            sleeptriggerDaily.second = 00
            content.title = "睡前吃藥通知"
            let trigger4 = UNCalendarNotificationTrigger(dateMatching: sleeptriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request4 = UNNotificationRequest(identifier: "notification4", content: content, trigger: trigger4)
            UNUserNotificationCenter.current().add(request4, withCompletionHandler: nil)
            
        }
        
    }

    func NotificThreeBeforeNo(){
        print("三餐飯前")
        let content = UNMutableNotificationContent()
        content.title = "吃藥通知"
        content.body = "該吃藥囉！"
        content.badge = 1
        content.categoryIdentifier = "luckyMessage"
        
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("早餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let breakfasttime = DataSnapshot.value as! String
            print("\(breakfasttime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date1 = dateFormatter.date(from: breakfasttime)
            date1! = date1! - 1800
            
            let beforebreakfasttime = dateFormatter.string(from: date1!)
            print("\(beforebreakfasttime)")
            
            let breakfastdate = Date(timeIntervalSinceNow: 3600)
            var breakfasttriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: breakfastdate)  //每日重複
            
            let breakfasthour = beforebreakfasttime.prefix(2)
            print("\(breakfasthour)")
            if breakfasthour != nil{
                //triggerDate.hour = Int(breakfasthour)
                breakfasttriggerDaily.hour = Int(breakfasthour)
            }
            
            let breakfastminute = beforebreakfasttime.suffix(2)
            print("\(breakfastminute)")
            if breakfastminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                breakfasttriggerDaily.minute = Int(breakfastminute)
            }
            
            breakfasttriggerDaily.second = 00
            content.title = "早餐前吃藥通知"
            let trigger1 = UNCalendarNotificationTrigger(dateMatching: breakfasttriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request1 = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger1)
            UNUserNotificationCenter.current().add(request1, withCompletionHandler: nil)
            
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("午餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let lunchtime = DataSnapshot.value as! String
            print("\(lunchtime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date2 = dateFormatter.date(from: lunchtime)
            date2! = date2! - 1800
            
            let beforelunchtime = dateFormatter.string(from: date2!)
            print("\(beforelunchtime)")
            
            let lunchdate = Date(timeIntervalSinceNow: 3600)
            var lunchtriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: lunchdate)  //每日重複
            
            let lunchhour = beforelunchtime.prefix(2)
            print("\(lunchhour)")
            if lunchhour != nil{
                //triggerDate.hour = Int(breakfasthour)
                lunchtriggerDaily.hour = Int(lunchhour)
            }
            
            let lunchminute = beforelunchtime.suffix(2)
            print("\(lunchminute)")
            if lunchminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                lunchtriggerDaily.minute = Int(lunchminute)
            }
            
            lunchtriggerDaily.second = 00
            content.title = "午餐前吃藥通知"
            let trigger2 = UNCalendarNotificationTrigger(dateMatching: lunchtriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request2 = UNNotificationRequest(identifier: "notification2", content: content, trigger: trigger2)
            UNUserNotificationCenter.current().add(request2, withCompletionHandler: nil)
            
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("晚餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let dinnertime = DataSnapshot.value as! String
            print("\(dinnertime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date3 = dateFormatter.date(from: dinnertime)
            date3! = date3! - 1800
            
            let beforedinnertime = dateFormatter.string(from: date3!)
            print("\(beforedinnertime)")
            
            let dinnerdate = Date(timeIntervalSinceNow: 3600)
            var dinnertriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: dinnerdate)  //每日重複
            
            let dinnerhour = beforedinnertime.prefix(2)
            print("\(dinnerhour)")
            if dinnerhour != nil{
                //triggerDate.hour = Int(breakfasthour)
                dinnertriggerDaily.hour = Int(dinnerhour)
            }
            
            let dinnerminute = beforedinnertime.suffix(2)
            print("\(dinnerminute)")
            if dinnerminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                dinnertriggerDaily.minute = Int(dinnerminute)
            }
            
            dinnertriggerDaily.second = 00
            content.title = "晚餐前吃藥通知"
            let trigger3 = UNCalendarNotificationTrigger(dateMatching: dinnertriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request3 = UNNotificationRequest(identifier: "notification3", content: content, trigger: trigger3)
            UNUserNotificationCenter.current().add(request3, withCompletionHandler: nil)
            
        }
    }
    
    func NotificThreeAfterYes(){
        print("三餐飯後睡前")
        let content = UNMutableNotificationContent()
        content.title = "吃藥通知"
        content.body = "該吃藥囉！"
        content.badge = 1
        content.categoryIdentifier = "luckyMessage"
        
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("早餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let breakfasttime = DataSnapshot.value as! String
            print("\(breakfasttime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date1 = dateFormatter.date(from: breakfasttime)
            date1! = date1! + 1800
            
            let beforebreakfasttime = dateFormatter.string(from: date1!)
            print("\(beforebreakfasttime)")
            
            let breakfastdate = Date(timeIntervalSinceNow: 3600)
            var breakfasttriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: breakfastdate)  //每日重複
            
            let breakfasthour = beforebreakfasttime.prefix(2)
            print("\(breakfasthour)")
            if breakfasthour != nil{
                //triggerDate.hour = Int(breakfasthour)
                breakfasttriggerDaily.hour = Int(breakfasthour)
            }
            
            let breakfastminute = beforebreakfasttime.suffix(2)
            print("\(breakfastminute)")
            if breakfastminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                breakfasttriggerDaily.minute = Int(breakfastminute)
            }
            
            breakfasttriggerDaily.second = 00
            content.title = "早餐後吃藥通知"
            let trigger5 = UNCalendarNotificationTrigger(dateMatching: breakfasttriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request5 = UNNotificationRequest(identifier: "notification5", content: content, trigger: trigger5)
            UNUserNotificationCenter.current().add(request5, withCompletionHandler: nil)
            
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("午餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let lunchtime = DataSnapshot.value as! String
            print("\(lunchtime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date2 = dateFormatter.date(from: lunchtime)
            date2! = date2! + 1800
            
            let beforelunchtime = dateFormatter.string(from: date2!)
            print("\(beforelunchtime)")
            
            let lunchdate = Date(timeIntervalSinceNow: 3600)
            var lunchtriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: lunchdate)  //每日重複
            
            let lunchhour = beforelunchtime.prefix(2)
            print("\(lunchhour)")
            if lunchhour != nil{
                //triggerDate.hour = Int(breakfasthour)
                lunchtriggerDaily.hour = Int(lunchhour)
            }
            
            let lunchminute = beforelunchtime.suffix(2)
            print("\(lunchminute)")
            if lunchminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                lunchtriggerDaily.minute = Int(lunchminute)
            }
            
            lunchtriggerDaily.second = 00
            content.title = "午餐後吃藥通知"
            let trigger6 = UNCalendarNotificationTrigger(dateMatching: lunchtriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request6 = UNNotificationRequest(identifier: "notification6", content: content, trigger: trigger6)
            UNUserNotificationCenter.current().add(request6, withCompletionHandler: nil)
            
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("晚餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let dinnertime = DataSnapshot.value as! String
            print("\(dinnertime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date3 = dateFormatter.date(from: dinnertime)
            date3! = date3! + 1800
            
            let beforedinnertime = dateFormatter.string(from: date3!)
            print("\(beforedinnertime)")
            
            let dinnerdate = Date(timeIntervalSinceNow: 3600)
            var dinnertriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: dinnerdate)  //每日重複
            
            let dinnerhour = beforedinnertime.prefix(2)
            print("\(dinnerhour)")
            if dinnerhour != nil{
                //triggerDate.hour = Int(breakfasthour)
                dinnertriggerDaily.hour = Int(dinnerhour)
            }
            
            let dinnerminute = beforedinnertime.suffix(2)
            print("\(dinnerminute)")
            if dinnerminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                dinnertriggerDaily.minute = Int(dinnerminute)
            }
            
            dinnertriggerDaily.second = 00
            content.title = "晚餐後吃藥通知"
            let trigger7 = UNCalendarNotificationTrigger(dateMatching: dinnertriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request7 = UNNotificationRequest(identifier: "notification7", content: content, trigger: trigger7)
            UNUserNotificationCenter.current().add(request7, withCompletionHandler: nil)
            
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("睡覺時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let sleeptime = DataSnapshot.value as! String
            print("\(sleeptime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date4 = dateFormatter.date(from: sleeptime)
            date4! = date4! - 1800
            
            let beforesleeptime = dateFormatter.string(from: date4!)
            print("\(beforesleeptime)")
            
            let sleepdate = Date(timeIntervalSinceNow: 3600)
            var sleeptriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: sleepdate)  //每日重複
            
            let sleephour = beforesleeptime.prefix(2)
            print("\(sleephour)")
            if sleephour != nil{
                //triggerDate.hour = Int(breakfasthour)
                sleeptriggerDaily.hour = Int(sleephour)
            }
            
            let sleepminute = beforesleeptime.suffix(2)
            print("\(sleepminute)")
            if sleepminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                sleeptriggerDaily.minute = Int(sleepminute)
            }
            
            sleeptriggerDaily.second = 00
            content.title = "睡前吃藥通知"
            let trigger4 = UNCalendarNotificationTrigger(dateMatching: sleeptriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request4 = UNNotificationRequest(identifier: "notification4", content: content, trigger: trigger4)
            UNUserNotificationCenter.current().add(request4, withCompletionHandler: nil)
            
        }
    }
    
    func NotificThreeAfterNo(){
        print("三餐飯後")
        let content = UNMutableNotificationContent()
        content.title = "吃藥通知"
        content.body = "該吃藥囉！"
        content.badge = 1
        content.categoryIdentifier = "luckyMessage"
        
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("早餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let breakfasttime = DataSnapshot.value as! String
            print("\(breakfasttime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date1 = dateFormatter.date(from: breakfasttime)
            date1! = date1! + 1800
            
            let beforebreakfasttime = dateFormatter.string(from: date1!)
            print("\(beforebreakfasttime)")
            
            let breakfastdate = Date(timeIntervalSinceNow: 3600)
            var breakfasttriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: breakfastdate)  //每日重複
            
            let breakfasthour = beforebreakfasttime.prefix(2)
            print("\(breakfasthour)")
            if breakfasthour != nil{
                //triggerDate.hour = Int(breakfasthour)
                breakfasttriggerDaily.hour = Int(breakfasthour)
            }
            
            let breakfastminute = beforebreakfasttime.suffix(2)
            print("\(breakfastminute)")
            if breakfastminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                breakfasttriggerDaily.minute = Int(breakfastminute)
            }
            
            breakfasttriggerDaily.second = 00
            content.title = "早餐後吃藥通知"
            let trigger5 = UNCalendarNotificationTrigger(dateMatching: breakfasttriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request5 = UNNotificationRequest(identifier: "notification5", content: content, trigger: trigger5)
            UNUserNotificationCenter.current().add(request5, withCompletionHandler: nil)
            
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("午餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let lunchtime = DataSnapshot.value as! String
            print("\(lunchtime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date2 = dateFormatter.date(from: lunchtime)
            date2! = date2! + 1800
            
            let beforelunchtime = dateFormatter.string(from: date2!)
            print("\(beforelunchtime)")
            
            let lunchdate = Date(timeIntervalSinceNow: 3600)
            var lunchtriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: lunchdate)  //每日重複
            
            let lunchhour = beforelunchtime.prefix(2)
            print("\(lunchhour)")
            if lunchhour != nil{
                //triggerDate.hour = Int(breakfasthour)
                lunchtriggerDaily.hour = Int(lunchhour)
            }
            
            let lunchminute = beforelunchtime.suffix(2)
            print("\(lunchminute)")
            if lunchminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                lunchtriggerDaily.minute = Int(lunchminute)
            }
            
            lunchtriggerDaily.second = 00
            content.title = "午餐後吃藥通知"
            let trigger6 = UNCalendarNotificationTrigger(dateMatching: lunchtriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request6 = UNNotificationRequest(identifier: "notification6", content: content, trigger: trigger6)
            UNUserNotificationCenter.current().add(request6, withCompletionHandler: nil)
            
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("晚餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let dinnertime = DataSnapshot.value as! String
            print("\(dinnertime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date3 = dateFormatter.date(from: dinnertime)
            date3! = date3! + 1800
            
            let beforedinnertime = dateFormatter.string(from: date3!)
            print("\(beforedinnertime)")
            
            let dinnerdate = Date(timeIntervalSinceNow: 3600)
            var dinnertriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: dinnerdate)  //每日重複
            
            let dinnerhour = beforedinnertime.prefix(2)
            print("\(dinnerhour)")
            if dinnerhour != nil{
                //triggerDate.hour = Int(breakfasthour)
                dinnertriggerDaily.hour = Int(dinnerhour)
            }
            
            let dinnerminute = beforedinnertime.suffix(2)
            print("\(dinnerminute)")
            if dinnerminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                dinnertriggerDaily.minute = Int(dinnerminute)
            }
            
            dinnertriggerDaily.second = 00
            content.title = "晚餐後吃藥通知"
            let trigger7 = UNCalendarNotificationTrigger(dateMatching: dinnertriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request7 = UNNotificationRequest(identifier: "notification7", content: content, trigger: trigger7)
            UNUserNotificationCenter.current().add(request7, withCompletionHandler: nil)
            
        }
    }
    
    func NotificTwoBeforeYes(){
        print("早晚飯前睡前")
        let content = UNMutableNotificationContent()
        content.title = "吃藥通知"
        content.body = "該吃藥囉！"
        content.badge = 1
        content.categoryIdentifier = "luckyMessage"
        
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("早餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let breakfasttime = DataSnapshot.value as! String
            print("\(breakfasttime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date1 = dateFormatter.date(from: breakfasttime)
            date1! = date1! - 1800
            
            let beforebreakfasttime = dateFormatter.string(from: date1!)
            print("\(beforebreakfasttime)")
            
            let breakfastdate = Date(timeIntervalSinceNow: 3600)
            var breakfasttriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: breakfastdate)  //每日重複
            
            let breakfasthour = beforebreakfasttime.prefix(2)
            print("\(breakfasthour)")
            if breakfasthour != nil{
                //triggerDate.hour = Int(breakfasthour)
                breakfasttriggerDaily.hour = Int(breakfasthour)
            }
            
            let breakfastminute = beforebreakfasttime.suffix(2)
            print("\(breakfastminute)")
            if breakfastminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                breakfasttriggerDaily.minute = Int(breakfastminute)
            }
            
            breakfasttriggerDaily.second = 00
            content.title = "早餐前吃藥通知"
            let trigger1 = UNCalendarNotificationTrigger(dateMatching: breakfasttriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request1 = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger1)
            UNUserNotificationCenter.current().add(request1, withCompletionHandler: nil)
            
        }
        
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("晚餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let dinnertime = DataSnapshot.value as! String
            print("\(dinnertime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date3 = dateFormatter.date(from: dinnertime)
            date3! = date3! - 1800
            
            let beforedinnertime = dateFormatter.string(from: date3!)
            print("\(beforedinnertime)")
            
            let dinnerdate = Date(timeIntervalSinceNow: 3600)
            var dinnertriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: dinnerdate)  //每日重複
            
            let dinnerhour = beforedinnertime.prefix(2)
            print("\(dinnerhour)")
            if dinnerhour != nil{
                //triggerDate.hour = Int(breakfasthour)
                dinnertriggerDaily.hour = Int(dinnerhour)
            }
            
            let dinnerminute = beforedinnertime.suffix(2)
            print("\(dinnerminute)")
            if dinnerminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                dinnertriggerDaily.minute = Int(dinnerminute)
            }
            
            dinnertriggerDaily.second = 00
            content.title = "晚餐前吃藥通知"
            let trigger3 = UNCalendarNotificationTrigger(dateMatching: dinnertriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request3 = UNNotificationRequest(identifier: "notification3", content: content, trigger: trigger3)
            UNUserNotificationCenter.current().add(request3, withCompletionHandler: nil)
            
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("睡覺時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let sleeptime = DataSnapshot.value as! String
            print("\(sleeptime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date4 = dateFormatter.date(from: sleeptime)
            date4! = date4! - 1800
            
            let beforesleeptime = dateFormatter.string(from: date4!)
            print("\(beforesleeptime)")
            
            let sleepdate = Date(timeIntervalSinceNow: 3600)
            var sleeptriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: sleepdate)  //每日重複
            
            let sleephour = beforesleeptime.prefix(2)
            print("\(sleephour)")
            if sleephour != nil{
                //triggerDate.hour = Int(breakfasthour)
                sleeptriggerDaily.hour = Int(sleephour)
            }
            
            let sleepminute = beforesleeptime.suffix(2)
            print("\(sleepminute)")
            if sleepminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                sleeptriggerDaily.minute = Int(sleepminute)
            }
            
            sleeptriggerDaily.second = 00
            content.title = "睡前吃藥通知"
            let trigger4 = UNCalendarNotificationTrigger(dateMatching: sleeptriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request4 = UNNotificationRequest(identifier: "notification4", content: content, trigger: trigger4)
            UNUserNotificationCenter.current().add(request4, withCompletionHandler: nil)
            
        }
    }
    
    func NotificTwoBeforeNo(){
        print("早晚飯前")
        let content = UNMutableNotificationContent()
        content.title = "吃藥通知"
        content.body = "該吃藥囉！"
        content.badge = 1
        content.categoryIdentifier = "luckyMessage"
        
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("早餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let breakfasttime = DataSnapshot.value as! String
            print("\(breakfasttime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date1 = dateFormatter.date(from: breakfasttime)
            date1! = date1! - 1800
            
            let beforebreakfasttime = dateFormatter.string(from: date1!)
            print("\(beforebreakfasttime)")
            
            let breakfastdate = Date(timeIntervalSinceNow: 3600)
            var breakfasttriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: breakfastdate)  //每日重複
            
            let breakfasthour = beforebreakfasttime.prefix(2)
            print("\(breakfasthour)")
            if breakfasthour != nil{
                //triggerDate.hour = Int(breakfasthour)
                breakfasttriggerDaily.hour = Int(breakfasthour)
            }
            
            let breakfastminute = beforebreakfasttime.suffix(2)
            print("\(breakfastminute)")
            if breakfastminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                breakfasttriggerDaily.minute = Int(breakfastminute)
            }
            
            breakfasttriggerDaily.second = 00
            content.title = "早餐前吃藥通知"
            let trigger1 = UNCalendarNotificationTrigger(dateMatching: breakfasttriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request1 = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger1)
            UNUserNotificationCenter.current().add(request1, withCompletionHandler: nil)
            
        }
        
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("晚餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let dinnertime = DataSnapshot.value as! String
            print("\(dinnertime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date3 = dateFormatter.date(from: dinnertime)
            date3! = date3! - 1800
            
            let beforedinnertime = dateFormatter.string(from: date3!)
            print("\(beforedinnertime)")
            
            let dinnerdate = Date(timeIntervalSinceNow: 3600)
            var dinnertriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: dinnerdate)  //每日重複
            
            let dinnerhour = beforedinnertime.prefix(2)
            print("\(dinnerhour)")
            if dinnerhour != nil{
                //triggerDate.hour = Int(breakfasthour)
                dinnertriggerDaily.hour = Int(dinnerhour)
            }
            
            let dinnerminute = beforedinnertime.suffix(2)
            print("\(dinnerminute)")
            if dinnerminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                dinnertriggerDaily.minute = Int(dinnerminute)
            }
            
            dinnertriggerDaily.second = 00
            content.title = "晚餐前吃藥通知"
            let trigger3 = UNCalendarNotificationTrigger(dateMatching: dinnertriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request3 = UNNotificationRequest(identifier: "notification3", content: content, trigger: trigger3)
            UNUserNotificationCenter.current().add(request3, withCompletionHandler: nil)
            
            
        }
    }
    
    func NotificTwoAfterYes(){
        print("早晚飯後睡前")
        let content = UNMutableNotificationContent()
        content.title = "吃藥通知"
        content.body = "該吃藥囉！"
        content.badge = 1
        content.categoryIdentifier = "luckyMessage"
        
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("早餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let breakfasttime = DataSnapshot.value as! String
            print("\(breakfasttime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date1 = dateFormatter.date(from: breakfasttime)
            date1! = date1! + 1800
            
            let beforebreakfasttime = dateFormatter.string(from: date1!)
            print("\(beforebreakfasttime)")
            
            let breakfastdate = Date(timeIntervalSinceNow: 3600)
            var breakfasttriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: breakfastdate)  //每日重複
            
            let breakfasthour = beforebreakfasttime.prefix(2)
            print("\(breakfasthour)")
            if breakfasthour != nil{
                //triggerDate.hour = Int(breakfasthour)
                breakfasttriggerDaily.hour = Int(breakfasthour)
            }
            
            let breakfastminute = beforebreakfasttime.suffix(2)
            print("\(breakfastminute)")
            if breakfastminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                breakfasttriggerDaily.minute = Int(breakfastminute)
            }
            
            breakfasttriggerDaily.second = 00
            content.title = "早餐後吃藥通知"
            let trigger5 = UNCalendarNotificationTrigger(dateMatching: breakfasttriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request5 = UNNotificationRequest(identifier: "notification5", content: content, trigger: trigger5)
            UNUserNotificationCenter.current().add(request5, withCompletionHandler: nil)
            
        }
        
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("晚餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let dinnertime = DataSnapshot.value as! String
            print("\(dinnertime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date3 = dateFormatter.date(from: dinnertime)
            date3! = date3! + 1800
            
            let beforedinnertime = dateFormatter.string(from: date3!)
            print("\(beforedinnertime)")
            
            let dinnerdate = Date(timeIntervalSinceNow: 3600)
            var dinnertriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: dinnerdate)  //每日重複
            
            let dinnerhour = beforedinnertime.prefix(2)
            print("\(dinnerhour)")
            if dinnerhour != nil{
                //triggerDate.hour = Int(breakfasthour)
                dinnertriggerDaily.hour = Int(dinnerhour)
            }
            
            let dinnerminute = beforedinnertime.suffix(2)
            print("\(dinnerminute)")
            if dinnerminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                dinnertriggerDaily.minute = Int(dinnerminute)
            }
            
            dinnertriggerDaily.second = 00
            content.title = "晚餐後吃藥通知"
            let trigger7 = UNCalendarNotificationTrigger(dateMatching: dinnertriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request7 = UNNotificationRequest(identifier: "notification7", content: content, trigger: trigger7)
            UNUserNotificationCenter.current().add(request7, withCompletionHandler: nil)
            
        }
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("睡覺時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let sleeptime = DataSnapshot.value as! String
            print("\(sleeptime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date4 = dateFormatter.date(from: sleeptime)
            date4! = date4! - 1800
            
            let beforesleeptime = dateFormatter.string(from: date4!)
            print("\(beforesleeptime)")
            
            let sleepdate = Date(timeIntervalSinceNow: 3600)
            var sleeptriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: sleepdate)  //每日重複
            
            let sleephour = beforesleeptime.prefix(2)
            print("\(sleephour)")
            if sleephour != nil{
                //triggerDate.hour = Int(breakfasthour)
                sleeptriggerDaily.hour = Int(sleephour)
            }
            
            let sleepminute = beforesleeptime.suffix(2)
            print("\(sleepminute)")
            if sleepminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                sleeptriggerDaily.minute = Int(sleepminute)
            }
            
            sleeptriggerDaily.second = 00
            content.title = "睡前吃藥通知"
            let trigger4 = UNCalendarNotificationTrigger(dateMatching: sleeptriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request4 = UNNotificationRequest(identifier: "notification4", content: content, trigger: trigger4)
            UNUserNotificationCenter.current().add(request4, withCompletionHandler: nil)
            
        }
    }
    
    func NotificTwoAfterNo(){
        print("早晚飯後")
        let content = UNMutableNotificationContent()
        content.title = "吃藥通知"
        content.body = "該吃藥囉！"
        content.badge = 1
        content.categoryIdentifier = "luckyMessage"
        
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("早餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let breakfasttime = DataSnapshot.value as! String
            print("\(breakfasttime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date1 = dateFormatter.date(from: breakfasttime)
            date1! = date1! + 1800
            
            let beforebreakfasttime = dateFormatter.string(from: date1!)
            print("\(beforebreakfasttime)")
            
            let breakfastdate = Date(timeIntervalSinceNow: 3600)
            var breakfasttriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: breakfastdate)  //每日重複
            
            let breakfasthour = beforebreakfasttime.prefix(2)
            print("\(breakfasthour)")
            if breakfasthour != nil{
                //triggerDate.hour = Int(breakfasthour)
                breakfasttriggerDaily.hour = Int(breakfasthour)
            }
            
            let breakfastminute = beforebreakfasttime.suffix(2)
            print("\(breakfastminute)")
            if breakfastminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                breakfasttriggerDaily.minute = Int(breakfastminute)
            }
            
            breakfasttriggerDaily.second = 00
            content.title = "早餐後吃藥通知"
            let trigger5 = UNCalendarNotificationTrigger(dateMatching: breakfasttriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request5 = UNNotificationRequest(identifier: "notification5", content: content, trigger: trigger5)
            UNUserNotificationCenter.current().add(request5, withCompletionHandler: nil)
            
        }
        
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("晚餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let dinnertime = DataSnapshot.value as! String
            print("\(dinnertime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date3 = dateFormatter.date(from: dinnertime)
            date3! = date3! + 1800
            
            let beforedinnertime = dateFormatter.string(from: date3!)
            print("\(beforedinnertime)")
            
            let dinnerdate = Date(timeIntervalSinceNow: 3600)
            var dinnertriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: dinnerdate)  //每日重複
            
            let dinnerhour = beforedinnertime.prefix(2)
            print("\(dinnerhour)")
            if dinnerhour != nil{
                //triggerDate.hour = Int(breakfasthour)
                dinnertriggerDaily.hour = Int(dinnerhour)
            }
            
            let dinnerminute = beforedinnertime.suffix(2)
            print("\(dinnerminute)")
            if dinnerminute != nil{
                //triggerDate.minute = Int(breakfastminute)
                dinnertriggerDaily.minute = Int(dinnerminute)
            }
            
            dinnertriggerDaily.second = 00
            content.title = "晚餐後吃藥通知"
            let trigger7 = UNCalendarNotificationTrigger(dateMatching: dinnertriggerDaily, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
            let request7 = UNNotificationRequest(identifier: "notification7", content: content, trigger: trigger7)
            UNUserNotificationCenter.current().add(request7, withCompletionHandler: nil)
            
        }
    }
    
    func NotificBeforeSleep(){
        print("睡前")
        let content = UNMutableNotificationContent()
        content.title = "吃藥通知"
        content.body = "該吃藥囉！"
        content.badge = 1
        content.categoryIdentifier = "luckyMessage"
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("睡覺時間").observeSingleEvent(of: .value) { (DataSnapshot) in
            let sleeptime = DataSnapshot.value as! String
            print("\(sleeptime)")
            
            let dateFormatter = DateFormatter()      //把時間調成30分前
            dateFormatter.dateFormat = "HH:mm"
            var date4 = dateFormatter.date(from: sleeptime)
            date4! = date4! - 1800
            
            let beforesleeptime = dateFormatter.string(from: date4!)
            print("\(beforesleeptime)")
            
            let sleepdate = Date(timeIntervalSinceNow: 3600)
            var sleeptriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: sleepdate)  //每日重複
            
            let sleephour = beforesleeptime.prefix(2)
            print("\(sleephour)")
            if sleephour != nil{
                sleeptriggerDaily.hour = Int(sleephour)
            }
            
            let sleepminute = beforesleeptime.suffix(2)
            print("\(sleepminute)")
            if sleepminute != nil{
                sleeptriggerDaily.minute = Int(sleepminute)
            }
            
            sleeptriggerDaily.second = 00
            content.title = "睡前吃藥通知"
            let trigger4 = UNCalendarNotificationTrigger(dateMatching: sleeptriggerDaily, repeats: true)
            let request4 = UNNotificationRequest(identifier: "notification4", content: content, trigger: trigger4)
            UNUserNotificationCenter.current().add(request4, withCompletionHandler: nil)
            
        }
    }
    
    @IBAction func Classifer(_ sender: Any) {
        let controller = UIAlertController(title: "藥物辨識", message: "請選擇欲辨識藥物圖片來源?\n" + "請選擇白色為底的圖片", preferredStyle: .actionSheet)
        let names = ["從相機拍攝", "從相簿選擇"]
        for name in names {
           let action = UIAlertAction(title: name, style: .default) { (action) in
              print(action.title)
              switch action.title  {
                 case "從相機拍攝":
                    print("camera")
                    self.titletext = action.title!
                    self.performSegue(withIdentifier: "gotoclassifier1", sender: self)
                    
//                    if !UIImagePickerController.isSourceTypeAvailable(.camera) {
//                        return
//                    }
//
//                    let cameraPicker = UIImagePickerController()
//                    cameraPicker.delegate = self
//                    cameraPicker.sourceType = .camera
//                    cameraPicker.allowsEditing = true
//                    self.present(cameraPicker, animated: true, completion: nil)
                 case "從相簿選擇":
                    self.titletext = action.title!
                    self.performSegue(withIdentifier: "gotoclassifier1", sender: self)
//                    print("photo")
//                    let picker = UIImagePickerController()
//                    picker.allowsEditing = false
//                    picker.delegate = self
//                    picker.sourceType = .photoLibrary
//                    self.present(picker, animated: true)
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
    
//        override func prepare(for segue:UIStoryboardSegue,sender:Any?)
//        {
//            if segue.identifier == "gotoclassifier"
//            {
//                let controller = segue.destination as! ImageClassifierViewController
//                controller.nameText = String(titletext)
//            }
//        }
    
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            dismiss(animated: true, completion: nil)
//        }
//    
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            picker.dismiss(animated: true)
//            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
//                return
//            }
//            print("aa")
//            if let controller =
//                storyboard?.instantiateViewController(withIdentifier:"Classifier"){
//                present(controller,animated: true, completion: nil)
//            }
//        }
    
}


//extension Page1ViewController : UIImagePickerControllerDelegate {
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        picker.dismiss(animated: true)
//        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
//            print("a")
//            return
//        } //1
//        print("aa ")
//        if let controller =
//            storyboard?.instantiateViewController(withIdentifier:"Classifier"){
//            present(controller,animated: true, completion: nil)
//        }
//    }
//}
   /* @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if MyMedicineTableView.indexPathForSelectedRow != nil{
            let indexPath = MyMedicineTableView.indexPathForSelectedRow!
            var cell = MyMedicineTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyMedTableViewCell
            if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell") as! MyMedTableViewCell
                
            }
            cell.MyMedName.text = mymedlist[(indexPath.row)].商品名
            print(cell.MyMedName.text)
            let MedNamebox = cell.MyMedName.text
            
            let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
            // 文字內容
            myLabel.text = MedNamebox
            
            // 或是可以使用系統預設字型 並設定文字大小
            myLabel.font = UIFont.systemFont(ofSize: 36)
            
            // 也可以簡寫成這樣
            myLabel.textAlignment = .center
            
            // 文字行數
            myLabel.numberOfLines = 1
            self.view.addSubview(myLabel)
        }*/
        //let indexPath = MyMedicineTableView.indexPathForSelectedRow!
        //var cell = MyMedicineTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyMedTableViewCell
        //cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell") as! MyMedTableViewCell
        //cell.MyMedName.text = mymedlist[(indexPath.row)].商品名
        //print(cell)
    
    
       /*
        let p = gestureRecognizer.location(in: self.MyMedicineTableView)
        let indexPath = MyMedicineTableView.indexPathForSelectedRow
        
        if let index = indexPath {
            var cell = MyMedicineTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath!) as! MyMedTableViewCell
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell") as! MyMedTableViewCell
            cell.MyMedName.text = mymedlist[(indexPath?.row)!].商品名
            print(index.row)
        } else {
            print("Could not find index path")
        }*/


//            //通知
//            let content = UNMutableNotificationContent()
//            content.title = "吃藥通知"
//            //content.subtitle = "米花兒"
//            content.body = "該吃藥囉！"
//            content.badge = 1
//            //content.sound = UNNotificationSound.default
//            content.categoryIdentifier = "luckyMessage"
//
//
//            ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("早餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
//                let breakfasttime = DataSnapshot.value as! String
//
//                let date = Date(timeIntervalSinceNow: 3600)
//                var triggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: date)  //每日重複
//
//                let breakfasthour = breakfasttime.prefix(2)
//                if breakfasthour != nil{
//                    //triggerDate.hour = Int(breakfasthour)
//                    triggerDaily.hour = Int(breakfasthour)
//                }
//
//                let breakfaststart = breakfasttime.index(breakfasttime.startIndex, offsetBy: 5)//取得早餐分
//                let breakfastend = breakfasttime.index(breakfaststart, offsetBy: 2)
//                let breakfastminute = breakfasttime[breakfaststart..<breakfastend]
//                //print("aaaaaaaaaaa\(breakfastminute)")
//                if breakfastminute != nil{
//                    //triggerDate.minute = Int(breakfastminute)!
//                    triggerDaily.minute = Int(breakfastminute)!
//                }
//
//                triggerDaily.second = 00
//                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
//
//                //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
//                let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
//                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//            }

//              //重量底下時間
//            ref.child("users").child(userID!).child("BoxStatus").child("box1").child("重量").observeSingleEvent(of: .value, with: { (snapshot) in
//                let value = snapshot.value as? NSDictionary
//                let dic:[String:Any] = value as! Dictionary
//                let sortedByKey = dic.keys.sorted(by: <)  //把時間排序
//                let lasttime = sortedByKey[sortedByKey.count - 1]    //最後讀取資料的時間的數值
//                let lasttimedata = (dic[lasttime] as! Int)  //Any轉成int
//                let lastsecondtime = sortedByKey[sortedByKey.count - 2]    //最後讀取資料的時間的數值
//                let lastsecondtimedata = (dic[lastsecondtime] as! Int)  //Any轉成int
//                if lastsecondtimedata - lasttimedata > 5{  //已經吃了沒通知
//                    print("box 1 alreadly ate")
//
//                }else{//送通知
//                    print("box 1 go to eat")
//                    self.notific()
////                    let content = UNMutableNotificationContent()
////                    content.title = "吃藥通知"
////                    content.body = "該吃藥囉！"
////                    content.badge = 1
////                    content.categoryIdentifier = "luckyMessage"
////
////
////                    ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("早餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
////                        let breakfasttime = DataSnapshot.value as! String
////
////                        let breakfastdate = Date(timeIntervalSinceNow: 3600)
////                        var breakfasttriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: breakfastdate)  //每日重複
////
////                        let breakfasthour = breakfasttime.prefix(2)
////                        if breakfasthour != nil{
////                            //triggerDate.hour = Int(breakfasthour)
////                            breakfasttriggerDaily.hour = Int(breakfasthour)
////                        }
////
////                        let breakfaststart = breakfasttime.index(breakfasttime.startIndex, offsetBy: 5)//取得早餐分
////                        let breakfastend = breakfasttime.index(breakfaststart, offsetBy: 2)
////                        let breakfastminute = breakfasttime[breakfaststart..<breakfastend]
////                        //print("aaaaaaaaaaa\(breakfastminute)")
////                        if breakfastminute != nil{
////                            //triggerDate.minute = Int(breakfastminute)!
////                            breakfasttriggerDaily.minute = Int(breakfastminute)!
////                        }
////
////                        breakfasttriggerDaily.second = 00
////                        let trigger1 = UNCalendarNotificationTrigger(dateMatching: breakfasttriggerDaily, repeats: true)
////                        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
////                        let request1 = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger1)
////                        UNUserNotificationCenter.current().add(request1, withCompletionHandler: nil)
////
////                    }
////
////                    ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("午餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
////                        let lunchtime = DataSnapshot.value as! String
////
////                        let lunchdate = Date(timeIntervalSinceNow: 3600)
////                        var lunchtriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: lunchdate)  //每日重複
////
////                        let lunchhour = lunchtime.prefix(2)
////                        if lunchhour != nil{
////                            //triggerDate.hour = Int(breakfasthour)
////                            lunchtriggerDaily.hour = Int(lunchhour)
////                        }
////
////                        let lunchstart = lunchtime.index(lunchtime.startIndex, offsetBy: 5)//取得早餐分
////                        let lunchend = lunchtime.index(lunchstart, offsetBy: 2)
////                        let lunchminute = lunchtime[lunchstart..<lunchend]
////                        //print("aaaaaaaaaaa\(breakfastminute)")
////                        if lunchminute != nil{
////                            //triggerDate.minute = Int(breakfastminute)!
////                            lunchtriggerDaily.minute = Int(lunchminute)!
////                        }
////
////                        lunchtriggerDaily.second = 00
////                        let trigger2 = UNCalendarNotificationTrigger(dateMatching: lunchtriggerDaily, repeats: true)
////                        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
////                        let request2 = UNNotificationRequest(identifier: "notification2", content: content, trigger: trigger2)
////                        UNUserNotificationCenter.current().add(request2, withCompletionHandler: nil)
////
////                    }
////
////                    ref.child("users").child(Auth.auth().currentUser!.uid).child("personal_details").child("晚餐時間").observeSingleEvent(of: .value) { (DataSnapshot) in
////                        let dinnertime = DataSnapshot.value as! String
////
////                        let dinnerdate = Date(timeIntervalSinceNow: 3600)
////                        var dinnertriggerDaily = Calendar.current.dateComponents([.hour,. minute,. second], from: dinnerdate)  //每日重複
////
////                        let dinnerhour = dinnertime.prefix(2)
////                        if dinnerhour != nil{
////                            //triggerDate.hour = Int(breakfasthour)
////                            dinnertriggerDaily.hour = Int(dinnerhour)
////                        }
////
////                        let dinnerstart = dinnertime.index(dinnertime.startIndex, offsetBy: 5)//取得早餐分
////                        let dinnerend = dinnertime.index(dinnerstart, offsetBy: 2)
////                        let dinnerminute = dinnertime[dinnerstart..<dinnerend]
////                        //print("aaaaaaaaaaa\(breakfastminute)")
////                        if dinnerminute != nil{
////                            //triggerDate.minute = Int(breakfastminute)!
////                            dinnertriggerDaily.minute = Int(dinnerminute)!
////                        }
////
////                        dinnertriggerDaily.second = 00
////                        let trigger3 = UNCalendarNotificationTrigger(dateMatching: dinnertriggerDaily, repeats: true)
////                        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)   //幾秒後觸發
////                        let request3 = UNNotificationRequest(identifier: "notification3", content: content, trigger: trigger3)
////                        UNUserNotificationCenter.current().add(request3, withCompletionHandler: nil)
////
////                    }
//
//                }
//
//            })

//        //時間底下重量
//        let ref = Database.database().reference()
//        //var boxid : String? = nil
//        let userID = Auth.auth().currentUser?.uid
//        ref.child("users").child(userID!).child("boxes").observeSingleEvent(of: .value) { (DataSnapshot) in  //比較是否已經吃藥
//            let boxid = DataSnapshot.value as! String  //取得boxid
//            print("boxid:\(boxid)")
//            ref.child("boxes").child(boxid).child("第一格").observeSingleEvent(of: .value) { (DataSnapshot) in
//                let value = DataSnapshot.value as? NSDictionary
//                print("\(String(describing: value))")
//                let dic:[String:Any] = value as! Dictionary
//                print("\(dic)")
//                let sortedByKey = dic.keys.sorted(by: <)  //把時間排序
////                print("\(sortedByKey)")
////                print("\(sortedByKey[sortedByKey.count - 1])")  //最後讀取資料的時間
//                let lasttime = sortedByKey[sortedByKey.count - 1]  //倒數第二個讀取資料的時間
//                let lastsecondtime = sortedByKey[sortedByKey.count - 2]
//                ref.child("boxes").child(boxid).child("第一格").child(lasttime).child("weight").observeSingleEvent(of: .value) { (DataSnapshot) in
//                    let lasttimeweight = DataSnapshot.value as! Double
//                    print("lasttime weight:\(lasttimeweight)")  //最後一筆資料的重量
//                    ref.child("boxes").child(boxid).child("第一格").child(lastsecondtime).child("weight").observeSingleEvent(of: .value) { (DataSnapshot) in
//                        let lastsecondtimeweight = DataSnapshot.value as! Double
//                        print("lastsecondtime weight:\(lastsecondtimeweight)")  //倒數第二筆資料的重量
//                        if lastsecondtimeweight - lasttimeweight > 5{
//                            print("alreadly ate")
//                        }else{
//                            print("go to eat")
//                        }
//
//                    }
//                }
//            }
//        }

//        //重量底下時間
//        let userID = Auth.auth().currentUser?.uid
//        ref.child("users").child(userID!).child("BoxStatus").child("box1").child("重量").observeSingleEvent(of: .value, with: { (snapshot) in  //資料庫資料格式錯誤的讀取
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            print("\(String(describing: value))")
//            let dic:[String:Any] = value as! Dictionary
//            print("\(dic)")
//            let sortedByKey = dic.keys.sorted(by: <)  //把時間排序
//            print("\(sortedByKey)")
//            print("\(sortedByKey[sortedByKey.count - 1])")  //最後讀取資料的時間
//            let lasttime = sortedByKey[sortedByKey.count - 1]    //最後讀取資料的時間的數值
//            //print("\(dic[lasttime])")
//            let lasttimedata = (dic[lasttime] as! Int)  //Any轉成int
//            print(lasttimedata)
//
//            let lastsecondtime = sortedByKey[sortedByKey.count - 2]    //最後讀取資料的時間的數值
//            //print("\(dic[lastsecondtime])")
//            let lastsecondtimedata = (dic[lastsecondtime] as! Int)  //Any轉成int
//            print(lastsecondtimedata)
//
//            if lastsecondtimedata - lasttimedata > 5{
//                print("alreadly ate")
//            }else{
//                print("go to eat")
//            }
//
//        }) { (error) in
//            print(error.localizedDescription)
//        }
