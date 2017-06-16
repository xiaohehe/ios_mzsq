//
//  ShouCangDianPuViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShouCangDianPuViewController.h"
#import "BreakfastCellTableViewCell.h"
#import "UmengCollection.h"
@interface ShouCangDianPuViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *la;
@property(nonatomic,strong)reshshoucang block;
@end

@implementation ShouCangDianPuViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    _index=0;
    [self reshData];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray new];
    _index=0;
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self reshData];
    
    
}

-(void)reshData{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    [_la removeFromSuperview];
    _index++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    
    AnalyzeObject *anle =[AnalyzeObject new];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    
    
    NSDictionary *dic = @{@"user_id":userid,@"collect_type":@"2",@"pindex":index,@"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],@"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]]};
    [anle getCollectListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (_index==1) {
            [_dataSource removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {
            [_dataSource addObjectsFromArray:models];
        }
        
        
        if (_dataSource.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
            _la.text=@"暂无收藏店铺信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:_la];
        }
        [_tableView reloadData];
        
    }];


}
-(void)newView{
    
    _tableView=[[UITableView  alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[BreakfastCellTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footr)];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headr)];
    [self.view addSubview:_tableView];
    
}
-(void)footr{

    [self reshData];
}

-(void)headr{
    _index=0;
    [self reshData];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BreakfastCellTableViewCell *cell=(BreakfastCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.addressImg.image = [UIImage imageNamed:@"address"];
    
    NSString *url=@"";
    NSString *cut = _dataSource[indexPath.row][@"logo"];
    NSLog(@"%@",_dataSource);
    NSString *imagename = [cut lastPathComponent];
    NSString *path = [cut stringByDeletingLastPathComponent];
    NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb320."]];
    NSLog(@"%@",smallImgUrl);
//    if (cut.length>0) {
//        url = [cut substringToIndex:[cut length] - 4];
//        
//    }
//    [cell.headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb320.jpg",url]] placeholderImage:[UIImage imageNamed:@"za"]];
     [cell.headImg setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
    if ([[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"is_auth"]] isEqualToString:@"2"]) {
        cell.renZheng.hidden=NO;
        cell.isJin=YES;
    }else{
        cell.renZheng.hidden=YES;
        cell.isJin=NO;
    }
    cell.titleLa.text = _dataSource[indexPath.row][@"shop_name"];
    cell.scoreLa.text = _dataSource[indexPath.row][@"rating"];
    cell.contextLa.text = _dataSource[indexPath.row][@"summary"];
    
    if ([cell.contextLa.text isEqualToString:@""]) {
        cell.contextLa.text=@"暂无简介";
    }
    cell.addressLa.text = _dataSource[indexPath.row][@"address"];
    float dis = [_dataSource[indexPath.row][@"distance"] floatValue];
    
    if (dis<1000) {
        cell.distanceLa.text = [NSString stringWithFormat:@"%.0fm", dis];
        if ([cell.distanceLa.text isEqualToString:@"0m"]) {
            cell.distanceLa.hidden=YES;
        }
        
    }else{
        dis = dis/1000;
        cell.distanceLa.hidden=NO;
        cell.distanceLa.text = [NSString stringWithFormat:@"%.1fkm", dis];
        
    }
    

   NSString *start = _dataSource[indexPath.row][@"rating"];
    cell.StartNumber=start;
    
    
    
    
    
    //-----------------是否休息判断
    
    
    if ([_dataSource[indexPath.row][@"status"] isEqualToString:@"3"]) {
        cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
        cell.addLa.textColor=[UIColor clearColor];
        
        return cell;
    }else{
        NSString *week = [self weekdayStringFromDate:[NSDate date]];
        if ([week isEqualToString:@"周六"]) {
            if ([_dataSource[indexPath.row][@"off_on_saturday"] isEqualToString:@"2"]) {
                cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
                cell.addLa.textColor=[UIColor clearColor];
                return cell;
            }
        }else if ([week isEqualToString:@"周日"]){
            if ([_dataSource[indexPath.row][@"off_on_sunday"] isEqualToString:@"2"]) {
                cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
                cell.addLa.textColor=[UIColor clearColor];
                return cell;
            }
        }
    }
    
    BOOL isSleep1=YES;
    BOOL isSleep2=YES;
    BOOL isSleep3=YES;
    
    NSArray *timArr  = [_dataSource[indexPath.row][@"business_hour"] componentsSeparatedByString:@","];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *nowFo = [[NSDateFormatter alloc]init];
    [nowFo setDateFormat:@"yyyy-MM-dd"];
    NSString *noewyers = [nowFo stringFromDate:now];
    
    for (NSString *str in timArr) {
        if ([str isEqualToString:@"1"]) {
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_dataSource[indexPath.row][@"business_start_hour1"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_dataSource[indexPath.row][@"business_end_hour1"]]];
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
                isSleep1=NO;
            }else{
                isSleep1=YES;
            }
            
            
            
        }
        
        
        
        
        else if ([str isEqualToString:@"2"]) {
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_dataSource[indexPath.row][@"business_start_hour2"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_dataSource[indexPath.row][@"business_end_hour2"]]];
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
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_dataSource[indexPath.row][@"business_start_hour3"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_dataSource[indexPath.row][@"business_end_hour3"]]];
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
    if (isSleep1==NO || isSleep2==NO || isSleep3==NO) {
        
//        cell.addLa.text = [_dataSource[indexPath.row] objectForKey:@"notice"];
//        cell.addLa.textColor=blueTextColor;
        
    }else{
        cell.addLa.text = @"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
        cell.addLa.textColor=[UIColor clearColor];
        
    }
    
    if ([_dataSource[indexPath.row][@"business_hour"] isEqualToString:@""]) {
        cell.addLa.text = [_dataSource[indexPath.row] objectForKey:@"notice"];
        
    }
    
    
    
    return cell;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width-170*self.scale, 10)];
    la.font=DefaultFont(self.scale);
    la.numberOfLines=0;
    la.text=[_dataSource[indexPath.row] objectForKey:@"address"];
    [la sizeToFit];
    if (la.height>30) {
        la.height=30*self.scale;
    }
    
    
    UILabel *buss = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width-130*self.scale, 10)];
    buss.text=[_dataSource[indexPath.row] objectForKey:@"summary"];
    if ([buss.text isEqualToString:@""]) {
        buss.text=@"暂无简介";
    }
    buss.font=SmallFont(self.scale);
    buss.numberOfLines=0;
    [buss sizeToFit];
    if (buss.height>30) {
        buss.height=30*self.scale;
    }
    if (buss.height<20*self.scale) {
        buss.height=20*self.scale;
    }
    
//    UILabel *add = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width-120*self.scale, 10)];
//    add.text=[_dataSource[indexPath.row] objectForKey:@"notice"];
//    if ([add.text isEqualToString:@""]) {
//        add.text=@"暂无公告";
//    }
//    add.font=SmallFont(self.scale);
//    add.numberOfLines=0;
//    [add sizeToFit];
//    if (add.height>35) {
//        add.height=35*self.scale;
//    }
//
    
    
    float h = la.height+ 60*self.scale+buss.height;//+add.height;
    if ([_dataSource[indexPath.row] objectForKey:@"rating"]==nil || [[_dataSource[indexPath.row] objectForKey:@"rating"]isEqualToString:@""]) {
        h=h-15*self.scale;
    }
    
    
    return h+0*self.scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed=YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL issleep;
    
    BreakfastCellTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@",cell.addLa.text);
    
    if ([cell.addLa.text isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
        issleep=YES;
    }else{
        issleep=NO;
    }
    
    
    
    
    if ([_dataSource[indexPath.row][@"shop_type"] isEqualToString:@"2"]) {
        
        GanXiShopViewController *shangjia = [GanXiShopViewController new];
        if ([_dataSource[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
            shangjia.isOpen=NO;
        }else{
            shangjia.isOpen=YES;
        }
        shangjia.gonggao = [_dataSource[indexPath.row] objectForKey:@"notice"];
        shangjia.issleep=issleep;
        shangjia.ID = _dataSource[indexPath.row][@"shop_id"];
        shangjia.titlee=_dataSource[indexPath.row][@"shop_name"];
        shangjia.shop_user_id =_dataSource[indexPath.row][@"shop_user_id"];
        [self.navigationController pushViewController:shangjia animated:YES];
        
        
    }else{
    
    
    
    BreakInfoViewController *info = [BreakInfoViewController new];
        if ([_dataSource[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
            info.isopen=NO;
        }else{
            info.isopen=YES;
        }
        info.tel=[NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"hotline"]];
            info.titlete=[_dataSource[indexPath.row] objectForKey:@"shop_name"];
            info.shopImg = [_dataSource[indexPath.row] objectForKey:@"logo"];
            info.gonggao = [_dataSource[indexPath.row] objectForKey:@"notice"];
            info.yunfei =[_dataSource[indexPath.row] objectForKey:@"delivery_fee"];
            info.manduoshaofree=[_dataSource[indexPath.row] objectForKey:@"free_delivery_amount"];
        info.issleep=issleep;
            info.shop_user_id=[_dataSource[indexPath.row] objectForKey:@"shop_user_id"];
        [info reshshocuang:^(NSString *str) {
            //    _index=0;
            //    [self reshData];

 
        }];
    
    info.ID =_dataSource[indexPath.row][@"shop_id"];
      [self.navigationController pushViewController:info animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        AnalyzeObject *anle = [AnalyzeObject new];
        NSDictionary *dic = @{@"user_id":[self getuserid],@"collect_id":_dataSource[indexPath.row][@"shop_id"]};
        
        [anle delCollectWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"0"]) {
                _index=0;
                [self reshData];
            }
        }];
        
        
        
    }


}
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"收藏的店铺";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}
-(void)PopVC:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
}
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
