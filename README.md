# SemiModal

[![Build](https://img.shields.io/wercker/ci/wercker/docs.svg)]()
[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=flat)]()
[![Language](https://img.shields.io/badge/platform-Objective%20C-blue.svg?style=flat)]()
[![License](https://img.shields.io/badge/license-MIT-orange.svg?style=flat)]()

# 该项目已废弃不再维护，请移步 [`iOS-Modal`](https://github.com/xiaopin/iOS-Modal.git)

> 使用者只需关心`UIViewController+XPSemiModal.h`提供的使用方法以及`XPSemiModalConfiguration.h`所提供的定制功能即可，无需关心其他文件。如果对该功能实现有兴趣，你可自行查阅其他文件源代码。

类似淘宝添加购物车的模态视图动画

参考了[KNSemiModalViewController](https://github.com/kentnguyen/KNSemiModalViewController)的代码，但由于KNSemiModalViewController毕竟年代久远，当时还是用的addChildViewController的方式去实现的，所以现在采用iOS7提供的转场动画API以及iOS8推出的`UIPresentationController`来实现该功能。

提供Swift版本的实现，请查看[swift](https://github.com/xiaopin/SemiModal/tree/swift)分支。


## 环境要求

- iOS8.0+


## 用法

- 将`SemiModal`文件夹拖入你的项目并导入`#import "UIViewController+XPSemiModal.h"`即可

- 示例代码

1. 弹出控制器

```ObjC
UIViewController *contentViewController = [[UIViewController alloc] init];
contentViewController.view.backgroundColor = [UIColor lightGrayColor];
XPSemiModalConfiguration *config = [XPSemiModalConfiguration defaultConfiguration];
[self presentSemiModalViewController:contentViewController contentHeight:300.0 configuration:config completion:nil];
```

2. 弹出自定义视图

```ObjC
UIView *contentView = [[UIView alloc] init];
contentView.backgroundColor = [UIColor purpleColor];
XPSemiModalConfiguration *config = [XPSemiModalConfiguration defaultConfiguration];
[self presentSemiModalView:contentView contentHeight:300.0 configuration:config completion:^{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
	});
}];
```

## 演示

[![GIF](./preview.gif)]()

[![1.png](./1.png)]()

[![2.png](./2.png)]()

## 致谢

参考了[KNSemiModalViewController](https://github.com/kentnguyen/KNSemiModalViewController)的代码，感谢他们对开源社区做出的贡献。

## 协议

`SemiModal`被许可在 MIT 协议下使用。查阅`LICENSE`文件来获得更多信息。
