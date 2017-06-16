//
//  UIBarButtonItem+Extension.h
//  yunkt
//
//  Created by guest on 17/3/16.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;


+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage title:(NSString *)title titleColor:(UIColor *)color fontSize:(CGFloat)size;
@end
