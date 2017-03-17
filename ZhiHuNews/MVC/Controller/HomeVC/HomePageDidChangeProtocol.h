//
//  HomePageDidChangeProtocol.h
//  ZhiHuNews
//
//  Created by kong on 17/3/15.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HomeScrollViewDelegate <NSObject>

- (void)homeScrollViewDidStartScroll:(UIScrollView *)scrollView;

- (void)homeScrollViewDidEndScroll:(UIScrollView *)scrollView;

@end

@protocol HomePageDidChangeProtocol <NSObject>

@property (nonatomic, weak) id<HomeScrollViewDelegate> scrollDelegate;


/**
 控制器的HomeVC的View
 */
@property (nonatomic, readonly) UIView *view;


@end

typedef id<HomePageDidChangeProtocol> homePageProtocol;
