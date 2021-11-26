//
//  SubscriptionPageViewController.swift
//  Flipr
//
//  Created by Benjamin McMurrich on 09/04/2019.
//  Copyright © 2019 I See U. All rights reserved.
//

import UIKit

class SubscriptionPage: UIViewController {
    
    var message = ""
    var imageName = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = self.title
        messageLabel.text = message
        self.imageView.image = UIImage(named: imageName)
    }
}

class SubscriptionPageViewController: UIPageViewController {
    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withTitle: "Activez la connexion à distance".localized, message: "Accédez à la connexion automatique et à distance, même loin de chez vous !".localized, imageName: "slider1"),
            /*
            self.getViewController(withTitle: "Reduce your costs by almost 30%!".localized, message: "Flipr gives you the right product dosages and tells you how long the filtration works. No more waste: reduce your maintenance costs!".localized, imageName: "slider2"),
            self.getViewController(withTitle: "Receive alerts and act serenely!".localized, message:
                "Flipr Start infinite alerts you as soon as an event occurs: low pH, risk of a storm, frost alert: you are informed and you know what to do".localized, imageName: "slider3"),
            self.getViewController(withTitle: "Follow and anticipate the state of the water".localized, message:"Access Flipr Predict, follow the measurement history and temperature predictive curves".localized, imageName: "slider4"),
            self.getViewController(withTitle: "Up to 20 updates per day".localized, message: "Get updated data up to 20 times a day!".localized, imageName: "slider5"),
            self.getViewController(withTitle:
            "and many others !".localized, message:"Expert mode, customization of thresholds, inventory management ... And all the new features to come during the 2019 season!".localized, imageName: "slider6")
            */
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
        let verticalConstraint = NSLayoutConstraint(item: pageControl, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -6)
        view.addConstraints([horizontalConstraint, verticalConstraint])
        pageControl.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func getViewController(withTitle title: String, message: String, imageName:String) -> UIViewController
    {
        let vc = UIStoryboard(name: "Subscription", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionPage") as! SubscriptionPage
        vc.title = title
        vc.message = message
        vc.imageName = imageName
        vc.view.backgroundColor = .clear
        return vc
    }
    
}

extension SubscriptionPageViewController: UIPageViewControllerDataSource {
    
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

extension SubscriptionPageViewController : UIPageViewControllerDelegate {
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

