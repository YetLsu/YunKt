//
//  NFLoginViewController.m
//  yunkt
//
//  Created by guest on 17/4/1.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFLoginViewController.h"

@interface NFLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwdTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) MBProgressHUD *hub;
@end

@implementation NFLoginViewController

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    _loginBtn.layer.borderWidth = 1;
    _loginBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _loginBtn.layer.cornerRadius = 5;
    _loginBtn.layer.masksToBounds = YES;
    _phoneTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    
    _hub = [[MBProgressHUD alloc] initWithView:self.view];
    _hub.dimBackground = YES;
    [self.view addSubview:_hub];
    
}
//登录按钮
- (IBAction)loginAction:(UIButton *)sender {
    if ([self check]) {
        [_hub show:YES];
        [_hub hide:YES afterDelay:2.5];
        [[NSUserDefaults standardUserDefaults] setObject:_phoneTF.text forKey:@"phone"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)check{
    if (_phoneTF.text.length == 0 || _passwdTF.text.length == 0) {
        UIAlertController *controller = [NFUtils createAlertViewWithMessage:@"手机号或密码不能为空"];
        [self presentViewController:controller animated:YES completion:nil];
        return NO;
    }
    if (![NFUtils isMobileNumber:_phoneTF.text]) {
        UIAlertController *controller = [NFUtils createAlertViewWithMessage:@"请输入正确的手机格式"];
        [self presentViewController:controller animated:YES completion:nil];
        return NO;
    }
    

    return YES;
}



- (void)setupNavigation{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 40)];
    titleLabel.text = @"用户登录";
    titleLabel.font = kFZXiYuan(20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = kFontGrayColor6;
    self.navigationItem.titleView = titleLabel;
    
    
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
