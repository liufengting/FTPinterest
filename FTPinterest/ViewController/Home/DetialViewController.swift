//
//  DetialViewController.swift
//  FTPinterest
//
//  Created by liufengting on 26/12/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit
import FTImageSize


class DetialViewController: UIViewController {

    var headerView : DetialHeaderView = Bundle.main.loadNibNamed("DetialHeaderView", owner: nil, options: nil)?[0] as! DetialHeaderView
    var imageRect : CGRect!
    var imageUrl : String! {
        didSet{
            self.setupHeaderView()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setupHeaderView() {
        
        let imageSize : CGSize = FTImageSize.getImageSizeFromImageURL(imageUrl, perferdWidth: UIScreen.main.bounds.width - 30)
        
        imageRect = self.view.convert(CGRect.init(x: 15, y: 64+15, width: UIScreen.main.bounds.width - 30, height: imageSize.height), to: UIApplication.shared.keyWindow)
        
        headerView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: imageRect.height + 100)
        headerView.setup(imageUrl: imageUrl)
        self.view.addSubview(headerView)
        
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true) { 
            // ..
        }
        
    }
    
}
