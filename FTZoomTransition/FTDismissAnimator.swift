//
//  FTDismissAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit

open class FTDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    
    open var config : FTZoomTransitionConfig!
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return max(FTZoomTransitionConfig.maxAnimationDuriation(), config.dismissAnimationDuriation)
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if config == nil {
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
        container.addSubview(self.config.transitionImageView)
        
        self.config.transitionImageView.frame = config.targetFrame
        self.config.transitionImageView.alpha = 1.0
        self.config.transitionImageView.isHidden = false
        
        let zoomScale : CGFloat = self.config.targetFrame.size.width/self.config.sourceFrame.size.width
        
        if self.config.enableZoom == true {
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
                                            print(self.config.sourceFrame)

                                            self.config.transitionImageView.frame = self.config.sourceFrame
                                        }
                                    })
                                    if self.config.enableZoom == true {
                                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration:  1.0, animations: {
                                            toVC.view.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
                                        })
                                    }
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.01, animations: {
                                        fromVC.view.alpha = 0
                                    })
                                    
        }, completion: { (completed) -> () in
            if (transitionContext.transitionWasCancelled == true){
                if self.config.enableZoom == true {
                    toVC.view.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
                }
                container.bringSubviewToFront(fromVC.view)
            }
            self.config.transitionImageView.isHidden = transitionContext.transitionWasCancelled
            self.config.sourceView?.isHidden = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
