//
//  AFRequest.h
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^finishSuccessBlock)(id result);

typedef void(^progressBlock)(NSProgress *progress);

typedef void(^finishFalureBlock)(id result);

typedef void(^checkProxyBlock) (NSDictionary *mDic);

@interface AFRequest : NSObject

+ (void)requestDataWithUrlString:(NSString *)URLString
                                        Parameters:(NSDictionary *)dic
                                            Method:(NSString *)string
                                             Proxy:(checkProxyBlock)proxyBlock
                                           Success:(finishSuccessBlock)successBlock
                                          Progress:(progressBlock)progressBlock
                                           Failure:(finishFalureBlock)failureBlock;

@end
