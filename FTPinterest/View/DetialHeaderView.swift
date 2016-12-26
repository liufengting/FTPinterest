//
//  DetialHeaderView.swift
//  FTPinterest
//
//  Created by liufengting on 06/12/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit
import Kingfisher
import FTImageSize

class DetialHeaderView: UIView {

//    lazy var imageView : UIImageView = {
//        let imageV = UIImageView(frame: CGRect.zero)
//        imageV.layer.cornerRadius = 5
//        imageV.clipsToBounds = true
//        imageV.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.addSubview(imageV)
//        return imageV
//    }()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!

    func setup(imageUrl: String) {
        
        let imageSize : CGSize = FTImageSize.getImageSizeFromImageURL(imageUrl, perferdWidth: self.frame.size.width-30)
        
        imageViewHeightConstraint.constant = imageSize.height
        
        imageView.kf.setImage(with: URL(string: imageUrl)!)
    }
    
    
    
    
    func hide() {
//        imageView.frame = CGRect(x: 15, y: 15, width: self.frame.size.width-30, height: self.frame.size.height-30)
        imageView.isHidden = true
    }

}
