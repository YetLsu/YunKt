//
//  MainViewController.m
//  yunkt
//
//  Created by guest on 17/3/7.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "MainViewController.h"

#import "BaseNavigationController.h"
#import "NFCloudbookViewController.h"
#import "NFRecommendViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) UIButton *lastBtn;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureViewControllers];
    
    [self customView];
    
    
    
}
- (void)configureViewControllers{
    NFCloudbookViewController *cloudbookVC = [[NFCloudbookViewController alloc] init];
    NFRecommendViewController *recommendVC = [[NFRecommendViewController alloc] init];
    NSArray *vcs = @[cloudbookVC,recommendVC];
    NSMutableArray *navs = [NSMutableArray array];
    for (UIViewController *vc in vcs) {
        BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:vc];
        
        [navs addObject:navi];
    }
    self.viewControllers = navs;
}

- (void)customView{
    for (UIView *subView in self.tabBar.subviews) {
        [subView removeFromSuperview];
    }
    
    UIImageView *tabBarBGView = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
    tabBarBGView.backgroundColor = [UIColor whiteColor];
    [self.tabBar addSubview:tabBarBGView];
    
    NSArray *titles = @[@"云刊",@"精选"];
    NSArray *imageNames = @[@"icon_maxim",@"icon_article"];
    NSArray *selectedImageNames = @[@"icon_maxim_se",@"icon_article_se"];
    NSArray *hightLiaghtImageNames = selectedImageNames;
    NSInteger count = self.viewControllers.count;
    CGFloat itemW = (kScreenWidth-count+1)/count;
    
    for (int i=0; i<count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*itemW, 0, itemW, 49.f);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#444444"] forState:UIControlStateSelected];
        button.titleLabel.font = kFZXiYuan(18);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        
        [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:selectedImageNames[i]] forState:UIControlStateSelected];
        
        [button setImage:[UIImage imageNamed:hightLiaghtImageNames[i]] forState:UIControlStateHighlighted];
        
        button.tag = i;
        [button addTarget:self action:@selector(itemSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
        if(i != count - 1){
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(button.right, 12, 1, 25)];
            line.backgroundColor = [UIColor blackColor];
            [self.tabBar addSubview:line];
            
        }
        if (i==0) {
            button.selected = YES;
            _lastBtn = button;
        }
    }
}

- (void)itemSelectedAction:(UIButton *)button{
    
    _lastBtn.selected = NO;
    self.selectedIndex = button.tag;
    button.selected = YES;
    _lastBtn = button;
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
