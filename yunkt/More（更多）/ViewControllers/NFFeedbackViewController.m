//
//  NFFeedbackViewController.m
//  yunkt
//
//  Created by guest on 17/3/9.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFFeedbackViewController.h"
#import "UIViewController+MMDrawerController.h"
//#import "MBProgressHUD.h"

@interface NFFeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholederLabel;
@property (nonatomic, strong) UITextField *phoneNumTf;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation NFFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self setupContent];
}

- (void)setNavigation{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    // 设置图片
//    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
//    [btn setTitle:@"反馈" forState:UIControlStateNormal];
//    [btn setTitleColor:kFontGrayColor6 forState:UIControlStateNormal];
//    btn.titleLabel.font = kFZXiYuan(18);
//    // 设置尺寸
//    btn.size = CGSizeMake(70, 23);
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = leftItem;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 200, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kFontGrayColor4;
    label.text = @"用户反馈";
    label.font = kFZXiYuan(18);
    self.navigationItem.titleView = label;
}
- (void)backAction{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupContent{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _placeholederLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 15 + 64, kScreenWidth - 30, 30)];
    _placeholederLabel.textColor = kFontGrayColora;
    _placeholederLabel.text = @"请输入遇到的问题或建议...";
//    [self.view addSubview:_placeholederLabel];
    [_scrollView addSubview:_placeholederLabel];
    
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(21, 15 + 64, kScreenWidth - 30, 200*kRateHeight)];
    _textView.textColor = kFontGrayColora;
    _textView.font = kFZXiYuan(15);
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_textView];
    [_scrollView addSubview:_textView];
    
    
    _phoneNumTf = [[UITextField alloc] initWithFrame:CGRectMake(24, _textView.bottom+15, kScreenWidth - 30, 30)];
    _phoneNumTf.placeholder = @"请输入您的电话，便于我们联系您...";
    _phoneNumTf.textColor = kFontGrayColora;
    _phoneNumTf.font = kFZXiYuan(15);
    _phoneNumTf.delegate = self;
    _phoneNumTf.keyboardType = UIKeyboardTypeNumberPad;
//    [self.view addSubview:_phoneNumTf];
    [_scrollView addSubview:_phoneNumTf];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, _phoneNumTf.bottom + 15, kScreenWidth - 30, 45);
    [button setBackgroundImage:[UIImage imageNamed:@"submit"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"submit"] forState:UIControlStateHighlighted];
    
    button.titleLabel.font = kFZXiYuan(15);
    [button setTitleColor:kFontGrayColor6 forState:UIControlStateNormal];
    [button setTitle:@"提   交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    [_scrollView addSubview:button];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + 20);

    _hub = [[MBProgressHUD alloc] initWithView:self.view];
    _hub.dimBackground = YES;
    [self.view addSubview:_hub];
}

//提交按钮的动作
- (void)submitAction{
//    检查内容是否为空，手机号码是否为正确的格式
    if (![self check]) {
        return;
    }
    
    [_hub show:YES];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"content"] = self.textView.text;
    parameters[@"phone"] = self.phoneNumTf.text;
    __weak typeof (self) weakSelf = self;
    [NFUtils postMutipleRequestWithBaseURL:@"http://www.sxeto.com:8808/yunketang/feedback/save.do" parameters:parameters block:^(id responseObject) {
        if ((int)responseObject[@"status"] == 200) {
            [_hub setLabelText:@"反馈成功"];
            [_hub hide:YES afterDelay:0.25];
            [weakSelf backAction];
        }else{
            [_hub hide:YES afterDelay:0.25];
            [weakSelf backAction];
        }
        
    }];
}
//    检查内容是否为空，手机号码是否为正确的格式
- (BOOL)check{
    if (self.textView.text == nil || self.textView.text.length == 0) {
        UIAlertController *alert = [NFUtils createAlertViewWithMessage:@"请填入反馈内容！"];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    if (self.phoneNumTf.text.length != 0) {
        if (![NFUtils isMobileNumber:self.phoneNumTf.text]) {
            UIAlertController *alert = [NFUtils createAlertViewWithMessage:@"请填写正确的手机格式！"];
            [self presentViewController:alert animated:YES completion:nil];
            return NO;
        };
    }
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (![text isEqualToString:@""])
    {
        _placeholederLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        _placeholederLabel.hidden = NO;
    }
    return YES;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
