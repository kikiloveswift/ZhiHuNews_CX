//
//  BaseModel.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
- (id)initContentWithDic:(NSDictionary *)jsonDic
{
    self = [super init];
    if (self != nil)
    {
        if (![jsonDic isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        [self setAttributes:jsonDic];
    }
    
    return self;
}

- (void)setAttributes:(NSDictionary *)jsonDic
{
    NSDictionary *mapDic = [self attributeMapDictionary:jsonDic];
    
    for (NSString *jsonKey in mapDic)
    {

        NSString *modelAttr = [mapDic objectForKey:jsonKey];
        SEL seletor = [self stringToSel:modelAttr];
        
        if ([self respondsToSelector:seletor])
        {
            id value = [jsonDic objectForKey:jsonKey];
            
            if ([value isKindOfClass:[NSNull class]])
            {
                value = @"";
            }
            
            [self performSelector:seletor withObject:value];
        }
        
    }
}

- (SEL)stringToSel:(NSString *)attName
{
    NSString *first = [[attName substringToIndex:1] uppercaseString];
    NSString *end = [attName substringFromIndex:1];
    
    NSString *setMethod = [NSString stringWithFormat:@"set%@%@:",first,end];
    
    return NSSelectorFromString(setMethod);
}

- (NSDictionary *)attributeMapDictionary:(NSDictionary *)jsonDic
{
    
    NSMutableDictionary *mapDic = [NSMutableDictionary dictionary];
    
    for (id key in jsonDic) {
        [mapDic setObject:key forKey:key];
    }
    
    return mapDic;
}
@end
