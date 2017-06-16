//
//  NFTempViewController.m
//  yunkt
//
//  Created by guest on 17/3/30.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFTempViewController.h"
#import "NFTempModel.h"
#import "NFTempCell.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"

@interface NFTempViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIButton *maskView;
@property (nonatomic, strong) NSDate *startTime;

@end

static NSString *const identifierId = @"identifierId";
@implementation NFTempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    
    [self setupContent];
    
    [self requestData];
}
- (void)viewWillAppear:(BOOL)animated{
    _startTime = [NSDate date];
}

//视图结束显示的时候，将浏览时间上传到服务器，清理webcache
- (void)viewWillDisappear:(BOOL)animated{
//    [self cleanWebCache];
    NSTimeInterval time = [_startTime timeIntervalSinceNow];
    double visit = time * 1000.;
    NSString *visitTime = [NSString stringWithFormat:@"%f", fabs(visit)];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    parameters[@"visitTime"] = visitTime;
    parameters[@"choicenessId"] = self.model.tempModelId;
    [NFUtils postMutipleRequestWithBaseURL:@"http://www.sxeto.com:8808/yunketang/choiceness/savetime.do" parameters:parameters block:^(id responseObject) {
    }];
}


- (NSMutableArray *)datasource{
    if (_datasource == nil) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)requestData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"id"] = self.model.tempModelId;
    parameters[@"tag"] = self.model.tag;
    [NFUtils getDataWithBaseURL:@"http://www.sxeto.com:8808/yunketang/choiceness/getchoicenessback.do" parameters:parameters block:^(id responseObject) {
        NSArray *data = responseObject[@"data"];
        for (NSDictionary *dict in data) {
            NFTempModel *model = [NFTempModel mj_objectWithKeyValues:dict];
            [self.datasource addObject:model];
        }
        [self.tableView reloadData];
    }];
    
}

- (void)setupNavigation{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 35, 35);
    [button setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareViewShowOrHidden) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    //    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

#pragma mark - 分享按钮点击
- (void)share:(UIButton *)button{
    NSInteger tag = button.tag;
    NSInteger platformType;
    switch (tag) {
        case 0:
            platformType = SSDKPlatformSubTypeWechatSession;
            break;
        case 1:
            platformType = SSDKPlatformSubTypeWechatTimeline;
            break;
        case 2:
            platformType = SSDKPlatformSubTypeQQFriend;
            break;
        case 3:
            platformType = SSDKPlatformSubTypeQZone;
            break;
        case 4:
            platformType = SSDKPlatformTypeSinaWeibo;
            break;
        case 5:
            platformType = SSDKPlatformTypeCopy;
            break;
        default:
            break;
    }
    
    //    UIImage *image = [UIImage imageNamed:@"b1_img"];
    NSArray *images = @[_model.imgurl];
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSURL *shareUrl = [NSURL URLWithString:self.model.weburl];
    [shareParams SSDKSetupShareParamsByText:_model.abstraction
                                     images:images //传入要分享的图片
                                        url:shareUrl
                                      title:_model.title
                                       type:SSDKContentTypeWebPage];
    //有的平台要客户端分享需要加此方法，例如微博
    [shareParams SSDKEnableUseClientShare];
    __weak typeof (self)weakSelf = self;
    [ShareSDK share:platformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                if (platformType == SSDKPlatformTypeCopy) {
                    UIAlertController *controller = [NFUtils createAlertViewWithMessage:@"链接复制成功"];
                    [weakSelf presentViewController:controller animated:YES completion:nil];
                }else{
                    UIAlertController *controller = [NFUtils createAlertViewWithMessage:@"分享成功"];
                    [weakSelf presentViewController:controller animated:YES completion:nil];
                }
                break;
            }
            case SSDKResponseStateFail:
            {
                
                if (((platformType == SSDKPlatformSubTypeQQFriend) || (platformType == SSDKPlatformSubTypeQZone)) && ![QQApiInterface isQQInstalled]) {
                    UIAlertController *controller = [NFUtils createAlertViewWithMessage:@"未安装QQ"];
                    [weakSelf presentViewController:controller animated:YES completion:nil];
                    break;
                    
                }
                if(((platformType == SSDKPlatformSubTypeWechatSession)||(platformType == SSDKPlatformSubTypeWechatTimeline))&& ![WXApi isWXAppInstalled]){
                    UIAlertController *controller = [NFUtils createAlertViewWithMessage:@"未安装微信"];
                    [weakSelf presentViewController:controller animated:YES completion:nil];
                    break;
                }
                
                UIAlertController *controller = [NFUtils createAlertViewWithMessage:@"分享失败"];
                [weakSelf presentViewController:controller animated:YES completion:nil];
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark - 分享视图的显示和隐藏
- (void)shareViewShowOrHidden{
    if (_maskView.hidden) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect = _shareView.frame;
            rect.origin = CGPointMake(0, kScreenHeight-170*kRateHeight);
            _shareView.frame = rect;
            _maskView.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect = _shareView.frame;
            rect.origin = CGPointMake(0, kScreenHeight);
            _shareView.frame = rect;
            _maskView.hidden = YES;
        }];
    }
    
}


- (void)setupContent{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _model.pictureHeight + 70)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, kScreenWidth, 60)];
    title.numberOfLines = 0;
    title.text = _model.title;
    title.font = kFZXiYuan(20);
    title.textColor = kFontGrayColor4;
//    title.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview: title];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, title.bottom, kScreenWidth, _model.pictureHeight)];
    imageView.image = _model.pictureImage;
    [headerView addSubview:imageView];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.tableHeaderView = headerView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 115.f;
    [_tableView registerNib:[UINib nibWithNibName:@"NFTempCell" bundle:nil] forCellReuseIdentifier:identifierId];
    [self.view addSubview:_tableView];
    
    _maskView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.6;
    _maskView.hidden = YES;
    [_maskView addTarget:self action:@selector(shareViewShowOrHidden) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_maskView];
    
    _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 170*kRateHeight)];
    _shareView.backgroundColor = [UIColor whiteColor];
    CGFloat topMargin = 32.5 * kRateHeight;
    CGFloat rightMargin = 10 * kRateWidth;
    CGFloat btnW = 50 * kRateWidth;
    NSArray *imageArray = @[@"icon_wechat",@"icon_circle",@"icon_QQ",@"icon_zone",@"icon_weibo",@"icon_link"];
    for (int i=0; i<6; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(rightMargin +(btnW + rightMargin)*i, topMargin, btnW, btnW);
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:button];
    }
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(0, _shareView.height - 36 - 10, kScreenWidth, 36);
    [cancleButton setTitleColor:kFontGrayColor4 forState:UIControlStateNormal];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = kFZXiYuan(18);
    [cancleButton addTarget:self action:@selector(shareViewShowOrHidden) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:cancleButton];
    [self.view addSubview:_shareView];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
//    UIImage *gifImage = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:path]];
//    _netImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 50)*0.5, (kScreenHeight-50)*0.5, 50, 50)];
//    _netImageView.image = gifImage;
//    _netImageView.hidden = YES;
//    [self.view addSubview:_netImageView];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NFTempCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierId forIndexPath:indexPath];
    cell.model = _datasource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *secHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 36)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 36)];
    label.font = kFZXiYuan(18);
    label.text = @"相关阅读";
    label.textColor = kFontGrayColor4;
    [secHeader addSubview:label];
    return secHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NFTempViewController *detailVC = [[NFTempViewController alloc] init];
    detailVC.model = _datasource[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];

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
