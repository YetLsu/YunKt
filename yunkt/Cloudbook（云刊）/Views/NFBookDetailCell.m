//
//  NFBookDetailCell.m
//  yunkt
//
//  Created by guest on 17/3/11.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFBookDetailCell.h"
#import "NFCloudbookModel.h"

@interface NFBookDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end


@implementation NFBookDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.textColor = kFontGrayColor4;
    _contentLabel.textColor = kFontGrayColor6;
    if (kScreenWidth < 375) {
        _titleLabel.font = kFZXiYuan(18);
    }else{
        _titleLabel.font = kFZXiYuan(24);
    }
}

- (void)setModel:(NFCloudbookModel *)model{
    if (_model != model) {
        _model = model;
    }
    
    _titleLabel.text = model.title;
    _contentLabel.attributedText = [NFUtils getStringWithParagraphStyleWithString:_model.content lineHeight:6 firstLineHeadIndent:34];
//    _contentLabel.text = _model.content;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
