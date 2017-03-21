//
//  HomeListViewController.h
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "RootViewController.h"
#import "HomePageDidChangeProtocol.h"

@interface HomeListViewController : RootViewController<HomePageDidChangeProtocol>

- (instancetype)initWithChannel:(NSNumber *)channel;

//主题Arr
@property (nonatomic, strong) NSArray *themeArr;

//中间的tableView
@property (nonatomic, strong) UITableView *mTableView;

//左边的tableView
@property (nonatomic, strong) UITableView *lTableView;

//右边的tabelView
@property (nonatomic, strong) UITableView *rTableView;

//设计理念为车轮模式

//中间tableView数据源
@property (nonatomic, strong) NSArray *dataArrMiddle;

//左tableView数据源
@property (nonatomic, strong) NSArray *dataArrLeft;

//右tableView数据源
@property (nonatomic, strong) NSArray *dataArrRight;

@property (nonatomic, weak) id<HomeScrollViewDelegate> scrollDelegate;

@end
