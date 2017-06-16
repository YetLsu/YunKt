//
//  NFCloudbookModel.m
//  yunkt
//
//  Created by guest on 17/3/14.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFCloudbookModel.h"

@implementation NFCloudbookModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"cloudbookModelId":@"id"};
}

- (void)setContent:(NSString *)content{
    if (_content != content) {
        _content = content;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = kFZXiYuan(17);
    dict[NSForegroundColorAttributeName] = kFontGrayColor6;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [paragraphStyle setFirstLineHeadIndent:34];
    dict[NSParagraphStyleAttributeName] = paragraphStyle;
    CGRect rect = [_content boundingRectWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    _contentHeight = rect.size.height + 120;
}
@end
