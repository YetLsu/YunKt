//
//  NFCloudbookCell.m
//  yunkt
//
//  Created by guest on 17/3/11.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFCloudbookCell.h"
#import "NFCloudbookModel.h"

@interface NFCloudbookCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postImageConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelConstraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authorLabelConstraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textConstraintBottom;

@property (weak, nonatomic) IBOutlet UILabel *solarTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lunarTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *articleTextView;
@property (weak, nonatomic) IBOutlet UIButton *moreDetailButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBtnHeightConstraint;


@end

@implementation NFCloudbookCell
- (IBAction)lookForDetail:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cell:withModel:)]) {
        [self.delegate performSelector:@selector(cell:withModel:) withObject:self withObject:self.model];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _postImageConstraintHeight.constant *= kRateHeight;
    _titleLabelConstraintTop.constant *= kRateHeight;
    _authorLabelConstraintTop.constant *= kRateHeight;
    _textConstraintBottom.constant *= kRateHeight;
    _moreBtnHeightConstraint.constant *= kRateHeight;
    _solarTimeLabel.textColor = kFontGrayColor8;
    _lunarTimeLabel.textColor = kFontGrayColora;
    _titleLabel.textColor = kFontGrayColor4;
    _authorLabel.textColor = kFontGrayColora;
    _articleTextView.textColor = kFontGrayColor4;
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
    _solarTimeLabel.text = _model.solarCalendar;
    _lunarTimeLabel.text = _model.lunarCalendar;
    _titleLabel.text = _model.title;
    _authorLabel.text = [NSString stringWithFormat:@"作者:%@",_model.author];
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgurl] placeholderImage:nil options:SDWebImageRetryFailed];
    
     _articleTextView.attributedText = [NFUtils getStringWithParagraphStyleWithString:_model.abstraction lineHeight:6 firstLineHeadIndent:30];
    _articleTextView.font = kFZXiYuan(15);
    _articleTextView.textColor = kFontGrayColor4;
    if (_model.content == nil || _model.content.length == 0) {
        _moreDetailButton.hidden = YES;
    }else{
        _moreDetailButton.hidden = NO;
    }
}


@end
