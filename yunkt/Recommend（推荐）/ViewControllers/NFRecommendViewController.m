//
//  NFRecommendViewController.m
//  yunkt
//
//  Created by guest on 17/3/7.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFRecommendViewController.h"
#import "NFRecommendCell.h"
#import "NFDetailArticleViewController.h"
//#import "NFRecommendModel.h"
#import "NFTempModel.h"
#import "NFTempViewController.h"


//#define kRecommendUrl @"http://www.sxeto.com:8808/yunketang/choiceness/getlistchoiceness.do"

#define kTempUrl @"http://www.sxeto.com:8808/yunketang/choiceness/getlistchoicenessback.do?"


@interface NFRecommendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *promptLabel;

@end

static NSString *const NFRecommendCellId = @"NFRecommendCellId";
@implementation NFRecommendViewController
- (NSMutableArray *)datasource{
    if (_datasource == nil) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
- (UILabel *)promptLabel{
    if (_promptLabel == nil) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-150)*0.5, 64, 150, 40)];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.text = @"已经为最新文章";
        _promptLabel.backgroundColor = [UIColor darkGrayColor];
        _promptLabel.layer.cornerRadius = 5.0;
        _promptLabel.layer.masksToBounds = YES;
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.font = kFZXiYuan(17);

    }
    return _promptLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupContent];
    
    [self setupHeaderandFooter];
    
//    [self loadMoreData:self.index];
    [self requestNewData:0];
    
}

- (void)setupHeaderandFooter{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNewData:)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];

}

//- (void)requestNewData:(NSInteger)index{
//    
//    NFRecommendModel *modelFirst;
//    if (self.datasource.count > 0) {
//        modelFirst = self.datasource[0];
//    }
//    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"index"] = @(0);
//    [NFUtils getDataWithBaseURL:kRecommendUrl parameters:parameters block:^(id responseObject) {
//        if (responseObject) {
//            NSMutableArray *newArrM = [NSMutableArray array];
//            NSArray *data = responseObject[@"data"];
//            for (NSDictionary *dict in data) {
//                NFRecommendModel *model = [NFRecommendModel mj_objectWithKeyValues:dict];
//                if ([modelFirst.recommendModelId isEqualToString:model.recommendModelId]) {
//                    [self.tableView.mj_header endRefreshing];
//                    
//                    
//                    [self.view addSubview:self.promptLabel];
//                    [UIView animateWithDuration:0.3 animations:^{
//                        self.promptLabel.alpha = 0.6;
//                    } completion:^(BOOL finished) {
//                        if (finished) {
//                            self.promptLabel.alpha = 1;
//                            [self.promptLabel removeFromSuperview];
//                        }
//                    }];
//                    
//                    
//                    return;
//                }else{
//                    [newArrM addObject:model];
//                    
//                }
//            }
//            [self.datasource insertObjects:newArrM atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newArrM.count)]];
//            [self.tableView.mj_header endRefreshing];
//            [_tableView reloadData];
//        }else{
//            [self.tableView.mj_header endRefreshing];
//        }
//    }];
//}



- (void)requestNewData:(NSInteger)index{
    
    NFTempModel *modelFirst;
    if (self.datasource.count > 0) {
        modelFirst = self.datasource[0];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"index"] = @(0);
    [NFUtils getDataWithBaseURL:kTempUrl parameters:parameters block:^(id responseObject) {
        if (responseObject) {
            NSMutableArray *newArrM = [NSMutableArray array];
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *dict in data) {
                NFTempModel *model = [NFTempModel mj_objectWithKeyValues:dict];
                if ([modelFirst.tempModelId isEqualToString:model.tempModelId]) {
                    [self.tableView.mj_header endRefreshing];
                    
                    
                    [self.view addSubview:self.promptLabel];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.promptLabel.alpha = 0.6;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            self.promptLabel.alpha = 1;
                            [self.promptLabel removeFromSuperview];
                        }
                    }];
                    
                    
                    return;
                }else{
                    [newArrM addObject:model];
                    
                }
            }
            [self.datasource insertObjects:newArrM atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newArrM.count)]];
            [self.tableView.mj_header endRefreshing];
            [_tableView reloadData];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
    }];
}

//- (void)loadMoreData:(NSInteger)index{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"index"] = @(self.index);
//    [NFUtils getDataWithBaseURL:kRecommendUrl parameters:parameters block:^(id responseObject) {
//        if (responseObject) {
//            
//            NSArray *data = responseObject[@"data"];
//            if(data.count == 0){
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                return;
//            }
//            self.index += 5;
//            for (NSDictionary *dict in data) {
//                NFRecommendModel *model = [NFRecommendModel mj_objectWithKeyValues:dict];
//                [self.datasource addObject:model];
//            }
//            //            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer endRefreshing];
//            [_tableView reloadData];
//        }else{
//            //            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer endRefreshing];
//        }
//    }];
//}


- (void)loadMoreData:(NSInteger)index{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"index"] = @(self.index);
    [NFUtils getDataWithBaseURL:kTempUrl parameters:parameters block:^(id responseObject) {
        if (responseObject) {
            
            NSArray *data = responseObject[@"data"];
            if(data.count == 0){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            self.index += 5;
            for (NSDictionary *dict in data) {
                NFTempModel *model = [NFTempModel mj_objectWithKeyValues:dict];
                [self.datasource addObject:model];
            }
//            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [_tableView reloadData];
        }else{
//            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}


//废弃了
//- (void)requestData{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"index"] = @(0);
//    [NFUtils getDataWithBaseURL:kRecommendUrl parameters:parameters block:^(id responseObject) {
//        if (responseObject) {
//            self.index += 5;
//            NSArray *data = responseObject[@"data"];
//            for (NSDictionary *dict in data) {
//                NFTempModel *model = [NFTempModel mj_objectWithKeyValues:dict];
//                [self.datasource addObject:model];
//            }
//            [self.tableView.mj_header endRefreshing];
//            [_tableView reloadData];
//        }else{
//            [self.tableView.mj_header endRefreshing];
//        }
//    }];
//}

- (void)setupContent{
    self.index = 5;
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 390.f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"NFRecommendCell" bundle:nil] forCellReuseIdentifier:NFRecommendCellId];
    [self.view addSubview:_tableView];
}
#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NFRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:NFRecommendCellId forIndexPath:indexPath];
    cell.model = _datasource[indexPath.row];
    return cell;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NFDetailArticleViewController *detailVC = [[NFDetailArticleViewController alloc] init];
//    detailVC.model = _datasource[indexPath.row];
    NFTempViewController *tempVC = [[NFTempViewController alloc] init];
    tempVC.model = _datasource[indexPath.row];
    [self.navigationController pushViewController:tempVC animated:YES];
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
