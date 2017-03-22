//
//  HomeScrollViewController+SwitchLogic.h
//  ZhiHuNews
//
//  Created by kong on 17/3/22.
//  Copyright © 2017年 陈鑫. All rights reserved.
//  逻辑处理分类

#import "HomeScrollViewController.h"

typedef NS_ENUM(NSInteger, ADDPagesMode)
{
    ADDPagesModeLeftMost = 1,   //当前页为最左边的页面
    ADDPagesModeRightMost = 2,  //当前页为最右的页面
    ADDPagesModeNormal = 3      //当前页为中间的普通页面
    
};
@class HomeModel_Theme;

/*
 1. 切换到相应标签下 从缓存数组中取相应的页面 如果没有 则New一个
 2. 当前页面 左边 右边视图都要预加载上去
 3. 若当前页面是首页 只处理右边视图
 */

@interface HomeScrollViewController (SwitchLogic)


/**
 处理切换标签逻辑

 @param cModel 当前主题Model
 @param lModel 左边主题Model
 @param rModel 右边主题Model
 @param index  当前选中页面坐标 首页index为0
 */
- (void)sWitchPageWithCurrentPage:(HomeModel_Theme *)cModel
               Left:(HomeModel_Theme *)lModel
              Right:(HomeModel_Theme *)rModel
       CurrentIndex:(NSInteger)index;

@end
