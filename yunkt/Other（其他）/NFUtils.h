//
//  NFUtils.h
//  yunkt
//
//  Created by guest on 17/3/9.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^DataBlock)(id responseObject);
@interface NFUtils : NSObject
@property (nonatomic, assign) DataBlock block;
/**
 * 根据字符串和行间距返回一个attributedText字符串
 */
+ (NSMutableAttributedString *)getStringWithParagraphStyleWithString:(NSString *)string lineHeight:(CGFloat)lineSpacing;

/**
 * 根据字符串和行间距返回一个attributedText字符串,并且带有首行缩紧
 */
+ (NSMutableAttributedString *)getStringWithParagraphStyleWithString:(NSString *)string lineHeight:(CGFloat)lineSpacing firstLineHeadIndent:(CGFloat)headIndent;

/**
 * 根据字符串的属性计算文字内容的高度
 */
+ (CGFloat)getHeightWithString:(NSString *)string withLineWidth:(CGFloat)width fontSize:(CGFloat)size fontColor:(UIColor *)color lineHeight:(CGFloat)height;

//根据传过来的字符串返回一个alertView
+ (UIAlertController *)createAlertViewWithMessage:(NSString *)message;


//封装网络请求get请求
+ (void)getDataWithBaseURL:(NSString *)baseUrl parameters:(NSMutableDictionary *)parameters block:(DataBlock)block;


//封装网络请求post请求
+ (void)postDataWithBaseURL:(NSString *)baseUrl parameters:(NSMutableDictionary *)parameters block:(DataBlock)block;

//封装表单上传请求
+ (void)postMutipleRequestWithBaseURL:(NSString *)baseUrl parameters:(NSDictionary *)parameters block:(DataBlock)block;

//检查电话格式是否正确
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//获取当前的版本和build号
+ (NSString *)getAppVersion;

@end
