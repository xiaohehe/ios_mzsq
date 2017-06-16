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
#import "GouWuCheViewController.h"
#import "BreakInfoViewController.h"

@interface SouViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *la;
@property(nonatomic,strong)UIButton * numberImg;
//@property(nonatomic,strong)UILabel *priceLa, *shopCarLa;
@property(nonatomic,strong)NSString * carPrice;
@property(nonatomic,strong)NSDictionary * remindDic;
@property(nonatomic,strong)UILabel * peiSongLab;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)CGFloat totalPrice;

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
    _dataSource=[[NSMutableArray alloc]init];
    [self reshData];
    [self loadShopingCart];
    //NSLog(@"shop_ip:%@",_shop_id);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
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
    NSLog(@"shop_ip:%@",dic);
    [anal shouYeSouList:dic Block:^(id models, NSString *code, NSString *msg) {
        [self shangJiaXiangQing];
        [self.activityVC stopAnimate];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if (_index==1) {
            [_data removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {
            [self bottomVi];
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
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, souVi.bottom+10*self.scale, self.view.width, self.view.height-souVi.bottom-10*self.scale-49*self.scale) style:UITableViewStylePlain];
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
    NSLog(@"cell==%@",_data[indexPath.row]);
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
    if ([miaoShu isEqualToString:@""] || [miaoShu isEqual:[NSNull null]] || miaoShu == nil || [miaoShu isEqualToString:@"(null)"]){
        cell.noMiaoShuShopName.hidden = NO;
        cell.ShopName.hidden = YES;
        cell.noMiaoShuShopName.text  = [NSString stringWithFormat:@"来自%@",_data[indexPath.row][@"shop_name"]];
        cell.desLa.hidden =  YES;
    }else{
        //cell.ShopName.text = [NSString stringWithFormat:@"2来自%@",_data[indexPath.row][@"shop_name"]];
        cell.ShopName.hidden = NO;
        cell.noMiaoShuShopName.hidden = NO;
        cell.noMiaoShuShopName.text = [NSString stringWithFormat:@"来自%@",_data[indexPath.row][@"shop_name"]];
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
        }else if ([str isEqualToString:@"2"]) {
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
        }else  if ([str isEqualToString:@"3"]) {
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
    [cell.jiaBtn addTarget:self action:@selector(changeShopingCartNum:) forControlEvents:UIControlEventTouchUpInside];
    cell.jiaBtn.tag=100000+indexPath.row;
    cell.numLb.tag=200000+indexPath.row;
    [cell.jianBtn addTarget:self action:@selector(changeShopingCartNum:) forControlEvents:UIControlEventTouchUpInside];
    cell.jianBtn.tag=300000+indexPath.row;
    if (![Stockpile sharedStockpile].isLogin) {
        cell.numLb.hidden=YES;
        cell.jianBtn.hidden=YES;
    }else{
        NSString* prodID=_data[indexPath.row][@"id"];
        int* index=[self.appdelegate.shopDictionary[prodID] intValue];
        if(index>0){
            cell.numLb.hidden=NO;
            cell.jianBtn.hidden=NO;
        }else{
            cell.numLb.hidden=YES;
            cell.jianBtn.hidden=YES;
        }
        cell.numLb.text=[NSString stringWithFormat:@"%d",index];
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

/*请求购物车*/
-(void) requestShopingCart:(BOOL) isRefresh{
    [self.appdelegate.shopDictionary removeAllObjects];
    NSString *userid =  [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    if(userid==nil)
        return;
    NSDictionary *dic = @{@"user_id":userid};
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy showCartWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            NSArray* arr=models;
            NSLog(@"cart==%@",arr);
            for (int i = 0; i < arr.count; i ++) {
                NSArray * Prod_infoArr = arr[i][@"prod_info"];
                for (int j = 0; j < Prod_infoArr.count; j ++) {
                    [self.appdelegate.shopDictionary setObject:Prod_infoArr[j][@"prod_count"] forKey:Prod_infoArr[j][@"prod_id"]];
                }
            }
            if(isRefresh)
                [self xiala];
        }
    }];
}


/*更改购车车内商品数量*/
-(void)changeShopingCartNum:(UIButton *)btn{
    if ([Stockpile sharedStockpile].isLogin==NO) {
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {//登录成功后需要加载的数据
                    NSLog(@"登录成功");
                    [self requestShopingCart:true];
                }];
            }
        }];
        return;
    }
    [self.view addSubview:self.activityVC];
    //[self.activityVC startAnimate];
    NSInteger num=0;//购物车商品数量
    NSInteger index=-1;//商品项，为了获取商品id
    NSInteger tag=btn.tag;
    UILabel* numLb=nil;
    //UIScrollView * bScrollView = (UIScrollView *)[_fenLeiScrollView viewWithTag:2000+fenleiIndex];
    if (tag<200000) {
        numLb=(UILabel *)[self.view viewWithTag:200000+tag-100000];
        num=[numLb.text intValue];
        num++;
        index=tag-100000;
    }else{
        numLb=(UILabel *)[self.view viewWithTag:200000+tag-300000];
        num=[numLb.text intValue];
        num--;
        index=tag-300000;
    }
    if (num<0) {
        num=0;
    }
    NSDictionary *shopInfo = _data[index];
    NSString* prodID=shopInfo[@"id"];
    NSString* shopID=shopInfo[@"shop_id"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    //NSLog(@"prodid==%@     shopid==%@    userid==%@   num==%d",prodID,shopID,userid,num);
    NSDictionary *dicc = @{@"user_id":userid,@"prod_id":prodID,@"prod_count":[NSNumber numberWithInt:num],@"shop_id":shopID};
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle addProdWithDic:dicc Block:^(id models, NSString *code, NSString *msg) {
        NSLog(@"addcart=%@  code==%@  msg==%@",models,code,msg);
        //[self ReshBotView];
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            numLb.text=[NSString stringWithFormat:@"%d",num];
            UIButton* subBtn=(UIButton *)[self.view viewWithTag:300000+index];
            if(num==0){
                numLb.hidden=YES;
                subBtn.hidden=YES;
            }else{
                numLb.hidden=NO;
                subBtn.hidden=NO;
            }
            [self.appdelegate.shopDictionary setObject:[NSString stringWithFormat:@"%d",num] forKey:prodID];
            NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
            int cartNum=[value intValue];
            CGFloat price=[shopInfo[@"price"] floatValue];
            if(tag<200000){
                cartNum++;
                _totalPrice+=price;
            }else{
                _totalPrice-=price;
                cartNum--;
                if(cartNum<0)cartNum=0;
            }
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cartNum] forKey:@"GouWuCheShuLiang"];
            [self gouWuCheShuZi];
            _peiSongLab.text = [self xianShiPeiSongFei];
            [self.tableView reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                 initWithTitle:@"提示" // 指定标题
                                 message:msg  // 指定消息
                                 delegate:nil
                                 cancelButtonTitle:@"确定" // 为底部的取消按钮设置标题
                                 // 不设置其他按钮
                                 otherButtonTitles:nil];
            [alert show];
        }
    }];
}

#pragma mark -- 购物车的数字
- (void)gouWuCheShuZi
{
    UITabBarItem * item=[self.appdelegate.tabBarController.tabBar.items objectAtIndex:2];
    if ([Stockpile sharedStockpile].isLogin)
    {
        NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
        NSLog(@"%@",value);
        if ([value isEqualToString:@"0"])
        {
            //[item setBadgeValue:nil];
            [item setBadgeValue:@"0"];
        }
        else
        {
            [_numberImg setTitle:[NSString stringWithFormat:@"%@",value] forState:UIControlStateNormal];
            [item setBadgeValue:value];
        }
    }else{
        //[item setBadgeValue:nil];
        [item setBadgeValue:@"0"];
    }
}

#pragma mark -- 计算本店消费多少元
-  (NSMutableAttributedString *)jiSuanBenDianXiaoFei
{
    CGFloat total =0.0;
    for (NSDictionary * dic in _remindDic[@"shopping_cart_info"])
    {
        CGFloat price = [dic[@"price"] floatValue];
        NSInteger number = [dic[@"prod_count"] integerValue];
        total = total + price * number;
        
    }
    _carPrice = [NSString stringWithFormat:@"本店消费￥%.2f元",total];
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:_carPrice];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 4)];
    return attributeString;
}

#pragma mark-------底部UI设置，购物车。
-(void)bottomVi{
    if (_bottomR) {
        [_bottomR removeFromSuperview];
    }
    //右边购物车
    self.bottomR = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-58*self.scale, self.view.bounds.size.width, 58*self.scale)];
    self.bottomR.userInteractionEnabled = YES;
    //    [self.bottomR.backgroundColor =
    [self.view addSubview:_bottomR];
    if (_botRTwo) {
        [_botRTwo removeFromSuperview];
    }
    self.botRTwo = [[UIView alloc]initWithFrame:CGRectMake(0,9*self.scale, self.view.bounds.size.width, 49*self.scale)];
    _botRTwo.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    [self.bottomR addSubview:_botRTwo];
    UIButton *shopcarImgL = [[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, 0*self.scale, 49*self.scale, 49*self.scale)];
    [shopcarImgL setBackgroundImage:[UIImage imageNamed:@"gw"] forState:UIControlStateNormal];
    [shopcarImgL addTarget:self action:@selector(goShopCar) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomR addSubview:shopcarImgL];
    
    //购物车左上角的红色数字;
    _numberImg = [[UIButton alloc]initWithFrame:CGRectMake(shopcarImgL.width-15*self.scale,3*self.scale, 15*self.scale, 15*self.scale)];
    _numberImg.backgroundColor = [UIColor redColor];
    _numberImg.layer.cornerRadius=_numberImg.width/2;
    
    
    NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];

    
    [_numberImg setTitle:[NSString stringWithFormat:@"%@",value] forState:UIControlStateNormal];
   // [[NSUserDefaults standardUserDefaults] setObject:_numberImg.titleLabel.text forKey:@"GouWuCheShuLiang"];
    _numberImg.titleLabel.font = Small10Font(self.scale);
    [shopcarImgL addSubview:_numberImg];
    float r = shopcarImgL.right;
    float t = shopcarImgL.top;
    
//    _shopCarLa = [[UILabel alloc]initWithFrame:CGRectMake(r+5*self.scale,0, [UIScreen mainScreen].bounds.size.width - r - 110*self.scale , 20*self.scale)];
//    _shopCarLa.attributedText = [self jiSuanBenDianXiaoFei];
//    _shopCarLa.font=Small10Font(self.scale);
//    _shopCarLa.textColor = [UIColor redColor];
//    [self.botRTwo addSubview:_shopCarLa];
    _peiSongLab = [[UILabel alloc]initWithFrame:CGRectMake(r+5*self.scale, 14*self.scale, [UIScreen mainScreen].bounds.size.width - r - 110*self.scale, 20*self.scale)];
    _peiSongLab.text = [self xianShiPeiSongFei];
    _peiSongLab.font = Small10Font(self.scale);
    _peiSongLab.textColor = [UIColor whiteColor];
    [self.botRTwo addSubview:_peiSongLab];
    UIButton *shopCarR = [UIButton buttonWithType:UIButtonTypeSystem];
    shopCarR.frame = CGRectMake([UIScreen mainScreen].bounds.size.width -100*self.scale , 0, 100*self.scale, 49*self.scale);
    //    shopCarR.layer.cornerRadius = 3.0f;
    shopCarR.tag=907;
    //    shopCarR.userInteractionEnabled=NO;
    [shopCarR setBackgroundColor:blueTextColor];
    [shopCarR setTitle:@"结算中心" forState:UIControlStateNormal];
    shopCarR.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    [shopCarR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shopCarR addTarget:self action:@selector(godingdan) forControlEvents:UIControlEventTouchUpInside];
    [self.botRTwo addSubview:shopCarR];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _bottomL.top, self.view.width, .5)];
    line.backgroundColor=blackLineColore;
    [self.view addSubview:line];
}
    
#pragma mark -- 商家详情接口
-(void)shangJiaXiangQing{
    NSDictionary *dic=[NSDictionary new];
    dic = @{@"shop_id":self.shop_id};
    if ([Stockpile sharedStockpile].isLogin) {
        dic=@{@"user_id":[self getuserid],@"shop_id":self.shop_id};
    }
    //NSLog(@"商家详情参数==%@",dic);
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    [analyze ShopshopInfoWithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            _remindDic = models;
            //NSLog(@"商家详情==%@",models);
            //_shopCarLa.attributedText = [self jiSuanBenDianXiaoFei];
            _peiSongLab.text = [self xianShiPeiSongFei];
        }
    }];
}
#pragma mark -- 显示配送费
- (NSString *)xianShiPeiSongFei
{
//    NSString * peiSongFei = [NSString stringWithFormat:@"配送费%@元，满%@元免配送费",_remindDic[@"shop_info"][@"delivery_fee"],_remindDic[@"shop_info"][@"free_delivery_amount"]];
   
    NSString * string = [NSString stringWithFormat:@"合计:￥%.2f",self.totalPrice];
//    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:string];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:blackTextColor range:NSMakeRange(0, 3)];
//    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10*self.scale] range:NSMakeRange(3, 1)];
    return string;
}

-(void)godingdan{
    if ([Stockpile sharedStockpile].isLogin==NO) {
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {
                    [self requestShopingCart:true];
                }];
            }
        }];
        return;
    }
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
 }

#pragma mark-------去购物车，  去订单订单详情
-(void)goShopCar{
    if ([Stockpile sharedStockpile].isLogin==NO) {
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {
                    [self requestShopingCart:true];
                }];
            }
        }];
        return;
    }
    self.hidesBottomBarWhenPushed=YES;
    GouWuCheViewController *gouwuceh = [GouWuCheViewController new];
    gouwuceh.isShowBack=true;
    [self.navigationController pushViewController:gouwuceh animated:YES];
}

-(void)loadShopingCart{
    NSString *userid =  [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dic = @{@"user_id":userid};
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy showCartWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            [_dataSource addObjectsFromArray:models];
            for (NSDictionary *ShopInfo in _dataSource) {
                NSMutableArray *arr = [[ShopInfo objectForKey:@"prod_info"] mutableCopy];
                for (NSDictionary *prodDic in arr) {
                    if (![prodDic[@"prod_count"] isEqualToString:@"0"]) {
                        self.totalPrice += [prodDic[@"price"] floatValue]*[prodDic[@"prod_count"] integerValue];
                    }
                }
            }
            NSLog(@"price:%f",self.totalPrice);
        }
    }];
}

@end
