//
//  NFBaseViewController.m
//  yunkt
//
//  Created by guest on 17/3/7.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFBaseViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface NFBaseViewController ()

@end

@implementation NFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
}
- (void)setupNavigation{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(0, 0, 40, 25);
    [button setImage:[UIImage imageNamed:@"icon_index"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setViewShow) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    titleLabel.text = @"蒲公英教育";
    titleLabel.font = kFZXiYuan(20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = kFontGrayColor6;
    self.navigationItem.titleView = titleLabel;
    
}

- (void)setViewShow{
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
