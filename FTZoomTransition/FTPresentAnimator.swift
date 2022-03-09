//
//  FTPresentAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit

public class FTPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var config: FTZoomTransitionConfig?
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        guard let config = config else {
            return 0
        }
        return max(FTZoomTransitionConfig.maxAnimationDuriation(), config.presentAnimationDuriation)
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let config = config else {
            return
        }
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let container = transitionContext.containerView
        
        fromVC.view.frame = CGRect(origin: CGPoint.zero, size: container.bounds.size)
        toVC.view.frame = CGRect(origin: CGPoint.zero, size: container.bounds.size);
        container.addSubview(fromVC.view)
        container.addSubview(toVC.view)
        
        config.transitionImageView.frame = config.sourceFrame
        config.transitionImageView.isHidden = false
        container.addSubview(config.transitionImageView)
        config.sourceView?.isHidden = true
        toVC.view.alpha = 0
        
        let zoomScale: CGFloat = config.targetFrame.size.width/config.sourceFrame.size.width
        
        if config.enableZoom == true {
            let sourcePoint = config.sourceFrame.origin
            let targetPoint = config.targetFrame.origin
            var anchorPoint = CGPoint(x: (abs(sourcePoint.x*zoomScale)-targetPoint.x)/container.bounds.size.width, y: (abs((sourcePoint.y*zoomScale)-targetPoint.y))/container.bounds.size.height)
            if sourcePoint.x >= container.bounds.size.width/2 {
                anchorPoint = CGPoint(x: (config.sourceFrame.origin.x + config.sourceFrame.size.width)/container.bounds.size.width, y: (abs(sourcePoint.y*zoomScale-targetPoint.y))/container.bounds.size.height)
            }
            fromVC.view.setAnchorPoint(anchorPoint: anchorPoint)
        }
        
        let keyframeAnimationOption = UIView.KeyframeAnimationOptions.calculationModeCubic
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                                delay: 0,
                                options: keyframeAnimationOption,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                                        config.transitionImageView.frame = config.targetFrame
                                        fromVC.view.alpha = 0
                                    })
                                    if config.enableZoom == true {
                                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                                            fromVC.view.layer.transform = CATransform3DMakeScale(zoomScale, zoomScale, 1)
                                        })
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.99, relativeDuration: 0.01, animations: {
                                        toVC.view.alpha = 1
                                    })
        }, completion: { (completed) -> () in
            fromVC.view.alpha = transitionContext.transitionWasCancelled ? 1.0: 0.0
            config.transitionImageView.alpha = transitionContext.transitionWasCancelled ? 1.0: 0.0
            config.transitionImageView.isHidden = true
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}

