//
//  DetailViewController.swift
//  FTPinterest
//
//  Created by liufengting on 26/12/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit
import FTImageSize

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    var imageRect: CGRect = .zero
    var imageModel: ImageModel! {
        didSet {
            let imageSize: CGSize = FTImageSize.shared.convertSize(size: imageModel.imageSize, perferdWidth: UIScreen.main.bounds.width)
            self.imageRect = CGRect(x: 0, y: DetailViewController.navigationBarHeight, width: imageSize.width, height: imageSize.height)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleCloseBarButtonItemTapped(_:)))
        
        self.imageViewHeightConstraint.constant = self.imageRect.size.height
        self.imageView.kf.setImage(with: URL(string: imageModel.imageURL))
    }
    
    @objc func handleCloseBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            
        }
    }
    
}

extension UIViewController {
    
    static var statusBarHeight: CGFloat {
       if #available(iOS 13.0, *) {
           let statusManager = UIApplication.shared.delegate?.window??.windowScene?.statusBarManager
           return statusManager?.statusBarFrame.height ?? 20.0
       } else {
           return UIApplication.shared.statusBarFrame.height
       }
    }

    static var navigationBarHeight: CGFloat {
        return 44.0 + statusBarHeight
    }
    
}
