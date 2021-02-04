//
//  SimplePageViewController.swift
//
//  Created by Benjamin McMurrich on 16/05/2018.
//  Copyright © 2018 I See U. All rights reserved.
//

import UIKit

class SimplePage: UIViewController {
    
    var message = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = self.title
        messageLabel.text = message
    }
}

class SimplePageViewController: UIPageViewController {
    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withTitle: "FORGET WATER ANALYZES".localized, message: "You no longer have to worry about the quality of the water. Thanks to its sensors, Flipr performs the analyzes for you in real time. An anomaly is detected: Flipr warns you and tells you what to do.".localized),
            self.getViewController(withTitle: "SAVE ON MAINTENANCE".localized, message: "No more hazardous dosages of chemicals! With powerful algorithms, Flipr gives you the exact measurements to keep your pool clean, without waste or pond drain.".localized),
            self.getViewController(withTitle: "SWIM WITH SAFETY".localized, message: "A poorly disinfected or over-disinfected pool poses health risks, sometimes significant. Flipr helps you keep your pool healthy: no over-chlorination, no acidity problem. You control your pool.".localized)
        ]
    }()
    
    var currentIndex: Int?
    var pendingIndex: Int?
    
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        if let firstVC = pages.first
        {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        pageControl.numberOfPages = pages.count
        pageControl.frame = CGRect(x: 0, y: view.bounds.size.height - 20, width: view.bounds.size.width, height: 20)
        self.view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: pageControl, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: pageControl, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        view.addConstraints([horizontalConstraint, verticalConstraint])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func getViewController(withTitle title: String, message: String) -> UIViewController
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Page") as! SimplePage
        vc.title = title
        vc.message = message
        vc.view.backgroundColor = .clear
        return vc
    }

}

extension SimplePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return pages.last }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    
}

extension SimplePageViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.index(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
}
