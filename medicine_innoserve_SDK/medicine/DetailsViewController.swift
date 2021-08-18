//
//  DetailsViewController.swift
//  medicine
//
//  Created by amkdajmal on 2020/10/31.
//  Copyright © 2020 amkdajmal. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseDatabase
import FirebaseStorage

class DetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    

    @IBOutlet weak var Detailstable: UITableView!
    @IBOutlet weak var sControl: UISegmentedControl!
    

    var refHandle: UInt!
    var medList = [MedHistory]()
    var boxvalue = ""
    var ref:DatabaseReference!
    
    var refreshControl:UIRefreshControl!   //下拉更新
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if medList == []{
            return 1
        }else{
            return medList.count
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Detailscell", for: indexPath) as! MedTextCell
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Detailscell") as! MedTextCell
//        }
        if medList == []{
            cell.title.text = "無資料"
            cell.desc1.text = ""
            cell.desc2.text = ""
            cell.desc3.text = ""
            
            return cell
        }else{
            cell.title.text = medList[indexPath.row].Date
            if medList[indexPath.row].Take == "是"{
                cell.desc1.text = "已服藥"
            }else if medList[indexPath.row].Take == "否"{
                cell.desc1.text = "未服藥"
            }
            cell.desc2.text = medList[indexPath.row].Time
            cell.desc3.text = medList[indexPath.row].Name
            return cell
        }
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Detailstable.delegate = self
        Detailstable.dataSource = self
        ref = Database.database().reference()
        //fetchMealsList()
//        for i in 1...31{
//            for _ in 1...3{
//                writeData(i:i)
//            }
//        }
        appear(box:"box1")
        

//        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(selectAction(_:)), for: UIControl.Event.valueChanged)
//        Detailstable.addSubview(refreshControl)
        
        Detailstable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0);   //讓底部兩格顯示出來
        
        //appear(box:"box1")
        print("1")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func writeData(i:Int){
        let autoid = ref.childByAutoId().key
        ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").child("阿巴克丁")
            .child(autoid!).child("Date").setValue("20/5/\(i)")
        ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").child("阿巴克丁")
        .child(autoid!).child("Take").setValue("是")
        ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").child("阿巴克丁")
        .child(autoid!).child("Time").setValue("9:00")
        ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").child("阿巴克丁")
        .child(autoid!).child("Name").setValue("阿巴克丁")
        ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").child("阿巴克丁")
        .child(autoid!).child("count").setValue("3")
    }

    func appear(box : String){//讀取firebase
        medList = []
//        if medList.count != 0{
//            for i in 0...(medList.count-1)
//            {medList.remove(at: 0)}}
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "病患"{
                self.ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child(box).observe(.childAdded, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String : AnyObject]{
                        let hisDetails = MedHistory()
                        hisDetails.setValuesForKeys(dictionary)
                        //print(hisDetails)
                        self.medList.append(hisDetails)
                        //print(self.medList)
                        DispatchQueue.main.async {
                            self.Detailstable.reloadData()
                            //self.refreshControl!.endRefreshing()
                            
                            }
                        }
                })
            }else{
                self.ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").child(box).observe(.childAdded, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String : AnyObject]{
                        let hisDetails = MedHistory()
                        hisDetails.setValuesForKeys(dictionary)
                        //print(hisDetails)
                        self.medList.append(hisDetails)
                        //print(self.medList)
                        DispatchQueue.main.async {
                            self.Detailstable.reloadData()
                            //self.refreshControl!.endRefreshing()
                            }
                        }
                })
            }
        }
//        ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child(box).observe(.childAdded, with: { (snapshot) in
//            if let dictionary = snapshot.value as? [String : AnyObject]{
//                let hisDetails = MedHistory()
//                hisDetails.setValuesForKeys(dictionary)
//                //print(hisDetails)
//                self.medList.append(hisDetails)
//                //print(self.medList)
//                DispatchQueue.main.async {
//                    self.Detailstable.reloadData()
//                    }
//                }
//        })
    }

    @IBAction func selectAction(_ sender: Any) {
        if sControl.selectedSegmentIndex == 0{
//            refreshControl.addTarget(self, action: #selector(selectAction(_:)), for: UIControl.Event.valueChanged)
//            Detailstable.addSubview(refreshControl)
            medList = []
            appear(box:"box1")
            self.Detailstable.reloadData()
            print("1")
        }
        if sControl.selectedSegmentIndex == 1{
//            refreshControl.addTarget(self, action: #selector(selectAction(_:)), for: UIControl.Event.valueChanged)
//            Detailstable.addSubview(refreshControl)
            medList = []
            appear(box:"box2")
            self.Detailstable.reloadData()
            print("2")

        }
        if sControl.selectedSegmentIndex == 2{
//            refreshControl.addTarget(self, action: #selector(selectAction(_:)), for: UIControl.Event.valueChanged)
//            Detailstable.addSubview(refreshControl)
            medList = []
            appear(box:"box3")
            self.Detailstable.reloadData()
            print("3")

        }
        if sControl.selectedSegmentIndex == 3{
//            refreshControl.addTarget(self, action: #selector(selectAction(_:)), for: UIControl.Event.valueChanged)
//            Detailstable.addSubview(refreshControl)
            medList = []
            appear(box:"box4")
            self.Detailstable.reloadData()
            print("4")

        }
        if sControl.selectedSegmentIndex == 4{
//            refreshControl.addTarget(self, action: #selector(selectAction(_:)), for: UIControl.Event.valueChanged)
//            Detailstable.addSubview(refreshControl)
            medList = []
            appear(box:"box5")
            self.Detailstable.reloadData()
            print("5")

        }
        if sControl.selectedSegmentIndex == 5{
//            refreshControl.addTarget(self, action: #selector(selectAction(_:)), for: UIControl.Event.valueChanged)
//            Detailstable.addSubview(refreshControl)
            medList = []
            appear(box:"box6")
            self.Detailstable.reloadData()
            print("6")
        }

    }
    

    /*    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

