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


public let homeCellReuseIdentifier = "HomeCollectionViewCellIdentifier"

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, FTWaterFallLayoutDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    var imageModelArray : [ImageModel] = []
    fileprivate let transitionDelegate = FTZoomTransition()
    
    var imageURLs : [String] = [ "http://wx4.sinaimg.cn/mw600/007wHJ1wly1gs6ocli7hlj318g0toary.jpg",
                                 "http://wx1.sinaimg.cn/orj360/006KDv0Jly1gs1hys0m1zj33402c0qv5.jpg",
                                 "http://wx1.sinaimg.cn/orj360/006KDv0Jly1gs1hytnobhj33402c0npd.jpg",
                                 "http://wx1.sinaimg.cn/orj360/006KDv0Jly1gs1hyxep3aj31hc0u044q.jpg",
                                 "http://wx1.sinaimg.cn/mw600/007wHJ1wly1gs1hnskhshj30go0fm41t.jpg",
                                 "http://wx1.sinaimg.cn/mw600/007wHJ1wly1gs1h6z1k8rj30jg0pygo8.jpg",
                                 "http://wx1.sinaimg.cn/mw600/007wHJ1wly1gs1gs24581j30u00wvwg7.jpg"]

    override func viewDidLoad() {
        super.viewDidLoad()

        imageModelArray = getImages()

        self.collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: homeCellReuseIdentifier)
        
        self.collectionView.collectionViewLayout = collectionViewLayout

    }

    var collectionViewLayout : FTWaterFallLayout {
        let layout : FTWaterFallLayout = FTWaterFallLayout()
        layout.numberOfColumns = 2
        layout.sectionInsets = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
        layout.itemMaginSize = CGSize(width: 10, height: 10)
        layout.delegate = self
        return layout
    }
    
    func getImages() -> [ImageModel] {
        var array: [ImageModel] = []
        for _ in 0..<3 {
            for url in imageURLs {
                let size = FTImageSize.shared.getImageSize(url)
                array.append(ImageModel(imageURL: url, imageSize: size))
            }
        }
        return array
    }

    // MARK: FTWaterFallLayoutDelegate

    func ftWaterFallLayout(layout: FTWaterFallLayout, heightForItem atIndex: IndexPath) -> CGFloat {
        
        // get image size without downloading it !!!!!! see more at :  https://github.com/liufengting/FTImageSize
        
        let preferdWidth : CGFloat = (self.view.frame.size.width - 45)/2
        let imageSize : CGSize = FTImageSize.shared.convertSize(size: imageModelArray[atIndex.item].imageSize, perferdWidth: preferdWidth)
        return imageSize.height + 10
    }
    
    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellReuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        cell.setupWith(imageModel: imageModelArray[indexPath.item])
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
        
        let detialVC : DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetialViewController") as! DetailViewController
        

        detialVC.imageModel = imageModelArray[indexPath.item]
        
//        let element = FTZoomTransitionElement(sourceView: sender.imageView,
//                                              sourceSnapView: sender.imageView.snapshotView(afterScreenUpdates: true)!,
//                                              sourceFrame: sourceRect,
//                                              targetView: (detialVC.headerView.imageView)!,
//                                              targetFrame: detialVC.imageRect)


        
        let config = FTZoomTransitionConfig(sourceView: sender.imageView, image: sender.imageView.image, targetFrame: detialVC.imageRect)

        config.enableZoom = true
        
        transitionDelegate.config = config
        
        let nav = UINavigationController(rootViewController: detialVC)
        
        transitionDelegate.wirePanDismissToViewController(nav, for: detialVC.imageView)
        nav.transitioningDelegate = transitionDelegate

        
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: {})
    }
    
    

}



