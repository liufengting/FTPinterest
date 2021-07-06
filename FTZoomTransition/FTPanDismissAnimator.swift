//
//  FTPanDismissAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 28/12/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit

open class FTPanDismissAnimator : UIPercentDrivenInteractiveTransition {
    
    public var interactionInProgress = false
    public weak var dismissAnimator: FTDismissAnimator!
    public weak var viewController: UIViewController?
    fileprivate var shouldCompleteTransition = false
    
    lazy var panGesture : UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        return gesture
    }()
    
    lazy var edgePanGesture : UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        gesture.edges = .left
        return gesture
    }()
    
    public func wirePanDismissToViewController(viewController: UIViewController, for view: UIView?) {
        self.viewController = viewController
        preparePanGestureRecognizerInView(viewController.view)
    }
    
    public func wireEdgePanDismissToViewController(viewController: UIViewController) {
        self.viewController = viewController
        preparePanGestureRecognizerInView(viewController.view)
    }
    
    public func handleDismissBegin() {
        interactionInProgress = true
        viewController?.view.isHidden = true
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    public func handleDismissProgress(translation: CGPoint) {
        var progress: CGFloat = 0.0
        if abs(translation.y) > abs(translation.x) {
            progress = (translation.y / UIScreen.main.bounds.size.height)
        } else {
            progress = (translation.x / UIScreen.main.bounds.size.width)
        }
        shouldCompleteTransition = (abs(progress) > 0.2)
        viewController?.view.isHidden = true
        self.updateTargetViewFrame(progress, translation: translation)
        update(abs(progress))
    }
    
    public func handleDismissCancel() {
        interactionInProgress = false
        viewController?.view.isHidden = false
        cancel()
    }
    public func handleDismissFinish() {
        interactionInProgress = false
        viewController?.view.isHidden = true
        self.finishAnimation()
        finish()
    }
    
    fileprivate func preparePanGestureRecognizerInView(_ view: UIView?) {
        view?.addGestureRecognizer(self.panGesture)
    }
    
    fileprivate func prepareEdgePanGestureRecognizerInView(_ view: UIView) {
        view.addGestureRecognizer(self.edgePanGesture)
    }
    
    @objc public func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            self.handleDismissBegin()
        case .changed:
            if gestureRecognizer.isEqual(self.panGesture) {
                let translation = gestureRecognizer.translation(in: gestureRecognizer.view!)
                self.handleDismissProgress(translation: translation)
            }
        case .cancelled:
            self.handleDismissCancel()
        case .ended:
            if shouldCompleteTransition {
                self.handleDismissFinish()
            } else {
                self.handleDismissCancel()
            }
        default: break
        }
    }
    
    func updateTargetViewFrame(_ progress: CGFloat, translation: CGPoint) {
        let sourceFrame = self.dismissAnimator.config.targetFrame
        let targetWidth = sourceFrame.width * (1.0 - abs(progress))
        let targetHeight = sourceFrame.height * (1.0 - abs(progress))
        let targetX = sourceFrame.origin.x + sourceFrame.size.width/2.0 - targetWidth/2.0 + translation.x
        let targetY = sourceFrame.origin.y + sourceFrame.size.height/2.0 - targetHeight/2.0 + translation.y
        self.dismissAnimator.config.transitionImageView.frame = CGRect(x: targetX, y: targetY, width: targetWidth, height: targetHeight)
    }
    
    func finishAnimation() {
        self.dismissAnimator.config.sourceView?.isHidden = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.dismissAnimator.config.transitionImageView.frame = self.dismissAnimator.config.sourceFrame
        } completion: { complete in
            self.dismissAnimator.config.transitionImageView.isHidden = true
            self.dismissAnimator.config.sourceView?.isHidden = false
        }  
    }
}
