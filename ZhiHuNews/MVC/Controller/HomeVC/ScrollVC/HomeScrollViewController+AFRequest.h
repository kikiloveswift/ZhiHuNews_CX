//
//  HomeScrollViewController+AFRequest.h
//  ZhiHuNews
//
//  Created by kong on 17/3/22.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

typedef void(^ThemeData)(id obj);

#import "HomeScrollViewController.h"

@interface HomeScrollViewController (AFRequest)

- (void)requestThemeAPI:(ThemeData)data;
@end
