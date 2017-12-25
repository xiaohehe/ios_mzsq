//
//  MapNavigationManager.h
//  MapNavigation
//
//  Created by apple on 16/2/14.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import CoreLocation;
@import MapKit;
typedef enum : NSUInteger {
    Address = 0,
    Coordinates
} MapNavStyle;

@interface MapNavigationManager : NSObject

+ (void)showSheetWithCity:(NSString *)city start:(NSString *)start end:(NSString *)end;
+ (void)showSheetWithCoordinate2D:(CLLocationCoordinate2D)Coordinate2D andShopName:(NSString*) shopname;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
