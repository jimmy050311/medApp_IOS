//
//  Page2ViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/5/20.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Page2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating,UISearchBarDelegate{

    var searchController: UISearchController!
    @IBOutlet weak var MedicineTableView: UITableView!
    var ref: DatabaseReference!
    var medlist = [Med]()
    var refHandle: UInt!
    
    var isSwitch = false
    var searchResults: [String] = [String] () // 搜尋結果集合
    var searchIndicationsResults:[String] = [String] ()//搜尋適應症結果
    var searchmedicinename: [String] = [] // 被搜尋的藥品名
    var searchmedicineIndications: [String] = [] // 被搜尋的適應症結果
    var searchIndicationsName: [String] = [String] ()
    var isShowSearchResult: Bool = false // 是否顯示搜尋的結果
    
    
    
    
    override func viewDidLoad() {
        print("page2")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    
        MedicineTableView.delegate = self
        MedicineTableView.dataSource = self
        ref = Database.database().reference()
//        SwitchBtn.setTitle("藥物名稱", for: .normal)
        name()
        MedicineTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0);   //讓底部兩格顯示出來
        appear()
        
        searchController = UISearchController(searchResultsController:nil)
//      MedicineTableView.tableHeaderView = searchController.searchBar
        let searchBarFrame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 44)
        let searchBarContainer = UIView(frame: searchBarFrame)
        searchBarContainer.addSubview(searchController.searchBar)
        self.view.addSubview(searchBarContainer)//固定搜尋列
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
//        searchController.searchBar.setImage(UIImage(named: "Sort"), for: .bookmark, state: .normal)
        self.searchController.dimsBackgroundDuringPresentation = true  // 預設為true，若是沒改為false，則在搜尋時整個TableView的背景顏色會變成灰底的
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "搜索藥物名稱"
        
      
                          
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {   //每次切換到這頁會執行
        super.viewWillAppear(animated)
     
        print("page2")
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func name(){//過濾搜尋的藥名
      
        if searchmedicinename.count != 0{
            for i in 0...(searchmedicinename.count-1)
            {searchmedicinename.remove(at: 0)}}
        for i in 0...70{
        ref.child("Medicine").child(String(i)).child("中文品名").observeSingleEvent(of: .value) { (DataSnapshot) in
            let name = DataSnapshot.value as! String
            self.searchmedicinename.append(name)
        }}
               
        if searchmedicineIndications.count != 0{
                for i in 0...(searchmedicineIndications.count-1)
                {searchmedicineIndications.remove(at: 0)}}
            for i in 0...70{
            ref.child("Medicine").child(String(i)).child("適應症").observeSingleEvent(of: .value) { (DataSnapshot) in
                let Indications = DataSnapshot.value as! String
                self.searchmedicineIndications.append(Indications)
                
                
            }}
        
    }
    
    func appear(){//讀取firebase
        if medlist.count != 0{
            for i in 0...(medlist.count-1)
            {medlist.remove(at: 0)}}
        refHandle = ref.child("Medicine").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject]{
                //print("dictionary is \(dictionary)")
                let medDetail = Med()
                medDetail.setValuesForKeys(dictionary)
                self.medlist.append(medDetail)
                DispatchQueue.main.async {
                    self.MedicineTableView.reloadData()
                }
            }
        })
    }
    


    func filterDataSource() {
        // 使用高階函數來過濾掉陣列裡的資料
        
      
        
        self.searchResults = searchmedicinename.filter({ (medicinesearched) -> Bool in
            return medicinesearched.lowercased().range(of: self.searchController.searchBar.text!.lowercased()) != nil
        })
        
        if self.searchResults.count > 0 {
            self.isShowSearchResult = true
            self.MedicineTableView.separatorStyle = UITableViewCell.SeparatorStyle.init(rawValue: 1)! // 顯示TableView的格線
        } else {
            self.MedicineTableView.separatorStyle = UITableViewCell.SeparatorStyle.none // 移除TableView的格線
            // 可加入一個查找不到的資料的label來告知使用者查不到資料...
            // ...
        }
        
        self.searchIndicationsResults = searchmedicineIndications.filter({ (medicinesearched) -> Bool in
            return medicinesearched.lowercased().range(of: self.searchController.searchBar.text!.lowercased()) != nil
        })
        
        if self.searchIndicationsResults.count > 0 {
            self.isShowSearchResult = true
            self.MedicineTableView.separatorStyle = UITableViewCell.SeparatorStyle.init(rawValue: 1)! // 顯示TableView的格線
            
        } else {
            self.MedicineTableView.separatorStyle = UITableViewCell.SeparatorStyle.none // 移除TableView的格線
            // 可加入一個查找不到的資料的label來告知使用者查不到資料...
            // ...
        }
        
        
        self.MedicineTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // 若是沒有輸入任何文字或輸入空白則直接返回不做搜尋的動作
        if searchController.isActive {
            searchController.searchBar.showsBookmarkButton = false
        } else {
            searchController.searchBar.showsBookmarkButton = true
        }
        
        
        if self.searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            return
        }
        self.filterDataSource()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {    // 若是有查詢結果則顯示查詢結果集合裡的資料
    if self.isShowSearchResult {
        if self.isSwitch == false{
            return self.searchResults.count}
        else {
            return self.searchIndicationsResults.count}
        }
        
    else {
            return medlist.count
        }
        //return medlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MedicineTableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell") as! MedicineTableViewCell
        }
        if self.isShowSearchResult {
            // 若是有查詢結果則顯示查詢結果集合裡的資料
            //cell.textLabel?.text = String(result[indexPath.row])
            if self.isSwitch == false{
                cell.nameMed.text = String(searchResults[indexPath.row])}
            else{
                for i in 0...70
                {
                    if medlist[i].適應症 == searchIndicationsResults[indexPath.row]
                    {
                        cell.nameMed.text = medlist[i].中文品名
                      
                        
                    }
                }
            }
         } else {
            cell.textLabel?.text = nil
            cell.nameMed.text = medlist[indexPath.row].中文品名
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showdetail", sender: nil)
       
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 依個人需求決定如何實作
        isShowSearchResult = false
        appear()
        
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        //showAlert, presentVC or whatever you want here
        let controller = UIAlertController(title: "請選擇查詢方式", message: "", preferredStyle: .actionSheet)
        let names = ["藥物名稱", "適應症"]
        for name in names {
           let action = UIAlertAction(title: name, style: .default) { (action) in
            if (action.title) == "藥物名稱"
            {
             self.isSwitch = false
             self.searchController.searchBar.placeholder = "搜索藥物名稱"
            }
            else
            {
             self.isSwitch = true
             self.searchController.searchBar.placeholder = "搜索適應症"
            }
            
           }
            controller.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
        
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 法蘭克選擇不需要執行查詢的動作，因在「輸入文字時」即會觸發 updateSearchResults 的 delegate 做查詢的動作(可依個人需求決定如何實作)
        // 關閉瑩幕小鍵盤
        self.searchController.searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showdetail"{
            if let dvc = segue.destination as? DetailViewController{
                let selectedIndexPath = MedicineTableView.indexPathForSelectedRow
                if self.isShowSearchResult {
                    searchController.isActive = false  //換頁隱藏搜尋欄
                    if let selectedRow = selectedIndexPath?.row{
                        if isSwitch == false{
                        dvc.infoFromViewOne1 = searchResults[selectedRow]
                        if var selectedRow2 = selectedIndexPath?.row{
                            for i in 0...70
                            {
                                selectedRow2 = i
                                if medlist[i].中文品名 == searchResults[selectedRow]{
                                    dvc.infoFromViewOne2 = medlist[i].英文品名
                                    dvc.infoFromViewOne3 = medlist[i].許可證字號
                                    dvc.infoFromViewOne4 = medlist[i].仿單圖檔連結
                                    dvc.infoFromViewOne5 = medlist[i].外盒圖檔連結
                                    dvc.infoFromViewOne6 = "\(i)"
                                    
                                }
                            }
                        }}
                        else
                        {

                            if var selectedRow2 = selectedIndexPath?.row{
                                for i in 0...70
                                {
                                    selectedRow2 = i
                                    if medlist[i].適應症 == searchIndicationsResults[selectedRow]{
                                        dvc.infoFromViewOne1 = medlist[i].中文品名
                                        dvc.infoFromViewOne2 = medlist[i].英文品名
                                        dvc.infoFromViewOne3 = medlist[i].許可證字號
                                        dvc.infoFromViewOne4 = medlist[i].仿單圖檔連結
                                        dvc.infoFromViewOne5 = medlist[i].外盒圖檔連結
                                        dvc.infoFromViewOne6 = "\(i)"
                                    }
                                }
                            }
                        }
                    }
                }else {
                   searchController.isActive = false
                    if let selectedRow = selectedIndexPath?.row{
                        dvc.infoFromViewOne1 = medlist[selectedRow].中文品名
                        dvc.infoFromViewOne2 = medlist[selectedRow].英文品名
                        dvc.infoFromViewOne3 = medlist[selectedRow].許可證字號
                        dvc.infoFromViewOne4 = medlist[selectedRow].仿單圖檔連結
                        dvc.infoFromViewOne5 = medlist[selectedRow].外盒圖檔連結
                        dvc.infoFromViewOne6 = "\(selectedRow)"
                    }
                }
             }
        }
    }
}
    /*品硯der
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addAction =
            UITableViewRowAction(style: .normal, title: "加入我的藥物", handler: {(action,indexPath)-> Void in
                
        })
        return[addAction]
    }*/
   
        
    
    /*
        let userID = Auth.auth().currentUser?.uid
        ref.child("med_Search").observe(.childAdded, with: { (snapshot) in
            // Get user value
            let results = snapshot.value as? [String : AnyObject]
            let aaa = results?["適應症"]
            //let user = User(username: username)
            print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
            print(aaa)
        }) { (error) in
            print(error.localizedDescription)
        }
    }*/
    
/*func appear(){
 refHandle = ref.child("med_Search").observe(.childAdded, with: { (snapshot) in
 
 if let dictionary = snapshot.value as? [String : AnyObject]{
 print("dictionary is \(dictionary)")
 let aaa = dictionary["適應症"]
 let medDetail = Med()
 
 medDetail.setValuesForKeys(aaa)
 self.medlist.append(medDetail)
 
 DispatchQueue.main.async {
 self.MedicineTableView.reloadData()
 }
 
 }
 
 })
 }*/
    
    

