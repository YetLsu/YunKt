//
//  NFGuideViewController.m
//  yunkt
//
//  Created by guest on 17/3/13.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFGuideViewController.h"
#import "CenterViewController.h"
@interface NFGuideViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation NFGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupContent];
}
- (void)setupContent{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(kScreenWidth*3, kScreenHeight);
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    NSArray *imageNames = @[@"LP_know1",@"LP_news2",@"LP_simple3"];
    
    CGFloat btnW = 150 * kRateWidth;
    CGFloat btnH = 50 * kRateHeight;

    for (int i=0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight)];
        imageView.image = [UIImage imageNamed:imageNames[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:imageView];
        if (i == 2) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((kScreenWidth - btnW)*0.5, kScreenHeight - 100*kRateHeight - btnH, btnW, btnH);
            [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor clearColor];
            [imageView addSubview:button];
        }
    }
    [self.view addSubview:_scrollView];
    
}

- (void)click{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.rootViewController = [[CenterViewController alloc] init];
    keyWindow.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.25 animations:^{
        keyWindow.transform = CGAffineTransformIdentity;
    }];
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
