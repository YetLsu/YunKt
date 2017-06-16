//
//  NFDetailArticleViewController.m
//  yunkt
//
//  Created by guest on 17/3/10.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "NFDetailArticleViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"

#import "NFDetailHeader.h"
#import "NFDetailArticleCell.h"
#import "NFRecommendModel.h"
#import "NFWebViewCell.h"

@interface NFDetailArticleViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UIButton *maskView;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, assign) CGFloat webHeight;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) UIImageView *netImageView;

@end

static NSString *const DetailCellId = @"DetailCellId";
static NSString *const WebCellId = @"WebCellId";
@implementation NFDetailArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupNavigation];
    
    [self setupContent];
    
    [self requestData];
}

- (NSMutableArray *)datasource{
    if (_datasource == nil) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}


- (void)viewWillAppear:(BOOL)animated{
    _startTime = [NSDate date];
}

//视图结束显示的时候，将浏览时间上传到服务器，清理webcache
- (void)viewWillDisappear:(BOOL)animated{
    [self cleanWebCache];
    NSTimeInterval time = [_startTime timeIntervalSinceNow];
    double visit = time * 1000.;
    NSString *visitTime = [NSString stringWithFormat:@"%f", fabs(visit)];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    parameters[@"visitTime"] = visitTime;
    parameters[@"choicenessId"] = self.model.recommendModelId;
    [NFUtils postMutipleRequestWithBaseURL:@"http://www.sxeto.com:8808/yunketang/choiceness/savetime.do" parameters:parameters block:^(id responseObject) {
    }];
}
- (void)cleanWebCache{
    _webView = nil;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in storage.cookies) {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
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

- (void)requestData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"id"] = self.model.recommendModelId;
    parameters[@"tag"] = self.model.tag;
    [NFUtils getDataWithBaseURL:@"http://www.sxeto.com:8808/yunketang/choiceness/getchoiceness.do" parameters:parameters block:^(id responseObject) {
        NSArray *data = responseObject[@"data"];
        for (NSDictionary *dict in data) {
            NFRecommendModel *model = [NFRecommendModel mj_objectWithKeyValues:dict];
            [self.datasource addObject:model];
        }
        [self.tableView reloadData];
    }];
    
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    //先加载网页，计算网页的高度
    self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.weburl]];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    [self.webView loadRequest:self.request];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"NFDetailArticleCell" bundle:nil] forCellReuseIdentifier:DetailCellId];
    [_tableView registerNib:[UINib nibWithNibName:@"NFWebViewCell" bundle:nil] forCellReuseIdentifier:WebCellId];
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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    UIImage *gifImage = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:path]];
    _netImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 50)*0.5, (kScreenHeight-50)*0.5, 50, 50)];
    _netImageView.image = gifImage;
    _netImageView.hidden = YES;
    [self.view addSubview:_netImageView];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.netImageView.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (error) {
        self.netImageView.hidden = NO;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.netImageView.hidden = YES;
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView.height = height;
    self.webHeight = height;
    [self.tableView reloadData];
}


#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else
        return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NFWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WebCellId forIndexPath:indexPath];
        [cell.contentView addSubview:self.webView];
        return cell;
    }else{
        NFDetailArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCellId forIndexPath:indexPath];
        cell.model = self.datasource[indexPath.row];
        return cell;
    }
    
}
#pragma mark - 设置头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *secHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 36)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 36)];
        label.font = kFZXiYuan(18);
        label.text = @"相关阅读";
        label.textColor = kFontGrayColor4;
        [secHeader addSubview:label];
        return secHeader;
    }
    return nil;
}
#pragma mark - 计算组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 36;
    }else{
        return 0.0001;
    }
}
#pragma mark - 计算cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.webHeight == 0) {
            return kScreenHeight;
        }else
            return self.webHeight;
    }else
        return 115.f;
}

#pragma mark - 页面的跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NFDetailArticleViewController *detailVC = [[NFDetailArticleViewController alloc] init];
        detailVC.model = _datasource[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}


//- (void)backAction{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

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
