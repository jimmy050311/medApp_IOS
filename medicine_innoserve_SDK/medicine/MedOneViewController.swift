//
//  MedOneViewController.swift
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
import PickerButton
import FSCalendar

protocol MyDelegate{
    func didFetchData(data:[Double])
    func hisFetchData(data:[String])

}

class MedOneViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return historyMed[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return historyMed.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.view.endEditing(false)//收鍵盤
        picker.reloadAllComponents()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return medNameStr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! MedChartTableViewCell
        cell.medLabel.text = medNameStr [indexPath.row]
        cell.countLabel.text = sumString [indexPath.row]
        cell.percentLabel.text = sumPercentStr [indexPath.row]
        return cell
    }
    
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var MedChartTableView: UITableView!    
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var cDateView: FSCalendar!
    @IBOutlet weak var selControl: UISegmentedControl!
    @IBOutlet weak var historyPicker: UIButton!
    @IBOutlet var topView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    
    
    
    var selectedButton: UIButton!
    var selectedButtonType : UIButton!
    var ref:DatabaseReference!
    var refHandle: UInt!
    var medList = [MedHistory]()
    var day = 1
    var days = [[String]]()
    var value = [[Double]]()
    var sumValue = [Double]()
    var sumString = [String]()
    var sumPercent = [Double]()
    var sumPercentStr = [String]()
    var medName : Set<String> = []
    var medNameStr = [String]()
    var medNameStrBut = [String]()
    var dateArray = [[String]]()
    var dateFormate = [[Date]]()
    var historyMed = [String]()
    var med : String = ""
    var dictionaryDate = [Date:[String]]()
    var calendarDate = Date()
    var negativedays = [String]()
    var positivedays = [String]()
    var buttonDetect = 0
    let empty1 = [String]()
    let empty2 = [Double]()

    let dispatchgroup = DispatchGroup()
    
    override func viewDidLoad() {
        
//                for i in 1...30{
//                    for _ in 1...1{
//                        writeData(i:i)
//                    }
//                }
        
        super.viewDidLoad()
        super.viewDidLayoutSubviews()

        switchControl.onTintColor = UIColor.red
        switchControl.tintColor = UIColor.red
        switchControl.thumbTintColor = UIColor.white
        switchControl.backgroundColor = UIColor.blue
        switchControl.layer.cornerRadius = 16
        
        historyPicker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        historyPicker.layer.cornerRadius = 20
        historyPicker.layer.borderWidth = 1
        historyPicker.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        cDateView.delegate = self
        cDateView.dataSource = self
        
        picker.delegate = self
        picker.dataSource = self

        ref = Database.database().reference()
        
        read_historyData()
        
        self.negativedays = []
        self.positivedays = []
        dictionaryDate.removeAll()
        readData(box : "box1",i : 0, day:day){
            self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
            print(self.negativedays)
            self.cDateView.reloadData()
        }
        //回歸歷史藥物
        historyPicker.setTitle("歷史藥物", for: .normal)
        //偵測哪一個按鈕
        buttonDetect = 1
        print("1")
        
}
    override func viewWillAppear(_ animated: Bool) {

        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        topView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0).isActive
            = true
        topView.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 0).isActive = true
        let constraitControl = topView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 128)
        constraitControl.identifier = "Bottom"
        constraitControl.isActive = true

        topView.layer.cornerRadius = 10
        super.viewWillAppear(animated)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if(dictionaryDate[date] != nil){
            var message : String = ""
            var c : Int = 0
            for i in dictionaryDate[date]!{
                message = message + i + " "
                print(message)
                 c = c + 1
                if c%3==0{
                    message = message + "\n"
                }
            }
            let alertController = UIAlertController(title:"用藥紀錄",message: message,
                                                    preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alertController,animated: true,completion: nil)
        }


    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor?{
        //let gregorian: Calendar = Calendar(identifier: .gregorian)
        let dateFormatterConvert: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yy/M/d"
            return formatter
        }()
        let dateString : String = dateFormatterConvert.string(from:date)
        if negativedays.contains(dateString) {
            return .red
        } else if positivedays.contains(dateString){
            return .green
        }else{
            return nil
        }
    }

    func readData(box :String,i :Int,day:Int,completion: @escaping ()->()){
        var countN: Double = 0
        var accumulation : [Double]=[]
        var finalacc : [Double]=[]
        let ar = [String]()
        let i = i
        var finaldateindex = [String]()
        var dateindex = [String]()
        var typecount = Int()
        var countY: Double = 0
        var chartcount : Double = 0

        days.append([""])
        value.append([0.0])
        dateArray.append([""])
        sumString.append("")
        sumValue.append(0.0)
        sumPercentStr.append("")
        sumPercent.append(0.0)
        medNameStr.append("")
        sumValue[i] = 0.0
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "病患"{
                self.ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").child(box).observe(.childAdded, with:{ (snapshot) in

                            //let ref = Database.database().reference()
                            //讀取藥物一天服用幾次
                            if let dictionary = snapshot.value as? [String : AnyObject]{

                                if dictionary["count"] != nil{
                                    typecount = Int((dictionary["count"] as! NSString).intValue)
                                }
                                //讀取日期陣列
                                if dictionary["Date"] != nil{
                                    dateindex.append(dictionary["Date"] as! String)
                                if dateindex.count % (typecount*day) == 0{
                                    finaldateindex.append(dateindex[dateindex.count-1])
                                }
                                //月曆紅字和綠字日期
                                if dictionary["Take"]! as! String == "否"{
                                    self.negativedays.append(dictionary["Date"] as! String)
                                }else{
                                    self.positivedays.append(dictionary["Date"] as! String)
                                }
                                //字串轉日期
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yy/MM/dd"
                                //formatter.timeZone =  NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
                                self.calendarDate = formatter.date(from: dictionary["Date"] as! String)!
                                //print(self.calendarDate)
                                //創建字典
                                    if self.dictionaryDate.keys.contains(self.calendarDate){
                                         self.dictionaryDate[self.calendarDate]!.append(dictionary["Time"] as! String)
                                        self.dictionaryDate[self.calendarDate]!.append(dictionary["Name"] as! String)
                                        self.dictionaryDate[self.calendarDate]!.append(dictionary["Take"] as! String)

                                    }else{
                                        self.dictionaryDate[self.calendarDate] = [dictionary["Time"] as! String,
                                                                                  dictionary["Name"] as! String,
                                                                                  dictionary["Take"] as! String]
                                    }
                                }
                                //讀取藥物名稱
                                if dictionary["Name"] != nil{
                                    self.medNameStr[0] = dictionary["Name"] as! String
                                    if(!self.medName.contains(dictionary["Name"] as! String)){
                                        self.medNameStrBut.append(dictionary["Name"] as! String)
                                    }
                                    self.medName.insert(dictionary["Name"] as! String)
                                }
                                //讀取是否服藥的次數
                                if dictionary["Take"] != nil{
                                    countN = countN+1
                                            if dictionary["Take"]! as! String == "是"{
                                                countY = countY+1
                                                chartcount = chartcount + 1
                                                accumulation.append(chartcount)
                                                self.sumValue[i] = countY + self.sumValue[i]
                                                self.sumString[i] = "\(String(format:"%.0f",self.sumValue[i]))/\(String(format: "%.0f",countN))次"
                                                self.sumPercent[i] = (self.sumValue[i]/countN*100)
                                                self.sumPercentStr[i] = "\(String(format: "%.0f", self.sumPercent[i]))%"
                                                countY = 0
                                               }else{
                                                accumulation.append(chartcount)
                                        }
                                    //print(accumulation)
                                    if accumulation.count % (typecount*day) == 0{
                                        if accumulation.count > typecount*day{
                                    finalacc.append(accumulation[accumulation.count-1]-accumulation[accumulation.count-1-(typecount*day)])

                                        }else{
                                            finalacc.append(accumulation[accumulation.count-1])
                                        }
                                    }
                                }
                            }
                        self.didFetchData(data: finalacc,day:ar,i:i,date:finaldateindex)
                    
                    completion()
                        })
                
            }else{
                self.ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").child(box).observe(.childAdded, with:{ (snapshot) in

                            //let ref = Database.database().reference()
                            //讀取藥物一天服用幾次
                            if let dictionary = snapshot.value as? [String : AnyObject]{

                                if dictionary["count"] != nil{
                                    typecount = Int((dictionary["count"] as! NSString).intValue)
                                }
                                //讀取日期陣列
                                if dictionary["Date"] != nil{
                                    dateindex.append(dictionary["Date"] as! String)
                                if dateindex.count % (typecount*day) == 0{
                                    finaldateindex.append(dateindex[dateindex.count-1])
                                }
                                //月曆紅字和綠字日期
                                if dictionary["Take"]! as! String == "否"{
                                    self.negativedays.append(dictionary["Date"] as! String)
                                }else{
                                    self.positivedays.append(dictionary["Date"] as! String)
                                }
                                //字串轉日期
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yy/MM/dd"
                                //formatter.timeZone =  NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
                                self.calendarDate = formatter.date(from: dictionary["Date"] as! String)!
                                //print(self.calendarDate)
                                //創建字典
                                    if self.dictionaryDate.keys.contains(self.calendarDate){
                                        self.dictionaryDate[self.calendarDate]!.append(dictionary["Time"] as! String)
                                        self.dictionaryDate[self.calendarDate]!.append(dictionary["Name"] as! String)
                                        self.dictionaryDate[self.calendarDate]!.append(dictionary["Take"] as! String)

                                    }else{
                                        self.dictionaryDate[self.calendarDate] = [dictionary["Time"] as! String,
                                                                                  dictionary["Name"] as! String,
                                                                                  dictionary["Take"] as! String]
                                    }
                                }
                                //讀取藥物名稱
                                if dictionary["Name"] != nil{
                                    self.medNameStr[0] = dictionary["Name"] as! String
                                    if(!self.medName.contains(dictionary["Name"] as! String)){
                                        self.medNameStrBut.append(dictionary["Name"] as! String)
                                    }
                                    self.medName.insert(dictionary["Name"] as! String)
                                }
                                //讀取是否服藥的次數
                                if dictionary["Take"] != nil{
                                    countN = countN+1
                                            if dictionary["Take"]! as! String == "是"{
                                                countY = countY+1
                                                chartcount = chartcount + 1
                                                accumulation.append(chartcount)
                                                self.sumValue[i] = countY + self.sumValue[i]
                                                self.sumString[i] = "\(String(format:"%.0f",self.sumValue[i]))/\(String(format: "%.0f",countN))次"
                                                self.sumPercent[i] = (self.sumValue[i]/countN*100)
                                                self.sumPercentStr[i] = "\(String(format: "%.0f", self.sumPercent[i]))%"
                                                countY = 0
                                               }else{
                                                accumulation.append(chartcount)
                                        }
                                    //print(accumulation)
                                    if accumulation.count % (typecount*day) == 0{
                                        if accumulation.count > typecount*day{
                                    finalacc.append(accumulation[accumulation.count-1]-accumulation[accumulation.count-1-(typecount*day)])

                                        }else{
                                            finalacc.append(accumulation[accumulation.count-1])
                                        }
                                    }
                                }
                            }
                        self.didFetchData(data: finalacc,day:ar,i:i,date:finaldateindex)
                        
                    completion()
                        })
            }
            
        }
        
//        ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").child(box).observe(.childAdded, with:{ (snapshot) in
//
//                    //let ref = Database.database().reference()
//                    //讀取藥物一天服用幾次
//                    if let dictionary = snapshot.value as? [String : AnyObject]{
//
//                        if dictionary["count"] != nil{
//                            typecount = Int((dictionary["count"] as! NSString).intValue)
//                        }
//                        //讀取日期陣列
//                        if dictionary["Date"] != nil{
//                            dateindex.append(dictionary["Date"] as! String)
//                        if dateindex.count % (typecount*day) == 0{
//                            finaldateindex.append(dateindex[dateindex.count-1])
//                        }
//                        //月曆紅字和綠字日期
//                        if dictionary["Take"]! as! String == "否"{
//                            self.negativedays.append(dictionary["Date"] as! String)
//                        }else{
//                            self.positivedays.append(dictionary["Date"] as! String)
//                        }
//                        //字串轉日期
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "yy/MM/dd"
//                        //formatter.timeZone =  NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
//                        self.calendarDate = formatter.date(from: dictionary["Date"] as! String)!
//                        //print(self.calendarDate)
//                        //創建字典
//                            if self.dictionaryDate.keys.contains(self.calendarDate){
//                                self.dictionaryDate[self.calendarDate]!.append(dictionary["Time"] as! String)
//                                self.dictionaryDate[self.calendarDate]!.append(dictionary["Name"] as! String)
//                                self.dictionaryDate[self.calendarDate]!.append(dictionary["Take"] as! String)
//
//                            }else{
//                                self.dictionaryDate[self.calendarDate] = [dictionary["Time"] as! String,
//                                                                          dictionary["Name"] as! String,
//                                                                          dictionary["Take"] as! String]
//                            }
//                        }
//                        //讀取藥物名稱
//                        if dictionary["Name"] != nil{
//                            self.medNameStr[0] = dictionary["Name"] as! String
//                            if(!self.medName.contains(dictionary["Name"] as! String)){
//                                self.medNameStrBut.append(dictionary["Name"] as! String)
//                            }
//                            self.medName.insert(dictionary["Name"] as! String)
//                        }
//                        //讀取是否服藥的次數
//                        if dictionary["Take"] != nil{
//                            countN = countN+1
//                                    if dictionary["Take"]! as! String == "是"{
//                                        countY = countY+1
//                                        chartcount = chartcount + 1
//                                        accumulation.append(chartcount)
//                                        self.sumValue[i] = countY + self.sumValue[i]
//                                        self.sumString[i] = "\(String(format:"%.0f",self.sumValue[i]))/\(String(format: "%.0f",countN))次"
//                                        self.sumPercent[i] = (self.sumValue[i]/countN*100)
//                                        self.sumPercentStr[i] = "\(String(format: "%.0f", self.sumPercent[i]))%"
//                                        countY = 0
//                                       }else{
//                                        accumulation.append(chartcount)
//                                }
//                            //print(accumulation)
//                            if accumulation.count % (typecount*day) == 0{
//                                if accumulation.count > typecount*day{
//                            finalacc.append(accumulation[accumulation.count-1]-accumulation[accumulation.count-1-(typecount*day)])
//
//                                }else{
//                                    finalacc.append(accumulation[accumulation.count-1])
//                                }
//                            }
//                        }
//                    }
//            self.didFetchData(data: finalacc,day:ar,i:i,date:finaldateindex)
//            completion()
//                })
    }
    
    func read_historyData(){
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Status").observeSingleEvent(of: .value) { (DataSnapshot) in
            let status = DataSnapshot.value as! String
            if status == "病患"{
                self.ref.child("users").child(Auth.auth().currentUser!.uid).child("Med_History_Now").observe(.value, with: {
                    (snapshot) in
                    for child in snapshot.children{
                        let dicvalue = child as! DataSnapshot
                        let key = dicvalue.key
                        self.hisFetchData(data: key)
                    }
                })
            }else{
                self.ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").observe(.value, with: {
                    (snapshot) in
                    for child in snapshot.children{
                        let dicvalue = child as! DataSnapshot
                        let key = dicvalue.key
                        self.hisFetchData(data: key)
                    }
                })
            }
        }
//        ref.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").observe(.value, with: {
//            (snapshot) in
//            for child in snapshot.children{
//                let dicvalue = child as! DataSnapshot
//                let key = dicvalue.key
//                self.hisFetchData(data: key)
//            }
//        })
    }
    func didFetchData(data:[Double],day:[String],i:Int,date:[String]){
        //Do what you want
        days[i]  = day
        value[i] = data
        dateArray[i] = date

        MedChartTableView.reloadData()

    }

    @IBAction func switchAcy(_ sender: UISwitch) {
        if sender.isOn == true{
            day = 1
            switch buttonDetect{
                case 1 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                readData(box : "box1",i : 0, day:day){
                    self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                    print(self.negativedays)
                    self.cDateView.reloadData()
                    
                }
                case 2 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                readData(box : "box2",i : 0, day:day){
                    self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                    self.cDateView.reloadData()
                }
                case 3 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                readData(box : "box3",i : 0, day:day){
                    self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                    self.cDateView.reloadData()
                }
                case 4 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                readData(box : "box4",i : 0, day:day){
                    self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                    self.cDateView.reloadData()
                }
                case 5 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                readData(box : "box5",i : 0, day:day){
                    self.setChart(dataPoints: self.days[0], values: self.value[0])
                    self.cDateView.reloadData()
                }
                case 6 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                readData(box : "box6",i : 0, day:day){
                    self.setChart(dataPoints: self.days[0], values: self.value[0])
                    self.cDateView.reloadData()
                }
                case 7 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                med = historyMed[picker.selectedRow(inComponent: 0)]
                historyPicker.setTitle(med, for: .normal)
                readData(box: med , i: 0 , day: day){
                    self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                    self.cDateView.reloadData()
                }
                default:
                print("error")
            }
        }else{
            day = 7
            switch buttonDetect{
                case 1 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                readData(box : "box1",i : 0, day:day){
                    self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                    print(self.negativedays)
                    self.cDateView.reloadData()
                }
                case 2 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                readData(box : "box2",i : 0, day:day){
                    self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                    self.cDateView.reloadData()
                }
                case 3 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                readData(box : "box3",i : 0, day:day){
                    self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                    self.cDateView.reloadData()
                }
                case 4 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                readData(box : "box4",i : 0, day:day){
                    self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                    self.cDateView.reloadData()
                }
                case 5 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                readData(box : "box5",i : 0, day:day){
                    self.setChart(dataPoints: self.days[0], values: self.value[0])
                    self.cDateView.reloadData()
                }
                case 6 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                readData(box : "box6",i : 0, day:day){
                    self.setChart(dataPoints: self.days[0], values: self.value[0])
                    self.cDateView.reloadData()
                }
                case 7 :
                self.negativedays = []
                self.positivedays = []
                dictionaryDate.removeAll()
                med = historyMed[picker.selectedRow(inComponent: 0)]
                historyPicker.setTitle(med, for: .normal)
                readData(box: med , i: 0 , day: day){
                    self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                    self.cDateView.reloadData()
                }
                default:
                print("error")
            }
        }
    }
    
    

    func hisFetchData(data:String){
        if(!data.contains("box")){
            historyMed.append(data)
            print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
            print(data)
        }
    }

    @IBAction func selAction(_ sender: Any) {
        if selControl.selectedSegmentIndex == 0{
            self.negativedays = []
            self.positivedays = []
            dictionaryDate.removeAll()
            readData(box : "box1",i : 0, day:day){
                self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                print(self.negativedays)
                self.cDateView.reloadData()
            }
            self.setChart(dataPoints: empty1, values: empty2)
            self.cDateView.reloadData()
            //回歸歷史藥物
            historyPicker.setTitle("歷史藥物", for: .normal)
            //偵測哪一個按鈕
            buttonDetect = 1
            print("1")
            
        }
        if selControl.selectedSegmentIndex == 1{
            self.negativedays = []
            self.positivedays = []
            dictionaryDate.removeAll()
            readData(box : "box2",i : 0, day:day){
                self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                self.cDateView.reloadData()
            }
            self.setChart(dataPoints: empty1, values: empty2)
            self.cDateView.reloadData()
            historyPicker.setTitle("歷史藥物", for: .normal)
            buttonDetect = 2
            print("2")

        }
        if selControl.selectedSegmentIndex == 2{
            self.negativedays = []
            self.positivedays = []
            dictionaryDate.removeAll()
            readData(box : "box3",i : 0, day:day){
                self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                self.cDateView.reloadData()
            }
            self.setChart(dataPoints: empty1, values: empty2)
            self.cDateView.reloadData()
            historyPicker.setTitle("歷史藥物", for: .normal)
            buttonDetect = 3
            print("3")
        }
        if selControl.selectedSegmentIndex == 3{
            self.negativedays = []
            self.positivedays = []
            dictionaryDate.removeAll()
            readData(box : "box4",i : 0, day:day){
                self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                self.cDateView.reloadData()
            }
            self.setChart(dataPoints: empty1, values: empty2)
            self.cDateView.reloadData()
            historyPicker.setTitle("歷史藥物", for: .normal)
            buttonDetect = 4
            print("4")

        }
        if selControl.selectedSegmentIndex == 4{
            self.negativedays = []
            self.positivedays = []
            dictionaryDate.removeAll()
            readData(box : "box5",i : 0, day:day){
                self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                self.cDateView.reloadData()
            }
            self.setChart(dataPoints: empty1, values: empty2)
            self.cDateView.reloadData()
            historyPicker.setTitle("歷史藥物", for: .normal)
            buttonDetect = 5
            print("5")
        }
        if selControl.selectedSegmentIndex == 5{
            self.negativedays = []
            self.positivedays = []
            dictionaryDate.removeAll()
            
            readData(box : "box6",i : 0, day:day){
                //self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
                self.cDateView.reloadData()
            }
            self.setChart(dataPoints: empty1, values: empty2)
            self.cDateView.reloadData()
            historyPicker.setTitle("歷史藥物", for: .normal)
            buttonDetect = 6
            print("6")
        }
    }
    

    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i),y:values[i])
            dataEntries.append(dataEntry)
            dataEntries.sort(by: { $0.x < $1.x })
        }
            //print(dataEntries)
        let lineChartDataSet = LineChartDataSet(entries : dataEntries, label: " ")
        lineChartView.rightAxis.enabled = false
        lineChartDataSet.drawCirclesEnabled = true
        lineChartDataSet.lineWidth = 5
        lineChartDataSet.highlightColor = .systemYellow
        lineChartDataSet.highlightLineWidth = 1
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        lineChartView.xAxis.granularity = 1
        let yAxis = lineChartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.granularity = 1
        yAxis.axisMinimum = 0
        //yAxis.axisMaximum = 120
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChartView.xAxis.setLabelCount(6, force: false)
        lineChartView.animate(xAxisDuration: 0.5)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setDrawValues(false)
        //lineChartData.dataSets[0].valueFormatter = self as? IValueFormatter
        lineChartView.data = lineChartData
        ref.child("users/\("2lHbliqLccTAwvsgmHA67ZZueWM2")/array").setValue("S")

        }
    func timeStringToDate(_ dateStr:String) ->Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateStr)
        return date!
    }
    func changeTab(to newButton: UIButton) {
        // 先利用 tintColor 取得 Button 預設的文字顏色
        let defaultColor = selectedButton.tintColor
        // 將目前選取的按鈕改成未選取的顏色
        selectedButton.backgroundColor = UIColor.white
        selectedButton.setTitleColor(defaultColor, for: .normal)
        // 將參數傳來的新按鈕改成選取的顏色
        newButton.backgroundColor = UIColor.lightGray
        newButton.setTitleColor(UIColor.black, for: .normal)
        // 將目前選取的按鈕改為新的按鈕
        selectedButton = newButton
    }
    func changeTab(byIndex index: Int) {
        switch index {
            case 0: changeTab(to: historyPicker)
            default: return
        }
    }
    func changeTabType(to newButton: UIButton) {
        // 先利用 tintColor 取得 Button 預設的文字顏色
        let defaultColor = selectedButtonType.tintColor
        // 將目前選取的按鈕改成未選取的顏色
        selectedButtonType.backgroundColor = UIColor.white
        selectedButtonType.setTitleColor(defaultColor, for: .normal)
        // 將參數傳來的新按鈕改成選取的顏色
        newButton.backgroundColor = UIColor.lightGray
        newButton.setTitleColor(UIColor.black, for: .normal)
        // 將目前選取的按鈕改為新的按鈕
        selectedButtonType = newButton
    }

    @IBAction func pickerselect(_ sender: Any) {
        displayPickerView(show: true)
    }    
    
    @IBAction func doneClick(_ sender: Any) {
        self.negativedays = []
        self.positivedays = []
        dictionaryDate.removeAll()
        med = historyMed[picker.selectedRow(inComponent: 0)]
        historyPicker.setTitle(med, for: .normal)
        readData(box: med , i: 0 , day: day){
            self.setChart(dataPoints: self.dateArray[0], values: self.value[0])
            self.cDateView.reloadData()
        }
        displayPickerView(show: false)
        buttonDetect = 7
    }
    
    func displayPickerView(show : Bool){
        for constraitControl in view.constraints{
            if constraitControl.identifier == "Bottom"{
                constraitControl.constant = (show) ? -10 : 128
                break
            }
        }
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }

    }
    func writeData(i:Int){
        let refs = Database.database().reference()
        let autoid = refs.childByAutoId().key
        refs.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").child("box5")
            .child(autoid!).child("Date").setValue("20/11/\(i)")
        refs.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").child("box5")
        .child(autoid!).child("Take").setValue("是")
        refs.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").child("box5")
        .child(autoid!).child("Time").setValue("9:00")
        refs.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").child("box5")
        .child(autoid!).child("Name").setValue("Dailycare_actibest")
        refs.child("users").child("SQyNvxzQGJYD4Q3P6MybHawUhlr2").child("Med_History_Now").child("box5")
        .child(autoid!).child("count").setValue("4")
    }

}
