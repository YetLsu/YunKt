//
//  NFTempModel.m
//  yunkt
//
//  Created by guest on 17/3/31.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFTempModel.h"

@implementation NFTempModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"tempModelId":@"id"};
}

- (void)setPictureurl:(NSString *)pictureurl{
    if (_pictureurl != pictureurl) {
        _pictureurl = pictureurl;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_pictureurl]];
        _pictureImage = [UIImage imageWithData:imageData];
        _pictureHeight = _pictureImage.size.height*0.5;
    });
    
    
    
}
@end
