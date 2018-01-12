//
//  XPRootViewController.m
//  Example
//
//  Created by nhope on 2018/1/10.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "XPRootViewController.h"
#import "XPContentViewController.h"
#import "UIViewController+XPSemiModal.h"

@interface XPRootViewController ()

@end

@implementation XPRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(UIButton *)sender {
    NSString *identifier = NSStringFromClass([XPContentViewController class]);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XPContentViewController *contentViewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    XPSemiModalConfiguration *config = [XPSemiModalConfiguration defaultConfiguration];
    [self presentSemiModalViewController:contentViewController contentHeight:300.0 configuration:config completion:nil];
    
    
//    UIView *contentView = [[UIView alloc] init];
//    contentView.backgroundColor = [UIColor purpleColor];
//    XPSemiModalConfiguration *config = [XPSemiModalConfiguration defaultConfiguration];
//    [self presentSemiModalView:contentView contentHeight:300.0 configuration:config completion:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
//        });
//    }];
}

@end
