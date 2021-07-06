//
//  HomeCollectionViewCell.swift
//  Demo
//
//  Created by LiuFengting on 2021/7/1.
//

import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    public var imageModel : ImageModel!
    
//    {
//        didSet{
//

//        }
//    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.imageView.layer.cornerRadius = 5
        self.selectedBackgroundView = self.selectedBGView
    }
    
    func setupWith(imageModel: ImageModel) {
        self.imageView.kf.setImage(with: URL(string: imageModel.imageURL)!)
    }
    
    var selectedBGView : UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        return view
    }
    
}
