//
//  RootTabBarController.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "RootTabBarController.h"
#import "RootNavigationController.h"

#import "HomeRootViewController.h"

#import "FavViewController.h"

#import "MineViewController.h"

#import "ViewController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setItems];
}

- (void)setItems
{
    HomeRootViewController *homePage = [HomeRootViewController new];
    RootNavigationController *homeNav = [[RootNavigationController alloc] initWithRootViewController:homePage];
    [self addChildVC:homeNav titile:@"首页" imageName:@"tabhome_normal" selectImg:@"tabhome_red"];
    
    ViewController *favVC = [ViewController new];
//    FavViewController *favVC = [FavViewController new];
    RootNavigationController *favNav = [[RootNavigationController alloc] initWithRootViewController:favVC];
    [self addChildVC:favNav titile:@"收藏" imageName:@"tabfav_normal" selectImg:@"tabfav_red"];
    
    MineViewController *mineVC = [MineViewController new];
    RootNavigationController *mineNav = [[RootNavigationController alloc] initWithRootViewController:mineVC];
    [self addChildVC:mineNav titile:@"我的" imageName:@"tabmine_normal" selectImg:@"tabmine_red"];
    
}

- (void)addChildVC:(UIViewController *)viewController titile:(NSString *)title imageName:(NSString *)imageName selectImg:(NSString *)selectImgName
{
    
    // 同时设置TabBar,Nav 标题
    viewController.tabBarItem.title = title;
    //设置tabBar上的文字的偏移量
    [viewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    //  设置tabbar的文字颜色 , 没有图片没有效果
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = UIColorHEX(0xFF5523,1);
    NSMutableDictionary *normalTestAtts = [NSMutableDictionary dictionary];
    normalTestAtts[NSForegroundColorAttributeName] = UIColorHEX(0x565960,1);
    [viewController.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    [viewController.tabBarItem setTitleTextAttributes:normalTestAtts forState:UIControlStateNormal];
    
    //  设置图片 , 并且不渲染
    viewController.tabBarItem.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //  设置选中图片 , 并且不渲染
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImgName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:viewController];
    
}


@end
