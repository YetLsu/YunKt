//
//  NFCloudbookCell.h
//  yunkt
//
//  Created by guest on 17/3/11.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NFCloudbookCell,NFCloudbookModel;
@protocol NFCloudbookCellDelegate <NSObject>
     
- (void)cell:(NFCloudbookCell *)cell withModel:(NFCloudbookModel *)model;

@end

@interface NFCloudbookCell : UICollectionViewCell

@property (nonatomic, assign) id<NFCloudbookCellDelegate> delegate;
@property (nonatomic, strong) NFCloudbookModel *model;

@end
