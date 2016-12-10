//
//  HomeViewController.swift
//  FTPinterest
//
//  Created by liufengting on 02/12/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit
import FTImageSize
import FTWaterFallLayout
import FTZoomTransition

private let homeCellReuseIdentifier = "HomeCollectionViewCellIdentifier"

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FTWaterFallLayoutDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var imageArray : [String]!

    fileprivate let transitionDelegate = FTZoomTransition()
    fileprivate let swipeInteractionController = FTInteractionTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        imageArray = getImages()

        self.collectionView.collectionViewLayout = collectionViewLayout

    }

    var collectionViewLayout : FTWaterFallLayout {
        let layout : FTWaterFallLayout = FTWaterFallLayout()
        layout.numberOfColumns = 2
        layout.sectionInsets = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
        layout.itemMaginSize = CGSize(width: 5, height: 5)
        layout.delegate = self
        return layout
    }
    
    func getImages() -> [String] {
        var array : [String] = [ "http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                                 "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                                 "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg",
                                 "http://ww1.sinaimg.cn/mw600/c0679ecagw1f6ff6ar7v7j20gt0me3yy.jpg",
                                 "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff6csucjj20gt0aijrh.jpg",
                                 "http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                                 "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                                 "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg",
                                 "http://ww1.sinaimg.cn/mw600/c0679ecagw1f6ff6ar7v7j20gt0me3yy.jpg" ]
        for _ in 0..<3 {
            array.append(contentsOf: array)
        }
        return array
    }
    // MARK: FTWaterFallLayoutDelegate
    
    func ftWaterFallLayout(layout: FTWaterFallLayout, heightForItem atIndex: IndexPath) -> CGFloat {
        // get image size without downloading it !!!!!! see more at :  https://github.com/liufengting/FTImageSize
        return FTImageSize.getImageSizeFromImageURL(imageArray[atIndex.item], perferdWidth: (self.view.frame.size.width - 45)/2).height + 10
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellReuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        
        cell.imageUrl = imageArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // present

        
        let sender : HomeCollectionViewCell = collectionView.cellForItem(at: indexPath) as! HomeCollectionViewCell
        let sourceRect = sender.convert(sender.imageView.frame, to: UIApplication.shared.keyWindow)


        let detialVC : DetialViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetialViewController") as! DetialViewController
        
        swipeInteractionController.wireToViewController(detialVC)

        detialVC.imageUrl = imageArray[indexPath.item]
        let element = FTZoomTransitionElement(sourceView: sender.imageView,
                                              sourceSnapView: sender.imageView.snapshotView(afterScreenUpdates: true)!,
                                              sourceFrame: sourceRect,
                                              targetView: detialVC.headerView.imageView,
                                              targetFrame: detialVC.imageRect)
        transitionDelegate.element = element
        detialVC.modalPresentationStyle = .custom
        detialVC.transitioningDelegate = self
        self.present(detialVC, animated: true, completion: {})
//        self.navigationController?.pushViewController(detialVC, animated: true)
        
    }

}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionDelegate.presentAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionDelegate.dismissAnimator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
    }
}

