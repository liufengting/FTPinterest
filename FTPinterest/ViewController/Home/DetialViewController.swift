//
//  DetialViewController.swift
//  FTPinterest
//
//  Created by liufengting on 06/12/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit
import FTImageSize


class DetialViewController: UIViewController {

    var headerView : DetialHeaderView!
    var imageRect : CGRect!
    
    
    var imageUrl : String! {
        didSet{
            self.setupHeaderView()
        }
    }
    
    func setupHeaderView() {
        
        let imageSize : CGSize = FTImageSize.getImageSizeFromImageURL(imageUrl, perferdWidth: UIScreen.main.bounds.width - 30)

        headerView = DetialHeaderView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: imageSize.height + 30))
        
        headerView.setup(imageUrl: imageUrl)
        
        self.view.addSubview(headerView)
        
        imageRect = headerView.convert(headerView.imageView.frame, to: UIApplication.shared.keyWindow)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        headerView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: imageRect.height + 30)
//        headerView.resize()
//    }

    @objc func onTap(gesture : UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
}
