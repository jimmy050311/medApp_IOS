//
//  PageViewController.swift
//  medicine
//
//  Created by amkdajmal on 2019/5/20.
//  Copyright © 2019年 amkdajmal. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var page1ViewController: Page1ViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "Page1") as! Page1ViewController
    }()
    lazy var page2ViewController: Page2ViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "Page2") as! Page2ViewController
    }()
    lazy var page3ViewController: Page3ViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "Page3") as! Page3ViewController
    }()
    lazy var page4ViewController: Page4ViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "Page4") as! Page4ViewController
    }()
    
    lazy var orderedViewControllers: [UIViewController] = {
        [self.page1ViewController, self.page2ViewController, self.page3ViewController, self.page4ViewController]
    }()
    
    var mainViewController: HomeViewController!
    var willTransitionTo: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        setViewControllers([page1ViewController], direction: .forward, animated: false, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showPage(byIndex index: Int) {
        let viewController = orderedViewControllers[index]
        setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = index - 1
        guard previousIndex >= 0 && previousIndex < orderedViewControllers.count else {
            return nil
        }
        print("number1")
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = index + 1
        guard nextIndex >= 0 && nextIndex < orderedViewControllers.count else {
            return nil
        }
        print("number2")
        return orderedViewControllers[nextIndex]
    }
    
    // MARK: - UIPageViewControllerDeleage
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.willTransitionTo = pendingViewControllers.first
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard let index = orderedViewControllers.firstIndex(of: self.willTransitionTo)
                else { return }
            let previousViewController = previousViewControllers.first!
            let previousIndex = orderedViewControllers.firstIndex(of: previousViewController)
            if index != previousIndex {
                mainViewController.changeTab(byIndex: index)
            }
        }
        print("number3")
    }
    
    
    
}

