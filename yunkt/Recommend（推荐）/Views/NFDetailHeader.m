//
//  NFDetailHeader.m
//  yunkt
//
//  Created by guest on 17/3/10.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFDetailHeader.h"

@interface NFDetailHeader ()
//@property (weak, nonatomic) IBOutlet UIImageView *readCountImageView;
//@property (weak, nonatomic) IBOutlet UIView *hidenView;
//@property (weak, nonatomic) IBOutlet UIImageView *subTitleImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *readCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *articleTextView;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

//文章的高度需要动态设置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *articleTextViewHeightConstraint;

@end


@implementation NFDetailHeader

- (void)awakeFromNib{
    [super awakeFromNib];
    _titleLabel.textColor = kFontGrayColor4;
    _timeLabel.textColor = kFontGrayColora;
    _readCountLabel.textColor = kFontGrayColora;
    _authorLabel.textColor = kFontGrayColor6;
    _articleTextView.textColor = kFontGrayColor4;
    _endLabel.textColor = kFontGrayColor4;
    _subTitleLabel.textColor = kFontGrayColora;
    
    NSString *article = @"\t愿你的城市有酒可以喝，有故事可以说。愿你的城市有酒可以喝，也愿你的余生有故事可以说。\n\t愿你的城市有酒可以喝，也愿你的。愿你的城市有酒可以喝，也愿你的余生有故事可以说。";
    NSAttributedString *attrArticle = [NFUtils getStringWithParagraphStyleWithString:article lineHeight:17];
    _articleTextView.attributedText = attrArticle;
    _articleTextView.font = kFZXiYuan(17);
    
    CGFloat height = [NFUtils getHeightWithString:article withLineWidth:kScreenWidth - 20 fontSize:17 fontColor:kFontGrayColor4 lineHeight:17];
    
    _articleTextViewHeightConstraint.constant = height;
    self.height = self.height - 200 + height;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
