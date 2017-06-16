//
//  NFUtils.m
//  yunkt
//
//  Created by guest on 17/3/9.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFUtils.h"

@implementation NFUtils
+ (NSMutableAttributedString *)getStringWithParagraphStyleWithString:(NSString *)string lineHeight:(CGFloat)lineSpacing{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
//    [paragraphStyle setFirstLineHeadIndent:30];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attr;
}

+ (NSMutableAttributedString *)getStringWithParagraphStyleWithString:(NSString *)string lineHeight:(CGFloat)lineSpacing firstLineHeadIndent:(CGFloat)headIndent{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setFirstLineHeadIndent:headIndent];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attr;
}


+ (CGFloat)getHeightWithString:(NSString *)string withLineWidth:(CGFloat)width fontSize:(CGFloat)size fontColor:(UIColor *)color lineHeight:(CGFloat)height{
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    //设置行高的style
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:height];
    attributes[NSFontAttributeName] = kFZXiYuan(size);
    attributes[NSForegroundColorAttributeName] = color;
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];

    return rect.size.height;
}


+ (UIAlertController *)createAlertViewWithMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    return alert;
}

//封装网络请求get请求
+ (void)getDataWithBaseURL:(NSString *)baseUrl parameters:(NSMutableDictionary *)parameters block:(DataBlock)block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:baseUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject != nil) {
            block(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            block(nil);
        }
    }];

}


//封装网络请求post请求
+ (void)postDataWithBaseURL:(NSString *)baseUrl parameters:(NSMutableDictionary *)parameters block:(DataBlock)block{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:baseUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            block(nil);
        }
    }];

}

//封装表单上传请求
+ (void)postMutipleRequestWithBaseURL:(NSString *)baseUrl parameters:(NSDictionary *)parameters block:(DataBlock)block{
    NSArray *keys = [parameters allKeys];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:baseUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < keys.count; i++) {
            [formData appendPartWithFormData:[[parameters objectForKey:keys[i]] dataUsingEncoding:NSUTF8StringEncoding] name:keys[i]];
        }
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            block(@"error");
        }else{
            block(responseObject);
        }
    }] resume];
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10 * 中国移动：China Mobile
     11 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12 */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15 * 中国联通：China Unicom
     16 * 130,131,132,152,155,156,185,186
     17 */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20 * 中国电信：China Telecom
     21 * 133,1349,153,180,189
     22 */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25 * 大陆地区固话及小灵通
     26 * 区号：010,020,021,022,023,024,025,027,028,029
     27 * 号码：七位或八位
     28 */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//以上集合一起，并兼容14开头的
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [regextestmobile evaluateWithObject:mobileNum];
}

+ (NSString *)getAppVersion{
    //获取当前版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *ver = [infoDic objectForKey:@"CFBundleShortVersionString"];
//    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    NSString *appVersion = [NSString stringWithFormat:@"%@.%@",ver,build];
     NSString *appVersion = [NSString stringWithFormat:@"%@",ver];
    return appVersion;
}


@end
