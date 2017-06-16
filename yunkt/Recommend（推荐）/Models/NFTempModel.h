//
//  NFTempModel.h
//  yunkt
//
//  Created by guest on 17/3/31.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFTempModel : NSObject

@property (nonatomic, copy) NSString *tempModelId;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *abstraction;
@property (nonatomic, copy) NSString *weburl;
@property (nonatomic, copy) NSString *visitnum;
//内部图片的url
@property (nonatomic, copy) NSString *pictureurl;
//图片的高度
@property (nonatomic, assign) CGFloat pictureHeight;
//内部图片
@property (nonatomic, strong) UIImage *pictureImage;

@end
