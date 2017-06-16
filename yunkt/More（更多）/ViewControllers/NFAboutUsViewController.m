//
//  NFAboutUsViewController.m
//  yunkt
//
//  Created by guest on 17/3/10.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFAboutUsViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface NFAboutUsViewController ()

@end

@implementation NFAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    
    [self setupContent];
}

- (void)setupNavigation{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 200, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kFontGrayColor4;
    label.text = @"关于我们";
    label.font = kFZXiYuan(18);
    self.navigationItem.titleView = label;
    
}
- (void)backAction{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupContent{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *logImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 150*kRateWidth)*0.5, 64 + 37, 150*kRateWidth, 150*kRateWidth)];
    logImageView.image = [UIImage imageNamed:@"app_logo"];
    [self.view addSubview:logImageView];
    
    UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, logImageView.bottom+34, kScreenWidth - 40, 36)];
    appNameLabel.text = @"蒲公英教育";
    appNameLabel.textColor = kFontGrayColor4;
    appNameLabel.font = kFZXiYuan(18);
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:appNameLabel];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, appNameLabel.bottom, kScreenWidth - 40, 20)];
    versionLabel.textColor = kFontGrayColor4;
    versionLabel.font = kFZXiYuan(15);
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSString *appVersion = [NFUtils getAppVersion];
    versionLabel.text = [NSString stringWithFormat:@"Version %@",version];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
    UITextView *aboutLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, versionLabel.bottom + 20, kScreenWidth - 40, kScreenHeight - versionLabel.bottom - 20)];
//    aboutLabel.numberOfLines = 0;
    aboutLabel.showsVerticalScrollIndicator = NO;
    aboutLabel.showsHorizontalScrollIndicator = NO;
    aboutLabel.editable = NO;
    aboutLabel.textColor = kFontGrayColor4;
    aboutLabel.font = kFZXiYuan(15);
    aboutLabel.text = @"一所边玩边学的大学\n\n蒲公英教育移动端是绍兴蒲公英电子商务有限公司推出的服务于电商从业者的交流学习平台。我们致力于帮助电商人一起成交、成长、成功。\n\n在这里，您可以随时查看高质量的精选资讯；\n在这里，您可以及时了解最前沿的精简快报。\n\n客服QQ：630959576\n客服电话：15258511593\n客服邮箱：gaopingping@pgy-3.cn\n\n蒲公英电子商务有限公司版权所有";
    [self.view addSubview:aboutLabel];
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
