//
//  NFProtocolViewController.m
//  yunkt
//
//  Created by guest on 17/3/10.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFProtocolViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface NFProtocolViewController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation NFProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigation];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15,  15, kScreenWidth - 30, kScreenHeight - 15)];
    
    _textView.editable = NO;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_textView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:nil];
    NSString *protocolString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSAttributedString *string = [NFUtils getStringWithParagraphStyleWithString:protocolString lineHeight:6];
    _textView.attributedText = string;
    _textView.textColor = kFontGrayColor6;
    _textView.font = kFZXiYuan(15);
}

- (void)setupNavigation{
//    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) image:@"icon_back" highImage:@"icon_back" title:@"用户协议" titleColor:kFontGrayColor6 fontSize:18];
//    self.navigationItem.leftBarButtonItem = leftItem;
//    self.navigationItem.title = @"用户协议";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 200, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kFontGrayColor4;
    label.text = @"用户协议";
    label.font = kFZXiYuan(18);
    self.navigationItem.titleView = label;
}
- (void)backAction{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.navigationController popViewControllerAnimated:YES];
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
