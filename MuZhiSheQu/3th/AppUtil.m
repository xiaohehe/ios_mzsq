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
    if([s length]==0||[s isEqualToString:@""]|| s==nil||[s isEqualToString:@"<null>"]||[s isEqualToString:@"(null)"]){
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


+(NSString*) postSendTime:(NSString*) time{
    NSDate *now = [NSDate date];
    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
    NSInteger interval1 = [zone1 secondsFromGMTForDate:now];
    NSDate *localDate1 = [now dateByAddingTimeInterval:interval1];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *start = [dateFormat dateFromString:time];
    NSInteger interval2 = [zone1 secondsFromGMTForDate:start];
    NSDate *localDate2 = [start dateByAddingTimeInterval:interval2];
    
    // 时间2与时间1之间的时间差（秒）
    double lTime = [localDate1 timeIntervalSinceReferenceDate] - [localDate2 timeIntervalSinceReferenceDate];
    NSInteger minutes = lTime / 60;
    NSInteger hours = (lTime / 3600);
    NSInteger days = lTime/60/60/24;
    NSInteger month = lTime/60/60/24/12;
    NSInteger years = lTime/60/60/24/365;
    NSString* subTime=@"刚刚";
    if(years>0){
        subTime=[NSString stringWithFormat:@"%ld年前",years];
    }else if(month>0){
        subTime=[NSString stringWithFormat:@"%ld月前",month];
    }else if(days>0){
        subTime=[NSString stringWithFormat:@"%ld天前",days];
    }else if(hours>0){
        subTime=[NSString stringWithFormat:@"%ld小时前",hours];
    }else if(minutes>0){
        subTime=[NSString stringWithFormat:@"%ld分钟前",minutes];
    }
    return subTime;
}

+(NSString*) postSendTime2:(NSString*) time{
    NSDate *now = [NSDate date];
    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
    NSInteger interval1 = [zone1 secondsFromGMTForDate:now];
    NSDate *localDate1 = [now dateByAddingTimeInterval:interval1];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *start = [dateFormat dateFromString:time];
    NSInteger interval2 = [zone1 secondsFromGMTForDate:start];
    NSDate *localDate2 = [start dateByAddingTimeInterval:interval2];
    // 时间2与时间1之间的时间差（秒）
    double lTime = [localDate1 timeIntervalSinceReferenceDate] - [localDate2 timeIntervalSinceReferenceDate];
    NSInteger minutes = lTime / 60;
    NSInteger hours = (lTime / 3600);
    NSInteger days = lTime/60/60/24;
    NSInteger month = lTime/60/60/24/12;
    NSInteger years = lTime/60/60/24/365;
    NSString* subTime=@"刚刚";
    if(years>0){
        subTime=[NSString stringWithFormat:@"%ld年前",years];
    }else if(month>0){
        subTime=[NSString stringWithFormat:@"%ld月前",month];
    }else if(days>0){
        subTime=[NSString stringWithFormat:@"%ld天前",days];
    }else if(hours>0){
        subTime=[NSString stringWithFormat:@"%ld小时前",hours];
    }else if(minutes>0){
        subTime=[NSString stringWithFormat:@"%ld分钟前",minutes];
    }
    return subTime;
}

+(NSString*) postSendTime3:(NSString*) time{
    NSDate *now = [NSDate date];
    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
    NSInteger interval1 = [zone1 secondsFromGMTForDate:now];
    NSDate *localDate1 = [now dateByAddingTimeInterval:interval1];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *start = [dateFormat dateFromString:time];
    NSInteger interval2 = [zone1 secondsFromGMTForDate:start];
    NSDate *localDate2 = [start dateByAddingTimeInterval:interval2];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSString* subTime=time;
    NSArray *d1 = [subTime componentsSeparatedByString:@" "];
    NSString* t1=[d1 lastObject];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:localDate2];
    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:localDate1];
    if((selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day)){
        if([t1 length]>=5){
            subTime=[t1 substringToIndex:5];
        }
    }else if((selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && ((selfCmps.day+1) == nowCmps.day)){
        if([t1 length]>=5){
            subTime=[NSString stringWithFormat:@"昨天 %@",[t1 substringToIndex:5]];
        }
    }else{
        if([t1 length]>=5){
            subTime=[NSString stringWithFormat:@"%@ %@",[d1 firstObject],[t1 substringToIndex:5]];
        }
    }
    return subTime;
}

+(NSString*) getCurrentTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}

+(NSString*) getCurrentTime2{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}

+(BOOL) arrayIsEmpty:(NSArray *) arr{
    if([arr isKindOfClass:[NSNull class]])
        return YES;
    if(arr==nil||arr.count==0)
        return YES;
    return NO;
}

+(NSString*) dateConversion:(NSString*) time{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *start = [dateFormat dateFromString:time];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter2 setDateFormat:@"yyyy年MM月dd日"];
    //NSDate转NSString
    NSString* format = [dateFormatter2 stringFromDate:start];
    return format;
}
@end
