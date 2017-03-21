//
//  defineHeader.h
//  ZhiHuNews
//
//  Created by konglee on 2017/3/7.
//  Copyright © 2017年 陈鑫. All rights reserved.
//#CE413A

#ifndef defineHeader_h
#define defineHeader_h

#define KURL @"http://news-at.zhihu.com"

#define kScreenW [UIScreen mainScreen].bounds.size.width

#define kScreenH [UIScreen mainScreen].bounds.size.height

//是否是Debug模式
#define isDebug 1

//当前抓包ip
#define KHost @"customUserip"

//当前抓包端口
#define KPort @"customUserPort"

#ifdef DEBUG
#define NSLog(fmt, ...) printf("\n[%s]\n %s\n [第%d行]\n [输出:]\n %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:fmt, ## __VA_ARGS__] UTF8String]);
#else
# define NSLog(...);
#endif

//16进制色值
#define UIColorHEX(rgbValue,f) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:f]

//RGB色值
#define UIColorRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]

#define padding 20
#define itemPerLine 4
#define kItemW (kScreenW-padding*(itemPerLine+1))/itemPerLine
#define kItemH 25


#define kUUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

#define WeChatAPPID @"wx0cc7de55902ced91"

#define WeboAPPKEY @"3325013476"

#define WeboAPPSecret @"f8d25c80a96e17f7f18b69788fb61b3c"


#endif 
