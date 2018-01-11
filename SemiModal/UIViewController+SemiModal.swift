//
//  UIViewController+SemiModal.swift
//  https://github.com/xiaopin/SemiModal.git `swift` branch
//
//  Created by nhope on 2018/1/10.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

import UIKit

private let animationDuration: CFTimeInterval = 0.5
private var key = UnsafeRawPointer(bitPattern: "SemiModalTransitioningDelegate".hashValue)

// MARK: - Public API

extension UIViewController {
    
    /// 显示一个从底部弹起的半模态视图控制器
    ///
    /// - Parameters:
    ///   - contentViewController:  模态视图控制器
    ///   - contentHeight:          模态视图高度
    ///   - shouldDismissModal:     点击模态视图之外的区域是否关闭模态窗口
    ///   - completion:             模态窗口显示完毕时的回调
    @available(iOS 8.0, *)
    func presentSemiModalViewController(_ contentViewController: UIViewController, contentHeight: CGFloat, shouldDismissModal: Bool, completion: (() -> Void)?) {
        if let _ = presentedViewController { return }
        contentViewController.modalPresentationStyle = .custom
        contentViewController.preferredContentSize = CGSize(width: 0.0, height: contentHeight)
        
        let transitioningDelegate = SemiModalTransitioningDelegate()
        contentViewController.transitioningDelegate = transitioningDelegate
        // Keep strong references.
        objc_setAssociatedObject(contentViewController, &key, transitioningDelegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        if let presentationController = contentViewController.presentationController as? SemiModalPresentationController {
            presentationController.isShouldDismissModal = shouldDismissModal
        }
        
        present(contentViewController, animated: true, completion: completion)
    }
    
    
    /// 显示一个从底部弹起的半模态视图
    ///
    /// 内部会创建一个UIViewController并将contentView添加到该控制器的view上,并添加`距离父视图上下左右均为0`的约束.
    /// 如果需要手动关闭模态窗口,则`谁弹出谁负责关闭`,即`self.presentedViewController?.dismiss(animated: true, completion: nil)`
    ///
    /// - Parameters:
    ///   - contentView:            模态视图
    ///   - contentHeight:          模态视图高度
    ///   - shouldDismissModal:     点击模态视图之外的区域是否关闭模态窗口
    ///   - completion:             模态窗口显示完毕时的回调
    @available(iOS 8.0, *)
    func presentSemiModalView(_ contentView: UIView, contentHeight: CGFloat, shouldDismissModal: Bool, completion: (() -> Void)?) {
        let contentViewController = UIViewController()
        contentViewController.view.backgroundColor = .clear
        contentViewController.view.addSubview(contentView)
        
        let views = ["contentView": contentView]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: .directionLeadingToTrailing, metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", options: .directionLeadingToTrailing, metrics: nil, views: views))
        
        presentSemiModalViewController(contentViewController, contentHeight: contentHeight, shouldDismissModal: shouldDismissModal, completion: completion)
    }
    
}


// MARK: - Private API


private class SemiModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SemiModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = SemiModalAnimatedTransitioning()
        animation.isPresentation = true
        return animation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = SemiModalAnimatedTransitioning()
        animation.isPresentation = false
        return animation
    }
    
}


private class SemiModalAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresentation = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else { return }
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        if isPresentation, let toView = toView {
            transitionContext.containerView.addSubview(toView)
            toView.layer.shadowColor = UIColor.black.cgColor
            toView.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
            toView.layer.shadowRadius = 5.0
            toView.layer.shadowOpacity = 0.8
            toView.layer.shouldRasterize = true
            toView.layer.rasterizationScale = UIScreen.main.scale
        }
        
        let animatingVC = isPresentation ? toVC : fromVC
        let finalFrame = transitionContext.finalFrame(for: animatingVC)
        animatingVC.view.frame  = isPresentation ? finalFrame.offsetBy(dx: 0.0, dy: finalFrame.size.height) : finalFrame
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            animatingVC.view.frame = self.isPresentation ? finalFrame : finalFrame.offsetBy(dx: 0.0, dy: finalFrame.size.height)
        }) { (_) in
            if !self.isPresentation {
                fromView?.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        }
    }
    
}


private class SemiModalPresentationController: UIPresentationController {
    
    var isShouldDismissModal = true
    private var animatingView: UIView?
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isUserInteractionEnabled = false
        return view
    }()
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        return view
    }()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction(_:)))
        dimmingView.addGestureRecognizer(tap)

        if let window = UIApplication.shared.keyWindow,
            let snapshotView = window.snapshotView(afterScreenUpdates: true) {
            let views = ["view": snapshotView]
            animatingView = snapshotView
            backgroundView.addSubview(snapshotView)
            snapshotView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: views))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: views))
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerSize = containerView?.bounds.size else {
            return .zero
        }
        var presentedViewFrame = CGRect.zero
        let width = containerSize.width
        let height = min(containerSize.height, presentedViewController.preferredContentSize.height)
        
        presentedViewFrame.size = CGSize(width: width, height: height)
        presentedViewFrame.origin = CGPoint(x: 0.0, y: containerSize.height-height)
        return presentedViewFrame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        backgroundView.frame = containerView?.bounds ?? .zero
        dimmingView.frame = backgroundView.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(backgroundView)
        containerView?.addSubview(dimmingView)
        let animation = backgroundTranslateAnimation(true)
        dimmingView.alpha = 0.0
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 1.0
            self.animatingView?.layer.add(animation, forKey: nil)
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        let animation = backgroundTranslateAnimation(false)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 0.0
            self.animatingView?.layer.add(animation, forKey: nil)
        }, completion: nil)
    }
    
    @objc private func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        if isShouldDismissModal {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    private func backgroundTranslateAnimation(_ forward: Bool) -> CAAnimationGroup {
        let iPad = UI_USER_INTERFACE_IDIOM() == .pad
        let translateFactor: CGFloat = iPad ? -0.08 : -0.04
        let rotateFactor: Double = iPad ? 7.5 : 15.0
        
        var t1 = CATransform3DIdentity
        t1.m34 = CGFloat(1.0 / -900)
        t1 = CATransform3DScale(t1, 0.95, 0.95, 1.0)
        t1 = CATransform3DRotate(t1, CGFloat(rotateFactor * Double.pi / 180.0), 1.0, 0.0, 0.0)
        
        var t2 = CATransform3DIdentity
        t2.m34 = t1.m34
        t2 = CATransform3DTranslate(t2, 0.0, presentedViewController.view.frame.size.height * translateFactor, 0.0)
        t2 = CATransform3DScale(t2, 0.8, 0.8, 1.0)
        
        let animation1 = CABasicAnimation(keyPath: "transform")
        animation1.toValue = NSValue(caTransform3D: t1)
        animation1.duration = animationDuration / 2
        animation1.fillMode = kCAFillModeForwards
        animation1.isRemovedOnCompletion = false
        animation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let animation2 = CABasicAnimation(keyPath: "transform")
        animation2.toValue = NSValue(caTransform3D: forward ? t2 : CATransform3DIdentity)
        animation2.beginTime = animation1.duration
        animation2.duration = animation1.duration
        animation2.fillMode = kCAFillModeForwards
        animation2.isRemovedOnCompletion = false
        
        let group = CAAnimationGroup()
        group.fillMode = kCAFillModeForwards
        group.isRemovedOnCompletion = false
        group.duration = animationDuration
        group.animations = [animation1, animation2]
        return group
    }
    
}
