//
//  AppUtil.m
//  trading
//  Created by 张玲 on 15/8/29.
//  Copyright (c) 2015年 getco. All rights reserved.
//

#import "AppUtil.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@implementation AppUtil

+(void) showProgressDialog:(MBProgressHUD *)hud withContent:(NSString *)content{
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=content;
    [hud show:YES];
}

+(void) showToast:(UIView *)view withContent:(NSString *)content{
    MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    //[view addSubview:hud];
    hud.mode=MBProgressHUDModeText;
    hud.labelText=content;
    hud.margin=10.f;
    hud.yOffset=150.f;
    hud.removeFromSuperViewOnHide=YES;
    [hud hide:YES afterDelay:2];
}

+(BOOL) isBlank:(NSString *)str{
    if([str isKindOfClass:[NSNull class]])
        return YES;
    if(str==nil)
        return YES;
    NSString* s=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([s length]==0||[s isEqualToString:@""]|| s==nil){
        return  YES;
    }
    return NO;
}

//是否在营业时间
+(BOOL) isDoBusiness:(NSDictionary*) dic{
    NSString* ts1=dic[@"business_start_hour1"];
    NSString* td1=dic[@"business_end_hour1"];
    NSString* ts2=dic[@"business_start_hour2"];
    NSString* td2=dic[@"business_end_hour2"];
//    ts1=@"16:00";
//    td1=@"10:00";
    //NSLog(@"start==%@   expire==%@  ==%d",ts1,td1,[self isTimeBlank:ts1]);
    if((![self isTimeBlank:ts1]||![self isTimeBlank:td1])&&[self validateWithStartTime:ts1 withExpireTime:td1]){
        return YES;
    }
    if((![self isTimeBlank:ts2]||![self isTimeBlank:td2])&&[self validateWithStartTime:ts2 withExpireTime:td2]){
        return YES;
    }
    if([self isTimeBlank:ts1]&&[self isTimeBlank:td1]&&[self isTimeBlank:ts2]&&[self isTimeBlank:td2])
        return YES;
    return NO;
}

//时间是否有效
+(BOOL) isTimeBlank:(NSString*) time{
    if([self isBlank:time]||[time isEqualToString:@"00:00"]||[time isEqualToString:@"00:00:00"])
        return YES;
    return NO;
}

/**
 *  判断当前时间是否处于某个时间段内
 *
 *  @param startTime        开始时间
 *  @param expireTime       结束时间
 */
+(BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *start = [dateFormat dateFromString:[self getTimeWithDate:startTime]];
    NSDate *expire = [dateFormat dateFromString:[self getTimeWithDate:expireTime]];
//    NSLog(@"compare==%@==%@",[self getTimeWithDate:startTime],[self getTimeWithDate:expireTime]);
//    NSLog(@"compare==%@==%@",start,expire);
//    NSLog(@"compare==%@==%ld==%ld==%ld==%ld",today,[today compare:start],NSOrderedDescending,[today compare:expire],NSOrderedAscending);
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

+(NSString*) getTimeWithDate:(NSString*) time{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    return [NSString stringWithFormat:@"%ld-%@-%@ %@",year,[self getTimeWith0:month],[self getTimeWith0:day],time];
}

+(NSString*) getTimeWith0:(NSInteger) time{
    if(time<10)
        return [NSString stringWithFormat:@"0%ld",time];
    else
        return [NSString stringWithFormat:@"%ld",time];
}

@end
