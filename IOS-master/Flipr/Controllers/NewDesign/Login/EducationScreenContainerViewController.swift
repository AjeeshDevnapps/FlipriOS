//
//  EducationScreenContainerViewController.swift
//  Flipr
//
//  Created by Ajeesh on 17/07/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class EducationScreenContainerViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!

    
    var pageController: UIPageViewController!
    var controllers = [UIViewController]()
    var contentViewController : UIViewController?

    
    var nextPage : Int = 0
    var prevPage : Int = 0
    var screenCounts : Int = 3

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.roundCorner(corner: 12)
        configurePageViewController(state: 0)
        loginButton.setTitle("Login".localized, for: .normal)
        nextButton.setTitle("Create an account".localized, for: .normal)

        self.view.bringSubviewToFront(self.pageControl)
        pageControl.currentPage = 0

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonClicked(){
//        let vc = UIStoryboard.init(name: "PoolSettings", bundle: nil).instantiateViewController(withIdentifier: "PoolLocationViewController") as! PoolLocationViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    
    @IBAction func signupButtonClicked(){
        
        let signupView = UIStoryboard.init(name: "Signup", bundle: nil).instantiateViewController(withIdentifier: "SignUpEmailController") as! SignUpEmailController
        self.navigationController?.pushViewController(signupView)
    }
    
    func configurePageViewController(state : Int) {
        let pageCntrl = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.pageController = pageCntrl
//        self.pageController?.view.frame = contentView.frame
        self.contentViewController = self.pageController
        self.addChild(self.contentViewController!)
        self.contentViewController?.didMove(toParent: self)
        self.contentViewController!.view.frame = CGRectMake(0, 78,self.view.frame.size.width, self.contentView.frame.size.height)
//        self.contentViewController!.view.frame = contentView.frame
        self.contentViewController?.view.translatesAutoresizingMaskIntoConstraints = false
     //   self.contentViewController!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
        var viewController : UIViewController?
        if let introVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginEducationOneViewController") as? LoginEducationOneViewController{
            introVC.view.tag = index
            if index == 0{
                introVC.contentImageView.image = #imageLiteral(resourceName: "intro1")
                introVC.headingLbl.text = "Profitez enfin de votre piscine".localized
                introVC.subHeadingLbl.text = "Avec Flipr, l'entretien de la piscine devient un jeu d'enfant. Analysez l'eau à distance, réglez votre filtration, et oubliez la contrainte de l'entretien.".localized

            }
            else if index == 1{
                introVC.contentImageView.image = #imageLiteral(resourceName: "intro2")
                introVC.headingLbl.text = "Economisez sur l'entretien".localized
                introVC.subHeadingLbl.text = "Grâce à sa technologie FliprPredict, Flipr vous donne des conseils précis et hautement personnalisés pour éviter le gaspillage des traitements et de l'eau.".localized
            }
            else{
                introVC.contentImageView.image = #imageLiteral(resourceName: "intro3")
                introVC.headingLbl.text = "Prenez soin de votre santé".localized
                introVC.subHeadingLbl.text = "Les conseils de Flipr vous permettent de profiter d'une eau saine, sans sur-dosages de traitements et en évitant la prolifération de bactéries.".localized
            }
            viewController = introVC

        }else{
            viewController = nil
        }
        
        return viewController
    }

}


extension EducationScreenContainerViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
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
        if (index == screenCounts) {
            return nil;
        }
        // Decrease the index by 1 to return
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers.first as? LoginEducationOneViewController {
            self.nextPage = vc.view.tag
            pageControl.currentPage = self.nextPage
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            // current page has changed.
            self.prevPage = previousViewControllers[0].view.tag
            
        }
    }
    
}
