//
//  FTPanDismissAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 28/12/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit

public class FTPanDismissAnimator: UIPercentDrivenInteractiveTransition {
    
    public var interactionInProgress = false
    public weak var dismissAnimator: FTDismissAnimator!
    public weak var viewController: UIViewController?
    fileprivate var shouldCompleteTransition = false
    
    lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        return gesture
    }()
    
    lazy var edgePanGesture: UIScreenEdgePanGestureRecognizer = {
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
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
            self.handleDismissProgress(translation: translation)
        case .cancelled:
            self.handleDismissCancel()
        case .ended:
            if shouldCompleteTransition {
                self.handleDismissFinish()
            } else {
                self.handleDismissCancel()
            }
        default:
            break
        }
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
    
    func updateTargetViewFrame(_ progress: CGFloat, translation: CGPoint) {
        guard let config = self.dismissAnimator.config else {
            return
        }
        let sourceFrame = config.targetFrame
        let targetFrame = config.sourceFrame
        let targetX = sourceFrame.origin.x + (targetFrame.origin.x - sourceFrame.origin.x) * progress
        let targetY = sourceFrame.origin.y + (targetFrame.origin.y - sourceFrame.origin.y) * progress
        let targetWidth = sourceFrame.width + (targetFrame.width - sourceFrame.width) * progress
        let targetHeight = sourceFrame.height + (targetFrame.height - sourceFrame.height) * progress
        config.transitionImageView.frame = CGRect(x: targetX, y: targetY, width: targetWidth, height: targetHeight)
        if config.enableZoom == true {
            let zoomScale: CGFloat = config.targetFrame.size.width/config.sourceFrame.size.width
            config.transitionImageView.layer.transform = CATransform3DMakeScale(zoomScale, zoomScale, 1.0)
        }
    }
    
    func finishAnimation() {
        guard let config = self.dismissAnimator.config else {
            return
        }
        config.sourceView?.isHidden = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            config.transitionImageView.frame = config.sourceFrame
            config.transitionImageView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        } completion: { complete in
            config.transitionImageView.isHidden = true
            config.sourceView?.isHidden = false
        }  
    }

}
