//
//  MapNavigationManager.m
//  MapNavigation
//
//  Created by apple on 16/2/14.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "MapNavigationManager.h"



typedef enum : NSUInteger {
    Apple = 0,
    Baidu,
    Gaode,
} MapSelect;


static MapNavigationManager * MBManager = nil;

@interface MapNavigationManager ()<UIActionSheetDelegate>

@property (strong, nonatomic) NSString * urlScheme;
@property (strong, nonatomic) NSString * appName;

@property (strong, nonatomic) NSString * start;
@property (strong, nonatomic) NSString * end;
@property (strong, nonatomic) NSString * city;

@property (assign, nonatomic) MapNavStyle style;

@property (assign, nonatomic) CLLocationCoordinate2D Coordinate2D;

@end

@implementation MapNavigationManager


+ (MapNavigationManager *)shardMBManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MBManager = [[MapNavigationManager alloc] init];
    });
    return MBManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //!!! 需要自己改，方便弹回来
        _start=@"我的位置";
        self.urlScheme = @"ap2015072400185895://";
        self.appName = @"拇指便利";
    }
    return self;
}

- (void)showSheet
{
    NSString * appleMap  = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]] ? @"苹果地图" : nil;
    NSString * baiduMap  = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]] ? @"百度地图" : nil;
    NSString * gaodeMap  = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]] ? @"高德地图":nil;
    //不能用，需翻墙
    NSString * googleMap = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]] ? nil :nil;
    //暂时不支持
    NSString * tencentMap  = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://map/"]] ? nil : nil;
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"导航到%@",_end] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:appleMap otherButtonTitles:baiduMap,gaodeMap,googleMap,tencentMap,nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * str = [actionSheet buttonTitleAtIndex:buttonIndex];
    //和枚举对应
    NSArray <NSString *> * mapArray = @[@"苹果地图",@"百度地图",@"高德地图"];
    NSUInteger i = 0 ;
    for (; i < mapArray.count; i ++) {
        if ([str isEqualToString:mapArray[i]]) {
            break;
        }
    }
    [self startNavigation:i];
}

- (void)startNavigation:(MapSelect)index
{
    NSString * urlString = [self getUrlStr:index];
    if (urlString != nil) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }else if(_style == Coordinates){
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.Coordinate2D addressDictionary:nil]];
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }
}

- (NSString *)getUrlStr:(MapSelect)index
{
    NSString * urlStr = nil;
    if (index == Apple && _style == Coordinates) {
        return urlStr;
    }
    switch (_style) {
        case Coordinates:
            urlStr = [self getUrlStrWithCoordinates:index];
            break;
        case Address:
            urlStr = [self getUrlStrWithAddress:index];
            break;
        default:
            break;
    }
    return urlStr;
}

- (NSString *)getUrlStrWithCoordinates:(MapSelect)index
{   // NSLog(@"end==%@",_end);
    NSString * urlString = nil;
    MapNavigationManager * mb = [MapNavigationManager shardMBManager];
    NSString * baiduUrlStr = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",mb.Coordinate2D.latitude, mb.Coordinate2D.longitude,_end] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString * gaodeUrlStr= [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",_appName,_urlScheme,mb.Coordinate2D.latitude, mb.Coordinate2D.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    switch (index) {
        case Baidu:
            urlString = baiduUrlStr;
            break;
        case Gaode:
            urlString = gaodeUrlStr;
            break;
        default:
            break;
    }
    return urlString;
}

- (NSString *)getUrlStrWithAddress:(MapSelect)index{
    NSString * urlString = nil;
    MapNavigationManager * mb = [MapNavigationManager shardMBManager];
    //苹果
    NSString *appleAddressUrl = [[NSString stringWithFormat:@"http://maps.apple.com/?saddr=%@&daddr=%@&dirflg=w",_start, mb.end] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //百度
    NSString *baiduAddressUrl = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%@&destination=%@&mode=walking&region=%@&src=%@",mb.start, mb.end,_city,_appName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //高德
    NSString *gaodeAddressUrl = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&sname=%@&did=BGVIS2&dname=%@&dev=0&m=2&t=2",_appName,mb.start,mb.end] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    switch (index) {
        case Apple:
            urlString = appleAddressUrl;
            break;
        case Baidu:
            urlString = baiduAddressUrl;
            break;
        case Gaode:
            urlString = gaodeAddressUrl;
            break;
        default:
            break;
    }
    return urlString;
}

+ (void)showSheetWithCoordinate2D:(CLLocationCoordinate2D)Coordinate2D andShopName:(NSString*) shopname{
    MapNavigationManager * mb = [self shardMBManager];
    mb.style = Coordinates;
    mb.end=shopname;
    mb.Coordinate2D = Coordinate2D;
    [mb showSheet];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
