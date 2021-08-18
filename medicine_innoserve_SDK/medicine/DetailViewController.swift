//
//  DetailViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/6/30.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GameKit
import SafariServices
import FirebaseStorage
import FirebaseUI

class DetailViewController: UIViewController,SFSafariViewControllerDelegate, UIScrollViewDelegate {

    var infoFromViewOne1:String?
    var infoFromViewOne2:String?
    var infoFromViewOne3:String?
    var infoFromViewOne4:String?
    var infoFromViewOne5:String?
    var infoFromViewOne6:String?
    
    var scrollView:UIScrollView?
    var lastImageView:UIImageView?
    var originalFrame:CGRect!
    var isDoubleTap:ObjCBool!
    
    var fireUploadDic: [String:Any]?
    
    @IBOutlet weak var MedicineName: UILabel!
    @IBOutlet weak var ScientificName: UILabel!
    @IBOutlet weak var Sideeffect: UILabel!
    @IBOutlet weak var Adaptation: UILabel!
    @IBOutlet weak var MedicineNumber: UILabel!
    @IBOutlet weak var mymedButton: UIButton!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var DeImage: UIImageView!
    
    
    var website:String = "https://www.google.com/search?&q="
    var searchword:String = ""
    var searchweb:String = ""
    var newurl:String = ""
    var dohavemymed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let num = infoFromViewOne6
        getPic(index: num!)
        MedicineName.text = infoFromViewOne1
        ScientificName.text = infoFromViewOne2
        Sideeffect.text = infoFromViewOne3
        Adaptation.text = infoFromViewOne4
        MedicineNumber.text = infoFromViewOne5
        
        
        var reference: StorageReference!
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child("藥物仿單")
        let fileName = "\"\"\"芭法\"\" 痘化膠５％（過氧化苯醯）\".jpg"
        let spaceRef = imagesRef.child(fileName)
        let path = spaceRef.fullPath;
        let name = spaceRef.name;
        let images = spaceRef.parent()
        var ref = Database.database().reference()
        print(path)
        print(name)
        print(images)
        
        mymedButton.backgroundColor = #colorLiteral(red: 1, green: 0.6925184462, blue: 0.5362955729, alpha: 1)
        mymedButton.layer.cornerRadius = 5
        mymedButton.layer.borderWidth = 2
        mymedButton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
        
        SearchButton.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.8784313725, blue: 1, alpha: 1)
        SearchButton.layer.cornerRadius = 5
        SearchButton.layer.borderWidth = 1
        SearchButton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
        
        
        ref = Database.database().reference()
        var array1 = [String]()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("MyMedicine").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : String]{
                //print("\(dictionary["中文品名"])")
                //array1.append("\(dictionary["中文品名"])")
                if self.MedicineName.text == dictionary["中文品名"]{
                    self.dohavemymed = true
                }
            }
            
            
            print("\(self.dohavemymed)")
            if self.dohavemymed == true{
                self.mymedButton.setTitle("移出我的最愛", for:.normal)
            }else {
                self.mymedButton.setTitle("加入我的最愛", for:.normal)
            }
            
        })
        DeImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showZoomImageView(tap:)))
        self.DeImage.addGestureRecognizer(tap)

    }
    
    var ref = Database.database().reference()

    @IBAction func AddMyMed(_ sender: Any) {
        
        if dohavemymed == true{      //代表按鈕是刪除我的最愛
            self.ref.child("users").child(Auth.auth().currentUser!.uid).child("MyMedicine").child(String(describing: self.Sideeffect.text)).setValue(nil)
            dohavemymed = false
            self.mymedButton.setTitle("加入我的最愛", for:.normal)
        }else{     //代表按鈕是加入我的最愛
            self.ref.child("users/\(Auth.auth().currentUser!.uid)/MyMedicine/\(String(describing: self.Sideeffect.text))").child("中文品名").setValue(self.MedicineName.text)
            self.ref.child("users/\(Auth.auth().currentUser!.uid)/MyMedicine/\(String(describing: self.Sideeffect.text))").child("英文品名").setValue(self.ScientificName.text)
            self.ref.child("users/\(Auth.auth().currentUser!.uid)/MyMedicine/\(String(describing: self.Sideeffect.text))").child("許可證字號").setValue(self.Sideeffect.text)
            self.ref.child("users/\(Auth.auth().currentUser!.uid)/MyMedicine/\(String(describing: self.Sideeffect.text))").child("外盒圖檔連結").setValue(self.Adaptation.text)
            self.ref.child("users/\(Auth.auth().currentUser!.uid)/MyMedicine/\(String(describing: self.Sideeffect.text))").child("仿單圖檔連結").setValue(self.MedicineNumber.text)
            
            
            dohavemymed = true
            self.mymedButton.setTitle("移出我的最愛", for:.normal)
        }
        
    
    
//        let optionMenu = UIAlertController(title: nil, message: "請選擇", preferredStyle: .actionSheet)
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//        optionMenu.addAction(cancelAction)
//
//        present(optionMenu,animated: true,completion: nil)
//
//
//        let checkInAction = UIAlertAction(title: "加入我的最愛", style: .default, handler:
//        {
//            (action:UIAlertAction!) -> Void in
//
//
//            self.ref.child("users/\(Auth.auth().currentUser!.uid)/mymed/\(String(describing: self.MedicineNumber.text))").child("商品名").setValue(self.MedicineName.text)
//            self.ref.child("users/\(Auth.auth().currentUser!.uid)/mymed/\(String(describing: self.MedicineNumber.text))").child("學名").setValue(self.ScientificName.text)
//            self.ref.child("users/\(Auth.auth().currentUser!.uid)/mymed/\(String(describing: self.MedicineNumber.text))").child("副作用").setValue(self.Sideeffect.text)
//            self.ref.child("users/\(Auth.auth().currentUser!.uid)/mymed/\(String(describing: self.MedicineNumber.text))").child("適應症").setValue(self.Adaptation.text)
//            self.ref.child("users/\(Auth.auth().currentUser!.uid)/mymed/\(String(describing: self.MedicineNumber.text))").child("商品代號").setValue(self.MedicineNumber.text)
//
//            self.ref.child("users/\(Auth.auth().currentUser!.uid)/mymedname/\(String(describing: self.MedicineName.text))")
//
//
//
//
//            let controller = UIAlertController(title: nil, message: "已加入我的最愛", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            controller.addAction(okAction)
//            self.present(controller, animated: true, completion: nil)
//
//
//
//        })
//            optionMenu.addAction(checkInAction)
//
//        let checkOutAction = UIAlertAction(title: "移出我的最愛", style: .default, handler:
//        {
//            (action:UIAlertAction!) -> Void in
//            //self.ref.child("users/\(Auth.auth().currentUser!.uid)/mymed/\(key!)").setValue(nil)
//            self.ref.child("users").child(Auth.auth().currentUser!.uid).child("mymed").child(String(describing: self.MedicineNumber.text)).setValue(nil)
//
//            let controller = UIAlertController(title: nil, message: "已移出我的最愛", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            controller.addAction(okAction)
//            self.present(controller, animated: true, completion: nil)
//        })
//
//
//        optionMenu.addAction(checkOutAction)
        
}
    
    func getPic(index : String){
        ref = Database.database().reference()
        
        ref.child("Medicine").child(index).observe(.value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let pic = value!["中文品名"] as? String
            print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
            print(pic!)
            let picstorage = "gs://medicine-5a4f8.appspot.com/"+pic!+"0"
            print(picstorage)
            self.downloadPictue(path: picstorage)
        })
        
    }
    
    func downloadPictue(path : String){
        let storage = Storage.storage() //連結storage
        let gsReference = storage.reference(forURL: path) //你storage上的參考位置 com/後面就是你想找的圖片位置/
            gsReference.getData(maxSize: 2 * 1024 * 1024) { (data, error) -> Void in //withmaxSize很重要 他會取圖的最大範圍 如果過小就會取不到圖片 但是太大就會減慢速度 大小要自己爭酌
        if (error != nil) {
    ////    //錯誤發生執行
        print("========="+error.debugDescription)//印出錯誤原因
        } else {
        let islandImage: UIImage! = UIImage(data: data!) //成功取得照片
        self.DeImage.image = islandImage //設定照片到你的imageView上
        }
        }
        }
 
//    func downloadPictue(){
//    let storage = Storage.storage() //連結storage
//    let gsReference = storage.reference(forURL: "https://storage.googleapis.com/medicine-5a4f8.appspot.com/%22%E7%94%9F%E9%81%94%22%20%E8%88%92%E7%88%BE%E5%BF%83%E8%86%9C%E8%A1%A3%E9%8C%A0%EF%BC%94%EF%BC%90%EF%BC%90%E5%85%AC%E7%B5%B2%EF%BC%88%E8%89%BE%E6%80%9D%E5%B8%83%E5%A6%A5%EF%BC%890") //你storage上的參考位置 com/後面就是你想找的圖片位置
//    gsReference.getData(maxSize: 2 * 1024 * 1024) { (data, error) -> Void in //withmaxSize很重要 他會取圖的最大範圍 如果過小就會取不到圖片 但是太大就會減慢速度 大小要自己爭酌
//    if (error != nil) {
//    //錯誤發生執行
//    print("========="+error.debugDescription)//印出錯誤原因
//    } else {
//    let islandImage: UIImage! = UIImage(data: data!) //成功取得照片
//    self.DeImage.image = islandImage //設定照片到你的imageView上
//    }
//    }
//    }

//    func loadimage(){
//           ref.child("users").child(Auth.auth().currentUser!.uid).child("Medicine").child("0").child("仿單PNG0").observeSingleEvent(of: .value) { (DataSnapshot) in
//           let picture = DataSnapshot.value as! String
//           let url = URL(string:picture )!
//       let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//          if let data = data, let image = UIImage(data: data) {
//             DispatchQueue.main.async {
//                self.DeImage.image = image
//             }
//          }
//       }
//       task.resume()
//
//           }}
    
    
    
    
    
    @objc func showZoomImageView( tap : UITapGestureRecognizer) {
        let bgView = UIScrollView.init(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.black
        let tapBg = UITapGestureRecognizer.init(target: self, action: #selector(tapBgView(tapBgRecognizer:)))
        bgView.addGestureRecognizer(tapBg)
        let picView = tap.view as! UIImageView//view 强制转换uiimageView
        let imageView = UIImageView.init()
        imageView.image = picView.image;
        imageView.frame = bgView.convert(picView.frame, from: self.view)
        bgView.addSubview(imageView)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        self.lastImageView = imageView
        self.originalFrame = imageView.frame
        self.scrollView = bgView
        self.scrollView?.maximumZoomScale = 1.5
        self.scrollView?.delegate = self
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: UIView.AnimationOptions.beginFromCurrentState,
            animations: {
                var frame = imageView.frame
                frame.size.width = bgView.frame.size.width
                frame.size.height = frame.size.width * ((imageView.image?.size.height)! / (imageView.image?.size.width)!)
                frame.origin.x = 0
                frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5
                imageView.frame = frame
            }, completion: nil
        )
    }
    
    @objc func tapBgView(tapBgRecognizer:UITapGestureRecognizer)
    {
        self.scrollView?.contentOffset = CGPoint.zero
        UIView.animate(withDuration: 0.5, animations: {
            self.lastImageView?.frame = self.originalFrame
            tapBgRecognizer.view?.backgroundColor = UIColor.clear
        }) { (finished:Bool) in
            tapBgRecognizer.view?.removeFromSuperview()
            self.scrollView = nil
            self.lastImageView = nil
        }
    }
    
    //正确代理回调方法
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.lastImageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SearchPicture(_ sender: Any) {
        searchword = MedicineName.text!
        searchweb = website + searchword
        newurl = searchweb.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!  //解決url裡有中文字
        if let url = URL(string: newurl){
            let safari = SFSafariViewController(url: url)
            safari.delegate = self
            present(safari, animated: true, completion: nil)
    }
}
   
    /*
 let optionMenu = UIAlertController(title: nil, message: "請選擇", preferredStyle: .actionSheet)
 let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
 optionMenu.addAction(cancelAction)
 present(optionMenu,animated: true,completion: nil)
 
 let checkInAction = UIAlertAction(title: "加入我的最愛", style: .default, handler:
 {
 (action:UIAlertAction!) -> Void in
 
 
 })
 optionMenu.addAction(checkInAction)*/
    
    

}
