//
//  UIColor+Hex.h
//  cloudIndustry_app
//
//  Created by autonavi on 15/5/4.
//  Copyright (c) 2015年 autonavi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
