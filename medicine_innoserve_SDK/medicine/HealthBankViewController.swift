//
//  HealthBankViewController.swift
//  medicine
//
//  Created by amkdajmal on 2020/12/6.
//  Copyright © 2020 amkdajmal. All rights reserved.
//

import UIKit

class HealthBankViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    var dateArray = [String]()
    var hospitalArray = [String]()
    var sickArray = [String]()
    var moneyArray = [String]()
    var medArray = [[String]]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "HealthBankCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HealthBankTableViewCell
        cell.DateText.text = dateArray[indexPath.row]
        cell.NameText.text = hospitalArray[indexPath.row]
        
        return cell
    }
    
    
    @IBOutlet weak var HealthBankTableView: UITableView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HealthBankTableView.delegate = self
        HealthBankTableView.dataSource = self
        readJson()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showhealth", sender: nil)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showhealth"{
            if let dvc = segue.destination as? HealthDetailViewController{
                let selectedIndexPath = HealthBankTableView.indexPathForSelectedRow

                    if let selectedRow = selectedIndexPath?.row{
                        dvc.infoFromViewOne1 = dateArray[selectedRow]
                        dvc.infoFromViewOne2 = hospitalArray[selectedRow]
                        dvc.infoFromViewOne3 = sickArray[selectedRow]
                        dvc.infoFromViewOne4 = moneyArray[selectedRow]
                        dvc.infoFromViewOne5 = medArray[selectedRow]
                    }
                }
             
        }
    }
    
    func readJson(){
            let jsonPath = NSTemporaryDirectory()+"sdkunzip/2020121114979021.json"
            let jsonPathUrl = URL(fileURLWithPath: jsonPath)
            let decoder = JSONDecoder()
            do{
                let loading = try NSString(contentsOfFile: jsonPath, encoding: String.Encoding.utf8.rawValue)
                let jsonData = try Data(contentsOf: jsonPathUrl)
                if let json = try JSONSerialization.jsonObject(with: jsonData,options: []) as? [String : Any]{
                    let dic1 = json
                    let details1 = dic1["myhealthbank"] as? [String : Any]
                    let dic2 = details1
                    let details2 = dic2!["bdata"] as? [String : Any]
                    let dic3 = details2
                    let details3 = dic3!["r1"] as? [[String : Any]]
                    let dic4 = details3
                    for i in 0...details3!.count-1{
                        let detailsDate = dic4![i]["r1.5"]
                        let detailsHospital = dic4![i]["r1.4"]
                        let detailsSick = dic4![i]["r1.9"] //病名
                        let detailsMoney = dic4![i]["r1.12"]  //金額
                        print(detailsDate!)
                        print(detailsHospital!)
                        print(detailsSick!)
                        print(detailsMoney!)
                        dateArray.append(detailsDate! as! String)
                        hospitalArray.append(detailsHospital! as! String)
                        sickArray.append(detailsSick! as! String)
                        moneyArray.append(detailsMoney! as! String)
                        let details4 = dic4![i]["r1_1"] as? [[String:Any]]
                        let dic5 = details4
                        for j in 0...details4!.count-1{
                            let med = dic5![j]["r1_1.2"]! as? String
                            let medDay = dic5![j]["r1_1.4"] as? String
                            if (med?.contains("錠"))! || (med?.contains("膠囊"))! || (med?.contains("貼片"))!{
                                print(med!)//藥物名
                                medArray.append([])
                                medArray[i].append(med!)
                            }
                            if !(medDay?.contains("0"))!{
                                print(medDay!)//天數
                            }
                        }
                        print("________________________________________________________")
                    }
                }
                }catch{
                    print("ERROR : \(error)")
                }
        }
}
