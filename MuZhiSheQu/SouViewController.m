//
//  SouViewController.m
//  MuZhiSheQu
//
//  Created by lmy on 2016/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SouViewController.h"
#import "SouListCell.h"
#import "ShopInfoViewController.h"
#import "BreakfastCellTableViewCell.h"

#import "BreakInfoViewController.h"

@interface SouViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *la;
@end
@implementation SouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data=[NSMutableArray new];
    _index=0;
    if ([_shop_id isEqualToString:@""] || [_shop_id isEqual:[NSNull null]] || _shop_id == nil)
    {
        _shop_id = @"";
    }
    [self returnVi];
    [self newView];
    [self.view addSubview:self.activityVC];
    UITextField *tf=[self.view viewWithTag:888];
    tf.text=_keyword;
    [self reshData];
}
-(void)reshData{
    _index++;
    self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    [self.activityVC startAnimating];
    UITextField *tf=[self.view viewWithTag:888];
    AnalyzeObject *anal=[AnalyzeObject new];
    NSDictionary *dic=@{@"keyword":tf.text.trimString,
                        @"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],
                        @"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]],
                        @"pindex":[NSString stringWithFormat:@"%ld",(long)_index],
                        @"community_id":self.commid,@"shop_id":_shop_id};
    
    [anal shouYeSouList:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if (_index==1) {
            [_data removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {
            [_data addObjectsFromArray:models];
        }
        [_tableView reloadData];
        if (_la) {
            [_la removeFromSuperview];
        }
        if (_data.count<=0)
        {
            _la = [[UILabel alloc]initWithFrame:self.view.bounds];
            _la.alpha=.6;
            _la.font=DefaultFont(self.scale);
            _la.text=@"暂无内容！";
            _la.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:_la];
        }
    }];
}
-(void)shangla{
    [self reshData];
}
-(void)xiala{
    _index=0;
    [self reshData];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    _index=0;
    [self reshData];
    return YES;
}
-(void)newView{
    self.view.backgroundColor=superBackgroundColor;
    UIImageView *souVi=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 64+10*self.scale, self.view.width-20*self.scale, 30*self.scale)];
    souVi.layer.cornerRadius=5;
    souVi.userInteractionEnabled=YES;
    souVi.backgroundColor=whiteLineColore;
    souVi.layer.borderWidth=1;
    souVi.layer.borderColor=[[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1] CGColor];
    [self.view addSubview:souVi];
    
    UIImageView *souImg=[[UIImageView alloc]initWithFrame:CGRectMake(5*self.scale, 3*self.scale, souVi.height-6*self.scale, souVi.height-6*self.scale)];
    souImg.image=[UIImage imageNamed:@"so_1"];
    [souVi addSubview:souImg];
    
    UITextField *souTf=[[UITextField alloc]initWithFrame:CGRectMake(souImg.right+5*self.scale, 0, souVi.width-souImg.right, souVi.height)];
    souTf.placeholder=@"请你输入想要买的商品名称";
    [souTf setValue:[UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    souTf.textColor=[UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1];
    souTf.font=SmallFont(self.scale);
    souTf.tag=888;
    souTf.delegate=self;
    souTf.returnKeyType=UIReturnKeySearch;
    [souVi addSubview:souTf];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, souVi.bottom+10*self.scale, self.view.width, self.view.height-souVi.bottom-10*self.scale) style:UITableViewStylePlain];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
    [_tableView registerClass:[SouListCell class] forCellReuseIdentifier:@"SouListCell"];
    [self.view addSubview:_tableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SouListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SouListCell" forIndexPath:indexPath];
   [cell.headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_data[indexPath.row][@"img1"]]] placeholderImage:[UIImage imageNamed:@"za"]];
    cell.titleLa.text=[NSString stringWithFormat:@"%@",_data[indexPath.row][@"prod_name"]];
    cell.salesLa.text=[NSString stringWithFormat:@"销量：%@",_data[indexPath.row][@"sales"]];
    

    NSString *priceStr=[NSString stringWithFormat:@"价格：%@元/%@",_data[indexPath.row][@"price"],_data[indexPath.row][@"unit"]];
    
    
    
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:priceStr];
    NSRange range=[priceStr rangeOfString:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@元/%@",_data[indexPath.row][@"price"],_data[indexPath.row][@"unit"]]]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:0 blue:0 alpha:1] range:range];
    NSRange range1=[priceStr rangeOfString:@"价格："];
    [str addAttribute:NSForegroundColorAttributeName value:grayTextColor range:range1];
    cell.priceLa.attributedText=str;
    
    cell.price_yuan.text=[NSString stringWithFormat:@"￥%@",_data[indexPath.row][@"origin_price"]];
    
//    if ([[NSString stringWithFormat:@"%@",_data[indexPath.row][@"origin_price"]] isEqualToString:[NSString stringWithFormat:@"%@",_data[indexPath.row][@"price"]]]) {
//        cell.price_yuan.hidden=YES;
//        cell.lin.hidden=YES;
//    }else{
//        cell.price_yuan.hidden=NO;
//        cell.lin.hidden=NO;
//    }
//    
    
    
    float yuan = [[NSString stringWithFormat:@"%@",_data[indexPath.row][@"origin_price"]] floatValue];
    float xian = [[NSString stringWithFormat:@"%@",_data[indexPath.row][@"price"]] floatValue];
    
    if (xian>=yuan) {
        cell.price_yuan.hidden=YES;
        cell.lin.hidden=YES;
    }else{
        cell.price_yuan.hidden=NO;
        cell.lin.hidden=NO;
    }
    
    NSString * miaoShu = [NSString stringWithFormat:@"%@",_data[indexPath.row][@"description"]];
    //如果没有描述的话就显示商店的名称
    if ([miaoShu isEqualToString:@""] || [miaoShu isEqual:[NSNull null]] || miaoShu == nil || [miaoShu isEqualToString:@"(null)"])
    {
        cell.noMiaoShuShopName.hidden = NO;
        cell.ShopName.hidden = YES;
        cell.noMiaoShuShopName.text  = [NSString stringWithFormat:@"来自%@",_data[indexPath.row][@"shop_name"]];
        cell.desLa.hidden =  YES;
       
    }
    else
    {
        cell.ShopName.text = [NSString stringWithFormat:@"来自%@",_data[indexPath.row][@"shop_name"]];
        cell.ShopName.hidden = NO;
        cell.noMiaoShuShopName.hidden = YES;
        cell.desLa.hidden = NO;
        
        cell.desLa.text=[NSString stringWithFormat:@"%@",_data[indexPath.row][@"description"]];
    }
        
                          

    
  
    
    if (indexPath.row<_data.count-1) {
        cell.isShort=YES;
    }else{
        cell.isShort=NO;
    }
    
    
    
    
    
    
    
    
    
    
    
    //-----------------是否休息判断
    
    
    if ([_data[indexPath.row][@"status"] isEqualToString:@"3"]) {
        cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
        cell.addLa.textColor=[UIColor clearColor];
        
        return cell;
    }else{
        NSString *week = [self weekdayStringFromDate:[NSDate date]];
        if ([week isEqualToString:@"周六"]) {
            if ([_data[indexPath.row][@"off_on_saturday"] isEqualToString:@"2"]) {
                cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
                cell.addLa.textColor=[UIColor clearColor];
                return cell;
            }
        }else if ([week isEqualToString:@"周日"]){
            if ([_data[indexPath.row][@"off_on_sunday"] isEqualToString:@"2"]) {
                cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
                cell.addLa.textColor=[UIColor clearColor];
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
        
        //        cell.addLa.text = [_dataSource[indexPath.row] objectForKey:@"notice"];
        //        cell.addLa.textColor=blueTextColor;
        
    }else{
        cell.addLa.text = @"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
        cell.addLa.textColor=[UIColor clearColor];
        
    }
    
    if ([_data[indexPath.row][@"business_hour"] isEqualToString:@""]) {
        cell.addLa.text = [_data[indexPath.row] objectForKey:@"notice"];
        
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * miaoShu = [NSString stringWithFormat:@"%@",_data[indexPath.row][@"description"]];
    if ([miaoShu isEqualToString:@""] || [miaoShu isEqual:[NSNull null]] || miaoShu == nil || [miaoShu isEqualToString:@"(null)"])
    {
       return 95*self.scale;
    }
    else
    {
        return 115*self.scale;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hidesBottomBarWhenPushed=YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //NSString *ID = [_data[indexPath.row]objectForKey:@"id"];
    
    BOOL issleep;
    BreakfastCellTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.addLa.text isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
        issleep=YES;
    }else{
        issleep=NO;
    }
    
    
//    if ([self.shop_type isEqualToString:@"2"]) {
//        GanXiShopViewController *ganxi = [GanXiShopViewController new];
//        if ([_data[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
//            ganxi.isOpen=NO;
//        }else{
//            ganxi.isOpen=YES;
//        }
//        ganxi.ID=ID;
//        ganxi.gonggao = [_data[indexPath.row] objectForKey:@"notice"];
//        ganxi.issleep=issleep;
//        ganxi.titlee=[_data[indexPath.row] objectForKey:@"shop_name"];
//        ganxi.topSetimg = [_data[indexPath.row] objectForKey:@"logo"];
//        ganxi.shop_user_id=[_data[indexPath.row] objectForKey:@"shop_user_id"];
//        [self.navigationController pushViewController:ganxi animated:YES];
//        
//    }else{
//    
//        
//        BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
//        
//        if ([_data[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
//            info.isopen=NO;
//        }else{
//            info.isopen=YES;
//        }
//        info.tel=[NSString stringWithFormat:@"%@",[_data[indexPath.row] objectForKey:@"hotline"]];
//        info.ID=ID;
//        info.titlete=[_data[indexPath.row] objectForKey:@"shop_name"];
//        info.shopImg = [_data[indexPath.row] objectForKey:@"logo"];
//        info.gonggao = [_data[indexPath.row] objectForKey:@"notice"];
//        info.yunfei =[_data[indexPath.row] objectForKey:@"delivery_fee"];
//        info.manduoshaofree=[_data[indexPath.row] objectForKey:@"free_delivery_amount"];
//        info.shop_user_id=[_data[indexPath.row] objectForKey:@"shop_user_id"];
//        info.issleep=issleep;
//        [self.navigationController pushViewController:info animated:YES];
    
//    }
    ShopInfoViewController *buess = [ShopInfoViewController new];
    buess.isgo=YES;
    
    
    [buess reshChoucang:^(NSString *str) {
        _index=0;
        [self reshData];
        
    }];
    if ([_data[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
        buess.isopen=NO;
    }else{
        buess.isopen=YES;
    }
    buess.tel=[NSString stringWithFormat:@"%@",_data[indexPath.row][@"hotline"]];
    buess.price =_data[indexPath.row][@"prod_price"];
    buess.shop_name=_data[indexPath.row][@"shop_name"];
    buess.orshoucang=YES;
    buess.issleep=issleep;
    buess.shop_user_id=_data[indexPath.row][@"shop_user_id"];
    NSLog(@"%@",_data[indexPath.row][@"shop_user_id"]);
    buess.shop_id = _data[indexPath.row][@"shop_id"];
    buess.prod_id = _data[indexPath.row][@"id"];
    buess.xiaoliang = _data[indexPath.row][@"sales"];
    buess.shoucang = _data[indexPath.row][@"collect_time"];
    buess.gongGao = _data[indexPath.row][@"notice"];
    //    buess.yunfei=self.
    [self.navigationController pushViewController:buess animated:YES];
    
    

}
#pragma mark -----返回按钮
-(void)returnVi{
    self.TitleLabel.text=@"产品搜索列表";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
