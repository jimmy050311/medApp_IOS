//
//  HisPageViewController.swift
//  medicine
//
//  Created by amkdajmal on 2020/10/31.
//  Copyright © 2020 amkdajmal. All rights reserved.
//

import UIKit

class HisPageViewController: UIPageViewController,UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = index - 1
        guard previousIndex>=0 && previousIndex < orderedViewControllers.count else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = index + 1
        guard nextIndex>=0 && nextIndex < orderedViewControllers.count else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    func showPage(byIndex index: Int) {
        let viewController = orderedViewControllers[index]
        setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
    }
    
    lazy var page1ViewController: DetailsViewController = {
            self.storyboard!.instantiateViewController(withIdentifier: "Page1_1" )as! DetailsViewController
    }()
    lazy var MedOneViewController: MedOneViewController = {
            self.storyboard!.instantiateViewController(withIdentifier: "Page2_1") as! MedOneViewController
    }()
    lazy var orderedViewControllers: [UIViewController] = {
        [self.page1ViewController, self.MedOneViewController]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        setViewControllers([page1ViewController], direction: .forward, animated: false, completion: nil)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

