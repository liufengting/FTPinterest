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


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!

    func setup(imageUrl: String) {
        let imageSize: CGSize = FTImageSize.shared.getImageSizeFromImageURL(imageUrl, perferdWidth: self.frame.size.width-30)
        imageViewHeightConstraint.constant = imageSize.height
        imageView.kf.setImage(with: URL(string: imageUrl)!)
    }

    func hide() {
        imageView.isHidden = true
    }

}
