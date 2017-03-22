//
//  HomeScrollViewController.h
//  ZhiHuNews
//
//  Created by kong on 17/3/15.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "RootViewController.h"
#import "HomeListViewController.h"
#import "HomePageDidChangeProtocol.h"

@protocol HomeScrollViewControllerDelegate <NSObject>

- (void)homePageDidScroll:(UIScrollView *)scrollView;

@end

@interface HomeScrollViewController : RootViewController<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;



//主题Arr
@property (nonatomic, strong) NSArray *themeArr;

@property (nonatomic, strong) NSMutableArray *pages;

@property (nonatomic, strong) NSMutableArray *preLoadPages;


/**
 缓存的pages
 */
@property (nonatomic, strong) NSMutableDictionary *cachePages;


@end
