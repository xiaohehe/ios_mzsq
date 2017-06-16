//
//  GongGaoQiangViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GongGaoQiangViewController.h"
#import "GongGaoSouSuoViewController.h"
#import "GongGaoInfoViewController.h"
#import "ShareTableViewCell.h"
#import "IntroControll.h"
#import "LoginViewController.h"
#import "SheQuManagerViewController.h"
#import "SolveRedViewController.h"
#import "UITabBar+badge.h"
#import "GanXiShopViewController.h"
#import "BreakInfoViewController.h"
#import "UmengCollection.h"
@interface GongGaoQiangViewController()<UITableViewDataSource,UITableViewDelegate,ShareTableViewCellDelegate,introlDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSIndexPath *selectedIndex;
@property(nonatomic,strong)GongGaoSouSuoViewController *souSuoVC;
@property(nonatomic,assign)BOOL  selected;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSString *typeg;
@property(nonatomic,strong)UILabel *la;
@property(nonatomic,strong)IntroControll *IntroV;
@property(nonatomic,strong)UITextField *mesay;
@property(nonatomic,strong)CellView *bv;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)NSMutableDictionary *dic;
@property(nonatomic,strong)UIControl *bgCon;
@end
@implementation GongGaoQiangViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    //    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBarHidden=YES;
    if ([Stockpile sharedStockpile].isLogin==NO) {
        LoginViewController *login = [LoginViewController new];
        //让tabbar的select等于0
        login.f=YES;
        [login resggong:^(NSString *str) {
            [self reshData];
        }];
//        [self presentViewController:login animated:YES completion:nil];
        [self presentViewController:login animated:YES completion:^{
//           [self.view endEditing:YES];
        }];
        return;
    }
    NSString *commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    if ([commid isEqualToString:@"0"] && [Stockpile sharedStockpile].isLogin==YES) {
        self.hidesBottomBarWhenPushed=YES;
        SheQuManagerViewController *shequ = [SheQuManagerViewController new];
        shequ.nojiantou=NO;
        [self.navigationController pushViewController:shequ animated:NO];
        self.hidesBottomBarWhenPushed=NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadNearby" object:nil];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keybordWillChange:) name:UIKeyboardWillShowNotification object:nil];
    _dic=[NSMutableDictionary new];//dictionaryWithObjectsAndKeys:@"张三":@"产品不错我想买",@"张三":@"产品不错我想买",@"张三":@"产品不错我想买",@"张三":@"产品不错我想买" nil] ;
    NSDictionary *d=@{@"张三":@"产品不错我想买",
                      @"李四":@"产品不错11111我想买",
                      @"王五":@"产品不错1111111我想买",
                      @"赵六":@"产品111111不错我想买"};
    [_dic addEntriesFromDictionary:d];
   [self newNav];
   
    self.view.backgroundColor=[UIColor whiteColor];
    _index=0;
    _typeg=@"5";
    _data = [NSMutableArray new];
    
    [self newView];
    [self newSearch];
    if ([Stockpile sharedStockpile].isLogin) {
        //NSLog(@"123456");
        [self reshData];
    }
     [self fabiaovi];
    [self.view addSubview:self.activityVC];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiala)  name:@"reloadNearby" object:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)keybordWillChange:(NSNotification *)notification{
    
//    [_mesay becomeFirstResponder];
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _bv.bottom=rect.origin.y;
    }];   
}

-(void)keybordWillhieeht:(NSNotification *)notification{
    
   
    
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        
        _bv.top=self.view.height;
    }];
}

-(void)reshData{
    [self.activityVC startAnimate];
    
    _index++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    
    
    NSDictionary *dic = @{@"user_id":self.user_id,@"pindex":index,@"notice_type":_typeg,@"community_id":self.commid};
    [anle getNoticeListwallWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if (_index==1) {
            [_data removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {
            
            [_data addObjectsFromArray:models];
            
            NSInteger hunm = [[[NSUserDefaults standardUserDefaults]objectForKey:@"gongnumc"] integerValue];
            
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)hunm] forKey:@"gongnum"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self.tabBarController.tabBar hideBadgeOnItemIndex:1];

         
        }
        
        if (_la) {
            [_la removeFromSuperview];
            _la=nil;
        }
        if (_data.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-self.NavImg.bottom)];
            _la.text=@"暂无公告信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            [_tableView addSubview:_la];
        }
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
    }];
}
-(void)newSearch{
    _souSuoVC=[[GongGaoSouSuoViewController alloc]init];
    _souSuoVC.view.frame=CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom);
    [self.view addSubview:_souSuoVC.view];
}
-(void)newView{

    
    
    if (!_tableView) {
         _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, [UIScreen mainScreen].bounds.size.height-self.NavImg.bottom-49)];
    }
    
   
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[ShareTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    [self.view addSubview:_tableView];
}

-(void)keyBoard:(id)sender{
    [self.view endEditing:YES];
}

-(void)fabiaovi{
    
    
//    _bgCon=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
//    _bgCon.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//    [_bgCon addTarget:self action:@selector(keyBoard:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_bgCon];
    
    
    
    
    _bv = [[CellView alloc]initWithFrame:CGRectMake(0, self.view.height, self.view.width, 80*self.scale)];
    _bv.backgroundColor=superBackgroundColor;
    [self.view addSubview:_bv];
    
    
    
    
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(10*self.scale, 7, self.view.width-20*self.scale, 30*self.scale)];
    vi.layer.borderWidth=.5;
    vi.backgroundColor=[UIColor whiteColor];
    vi.layer.borderColor=blackLineColore.CGColor;
    vi.layer.cornerRadius=5;
    [_bv addSubview:vi];
    
    
    _mesay = [[UITextField alloc]initWithFrame:CGRectMake(10*self.scale, 0, vi.width-20*self.scale, 30*self.scale)];
    //    _mesay.layer.borderWidth=.5;
    //    _mesay.backgroundColor=[UIColor whiteColor];
    _mesay.layer.borderColor=blackLineColore.CGColor;
    _mesay.layer.cornerRadius=5;
    _mesay.placeholder=@"我也说两句";

    _mesay.font=DefaultFont(self.scale);
    [vi addSubview:_mesay];
    
    UILabel *xianzhi = [[UILabel alloc]initWithFrame:CGRectMake(_mesay.left, _mesay.bottom+10*self.scale, self.view.width-80*self.scale, 20*self.scale)];
    xianzhi.text=@"最多字符200个";
    xianzhi.font=DefaultFont(self.scale);
    xianzhi.textColor=grayTextColor;
    [_bv addSubview:xianzhi];
    
    UIButton *fa = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-60*self.scale, _mesay.bottom+10*self.scale, 50*self.scale, 30*self.scale)];
    [fa setBackgroundImage:[UIImage ImageForColor:[UIColor colorWithRed:224/255.0 green:234/255.0 blue:238/255.0 alpha:1]]forState:UIControlStateNormal];
    fa.layer.cornerRadius=5;
    fa.layer.borderWidth=.5;
    fa.layer.borderColor=blackLineColore.CGColor;
    fa.titleLabel.font=DefaultFont(self.scale);
    [fa setTitle:@"发表" forState:UIControlStateNormal];
    [fa addTarget:self action:@selector(fabiao) forControlEvents:UIControlEventTouchUpInside];
    [fa setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bv addSubview:fa];
    
}


-(void)shangla{

    [self reshData];
}
-(void)xiala{
    
    _index=0;
    [self reshData];
    
//    AnalyzeObject *anle = [AnalyzeObject new];
//    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
//    self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
//    NSDictionary *dic = @{@"user_id":self.user_id,@"pindex":@"1",@"notice_type":_typeg,@"community_id":self.commid};
//    [anle getNoticeListwallWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
//        [self.activityVC stopAnimate];
//        [_tableView.header d];
//        [_tableView.footer endRefreshing];
//        if ([code isEqualToString:@"0"]) {
//            [_data removeAllObjects];
//            [_data addObjectsFromArray:models];
//            [_tableView reloadData];
//        }
//        
//        
//        
//    }];
//    NSLog(@"%@",_data);

}
#pragma mark -  UITableViewDelegate && UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}


-(void)nameTalk:(UIButton *)btn{

    
    
    
    if ([[NSString stringWithFormat:@"%@",_data[btn.tag-1000][@"notice_type"]] isEqualToString:@"2"]) {
        
        
        
        
        NSString *add = @"";
        if ([_data[btn.tag-1000][@"shop_info"][@"status"] isEqualToString:@"3"]) {
            add=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
            //        cell.addLa.textColor=[UIColor redColor];
            
            //        return cell;
        }else{
            NSString *week = [self weekdayStringFromDate:[NSDate date]];
            if ([week isEqualToString:@"周六"]) {
                if ([_data[btn.tag-1000][@"shop_info"][@"off_on_saturday"] isEqualToString:@"2"]) {
                    add=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
                    //                cell.addLa.textColor=[UIColor redColor];
                    //                return cell;
                }
            }else if ([week isEqualToString:@"周日"]){
                if ([_data[btn.tag-1000][@"shop_info"][@"off_on_sunday"] isEqualToString:@"2"]) {
                    add=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
                    //                cell.addLa.textColor=[UIColor redColor];
                    //                return cell;
                }
            }
        }
        
        
        
        if ([add isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
            
            [self tiao:YES btn:btn];
            
            
            return;
        }else{
            
            
        }
        
        BOOL isSleep1=YES;
        BOOL isSleep2=YES;
        BOOL isSleep3=YES;
        
        
        NSArray *timArr  = [_data[btn.tag-1000][@"shop_info"][@"business_hour"] componentsSeparatedByString:@","];
        
        NSDate *now = [NSDate date];
        NSDateFormatter *nowFo = [[NSDateFormatter alloc]init];
        [nowFo setDateFormat:@"yyyy-MM-dd"];
        NSString *noewyers = [nowFo stringFromDate:now];
        
        for (NSString *str in timArr) {
            if ([str isEqualToString:@"1"]) {
                
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[btn.tag-1000][@"shop_info"][@"business_start_hour1"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[btn.tag-1000][@"shop_info"][@"business_end_hour1"]]];
                
                
                
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
                
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[btn.tag-1000][@"shop_info"][@"business_start_hour2"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[btn.tag-1000][@"shop_info"][@"business_end_hour2"]]];
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
                
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[btn.tag-1000][@"shop_info"][@"business_start_hour3"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[btn.tag-1000][@"shop_info"][@"business_end_hour3"]]];
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
            
            
            
        }else{
            add = @"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
            
        }
        
        if ([_data[btn.tag-1000][@"shop_info"][@"business_hour"] isEqualToString:@""]) {
            
            add=@"";
        }
        
        
        //-----------------是否休息判断end
        
        
        
        
        
        BOOL issleep;
        if ([add isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
            issleep=YES;
        }else{
            issleep=NO;
        }

        
        [self tiao:issleep btn:btn];
        
        return;
    }
    
    
    
    
//    if ([_data[btn.tag-1000][@"user_id"]isEqualToString:@""]) {
//        [self ShowAlertWithMessage:@"该商家暂未开通聊天功能！"];
//        return;
//    }
//    
//    
    self.hidesBottomBarWhenPushed=YES;
    RCDChatViewController *chatService = [RCDChatViewController new];
  //  chatService.userName = _data[btn.tag-1000][@"publisher"];
    chatService.targetId = _data[btn.tag-1000][@"user_id"];
    chatService.conversationType = ConversationType_PRIVATE;
    chatService.title = _data[btn.tag-1000][@"publisher"];
    [self.navigationController pushViewController: chatService animated:YES];
    self.hidesBottomBarWhenPushed=NO;



}


-(void)tiao:(BOOL)issleep btn:(UIButton*)btn{
    
        //商家
        
        self.hidesBottomBarWhenPushed=YES;
        
        if ([_data[btn.tag-1000][@"shop_info"][@"shop_type"] isEqualToString:@"2"]) {
            GanXiShopViewController *ganxi = [GanXiShopViewController new];
            if ([_data[btn.tag-1000][@"shop_info"][@"is_open_chat"]isEqualToString:@"2"]) {
                ganxi.isOpen=NO;
            }else{
                ganxi.isOpen=YES;
            }
            
            
            ganxi.issleep=issleep;
            ganxi.ID=_data[btn.tag-1000][@"shop_info"][@"id"];
            ganxi.titlee=_data[btn.tag-1000][@"shop_info"][@"shop_name"];
            ganxi.topSetimg = _data[btn.tag-1000][@"shop_info"][@"logo"];
            ganxi.shop_user_id=_data[btn.tag-1000][@"shop_info"][@"user_id"];
            [self.navigationController pushViewController:ganxi animated:YES];
            self.hidesBottomBarWhenPushed=NO;
            
        }else{
            self.hidesBottomBarWhenPushed=YES;
            
            
            BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
            if ([_data[btn.tag-1000][@"shop_info"][@"is_open_chat"]isEqualToString:@"2"]) {
                info.isopen=NO;
            }else{
                info.isopen=YES;
            }
            info.tel = [NSString stringWithFormat:@"%@",_data[btn.tag-1000][@"shop_info"][@"hotline"]];
            info.issleep=issleep;
            info.ID=_data[btn.tag-1000][@"shop_info"][@"id"];
            info.titlete=_data[btn.tag-1000][@"shop_info"][@"shop_name"];
            info.shopImg = _data[btn.tag-1000][@"shop_info"][@"logo"];
            info.gonggao = _data[btn.tag-1000][@"shop_info"][@"notice"];
            info.yunfei =_data[btn.tag-1000][@"shop_info"][@"delivery_fee"];
            info.manduoshaofree=_data[btn.tag-1000][@"shop_info"][@"free_delivery_amount"];
            info.shop_user_id=_data[btn.tag-1000][@"shop_info"][@"user_id"];
            [self.navigationController pushViewController:info animated:YES];
            self.hidesBottomBarWhenPushed=NO;
            
        }
        
}


-(void)liaotian:(UIGestureRecognizer *)view{

    
    if ([[NSString stringWithFormat:@"%@",_data[view.view.tag][@"notice_type"]] isEqualToString:@"2"]) {
        
        
        
        
        NSString *add = @"";
        if ([_data[view.view.tag][@"shop_info"][@"status"] isEqualToString:@"3"]) {
            add=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
            //        cell.addLa.textColor=[UIColor redColor];
            
            //        return cell;
        }else{
            NSString *week = [self weekdayStringFromDate:[NSDate date]];
            if ([week isEqualToString:@"周六"]) {
                if ([_data[view.view.tag][@"shop_info"][@"off_on_saturday"] isEqualToString:@"2"]) {
                    add=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
                    //                cell.addLa.textColor=[UIColor redColor];
                    //                return cell;
                }
            }else if ([week isEqualToString:@"周日"]){
                if ([_data[view.view.tag][@"shop_info"][@"off_on_sunday"] isEqualToString:@"2"]) {
                    add=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
                    //                cell.addLa.textColor=[UIColor redColor];
                    //                return cell;
                }
            }
        }
        
        
        
        if ([add isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
            
            [self Liaotiao:YES btn:view];
            
            
            return;
        }else{
            
            
        }
        
        BOOL isSleep1=YES;
        BOOL isSleep2=YES;
        BOOL isSleep3=YES;
        
        
        NSArray *timArr  = [_data[view.view.tag][@"shop_info"][@"business_hour"] componentsSeparatedByString:@","];
        
        NSDate *now = [NSDate date];
        NSDateFormatter *nowFo = [[NSDateFormatter alloc]init];
        [nowFo setDateFormat:@"yyyy-MM-dd"];
        NSString *noewyers = [nowFo stringFromDate:now];
        
        for (NSString *str in timArr) {
            if ([str isEqualToString:@"1"]) {
                
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[view.view.tag][@"shop_info"][@"business_start_hour1"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[view.view.tag][@"shop_info"][@"business_end_hour1"]]];
                
                
                
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
                
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[view.view.tag][@"shop_info"][@"business_start_hour2"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[view.view.tag][@"shop_info"][@"business_end_hour2"]]];
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
                
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[view.view.tag][@"shop_info"][@"business_start_hour3"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[view.view.tag][@"shop_info"][@"business_end_hour3"]]];
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
            
            
            
        }else{
            add = @"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
            
        }
        
        if ([_data[view.view.tag][@"shop_info"][@"business_hour"] isEqualToString:@""]) {
            
            add=@"";
        }
        
        
        //-----------------是否休息判断end
        
        
        
        
        
        BOOL issleep;
        if ([add isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
            issleep=YES;
        }else{
            issleep=NO;
        }
        
        
        [self Liaotiao:issleep btn:view];
        
        return;
    }

    
    
    
    
    
    self.hidesBottomBarWhenPushed=YES;
    RCDChatViewController *chatService = [RCDChatViewController new];
    chatService.targetId = _data[view.view.tag][@"user_id"];
    chatService.conversationType = ConversationType_PRIVATE;
    chatService.title = _data[view.view.tag][@"publisher"];
    [self.navigationController pushViewController: chatService animated:YES];
    self.hidesBottomBarWhenPushed=NO;


}


-(void)Liaotiao:(BOOL)issleep btn:(UIGestureRecognizer *)btn{
    
    //商家
    
    self.hidesBottomBarWhenPushed=YES;
    
    if ([_data[btn.view.tag][@"shop_info"][@"shop_type"] isEqualToString:@"2"]) {
        GanXiShopViewController *ganxi = [GanXiShopViewController new];
        if ([_data[btn.view.tag][@"shop_info"][@"is_open_chat"]isEqualToString:@"2"]) {
            ganxi.isOpen=NO;
        }else{
            ganxi.isOpen=YES;
        }
        
        
        ganxi.issleep=issleep;
        ganxi.ID=_data[btn.view.tag][@"shop_info"][@"id"];
        ganxi.titlee=_data[btn.view.tag][@"shop_info"][@"shop_name"];
        ganxi.topSetimg = _data[btn.view.tag][@"shop_info"][@"logo"];
        ganxi.shop_user_id=_data[btn.view.tag][@"shop_info"][@"user_id"];
        [self.navigationController pushViewController:ganxi animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        
    }else{
        self.hidesBottomBarWhenPushed=YES;
        
        
        BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
        if ([_data[btn.view.tag][@"shop_info"][@"is_open_chat"]isEqualToString:@"2"]) {
            info.isopen=NO;
        }else{
            info.isopen=YES;
        }
        info.tel = [NSString stringWithFormat:@"%@",_data[btn.view.tag][@"shop_info"][@"hotline"]];
        info.issleep=issleep;
        info.ID=_data[btn.view.tag][@"shop_info"][@"id"];
        info.titlete=_data[btn.view.tag][@"shop_info"][@"shop_name"];
        info.shopImg = _data[btn.view.tag][@"shop_info"][@"logo"];
        info.gonggao = _data[btn.view.tag][@"shop_info"][@"notice"];
        info.yunfei =_data[btn.view.tag][@"shop_info"][@"delivery_fee"];
        info.manduoshaofree=_data[btn.view.tag][@"shop_info"][@"free_delivery_amount"];
        info.shop_user_id=_data[btn.view.tag][@"shop_info"][@"user_id"];
        [self.navigationController pushViewController:info animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        
    }
    
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

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShareTableViewCell *cell=(ShareTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.HeaderImage.tag=indexPath.row;
    cell.HeaderImage.userInteractionEnabled=YES;
    [cell.headBtn setTitle:[NSString stringWithFormat:@"%@",_data[indexPath.row][@"publisher"]] forState:UIControlStateNormal];
    [cell.headBtn addTarget:self action:@selector(nameTalk:) forControlEvents:UIControlEventTouchUpInside];
    cell.headBtn.tag=indexPath.row+1000;
    [cell.HeaderImage setImageWithURL:[NSURL URLWithString:_data[indexPath.row][@"logo"]] placeholderImage:[UIImage imageNamed:@"not_1"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liaotian:)];
    [cell.HeaderImage addGestureRecognizer:tap];

    NSMutableArray *a = [NSMutableArray new];
    for (int i=0; i<9; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i+1];
       NSString *na = _data[indexPath.row][str];
        if (![na isEqualToString:@""]) {
            [a addObject:na];
        }
    }
    

    if ([[NSString stringWithFormat:@"%@",_data[indexPath.row][@"praise_status"]] isEqualToString:@"1"]) {
        [cell.ZanButton setTitle:@"取消" forState:UIControlStateNormal];
        
    }else{
        [cell.ZanButton setTitle:@"赞" forState:UIControlStateNormal];
    }
    
    
    [cell.pingLunButton setTitle:@"评论" forState:UIControlStateNormal];
    
    cell.zanCount = [_data[indexPath.row][@"praisers"] count];
    cell.zanData = _data[indexPath.row][@"praisers"];
    
    cell.imgCount=a.count;
    cell.imgData=a;
    
    cell.zanCount = [_data[indexPath.row][@"praisers"] count];
    cell.delegate=self;
//    cell.NameLabel.text=[_data [indexPath.row]objectForKey:@"title"];
    cell.ContentLabel.text=[_data [indexPath.row]objectForKey:@"content"];
    cell.ContentLabel.numberOfLines=3;
   
    cell.commitDic=_data[indexPath.row][@"comments"];
    
    cell.commitCount=[_data[indexPath.row][@"comment_count"] integerValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *time = [NSString stringWithFormat:@"%@",[_data [indexPath.row]objectForKey:@"create_time"]];
    
    NSDate *date = [formatter dateFromString:time];
    

    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"MM-dd HH:mm"];

    time = [formatter1 stringFromDate:date];
    
    [cell.ju addTarget:self action:@selector(jubao) forControlEvents:UIControlEventTouchUpInside];

    
    cell.DateLabel.text=time;
    
    
    
    cell.delegate=self;
    cell.indexPath=indexPath;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)jubao{
    
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入举报内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    al.alertViewStyle=UIAlertViewStylePlainTextInput;
    [al show];
     UITextField *tf=[al textFieldAtIndex:0];
    [tf becomeFirstResponder];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        UITextField *tf=[alertView textFieldAtIndex:0];

        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [tf resignFirstResponder];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_mesay resignFirstResponder];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self ShowAlertWithMessage:@"举报成功"];
                    });
                    
                });
            });
            
        });
        
    }else{
        UITextField *tf=[alertView textFieldAtIndex:0];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [tf resignFirstResponder];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_mesay resignFirstResponder];

            });

            

        });
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // return 300*self.scale;
    //   NSLog(@"%@",_data);
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width-70*self.scale, 20*self.scale)];
    la.numberOfLines=3;
    la.text=[_data [indexPath.row]objectForKey:@"content"];
    la.font=DefaultFont(self.scale);
    [la sizeToFit];
    
    
    
    
    
    NSMutableArray *ar = [NSMutableArray new];
    for (int i=0; i<9; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i+1];
        NSString *na = _data[indexPath.row][str];
        if (![na isEqualToString:@""]) {
            [ar addObject:na];
        }
    }
    float imgH = 0;
    if (ar.count<=0) {
        imgH = 0;
    }
    
    if (ar.count<4 && ar.count>0) {
        imgH = 63*self.scale;
    }else if (ar.count<7 && ar.count>0){
        imgH=128*self.scale;
    }else if (ar.count<10 && ar.count>0){
        imgH=190*self.scale;
    }
    
    
    NSArray *praArr = _data[indexPath.row][@"praisers"];
    float zanH=0;
    
    
    
    NSString *str = @"";
    
    for (NSDictionary *dic in praArr) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",dic[@"user_name"]]];
        
        
        str = [str substringToIndex:str.length-1];
        
        
    }
    
    
    
    
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle1.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:12*self.scale], NSParagraphStyleAttributeName:paragraphStyle1.copy};
    CGSize size1 = [str boundingRectWithSize:CGSizeMake(self.view.width-50*self.scale, 3500*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes1 context:nil].size;
    
    if (praArr.count>0&&[_data[indexPath.row][@"comments"] count]>0) {
        zanH=size1.height+10*self.scale;
    }else{
        zanH=size1.height+15*self.scale;
    }
    
    
    if (praArr.count<=0) {
        zanH=0;
    }
    
    
    
    
    
    
    
    NSArray *commitArr = _data[indexPath.row][@"comments"];
    float comH=5*self.scale;
    
    
    
    
    
    for (int i=0; i<commitArr.count; i++) {
        UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(5*self.scale, comH, self.view.width-90*self.scale, 2000)];
        la.font=[UIFont systemFontOfSize:12*self.scale];
        la.numberOfLines=0;
        la.text=[NSString stringWithFormat:@"%@：%@",commitArr[i][@"user_name"],commitArr[i][@"content"]];
        NSLog(@"%@",la.text);
        [la sizeToFit];
        
        
        comH+=la.height+5*self.scale;
        
        
    }

    if (zanH>0) {
        comH+=13*self.scale;
    }else{
        comH+=15*self.scale;
    }
   





    if (commitArr.count<=0) {
        comH=0;
    }
    
    
    
    return imgH+zanH+65*self.scale+la.height+comH;
    
    
    
    
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    self.hidesBottomBarWhenPushed=YES;
    GongGaoInfoViewController *infoVC=[[GongGaoInfoViewController alloc]init];
    infoVC.gongID = _data[indexPath.row][@"id"];
    infoVC.type = _data[indexPath.row][@"notice_type"];
    [self.navigationController pushViewController:infoVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
#pragma mark - 赞操作
-(void)ShareTableViewCellWith:(NSIndexPath *)indexPath{
    
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    NSDictionary *dic = @{@"user_id":self.user_id,@"notice_id":_data[indexPath.row][@"id"]};
    [anle NoticeWallAgreeWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            
            NSArray *arr=_data[indexPath.row][@"praisers"];
            
            NSMutableArray *new=[NSMutableArray arrayWithArray:arr];
            NSMutableDictionary *dic=[NSMutableDictionary new];
            NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithDictionary:_data[indexPath.row]];
            
            [dic setObject:[Stockpile sharedStockpile].nickName forKey:@"user_name"];
            
            if ([[NSString stringWithFormat:@"%@",_data[indexPath.row][@"praise_status"]] isEqualToString:@"1"]) {
                [new removeObject:dic];
                [dataDic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"praise_status"];
            }else{
                [new addObject:dic];
                [dataDic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"praise_status"];
            }
            
            
           
            
            [dataDic setObject:new forKey:@"praisers"];
            
            [_data replaceObjectAtIndex:indexPath.row withObject:dataDic];

            [_tableView reloadData];
            
            
//            _index=0;
//            [self reshData];
            
//            ShareTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
//            cell.CaoZuoButton.selected=YES;
            
        }
    }];
    
    
}



#pragma mark - 评论操作
-(void)CommitTableViewCellWith:(NSIndexPath *)indexPath{
    
    [_mesay becomeFirstResponder];
    _indexPath=indexPath;
}
-(void)fabiao{
    [self.view endEditing:YES];
    
    
    if ([_mesay.text isEqualToString:@""]) {
        [self ShowAlertWithMessage:@"请输入信息"];
        return;
    }
    if (_mesay.text.length>200) {
        [self ShowAlertWithMessage:@"最多只能输入200个字符"];
        return;
    }
    [self.view addSubview:self.activityVC];
    [self .activityVC startAnimate];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    
   
    AnalyzeObject *nale = [AnalyzeObject new];
    NSDictionary *dic = @{@"user_id":self.user_id,@"content":_mesay.text,@"notice_id":_data[_indexPath.row][@"id"],@"notice_type":_data[_indexPath.row][@"notice_type"]};
    [nale NoticeWallcommentWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            [self.view endEditing:YES];
            
            
            
            NSString *comment_count= [NSString stringWithFormat:@"%@",_data[_indexPath.row][@"comment_count"]];
            NSArray *arr=_data[_indexPath.row][@"comments"];
            
            NSMutableArray *new=[NSMutableArray arrayWithArray:arr];
            NSMutableDictionary *dic=[NSMutableDictionary new];
            [dic setObject:[Stockpile sharedStockpile].nickName forKey:@"user_name"];
            [dic setObject:_mesay.text forKey:@"content"];
            [new insertObject:dic atIndex:0];
            
            NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithDictionary:_data[_indexPath.row]];
            [dataDic setObject:new forKey:@"comments"];
            [dataDic setObject:[NSString stringWithFormat:@"%d",[comment_count intValue]+1] forKey:@"comment_count"];
            [_data replaceObjectAtIndex:_indexPath.row withObject:dataDic];
            
            _mesay.text=@"";
            [_tableView reloadData];
            
//            _index=0;
//            [self reshData];
        }
        
    }];

}
#pragma mark - 操作
-(void)CanZuoTableViewCellWith:(NSIndexPath *)indexPath Selected:(BOOL)selected{
    if (_selectedIndex && _selectedIndex!=indexPath) {
        ShareTableViewCell *cell=(ShareTableViewCell *)[_tableView cellForRowAtIndexPath:_selectedIndex];
        cell.CaoZuoButton.selected=NO;
        _selectedIndex=nil;
    }
    _selectedIndex=indexPath;
}
#pragma mark - 大图
-(void)BigImageTableViewCellWith:(NSIndexPath *)indexPath ImageIndex:(NSInteger)index{
    NSMutableArray *a = [NSMutableArray new];
//    [self setHidesBottomBarWhenPushed:YES];
    
    for (int i=0; i<9; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i+1];
        NSString *na = _data[indexPath.row][str];
        if (![na isEqualToString:@""]) {
            [a addObject:na];
        }
    }
    
    SolveRedViewController *sole = [SolveRedViewController new];
    sole.data=a;
    sole.index=index;
    [self presentViewController:sole animated:NO completion:nil];
    
    
//    NSMutableArray *pagesArr = [[NSMutableArray alloc] init];
//    for (int i = 0; i <a.count; i ++) {
//        
//        IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:[NSString stringWithFormat:@"%@",a[i]]];
//        [pagesArr addObject:model1];
//    }
//    
//    _IntroV = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:pagesArr];
//    _IntroV.delegate=self;
//    [_IntroV index:index-1];
//    self.tabBarController.tabBar.hidden=YES;
//    [self.appdelegate.window addSubview:_IntroV];
}
-(void)tabaryes{

    self.tabBarController.tabBar.hidden=NO;

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_selectedIndex) {
        ShareTableViewCell *cell=(ShareTableViewCell *)[_tableView cellForRowAtIndexPath:_selectedIndex];
        cell.CaoZuoButton.selected=NO;
        _selectedIndex=nil;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_tableView==scrollView) {
        [self.view endEditing:YES];
    }
}
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"邻里圈";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, 85*self.scale, self.TitleLabel.height)];
    button.titleLabel.font=DefaultFont(self.scale);
    [button setTitle:@"所有公告" forState:UIControlStateNormal];
    [button setTitleColor:grayTextColor forState:(UIControlStateNormal)];
    button.titleEdgeInsets=UIEdgeInsetsMake(0, -5, 0,5);
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(button.width-14*self.scale, button.height/2-6*self.scale, 12*self.scale, 12*self.scale)];
    iconImg.image=[UIImage imageNamed:@"gg_borrow_01"];
    [button addTarget:self action:@selector(SearchEvent:) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:iconImg];
    [self.NavImg addSubview:button];
    
    UIButton *AddButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [AddButton setImage:[UIImage imageNamed:@"gg_jia"] forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(fagonggao) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:AddButton];
    
}

-(void)fagonggao{
    self.hidesBottomBarWhenPushed=YES;
    FaBuGongGaoViewController *fabuvc = [FaBuGongGaoViewController new];
    [fabuvc gonggaoResh:^(NSString *str) {
        _index=0;
        [self reshData];
        
    }];
    [self.navigationController pushViewController:fabuvc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
-(void)SearchEvent:(UIButton *)button{
    button.selected=!button.selected;
    if (button.selected) {
        [_souSuoVC ShowViewWithBlock:^(NSDictionary *gonggao) {
            [button setTitle:[gonggao objectForKey:@"name"] forState:UIControlStateNormal];
            button.selected=NO;
            
            
            if ([gonggao[@"name"] isEqualToString:@"所有公告"]) {
                _index=0;
                _typeg=@"5";
                [self reshData];
            }else if([gonggao[@"name"] isEqualToString:@"社区公告"]){
                _index=0;
                _typeg=@"3";
                [self reshData];
            }else if ([gonggao[@"name"] isEqualToString:@"用户公告"]){
                _index=0;
                _typeg=@"1";
                [self reshData];
            }else if ([gonggao[@"name"] isEqualToString:@"商家公告"]){
                _index=0;
                _typeg=@"2";
                [self reshData];
            }else if ([gonggao[@"name"] isEqualToString:@"二手闲置"]){
                _index=0;
                _typeg=@"4";
                [self reshData];
            }
            
            
            
            
            
        }];
        
        
        
        
        
        
    }else{
        [_souSuoVC HiddenView];
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
