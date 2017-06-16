//
//  NFBookDetailViewController.m
//  yunkt
//
//  Created by guest on 17/3/11.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFBookDetailViewController.h"
#import "NFBookDetailCell.h"
#import "NFCloudbookModel.h"

@interface NFBookDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end
static NSString *const BookDetailCellId = @"BookDetailCellId";
@implementation NFBookDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

//滚动的时候，动态的改变透明视图的不透明度
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
        UIColor * color = [UIColor whiteColor];
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > NAVBAR_CHANGE_POINT) {
            CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupContent];
    
}




- (void)setupContent{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 260*kRateHeight)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.imgurl] placeholderImage:nil options:SDWebImageRetryFailed];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = imageView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"NFBookDetailCell" bundle:nil] forCellReuseIdentifier:BookDetailCellId];
    [self.view addSubview:_tableView];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NFBookDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:BookDetailCellId forIndexPath:indexPath];
    cell.model = self.model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _model.contentHeight;
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
