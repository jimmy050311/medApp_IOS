//
//  HomeViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/5/20.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var page1Button: UIButton!
    @IBOutlet weak var Page2Button: UIButton!
    @IBOutlet weak var Page3Button: UIButton!
    @IBOutlet weak var Page4Button: UIButton!
    @IBOutlet weak var scroll: UIScrollView!
    var selectedButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    var pageViewController: PageViewController!
    
    func changeTab(to newButton: UIButton) {
        // 先利用 tintColor 取得 Button 預設的文字顏色
        let defaultColor = selectedButton.tintColor
        // 將目前選取的按鈕改成未選取的顏色
        //selectedButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.7137254902, blue: 0.7647058824, alpha: 1)
        //selectedButton.setTitleColor(#colorLiteral(red: 0.1960784314, green: 0.3568627451, blue: 0.6, alpha: 1), for: .normal)
        selectedButton.layer.borderWidth = 1
        selectedButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // 將參數傳來的新按鈕改成選取的顏色
        //newButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)  //選取後的背景顏色
        newButton.layer.borderWidth = 5
        newButton.layer.borderColor = #colorLiteral(red: 0.1960784314, green: 0.3568627451, blue: 0.6, alpha: 1)
        //newButton.setTitleColor(#colorLiteral(red: 0.1960784314, green: 0.3568627451, blue: 0.6, alpha: 1), for: .normal)
        // 將參數傳來的新按鈕改成選取的顏色 , for: .normal)
        // 將目前選取的按鈕改為新的按鈕
        selectedButton = newButton
    }
    
    func changeTab(byIndex index: Int) {
        switch index {
        case 0:
            changeTab(to: page1Button)
            navigationItem.title = "藥盒"
        case 1:
            changeTab(to: Page2Button)
            navigationItem.title = "查詢"
        case 2:
            changeTab(to: Page3Button)
            navigationItem.title = "用藥數據"
        case 3:
            changeTab(to: Page4Button)
            navigationItem.title = "設定"
        default: return
        }
    }
    
    var mainViewController: HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        selectedButton = page1Button
        navigationItem.title = "藥盒"
        changeTab(to: page1Button)
        scroll.layer.borderWidth = 1
        scroll.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContainerViewSegue" {
            pageViewController = segue.destination as! PageViewController
            pageViewController.mainViewController = self
        }
    }
    
   
    @IBAction func showPage1(_ sender: Any) {
        changeTab(to: page1Button)
        pageViewController.showPage(byIndex: 0)
        navigationItem.title = "藥盒"
    }
    @IBAction func showPage2(_ sender: Any) {
        changeTab(to: Page2Button)
        pageViewController.showPage(byIndex: 1)
        navigationItem.title = "查詢"
    }
    @IBAction func showPage3(_ sender: Any) {
        changeTab(to: Page3Button)
        pageViewController.showPage(byIndex: 2)
        navigationItem.title = "用藥數據"
    }
    @IBAction func showPage4(_ sender: Any) {
        changeTab(to: Page4Button)
        pageViewController.showPage(byIndex: 3)
        navigationItem.title = "設定"
    }
}
