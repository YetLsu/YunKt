//
//  NFCloudbookViewController.m
//  yunkt
//
//  Created by guest on 17/3/7.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFCloudbookViewController.h"
#import "NFBookDetailViewController.h"
#import "NFCloudbookCell.h"
#import "NFCloudbookModel.h"

#define kCloudbookUrl @"http://www.sxeto.com:8808/yunketang/periodical/getlistperiodical.do"

@interface NFCloudbookViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NFCloudbookCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datasource;

//是否有网
@property (nonatomic, assign) BOOL hasNet;

@property (nonatomic, strong) UIView *noNetView;
//网络提示的标签
//@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) UIImageView *netImageView;

@end
static NSString *const CloudbookCellId = @"CloudbookCellId";
@implementation NFCloudbookViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChange:) name:@"networking" object:nil];
    
    [self setupGestureRecognizer];
}

//- (UILabel *)promptLabel{
//    if (_promptLabel == nil) {
//        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-150)*0.5, (kScreenHeight-30)*0.5, 150, 40)];
//        _promptLabel.textAlignment = NSTextAlignmentCenter;
//        _promptLabel.text = @"网络未连接";
//        _promptLabel.backgroundColor = [UIColor darkGrayColor];
//        _promptLabel.layer.cornerRadius = 5.0;
//        _promptLabel.layer.masksToBounds = YES;
//        _promptLabel.textColor = [UIColor whiteColor];
//        _promptLabel.font = kFZXiYuan(17);
//        
//    }
//    return _promptLabel;
//}


- (UIView *)noNetView{
    if (_noNetView == nil) {
        _noNetView = [[UIView alloc] initWithFrame:self.view.bounds];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-200)*0.5, (kScreenHeight-50)*0.5, 200, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"网络走丢了";
        label.textColor = kFontGrayColor4;
        label.font = kFZXiYuan(20);
        
        [_noNetView addSubview:label];
    }
    return _noNetView;
}
- (void)netChange:(NSNotification *)notification{
    _hasNet = [[notification object] boolValue];
    
    if (_hasNet == NO && _collectionView == nil) {
        [self.view addSubview:self.noNetView];
    }
    if (_hasNet == YES && _datasource.count == 0) {
        
        [self.noNetView removeFromSuperview];
        [self setupContent];
        [self requestData];
    }
}

- (NSMutableArray *)datasource{
    if (_datasource == nil) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)setupGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];

}


#pragma mark - 请求数据
- (void)requestData{
    [NFUtils getDataWithBaseURL:kCloudbookUrl parameters:nil block:^(id responseObject) {
        if (responseObject != nil) {
            
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *dict in data) {
                NFCloudbookModel *model = [NFCloudbookModel mj_objectWithKeyValues:dict];
                [self.datasource addObject:model];
            }
            _netImageView.hidden = YES;
            [_collectionView reloadData];
        }else{
            _netImageView.hidden = YES;
        }
    }];

}

- (void)setupContent{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - 49);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 49) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"NFCloudbookCell" bundle:nil] forCellWithReuseIdentifier:CloudbookCellId];
    [self.view addSubview:_collectionView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    UIImage *gifImage = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:path]];
    _netImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 50)*0.5, (kScreenHeight-50)*0.5, 50, 50)];
    _netImageView.image = gifImage;
    [self.view addSubview:_netImageView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NFCloudbookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CloudbookCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    cell.model = _datasource[indexPath.row];
    return cell;
}




- (void)tapAction:(UITapGestureRecognizer *)tap{
     self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
}


- (void)cell:(NFCloudbookCell *)cell withModel:(NFCloudbookModel *)model{
    NFBookDetailViewController *bookDetailVC = [[NFBookDetailViewController alloc] init];
    bookDetailVC.model = model;
    [self.navigationController pushViewController:bookDetailVC animated:YES];
    
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
