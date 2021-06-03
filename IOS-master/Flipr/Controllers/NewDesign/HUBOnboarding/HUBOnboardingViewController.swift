//
//  HUBOnboardingViewController.swift
//  Flipr
//
//  Created by Ajeesh T S on 27/05/21.
//  Copyright © 2021 I See U. All rights reserved.
//

import UIKit

class HUBOnboardingViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = 12
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: view.frame.width, height: collectionView.frame.height)
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = collectionViewLayout
        
        if #available(iOS 14.0, *) {
            pageControl.preferredIndicatorImage = UIImage(named: "Step-Dot")
            pageControl.setIndicatorImage(UIImage(named: "Step"), forPage: 0)
        } else {
            // Fallback on earlier versions
        }
    }
}

extension HUBOnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.page = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
        
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
        if #available(iOS 14.0, *) {
            pageControl.setIndicatorImage(UIImage(named: "Step"), forPage: page)
            self.pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.08259455115, green: 0.1223137602, blue: 0.2131385803, alpha: 1)
            let otherPages = [0, 1, 2, 3].filter { $0 != page }
            otherPages.forEach {
                self.pageControl.setIndicatorImage(UIImage(named: "Step-Dot"), forPage: $0)
                self.pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.4743041992, green: 0.531175375, blue: 0.6073524356, alpha: 1)
                
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
