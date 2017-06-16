//
//  NFMoreViewController.m
//  yunkt
//
//  Created by guest on 17/3/7.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFMoreViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "NFFeedbackViewController.h"
#import "MainViewController.h"
#import "NFAboutUsViewController.h"
#import "NFProtocolViewController.h"
#import "NFLoginViewController.h"
#import "SDImageCache.h"

@interface NFMoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UILabel *cleanSuccLabel;
@end

static NSString *const NFMoreCellId = @"NFMoreCellId";
@implementation NFMoreViewController

- (UILabel *)cleanSuccLabel{
    if (_cleanSuccLabel == nil) {
        _cleanSuccLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-140)*0.5, (kScreenHeight-40)*0.5, 140, 40)];
        _cleanSuccLabel.text = @"清理成功";
        _cleanSuccLabel.backgroundColor = [UIColor darkGrayColor];
        _cleanSuccLabel.textColor = [UIColor whiteColor];
        _cleanSuccLabel.textAlignment = NSTextAlignmentCenter;
        _cleanSuccLabel.font = kFZXiYuan(17);
        _cleanSuccLabel.layer.cornerRadius = 5;
        _cleanSuccLabel.layer.masksToBounds = YES;
        
    }
    return _cleanSuccLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageArray = @[@"index_login",@"icon_feedback",@"icon_about",@"icon_agree",@"icon_clean"];
    _titleArray = @[@"用户登录",@"意见反馈",@"关于我们",@"用户协议",@"清理缓存"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NFMoreCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NFMoreCellId];
        cell.textLabel.font = kFZXiYuan(16);
        cell.textLabel.textColor = kFontGrayColor6;
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
            NFLoginViewController *loginVC = [[NFLoginViewController alloc] initWithNibName:@"NFLoginViewController" bundle:nil];
            [[self getNavigationController] pushViewController:loginVC animated:YES];
        }];
        
    }else if (indexPath.row == 1) {
        
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
            NFFeedbackViewController *feedbackVC = [[NFFeedbackViewController alloc] init];
            [[self getNavigationController] pushViewController:feedbackVC animated:YES];
        }];

    }else if (indexPath.row == 2){
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
            NFAboutUsViewController *aboutVC = [[NFAboutUsViewController alloc] init];
            [[self getNavigationController] pushViewController:aboutVC animated:YES];
        }];

    }else if (indexPath.row == 3){
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
            NFProtocolViewController *protocolVC = [[NFProtocolViewController alloc] init];
            [[self getNavigationController] pushViewController:protocolVC animated:YES];
        }];

    
    }else{
        [[SDImageCache sharedImageCache] clearDisk];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.cleanSuccLabel];
        [UIView animateWithDuration:0.5 animations:^{
            self.cleanSuccLabel.alpha = 0.6;
        } completion:^(BOOL finished) {
            self.cleanSuccLabel.alpha = 1;
            [self.cleanSuccLabel removeFromSuperview];
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {}];
        }];
        
        
    }

}

- (UINavigationController *)getNavigationController{
    MainViewController *center = (MainViewController *)self.mm_drawerController.centerViewController;
    //获取tabBarController选中的是哪个
    NSInteger i = center.selectedIndex;
    return center.childViewControllers[i];
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
