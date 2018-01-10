//
//  XPSemiModalPresentationController.m
//  https://github.com/xiaopin/SemiModal.git
//
//  Created by nhope on 2018/1/10.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "XPSemiModalPresentationController.h"

@interface XPSemiModalPresentationController ()

@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *animatingView;

@end

@implementation XPSemiModalPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        _shouldDismissPopover = YES;
        
        _dimmingView = [[UIView alloc] init];
        _dimmingView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
        [_dimmingView addGestureRecognizer:tap];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIView *snapshotView = [window snapshotViewAfterScreenUpdates:YES];
        NSAssert(window, @"UIApplication.sharedApplication.keyWindow is nil");
        if (snapshotView) {
            _animatingView = snapshotView;
            [_dimmingView addSubview:snapshotView];
            snapshotView.translatesAutoresizingMaskIntoConstraints = NO;
            [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[snapshotView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(snapshotView)]];
            [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[snapshotView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(snapshotView)]];
        }
    }
    return self;
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGSize containerSize = self.containerView.bounds.size;
    CGFloat width = containerSize.width;
    CGFloat height = MIN(containerSize.height, self.presentedViewController.preferredContentSize.height);
    CGRect presentedViewFrame = CGRectMake(0.0, containerSize.height-height, width, height);
    return presentedViewFrame;
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    _dimmingView.frame = self.containerView.bounds;
    self.presentedView.frame = [self frameOfPresentedViewInContainerView];
}

- (void)presentationTransitionWillBegin {
    [super presentationTransitionWillBegin];
    [self.containerView addSubview:_dimmingView];
    CAAnimationGroup *animation = [self backgroundTranslateAnimationWithForward:YES];
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.animatingView.layer addAnimation:animation forKey:nil];
    } completion:nil];
}

- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    CAAnimationGroup *animation = [self backgroundTranslateAnimationWithForward:NO];
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.animatingView.layer addAnimation:animation forKey:nil];
    } completion:nil];
}

- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)sender {
    if (_shouldDismissPopover) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (CAAnimationGroup *)backgroundTranslateAnimationWithForward:(BOOL)forward {
    BOOL iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    CGFloat translateFactor = iPad ? -0.08 : -0.04;
    CGFloat rotateFactor = iPad ? 7.5 : 15.0;
    CGFloat scale = 0.8;
    CFTimeInterval animationDuration = 0.5;
    
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = -1.0/900.0;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1.0);
    t1 = CATransform3DRotate(t1, rotateFactor*M_PI/180.0, 1.0, 0.0, 0.0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    t2 = CATransform3DTranslate(t2, 0.0, self.presentedViewController.view.frame.size.height*translateFactor, 0.0);
    t2 = CATransform3DScale(t2, scale, scale, 1.0);

    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation1.toValue = [NSValue valueWithCATransform3D:t1];
    animation1.duration = animationDuration / 2;
    animation1.fillMode = kCAFillModeForwards;
    animation1.removedOnCompletion = NO;
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(forward ? t2 : CATransform3DIdentity)];
    animation2.beginTime = animation1.duration;
    animation2.duration = animation1.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.duration = animationDuration;
    group.animations = @[animation1, animation2];
    return group;
}

@end
