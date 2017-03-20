//
//  DetailViewController.h
//  ZhiHuNews
//
//  Created by konglee on 2017/3/17.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "RootViewController.h"

@interface DetailViewController : RootViewController


/**
 返回按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *navBackBtn;

/**
 收藏按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *favBtn;



/**
 分享按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


/**
 下一页
 */
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


- (instancetype)initWithtag:(NSNumber *)tag;




@end
