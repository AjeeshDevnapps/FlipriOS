//
//  DevicesViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 19/02/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class DevicesViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!

    var pageController: UIPageViewController!
    var controllers = [UIViewController]()
    var contentViewController : UIViewController?
    var nextPage : Int = 0
    var prevPage : Int = 0
    var devicesCount : Int = 0
    var images : [URL]?
    var devicesDetails:  [[String:Any]]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Devices"
//        self.setupPages()
        getHubInfo()
        // Do any additional setup after loading the view.
    }
    
    func getHubInfo(){
        User.currentUser?.getModuleList(completion: { (devices,error) in
            self.devicesDetails = devices
            self.setupPages()
            self.view.bringSubviewToFront(self.pageControl)
        })
        
    }
    
    func setupPages(){
        self.devicesCount =  self.devicesDetails?.count ?? 1
        self.devicesCount =  self.devicesCount + 1
        configurePageViewController(state: 0)
        pageControl.numberOfPages = devicesCount
        pageControl.currentPage = 0
    }
    
    func configurePageViewController(state : Int) {
        let pageCntrl = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController = pageCntrl
        self.pageController?.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 100)
        self.contentViewController = self.pageController
        self.addChild(self.contentViewController!)
        self.contentViewController?.didMove(toParent: self)
        self.contentViewController!.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 100)
        self.contentViewController?.view.clipsToBounds = false
        self.contentViewController!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.contentViewController!.view)
        self.pageController!.delegate = self
        self.pageController!.dataSource = self
        if let page = self.viewControllerAtIndex(index: state){
//            self.eventlistViewController = page as? EventListViewController
            //self.cellHolderTableVC?.selectionDelegate = self
            let viewControllers = [page]
            self.pageController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        }
        
    }
  
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        
        if index == devicesCount - 1{
            if let Vc = UIStoryboard.init(name: "Devices", bundle: nil).instantiateViewController(withIdentifier: "AddnewDeviceViewController") as? AddnewDeviceViewController {
                Vc.view.tag = index
                return Vc
            }else{
                return nil
            }
        }else{
            var viewController : UIViewController?
            if let Vc = UIStoryboard.init(name: "Devices", bundle: nil).instantiateViewController(withIdentifier: "DeviceViewController") as? DeviceViewController {
                Vc.view.tag = index
                if let info = self.devicesDetails?[index]{
                    Vc.devicesDetails = info
                }
                viewController =  Vc
            }else{
                viewController = nil
            }
            
            return viewController
            
        }
        
        
       
    }
    
    
   

}


extension DevicesViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index : Int = viewController.view.tag;
        if (index == 0) {
            return nil;
        }
        // Decrease the index by 1 to return
        index -= 1
        return viewControllerAtIndex(index: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index : Int = viewController.view.tag;
        index += 1
        if (index == devicesCount) {
            return nil;
        }
        // Decrease the index by 1 to return
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers.first as? UIViewController {
            self.nextPage = vc.view.tag
            print(vc.view.tag)
            pageControl.currentPage = self.nextPage
//            if let type = self.eventCategory?[vc.view.tag]{
//                if eventCategory != nil{
//                    //                AppSharedData.sharedInstance.newsCachedDataDict?[selectedCategory: newsResponse]
//                }
//                let typeId : Int = (type.id)!
//                selectedCategory = typeId
//                self.eventCategoryCollectionView.reloadData()
//            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            // current page has changed.
            self.prevPage = previousViewControllers[0].view.tag
            
        }
    }
    
}
