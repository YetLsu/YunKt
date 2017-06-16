//
//  NFDetailArticleCell.m
//  yunkt
//
//  Created by guest on 17/3/10.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFDetailArticleCell.h"
#import "NFRecommendModel.h"
@interface NFDetailArticleCell ()
@property (weak, nonatomic) IBOutlet UILabel *shortArticleLabel;
@property (weak, nonatomic) IBOutlet UILabel *readCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation NFDetailArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.textColor = kFontGrayColor4;
    _shortArticleLabel.textColor = kFontGrayColor8;
    _readCountLabel.textColor = kFontGrayColora;
}

- (void)setModel:(NFRecommendModel *)model{
    if (_model != model) {
        _model = model;
    }
    [_detailImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgurl] placeholderImage:nil options:SDWebImageRetryFailed];
    _titleLabel.text = _model.title;
    _shortArticleLabel.text = _model.abstraction;
    _readCountLabel.text = _model.visitnum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
