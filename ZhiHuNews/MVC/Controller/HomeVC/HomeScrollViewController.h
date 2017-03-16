//
//  HomeScrollViewController.h
//  ZhiHuNews
//
//  Created by kong on 17/3/15.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"

@protocol HomeScrollViewControllerDelegate <NSObject>

- (void)homePageDidScroll:(UIScrollView *)scrollView;

@end

@interface HomeScrollViewController : RootViewController<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, weak) id<HomeScrollViewControllerDelegate> controllDelegate;


@end
