//
//  HomeScrollViewController+SwitchLogic.m
//  ZhiHuNews
//
//  Created by kong on 17/3/22.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "HomeScrollViewController+SwitchLogic.h"
#import "HomeModel_Theme.h"

@implementation HomeScrollViewController (SwitchLogic)

- (void)sWitchPageWithCurrentPage:(HomeModel_Theme *)cModel
                             Left:(HomeModel_Theme *)lModel
                            Right:(HomeModel_Theme *)rModel
                     CurrentIndex:(NSInteger)index
{
    [self.pages removeAllObjects];
    
    if (lModel == nil)
    {
        //第一个页面
        //从preloadPages里面取pages
        //先从dic中取出preloadPages的下标
        //先处理当前页面 再处理右边的页面
        for (int i = 0; i < 2; i ++)
        {
            NSNumber *num = nil;
            if (i == 0)
            {
                num = cModel.id_n;
            }
            else
            {
                num = rModel.id_n;
            }
            if ([self.cachePages objectForKey:num])
            {
                NSUInteger index = [[self.cachePages objectForKey:num] integerValue];
                HomeListViewController *listvc = self.preLoadPages[index];
                [self.pages addObject:listvc];
            }
            else
            {
                //无
                HomeListViewController *listvc = [[HomeListViewController alloc] initWithChannel:num];
                [self.pages addObject:listvc];
            }
        }
        
        for (homePageProtocol vc in self.pages)
        {
            [self.view addSubview:vc.view];
            [vc.view removeFromSuperview];
            [self addChildViewController:(id)vc];
        }
        
        //移除其他多余的页面
        CGRect preloadRect = CGRectMake(0, 0, kScreenW * 2, kScreenH - 49 - 94);
        for (homePageProtocol page in self.preLoadPages)
        {
            if (!CGRectContainsPoint(preloadRect, page.view.center))
            {
                [page.view removeFromSuperview];
            }
        }
        [self addRecycleControllAt:(index+1) Channel:rModel.id_n];
        
    }
    else if (rModel == nil)
    {
        //最末页面
        for (int i = 0; i < 2; i ++)
        {
            NSNumber *num = nil;
            if (i == 0)
            {
                num = cModel.id_n;
            }
            else
            {
                num = lModel.id_n;
            }
            if ([self.cachePages objectForKey:num])
            {
                NSUInteger index = [[self.cachePages objectForKey:num] integerValue];
                HomeListViewController *listvc = self.preLoadPages[index];
                [self.pages addObject:listvc];
            }
            else
            {
                //无
                HomeListViewController *listvc = [[HomeListViewController alloc] initWithChannel:num];
                [self.pages addObject:listvc];
            }
        }
        
        for (homePageProtocol vc in self.pages)
        {
            [self.view addSubview:vc.view];
            [vc.view removeFromSuperview];
            [self addChildViewController:(id)vc];
        }
        
        //移除其他多余的页面
        CGRect preloadRect = CGRectMake(kScreenW * (index - 1), 0, kScreenW * 2, kScreenH - 49 - 94);
        for (homePageProtocol page in self.preLoadPages)
        {
            if (!CGRectContainsPoint(preloadRect, page.view.center))
            {
                [page.view removeFromSuperview];
            }
        }
        
        [self addRecycleControllAt:(index - 1) Channel:lModel.id_n];

    }
    else
    {
        for (int i = 0; i < 3; i ++)
        {
            NSNumber *num = nil;
            switch (i) {
                case 0:
                {
                    num = lModel.id_n;
                }
                    break;
                case 1:
                {
                    num = cModel.id_n;
                }
                    break;
                case 2:
                {
                    num = rModel.id_n;
                }
                    break;
                default:
                    break;
            }
        
            if ([self.cachePages objectForKey:num])
            {
                NSUInteger index = [[self.cachePages objectForKey:num] integerValue];
                HomeListViewController *listvc = self.preLoadPages[index];
                [self.pages addObject:listvc];
            }
            else
            {
                //无
                HomeListViewController *listvc = [[HomeListViewController alloc] initWithChannel:num];
                [self.pages addObject:listvc];
            }
        }
        for (homePageProtocol vc in self.pages)
        {
            [self.view addSubview:vc.view];
            [vc.view removeFromSuperview];
            [self addChildViewController:(id)vc];
        }
        //移除其他多余的页面
        CGRect preloadRect = CGRectMake(kScreenW * (index - 1), 0, kScreenW * 3, kScreenH - 49 - 94);
        for (homePageProtocol page in self.preLoadPages)
        {
            if (!CGRectContainsPoint(preloadRect, page.view.center))
            {
                [page.view removeFromSuperview];
            }
        }

        [self addRecycleControllAt:(index - 1) Channel:lModel.id_n];
        [self addRecycleControllAt:(index+1) Channel:rModel.id_n];
    }
    [self addRecycleControllAt:index Channel:cModel.id_n];
}

//- (void)loadPages:(ADDPagesMode)mode CurrentIndex:(NSInteger)currentIndex
//{
//    for (homePageProtocol vc in self.pages)
//    {
//        vc.scrollDelegate = (id<HomeScrollViewDelegate>)self.parentViewController;
//        [self.view addSubview:vc.view];
//        [vc.view removeFromSuperview];
//        [self addChildViewController:(id)vc];
//    }
//    switch (mode)
//    {
//        case ADDPagesModeLeftMost:
//        {
//            for (int i = 0; i < 2; i ++)
//            {
//                
//            }
//        }
//            break;
//        case ADDPagesModeRightMost:
//        {
//            
//        }
//            break;
//        case ADDPagesModeNormal:
//        {
//            
//        }
//            break;
//        default:
//            break;
//    }
////    for (NSInteger i = 0; i < 2; i ++)
////    {
////        [self addRecycleControllAt:i];
////    }
//}

- (homePageProtocol)recyclePages
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

- (void)addRecycleControllAt:(NSInteger)index Channel:(NSNumber *)channel
{
    homePageProtocol page = [self recyclePages];
    if (page)
    {
        [self.pages removeObject:page];
    }
    else
    {
        page = [[HomeListViewController alloc] initWithChannel:channel];
        [self addChildViewController:(id)page];
    }
    if (![self.preLoadPages containsObject:page])
    {
        [self.preLoadPages addObject:page];
    }
    NSUInteger listIndex = [self.preLoadPages indexOfObject:page];
    [self.cachePages setObject:@(listIndex) forKey:channel];
    
    page.view.frame = (CGRect){self.scrollView.width * index, 0, self.scrollView.size};
    page.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:page.view];
}



@end
