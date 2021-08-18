//
//  Page4ViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/5/20.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import MHBSdk
import CryptoSwift

import Alamofire
import SSZipArchive
import ZIPFoundation
import Zip
import Minizip

class Page4ViewController: UIViewController {

    
    @IBOutlet weak var HanButton: UIButton!
    @IBOutlet weak var PerButton: UIButton!
    @IBOutlet weak var ChangeButton: UIButton!
    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var SDKButton: UIButton!
    
    var arrR: [Int] = []
    var finalData : Any = ""
    var timeStamp : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MHB.configure(APIKey: "17cf1ae1218e4bc79bce2c69b6a8bde0")
        // Do any additional setup after loading the view.
//        HanButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        HanButton.layer.cornerRadius = 25
//        HanButton.layer.borderWidth = 1
//        HanButton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
//        
//        PerButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        PerButton.layer.cornerRadius = 25
//        PerButton.layer.borderWidth = 1
//        PerButton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
//        
//        ChangeButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        ChangeButton.layer.cornerRadius = 25
//        ChangeButton.layer.borderWidth = 1
//        ChangeButton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
//        
//        LogoutButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        LogoutButton.layer.cornerRadius = 25
//        LogoutButton.layer.borderWidth = 1
//        LogoutButton.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.7568627451, blue: 0.8392156863, alpha: 1)
        
        SDKButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        SDKButton.layer.cornerRadius = 25
        SDKButton.layer.borderWidth = 2
        SDKButton.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func check(item : String){
        for i in arrR[0]...arrR[1]{
            if(item == "File_Ticket_\(i)"){
                timeStamp = "File_Ticket_\(i)"
                print("timeStamp:"+timeStamp)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {   //每次切換到這頁會執行
        super.viewWillAppear(animated)
     
        print("page4")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logout(_ sender: Any) {
        
    do
    {
        try Auth.auth().signOut()
        print("success logout")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let initialViewController = (self.storyboard?.instantiateViewController(withIdentifier: "Login"))! as UIViewController
        appDelegate.window!.rootViewController = initialViewController
        appDelegate.window!.makeKeyAndVisible()
        
    }
        catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
    }
    }
    
    @IBAction func HealthSDK(_ sender: Any) {
        //連入SDK
        let date = NSDate(timeIntervalSinceNow: 0)
        //let dateStr = dfmatter.String(from: date)
        let timeStampStr:CLong = CLong(date.timeIntervalSince1970)
        self.arrR.append(timeStampStr)
        MHB.start(self)
    }
    
    internal func writeFile(_ filePath: URL,data: Data)->Bool{
        let strFilePath = filePath.path
        print("strFilePath : \(strFilePath)")
        if !FileManager.default.fileExists(atPath: strFilePath){
            FileManager.default.createFile(atPath: strFilePath, contents: nil, attributes: nil)
            print("建立成功")
        }else{
            
            do{
                try FileManager.default.removeItem(atPath: strFilePath)
                print("刪除")
            }catch{
                print("Removeerror\(error)")
            }
            FileManager.default.createFile(atPath: strFilePath, contents: nil, attributes: nil)
            
            print("建立")
        }
        if let fh = FileHandle(forWritingAtPath: filePath.path){
            fh.seekToEndOfFile()
            fh.write(data)
            fh.closeFile()
            
            return true
        }else{
            return false
        }
    }
}

extension Page4ViewController : MHBDelegate,SSZipArchiveDelegate{
    
    func didStartProcSuccess() {
        print("didStartProcSuccess")
    }
    
    func didStartProcFailure(error: String) {
        print("didStartProcFailure")
    }
    
    func didFetchDataSuccess(file: Data, serverKey: String) {
        print("didFetchDataSuccess")
        print("File : \(file)")
        let AESKey = decryptionAES256(salt: serverKey, password: "17cf1ae1218e4bc79bce2c69b6a8bde0")!
        let path = NSTemporaryDirectory()
        let sourceURL = URL(fileURLWithPath: path)
        
        let fileData = sourceURL.appendingPathComponent("sdk").appendingPathExtension("zip")
        let fileDic = sourceURL.appendingPathComponent("sdk2")
        
        //FileManager.default.createFile(atPath: fileDic.path, contents: nil, attributes: nil)
        
        var destinationURL = URL(fileURLWithPath: path)
        
        let x = writeFile(fileData, data: file)
        
        print("x:\(x)")
        let manager = FileManager.default
        var fileSize : Double = 0
        do{
            fileSize = try manager.attributesOfItem(atPath: fileData.path)[FileAttributeKey(rawValue: "NSFileSize")] as! Double
        }catch{
        
        }
        print("fileSize\(fileSize)")
        
        destinationURL = destinationURL.appendingPathComponent("sdkunzip")
        
        if FileManager.default.fileExists(atPath: destinationURL.path){
            do{
                try FileManager.default.removeItem(at: destinationURL)
                try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
                print(try FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory()))
            }catch{
                print("目錄建立失敗")
            }
        }else{
            do{
                try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
                print(try FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory()))
            }catch{
                print("目錄建立失敗")
            }
        }
        
        
//        let zip = CkoZip()!
//        let success: Bool = zip.open(fileData.path)
//        if success != true {
//            print("\(zip.lastErrorText!)")
//            return
//        }
//        zip.decryptPassword = AESKey
//
//        var unzipCount: Int
//
//        unzipCount = zip.unzip(destinationURL.path).intValue
//
//        if unzipCount < 0 {
//            print("\(zip.lastErrorText!)")
//        }
//        else {
//            print("Success!")
//        }
        
        do{
            try SSZipArchive.unzipFile(atPath: fileData.path, toDestination: destinationURL.path, overwrite: false, password: AESKey)
            print(try FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory()+"sdkunzip"))
        }catch{
        }
        var fileSize2 : Double = 0
        let jsonPath = NSTemporaryDirectory()+"sdkunzip/2020121114979021.json"
        let jsonPathUrl = URL(fileURLWithPath: jsonPath)
        do{
            fileSize2 = try manager.attributesOfItem(atPath: jsonPath)[FileAttributeKey(rawValue: "NSFileSize")] as! Double
            
        }catch{
            print("Nofile")
        }
        print("fileSize\(fileSize2)")
        
        //Save json file to file
        do{
            let jsonData = try Data(contentsOf: jsonPathUrl)
            print(jsonData)
            let str = String(decoding: jsonData, as: UTF8.self)
            print(str)
            //write json in local file
//            let localpath = Bundle.main.path(forResource: "Healthdata", ofType: "json")
//            let localpathUrl = URL(fileURLWithPath: localpath!)
//            try str.write(to: localpathUrl,
//                                     atomically: true,
//                                     encoding: .utf8)
        }catch{
            print("ERROR : \(error)")
        }
        print("------------------------------------------------")
        print("__________________________________________________")
        
        
    }
    
    func didFetchDataFailure(error: String) {
        print("didFetchDataFailure"+error)
    }
    
    func didMHBExit() {
        print("didMHBExit")
        let date = NSDate(timeIntervalSinceNow: 0)
        let timeStampStr:CLong = CLong(date.timeIntervalSince1970)
        arrR.append(timeStampStr)
        
        let arr = UserDefaults.standard.dictionaryRepresentation()
        print("__________________________________________________")
        for item in arrR {
                print(item)
        }
        print("__________________________________________________")
        
                print("arrR\(arrR)")
        
        print("__________________________________________________")
        
        for item in arr {
            if item.key.contains("File_Ticket_") {
            //可依已紀錄的起始/結束時間戳記區間內查詢前次 SDK 存入的檔案識別碼
                print(item)
                check(item: item.key)
            }
        }
        MHB.fetchData(self, fileTicket: timeStamp)
    }

    func decryptionAES256(salt : String, password : String) -> String!{
        var result : String!
        do{
            let saltData:Array<UInt8> = Array(salt.utf8)
            let pwData:Array<UInt8> = Array(password.utf8)
            
            let derivedKey:Array<UInt8> = try PKCS5.PBKDF2.init(password: pwData, salt: saltData, iterations: 1000, keyLength: 32,variant: .sha1).calculate()
            let key :Array<UInt8> = Array(derivedKey[0...31])
            result = Data(bytes: key, count: 32).base64EncodedString()
            
        }catch{
            print(error)
        }
        return result
    }
}



struct sdkFileShelf :Decodable {
    var updateAt : TimeInterval
    var list : [sdkFile]
}



struct sdkFile : Decodable {
    var hospital : String?
    var sick : String?
    var medicine : String?
}
