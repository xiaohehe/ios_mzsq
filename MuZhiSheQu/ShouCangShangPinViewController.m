//
//  ShouCangShangPinViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShouCangShangPinViewController.h"
#import "ShangPinTableViewCell.h"
#import "BusinessInfoViewController.h"
#import "UmengCollection.h"
@interface ShouCangShangPinViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *la;

@end

@implementation ShouCangShangPinViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource=[NSMutableArray new];
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    [self reshData];
}


-(void)reshData{
    [_la removeFromSuperview];
    _index++;
    
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    
    AnalyzeObject *anle =[AnalyzeObject new];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    
    NSDictionary *dic = @{@"user_id":userid,@"collect_type":@"1",@"pindex":index};
    [anle getCollectListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if (_index==1) {
            [_dataSource removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {
            [_dataSource addObjectsFromArray:models];
        }
        
        if (_dataSource.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
            _la.text=@"暂无收藏商品信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:_la];
        }

        
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        [self.activityVC stopAnimate];
    }];


}


-(void)newView{
    _tableView=[[UITableView  alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
   _tableView.delegate=self;
 _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[ShangPinTableViewCell class] forCellReuseIdentifier:@"Cell"];
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


- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
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
    ShangPinTableViewCell *cell=(ShangPinTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
//    
//    NSString *url=@"";
    NSString *cut = _dataSource[indexPath.row][@"img1"];
//    if (cut.length>0) {
//        url = [cut substringToIndex:[cut length] - 4];
//        
//    }
    NSString *imagename = [cut lastPathComponent];
    NSString *path = [cut stringByDeletingLastPathComponent];
    NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb640."]];
    
//    [cell.HeaderImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb640.jpg",url]] placeholderImage:[UIImage imageNamed:@"za"]];
    [cell.HeaderImage setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
    
    
    
    
    
    
    
    cell.NameLabel.text=_dataSource[indexPath.row][@"prod_name"];
    cell.NumberLabel.text=[NSString stringWithFormat:@"销量%@",_dataSource[indexPath.row][@"sales"]];
    cell.PriceLabel.text=[NSString stringWithFormat:@"￥%@/%@",_dataSource[indexPath.row][@"price"],_dataSource[indexPath.row][@"unit"]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.price_yuan.text=[NSString stringWithFormat:@"￥%@",_dataSource[indexPath.row][@"origin_price"]];
    
//    if ([[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"origin_price"]] isEqualToString:[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"price"]]]) {
//        cell.price_yuan.hidden=YES;
//        cell.lin.hidden=YES;
//    }else{
//        cell.price_yuan.hidden=NO;
//        cell.lin.hidden=NO;
//    }
//    
    float yuan = [[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"origin_price"]] floatValue];
    float xian = [[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"price"]] floatValue];
    
    if (xian>=yuan) {
        cell.price_yuan.hidden=YES;
        cell.lin.hidden=YES;
    }else{
        cell.price_yuan.hidden=NO;
        cell.lin.hidden=NO;
    }
    
    
    
    if ([_dataSource[indexPath.row][@"status"] isEqualToString:@"3"]) {
        cell.addLa=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
        
        return cell;
    }else{
        NSString *week = [self weekdayStringFromDate:[NSDate date]];
        if ([week isEqualToString:@"周六"]) {
            if ([_dataSource[indexPath.row][@"off_on_saturday"] isEqualToString:@"2"]) {
                cell.addLa=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
                return cell;
            }
        }else if ([week isEqualToString:@"周日"]){
            if ([_dataSource[indexPath.row][@"off_on_sunday"] isEqualToString:@"2"]) {
                cell.addLa=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
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
        cell.addLa = @"";

        
    }else{
       cell.addLa = @"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
        
    }
    
    if ([_dataSource[indexPath.row][@"business_hour"] isEqualToString:@""]) {
        cell.addLa = @"";

    }
    
    
    
    
     return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*self.scale;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.hidesBottomBarWhenPushed=YES;
    
    BOOL issleep;
    
    ShangPinTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    if ([cell.addLa isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
        issleep=YES;
    }else{
        issleep=NO;
    }
    
    
    ShopInfoViewController *buess = [ShopInfoViewController new];
    [buess reshChoucang:^(NSString *str) {
        _index=0;
        [self reshData];
        
    }];
    if ([_dataSource[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
        buess.isopen=NO;
    }else{
        buess.isopen=YES;
    }
    buess.tel=[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"hotline"]];
    buess.price =_dataSource[indexPath.row][@"prod_price"];
    buess.shop_name=_dataSource[indexPath.row][@"shop_name"];
    buess.orshoucang=YES;
    buess.issleep=issleep;
    buess.shop_user_id=_dataSource[indexPath.row][@"shop_user_id"];
    NSLog(@"%@",_dataSource[indexPath.row][@"shop_user_id"]);
    buess.shop_id = _dataSource[indexPath.row][@"shop_id"];
    buess.prod_id = _dataSource[indexPath.row][@"prod_id"];
    buess.xiaoliang = _dataSource[indexPath.row][@"sales"];
    buess.shoucang = _dataSource[indexPath.row][@"collect_time"];
//    buess.yunfei=self.
    [self.navigationController pushViewController:buess animated:YES];

    
 
    
    
    

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view addSubview:self.activityVC];
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSDictionary *dic = @{@"user_id":[self getuserid],@"collect_id":_dataSource[indexPath.row][@"prod_id"]};
        
        [anle delCollectWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"0"]) {
                _index=0;
                [self reshData];
            }
            [self.activityVC stopAnimate];
        }];
        
        
        
    }
    
    
}



#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"收藏的商品";
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
