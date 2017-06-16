//
//  CenterViewController.m
//  yunkt
//
//  Created by guest on 17/3/7.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "CenterViewController.h"
#import "MainViewController.h"
#import "NFMoreViewController.h"
#import "NFFeedbackViewController.h"

@interface CenterViewController ()
//网络链接的监听
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupContent];
    
}

- (UILabel *)promptLabel{
    if (_promptLabel == nil) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-150)*0.5, (kScreenHeight-30)*0.5, 150, 40)];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.text = @"网络未连接";
        _promptLabel.backgroundColor = [UIColor darkGrayColor];
        _promptLabel.layer.cornerRadius = 5.0;
        _promptLabel.layer.masksToBounds = YES;
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.font = kFZXiYuan(17);
        
    }
    return _promptLabel;
}

- (void)setupContent{
    
    NFMoreViewController *leftVC = [[NFMoreViewController alloc] init];
    self.leftDrawerViewController = leftVC;
    self.maximumLeftDrawerWidth = kScreenWidth*0.5;
    MainViewController *mainVC = [[MainViewController alloc] init];
    self.centerViewController = mainVC;
    
    self.showsShadow = NO;
    
    self.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"networking" object:@"NO"];
                [self.view addSubview:self.promptLabel];
                
                [UIView animateWithDuration:0.5 animations:^{
                    
                    self.promptLabel.alpha = 0.6;
                } completion:^(BOOL finished) {
                    if (finished) {
                        self.promptLabel.alpha = 1;
                        [self.promptLabel removeFromSuperview];
                    }
                }];
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"networking" object:@"YES"];
            }
                break;
            default:
                break;
        }
    }];
    
    [manager startMonitoring];
    
    //判断是否需要更新
//    [self isTheNewest];

}

- (void)isTheNewest{
    NSString *appVersion = [NFUtils getAppVersion];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@",kAppid]];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *resultArray = jsonData[@"results"];
        NSDictionary *dict = resultArray[0];
        NSString *version = dict[@"version"];
        NSString *message = dict[@"releaseNotes"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![appVersion isEqualToString:version]) {
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"检测到新版本" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"马上更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",kAppid];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
                }];
                [controller addAction:action1];
                [controller addAction:action2];
                
                [self presentViewController:controller animated:YES completion:nil];
            }
        });
    }] resume];

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
