
import Foundation
import UIKit

final public class ThreeQuaterModalPresentationController: UIPresentationController {
    
    lazy private var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.67)
        view.alpha = 0.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(ThreeQuaterModalPresentationController.dimmingViewTapped(_:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    override public init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override public func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        dimmingView.alpha = 0.0
        containerView?.insertSubview(dimmingView, at: 0)
        
        let animations = {
            self.dimmingView.alpha = 1.0
        }
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            
            transitionCoordinator.animate(alongsideTransition: { (_) in
                animations()
            }, completion: nil)
        } else {
            animations()
        }
    }
    
    override public func dismissalTransitionWillBegin() {
        let animations = {
            self.dimmingView.alpha = 0.0
        }
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (_) in
                animations()
            }, completion: nil)
        } else {
            animations()
        }
    }
    
    override public var adaptivePresentationStyle: UIModalPresentationStyle {
        get {
            return .none
        }
    }
    
    override public var shouldPresentInFullscreen: Bool {
        get {
            return true
        }
    }
    
    override public func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width,
                      height: round(parentSize.height * 0.9))
    }
    
    override public func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView!.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
        self.createShadow()
    }
    
    private func createShadow() {
        presentedView?.layer.shadowColor = UIColor.black.withAlphaComponent(0.16).cgColor
        presentedView?.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        presentedView?.layer.shadowRadius = 4
        presentedView?.layer.shadowOpacity = 1.0
        presentedView?.layer.masksToBounds = false
    }
    
    override public var frameOfPresentedViewInContainerView: CGRect {
        get {
            let size = CGSize(width: containerView!.bounds.width, height: 550.0)
            return CGRect(origin: CGPoint(x: 0.0, y: containerView!.frame.maxY - 550.0),
                          size: size)
        }
    }
    
    // MARK: Private
    
    @objc private func dimmingViewTapped(_ tap: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}

final public class iPhoneXPresentationController: UIPresentationController {
    
    lazy private var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.alpha = 0.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(iPhoneXPresentationController.dimmingViewTapped(_:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    override public init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override public func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        dimmingView.alpha = 0.0
        containerView?.insertSubview(dimmingView, at: 0)
        
        let animations = {
            self.dimmingView.alpha = 1.0
        }
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            
            transitionCoordinator.animate(alongsideTransition: { (_) in
                animations()
            }, completion: nil)
        } else {
            animations()
        }
    }
    
    override public func dismissalTransitionWillBegin() {
        let animations = {
            self.dimmingView.alpha = 0.0
        }
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (_) in
                animations()
            }, completion: nil)
        } else {
            animations()
        }
    }
    
    override public var adaptivePresentationStyle: UIModalPresentationStyle {
        get {
            return .none
        }
    }
    
    override public var shouldPresentInFullscreen: Bool {
        get {
            return true
        }
    }
    
    override public func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width,
                      height: round(parentSize.height * 0.9))
    }
    
    override public func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView!.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
        self.createShadow()
    }
    
    private func createShadow() {
        presentedView?.layer.shadowColor = UIColor.black.withAlphaComponent(0.16).cgColor
        presentedView?.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        presentedView?.layer.shadowRadius = 4
        presentedView?.layer.shadowOpacity = 1.0
        presentedView?.layer.masksToBounds = false
    }
    
    override public var frameOfPresentedViewInContainerView: CGRect {
        get {
            let size = CGSize(width: containerView!.bounds.width, height: 720.0)
            return CGRect(origin: CGPoint(x: 0.0, y: containerView!.frame.maxY - 720.0),
                          size: size)
        }
    }
    
    // MARK: Private
    
    @objc private func dimmingViewTapped(_ tap: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
