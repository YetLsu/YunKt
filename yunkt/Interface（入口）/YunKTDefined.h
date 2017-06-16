//
//  YunKTDefined.h
//  yunkt
//
//  Created by guest on 17/3/7.
//  Copyright © 2017年 niefan. All rights reserved.
//

#ifndef YunKTDefined_h
#define YunKTDefined_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kRateWidth kScreenWidth/375
#define kRateHeight kScreenHeight/667

//随机色
#define kRGBAColor(r ,g ,b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//方正细圆简体
#define kFZXiYuan(s) [UIFont fontWithName:@"FZXiYuan-M01S" size:(s)]

//导航栏上移变色的距离
#define NAVBAR_CHANGE_POINT 50

//appid
#define kAppid @"1144745209"

#define kFontGrayColor8 [UIColor colorWithHexString:@"#888888"]
#define kFontGrayColor6 [UIColor colorWithHexString:@"#666666"]
#define kFontGrayColor4 [UIColor colorWithHexString:@"#444444"]
#define kFontGrayColora [UIColor colorWithHexString:@"#aaaaaa"]
//定义debug模式下的打印
#ifdef DEBUG
#define NFLog(...) NSLog(@"%s\n %@\n\n",__func__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NFLog(...)
#endif

#endif /* YunKTDefined_h */
