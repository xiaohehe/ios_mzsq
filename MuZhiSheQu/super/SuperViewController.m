//
//  SuperViewController.m
//  MissAndFound
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "SDImageCache.h"
#import "LoginViewController.h"
#import "UITabBar+badge.h"
@interface SuperViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong)AlertBlock alertBlock;

@end
@implementation SuperViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self gouWuCheShuZi];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    _scale=1.0;
    if ([[UIScreen mainScreen] bounds].size.height > 480)
    {
         _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
    }
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//   self.navigationController.navigationBarHidden=YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    
    self.view.backgroundColor = superBackgroundColor;
    self.NavImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    self.NavImg.backgroundColor=[UIColor whiteColor];
    self.NavImg.userInteractionEnabled = YES;
    self.NavImg.clipsToBounds = YES;
    [self.view  addSubview:self.NavImg];

    
    self.TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45*self.scale, 20, self.view.width-90*self.scale, 44)];
    self.TitleLabel.textColor = [UIColor blackColor];
    self.TitleLabel.textAlignment = 1;
    self.TitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18*_scale];
    self.TitleLabel.backgroundColor = [UIColor clearColor];
    [self.NavImg addSubview:self.TitleLabel];
    _activityVC=[[UIActivityIndicatorView alloc]initWithView:self.view];
    _activityVC.color=[UIColor blackColor];
    
 //   _Navline=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.NavImg.height-1*self.scale, self.view.width, 1*self.scale)];
//    _Navline.backgroundColor=blackLineColore;
   //[self.NavImg addSubview:_Navline];
    
    
}

#pragma mark  -- 改变状态栏的颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
-(void)ShowAlertWithMessage:(NSString *)message{
    
    if ([[NSString stringWithFormat:@"%@",message] isEmptyString]) {
        return;
    }
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
- (void)getdismissBlock:(dismissBlock)dismissBlock
{
    _dismissBlock = dismissBlock;
}
-(void)setName:(NSString *)name{
    self.navigationController.title=name;
}
-(void)ShowAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate Block:(AlertBlock)block{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
    [alert show];
    _alertBlock=block;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (_alertBlock) {
        _alertBlock(buttonIndex);
    }
}
#pragma mark - 屏幕选转
- (BOOL)shouldAutorotate
{
    return NO;
}

//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(NSString *)getCommid{
    NSString *com = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    return com;
}

-(NSString *)getuserid{
    NSString *com = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    return com;
}

-(id)login{
//    self.hidesBottomBarWhenPushed=YES;
    LoginViewController *login = [LoginViewController new];
    login.f=NO;
    [self presentViewController:login animated:YES completion:nil];
    return login;
}


-(void)gongGaoDian{
    
    NSInteger num = [[[NSUserDefaults standardUserDefaults]objectForKey:@"gongnum"] integerValue];
    
    NSInteger wuyeNum = [[[NSUserDefaults standardUserDefaults]objectForKey:@"wuyeNum"] integerValue];
    
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle GongGaoNum:@{@"community_id":[self getCommid]} Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {

            NSInteger hnum = [models[@"total_notice_count"] integerValue];
            if (hnum>num) {
                [self.tabBarController.tabBar showBadgeOnItemIndex:1];
                
            }
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)hnum] forKey:@"gongnumc"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSInteger hwuyeNum = [models[@"community_notice_count"] integerValue];
            if (hwuyeNum>wuyeNum)
            {
//                [self.tabBarController.tabBar showBadgeOnItemIndex:2];
                if (!_hongDianImageView)
                {
                    self.hongDianImageView = [[UIImageView alloc]init];
                    self.hongDianImageView.backgroundColor = [UIColor redColor];
                }
                else
                {
                    _hongDianImageView.hidden = NO;
                }
            
            }
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)hwuyeNum] forKey:@"wuyeNum"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
    }];
    
    
    
}

//- (void)gouWuCheShuZi
//{
//    if ([Stockpile sharedStockpile].isLogin)
//    {
//        NSString *userid =  [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
//        NSDictionary *dic = @{@"user_id":userid};
//        AnalyzeObject *analy=[[AnalyzeObject alloc]init];
//        [analy showCartWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
//            if ([code isEqualToString:@"0"])
//            {
//                NSLog(@"%@",models);
//            }
//        }];
//    }
//    else
//    {
//        UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:2];
//        item.badgeValue=nil;
//    }
//   
//}

-(NSMutableAttributedString *)stringColorAllString:(NSString *)string redString:(NSString *)redString{

    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSRange range=[string rangeOfString:[NSString stringWithFormat:@"%@",redString]];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    
    return str;
    
}

-(void)ClearCache{
    
    dispatch_async(
                   
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   
                   , ^{
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
                       
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       
                       for (NSString *p in files) {
                           
                           NSError *error;
                           
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               
                           }
                           
                       }
                       
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    
}



- (CGFloat)folderSizeAtPath:(NSString *)folderPath

{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) {
        
        return 0;
        
    }
    
    
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    
    
    NSString *fileName = nil;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
    
}


- (long long)fileSizeAtPath:(NSString *)filePath

{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
    
    
    
}



-(void)clearCacheSuccess

{
    
    NSLog(@"清理成功");
    
    
    
}


 
//- (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
//{
//    NSDate *date8 = [self getCustomDateWithHour:fromHour];
//    NSDate *date23 = [self getCustomDateWithHour:toHour];
//    
//    NSDate *currentDate = [NSDate date];
//    
//    if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
//    {
//        NSLog(@"该时间在 %d:00-%d:00 之间！", fromHour, toHour);
//        return YES;
//    }
//    return NO;
//}
//
///**
// * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
// * @param hour 如hour为“8”，就是上午8:00（本地时间）
// */
//- (NSDate *)getCustomDateWithHour:(NSInteger)hour
//{
//    //获取当前时间
//    NSDate *currentDate = [NSDate date];
//    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
//    
//    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    
//    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
//    
//    //设置当天的某个点
//    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
//    [resultComps setYear:[currentComps year]];
//    [resultComps setMonth:[currentComps month]];
//    [resultComps setDay:[currentComps day]];
//    [resultComps setHour:hour];
//    
//    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    return [resultCalendar dateFromComponents:resultComps];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

-(BOOL)getTimeWith:(NSDictionary *)shopInfo{

    
    BOOL isSleep1=YES;
    BOOL isSleep2=YES;
    BOOL isSleep3=YES;
    
    
    NSArray *timArr  = [shopInfo[@"business_hour"] componentsSeparatedByString:@","];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *nowFo = [[NSDateFormatter alloc]init];
    [nowFo setDateFormat:@"yyyy-MM-dd"];
    NSString *noewyers = [nowFo stringFromDate:now];
    
    for (NSString *str in timArr) {
        if ([str isEqualToString:@"1"]) {
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",shopInfo[@"business_start_hour1"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",shopInfo[@"business_end_hour1"]]];
            
            
            
            NSDateFormatter *fo = [[NSDateFormatter alloc]init];
            [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *das = [fo dateFromString:timeStart1];
            NSDate *dad = [fo dateFromString:timeEnd1];
            
            NSDate *dates = [self getNowDateFromatAnDate:das];
            NSDate *dated = [self getNowDateFromatAnDate:dad];
            NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
            
            NSLog(@"%@",[NSDate date]);
            
            
            //开始的时间戳
            double times = [dates timeIntervalSince1970];
            //结束的时间戳
            double timed = [dated timeIntervalSince1970];
            //现在的时间戳
            double timen = [daten timeIntervalSince1970];
            
            
            
            if (timen>times && timen<timed) {
                isSleep1=NO;
            }else{
                isSleep1=YES;
            }
            
            
            
        }
        
        
        
        
        else if ([str isEqualToString:@"2"]) {
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",shopInfo[@"business_start_hour2"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",shopInfo[@"business_end_hour2"]]];
            NSDateFormatter *fo = [[NSDateFormatter alloc]init];
            [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *das = [fo dateFromString:timeStart1];
            NSDate *dad = [fo dateFromString:timeEnd1];
            
            
            NSDate *dates = [self getNowDateFromatAnDate:das];
            NSDate *dated = [self getNowDateFromatAnDate:dad];
            NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
            
            //开始的时间戳
            double times = [dates timeIntervalSince1970];
            //结束的时间戳
            double timed = [dated timeIntervalSince1970];
            //现在的时间戳
            double timen = [daten timeIntervalSince1970];
            
            
            
            if (timen>times && timen<timed) {
                isSleep2=NO;
            }else{
                isSleep2=YES;
            }
            
            
            
        }
        
        
        else  if ([str isEqualToString:@"3"]) {
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",shopInfo[@"business_start_hour3"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",shopInfo[@"business_end_hour3"]]];
            NSDateFormatter *fo = [[NSDateFormatter alloc]init];
            [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *das = [fo dateFromString:timeStart1];
            NSDate *dad = [fo dateFromString:timeEnd1];
            
            
            NSDate *dates = [self getNowDateFromatAnDate:das];
            NSDate *dated = [self getNowDateFromatAnDate:dad];
            NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
            
            //开始的时间戳
            double times = [dates timeIntervalSince1970];
            //结束的时间戳
            double timed = [dated timeIntervalSince1970];
            //现在的时间戳
            double timen = [daten timeIntervalSince1970];
            
            
            
            if (timen>times && timen<timed) {
                isSleep3=NO;
            }else{
                isSleep3=YES;
            }
            
        }
        
        
    }
    //-----------------
    
    BOOL   issleep=NO;

    
    
    if (isSleep1==NO || isSleep2==NO || isSleep3==NO) {
        issleep=NO;
    }else{
        issleep=YES;
    }
    
    if ([shopInfo[@"business_hour"] isEqualToString:@""]) {
        issleep=NO;
    }
    
    
    if ([shopInfo[@"status"] isEqualToString:@"3"]) {
        issleep=YES;
    }else{
        NSString *week = [self weekdayStringFromDate:[NSDate date]];
        if ([week isEqualToString:@"周六"]) {
            if ([shopInfo[@"off_on_saturday"] isEqualToString:@"2"]) {
                issleep=YES;
            }
        }else if ([week isEqualToString:@"周日"]){
            if ([shopInfo[@"off_on_sunday"] isEqualToString:@"2"]) {
                issleep=YES;
            }
        }
    }

    
    return issleep;
}
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate] ;
    return destinationDateNow;
}
#pragma mark -- 根据宽度获取字符串的高和宽
- (CGRect)getStringWithFont:(float)font withString:(NSString *)string withWith:(CGFloat)with
{
    CGRect stringRect = [string boundingRectWithSize:CGSizeMake(with, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return stringRect;
}
@end
