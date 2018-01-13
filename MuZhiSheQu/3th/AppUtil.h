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
//贴子发布时间
+(NSString*) postSendTime:(NSString*) time;
+(NSString*) postSendTime2:(NSString*) time;
+(NSString*) postSendTime3:(NSString*) time;
//获取当前时间
+(NSString*) getCurrentTime;
+(NSString*) getCurrentTime2;
+(NSString*) getTimeWith0:(NSInteger) time;
+(BOOL) arrayIsEmpty:(NSArray *) arr;
+(NSString*) dateConversion:(NSString*) time;
@end
