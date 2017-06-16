//
//  NFCloudbookModel.h
//  yunkt
//
//  Created by guest on 17/3/14.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFCloudbookModel : NSObject
@property (nonatomic, copy) NSString *cloudbookModelId;
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *abstraction;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *solarCalendar;
@property (nonatomic, copy) NSString *lunarCalendar;
//文章内容的高度
@property (nonatomic, assign) CGFloat contentHeight;
//文章内容带有行间距的字符串
@property (nonatomic, copy) NSMutableAttributedString *contentAttriString;
@end
