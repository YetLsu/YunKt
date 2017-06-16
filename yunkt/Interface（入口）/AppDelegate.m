//
//  AppDelegate.m
//  yunkt
//
//  Created by guest on 17/3/7.
//  Copyright © 2017年 niefan. All rights reserved.
//

#import "AppDelegate.h"
#import "CenterViewController.h"
#import "NFGuideViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    sleep(1.5);
    
    //设置社交分享
    [self setupShare];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL hasLauched = [userDefaults boolForKey:@"launched"];
    if (hasLauched == NO) {
        NFGuideViewController *guideVC = [[NFGuideViewController alloc] init];
        self.window.rootViewController = guideVC;
        [userDefaults setBool:YES forKey:@"launched"];
    }else{
        CenterViewController *center = [[CenterViewController alloc] init];
        self.window.rootViewController = center;
    }
    return YES;
}



- (void)setupShare{
    [ShareSDK registerApp:@"蒲公英教育" activePlatforms:@[
                                                     @(SSDKPlatformTypeSinaWeibo),
                                                     @(SSDKPlatformTypeCopy),
                                                     @(SSDKPlatformTypeWechat),
                                                     @(SSDKPlatformTypeQQ)
                                                     ] onImport:^(SSDKPlatformType platformType) {
                                                         switch (platformType)
                                                         {
                                                             case SSDKPlatformTypeWechat:
                                                                 [ShareSDKConnector connectWeChat:[WXApi class]];
                                                                 break;
                                                             case SSDKPlatformTypeQQ:
                                                                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                                 break;
                                                             case SSDKPlatformTypeSinaWeibo:
                                                                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                                                 break;
                                                             default:
                                                                 break;
                                                         }
                                                     } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                                         switch (platformType)
                                                         {
                                                             case SSDKPlatformTypeSinaWeibo:
                                                                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                                                 [appInfo SSDKSetupSinaWeiboByAppKey:@"3922540451"
                                                                                           appSecret:@"a46e7ec9c336d3dd994bbfc73c739ee9"
                                                                                         redirectUri:@"http://www.pgy198.com/"
                                                                                            authType:SSDKAuthTypeBoth];
                                                                 break;
                                                             case SSDKPlatformTypeWechat:
                                                                 [appInfo SSDKSetupWeChatByAppId:@"wxe994b1f3a946b209"
                                                                                       appSecret:@"c19b977a13085e5e4415d0b5ab277042"];
                                                                 break;
                                                             case SSDKPlatformTypeQQ:
                                                                 [appInfo SSDKSetupQQByAppId:@"1105985135"
                                                                                      appKey:@"rCyI0G4EwfWp0v2h"
                                                                                    authType:SSDKAuthTypeBoth];
                                                                 break;
                                                             default:
                                                                 break;
                                                         }
                                                     }];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    NSLog(@"handle  %@",url);
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
//    NSLog(@"openurl  %@",url);
    return YES;
}



@end
