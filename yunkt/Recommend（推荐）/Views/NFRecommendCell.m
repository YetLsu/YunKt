//
//  NFRecommendCell.m
//  yunkt
//
//  Created by guest on 17/3/9.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFRecommendCell.h"
//#import "NFRecommendModel.h"
#import "NFTempModel.h"

@interface NFRecommendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleLabel;
@property (weak, nonatomic) IBOutlet UILabel *readCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@end


@implementation NFRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.textColor = kFontGrayColor4;
    _articleLabel.textColor = kFontGrayColor6;
    _subTitle.textColor = kFontGrayColora;
    _readCountLabel.textColor = kFontGrayColora;
}

- (void)setModel:(NFTempModel *)model{
    if (_model != model) {
        _model = model;
    }
    
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgurl] placeholderImage:nil options:SDWebImageRetryFailed];
    _titleLabel.text = _model.title;
    NSAttributedString *string = [NFUtils getStringWithParagraphStyleWithString:_model.abstraction lineHeight:6];
    _articleLabel.attributedText = string;
    _subTitle.text = _model.tag;
    _readCountLabel.text = _model.visitnum;
}

//- (void)setModel:(NFRecommendModel *)model{
//    if (_model != model) {
//        _model = model;
//    }
//    
//    [_postImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgurl] placeholderImage:nil options:SDWebImageRetryFailed];
//    _titleLabel.text = _model.title;
//    NSAttributedString *string = [NFUtils getStringWithParagraphStyleWithString:_model.abstraction lineHeight:6];
//    _articleLabel.attributedText = string;
//    _subTitle.text = _model.tag;
//    _readCountLabel.text = _model.visitnum;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
