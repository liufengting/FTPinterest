//
//  FTDismissAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit

public class FTDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    
    public var config: FTZoomTransitionConfig?
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        guard let config = config else {
            return 0
        }
        return max(FTZoomTransitionConfig.maxAnimationDuriation(), config.dismissAnimationDuriation)
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let config = config else {
            return
        }
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let container = transitionContext.containerView
        
        fromVC.view.frame = container.bounds;
        toVC.view.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        toVC.view.frame = container.bounds;
        toVC.view.alpha = 0.0
        
        container.addSubview(toVC.view)
        container.addSubview(config.transitionImageView)
        
        config.transitionImageView.frame = config.targetFrame
        config.transitionImageView.alpha = 1.0
        config.transitionImageView.isHidden = false
        
        let zoomScale: CGFloat = config.targetFrame.size.width/config.sourceFrame.size.width
        
        if config.enableZoom == true {
            toVC.view.layer.transform = CATransform3DMakeScale(zoomScale, zoomScale, 1.0)
        }

        let keyframeAnimationOption = UIView.KeyframeAnimationOptions.calculationModeCubic
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                                delay: 0,
                                options: keyframeAnimationOption,
                                animations:{
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration:  1.0, animations: {
                                        toVC.view.alpha = 1
                                        if (!transitionContext.isInteractive) {
                                            config.transitionImageView.frame = config.sourceFrame
                                        }
                                    })
                                    if config.enableZoom == true {
                                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration:  1.0, animations: {
                                            toVC.view.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
                                        })
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.01, animations: {
                                        fromVC.view.alpha = 0
                                    })
                                    
        }, completion: { (completed) -> () in
            if (transitionContext.transitionWasCancelled == true){
                if config.enableZoom == true {
                    toVC.view.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
                }
                container.bringSubviewToFront(fromVC.view)
            }
            config.transitionImageView.isHidden = transitionContext.transitionWasCancelled
            config.sourceView?.isHidden = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}
