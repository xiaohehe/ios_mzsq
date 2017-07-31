//
//  AppUtil.h
//  trading
//
//  Created by 张玲 on 15/8/29.
//  Copyright (c) 2015年 getco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AppUtil : NSObject
+(void) showProgressDialog:(MBProgressHUD *) hud withContent:(NSString *) content;
+(void) showToast:(UIView *) view withContent:(NSString *) content;
+(BOOL) isBlank:(NSString *) str;
+(BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime;
//是否在营业时间
+(BOOL) isDoBusiness:(NSDictionary*) dic;
//时间是否有效
+(BOOL) isTimeBlank:(NSString*) time;
@end
