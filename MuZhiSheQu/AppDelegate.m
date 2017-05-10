//
//  AppDelegate.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ShangJiaViewController.h"
#import "CenterViewController.h"
#import "GongGaoQiangViewController.h"
#import "GeRenZhongXinViewController.h"
#import "ChooseQuViewController.h"
#import "LoginViewController.h"
#import "GuideViewController.h"
#import "TelPhoneViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIImage+Helper.h"
#import "RCDChatListViewController.h"
#import "WuYeZhongXinViewController.h"
#import "BreakInfoViewController.h"
#import "ShopInfoViewController.h"
#import "GanXiShopViewController.h"
#import "GouWuCheViewController.h"
#import "UmengCollection.h"//友盟统计

#import "SuperViewController.h"

#import <ShareSDK/ShareSDK.h>
//#import <ShareSDK/ShareSDK.h>---
//#import <ShareSDKConnector/ShareSDKConnector.h>

#import <RongIMKit/RongIMKit.h>



//#import "APService.h"

#import "WXApi.h"
//#import "WeiboSDK.h"


#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "RCDChatViewController.h"
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//#import <QZoneConnection/ISSQZoneApp.h>
#import "WebViewController.h"
#import "FuWuXiangQingViewController.h"
#import "OderStatesViewController.h"

#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

#import <BaiduMapAPI_Location/BMKLocationService.h>

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

#import <BaiduMapAPI_Search/BMKPoiSearchType.h>

#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface AppDelegate ()<UITabBarControllerDelegate,CLLocationManagerDelegate,RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate,WXApiDelegate,RCIMUserInfoDataSource,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,JPUSHRegisterDelegate>

@property(nonatomic,strong)WXPayBlock wxpay;
@property(nonatomic,strong)ApiPayBlock ApiBlock;
@property(nonatomic,strong)NSString *targetId,*conversationType;
@property(nonatomic,strong)BMKLocationService *service,*sre;
@property(nonatomic,strong)BMKGeoCodeSearch *search;
@property(nonatomic,assign)BOOL isDismiss;


@end

@implementation AppDelegate
{
    BMKMapManager* _mapManager;
    BOOL or;
    
}
//首页加了定位

//- (BOOL)application:(UIApplication *)application
//      handleOpenURL:(NSURL *)url
//{
//    
//    if ([url.host isEqualToString:@"safepay"]) {
//        
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            if (_ApiBlock) {
//                _ApiBlock(resultDic);
//            }
//            
//        }];
//        return YES;
//    }
//    
//    
//    return  [WXApi handleOpenURL:url delegate:self];
//}


- (BOOL)application:(UIApplication *)app handleOpenURL:(nonnull NSURL *)url{



    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (_ApiBlock) {
                _ApiBlock(resultDic);
            }
            
        }];
        return YES;
    }
    
    
    return  [WXApi handleOpenURL:url delegate:self];


    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);

            if (_ApiBlock) {
                _ApiBlock(resultDic);
            }
        }];
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);

            if (_ApiBlock) {
                _ApiBlock(resultDic);
            }
        }];
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"G"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    

    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"KT8PaG8f62YITBtye0c7Drjr" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }else{
        [self dingwei];
    }
//
    [self newTabBarViewController:YES];
//
    [self NavStye];
    [self newJPushWithOptions:launchOptions];
    [ShareSDK registerApp:@"c8ff5ced9020"];
    [self RongRunInit];
    [RCIM sharedRCIM].userInfoDataSource=self;
    [RCIM sharedRCIM].receiveMessageDelegate=self;
//    [self ziding];
    [self initddd];
    [self appNum];
//
    [UmengCollection setup];//友盟
    
    
//    self.window.backgroundColor=[UIColor blackColor];
    
    return YES;
}
//
//-(void)resh{
//    NSString *commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
//    
//    AnalyzeObject *nale = [AnalyzeObject new];
//    [nale getGJidWithDic:@{@"community_id":commid} Block:^(id models, NSString *code, NSString *msg) {
//        if ([models isKindOfClass:[NSDictionary class]]) {
//            //self.userName = models[@"user_name"];
//            self.targetId = models[@"id"];
//            self.conversationType = @"1";
//        }
//        
//    }];
//    
//    
//    
//}


- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion{
    
    NSString *str = [userId substringToIndex:1];
    
    if ([str isEqualToString:@"m"]) {
        NSString *commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
        AnalyzeObject *nale = [AnalyzeObject new];
        [nale getGJidWithDic:@{@"community_id":commid} Block:^(id models, NSString *code, NSString *msg) {
            if ([models isKindOfClass:[NSDictionary class]]) {
                RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@",models[@"id"]] name:[NSString stringWithFormat:@"%@",models[@"user_name"]] portrait:[NSString stringWithFormat:@"%@",models[@"logo"]]];
                completion(info);
                
            }
            
        }];
        
    }
    
    
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy GetNickAndAvatarWithUser_ID:@{@"user_id":userId} Block:^(id models, NSString *code, NSString *msg) {
        NSArray *Arr=models;
        if (Arr && Arr.firstObject && [code isEqualToString:@"0"]) {
            NSDictionary *dic = Arr.firstObject;
            RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@",dic[@"id"]] name:[NSString stringWithFormat:@"%@",dic[@"nick_name"]] portrait:[NSString stringWithFormat:@"%@",dic[@"avatar"]]];
            completion(info);
        }
    }];
    
}
-(void)ziding{

  
    
    [[CCLocation sharedCCLocation]getLocation:^(CLLocationCoordinate2D locationCoordinate2D, NSString *country, NSString *city, NSString *place ,NSString *area) {
        
        if([city isChinese] ){
            NSString *lat = [NSString stringWithFormat:@"%f",locationCoordinate2D.latitude];
            NSString *lon = [NSString stringWithFormat:@"%f",locationCoordinate2D.longitude];

            [[Stockpile sharedStockpile]setCity:[NSString stringWithFormat:@"%@",city]];
            [[Stockpile sharedStockpile] setArea:[NSString stringWithFormat:@"%@",area]];
            
            [[NSUserDefaults standardUserDefaults]setObject:lat  forKey:@"lat"];
            [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"lon"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            

            
            if (_callbackLocation) {
                _callbackLocation(@"ok");
            }
        }

        
    }];

    
}

-(void)dingwei{
    
    _sre = [[BMKLocationService alloc]init];
    _sre.delegate = self;
    //启动LocationService
    or=YES;
    [_sre startUserLocationService];
    

}





- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{

    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    NSString *lat = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
//

    
   double locaLatitude=userLocation.location.coordinate.latitude;//纬度
   double locaLongitude=userLocation.location.coordinate.longitude;//精度
    
    
    CLLocationCoordinate2D pt=(CLLocationCoordinate2D){0,0};
    pt=(CLLocationCoordinate2D){locaLatitude,locaLongitude};


    
    BMKReverseGeoCodeOption *i = [BMKReverseGeoCodeOption new];
    i.reverseGeoPoint = pt;
    
    
    [[NSUserDefaults standardUserDefaults]setObject:lat  forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"longitude"];
    
    [[NSUserDefaults standardUserDefaults]setObject:lat  forKey:@"lat"];
    [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"lon"];
    [[NSUserDefaults standardUserDefaults]synchronize];


    
    
   
    if (_callbackLocation) {
        _callbackLocation(@"ok");
    }
    [_sre stopUserLocationService];


}

//-(void)onGetAddrResult:(BMKAddrInfo *)result errorCode:(int)error{
//    if (error==0) {
//        BMKPointAnnotation *item=[[BMKPointAnnotation alloc] init];
//        item.coordinate=result.geoPt;//地理坐标
//        item.title=result.strAddr;//地理名称
//        [myMapView addAnnotation:item];
//        myMapView.centerCoordinate=result.geoPt;
//        
//        self.lalAddress.text=[result.strAddr stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        if (![self.lalAddress.text isEqualToString:@""]) {
//            strProvince=result.addressComponent.province;//省份
//            strCity=result.addressComponent.city;//城市
//            strDistrict=result.addressComponent.district;//地区
//        }
//        //		CLGeocoder *geocoder=[[CLGeocoder alloc] init];
//        //		CLGeocodeCompletionHandler handle=^(NSArray *palce,NSError *error){
//        //			for (CLPlacemark *placemark in palce) {
//        //				NSLog(@"%@1-%@2-%@3-%@4-%@5-%@6-%@7-%@8-%@9-%@10-%@11-%@12",placemark.name,placemark.thoroughfare,placemark.subThoroughfare,placemark.locality,placemark.subLocality,placemark.administrativeArea,placemark.postalCode,placemark.ISOcountryCode,placemark.country,placemark.inlandWater,placemark.ocean,placemark.areasOfInterest);
//        //				break;
//        //			}
//        //		};
//        //		CLLocation *loc = [[CLLocation alloc] initWithLatitude:locaLatitude longitude:locaLongitude];
//        //		[geocoder reverseGeocodeLocation:loc completionHandler:handle];
//    }
//}


- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{

    
    NSLog(@"%@",result.addressDetail);
    

}



- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");

    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
        
        
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");

    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

#pragma mark - 融云
-(void)RongRunInit{
    [[RCIM sharedRCIM] initWithAppKey:@"z3v5yqkbvnbm0"];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    if (iPhone6Plus) {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(56, 56);
    } else {
        NSLog(@"iPhone6 %d", iPhone6);
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    }
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    [RCIM sharedRCIM].userInfoDataSource=self;

    [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
    NSString *token =[Stockpile sharedStockpile].token;
    NSString *userId=[Stockpile sharedStockpile].ID;
    NSString *userName = [Stockpile sharedStockpile].nickName;
    if (token.length && userId.length &&[Stockpile sharedStockpile].isLogin) {
        RCUserInfo *_currentUserInfo =
        [[RCUserInfo alloc] initWithUserId:userId
                                      name:userName
                                  portrait:[Stockpile sharedStockpile].logo];
        [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
        [RCIM sharedRCIM].currentUserInfo=_currentUserInfo;
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            RCUserInfo *_currentUserInfo = [[RCUserInfo alloc]initWithUserId:userId name:[Stockpile sharedStockpile].nickName portrait:[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].logo]];
            NSLog(@"%@",[Stockpile sharedStockpile].logo);
            [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
            [RCIM sharedRCIM].currentUserInfo=_currentUserInfo;
        } error:^(RCConnectErrorCode status) {
            
        } tokenIncorrect:^{
            
        }];
    }
    
    [RCIM sharedRCIM].userInfoDataSource=self;
    
}





#pragma mark - RCIMConnectionStatusDelegate
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{


    
    int unreadMsgCount = [[RCIMClient sharedRCIMClient]getUnreadCount: @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_PUBLICSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)]];
    NSLog(@"%d",unreadMsgCount);
    // UINavigationController *nav=(UINavigationController *)_tabBarController.viewControllers[1];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (unreadMsgCount<1) {
            //   nav.tabBarItem.badgeValue=nil;
        }else{
            //  nav.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",unreadMsgCount];
        }
    });
}
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status
{
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的帐号在别的设备上登录，您被迫下线！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [self outLogin];
        [[NSNotificationCenter defaultCenter]postNotificationName:orderLineKey object:nil];
    }
}

-(int)ReshData{
    
    NSLog(@"%d",[[RCIMClient sharedRCIMClient]getUnreadCount: @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_PUBLICSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)]]);
         return [[RCIMClient sharedRCIMClient]getUnreadCount: @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_PUBLICSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)]];
}

-(int)appNum{
    
    if (![Stockpile sharedStockpile].isLogin) {
//        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
        return 0;
    }
    NSInteger i = [self ReshData];
//    [UIApplication sharedApplication].applicationIconBadgeNumber;
    
//    NSLog(@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber);
//    NSLog(@"%d",i);
//    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:i];

    if (i>0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        });

    }
    
    return i;
    
}

-(void)NavStye{
    
    float scale=Scale;
    UIFont* font =Big17BoldFont(scale);
    NSDictionary* textAttributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor blackColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance]setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage ImageForColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}



-(void)initddd{
    
    
    
//    [ShareSDK registerApp:@"c8ff5ced9020"
//     
//          activePlatforms:@[@(SSDKPlatformTypeWechat),
//                            @(SSDKPlatformTypeQQ),
//                            ]
//                 onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                 break;
//             default:
//                 break;
//         }
//     }
//          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//     {
//         
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:APPI_ID
//                                       appSecret:APP_SECRET];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [appInfo SSDKSetupQQByAppId:@"1105091993"
//                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
//                                    authType:SSDKAuthTypeBoth];
//                 break;
//             default:
//                 break;
//         }
//     }];

    
    [ShareSDK connectQZoneWithAppKey:@"1105091993"
                           appSecret:@"9u6v7VT9isn0AWya"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
    [ShareSDK connectWeChatWithAppId:APPI_ID
                           appSecret:APP_SECRET
                           wechatCls:[WXApi class]];
    
    
    [ShareSDK connectQQWithQZoneAppKey:@"1105091993"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
    [ShareSDK connectQQWithAppId:@"1105091993" qqApiCls:[QQApiInterface class]];
}




#pragma mark - TabBarViewController
-(void)newTabBarViewController:(BOOL)orgen{
    UITabBarItem *homeItem=[[UITabBarItem alloc]initWithTitle:@"社区精选" image:[[UIImage setImgNameBianShen:@"ico1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ico_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
   
    [self unSelectedTapTabBarItems:homeItem];
    [self selectedTapTabBarItems:homeItem];
    
    UINavigationController *homeNav=[[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]init]];
    homeNav.tabBarItem = homeItem;
    
//    UITabBarItem *shopItem=[[UITabBarItem alloc]initWithTitle:@"生活服务" image:[[UIImage imageNamed:@"fuwu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"fuwu_11"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [self unSelectedTapTabBarItems:shopItem];
//    [self selectedTapTabBarItems:shopItem];
//    UINavigationController *shopNav=[[UINavigationController alloc]initWithRootViewController:[[ShangJiaViewController alloc]init]];
//    shopNav.tabBarItem = shopItem;
    
    
//    UITabBarItem *centerItem=[[UITabBarItem alloc]initWithTitle:@"物业中心" image:[[UIImage imageNamed:@"Oval 6_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"Oval 6_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [self unSelectedTapTabBarItems:centerItem];
//    [self selectedTapTabBarItems:centerItem];
////    centerItem.accessibilityFrame
////    centerItem.badgeValue.absolutePath = YES;
//    centerItem.imageInsets = UIEdgeInsetsMake(-10, 0, 10,0);
//    //centerItem.titlePositionAdjustment
//    UINavigationController *centerNav=[[UINavigationController alloc]initWithRootViewController:[[WuYeZhongXinViewController alloc]init]];
//    centerNav.tabBarItem = centerItem;
    
    
    UITabBarItem *gonggaoItem=[[UITabBarItem alloc]initWithTitle:@"邻里圈" image:[[UIImage imageNamed:@"ico2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ico_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self unSelectedTapTabBarItems:gonggaoItem];
    [self selectedTapTabBarItems:gonggaoItem];
    UINavigationController *gonggaoNav=[[UINavigationController alloc]initWithRootViewController:[[GongGaoQiangViewController alloc]init]];
    gonggaoNav.tabBarItem = gonggaoItem;
    
    
    
    UITabBarItem * gouWuChe = [[UITabBarItem alloc]initWithTitle:@"结算中心" image:[[UIImage imageNamed:@"ico3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:[[UIImage imageNamed:@"ioc_3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self unSelectedTapTabBarItems:gouWuChe];
    [self selectedTapTabBarItems:gouWuChe];
    UINavigationController * gouWuCheNav = [[UINavigationController alloc]initWithRootViewController:[[GouWuCheViewController alloc]init]];
    gouWuCheNav.tabBarItem = gouWuChe;
    
    UITabBarItem *presonItem=[[UITabBarItem alloc]initWithTitle:@"个人中心" image:[[UIImage imageNamed:@"ico4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"ico_4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self unSelectedTapTabBarItems:presonItem];
    [self selectedTapTabBarItems:presonItem];
     _presonNav=[[UINavigationController alloc]initWithRootViewController:[[GeRenZhongXinViewController alloc]init]];
    _presonNav.tabBarItem = presonItem;

    _tabBarController=[[UITabBarController alloc]init];
//    _tabBarController.viewControllers=@[homeNav,shopNav,centerNav,gonggaoNav,_presonNav];
     _tabBarController.viewControllers=@[homeNav,gonggaoNav,gouWuCheNav,_presonNav];
    _tabBarController.selectedIndex = 0;
    _tabBarController.tabBar.backgroundColor=tabBarBackgroundColor;
    _tabBarController.delegate=self;
    
    
    
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"GuideKey"]) {
        
        GuideViewController *guideVC=[[GuideViewController alloc]initWithBlock:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            
                ChooseQuViewController *ch = [[ChooseQuViewController alloc]initWithBlock:^(BOOL success) {
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"GuideKey"];
                    self.window.rootViewController=_tabBarController;
                }];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:ch];
                
                    self.window.rootViewController = nav;

                
                [RCIM sharedRCIM].userInfoDataSource=self;

            });
        }];
        
        self.window.rootViewController = guideVC;
    }else{
        
        if ([Stockpile sharedStockpile].isLogin==NO && orgen) {
          
                
//            self.window.rootViewController=_tabBarController;

                ChooseQuViewController *ch = [[ChooseQuViewController alloc]initWithBlock:^(BOOL success) {
                    
                    self.window.rootViewController=_tabBarController;
                }];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:ch];
                self.window.rootViewController = nav;
            [RCIM sharedRCIM].userInfoDataSource=self;

        }else{

        
        
        
        
        
//       NSString *ID = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
//        if (!ID) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                ChooseQuViewController *ch = [[ChooseQuViewController alloc]initWithBlock:^(BOOL success) {
//                    
//                    self.window.rootViewController=_tabBarController;
//                }];
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:ch];
//                self.window.rootViewController = nav;
//            });
//        }
            self.window.rootViewController = _tabBarController;
            [RCIM sharedRCIM].userInfoDataSource=self;

    }
    }
}

-(void)outLogin{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [JPUSHService setAlias:nil callbackSelector:@selector(asdasd) object:self];
    [[Stockpile  sharedStockpile] setIsLogin:NO];
    [[RCIM sharedRCIM] disconnect:NO];
    [self newTabBarViewController:NO];
}

-(void)asdasd{


//    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        LoginViewController *login = [LoginViewController new];
        login.f=NO;
        [self.window.rootViewController presentViewController:login animated:YES completion:nil];
        
        
    }else{
        
        self.tabBarController.selectedIndex=0;
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        
    }



}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{

    if ([tabBarController.selectedViewController isEqual:viewController]) {
        return NO;
    }
    UINavigationController *nav=(UINavigationController *)viewController;
    
    if (([nav.visibleViewController isKindOfClass:[GongGaoQiangViewController class]] || [nav.visibleViewController isKindOfClass:[GouWuCheViewController class]]) && ![Stockpile sharedStockpile].isLogin) {
        
        NSInteger selectedIndex=0;
        
        if ( [nav.visibleViewController isKindOfClass:[GongGaoQiangViewController class]]) {
            selectedIndex=1;
        }else{
            selectedIndex=2;
        }
        LoginViewController * dengluVC = [[LoginViewController alloc]init];
        [dengluVC resggong:^(NSString *str) {
            if ([str isEqualToString:@"ok"])
            {
                NSLog(@"%@",str);
                dispatch_async(dispatch_get_main_queue(), ^{
                    _tabBarController.selectedIndex=selectedIndex;
                });
            }
        }];
        UINavigationController *homeK=[[UINavigationController alloc]initWithRootViewController:dengluVC];
        [tabBarController presentViewController:homeK animated:YES completion:nil];
        return NO ;
    }
    return YES;
}
#pragma mark - 支付
#pragma mark - WXApiDelegate(optional)
-(void) onReq:(BaseReq*)req
{
    
}
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg;
    NSString *strTitle;
    if([resp isKindOfClass:[PayResp class]]){
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！"];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        if (_wxpay) {
            _wxpay(resp);
        }
    }
}
#pragma mark - 微信支付
-(void)WXPayPrice:(NSString *)price OrderID:(NSString *)orderId OrderName:(NSString *)orderName complete:(WXPayBlock)complete{
    
    
    NSLog(@"%@",price);
    
    _wxpay=complete;
    payRequsestHandler *req=[payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APPI_ID mch_id:PARTNER_ID];
    [req setKey:PARTNER_KEY];
    NSMutableDictionary *dict = [req sendPayByOrderTitle:orderName Price:price OrderID:orderId   UUID: [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        
//        NSLog(@"%@  --   %@   ---  %@  ---  %@  ----  %@  ----  %@",req.openID,req.partnerId,req.nonceStr,req.timeStamp,req.package,req.sign);
        
//     BOOL or =   [WXApi openWXApp];
        [WXApi sendReq:req];
    }
    
}
#pragma mark - 支付宝支付
-(void)AliPayPrice:(NSString *)price OrderID:(NSString *)orderId OrderName:(NSString *)orderName OrderDescription:(NSString *)description  complete:(ApiPayBlock)complete{
    NSString *appScheme = @"MZSQZFB";
    NSString* orderInfo = [self getOrderInfoPrice:price OrderID:orderId OrderName:orderName OrderDescription:description];
    NSString* signedStr = [self doRsa:orderInfo];
    NSLog(@"%@",signedStr);
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderInfo, signedStr, @"RSA"];
    _ApiBlock=complete;
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {

        NSLog(@"reslut = %@",resultDic);
        //NSString *Code=[resultDic objectForKey:@"resultStatus"];
        _ApiBlock(resultDic);
    }];
    
}
-(NSString*)getOrderInfoPrice:(NSString *)price OrderID:(NSString *)orderId OrderName:(NSString *)orderName OrderDescription:(NSString *)description
{
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    //#warning 商品信息
    order.tradeNO =[NSString stringWithFormat:@"%@",orderId]   ; //订单ID（由商家自行制定）
    order.productName =[NSString stringWithFormat:@"%@",orderName];//商品标题
    order.productDescription = [NSString stringWithFormat:@"%@",description];//商品描述
    order.amount =[NSString stringWithFormat:@"%@",price] ; //商品价格 （单位：元）
    order.notifyURL =  [NSString stringWithFormat:@"%@",CallBackWeb]; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    return [order description];
}
-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}


#pragma mark - TabBar字体颜色
-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"Helvetica-Bold" size:10],
                                        NSFontAttributeName,grayTextColor,NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"Helvetica-Bold" size:10],
                                        NSFontAttributeName,blueTextColor,NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateSelected];
}

#pragma mark - JPush
-(void)ZhuCeJPush{

    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
 
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

}

-(void)newJPushWithOptions:(NSDictionary *)launchOptions{
    
    if ([UIApplication sharedApplication].isRegisteredForRemoteNotifications) {
        [self ZhuCeJPush];
        [Stockpile sharedStockpile].tuiS=YES;

    }else if (![[NSUserDefaults standardUserDefaults]boolForKey:@"GuideKey"]) {
        [self ZhuCeJPush];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:@"77eb1f35fa18e1b0db64b981" channel:@"Publish channel"apsForProduction:YES advertisingIdentifier:nil];

//    [APService setupWithOption:launchOptions];
//    [APService setLogOFF];
//    [JPUSHService resetBadge];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"******* %@",deviceToken);
    NSString* token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[RCIMClient sharedRCIMClient]setDeviceToken:token];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    
//    [APService handleRemoteNotification:userInfo];
//    if ( application.applicationState != UIApplicationStateActive){
//        dispatch_async(dispatch_get_main_queue(), ^{
//             [self TapNextView:userInfo];
//        });
//       
//    }else{
//        NSString * str  = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
//        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"消息" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
//        [alt show];
//    }
//    [application setApplicationIconBadgeNumber:0];
//
//}
//}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
   
    
    [JPUSHService handleRemoteNotification:userInfo];
    if ( application.applicationState != UIApplicationStateActive){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self TapNextView:userInfo];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1007);
            
        });
        NSString * str  = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"消息" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alt show];
    }
//    [application setApplicationIconBadgeNumber:0];
    completionHandler(UIBackgroundFetchResultNewData);
    
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", userInfo);
    [self TapNextView:userInfo];
}

//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo
//fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"iOS7及以上系统，收到通知:%@",userInfo);
//    
//    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
//        [self TapNextView:userInfo];
//    }
//    
//    completionHandler(UIBackgroundFetchResultNewData);
//}
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
//        [self TapNextView:userInfo];

    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
       
        [self TapNextView:userInfo];

    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif


//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
//{
//    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
//    {
//        //IOS8
//        //创建UIUserNotificationSettings，并设置消息的显示类类型
//        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
//        
//        [application registerUserNotificationSettings:notiSettings];
//    }
//    else
//    {   // ios7
//        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                       |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    }
//
//}


-(void)TapNextView:(NSDictionary *)dic{
//    if (![Stockpile sharedStockpile].isLogin) {
//        return;
//    }
//    for (UINavigationController *nav in _tabBarController.viewControllers) {
//    //    [nav popToRootViewControllerAnimated:NO];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//
//        
//        
//    });
//    [JPUSHService resetBadge];
   [[UIApplication sharedApplication] setApplicationIconBadgeNumber: ([UIApplication sharedApplication].applicationIconBadgeNumber-1)];
    
    if([UIApplication sharedApplication].applicationIconBadgeNumber>0)
    {
        
    }
    _isDismiss = NO;
    NSString *push_type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"redirect_to"]];

    if ([push_type isEqualToString:@"1"]) {
        WebViewController *webVC=[[WebViewController alloc]init];
        webVC.isPush=YES;
        webVC.webType=WebTypeID;
        [webVC getdismissBlock:^(BOOL isDismiss) {
            self.isDismiss = isDismiss;
            [webVC dismissViewControllerAnimated:YES completion:nil];
        }];

        webVC.Content=[NSString stringWithFormat:@"%@",[dic objectForKey:@"redirect_id"]];
        [_tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:webVC] animated:NO completion:nil];
    }else if ([push_type isEqualToString:@"2"]){
        if([[dic objectForKey:@"order_type"] integerValue]==1){
            
            OderStatesViewController *oder = [OderStatesViewController new];
            oder.isPush=YES;
            [oder getdismissBlock:^(BOOL isDismiss) {
                self.isDismiss = isDismiss;
                [oder dismissViewControllerAnimated:YES completion:nil];
            }];

            oder.orderid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_no"]];
            oder.smallOder=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sub_order_no"]];
            [_tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:oder] animated:NO completion:nil];
            
        }else if([[dic objectForKey:@"order_type"] integerValue]==2){
            FuWuXiangQingViewController *oder = [FuWuXiangQingViewController new];
            oder.isPush=YES;
            [oder getdismissBlock:^(BOOL isDismiss) {
                self.isDismiss = isDismiss;
                [oder dismissViewControllerAnimated:YES completion:nil];
            }];

            oder.orderid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_no"]];
            oder.smallOder=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sub_order_no"]];
            [_tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:oder] animated:NO completion:nil];
            
            
        }

    }else if ([push_type isEqualToString:@"3"]){
        
        //零售商家 BreakInfoViewController 零售商家
        BreakInfoViewController *oder = [BreakInfoViewController new];
        oder.isPush=YES;
        [oder getdismissBlock:^(BOOL isDismiss) {
            self.isDismiss = isDismiss;
            [oder dismissViewControllerAnimated:YES completion:nil];
        }];
//        [oder dism]
        NSLog(@"%@",dic);
        oder.shop_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_id"]];
//        oder.smallOder=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sub_order_no"]];
        [_tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:oder] animated:NO completion:nil];
        
        
    }else if ([push_type isEqualToString:@"4"]){
        //ShopInfoViewController  商品详情
        ShopInfoViewController *oder = [ShopInfoViewController new];
        oder.isPush=YES;
        oder.isgo=YES;
        [oder getdismissBlock:^(BOOL isDismiss) {
            self.isDismiss = isDismiss;
            [oder dismissViewControllerAnimated:YES completion:nil];
        }];

        oder.shop_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_id"]];
        //        oder.smallOder=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sub_order_no"]];
        oder.prod_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"prod_id"]];
        [_tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:oder] animated:NO completion:nil];
        
    }else if ([push_type isEqualToString:@"5"]){
        //GanXiShopViewController
        GanXiShopViewController *oder = [GanXiShopViewController new];
        oder.isPush=YES;
        [oder getdismissBlock:^(BOOL isDismiss) {
            self.isDismiss = isDismiss;
            [oder dismissViewControllerAnimated:YES completion:nil];
        }];

        oder.shop_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"life_shop_id"]];
        //        oder.smallOder=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sub_order_no"]];
//        oder.prod_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"prod_id"]];
        [_tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:oder] animated:NO completion:nil];
        
    }
    else if ([push_type isEqualToString:@"6"]){
        //GanXiShopViewController
        
    }else{
        
        RCDChatListViewController *list = [[RCDChatListViewController alloc]init];
        list.isPush=YES;
        [_tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:list] animated:NO completion:nil];
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
//        if ([push_type isEqualToString:@"1"]) {
//            WebViewController *webVC=[[WebViewController alloc]init];
//            webVC.isPush=YES;
//            webVC.webType=WebTypeID;
//            webVC.Content=[NSString stringWithFormat:@"%@",[dic objectForKey:@"redirect_id"]];
//            [_tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:webVC] animated:NO completion:nil];
//        }
//        else  {
//            if([[dic objectForKey:@"order_type"] integerValue]==1){
//                
//                OderStatesViewController *oder = [OderStatesViewController new];
//                oder.isPush=YES;
//                oder.orderid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_no"]];
//                oder.smallOder=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sub_order_no"]];
//                [_tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:oder] animated:NO completion:nil];
//                
//            }else if([[dic objectForKey:@"order_type"] integerValue]==2){
//                FuWuXiangQingViewController *oder = [FuWuXiangQingViewController new];
//                oder.isPush=YES;
//                oder.orderid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"order_no"]];
//                oder.smallOder=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sub_order_no"]];
//                [_tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:oder] animated:NO completion:nil];
//
//                
//            }else{
//            
//                RCDChatListViewController *list = [[RCDChatListViewController alloc]init];
//                list.isPush=YES;
//                [_tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:list] animated:NO completion:nil];
//            
//            }
//        }


}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [self appNum];
    [JPUSHService resetBadge];
//    NSLog(@"%ld",[UIApplication sharedApplication].applicationIconBadgeNumber);
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
    NSLog(@"%@",@"进入后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
