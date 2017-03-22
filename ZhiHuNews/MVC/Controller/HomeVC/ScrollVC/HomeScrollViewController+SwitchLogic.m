//
//  HomeScrollViewController+SwitchLogic.m
//  ZhiHuNews
//
//  Created by kong on 17/3/22.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "HomeScrollViewController+SwitchLogic.h"

@implementation HomeScrollViewController (SwitchLogic)

- (void)sWitchPageWithCurrentPage:(HomeModel_Theme *)cModle
                             Left:(HomeModel_Theme *)lModel
                            Right:(HomeModel_Theme *)rModel
                     CurrentIndex:(NSInteger)index
{
    if (lModel == nil)
    {
        //第一页面
        
    }
    else if (rModel == nil)
    {
        //最末页面
    }
    else
    {
        
    }
    
}

- (void)loadPages
{
    for (homePageProtocol vc in self.pages)
    {
        vc.scrollDelegate = (id<HomeScrollViewDelegate>)self.parentViewController;
        [self.view addSubview:vc.view];
        [vc.view removeFromSuperview];
        [self addChildViewController:(id)vc];
    }
    for (NSInteger i = 0; i < 2; i ++)
    {
        [self addControllAt:i];
    }
}

- (homePageProtocol)recyclePage
{
    for (id page in self.pages)
    {
        if ([page isKindOfClass:[HomeListViewController class]])
        {
            return page;
        }
    }
    return nil;
}

- (void)addControllAt:(NSInteger)index
{
    homePageProtocol page = [self recyclePage];
    if (page)
    {
        [self.pages removeObject:page];
    }
    else
    {
        page = [[HomeListViewController alloc] init];
        [self addChildViewController:(id)page];
    }
    
    page.view.frame = (CGRect){self.scrollView.width * index, 0, self.scrollView.size};
    page.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:page.view];
}



@end
