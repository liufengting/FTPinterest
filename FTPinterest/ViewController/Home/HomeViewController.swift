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


private let homeheaderReuseIdentifier = "homeheaderReuseIdentifier"
private let homeCellReuseIdentifier = "HomeCollectionViewCellIdentifier"

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FTWaterFallLayoutDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var imageArray : [String]!

    var headerView : DetialHeaderView?
    var imageRect : CGRect!
    var imageUrl : String! {
        didSet{
            self.setupHeaderView()
        }
    }
    
    
    fileprivate let transitionDelegate = FTZoomTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        imageArray = getImages()

        self.collectionView.collectionViewLayout = collectionViewLayout
        self.collectionView.register(DetialHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: homeheaderReuseIdentifier)

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
    
    

    
    func setupHeaderView() {
        
        let imageSize : CGSize = FTImageSize.getImageSizeFromImageURL(imageUrl, perferdWidth: UIScreen.main.bounds.width - 30)
        
        imageRect = self.view.convert(CGRect.init(x: 15, y: 20+15, width: UIScreen.main.bounds.width - 30, height: imageSize.height), to: UIApplication.shared.keyWindow)
        
        headerView = DetialHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: imageRect.height + 30))


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        headerView?.setup(imageUrl: imageUrl)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        headerView?.hide()
    }
    
    
    // MARK: FTWaterFallLayoutDelegate
    func ftWaterFallLayout(layout: FTWaterFallLayout, heightForHeader atSection: NSInteger) -> CGFloat {
        if (imageUrl != nil) {
            return headerView!.frame.size.height
        }
        return 0
    }
    
    func ftWaterFallLayout(layout: FTWaterFallLayout, heightForItem atIndex: IndexPath) -> CGFloat {
        // get image size without downloading it !!!!!! see more at :  https://github.com/liufengting/FTImageSize
        
        return FTImageSize.getImageSizeFromImageURL(imageArray[atIndex.item], perferdWidth: (self.view.frame.size.width - 45)/2).height + 10
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (imageUrl != nil) {
                headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: homeheaderReuseIdentifier, for: IndexPath(item: 0, section: 0)) as? DetialHeaderView
                return headerView!
        }
        return UICollectionReusableView()
    }
    
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

        self.showDetialWithIndexPath(indexPath: indexPath)
    }
    
    
    // MARK: show detialVC

    
    func showDetialWithIndexPath(indexPath: IndexPath) {
        
        // present

        let sender : HomeCollectionViewCell = collectionView.cellForItem(at: indexPath) as! HomeCollectionViewCell
        let sourceRect = sender.imageView.convert(sender.imageView.bounds, to: UIApplication.shared.keyWindow)
        
        
        let detialVC : HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        transitionDelegate.interactiveAnimator.wireToViewController(detialVC)
        
        detialVC.imageUrl = imageArray[indexPath.item]
        
        let element = FTZoomTransitionElement(sourceView: sender.imageView,
                                              sourceSnapView: sender.imageView.snapshotView(afterScreenUpdates: true)!,
                                              sourceFrame: sourceRect,
                                              targetView: detialVC.headerView?.imageView,
                                              targetFrame: detialVC.imageRect)
        
        element.enableZoom = true
        
        transitionDelegate.element = element
        
        detialVC.transitioningDelegate = transitionDelegate
        self.present(detialVC, animated: true, completion: {})
    }
    
    

}



