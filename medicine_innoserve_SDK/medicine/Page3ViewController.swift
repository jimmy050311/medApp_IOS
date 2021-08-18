//
//  Page3ViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/5/20.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Page3ViewController: UIViewController{

    
    @IBOutlet weak var page31Button: UIButton!
    @IBOutlet weak var page32Button: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var page33Button: UIButton!
    
    
    var page31ViewController: DetailsViewController!
    var selectedButton : UIButton!
    
    lazy var page32ViewController: MedOneViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "Page2_1") as! MedOneViewController
    }()
    lazy var page33ViewController: HealthBankViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "Page3_3") as! HealthBankViewController
    }()
    var selectedViewController: UIViewController!
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        selectedViewController = page31ViewController
        selectedButton = page31Button
        changeTab(to: page31Button)
        
        print("Page 3")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContainerViewSegue" {
            page31ViewController = segue.destination as! DetailsViewController
        }
    }
    
    func changePage(to newViewController: UIViewController) {
        // 2. Remove previous viewController
        selectedViewController.willMove(toParent: nil)
        selectedViewController.view.removeFromSuperview()
        selectedViewController.removeFromParent()
        
        // 3. Add new viewController
        addChild(newViewController)
        self.containerView.addSubview(newViewController.view)
        newViewController.view.frame = containerView.bounds
        newViewController.didMove(toParent: self)
        
        // 4.
        self.selectedViewController = newViewController
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPage31(_ sender: Any) {
        changeTab(to: page31Button)
        changePage(to: page31ViewController)
    }
    
    @IBAction func showPage32(_ sender: Any) {
        changeTab(to: page32Button)
        changePage(to: page32ViewController)
    }
    
    @IBAction func showPage33(_ sender: Any) {
        changeTab(to: page33Button)
        changePage(to: page33ViewController)
    }
    
}

