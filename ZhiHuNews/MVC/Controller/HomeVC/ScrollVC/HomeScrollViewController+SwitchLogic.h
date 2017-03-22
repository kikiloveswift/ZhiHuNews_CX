//
//  HomeScrollViewController+SwitchLogic.h
//  ZhiHuNews
//
//  Created by kong on 17/3/22.
//  Copyright © 2017年 陈鑫. All rights reserved.
//  逻辑处理分类

#import "HomeScrollViewController.h"
@class HomeModel_Theme;

/*
 1. 切换到相应标签下 从缓存数组中取相应的页面 如果没有 则New一个
 2. 当前页面 左边 右边视图都要预加载上去
 3. 若当前页面是首页 只处理右边视图
 */

@interface HomeScrollViewController (SwitchLogic)


/**
 处理切换标签逻辑

 @param cModle 当前主题Model
 @param lModel 左边主题Model
 @param rModel 右边主题Model
 @param index  当前选中页面坐标 首页index为0
 */
- (void)sWitchPageWithCurrentPage:(HomeModel_Theme *)cModle
               Left:(HomeModel_Theme *)lModel
              Right:(HomeModel_Theme *)rModel
       CurrentIndex:(NSInteger)index;

@end
