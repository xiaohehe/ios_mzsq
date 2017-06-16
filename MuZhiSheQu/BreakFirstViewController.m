//
//  BreakFirstViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BreakFirstViewController.h"
#import "BreakfastCellTableViewCell.h"
#import "BreakInfoViewController.h"
#import "UmengCollection.h"
@interface BreakFirstViewController ()<UITextFieldDelegate>
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)int typee;
@property(nonatomic,strong)UITextField *searchText;
@property(nonatomic,strong)UILabel *la;
@end

@implementation BreakFirstViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _data=[NSMutableArray new];
    _index=0;
    _typee=0;
    [self searchView];
    [self TableView];
    [self returnVi];
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    [self ReshData];
   // NSLog(@"--namet--%@",self.namet);
}

//-(void)keyboredxiA{
//    _typee=0;
//    _index=0;
//    [self ReshData];
//
//
//}

-(void)ReshData
{
    

    [self.appdelegate dingwei];
    _index++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    
    NSDictionary *dic = @{@"shop_type": self.shop_type,@"is_weishop":self.is_weishop,@"pindex":index,@"profession_class":self.ID,@"community_id":[self getCommid],@"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],@"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]]};
    if (_typee==1) {
        dic = @{@"shop_type": self.shop_type,@"is_weishop":self.is_weishop,@"pindex":index,@"profession_class":self.ID,@"community_id":[self getCommid],@"key":_searchText.text,@"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],@"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]]};
    }
    
    
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    [analyze queryShopByKeyAndProwithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        if (_index==1) {
            [_data removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {

            [_data addObjectsFromArray:models];
            
        }
        [_la removeFromSuperview];
        if (_data.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
            _la.text=@"暂无店铺信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:_la];
        }
        
        
//        if (_data.count==1) {
//            self.hidesBottomBarWhenPushed=YES;
//            NSString *ID = [_data[0]objectForKey:@"id"];
//            
//            if ([self.shop_type isEqualToString:@"2"]) {
//                GanXiShopViewController *ganxi = [GanXiShopViewController new];
//                ganxi.ID=ID;
//                ganxi.titlee=[_data[0] objectForKey:@"shop_name"];
//                ganxi.topSetimg = [_data[0] objectForKey:@"logo"];
//                ganxi.shop_user_id=[_data[0] objectForKey:@"shop_user_id"];
//                [self.navigationController pushViewController:ganxi animated:YES];
//                
//            }else{
//                
//                
//                BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
//                info.ID=ID;
//                info.titlete=[_data[0] objectForKey:@"shop_name"];
//                info.shopImg = [_data[0] objectForKey:@"logo"];
//                info.gonggao = [_data[0] objectForKey:@"notice"];
//                info.yunfei =[_data[0] objectForKey:@"delivery_fee"];
//                info.manduoshaofree=[_data[0] objectForKey:@"free_delivery_amount"];
//                info.shop_user_id=[_data[0] objectForKey:@"shop_user_id"];
//                [self.navigationController pushViewController:info animated:YES];
//                
//            }
//
//        }
        

        [_table reloadData];
        [self.activityVC stopAnimate];
        
    }];
    
    [_table.footer endRefreshing];
    [_table.header endRefreshing];
    
    

    
    
    
    [self ReshView];
    
}
-(void)ReshView{

    
    
    
    
}
#pragma mark -----返回按钮
-(void)returnVi{

    self.TitleLabel.text = self.namet;
//    NSString *addrss = [[NSUserDefaults standardUserDefaults]objectForKey:@"commname"];
//    
//    
//    self.TitleLabel.text=addrss;
//    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -------搜索框
-(void)searchView{
    UIImageView *SearchBG=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, self.NavImg.bottom+8*self.scale, self.view.width-20*self.scale, 32*self.scale)];
    SearchBG.image=[UIImage setImgNameBianShen:@"gg_pingjia_box"];
    SearchBG.userInteractionEnabled=YES;
    [self.view addSubview:SearchBG];
    
    UIImageView *IconImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SearchBG.height, SearchBG.height)];
    IconImage.image=[UIImage imageNamed:@"search"];
    [SearchBG addSubview:IconImage];
    _searchText=[[UITextField alloc]initWithFrame:CGRectMake(IconImage.right, 0, SearchBG.width-IconImage.right-5 , SearchBG.height)];
    _searchText.font=DefaultFont(self.scale);
    _searchText.placeholder=@"请输入店名/商品";
    _searchText.delegate=self;
    [SearchBG addSubview:_searchText];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)TextFieldChange{
    if ([_searchText.text isEqualToString:@""]) {
        _typee=0;
    }else{
        _typee=1;
    }

        _index=0;
        [self ReshData];


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark---------表试图
-(void)TableView{
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+65/2.25*self.scale+20, self.view.bounds.size.width, self.view.bounds.size.height-84-65/2.25*self.scale)];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.backgroundColor=superBackgroundColor;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    [self.table registerClass:[BreakfastCellTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    [_table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
    
}

-(void)xiala{
    _index=0;
    [self ReshData];
}
-(void)shangla{
    [self ReshData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    //-----------------是否休息判断
    
    UILabel *add = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width-120*self.scale, 10)];
    
    add.font=SmallFont(self.scale);
    add.numberOfLines=0;
    
    BOOL isSleep1=YES;
    BOOL isSleep2=YES;
    BOOL isSleep3=YES;
    
    NSArray *timArr  = [_data[indexPath.row][@"business_hour"] componentsSeparatedByString:@","];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *nowFo = [[NSDateFormatter alloc]init];
    [nowFo setDateFormat:@"yyyy-MM-dd"];
    NSString *noewyers = [nowFo stringFromDate:now];
    
    for (NSString *str in timArr) {
        if ([str isEqualToString:@"1"]) {
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_start_hour1"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_end_hour1"]]];
            
            
            
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
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_start_hour2"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_end_hour2"]]];
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
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_start_hour3"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_end_hour3"]]];
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
        add.text=[_data[indexPath.row] objectForKey:@"notice"];
        if ([add.text isEqualToString:@""]) {
            add.text=@"暂无公告";
        }
        
    }else{
        add.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
        
    }
    
    if ([_data[indexPath.row][@"business_hour"] isEqualToString:@""]) {
        add.text=[_data[indexPath.row] objectForKey:@"notice"];
        if ([add.text isEqualToString:@""]) {
            add.text=@"暂无公告";
        }
        
    }
    
    if ([_data[indexPath.row][@"status"] isEqualToString:@"3"]) {
        add.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
    }else{
        NSString *week = [self weekdayStringFromDate:[NSDate date]];
        if ([week isEqualToString:@"周六"]) {
            if ([_data[indexPath.row][@"off_on_saturday"] isEqualToString:@"2"]) {
                add.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
            }
        }else if ([week isEqualToString:@"周日"]){
            if ([_data[indexPath.row][@"off_on_sunday"] isEqualToString:@"2"]) {
                add.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
            }
        }
    }
    
    if ([add.text isEqualToString:@""]) {
        add.text=@"暂无公告";
    }
    

    [add sizeToFit];
    if (add.height>30*self.scale) {
        add.height=30*self.scale;
    }
    if (add.height<20*self.scale) {
        add.height=20*self.scale;
    }
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width-180*self.scale, 10)];
    la.font=DefaultFont(self.scale);
    la.numberOfLines=0;
    la.text=[_data[indexPath.row] objectForKey:@"address"];
    [la sizeToFit];
    if (la.height>30*self.scale) {
        la.height=30*self.scale;
    }
    
    
    
    UILabel *buss = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width-130*self.scale, 10)];
    buss.text=[_data[indexPath.row] objectForKey:@"summary"];
    if ([buss.text isEqualToString:@""]) {
        buss.text=@"暂无简介";
    }
    buss.font=SmallFont(self.scale);
    buss.numberOfLines=0;
    [buss sizeToFit];
    if (buss.height>30*self.scale) {
        buss.height=30*self.scale;
    }
    if (buss.height<20*self.scale) {
     //   buss.height=20*self.scale;
    }
    

    
    
    
    
    float h = la.height+ 60*self.scale+buss.height+add.height;
    if ([_data[indexPath.row] objectForKey:@"rating"]==nil || [[_data[indexPath.row] objectForKey:@"rating"]isEqualToString:@""]) {
        h=h-15*self.scale;
    }
    
    
    
    
    
    return h+0*self.scale;
    

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    BreakfastCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.addressImg.image = [UIImage imageNamed:@"address"];
    cell.addImg.image = [UIImage imageNamed:@"xiaoxi"];
    if (_data.count<=0) {
        return cell;
    }
    
    NSString *url=@"";
    NSString *cut = [_data[indexPath.row] objectForKey:@"logo"];
    NSString *imagename = [cut lastPathComponent];
    NSString *path = [cut stringByDeletingLastPathComponent];
    NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb320."]];
//    if (cut.length>0) {
//        url = [cut substringToIndex:[cut length] - 4];
//
//    }
    
    [cell.headImg setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
    cell.headImg.contentMode=UIViewContentModeScaleAspectFill;
    cell.headImg.clipsToBounds=YES;

    if ([[NSString stringWithFormat:@"%@",_data[indexPath.row][@"is_auth"]] isEqualToString:@"2"]) {
        cell.renZheng.hidden=NO;
        cell.isJin=YES;

    }else{
        cell.renZheng.hidden=YES;
        cell.isJin=NO;

    }
    
    cell.titleLa.text =[_data[indexPath.row] objectForKey:@"shop_name"];
    cell.StartNumber=[_data[indexPath.row] objectForKey:@"rating"];
    cell.contextLa.text = [_data[indexPath.row] objectForKey:@"summary"];
    if ([cell.contextLa.text isEqualToString:@""]) {
        cell.contextLa.text=@"暂无简介";
    }
    cell.addressLa.text = [_data[indexPath.row] objectForKey:@"address"];
    
    float dis = [[_data[indexPath.row] objectForKey:@"distance"] floatValue];
    
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

//    BOOL xieye=NO;
//    BOOL liu = NO;
//    BOOL tian = NO;
    
#pragma mark-----通
    
    
    
    //-----------------是否休息判断
    
    
    if ([_data[indexPath.row][@"status"] isEqualToString:@"3"]) {
        cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
        cell.addLa.textColor=[UIColor redColor];
        
        return cell;
    }else{
        NSString *week = [self weekdayStringFromDate:[NSDate date]];
        if ([week isEqualToString:@"周六"]) {
            if ([_data[indexPath.row][@"off_on_saturday"] isEqualToString:@"2"]) {
                cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
                cell.addLa.textColor=[UIColor redColor];
                return cell;
            }
        }else if ([week isEqualToString:@"周日"]){
            if ([_data[indexPath.row][@"off_on_sunday"] isEqualToString:@"2"]) {
                cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
                cell.addLa.textColor=[UIColor redColor];
                return cell;
            }
        }
    }
    
    BOOL isSleep1=YES;
    BOOL isSleep2=YES;
    BOOL isSleep3=YES;
    
    
    NSArray *timArr  = [_data[indexPath.row][@"business_hour"] componentsSeparatedByString:@","];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *nowFo = [[NSDateFormatter alloc]init];
    [nowFo setDateFormat:@"yyyy-MM-dd"];
    NSString *noewyers = [nowFo stringFromDate:now];
    
    for (NSString *str in timArr) {
        if ([str isEqualToString:@"1"]) {
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_start_hour1"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_end_hour1"]]];
            
            
            
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
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_start_hour2"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_end_hour2"]]];
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
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_start_hour3"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_end_hour3"]]];
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
        
        cell.addLa.text = [_data[indexPath.row] objectForKey:@"notice"];
        //        cell.addLa.textColor=blueTextColor;
        cell.addLa.textColor=[UIColor colorWithRed:0/255.0 green:134/255.0 blue:237/255.0 alpha:1];
        if ([cell.addLa.text isEqualToString:@""]) {
            cell.addLa.text=@"暂无公告";
        }
        
    }else{
        cell.addLa.text = @"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
        cell.addLa.textColor=[UIColor redColor];
        
    }
    
    if ([_data[indexPath.row][@"business_hour"] isEqualToString:@""]) {
        cell.addLa.text = [_data[indexPath.row] objectForKey:@"notice"];
//        cell.addLa.textColor=blueTextColor;
        cell.addLa.textColor =  [UIColor colorWithRed:0/255.0 green:134/255.0 blue:237/255.0 alpha:1];
        if ([cell.addLa.text isEqualToString:@""]) {
            cell.addLa.text=@"暂无公告";
        }
        
    }
    
    
    //-----------------是否休息判断end


    
    
//    if (_data.count==1) {
//        self.hidesBottomBarWhenPushed=YES;
//        
//        BOOL issleep;
//        if ([cell.addLa.text isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
//            issleep=YES;
//            return cell;
//        }else{
//            issleep=NO;
//        }
//        
//        
//        
//        
//        NSString *ID = [_data[0]objectForKey:@"id"];
//        
//        if ([self.shop_type isEqualToString:@"2"]) {
//            GanXiShopViewController *ganxi = [GanXiShopViewController new];
//            ganxi.ID=ID;
//            ganxi.gonggao = [_data[0] objectForKey:@"notice"];
//            if ([_data[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
//                ganxi.isOpen=NO;
//            }else{
//                ganxi.isOpen=YES;
//            }
//            ganxi.issleep=issleep;
//            ganxi.titlee=[_data[0] objectForKey:@"shop_name"];
//            ganxi.topSetimg = [_data[0] objectForKey:@"logo"];
//            ganxi.shop_user_id=[_data[0] objectForKey:@"shop_user_id"];
//            [self.navigationController pushViewController:ganxi animated:YES];
//            
//        }else{
//            
//            
//            BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
//            info.ID=ID;
//            if ([_data[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
//                info.isopen=NO;
//            }else{
//                info.isopen=YES;
//            }
//            info.issleep=issleep;
//            info.titlete=[_data[0] objectForKey:@"shop_name"];
//            info.shopImg = [_data[0] objectForKey:@"logo"];
//            info.gonggao = [_data[0] objectForKey:@"notice"];
//            info.yunfei =[_data[0] objectForKey:@"delivery_fee"];
//            info.manduoshaofree=[_data[0] objectForKey:@"free_delivery_amount"];
//            info.shop_user_id=[_data[0] objectForKey:@"shop_user_id"];
//            [self.navigationController pushViewController:info animated:YES];
//            
//        }
//        
//    }
    
    
    

    
    
    
    
#pragma mark==------rr
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
////-----------------是否休息判断
//    if ([_data[indexPath.row][@"status"] isEqualToString:@"3"]) {
//         cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//        cell.addLa.textColor=[UIColor redColor];
//        xieye=YES;
//
////        return cell;
//    }else{
//       NSString *week = [self weekdayStringFromDate:[NSDate date]];
//        if ([week isEqualToString:@"周六"]) {
//            if ([_data[indexPath.row][@"off_on_saturday"] isEqualToString:@"2"]) {
//                cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//                cell.addLa.textColor=[UIColor redColor];
////                return cell;
//                liu=YES;
//            }
//        }else if ([week isEqualToString:@"周日"]){
//            if ([_data[indexPath.row][@"off_on_sunday"] isEqualToString:@"2"]) {
//                cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//                cell.addLa.textColor=[UIColor redColor];
////                return cell;
//                tian=YES;
//            }
//        }
//    }
//    
//    
////判断是否休息的bool值
//    
//    BOOL isSleep1=NO;
//    BOOL isSleep2=NO;
//    BOOL isSleep3=NO;
//    
////    BOOL isSleep=YES;
//    
//    
//    NSArray *timArr  = [_data[indexPath.row][@"business_hour"] componentsSeparatedByString:@","];
//    
//    NSDate *now = [NSDate date];
//    NSDateFormatter *nowFo = [[NSDateFormatter alloc]init];
//    [nowFo setDateFormat:@"yyyy-MM-dd"];
//    NSString *noewyers = [nowFo stringFromDate:now];
//
//    for (NSString *str in timArr) {
//        if ([str isEqualToString:@"1"]) {
//            
//            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_start_hour1"]]];
//            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_end_hour1"]]];
//            NSDateFormatter *fo = [[NSDateFormatter alloc]init];
//            [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            
//            
//            NSDate *das = [fo dateFromString:timeStart1];
//            
//            NSDate *dad = [fo dateFromString:timeEnd1];
//            
//            
//            NSDate *dates = [self getNowDateFromatAnDate:das];
//            NSDate *dated = [self getNowDateFromatAnDate:dad];
//            NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
//            
//            //开始的时间戳
//            double times = [dates timeIntervalSince1970];
//            //结束的时间戳
//            double timed = [dated timeIntervalSince1970];
//            //现在的时间戳
//            double timen = [daten timeIntervalSince1970];
//            
//            
//            
//            if (timen>times && timen<timed) {
//                isSleep1=NO;
//            }else{
//                isSleep1=YES;
//            }
//            
//
//
//        }
//        
//        
//        
//        
//       else if ([str isEqualToString:@"2"]) {
//           
//           NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_start_hour2"]]];
//           NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_end_hour2"]]];
//           NSDateFormatter *fo = [[NSDateFormatter alloc]init];
//           [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//           NSDate *das = [fo dateFromString:timeStart1];
//           NSDate *dad = [fo dateFromString:timeEnd1];
//           
//           
//           NSDate *dates = [self getNowDateFromatAnDate:das];
//           NSDate *dated = [self getNowDateFromatAnDate:dad];
//           NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
//           
//    //开始的时间戳
//           double times = [dates timeIntervalSince1970];
//    //结束的时间戳
//           double timed = [dated timeIntervalSince1970];
//    //现在的时间戳
//           double timen = [daten timeIntervalSince1970];
//           
//           
//
//           if (timen>times && timen<timed) {
//               isSleep2=NO;
//           }else{
//               isSleep2=YES;
//           }
//           
//           
//
//        }
//        
//        
//      else  if ([str isEqualToString:@"3"]) {
//          
//          NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_start_hour3"]]];
//          NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[indexPath.row][@"business_end_hour3"]]];
//          NSDateFormatter *fo = [[NSDateFormatter alloc]init];
//          [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//          NSDate *das = [fo dateFromString:timeStart1];
//          NSDate *dad = [fo dateFromString:timeEnd1];
//          
//          NSDate *dates = [self getNowDateFromatAnDate:das];
//          NSDate *dated = [self getNowDateFromatAnDate:dad];
//          NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
//          
//          //开始的时间戳
//          double times = [dates timeIntervalSince1970];
//          //结束的时间戳
//          double timed = [dated timeIntervalSince1970];
//          //现在的时间戳
//          double timen = [daten timeIntervalSince1970];
//          
//          
//          
//          if (timen>times && timen<timed) {
//              isSleep3=NO;
//          }else{
//              isSleep3=YES;
//          }
//
//        }
//        
//        
//    }
////-----------------
////    if (isSleep1==NO || isSleep2==NO || isSleep3==NO) {
////        
////        cell.addLa.text = [_data[indexPath.row] objectForKey:@"notice"];
////        cell.addLa.textColor=blueTextColor;
////        
////    }else{
////        cell.addLa.text = @"商铺正在休息中！";
////        cell.addLa.textColor=[UIColor redColor];
////        
////    }
//    
//
//    
//    
//    if (isSleep1==YES || isSleep2==YES || isSleep3==YES) {
//        cell.addLa.text = @"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//        cell.addLa.textColor=[UIColor redColor];
//
//    }else{
//        cell.addLa.text = [_data[indexPath.row] objectForKey:@"notice"];
//        if ([cell.addLa.text isEqualToString:@""]) {
//            cell.addLa.text=@"暂无公告";
//        }
//
//    }
//    
//    if ([_data[indexPath.row][@"business_hour"] isEqualToString:@""]) {
//        cell.addLa.text = [_data[indexPath.row] objectForKey:@"notice"];
//        if ([cell.addLa.text isEqualToString:@""]) {
//            cell.addLa.text=@"暂无公告";
//        }
//
//    }
//    
//    if (xieye==YES) {
//        cell.addLa.text = @"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//        cell.addLa.textColor=[UIColor redColor];
//    }
//    if (liu || tian) {
//        cell.addLa.text = @"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//        cell.addLa.textColor=[UIColor redColor];
//    }
//   
//    
//    if (_data.count==1) {
//        self.hidesBottomBarWhenPushed=YES;
//        
//        
//        BOOL issleep;
//        if ([cell.addLa.text isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
//            issleep=YES;
//            return cell;
//        }else{
//            issleep=NO;
//        }
//        
//
//        
//        
//        NSString *ID = [_data[0]objectForKey:@"id"];
//        
//        if ([self.shop_type isEqualToString:@"2"]) {
//            GanXiShopViewController *ganxi = [GanXiShopViewController new];
//            ganxi.ID=ID;
//            ganxi.gonggao = [_data[0] objectForKey:@"notice"];
//            if ([_data[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
//                ganxi.isOpen=NO;
//            }else{
//                ganxi.isOpen=YES;
//            }
//            ganxi.issleep=issleep;
//            ganxi.titlee=[_data[0] objectForKey:@"shop_name"];
//            ganxi.topSetimg = [_data[0] objectForKey:@"logo"];
//            ganxi.shop_user_id=[_data[0] objectForKey:@"shop_user_id"];
//            [self.navigationController pushViewController:ganxi animated:YES];
//            
//        }else{
//            
//            
//            BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
//            info.ID=ID;
//            if ([_data[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
//                info.isopen=NO;
//            }else{
//                info.isopen=YES;
//            }
//            info.issleep=issleep;
//            info.titlete=[_data[0] objectForKey:@"shop_name"];
//            info.shopImg = [_data[0] objectForKey:@"logo"];
//            info.gonggao = [_data[0] objectForKey:@"notice"];
//            info.yunfei =[_data[0] objectForKey:@"delivery_fee"];
//            info.manduoshaofree=[_data[0] objectForKey:@"free_delivery_amount"];
//            info.shop_user_id=[_data[0] objectForKey:@"shop_user_id"];
//            [self.navigationController pushViewController:info animated:YES];
//            
//        }
//        
//    }
//
//    
//    
////-----------------是否休息判断end
    
    return cell;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed=YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *ID = [_data[indexPath.row]objectForKey:@"id"];

    BOOL issleep;
    BreakfastCellTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.addLa.text isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
        issleep=YES;
    }else{
        issleep=NO;
    }
    
    
    if ([self.shop_type isEqualToString:@"2"]) {
        GanXiShopViewController *ganxi = [GanXiShopViewController new];
        if ([_data[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
            ganxi.isOpen=NO;
        }else{
            ganxi.isOpen=YES;
        }
        ganxi.ID=ID;
        ganxi.gonggao = [_data[indexPath.row] objectForKey:@"notice"];
        ganxi.issleep=issleep;
        ganxi.titlee=[_data[indexPath.row] objectForKey:@"shop_name"];
        ganxi.topSetimg = [_data[indexPath.row] objectForKey:@"logo"];
        ganxi.shop_user_id=[_data[indexPath.row] objectForKey:@"shop_user_id"];
        [self.navigationController pushViewController:ganxi animated:YES];
        
    }else{
        
        
        BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
        
        if ([_data[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
            info.isopen=NO;
        }else{
            info.isopen=YES;
        }
        info.tel=[NSString stringWithFormat:@"%@",[_data[indexPath.row] objectForKey:@"hotline"]];
        info.ID=ID;
        info.titlete=[_data[indexPath.row] objectForKey:@"shop_name"];
        info.shopImg = [_data[indexPath.row] objectForKey:@"logo"];
        info.gonggao = [_data[indexPath.row] objectForKey:@"notice"];
        info.yunfei =[_data[indexPath.row] objectForKey:@"delivery_fee"];
        info.manduoshaofree=[_data[indexPath.row] objectForKey:@"free_delivery_amount"];
        info.shop_user_id=[_data[indexPath.row] objectForKey:@"shop_user_id"];
        info.issleep=issleep;
        [self.navigationController pushViewController:info animated:YES];

    }

    
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
