//
//  AFRequest.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "AFRequest.h"
#import <CFNetwork/CFNetwork.h>
#import "AFNetworking.h"

@implementation AFRequest

+ (void)requestDataWithUrlString:(NSString *)URLString
                      Parameters:(NSDictionary *)dic
                          Method:(NSString *)string
                           Proxy:(checkProxyBlock)proxyBlock
                         Success:(finishSuccessBlock)successBlock
                        Progress:(progressBlock)progressBlock
                         Failure:(finishFalureBlock)failureBlock
{
    NSDictionary *proxyDic = (isDebug == 1) ? nil : [AFRequest checkUseProxyWith:[NSURL URLWithString:URLString]];
    
    if (proxyDic != nil)
    {
        //TODO: 弹窗提醒使用端口和IP进行非法抓包
        if (proxyBlock) {
            
            proxyBlock(proxyDic);
        }
        return;
    }
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manger.requestSerializer setValue:@"Bearer YEFK46a1Qe2PK8JbTx_CTA" forHTTPHeaderField:@"Authorization"];
    [manger.requestSerializer setValue:@"com.zhihu.daily" forHTTPHeaderField:@"X-Bundle-ID"];
//    [manger.requestSerializer setValue:kUUID forHTTPHeaderField:@"X-UUID"];
    if ([string isEqualToString:@"GET"])
    {
        [manger GET:URLString parameters:dic success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSDictionary *jsonDic = [JSONData dicWithJsonString:responseObject];
            if (successBlock)
            {
                successBlock(jsonDic);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error)
        {
            if (failureBlock)
            {
                failureBlock(nil);
            }
        }];
    }
    else if ([string isEqualToString:@"POST"])
    {
        [manger POST:URLString parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *jsonDic = [JSONData dicWithJsonString:responseObject];
            if (successBlock)
            {
                successBlock(jsonDic);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failureBlock)
            {
                failureBlock(nil);
            }
        }];
    }
}


/**
 *  检测是否使用抓包工具
 *
 *  @param url 请求URL
 *
 *  @return 返回代理服务器地址和端口号
 */
+ (NSDictionary *)checkUseProxyWith:(NSURL *)url{
    
    NSDictionary *proxySetting = (__bridge NSDictionary *)CFNetworkCopySystemProxySettings();
    
    NSArray *proxies = (__bridge NSArray*)CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)(url), (__bridge CFDictionaryRef _Nonnull)(proxySetting));
    
    NSDictionary *dic = proxies[0];
    
    if ((__bridge CFStringRef)[dic objectForKey:(NSString *)kCFProxyTypeKey] == kCFProxyTypeNone)
    {
        return nil;
        
    }else if ((__bridge CFStringRef)[dic objectForKey:(NSString *)kCFProxyTypeKey] != nil){
        
        NSMutableDictionary *proxyDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [proxyDic setObject:(__bridge id _Nonnull)((__bridge CFStringRef)[dic objectForKey:(NSString *)kCFProxyHostNameKey]) forKey:KHost];
        
        [proxyDic setObject:(__bridge id _Nonnull)((__bridge CFStringRef)[dic objectForKey:(NSString *)kCFProxyPortNumberKey]) forKey:KPort];
        
        return proxyDic;
    }
    return nil;
}


@end
