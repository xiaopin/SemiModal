//
//  SemiModalAnimatedTransitioning.m
//  https://github.com/xiaopin/SemiModal.git
//
//  Created by nhope on 2018/1/10.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "XPSemiModalAnimatedTransitioning.h"

@implementation XPSemiModalAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    BOOL isPresentation = [self isPresentation];

    if (isPresentation) {
        [transitionContext.containerView addSubview:toView];
        // Add shadow effect.
        toView.layer.shadowColor = [[UIColor blackColor] CGColor];
        toView.layer.shadowOffset = CGSizeMake(0.0, -3.0);
        toView.layer.shadowRadius = 5.0;
        toView.layer.shadowOpacity = 0.8;
        toView.layer.shouldRasterize = YES;
        toView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    }
    UIViewController *animatingVC = isPresentation ? toVC : fromVC;
    CGRect finalFrame = [transitionContext finalFrameForViewController:animatingVC];
    animatingVC.view.frame = isPresentation ? CGRectOffset(finalFrame, 0.0, finalFrame.size.height) : finalFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGRect targetFrame = self.presentation ? finalFrame : CGRectOffset(finalFrame, 0.0, finalFrame.size.height);
        animatingVC.view.frame = targetFrame;
    } completion:^(BOOL finished) {
        if (!self.presentation) {
            [fromView removeFromSuperview];
        }
        [transitionContext completeTransition:YES];
    }];
}

@end
