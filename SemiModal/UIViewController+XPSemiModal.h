//
//  UIViewController+XPSemiModal.h
//  https://github.com/xiaopin/SemiModal.git
//
//  Created by nhope on 2018/1/10.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (XPSemiModal)

// 仅限内部使用(请直接无视该属性😊)
@property (nonatomic, strong) id<UIViewControllerTransitioningDelegate> strongSemiModalTransitioningDelegate;


/**
 显示一个从底部弹起的半模态视图控制器

 @param contentViewController   模态视图控制器
 @param contentHeight           模态视图高度
 @param shouldDismissPopover    点击模态视图之外的区域是否关闭模态窗口
 @param completion              模态窗口显示完毕时的回调
 */
- (void)presentSemiModalViewController:(UIViewController *)contentViewController contentHeight:(CGFloat)contentHeight shouldDismissPopover:(BOOL)shouldDismissPopover completion:(void (^)(void))completion NS_AVAILABLE_IOS(8_0);


/**
 显示一个从底部弹起的半模态视图
 
 内部会创建一个UIViewController并将contentView添加到该控制器的view上,并添加`距离父视图上下左右均为0`的约束.
 如果需要手动关闭模态窗口,则`谁弹出谁负责关闭`,即`[self.presentedViewController dismissViewControllerAnimated:YES completion:nil]`

 @param contentView             模态内容视图
 @param contentHeight           模态视图高度
 @param shouldDismissPopover    点击模态视图之外的区域是否关闭模态窗口
 @param completion              模态窗口显示完毕时的回调
 */
- (void)presentSemiModalView:(UIView *)contentView contentHeight:(CGFloat)contentHeight shouldDismissPopover:(BOOL)shouldDismissPopover completion:(void (^)(void))completion NS_AVAILABLE_IOS(8_0);

@end
