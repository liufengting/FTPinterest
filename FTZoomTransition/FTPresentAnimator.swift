//
//  FTPresentAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit

open class FTPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    open var config : FTZoomTransitionConfig!
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return max(FTZoomTransitionConfig.maxAnimationDuriation(), config.presentAnimationDuriation)
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if config == nil {
            return
        }
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let container = transitionContext.containerView
        
        fromVC.view.frame = CGRect(origin: CGPoint.zero, size: container.bounds.size)
        toVC.view.frame = CGRect(origin: CGPoint.zero, size: container.bounds.size);
        container.addSubview(fromVC.view)
        container.addSubview(toVC.view)
        
        self.config.transitionImageView.frame = config.sourceFrame
        self.config.transitionImageView.isHidden = false
        container.addSubview(config.transitionImageView)
        self.config.sourceView?.isHidden = true
        toVC.view.alpha = 0
        
        let zoomScale : CGFloat = self.config.targetFrame.size.width/self.config.sourceFrame.size.width
        
        if self.config.enableZoom == true {
            let sourcePoint = self.config.sourceFrame.origin
            let targetPoint = self.config.targetFrame.origin
            var anchorPoint = CGPoint(x: (abs(sourcePoint.x*zoomScale)-targetPoint.x)/container.bounds.size.width, y: (abs((sourcePoint.y*zoomScale)-targetPoint.y))/container.bounds.size.height)
            if sourcePoint.x >= container.bounds.size.width/2 {
                anchorPoint = CGPoint(x: (self.config.sourceFrame.origin.x + self.config.sourceFrame.size.width)/container.bounds.size.width, y: (abs(sourcePoint.y*zoomScale-targetPoint.y))/container.bounds.size.height)
            }
            fromVC.view.setAnchorPoint(anchorPoint: anchorPoint)
        }
        
        let keyframeAnimationOption = UIView.KeyframeAnimationOptions.calculationModeCubic
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                                delay: 0,
                                options: keyframeAnimationOption,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                                        self.config.transitionImageView.frame = self.config.targetFrame
                                        fromVC.view.alpha = 0
                                    })
                                    if self.config.enableZoom == true {
                                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                                            fromVC.view.layer.transform = CATransform3DMakeScale(zoomScale, zoomScale, 1)
                                        })
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.99, relativeDuration: 0.01, animations: {
                                        toVC.view.alpha = 1
                                    })
        }, completion: { (completed) -> () in
            fromVC.view.alpha = transitionContext.transitionWasCancelled ? 1.0 : 0.0
            self.config.transitionImageView.alpha = transitionContext.transitionWasCancelled ? 1.0 : 0.0
            self.config.transitionImageView.isHidden = true
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

