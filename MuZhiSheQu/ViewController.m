//
//  ViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "BreakFirstViewController.h"
#import "GanXiShopViewController.h"
#import "GanXiShopViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "ShopInfoViewController.h"
#import "BreakInfoTableViewCell.h"
#import "UITabBar+badge.h"
#import "UmengCollection.h"
#import "SouViewController.h"
#import "ShangJiaViewController.h"
#import "WuYeZhongXinViewController.h"
#import "MyPageControl.h"
#import "SheQuManagerViewController.h"
#import "UIColor+Hex.h"
@interface ViewController ()<RCIMReceiveMessageDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    int ii;
    NSInteger Tag;
    NSInteger hiddenTag;
    NSString *goodsListID;
    //轮播位置
    float _X;
    NSInteger fenleiIndex;
    UIView *lineFen;
    UIView * hiddenLineFenLab;
    CGFloat height;
    NSString * textFieldString;
    
    

    
}

@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIScrollView *ImageScrollView;
@property(nonatomic,strong)UIScrollView * fenLeiScrollView;
@property(nonatomic,strong)UIPageControl * pageControl;
@property(nonatomic,strong)MyPageControl * shangPinPageControl;
@property(nonatomic,strong)UIScrollView * shangPinScrollView;
@property(nonatomic,strong)UIControl *BigCon;
@property(nonatomic,strong)NSMutableDictionary * fenLeiDictionary;
@property(nonatomic,strong)NSMutableDictionary * indexDictionary;
@property(nonatomic,strong)NSMutableDictionary * xialaHDictionary;
@property(nonatomic,strong)NSMutableArray * viewArray;//存放分类view的数组
@property(nonatomic,strong)UIScrollView * hiddenScrollView;
@property(nonatomic,strong)NSMutableArray *hiddenArray;
//@property(nonatomic,strong)UILabel * hiddenLineFenLab;
@property(nonatomic,strong)NSMutableArray *lingShouData,*lunboData,*shangmenData,*weishangData,*lunda,*adverData,*adverDa,*fenBtnArr;

@property(nonatomic,assign)BOOL one,two,three,four,five;
@property(nonatomic,strong)NSDictionary *ADDic;

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong)UIScrollView *scroll;


@property(nonatomic,assign)float xialaH;

@property(nonatomic,assign)float keyeBoardShowHeight;

@property (nonatomic,retain)UIButton * shangjiaJinZhuBtn;

@property (nonatomic,retain)UIButton * shengHuoFuWuBtn;
@property (nonatomic,retain)UIButton * wuYeZhongXinBtn;
@property (nonatomic,retain)UIButton * dizhiBtn;

@property (nonatomic,retain)NSTimer * gongGaoTimer;

@property (nonatomic,retain)NSString * gongGaoStringq;
@property (nonatomic,retain)NSDictionary * gongGaoDic;



@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    _one=NO;
    _two=NO;
    _three=NO;
    _four=NO;
    _five=NO;
    textFieldString = @"";
    [self gouWuCheShuZi];
    
//    self.navigationController.navigationBarHidden=YES;
    [RCIM sharedRCIM].disableMessageAlertSound=NO;
    [self ReshMessage];
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//    NSString *addrss = [[NSUserDefaults standardUserDefaults]objectForKey:@"commname"];
//    self.TitleLabel.text=addrss;

    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"changeComm"]) {
        _lingShouData=[NSMutableArray new];
        _lunda=[NSMutableArray new];
        _shangmenData=[NSMutableArray new];
        _weishangData=[NSMutableArray new];
        _adverData=[NSMutableArray new];
        _adverDa=[NSMutableArray new];
        goodsListID=@"";
        [self reshData];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"changeComm"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else{
        
        self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
        if (self.commid==nil || [self.commid isEqualToString:@""]) {
            // [self ShowAlertWithMessage:@"没有数据，请重新选择社区"];
        }
        
        return;
        
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
//    view.backgroundColor = grayTextColor;
//    [self.view addSubview:view];
    
    self.fenLeiDictionary = [NSMutableDictionary new];
    self.indexDictionary = [NSMutableDictionary new];
    self.xialaHDictionary = [NSMutableDictionary new];
    self.gongGaoDic = [NSDictionary new];
    
    fenleiIndex = 0;
    _xialaH = 0;


    self.viewArray = [NSMutableArray new];
    _ADDic = [NSDictionary new];
    ii=1;
    Tag=1000000000;
    hiddenTag = -1000000000;
    _index=1;
    _keyeBoardShowHeight = 0;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.NavImg.hidden = YES;
//    self.navigationController.navigationBarHidden=YES;

    [self loadNotificationCell];
    [self.view endEditing:YES];
    // Do any additional setup after loading the view, typically from a nib.
//     self.NavImg.alpha = 1;
    [self newNav];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changeComm"];
    if ([self getCommid]==nil || [[self getCommid] isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"changeComm"];
    }
    
    
   BOOL gong = [[NSUserDefaults standardUserDefaults]boolForKey:@"G"];
    
    if (gong) {
        AnalyzeObject *anle = [AnalyzeObject new];
        [anle ADD:@{@"community_id":[self getCommid]} Block:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"0"]) {
                _ADDic=models;
                [self ADData:models];
                
            }
            
            
        }];
    }

    if ([Stockpile sharedStockpile].isLogin) {
        [self gongGaoDian];
    }
    [self createShangJiaJinZhuBtn];
    
    
    
    
    

}
- (void)createShangJiaJinZhuBtn
{
    if (_shangjiaJinZhuBtn)
    {
        [_shangjiaJinZhuBtn removeFromSuperview];
    }
    _shangjiaJinZhuBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/5*4, [UIScreen mainScreen].bounds.size.height - 44 - 20*self.scale - [UIScreen mainScreen].bounds.size.width/5/213*81,  [UIScreen mainScreen].bounds.size.width/5,  [UIScreen mainScreen].bounds.size.width/5/213*81)];
    [_shangjiaJinZhuBtn setImage:[UIImage imageNamed:@"shangJiaRuZhu"] forState:(UIControlStateNormal)];
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;.\
//    [window addSubview:_shangjiaJinZhuBtn];
//    [_shangjiaJinZhuBtn bringSubviewToFront:self.view];
    [_shangjiaJinZhuBtn addTarget:self action:@selector(shangjiaJinZhuBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_shangjiaJinZhuBtn];
    [_shangjiaJinZhuBtn bringSubviewToFront:self.view];
    
   
}
-(void)ADData:(NSDictionary *)dic{


    _BigCon = [[UIControl alloc]initWithFrame:self.appdelegate.window.bounds];
    _BigCon.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    [self.appdelegate.window addSubview:_BigCon];
    
    UIImageView *img = [[UIImageView alloc]init];
    [img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_ADDic[@"img"]]] placeholderImage:[UIImage imageNamed:@"za"]];
    img.width=self.view.width-40*self.scale;
    img.height=self.view.height-120*self.scale;
    img.center=_BigCon.center;
    [_BigCon addSubview:img];
    img.layer.cornerRadius=5;
    img.layer.masksToBounds=YES;
    img.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ADDT)];
    [img addGestureRecognizer:tap];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(img.right-15*self.scale, img.top-15*self.scale, 30*self.scale, 30*self.scale)];
    [_BigCon addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"addshn"] forState:0];
    [btn addTarget:self action:@selector(remo) forControlEvents:UIControlEventTouchUpInside];
    

}

-(void)ADDT{

    
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle ADDJLu:@{@"ad_id":_ADDic[@"id"]} Block:^(id models, NSString *code, NSString *msg) {
        
    }];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ad"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //-----------------是否休息判断
    
    NSString *add = @"";
    if ([_ADDic[@"shop_info"][@"status"] isEqualToString:@"3"]) {
        add=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
    }else{
        NSString *week = [self weekdayStringFromDate:[NSDate date]];
        if ([week isEqualToString:@"周六"]) {
            if ([_ADDic[@"shop_info"][@"off_on_saturday"] isEqualToString:@"2"]) {
                add=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
            }
        }else if ([week isEqualToString:@"周日"]){
            if ([_ADDic[@"shop_info"][@"off_on_sunday"] isEqualToString:@"2"]) {
                add=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
            }
        }
    }
    
    
    
    if ([add isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
     
        [self tiao:YES];
        
        
        return;
    }else{
    

    }
    
    BOOL isSleep1=YES;
    BOOL isSleep2=YES;
    BOOL isSleep3=YES;
    
    
    NSArray *timArr  = [_ADDic[@"shop_info"][@"business_hour"] componentsSeparatedByString:@","];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *nowFo = [[NSDateFormatter alloc]init];
    [nowFo setDateFormat:@"yyyy-MM-dd"];
    NSString *noewyers = [nowFo stringFromDate:now];
    
    for (NSString *str in timArr) {
        if ([str isEqualToString:@"1"]) {
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_ADDic[@"shop_info"][@"business_start_hour1"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_ADDic[@"shop_info"][@"business_end_hour1"]]];
            
            
            
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
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_ADDic[@"shop_info"][@"business_start_hour2"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_ADDic[@"shop_info"][@"business_end_hour2"]]];
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
            
            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_ADDic[@"shop_info"][@"business_start_hour3"]]];
            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_ADDic[@"shop_info"][@"business_end_hour3"]]];
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
    
    if ([_ADDic[@"shop_info"][@"business_hour"] isEqualToString:@""]) {

        add=@"";
    }
    
    
    //-----------------是否休息判断end
    
    
    
    
        self.hidesBottomBarWhenPushed=YES;
        
        
        BOOL issleep;
        if ([add isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
            issleep=YES;
//            return cell;
        }else{
            issleep=NO;
        }
        

    [self tiao:issleep];
}


-(void)tiao:(BOOL)issleep{
    [self.view endEditing:YES];
    [self remo];
    if ([[NSString stringWithFormat:@"%@",_ADDic[@"redirect_to"]] isEqualToString:@"1"]) {
        //商家
        
        self.hidesBottomBarWhenPushed=YES;

        if ([_ADDic[@"shop_info"][@"shop_type"] isEqualToString:@"2"]) {
            GanXiShopViewController *ganxi = [GanXiShopViewController new];
            if ([_ADDic[@"shop_info"][@"is_open_chat"]isEqualToString:@"2"]) {
                ganxi.isOpen=NO;
            }else{
                ganxi.isOpen=YES;
            }
            
            
            ganxi.issleep=issleep;
            ganxi.ID=_ADDic[@"shop_id"];
            ganxi.titlee=_ADDic[@"shop_info"][@"shop_name"];
            ganxi.topSetimg = _ADDic[@"shop_info"][@"logo"];
            ganxi.shop_user_id=_ADDic[@"shop_info"][@"user_id"];
            [self.navigationController pushViewController:ganxi animated:YES];
            self.hidesBottomBarWhenPushed=NO;

        }else{
            self.hidesBottomBarWhenPushed=YES;

            
            BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
            if ([_ADDic[@"shop_info"][@"is_open_chat"]isEqualToString:@"2"]) {
                info.isopen=NO;
            }else{
                info.isopen=YES;
            }
            info.tel = _ADDic[@"shop_info"][@"hotline"];
            info.issleep=issleep;
            info.ID=_ADDic[@"shop_id"];
            info.titlete=_ADDic[@"shop_info"][@"shop_name"];
            info.shopImg = _ADDic[@"shop_info"][@"logo"];
            info.gonggao = _ADDic[@"shop_info"][@"notice"];
            info.yunfei =_ADDic[@"shop_info"][@"delivery_fee"];
            info.manduoshaofree=_ADDic[@"shop_info"][@"free_delivery_amount"];
            info.shop_user_id=_ADDic[@"shop_info"][@"user_id"];
            
            [self.navigationController pushViewController:info animated:YES];
            self.hidesBottomBarWhenPushed=NO;

        }

        
    }else{
        //商品
        self.hidesBottomBarWhenPushed=YES;
        ShopInfoViewController *buess = [ShopInfoViewController new];
        
        if ([_ADDic[@"shop_info"][@"is_open_chat"]isEqualToString:@"2"]) {
            buess.isopen=NO;
        }else{
            buess.isopen=YES;
        }
        buess.issleep=issleep;
        buess.islunbo=YES;
        buess.yes=NO;
        buess.price =_ADDic[@"prod_info"][@"price"];
        buess.shop_name=_ADDic[@"prod_info"][@"shop_name"];
        buess.orshoucang=YES;
        buess.shop_user_id=_ADDic[@"shop_info"][@"user_id"];
        buess.shop_id = _ADDic[@"shop_id"];
        buess.prod_id = _ADDic[@"prod_id"];
        buess.xiaoliang = _ADDic[@"prod_info"][@"sales"];
        buess.shoucang = _ADDic[@"prod_info"][@"collect_time"];
//        buess.yunfei=
        
        /**
         *  2016 8 27
         */
        buess.tel=_ADDic[@"prod_info"][@"hotline"];
        /**
         *  2016.8.27
         */
        
        
        [self.navigationController pushViewController:buess animated:YES];

        
        self.hidesBottomBarWhenPushed=NO;

        
    }
    



}
-(void)remo{

    [_BigCon removeFromSuperview];
    _BigCon=nil;
}







-(void)reshData{
    [self.appdelegate dingwei];

    [self.view addSubview:self.activityVC];
    
    [self.activityVC startAnimate];
    
    static NSInteger viewNumber;//记录分类的个数
    self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
   NSString *lon = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]];
    NSString *lat = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]];
    
    NSDictionary *dic = @{@"community_id": self.commid,@"lng":lon,@"lat":lat};
    _one=NO;
    _two=NO;
    _three=NO;
    _four=NO;
    
    //零售
    //  [_lingShouData removeAllObjects];
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    [analyze getRetailShopList:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        
        //[self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            _lingShouData=models;
        }
        // [self newView];
        _one=YES;
        [self stop];
        
    }];
    
    //精选分类
//    [self.fenLeiDictionary removeAllObjects];
    [_shangmenData removeAllObjects];
    AnalyzeObject *anle = [AnalyzeObject new];
    
    [anle shouYeFenLei:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            NSLog(@"model%@",models);
            [_shangmenData addObjectsFromArray:models];
//            [_shangmenData addObjectsFromArray:models];
            if (_shangmenData.count>0) {
//                goodsListID = [NSString stringWithFormat:@"%@",_shangmenData[0][@"id"]];
//                NSLog(@"%d",fenleiIndex);
                 goodsListID = [NSString stringWithFormat:@"%@",_shangmenData[fenleiIndex][@"id"]];
                viewNumber = _shangmenData.count;

                
                for (int i = 0; i<_shangmenData.count; i++)
                {
                    NSMutableArray * fenleiArray  = [NSMutableArray new];
                    
                    [self.fenLeiDictionary setValue:fenleiArray forKey:_shangmenData[i][@"id"]];
                    
                    NSString * index = @"0";
                    
                    [self.indexDictionary setValue:index forKey:_shangmenData[i][@"id"]];
                    
                    NSString * xiaLaH = [NSString stringWithFormat:@"%f",0.0];
                    
                    [self.xialaHDictionary setValue:xiaLaH  forKey:_shangmenData[i][@"id"]];
                    
                }
                
                
            }
        }
//        if (_shangmenData.count>0)
//        {
             [self cool];
//        }
       

        // [self newView];

    }];
    
    //轮播图片
    [_lunda removeAllObjects];
    [_lunboData removeAllObjects];
    AnalyzeObject *anle1 = [AnalyzeObject new];
    [anle1 mu_zhi_adwithDic:@{@"community_id":self.commid,@"c_type":@"1"} WithBlock:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            [_lunda addObjectsFromArray:models];
            _lunboData=[NSMutableArray new];
            for (NSDictionary *dic in models) {
                [_lunboData addObject:[dic objectForKey:@"img"]];
            }
            
            
        }
        
        _three=YES;
        [self stop];
    }];
    
//    社区标语
    AnalyzeObject *anleshequ = [AnalyzeObject new];
    [anleshequ communitySlogan:@{@"community_id":self.commid} WithBlock:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"])
        {
            NSLog(@"%@",models);
            _gongGaoDic = models;
        }
        [self stop];
        
    }];
    
    // //广告
    //    [_adverData removeAllObjects];
    //    AnalyzeObject *anle2 = [AnalyzeObject new];
    //    [anle2 mu_zhi_adwithDic:@{@"community_id":self.commid,@"c_type":@"2"} WithBlock:^(id models, NSString *code, NSString *msg) {
    //        if ([code isEqualToString:@"0"]) {
    //            [_adverDa addObjectsFromArray:models];
    //            _adverData=[NSMutableArray new];
    //            for (NSDictionary *dic in models) {
    //                [_adverData addObject:[dic objectForKey:@"img"]];
    //            }
    //        }
    //        _five=YES;
    //        [self stop];
    //    }];
    
    
    
    //   [_weishangData removeAllObjects];
    //    AnalyzeObject *anle3 = [AnalyzeObject new];
    //    [anle3 getWeiShopListwithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
    //        if ([code isEqualToString:@"0"]) {
    //            //[self ShowAlertWithMessage:@"轮播图片成功"];
    //            _weishangData=models;
    //
    //
    //
    //        }
    //       // [self newView];
    //
    //        _four=YES;
    //        [self stop];
    //
    //
    //    }];
    
    
}
-(void)stop{
    //    if (_one && _two && _three && _four) {
    //        [self.activityVC stopAnimate];
    //        [self newView];
    //    }
    if (_one && _two && _three) {
        [self.activityVC stopAnimate];
        [self performSelector:@selector(newView) withObject:nil afterDelay:0.3];
        [self.mainScrollView.footer endRefreshing];
        
        [self.mainScrollView.header endRefreshing];
    }
    
    
}
#pragma mark -- 获取商品信息 //刷新
-(void)cool{
//    NSInteger index = [[self.indexDictionary objectForKey:goodsListID] integerValue];
    [self.indexDictionary setObject:@"1" forKey:goodsListID];
  NSDictionary *  dic = @{@"pindex":@"1",@"class_id":[NSString stringWithFormat:@"%@",goodsListID]};
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle shouYeGoodsF:dic Block:^(id models, NSString *code, NSString *msg) {
        [[self.fenLeiDictionary objectForKey:goodsListID] removeAllObjects];
        
        if ([code isEqualToString:@"0"])
        {
            NSMutableArray * weishangData = [self.fenLeiDictionary objectForKey:goodsListID];
            [weishangData addObjectsFromArray:models];
            NSLog(@"%@",weishangData);
            [self.fenLeiDictionary setObject:weishangData forKey:goodsListID];
//            [self.indexDictionary setObject:[NSString stringWithFormat:@"%ld",index] forKey:goodsListID];
            
            
        }
        _two=YES;
        [self stop];
        
        [UIView animateWithDuration:.3 animations:^{
            
            lineFen.frame=CGRectMake((Tag-1000000000)*[UIScreen mainScreen].bounds.size.width/5, _scroll.height-2,[UIScreen mainScreen].bounds.size.width/5, 2);
//            _X=0;
            hiddenLineFenLab.frame = CGRectMake((hiddenTag - 1000000000)*[UIScreen mainScreen].bounds.size.width/5, _hiddenScrollView.height-2,[UIScreen mainScreen].bounds.size.width/5, 2);
            
        }];
       

    }];

}
#pragma mark===-= _weishangData原本是微商的数据源  微商去掉 目前是商品类表的数据源;

#pragma mark====-- 上拉专用
-(void)GoosdListshangla{
    [self.view addSubview:self.activityVC];
    NSInteger index = [[self.indexDictionary objectForKey:goodsListID] integerValue];
    index = index + 1;
    [self.activityVC startAnimate];
    
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"pindex":[NSString stringWithFormat:@"%ld",(long)index],@"class_id":[NSString stringWithFormat:@"%@",goodsListID]};
    [anle shouYeGoodsF:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        UIScrollView * baScrollView = (UIScrollView *)[_fenLeiScrollView viewWithTag:2000+fenleiIndex];
      
        [_mainScrollView.footer endRefreshing];
//        if (index==1) {
//            [_weishangData removeAllObjects];
//          
//        }
        NSLog(@"%@",msg);
        NSLog(@"code::%@",code);
   
        if ([code isEqualToString:@"0"])
        {
            NSMutableArray * Array = [self.fenLeiDictionary objectForKey:goodsListID];
            [Array addObjectsFromArray:models];
            
            [self.fenLeiDictionary setObject:Array forKey:goodsListID];
            [self.indexDictionary setObject:[NSString stringWithFormat:@"%ld",index] forKey:goodsListID];
            
            
        }
//        else if ([code isEqualToString:@"1"])
//        {
//            
//            [self.indexDictionary setObject:[NSString stringWithFormat:@"%ld",_index] forKey:goodsListID];
//        }
//        [self newView];
        
    
//        [self newShopView];
        for(UIButton * btn in baScrollView.subviews)
        {
            NSLog(@"%@",btn);
            [btn removeFromSuperview];
        }
//        [baScrollView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
        
//        baScrollView.footer.automaticallyRefresh=NO;
    
        [self GoodsF:baScrollView withArray:[self.fenLeiDictionary objectForKey:goodsListID]];
   
        [_mainScrollView setContentOffset:CGPointMake(0, _xialaH)];
//        NSLog(@"%f",baScrollView.contentOffset.y);
        
//        NSLog(@"%f",_xialaH);
//        _xialaH = [[self.xialaHDictionary objectForKey:goodsListID] floatValue];
//        [baScrollView setContentOffset:CGPointMake(0, [[self.xialaHDictionary objectForKey:goodsListID] floatValue])];
        
    }];
}


-(void)zaoCan{
//    self.hidesBottomBarWhenPushed = YES;
//    
//    
//    
//    
//    BreakFirstViewController *breakF = [[BreakFirstViewController alloc]init];
//    breakF.type=@"zancan";
//    [self.navigationController pushViewController:breakF animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
}


//-(void)ganxi{
//    self.hidesBottomBarWhenPushed = YES;
//    BreakFirstViewController *breakF = [[BreakFirstViewController alloc]init];
//    breakF.type=@"ganxi";
//    [self.navigationController pushViewController:breakF animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
//
//
//}
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
// 
//}
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//      UIScrollView * bScrollView  = (UIScrollView *)[_fenLeiScrollView viewWithTag:2000+fenleiIndex];
//    if (bScrollView.contentOffset.y <= 10 && _mainScrollView.contentOffset.y<= self.view.width*336/720 + height)
//    {
//        _mainScrollView.scrollEnabled = YES;
//        bScrollView.scrollEnabled = NO;
//    }
//    
//    
//    if (bScrollView.contentOffset.y<0)
//    {
//        bScrollView.scrollEnabled = NO;
//        _mainScrollView.scrollEnabled = YES;
//    }
//
//   
//}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    
     UIView * yinCangDeView = (UIView *)[_mainScrollView viewWithTag:9999999];
     UITextField * yinCangDeTextField = (UITextField *)[yinCangDeView viewWithTag:99999999];
     UITextField * daoHanTextField = (UITextField *)[self.NavImg viewWithTag:888];
     UIButton * talkbtn = (UIButton *)[_mainScrollView viewWithTag:99999];
    
    if(_mainScrollView.contentOffset.y>64){
        yinCangDeView.alpha = 0;
        talkbtn.alpha = 0;
        self.NavImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.NavImg.alpha = 1;
        UIView * view = (UIView *)[self.NavImg viewWithTag:12345];
        view.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        UIButton * talkImg = (UIButton *)[self.NavImg viewWithTag:1234];
        [talkImg setImage:[UIImage imageNamed:@"index_xiaoxi_1"] forState:UIControlStateNormal];
    }else if (_mainScrollView.contentOffset.y>0)
    {
        yinCangDeView.alpha = 0;
        talkbtn.alpha = 0;
        self.NavImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:_mainScrollView.contentOffset.y/(self.view.width*336/720-64)];
        self.NavImg.alpha = 1;
        
    }else if (_mainScrollView.contentOffset.y<0)
    {
        if ([_mainScrollView.header isRefreshing])
        {
            NSLog(@"正在刷新");
        }
        else
        {
            yinCangDeView.alpha = 1;
            talkbtn.alpha = 1;
            self.NavImg.alpha = 0;
            yinCangDeTextField.text = daoHanTextField.text;
            
        }
    
        
    }
    else if (_mainScrollView.contentOffset.y==0)
    {
        self.NavImg.alpha = 1;
        yinCangDeView.alpha = 0;
        talkbtn.alpha = 0;
        self.NavImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
       
        UIView * view = (UIView *)[self.NavImg viewWithTag:12345];
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        UIButton * talkImg = (UIButton *)[self.NavImg viewWithTag:1234];
        [talkImg setImage:[UIImage imageNamed:@"lt"] forState:UIControlStateNormal];
    }
        

    
    if (_mainScrollView.contentOffset.y>=self.view.width*336/720 + height - 64)
    {
        _hiddenScrollView.hidden = NO;
    }
    else
    {
        _hiddenScrollView.hidden = YES;
    }
    return;
    
 
//    UIScrollView * bScrollView  = (UIScrollView *)[_fenLeiScrollView viewWithTag:2000+fenleiIndex];
//
//    if (scrollView == bScrollView) {//bScrollView 子scrollview _mainScrollView :父scrollView
//        if (bScrollView.contentOffset.y < 0 && _mainScrollView.contentOffset.y > 0) {
//            [_mainScrollView setContentOffset:CGPointMake(0, _mainScrollView.contentOffset.y + bScrollView.contentOffset.y > 0 ? _mainScrollView.contentOffset.y + bScrollView.contentOffset.y : 0)];
//            [bScrollView setContentOffset:CGPointZero];
//        }
//        
//        CGFloat backSVMaxContentOffsetY = _mainScrollView.contentSize.height - _mainScrollView.frame.size.height;
//        CGFloat maxContentOffsetY = bScrollView.contentSize.height - bScrollView.frame.size.height;
//        if (bScrollView.contentOffset.y  > maxContentOffsetY && _mainScrollView.contentOffset.y < backSVMaxContentOffsetY) {
//            _mainScrollView.contentOffset = CGPointMake(0, _mainScrollView.contentOffset.y + bScrollView.contentOffset.y - maxContentOffsetY > backSVMaxContentOffsetY ? : _mainScrollView.contentOffset.y + bScrollView.contentOffset.y - maxContentOffsetY);
//            bScrollView.contentOffset = CGPointMake(0, maxContentOffsetY);
//        }
//    }
//    return;

//    
//    if (_mainScrollView.contentOffset.y >= self.view.width*336/720 + height)
//    {
//        
//        _fenLeiScrollView.top = self.NavImg.bottom;
//        
//        [self.view addSubview:_fenLeiScrollView];
//    }else{
//    
//        _fenLeiScrollView.top = _scroll.bottom;
//        
//        [_mainScrollView addSubview:_fenLeiScrollView];
//    
//    }
    
//
//   if (bScrollView.contentOffset.y<0)
//   {
//       bScrollView.scrollEnabled = NO;
//       _mainScrollView.scrollEnabled = YES;
//   }
//
//        if (_mainScrollView.contentOffset.y >= self.view.width*336/720 + height)
//        {
//            
//            [_mainScrollView setContentOffset:CGPointMake(0, self.view.width*336/720 + height)];
//            _mainScrollView.scrollEnabled = NO;
//             bScrollView.scrollEnabled = YES;
//            [bScrollView setContentOffset:CGPointMake(0, -0.01)];
//            
//        }
//        else
//        {
//    
//      
//        }
//    
//    if(_mainScrollView.contentOffset.y>= self.view.width*336/720 + height && _mainScrollView.scrollEnabled == NO)
//    {
//        _mainScrollView.scrollEnabled = YES;
//        
//    }

    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview
{
    ii = scrollview.contentOffset.x / scrollview.frame.size.width;
    [_pageControl setCurrentPage:ii];
    
    if (scrollview.tag == 300)
    {
        _shangPinPageControl.currentPage = _shangPinScrollView.contentOffset.x/_shangPinScrollView.frame.size.width;
    }
    
//     UIScrollView * bScrollViewA = (UIScrollView *)[_fenLeiScrollView viewWithTag:2000+fenleiIndex];

//    _xialaH = _mainScrollView.contentOffset.y;
    
//    [self.xialaHDictionary setObject:[NSString stringWithFormat:@"%f",bScrollViewA.contentOffset.y] forKey:goodsListID];
//    if (fabs(bScrollViewA.contentSize.height - bScrollViewA.frame.size.height - bScrollViewA.contentOffset.y) < 1.f)
//    {
//
//            [self GoosdListshangla];
//    }


    if (scrollview.tag == 200)
    {


//        NSLog(@"jjjjjj:::%f",scrollview.contentOffset.x/[UIScreen mainScreen].bounds.size.width);
        NSInteger m = (NSInteger)scrollview.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
        goodsListID = _shangmenData[m][@"id"];
        fenleiIndex = m;
        Tag = fenleiIndex + 1000000000;
        hiddenTag = -(fenleiIndex + 1000000000);
        
        for (UIButton * fenBtn in self.fenBtnArr)
        {
            fenBtn.selected = NO;
            if (fenBtn.tag == Tag)
            {
                fenBtn.selected = YES;
            }
        }
        for (UIButton * hiddenBtn in self.hiddenArray)
        {
            hiddenBtn.selected = NO;
            if (hiddenBtn.tag == hiddenTag)
            {
                hiddenBtn.selected = YES;
            }
        }
        __block NSInteger j = m;
        [UIView animateWithDuration:.3 animations:^{
            
            lineFen.frame=CGRectMake(m*[UIScreen mainScreen].bounds.size.width/5, _scroll.height-2, [UIScreen mainScreen].bounds.size.width/5, 2);
         
            [self srollScrollViewWith:j];

        
            
        
          
            hiddenLineFenLab.frame = CGRectMake(m*[UIScreen mainScreen].bounds.size.width/5, _hiddenScrollView.height-2, [UIScreen mainScreen].bounds.size.width/5, 2);
            
        }];
        
       
        UIScrollView * bScrollView = (UIScrollView *)[_fenLeiScrollView viewWithTag:2000+m];

//        for(int i = 0;i<[bScrollView.subviews count];i++)
//        {
//            [[bScrollView.subviews objectAtIndex:i]removeFromSuperview];
//        bScrollView.scrollEnabled = YES;
//        }
//        [bScrollView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
//        
//        bScrollView.footer.automaticallyRefresh=NO;
        if (_mainScrollView.contentOffset.y>=self.view.width*336/720 + height)
        {
            _xialaH = self.view.width*336/720 + height;
            //         [_mainScrollView setContentOffset:CGPointMake(0, _xialaH)];
        }
        else
        {
            _xialaH = _mainScrollView.contentOffset.y;
        }
      
      
            NSMutableArray * dataArray =[self.fenLeiDictionary objectForKey:goodsListID];
            if (dataArray.count == 0)
            {
                
                //            NSLog(@"%ld",[[self.indexDictionary objectForKey:goodsListID] integerValue]);
                [self GoosdListshangla];
                
            }
            else
            {
                //            _index = [[self.indexDictionary objectForKey:goodsListID] integerValue];
                //            NSLog(@"%ld",_index);
                [self GoodsF:bScrollView withArray:[self.fenLeiDictionary objectForKey:goodsListID]];
                
                
                //            _xialaH = [[self.xialaHDictionary objectForKey:goodsListID] floatValue];
                
                //            NSLog(@"_xialaH = %f",_xialaH);
                [_mainScrollView setContentOffset:CGPointMake(0, _xialaH)];
            }
        


    
        
      
        
        
    }
    
    

}




-(void)xiala{

//    [self.mainScrollView.header endRefreshing];
    Tag=1000000000+fenleiIndex;
    hiddenTag = -(1000000000+fenleiIndex);
    [self.indexDictionary setObject:[NSString stringWithFormat:@"%d",0] forKey:goodsListID];
    [self reshData];

}
-(void)shangla{
    _xialaH=_mainScrollView.contentOffset.y;
//
//    [self.xialaHDictionary setObject:[NSString stringWithFormat:@"%f",_xialaH] forKey:goodsListID];
    
    
    
    [self GoosdListshangla];

}

#pragma mark -- 创建_mainScrollView
-(void)newView{
    
  
    if (_mainScrollView) {
        [_mainScrollView removeFromSuperview];
    
    }
    if (_gongGaoTimer)
    {
        [_gongGaoTimer invalidate];
        _gongGaoTimer = nil;
    }
    [self ReshMessage];
    
    _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0 ,self.view.width, [UIScreen mainScreen].bounds.size.height-49)];

    _mainScrollView.backgroundColor = [UIColor whiteColor];
    
    _mainScrollView.tag = 220;
    _mainScrollView.delegate = self;
 
    
    [_mainScrollView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    [_mainScrollView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
    _mainScrollView.footer.automaticallyRefresh=NO;
    [self.view insertSubview:_mainScrollView belowSubview:self.NavImg];

    
      [self createShangJiaJinZhuBtn];
    _ImageScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*336/720)];
    _ImageScrollView.pagingEnabled=YES;
    _ImageScrollView.delegate=self;
    [_mainScrollView addSubview:_ImageScrollView];
    
    _ImageScrollView.contentSize=CGSizeMake(_ImageScrollView.width*_lunboData.count, _ImageScrollView.height);
//    _ImageScrollView.backgroundColor = [UIColor redColor];
    
    for (int i=0; i<_lunboData.count; i++) {
        UIButton *img = [[UIButton alloc]initWithFrame:CGRectMake(i*self.view.width, 0, _ImageScrollView.width+0*self.scale, _ImageScrollView.height+0*self.scale)];
        img.tag=1000+i;
        [img addTarget:self action:@selector(lunbo:) forControlEvents:UIControlEventTouchUpInside];
        [img setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_lunboData[i]]] placeholderImage:[UIImage imageNamed:@"center_img"]];
        [img setBackgroundImageForState:UIControlStateHighlighted withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_lunboData[i]]] placeholderImage:[UIImage imageNamed:@"center_img"]];

        [_ImageScrollView addSubview:img];
    }
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(lunbo) userInfo:nil repeats:YES];

    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(self.view.width/2-100*self.scale, _ImageScrollView.bottom-25, 200*self.scale,20)];
    _pageControl.currentPageIndicatorTintColor=blueTextColor;
    _pageControl.pageIndicatorTintColor=[UIColor whiteColor];
    _pageControl.numberOfPages=_lunboData.count;
    [_mainScrollView addSubview:_pageControl];
    
    UIImageView * yinYingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 153.0/753.0*[UIScreen mainScreen].bounds.size.width)];
    yinYingImageView.image = [UIImage imageNamed:@"top_bg"];
    [_mainScrollView addSubview:yinYingImageView];
    
    
    
    

    
    
//    10月26日新加搜索 //17年4.28更换位置和改变样式
    UIView *souVi=[[UIView alloc]initWithFrame:CGRectMake(10*self.scale,22+self.TitleLabel.height/2- (0.087743*(self.view.width-20*self.scale-self.TitleLabel.height))/2, self.view.width-20*self.scale-self.TitleLabel.height, 0.087743*(self.view.width-20*self.scale-self.TitleLabel.height))];
    souVi.alpha =0;
//    souVi.image=[UIImage imageNamed:@"so_2"];
    souVi.userInteractionEnabled=YES;
    souVi.backgroundColor =[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    souVi.tag = 9999999;
    souVi.clipsToBounds = YES;
    souVi.layer.cornerRadius = souVi.height/2;
    [_mainScrollView addSubview:souVi];
    
    UIImageView *souImg=[[UIImageView alloc]initWithFrame:CGRectMake(souVi.height/2-6*self.scale, 3*self.scale, souVi.height-6*self.scale, souVi.height-6*self.scale)];
    souImg.image=[UIImage imageNamed:@"search_home_ico"];
    souImg.alpha = 0.5;
    [souVi addSubview:souImg];
    
    UITextField *souTf=[[UITextField alloc]initWithFrame:CGRectMake(souImg.right, 0, souVi.width-souImg.right, souVi.height)];
    souTf.returnKeyType = UIReturnKeySearch;
    UITextField * textF = (UITextField *)[self.NavImg viewWithTag:888];
    souTf.text = textF.text;
    souTf.placeholder=@"请你输入想要买的商品名称";
    souTf.tag = 99999999;
    [souTf setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    souTf.font=SmallFont(self.scale);
    souTf.delegate = self;
    [souVi addSubview:souTf];
    
    //17年4.28新添加的消息按钮
    UIButton *talkImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [talkImg setImage:[UIImage imageNamed:@"lt"] forState:UIControlStateNormal];
    talkImg.frame=CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height,self.TitleLabel.height);
//    [talkImg addTarget:self action:@selector(talk) forControlEvents:UIControlEventTouchUpInside];
    talkImg.tag = 99999;
    //    talkImg.backgroundColor = [UIColor blackColor];
    talkImg.alpha = 0;
    [_mainScrollView addSubview:talkImg];
    
    
    UILabel *CarNum=[[UILabel alloc]initWithFrame:CGRectMake(talkImg.width-4.5, -.5, 5, 5)];
    CarNum.backgroundColor=[UIColor redColor];
    CarNum.layer.cornerRadius=CarNum.width/2;
    CarNum.layer.masksToBounds=YES;
    CarNum.textAlignment=NSTextAlignmentCenter;
    CarNum.font=SmallFont(1);
    CarNum.tag=99;
    CarNum.textColor=[UIColor whiteColor];
    CarNum.hidden=YES;
    [talkImg addSubview:CarNum];
//
//
//    UIButton *souBtn=[[UIButton alloc]initWithFrame:CGRectMake(souTf.right, 0, souVi.width-souTf.right, souVi.height)];
//    [souBtn setBackgroundImage:[UIImage imageNamed:@"so_3"] forState:UIControlStateNormal];
//    [souBtn setTitle:@"搜索" forState:UIControlStateNormal];
//    souBtn.titleLabel.font=SmallFont(self.scale);
//    [souBtn setTitleColor:whiteLineColore forState:UIControlStateNormal];
//    [souVi addSubview:souBtn];
//    [souBtn addTarget:self action:@selector(souBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    

    [self newShopView];
}


-(void)newShopView{
    
    //17年4月28日修改
    
    NSMutableArray *arr =[NSMutableArray new];
    NSMutableArray *icon = [NSMutableArray new];
    for (NSDictionary *ar in _lingShouData) {
        [arr addObject:[ar objectForKey:@"class_name"]];
        //        [arr addObjectsFromArray:arr];
        [icon addObject:[ar objectForKey:@"icon"]];
    }
    UIView *shopView=[[UIView alloc]initWithFrame:CGRectMake(0, _ImageScrollView.bottom, self.view.width, 180*self.scale)];
    shopView.backgroundColor=[UIColor whiteColor];
    [_mainScrollView addSubview:shopView];
    

    
    //商店滑动视图
    _shangPinScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20*self.scale, _mainScrollView.width, (shopView.height-60*self.scale)/2)];
    _shangPinScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * ceilf(arr.count/4.0),  (shopView.height-60*self.scale)/2);
    _shangPinScrollView.pagingEnabled = YES;
    _shangPinScrollView.bounces = YES;
    _shangPinScrollView.scrollEnabled = YES;
    //    _shangPinScrollView.backgroundColor = [UIColor redColor];
    _shangPinScrollView.delegate = self;
    _shangPinScrollView.showsVerticalScrollIndicator = NO;
    _shangPinScrollView.showsHorizontalScrollIndicator = NO;
    _shangPinScrollView.tag = 300;
    [shopView addSubview:_shangPinScrollView];
    
    //点
    _shangPinPageControl=[[MyPageControl alloc]initWithFrame:CGRectMake(self.view.width/2-100*self.scale, 10*self.scale, 200*self.scale, 10*self.scale)];
    //    _shangPinPageControl.currentPageIndicatorTintColor=[UIColor redColor];
    //        _shangPinPageControl.pageIndicatorTintColor=[UIColor grayColor];
    _shangPinPageControl.numberOfPages=ceilf(arr.count/4.0);
    //    _shangPinPageControl.currentPage = 0;
    [shopView addSubview:_shangPinPageControl];
    
    
    float setX=(self.view.width-35*self.scale)/4;
    float setY=(shopView.height-60*self.scale)/2;
    NSLog(@"%@",arr);
    for (int i=0; i<arr.count; i++)
    {
        
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(7*self.scale+i%arr.count*(setX+7*self.scale)+i/4*7*self.scale, 0, setX, setY)];
        button.backgroundColor=[UIColor clearColor];
        button.tag=i+1;
        [_shangPinScrollView addSubview:button];
        
        UIImageView *IconImage=[[UIImageView alloc]initWithFrame:CGRectMake(button.width/2-(button.height-18*self.scale)/2, 0, button.height-18*self.scale, button.height-18*self.scale)];
        [IconImage setImageWithURL:[NSURL URLWithString:icon[i]] placeholderImage:[UIImage imageNamed:@"not_1"]];
        [button addSubview:IconImage];
        //        button.backgroundColor = [UIColor redColor];
        
        UILabel *Title=[[UILabel alloc]initWithFrame:CGRectMake(0, IconImage.bottom+2.5*self.scale, button.width, 15*self.scale)];
        Title.textAlignment=NSTextAlignmentCenter;
        Title.font=SmallFont(self.scale);
        Title.text=arr[i];
        Title.alpha=0.7;
        [button addSubview:Title];
        
        [button addTarget:self action:@selector(ZaoCanEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        //        shopView.height=button.bottom+20*self.scale;
        
    }
    
     //附近图片imageView
    UIImageView * fuJinImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _shangPinScrollView.height/2,_shangPinScrollView.height/2)];
    fuJinImageView.image = [UIImage imageNamed:@"fj"];
    [shopView addSubview:fuJinImageView];
    //3月13日修改界面
    //生活服务按钮
    
    UIView * dizhiView  = [[UIView alloc]initWithFrame:CGRectMake(0, _shangPinScrollView.bottom+5*self.scale,self.view.width, self.view.width/15*2)];
    dizhiView.backgroundColor = superBackgroundColor;
    [shopView addSubview:dizhiView];
    
    _shengHuoFuWuBtn = [[UIButton alloc]initWithFrame:CGRectMake(10*self.scale,10*self.scale, (self.view.width - 50*self.scale)/4, (self.view.width - 50*self.scale)/4/3)];
    _shengHuoFuWuBtn.clipsToBounds = YES;
    _shengHuoFuWuBtn.layer.cornerRadius = (self.view.width - 50*self.scale)/4/3/2;
    [_shengHuoFuWuBtn addTarget:self action:@selector(shengHuoFuWuBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    _shengHuoFuWuBtn.backgroundColor = blueTextColor;
    [_shengHuoFuWuBtn setTitle:@"社区黄页" forState:(UIControlStateNormal)];
    _shengHuoFuWuBtn.titleLabel.font = SmallFont(self.scale);
    [dizhiView addSubview:_shengHuoFuWuBtn];
    
    //地址图片
    UIImageView * dizhiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width/2-10*self.scale, -10*self.scale, 20*self.scale/56*73, 20*self.scale)];
    dizhiImageView.image = [UIImage imageNamed:@"map"];
    [dizhiView addSubview:dizhiImageView];
    
    //地址按钮
    _dizhiBtn = [[UIButton alloc]initWithFrame:CGRectMake(_shengHuoFuWuBtn.right + 10*self.scale, _shengHuoFuWuBtn.top, _shengHuoFuWuBtn.width*2+10*self.scale, _shengHuoFuWuBtn.height)];
    _dizhiBtn.clipsToBounds= YES;
    _dizhiBtn.layer.cornerRadius = _dizhiBtn.height/2;
    _dizhiBtn.backgroundColor = blueTextColor;
    [_dizhiBtn addTarget:self action:@selector(dizhiBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_dizhiBtn setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"commname"] forState:(UIControlStateNormal)];
    _dizhiBtn.titleLabel.font = SmallFont(self.scale);
    [dizhiView addSubview:_dizhiBtn];

    
    //物业中心Btn
    _wuYeZhongXinBtn = [[UIButton alloc]initWithFrame:CGRectMake(_dizhiBtn.right + 10*self.scale, _shengHuoFuWuBtn.top, _shengHuoFuWuBtn.width, _shengHuoFuWuBtn.height)];
    [_wuYeZhongXinBtn addTarget:self action:@selector(wuYeZhongXinBtnCLick) forControlEvents:(UIControlEventTouchUpInside)];
    _wuYeZhongXinBtn.clipsToBounds = YES;
    _wuYeZhongXinBtn.layer.cornerRadius = _wuYeZhongXinBtn.height/2;
    _wuYeZhongXinBtn.backgroundColor = blueTextColor;
    [_wuYeZhongXinBtn setTitle:@"物业中心" forState:(UIControlStateNormal)];
    _wuYeZhongXinBtn.titleLabel.font = SmallFont(self.scale);
    [dizhiView addSubview:_wuYeZhongXinBtn];
    
//    self.hongDianImageView.frame = CGRectMake(wuyeBImage.right - 5*self.scale, wuyeBImage.top, 5*self.scale, 5*self.scale);
//    self.hongDianImageView.clipsToBounds = YES;
//    self.hongDianImageView.layer.cornerRadius  = 2.5*self.scale;
//    [_wuYeZhongXinBtn addSubview:self.hongDianImageView];
    

    
    //公告View
    
    UIView * gongGaoView = [[UIView alloc]initWithFrame:CGRectMake(0, dizhiView.bottom, self.view.width, self.view.width/75*8)];
//    gongGaoView.backgroundColor = [UIColor redColor];
    [shopView addSubview:gongGaoView];
    
   


//    //公告lab
    NSString * gongGaoString = _gongGaoDic[@"slogan"];
    CGRect gongGaoMoreRect = [self getStringWithFont:12*self.scale withString:@"更多" withWith:self.view.width];
    CGRect  rect = [self getStringWithFont:12*self.scale withString:gongGaoString withWith:self.view.width];
    UIView * labView = [[UIView alloc]initWithFrame:CGRectMake(10*self.scale +(gongGaoView.height - 14*self.scale)/21*62 + 5*self.scale,7*self.scale,self.view.width - (10*self.scale +(gongGaoView.height - 14*self.scale)/21*62) - 30*self.scale - gongGaoMoreRect.size.width + 20*self.scale, gongGaoView.height- 14*self.scale)];
    [gongGaoView addSubview:labView];
    if (rect.size.width > labView.width )
    {
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, labView.height)];
        lab1.font = SmallFont(self.scale);
        lab1.text = gongGaoString;
        [labView addSubview:lab1];
        
        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.right + 15*self.scale, 0, lab1.width, lab1.height)];
        lab2.font = SmallFont(self.scale);
        lab2.text = gongGaoString;
        [labView addSubview:lab2];

         _gongGaoTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            lab1.frame = CGRectMake(lab1.frame.origin.x - 1*self.scale, lab1.origin.y, lab1.width, lab1.height);
            lab2.frame = CGRectMake(lab2.frame.origin.x - 1*self.scale, lab2.origin.y, lab2.width, lab2.height);
            if (-lab1.frame.origin.x >= rect.size.width)
            {
                lab1.frame = CGRectMake(lab2.width + lab2.frame.origin.x+15*self.scale, lab1.origin.y, lab1.width, lab1.height);
            }
            if (-lab2.frame.origin.x >= rect.size.width)
            {
                lab2.frame = CGRectMake(lab1.width + lab1.frame.origin.x+15*self.scale, lab2.origin.y, lab2.width, lab2.height);
            }
                
        }];
        [[NSRunLoop currentRunLoop] addTimer:_gongGaoTimer forMode:NSDefaultRunLoopMode];

        
        
    }
    else
    {
        UILabel * gongGaoLab = [[UILabel alloc]initWithFrame:CGRectMake(0,0,labView.width,labView.height)];
        gongGaoLab.font = SmallFont(self.scale);
        gongGaoLab.text = gongGaoString;
        [labView addSubview:gongGaoLab];
    }
    
    //公告图片
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (gongGaoView.height - 14*self.scale)/21*62+10*self.scale+5*self.scale, gongGaoView.height)];
    v.backgroundColor = [UIColor whiteColor];

    [gongGaoView addSubview:v];
    UIImageView * gongGaoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 7*self.scale, (gongGaoView.height - 14*self.scale)/21*62, gongGaoView.height- 14*self.scale)];
    gongGaoImageView.image = [UIImage imageNamed:@"sq"];
    [v addSubview:gongGaoImageView];
    
    //公告更多按钮
    UIButton * gongGaoMoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width - gongGaoMoreRect.size.width - 20*self.scale , gongGaoImageView.top, gongGaoMoreRect.size.width+20*self.scale, gongGaoImageView.height)];
    [gongGaoMoreBtn setTitle:@"更多" forState:(UIControlStateNormal)];
    gongGaoMoreBtn.titleLabel.font = SmallFont(self.scale);
    [gongGaoMoreBtn setTitleColor:grayTextColor forState:(UIControlStateNormal)];
    [gongGaoMoreBtn addTarget:self action:@selector(gongGaoMoreBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [gongGaoView addSubview:gongGaoMoreBtn];
    gongGaoMoreBtn.backgroundColor = [UIColor whiteColor];
    shopView.height = gongGaoView.bottom;
    
    height = shopView.height;

    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.view.width*336/720 + height, self.view.width, 30*self.scale)];
    
    [_mainScrollView addSubview:_scroll];
    _scroll.showsHorizontalScrollIndicator=NO;
    _scroll.showsVerticalScrollIndicator=NO;
    
    UILabel * bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(0, _scroll.bottom - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    bottomLine.backgroundColor = blackLineColore;
    [_mainScrollView addSubview:bottomLine];
    
    _fenBtnArr = [NSMutableArray new];
    setX = 0*self.scale;
    for (int i=0; i<_shangmenData.count; i++) {
        
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:[NSString stringWithFormat:@"%@",_shangmenData[i][@"class_name"]] forState:0];
        [btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.7] forState:0];
//        [btn setTitleColor:[UIColor colorWithRed:0 green:134/255.0 blue:237/255.0 alpha:1] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
        btn.tag=1000000000+i;
        [_scroll addSubview:btn];
        btn.titleLabel.font=SmallFont(self.scale);
        //        [btn sizeToFit];
        //        btn.width=btn.width+20*self.scale;
        btn.width=[UIScreen mainScreen].bounds.size.width/5;
//        btn.backgroundColor = [UIColor redColor];
        btn.height=30*self.scale;
        btn.left=setX;
        [btn addTarget:self action:@selector(changeFenLei:) forControlEvents:UIControlEventTouchUpInside];
        setX = btn.right;
        [_fenBtnArr addObject:btn];
        if (btn.tag==Tag) {
            btn.selected=YES;
        }
    }
    
    if (!lineFen) {
        lineFen = [[UIView alloc] initWithFrame:CGRectMake((Tag-1000000000)*[UIScreen mainScreen].bounds.size.width/5, _scroll.height-2, [UIScreen mainScreen].bounds.size.width/5, 2)];
//        lineFen.backgroundColor=[UIColor colorWithRed:0 green:134/255.0 blue:237/255.0 alpha:1];
        lineFen.backgroundColor = blueTextColor;
        
    }
    [_scroll addSubview:lineFen];
    
    _scroll.contentSize=CGSizeMake(setX, 0);
    [_scroll setContentOffset:CGPointMake(_X, 0)];
    
    [self createHiddenVeiw];
    //    if (!_fenLeiScrollView)
    //    {
    //
    //    }
    _fenLeiScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,  self.view.width*336/720 + height+30*self.scale, _mainScrollView.width, [UIScreen mainScreen].bounds.size.height - 49-self.NavImg.height - _scroll.bottom)];
    _fenLeiScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * _shangmenData.count,  [UIScreen mainScreen].bounds.size.height - 49-self.NavImg.height - _scroll.bottom);
    
    _fenLeiScrollView.pagingEnabled = YES;
    
    _fenLeiScrollView.bounces = NO;
    
    _fenLeiScrollView.scrollEnabled = NO;
    
    _fenLeiScrollView.delegate = self;
    
    _fenLeiScrollView.tag = 200;
    
    [_fenLeiScrollView setContentOffset:CGPointMake(fenleiIndex * [UIScreen mainScreen].bounds.size.width, 0) animated:NO];
    
    [_mainScrollView addSubview:_fenLeiScrollView];
    
    
    for (int i = 0; i < _shangmenData.count; i++)
    {
        
        UIScrollView * bScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, _mainScrollView.width, [UIScreen mainScreen].bounds.size.height-self.NavImg.bottom-49 - _scroll.height)];
        
        //        [bScrollView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
        //
        //        bScrollView.footer.automaticallyRefresh=NO;
        
        bScrollView.bounces = NO;
        
        bScrollView.scrollEnabled = NO;
        
        bScrollView.delegate  = self;
        
        
        //NO 发送滚动的通知 但是就算手指移动 scroll也不会动了 YES 发送通知 scroll可以移动
        [bScrollView setCanCancelContentTouches:YES];
        [bScrollView setBounces:NO];
        // NO 立即通知touchesShouldBegin:withEvent:inContentView 看是否滚动 scroll
        [bScrollView setDelaysContentTouches:NO];
        
        bScrollView.tag = 2000+i;
        
        [_fenLeiScrollView addSubview:bScrollView];
        
        [self GoodsF:bScrollView withArray:[self.fenLeiDictionary objectForKey:_shangmenData[i][@"id"]]];
        
        
    }
    
    //    NSLog(@"%@",self.fenLeiDictionary);
    
}

-(void)lunbo{
    
//    static int i=1;
    
    if (ii<_lunboData.count)
    {
        [_ImageScrollView setContentOffset:CGPointMake((ii)*_ImageScrollView.width, 0) animated:YES];
        _pageControl.currentPage = ii;
        ii++;
    }else
    {
        ii=0;
        [_ImageScrollView setContentOffset:CGPointMake((ii)*_ImageScrollView.width, 0) animated:NO];
        _pageControl.currentPage = ii;
        ii++;
    }
    
    
    
}



-(void)lunbo:(UIButton *)vi{
    [self.view endEditing:YES];
    self.hidesBottomBarWhenPushed=YES;
    LunBoWebViewController *lunbo = [LunBoWebViewController new];
    
    
    NSArray * data;
    NSInteger tag;
    if (vi.tag>=10000) {
      data=_adverDa;
      tag=vi.tag-10000;
    }else{
      data=_lunda;
      tag=vi.tag-1000;
    }

    
    
    
    
    if ([data[tag][@"redirect_to"] isEqualToString:@"1"]) {
        return;
    }else if ([data[tag][@"redirect_to"] isEqualToString:@"2"]){
       lunbo.link = data[tag][@"redirect_to"];
        [self.navigationController pushViewController:lunbo animated:YES];

    
    }else if ([data[tag][@"redirect_to"] isEqualToString:@"3"]){
        deiletWebViewViewController *deole = [deiletWebViewViewController new];
        deole.html =[NSString stringWithFormat:@"%@",data[tag][@"detail"]] ;
        [self.navigationController pushViewController:deole animated:YES];

    }else if ([data[tag][@"redirect_to"] isEqualToString:@"4"]){
        

        
        //-----------------是否休息判断
        
        
        //判断是否休息的bool值
        
        //    BOOL isSleep1=NO;
        //    BOOL isSleep2=NO;
        //    BOOL isSleep3=NO;
        
        BOOL isSleep=YES;
        
        
        NSArray *timArr  = [data[tag][@"shop_info"][@"business_hour"] componentsSeparatedByString:@","];
        
        NSDate *now = [NSDate date];
        NSDateFormatter *nowFo = [[NSDateFormatter alloc]init];
        [nowFo setDateFormat:@"yyyy-MM-dd"];
        NSString *noewyers = [nowFo stringFromDate:now];
        
        for (NSString *str in timArr) {
            if ([str isEqualToString:@"1"]) {
                
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",data[tag][@"shop_info"][@"business_start_hour1"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",data[tag][@"shop_info"][@"business_end_hour1"]]];
                NSDateFormatter *fo = [[NSDateFormatter alloc]init];
                [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dates = [fo dateFromString:timeStart1];
                NSDate *dated = [fo dateFromString:timeEnd1];
                //开始的时间戳
                double times = [dates timeIntervalSince1970];
                //结束的时间戳
                double timed = [dated timeIntervalSince1970];
                //现在的时间戳
                double timen = [[NSDate date] timeIntervalSince1970];
                
                
                
                if (timen>times && timen<timed) {
                    isSleep=NO;
                }else{
                    isSleep=YES;
                }
                
                
                
            }
            
            
            
            
            else if ([str isEqualToString:@"2"]) {
                
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",data[tag][@"shop_info"][@"business_start_hour2"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",data[tag][@"shop_info"][@"business_end_hour2"]]];
                NSDateFormatter *fo = [[NSDateFormatter alloc]init];
                [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dates = [fo dateFromString:timeStart1];
                NSDate *dated = [fo dateFromString:timeEnd1];
                //开始的时间戳
                double times = [dates timeIntervalSince1970];
                //结束的时间戳
                double timed = [dated timeIntervalSince1970];
                //现在的时间戳
                double timen = [[NSDate date] timeIntervalSince1970];
                
                
                
                if (timen>times && timen<timed) {
                    isSleep=NO;
                }else{
                    isSleep=YES;
                }
                
                
                
            }
            
            
            else  if ([str isEqualToString:@"3"]) {
                
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",data[tag][@"shop_info"][@"business_start_hour3"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",data[tag][@"shop_info"][@"business_end_hour3"]]];
                NSDateFormatter *fo = [[NSDateFormatter alloc]init];
                [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dates = [fo dateFromString:timeStart1];
                NSDate *dated = [fo dateFromString:timeEnd1];
                //开始的时间戳
                double times = [dates timeIntervalSince1970];
                //结束的时间戳
                double timed = [dated timeIntervalSince1970];
                //现在的时间戳
                double timen = [[NSDate date] timeIntervalSince1970];
                
                
                
                if (timen>times && timen<timed) {
                    isSleep=NO;
                }else{
                    isSleep=YES;
                }
                
            }
            
            
        }
        
        
        
        if ([data[tag][@"shop_info"][@"business_hour"] isEqualToString:@""]) {
            isSleep=NO;
        }
        
        if ([data[tag][@"shop_info"][@"status"] isEqualToString:@"3"]) {
            
            isSleep=YES;
            
        }else{


            NSString *week = [self weekdayStringFromDate:[NSDate date]];
            if ([week isEqualToString:@"周六"]) {
                if ([data[tag][@"shop_info"][@"off_on_saturday"] isEqualToString:@"2"]) {
                    isSleep=YES;
                }else{
                    isSleep=NO;
                }
            }else if ([week isEqualToString:@"周日"]){
                if ([data[tag][@"shop_info"][@"off_on_sunday"] isEqualToString:@"2"]) {
                    isSleep=YES;
                }else{
                    isSleep=NO;
                }
            }
        }

        
        
       
        
        
        
        [self.view endEditing:YES];
        //-----------------

        
        if ([data[tag][@"shop_info"][@"shop_type"] isEqualToString:@"2"]) {
            GanXiShopViewController *ganxi = [GanXiShopViewController new];
            if ([data[tag][@"shop_info"][@"is_open_chat"]isEqualToString:@"2"]) {
                ganxi.isOpen=NO;
            }else{
                ganxi.isOpen=YES;
            }
            
            
            ganxi.issleep=isSleep;
            ganxi.ID=data[tag][@"shop_id"];
            ganxi.titlee=data[tag][@"shop_info"][@"shop_name"];
            ganxi.topSetimg = data[tag][@"shop_info"][@"logo"];
            ganxi.shop_user_id=data[tag][@"shop_info"][@"user_id"];
            [self.navigationController pushViewController:ganxi animated:YES];
            
        }else{
            
            
            BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
            if ([data[tag][@"shop_info"][@"is_open_chat"]isEqualToString:@"2"]) {
                info.isopen=NO;
            }else{
                info.isopen=YES;
            }
            info.tel=[NSString stringWithFormat:@"%@",data[tag][@"hotline"]];
            info.issleep=isSleep;
            info.ID=data[tag][@"shop_id"];
            info.titlete=_lunda[tag][@"shop_info"][@"shop_name"];
            info.shopImg = data[tag][@"shop_info"][@"logo"];
            info.gonggao = data[tag][@"shop_info"][@"notice"];
            info.yunfei =data[tag][@"shop_info"][@"delivery_fee"];
            info.manduoshaofree=data[tag][@"shop_info"][@"free_delivery_amount"];
            info.shop_user_id=data[tag][@"shop_info"][@"user_id"];
            
           
            
            [self.navigationController pushViewController:info animated:YES];
            
        }
        
    
    
    }else if ([data[tag][@"redirect_to"] isEqualToString:@"5"]){
        
        
        BOOL isSleep=YES;
        
        
        NSArray *timArr  = [data[tag][@"shop_info"][@"business_hour"] componentsSeparatedByString:@","];
        
        NSDate *now = [NSDate date];
        NSDateFormatter *nowFo = [[NSDateFormatter alloc]init];
        [nowFo setDateFormat:@"yyyy-MM-dd"];
        NSString *noewyers = [nowFo stringFromDate:now];
        
        for (NSString *str in timArr) {
            if ([str isEqualToString:@"1"]) {
                
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",data[tag][@"shop_info"][@"business_start_hour1"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",data[tag][@"shop_info"][@"business_end_hour1"]]];
                NSDateFormatter *fo = [[NSDateFormatter alloc]init];
                [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dates = [fo dateFromString:timeStart1];
                NSDate *dated = [fo dateFromString:timeEnd1];
                //开始的时间戳
                double times = [dates timeIntervalSince1970];
                //结束的时间戳
                double timed = [dated timeIntervalSince1970];
                //现在的时间戳
                double timen = [[NSDate date] timeIntervalSince1970];
                
                
                
                if (timen>times && timen<timed) {
                    isSleep=NO;
                }else{
                    isSleep=YES;
                }
                
                
                
            }
            
            
            
            
            else if ([str isEqualToString:@"2"]) {
                
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",data[tag][@"shop_info"][@"business_start_hour2"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",data[tag][@"shop_info"][@"business_end_hour2"]]];
                NSDateFormatter *fo = [[NSDateFormatter alloc]init];
                [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dates = [fo dateFromString:timeStart1];
                NSDate *dated = [fo dateFromString:timeEnd1];
                //开始的时间戳
                double times = [dates timeIntervalSince1970];
                //结束的时间戳
                double timed = [dated timeIntervalSince1970];
                //现在的时间戳
                double timen = [[NSDate date] timeIntervalSince1970];
                
                
                
                if (timen>times && timen<timed) {
                    isSleep=NO;
                }else{
                    isSleep=YES;
                }
                
                
                
            }
            
            
            else  if ([str isEqualToString:@"3"]) {
                
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",data[tag][@"shop_info"][@"business_start_hour3"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",data[tag][@"shop_info"][@"business_end_hour3"]]];
                NSDateFormatter *fo = [[NSDateFormatter alloc]init];
                [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dates = [fo dateFromString:timeStart1];
                NSDate *dated = [fo dateFromString:timeEnd1];
                //开始的时间戳
                double times = [dates timeIntervalSince1970];
                //结束的时间戳
                double timed = [dated timeIntervalSince1970];
                //现在的时间戳
                double timen = [[NSDate date] timeIntervalSince1970];
                
                
                
                if (timen>times && timen<timed) {
                    isSleep=NO;
                }else{
                    isSleep=YES;
                }
                
            }
            
            
        }
        
        
        
        if ([data[tag][@"shop_info"][@"business_hour"] isEqualToString:@""]) {
            isSleep=NO;
        }
        
        if ([data[tag][@"shop_info"][@"status"] isEqualToString:@"3"]) {
            
            isSleep=YES;
            
        }else{
            
            
            NSString *week = [self weekdayStringFromDate:[NSDate date]];
            if ([week isEqualToString:@"周六"]) {
                if ([data[tag][@"shop_info"][@"off_on_saturday"] isEqualToString:@"2"]) {
                    isSleep=YES;
                }else{
                    isSleep=NO;
                }
            }else if ([week isEqualToString:@"周日"]){
                if ([data[tag][@"shop_info"][@"off_on_sunday"] isEqualToString:@"2"]) {
                    isSleep=YES;
                }else{
                    isSleep=NO;
                }
            }
        }
        
        

        
        
        
        
        
        
        
        
        self.hidesBottomBarWhenPushed=YES;
        ShopInfoViewController *buess = [ShopInfoViewController new];
        
        if ([data[tag][@"shop_info"][@"is_open_chat"]isEqualToString:@"2"]) {
            buess.isopen=NO;
        }else{
            buess.isopen=YES;
        }
        buess.issleep=isSleep;
        buess.islunbo=YES;
        buess.yes=NO;
        buess.price =_lunda[tag][@"prod_info"][@"price"];
        buess.shop_name=_lunda[tag][@"prod_info"][@"shop_name"];
        buess.orshoucang=YES;
        buess.shop_user_id=data[tag][@"shop_info"][@"shop_id"];
        buess.shop_id = data[tag][@"shop_id"];
        buess.prod_id = data[tag][@"prod_id"];
        buess.xiaoliang = data[tag][@"prod_info"][@"sales"];
        buess.shoucang = data[tag][@"prod_info"][@"collect_time"];
//        buess.yunfei
        /**
         *  2016 8 27
         */
        buess.tel=data[tag][@"prod_info"][@"hotline"];
        /**
         *  2016.8.27
         */
        
        [self.navigationController pushViewController:buess animated:YES];
    
    
    }
    
    self.hidesBottomBarWhenPushed=NO;

}
#pragma mark -- 公告更多按钮点击事件
- (void)gongGaoMoreBtnClick
{
    self.hidesBottomBarWhenPushed = YES;
    BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
    
    info.ID = _gongGaoDic[@"shop_id"];
    [self.navigationController pushViewController:info animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)souBtnEvent:(UIButton *)sender{
//    [self.view endEditing:YES];
//    UITextField *souTf;
//    if (self.NavImg.alpha>0)
//    {
//       souTf=[self.NavImg viewWithTag:888];
//    }
//    else
//    {
//       souTf = [self.mainScrollView viewWithTag:888];
//    }
//   
//    if ([souTf.text isEmptyString]) {
//        [self ShowAlertWithMessage:@"请你输入想要购买的商品名称"];
//        return;
//    }
//    
//    self.hidesBottomBarWhenPushed=YES;
//    SouViewController *vi=[SouViewController new];
//    vi.keyword=souTf.text.trimString;
//    [self.navigationController pushViewController:vi animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark -- 分类按钮点击事件
-(void)changeFenLei:(UIButton *)sender{

//    _xialaH = _mainScrollView.contentOffset.y;
//    
//    [self.xialaHDictionary setObject:[NSString stringWithFormat:@"%f",_xialaH] forKey:goodsListID];
    [self srollScrollViewWith:sender.tag - 1000000000];
    for (UIButton *btn in _fenBtnArr)
    {
        btn.selected=NO;
//        NSLog(@"按钮的个数%d",)
    }

    NSLog(@"sender.tag%ld",sender.tag-1000000001);
    
    //            UIImageView *Hline=(UIImageView *)[self.view viewWithTag:3];
    //            Hline.frame=CGRectMake((button.tag-1)*self.view.width/2, _ToolView.height-.5, self.view.width/2, .5) ;

    
    [UIView animateWithDuration:.3 animations:^{
        
        lineFen.frame=CGRectMake((sender.tag-1000000000)*[UIScreen mainScreen].bounds.size.width/5, _scroll.height-2, [UIScreen mainScreen].bounds.size.width/5, 2);
        hiddenLineFenLab.frame = CGRectMake((sender.tag-1000000000)*[UIScreen mainScreen].bounds.size.width/5, _hiddenScrollView.height-2, [UIScreen mainScreen].bounds.size.width/5, 2);
    }];
  
    
    
    sender.selected=YES;
    Tag=sender.tag;
    hiddenTag = - Tag;
    fenleiIndex = Tag - 1000000000;
    for (UIButton * hiddenBtn in self.hiddenArray)
    {
        hiddenBtn.selected = NO;
        if (hiddenBtn.tag == hiddenTag)
        {
            hiddenBtn.selected = YES;
        }
    }
    UIScrollView * bScrollView = (UIScrollView *)[_fenLeiScrollView viewWithTag:2000+fenleiIndex];
    bScrollView.scrollEnabled = YES;
    
    [_fenLeiScrollView setContentOffset:CGPointMake((sender.tag - 1000000000)*[UIScreen mainScreen].bounds.size.width, 0) animated:NO];
    _X = _scroll.contentOffset.x;
    
    goodsListID = _shangmenData[fenleiIndex][@"id"];
    
    if (_mainScrollView.contentOffset.y>=self.view.width*336/720 + height + 60*self.scale)
    {
        _xialaH = self.view.width*336/720 + height + 60*self.scale;
//         [_mainScrollView setContentOffset:CGPointMake(0, _xialaH)];
    }
    else
    {
        _xialaH = _mainScrollView.contentOffset.y;
    }
    
    NSMutableArray * dataArray =[self.fenLeiDictionary objectForKey:goodsListID];
    if (dataArray.count == 0)
    {
//        _index = 0;
//        [self.indexDictionary setObject:[NSString stringWithFormat:@"%ld",_index] forKey:goodsListID];
        [self GoosdListshangla];
    }
//    [_mainScrollView setContentOffset:CGPointMake(0, self.view.width*336/720 + height) animated:YES];
    else
    {
        UIScrollView * bScrollView = (UIScrollView *)[_fenLeiScrollView viewWithTag:2000+fenleiIndex];
        [self GoodsF:bScrollView withArray:[self.fenLeiDictionary objectForKey:goodsListID]];
        
//        _xialaH = [[self.xialaHDictionary objectForKey:goodsListID] floatValue];
//        
        [_mainScrollView setContentOffset:CGPointMake(0, _xialaH)];
    }
    
 
    
//    for (NSDictionary *dic in _shangmenData) {
//        
//        if ([[NSString stringWithFormat:@"%@",dic[@"class_name"]] isEqualToString:[NSString stringWithFormat:@"%@",sender.titleLabel.text]]) {
//            
//            goodsListID = [NSString stringWithFormat:@"%@",dic[@"id"]];
//            _xialaH=_mainScrollView.contentOffset.y;
//            _index=0;
//            [self GoosdListshangla];//获取数据
//            
//            break;
//        }
//        
//    }

}

//#pragma mark -- 判断分类信息是否有值
//- (BOOL)fenLeiDictionaryValeIsNull:(NSString *)key with
//{
//    if () {
//        <#statements#>
//    }
//}

//-(void)GoodsF:(UIView *)view{
//    _mainScrollView.backgroundColor=whiteLineColore;
////    _mainScrollView.backgroundColor = [UIColor redColor];
//    
//    NSLog(@"调用一次：：");
//    
//    float w = (self.view.width-45*self.scale)/2;
//    
//    for (int i=0; i<_weishangData.count; i++) {
//        float x = (w+15*self.scale)*(i%2);
//        float y = ((w+40*self.scale)+15*self.scale)*(i/2);
//
//        UIButton *bgVi = [[UIButton alloc]initWithFrame:CGRectMake(15*self.scale+x, view.bottom+10*self.scale+y, w,w+40*self.scale)];
//        bgVi.backgroundColor=[UIColor clearColor];
//        [_mainScrollView addSubview:bgVi];
//        [bgVi addTarget:self action:@selector(goodsEvent:) forControlEvents:UIControlEventTouchUpInside];
//        bgVi.tag=1000000000000+i;
//        
//        
//        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgVi.width, bgVi.width-20*self.scale)];
//        img.contentMode=UIViewContentModeScaleAspectFill;
//        img.clipsToBounds=YES;
//        img.layer.cornerRadius=2;
//        img.layer.borderColor=blackLineColore.CGColor;
//        img.layer.borderWidth=.5;
//        [img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_weishangData[i][@"img1"]]] placeholderImage:[UIImage imageNamed:@"center_img"]];
//        [bgVi addSubview:img];
//        
//        
//        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom+5*self.scale, bgVi.width,50*self.scale)];
//        la.text=[NSString stringWithFormat:@"%@",_weishangData[i][@"prod_name"]];
//        la.numberOfLines=2;
//        la.textColor=[UIColor blackColor];
//        la.alpha=.7;
//        la.font=SmallFont(self.scale);
//        [bgVi addSubview:la];
//        [la sizeToFit];
//        
//        UILabel *newPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom+ 40*self.scale, 0, 0)];
//        NSLog(@"%@",_weishangData);
//        NSLog(@"%@",_weishangData[i][@"unit"]);
//        newPrice.text=[NSString stringWithFormat:@"￥%@元/%@",_weishangData[i][@"price"],_weishangData[i][@"unit"]];
//        newPrice.font=[UIFont boldSystemFontOfSize:15*self.scale];
//        newPrice.textColor=[UIColor redColor];
//        [bgVi addSubview:newPrice];
//        [newPrice sizeToFit];
//        
//        if (newPrice.width>100*self.scale) {
//            newPrice.width=100*self.scale;
//        }
//        
//        
//        UILabel *oldPrice = [[UILabel alloc]initWithFrame:CGRectMake(newPrice.right+5*self.scale, la.bottom+7*self.scale, 0, 0)];
//        oldPrice.text=[NSString stringWithFormat:@"￥%@",_weishangData[i][@"origin_price"]];
//        oldPrice.font=[UIFont boldSystemFontOfSize:10*self.scale];
//        oldPrice.textColor=grayTextColor;
//        [bgVi addSubview:oldPrice];
//        [oldPrice sizeToFit];
//        oldPrice.centerY=newPrice.centerY;
//        
//        
//        
//        
//        
////        if ([[NSString stringWithFormat:@"%@",_weishangData[i][@"origin_price"]] integerValue]<=0) {
////            oldPrice.hidden=YES;
////        }
//        
//        
//        UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(0, oldPrice.height/2, oldPrice.width, .5)];
//        lin.backgroundColor=grayTextColor;
//        [oldPrice addSubview:lin];
////        if ([[NSString stringWithFormat:@"%@",_weishangData[i][@"origin_price"]] isEqualToString:[NSString stringWithFormat:@"%@",_weishangData[i][@"price"]]]) {
////            oldPrice.hidden=YES;
////            lin.hidden=YES;
////        }
//        
//        
//        float yuan = [[NSString stringWithFormat:@"%@",_weishangData[i][@"origin_price"]] floatValue];
//        float xian = [[NSString stringWithFormat:@"%@",_weishangData[i][@"price"]] floatValue];
//
//        if (xian>=yuan) {
//            oldPrice.hidden=YES;
//            lin.hidden=YES;
//        }
//        
//        
//        _mainScrollView.contentSize=CGSizeMake(0, bgVi.bottom+15*self.scale);
//        
//    }
//
//
//
//
//}
#pragma mark -- 创建滑动的ScrollView
-(void)GoodsF:(UIScrollView *)view withArray:(NSArray *)array
{
    NSLog(@"%@",array);
    view.backgroundColor = [UIColor whiteColor];
   
    for (UIButton * btn in view.subviews)
    {
        [btn removeFromSuperview];
    }
    NSLog(@"%@",array);
//    _mainScrollView.backgroundColor=whiteLineColore;
    
    

//    UIScrollView * bScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, _mainScrollView.width, [UIScreen mainScreen].bounds.size.height-self.NavImg.bottom-49-view.bottom)];
    
   
    
//    bScrollView.userInteractionEnabled = NO;
//    
//    bScrollView.tag = 100;
//    
////    bScrollView.pagingEnabled = YES;
//    
//    bScrollView.delegate = self;
    
    
    
    float w = self.view.width;
    
    for (int i=0; i<array.count; i++) {
        
        float x = 0;
        float y = 100*self.scale*i;
        
        UIButton *bgVi = [[UIButton alloc]initWithFrame:CGRectMake(x,y,w,100*self.scale)];
        bgVi.backgroundColor=[UIColor clearColor];
        [view addSubview:bgVi];
        [bgVi addTarget:self action:@selector(goodsEvent:) forControlEvents:UIControlEventTouchUpInside];
        bgVi.tag=1000000000000+i;
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, bgVi.height - 20*self.scale, bgVi.height-20*self.scale)];
        img.contentMode=UIViewContentModeScaleAspectFill;
        img.clipsToBounds=YES;
        img.layer.cornerRadius=2;
//        img.layer.borderColor=blackLineColore.CGColor;
//        img.layer.borderWidth=.5;
        
//        float x = (w+15*self.scale)*(i%2);
//        float y = ((w+40*self.scale)+15*self.scale)*(i/2);
        
//        UIButton *bgVi = [[UIButton alloc]initWithFrame:CGRectMake(15*self.scale+x, 10*self.scale+y, w,w+40*self.scale)];
//        bgVi.backgroundColor=[UIColor clearColor];
//        [view addSubview:bgVi];
//        [bgVi addTarget:self action:@selector(goodsEvent:) forControlEvents:UIControlEventTouchUpInside];
//        bgVi.tag=1000000000000+i;
        
        
//        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgVi.width, bgVi.width-20*self.scale)];
//        img.contentMode=UIViewContentModeScaleAspectFill;
//        img.clipsToBounds=YES;
//        img.layer.cornerRadius=2;
//        img.layer.borderColor=blackLineColore.CGColor;
//        img.layer.borderWidth=.5;
        NSLog(@"%@",array[i][@"img1"]);
        NSString *cut = array[i][@"img1"];
        NSString *imagename = [cut lastPathComponent];
        NSString *path = [cut stringByDeletingLastPathComponent];
        NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb320."]];

        NSLog(@"%@",smallImgUrl);
          [img setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"center_img"]];
        [bgVi addSubview:img];
        
        //商品名称
        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(img.right + 10*self.scale, img.top, bgVi.width - img.right-10*self.scale,20*self.scale)];
        la.text=[NSString stringWithFormat:@"%@",array[i][@"prod_name"]];
        la.numberOfLines=2;
        la.textColor=[UIColor blackColor];
        la.alpha=.7;
        la.font=SmallFont(self.scale);
        [bgVi addSubview:la];
//        [la sizeToFit];
        
        
//        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom+5*self.scale, bgVi.width,50*self.scale)];
//        la.text=[NSString stringWithFormat:@"%@",array[i][@"prod_name"]];
//        la.numberOfLines=2;
//        la.textColor=[UIColor blackColor];
//        la.alpha=.7;
//        la.font=SmallFont(self.scale);
//        [bgVi addSubview:la];
//        [la sizeToFit];
        //商品价格
        NSString * preceString = [NSString stringWithFormat:@"￥%@元/%@",array[i][@"price"],array[i][@"unit"]];
        
        NSString * firstString = [NSString stringWithFormat:@"￥%@元",array[i][@"price"]];
        NSString * secondString = [NSString stringWithFormat:@"/%@",array[i][@"unit"]];
        CGRect PriceRect = [self getStringWithFont:12*self.scale withString:preceString withWith:999999];
        UILabel *newPrice = [[UILabel alloc]initWithFrame:CGRectMake(img.right + 10*self.scale, la.bottom,PriceRect.size.width,20*self.scale)];

//        newPrice.text=preceString;
//        newPrice.font=[UIFont boldSystemFontOfSize:12*self.scale];
        newPrice.font = SmallFont(self.scale);
        newPrice.textColor=[UIColor redColor];
        
        NSMutableAttributedString * attributeString = [[NSMutableAttributedString    alloc]initWithString:preceString];
        [attributeString addAttribute:NSForegroundColorAttributeName value:grayTextColor range:NSMakeRange(firstString.length, secondString.length)];
        newPrice.attributedText = attributeString;
        
        [bgVi addSubview:newPrice];
//        [newPrice sizeToFit];
        
//        if (newPrice.width>100*self.scale) {
//            newPrice.width=100*self.scale;
//        }
        
        //原价
        NSString * oldPriceString = [NSString stringWithFormat:@"￥%@",array[i][@"origin_price"]];
        CGRect oldRect =  [self getStringWithFont:10*self.scale withString:oldPriceString withWith:9999999];
        UILabel *oldPrice = [[UILabel alloc]initWithFrame:CGRectMake(newPrice.right+5*self.scale,la.bottom+20*self.scale-oldRect.size.height,oldRect.size.width,oldRect.size.height)];
//        oldPrice.backgroundColor = [UIColor redColor];
        oldPrice.text=[NSString stringWithFormat:@"￥%@",array[i][@"origin_price"]];
//        oldPrice.font=[UIFont boldSystemFontOfSize:10*self.scale];
        oldPrice.font = Small10Font(self.scale);
        oldPrice.textColor=grayTextColor;
        [bgVi addSubview:oldPrice];
//        [oldPrice sizeToFit];
//        oldPrice.centerY=newPrice.centerY;
        
        
        
        
        
        //        if ([[NSString stringWithFormat:@"%@",_weishangData[i][@"origin_price"]] integerValue]<=0) {
        //            oldPrice.hidden=YES;
        //        }
        
        //销售数量
        UILabel * xiaoshouShuLiangLab = [[UILabel alloc]initWithFrame:CGRectMake(img.right+10*self.scale, newPrice.bottom, self.view.width - img.right-10*self.scale, 20*self.scale)];
        xiaoshouShuLiangLab.textColor = grayTextColor;
        xiaoshouShuLiangLab.font = Small10Font(self.scale);
        NSString * sales = [NSString stringWithFormat:@"%@",array[i][@"sales"]];
        xiaoshouShuLiangLab.text = [NSString stringWithFormat:@"已售%@",sales];
        [bgVi addSubview:xiaoshouShuLiangLab];
        //来自哪里
        UILabel * comeFromlab = [[UILabel alloc]initWithFrame:CGRectMake(img.right+10*self.scale, xiaoshouShuLiangLab.bottom, self.view.width - img.right - 10*self.scale, 20*self.scale)];
        comeFromlab.textColor = grayTextColor;
        comeFromlab.font = Small10Font(self.scale);
        comeFromlab.text = [NSString stringWithFormat:@"来自%@",array[i][@"shop_name"]];
        [bgVi addSubview:comeFromlab];
        
        
        
        UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(0, oldPrice.height/2, oldPrice.width, .5)];
        
        lin.backgroundColor=grayTextColor;
        [oldPrice addSubview:lin];
        
        UILabel * bottomLab = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 100*self.scale - 0.3, self.view.width - 20*self.scale, 0.3)];
        bottomLab.backgroundColor = grayTextColor;
        [bgVi addSubview:bottomLab];
        
        //        if ([[NSString stringWithFormat:@"%@",_weishangData[i][@"origin_price"]] isEqualToString:[NSString stringWithFormat:@"%@",_weishangData[i][@"price"]]]) {
        //            oldPrice.hidden=YES;
        //            lin.hidden=YES;
        //        }
        
        
        
        
        float yuan = [[NSString stringWithFormat:@"%@",array[i][@"origin_price"]] floatValue];
        float xian = [[NSString stringWithFormat:@"%@",array[i][@"price"]] floatValue];
        
        if (xian>=yuan) {
            oldPrice.hidden=YES;
            lin.hidden=YES;
        }
        
 
        
        view.size = CGSizeMake([UIScreen mainScreen].bounds.size.width,bgVi.bottom);
//                view.contentSize=CGSizeMake(bScrollView.width, bgVi.bottom);
//        _fenLeiScrollView.size = CGSizeMake([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - self.NavImg.height - 49 - _scroll.height );
        _fenLeiScrollView.size = CGSizeMake([UIScreen mainScreen].bounds.size.width,view.bottom );
        //        _fenLeiScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * _shangmenData.count, bView.height);
        _fenLeiScrollView.scrollEnabled = YES;
        _mainScrollView.contentSize=CGSizeMake(0, _fenLeiScrollView.bottom);

        
    }
    
    
    

//    bView.backgroundColor = [UIColor redColor];
    

    
}

#pragma mark -- 创建隐藏的scrollView
- (void)createHiddenVeiw
{
    if (_hiddenScrollView)
    {
        [_hiddenScrollView removeFromSuperview];
        for (UIView * view in _hiddenScrollView.allSubviews)
        {
            [view removeFromSuperview];
            hiddenLineFenLab = nil;
        }
        _hiddenScrollView = nil;
    }
     _hiddenScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, [UIScreen mainScreen].bounds.size.width, 30*self.scale)];
    _hiddenScrollView.showsVerticalScrollIndicator = NO;
    _hiddenScrollView.showsHorizontalScrollIndicator = NO;
    _hiddenScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_hiddenScrollView];
    UILabel * bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(0, _hiddenScrollView.height - 0.5, [UIScreen mainScreen].bounds.size.width*ceilf(_shangmenData.count/5.0), 0.5)];
    bottomLine.backgroundColor = blackLineColore;
    [_hiddenScrollView addSubview:bottomLine];
    _hiddenScrollView.hidden = YES;
    _hiddenArray = [NSMutableArray new];
    float  setX = 0*self.scale;
    for (int i=0; i<_shangmenData.count; i++) {
        
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:[NSString stringWithFormat:@"%@",_shangmenData[i][@"class_name"]] forState:0];
        [btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.7] forState:0];
//        [btn setTitleColor:[UIColor colorWithRed:0 green:134/255.0 blue:237/255.0 alpha:1] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
        btn.tag=-(1000000000+i);
        [_hiddenScrollView addSubview:btn];
        btn.titleLabel.font=SmallFont(self.scale);
        //        [btn sizeToFit];
        //        btn.width=btn.width+20*self.scale;
        btn.width=[UIScreen mainScreen].bounds.size.width/5;
        btn.height=30*self.scale;
        btn.left=setX;
        [btn addTarget:self action:@selector(hiddenChangeFenLei:) forControlEvents:UIControlEventTouchUpInside];
        setX = btn.right;
        [_hiddenArray addObject:btn];
        if (btn.tag==hiddenTag) {
            btn.selected=YES;
        }
    }
    NSLog(@"%@",hiddenLineFenLab);
    
//    if (!hiddenLineFenLab)
//    {
        hiddenLineFenLab = [[UIView alloc] initWithFrame:CGRectMake(((-hiddenTag)-1000000000)*[UIScreen mainScreen].bounds.size.width/5, _hiddenScrollView.height-2, [UIScreen mainScreen].bounds.size.width/5, 2)];
     
//        hiddenLineFenLab.backgroundColor=[UIColor colorWithRed:0 green:134/255.0 blue:237/255.0 alpha:1];
        hiddenLineFenLab.backgroundColor = blueTextColor;
        [_hiddenScrollView addSubview:hiddenLineFenLab];
//    }

    
    _hiddenScrollView.contentSize=CGSizeMake(setX, 0);
    [_hiddenScrollView setContentOffset:CGPointMake(_X, 0)];
   
}
- (void)hiddenChangeFenLei:(UIButton *)sender
{
    [self srollScrollViewWith:-sender.tag-1000000000];
    for (UIButton *btn in self.hiddenArray)
    {
        btn.selected=NO;
        //        NSLog(@"按钮的个数%d",)
    }
    
//    NSLog(@"sender.tag%ld",sender.tag-1000000001);
    
    //            UIImageView *Hline=(UIImageView *)[self.view viewWithTag:3];
    //            Hline.frame=CGRectMake((button.tag-1)*self.view.width/2, _ToolView.height-.5, self.view.width/2, .5) ;
    
    
    [UIView animateWithDuration:.3 animations:^{
        
        lineFen.frame=CGRectMake((-sender.tag-1000000000)*[UIScreen mainScreen].bounds.size.width/5, _scroll.height-2, [UIScreen mainScreen].bounds.size.width/5, 2);
        hiddenLineFenLab.frame = CGRectMake((-sender.tag-1000000000)*[UIScreen mainScreen].bounds.size.width/5, _hiddenScrollView.height-2, [UIScreen mainScreen].bounds.size.width/5, 2);
    }];
    
    
    
    sender.selected=YES;
    hiddenTag =sender.tag;
    Tag = - hiddenTag;
    fenleiIndex = Tag - 1000000000;
    for (UIButton * hiddenBtn in self.fenBtnArr)
    {
        hiddenBtn.selected = NO;
        if (hiddenBtn.tag == Tag)
        {
            hiddenBtn.selected = YES;
        }
    }
    UIScrollView * bScrollView = (UIScrollView *)[_fenLeiScrollView viewWithTag:2000+fenleiIndex];
    bScrollView.scrollEnabled = YES;
    
    [_fenLeiScrollView setContentOffset:CGPointMake((-sender.tag - 1000000000)*[UIScreen mainScreen].bounds.size.width, 0) animated:NO];
    _X = _scroll.contentOffset.x;
    
    goodsListID = _shangmenData[fenleiIndex][@"id"];
    
    if (_mainScrollView.contentOffset.y>=self.view.width*336/720 + height + 60*self.scale)
    {
        _xialaH = self.view.width*336/720 + height+60*self.scale;
        //         [_mainScrollView setContentOffset:CGPointMake(0, _xialaH)];
    }
    else
    {
        _xialaH = _mainScrollView.contentOffset.y;
    }
    
    NSMutableArray * dataArray =[self.fenLeiDictionary objectForKey:goodsListID];
    if (dataArray.count == 0)
    {
        //        _index = 0;
        //        [self.indexDictionary setObject:[NSString stringWithFormat:@"%ld",_index] forKey:goodsListID];
        [self GoosdListshangla];
    }
    //    [_mainScrollView setContentOffset:CGPointMake(0, self.view.width*336/720 + height) animated:YES];
    else
    {
        UIScrollView * bScrollView = (UIScrollView *)[_fenLeiScrollView viewWithTag:2000+fenleiIndex];
        [self GoodsF:bScrollView withArray:[self.fenLeiDictionary objectForKey:goodsListID]];
        
        //        _xialaH = [[self.xialaHDictionary objectForKey:goodsListID] floatValue];
        //
        [_mainScrollView setContentOffset:CGPointMake(0, _xialaH)];
    }
}
-(void)goodsEvent:(UIButton *)sender{

    
    NSMutableArray * dataArray = [self.fenLeiDictionary objectForKey:goodsListID];
    NSDictionary *shopInfo = dataArray[sender.tag-1000000000000];
    
    NSLog(@"%@",shopInfo);
    
   BOOL isSeelp = [self getTimeWith:shopInfo];

//    if (isSeelp) {
//        [self ShowAlertWithMessage:@"休息了"];
//    }else{
//        [self ShowAlertWithMessage:@"工作了"];
//    }

    self.hidesBottomBarWhenPushed=YES;
    ShopInfoViewController *buess = [ShopInfoViewController new];
    
    if ([shopInfo[@"is_open_chat"]isEqualToString:@"2"]) {
        buess.isopen=NO;
    }else{
        buess.isopen=YES;
    }
    buess.isgo=YES;
    buess.issleep=isSeelp;
    buess.yes=NO;
    buess.price =shopInfo[@"price"];
    buess.shop_name=shopInfo[@"shop_name"];
    buess.orshoucang=YES;
    buess.shop_user_id=shopInfo[@"shop_id"];
    buess.shop_id = shopInfo[@"shop_id"];
    buess.prod_id = shopInfo[@"prod_id"];
    buess.xiaoliang = shopInfo[@"sales"];
    buess.shoucang = shopInfo[@"collect_time"];
    buess.gongGao = shopInfo[@"notice"];
    //        buess.yunfei
    /**
     *  2016 8 27
     */
    buess.tel=shopInfo[@"hotline"];
    

    /**
     *  2016.8.27
     */
    
    [self.navigationController pushViewController:buess animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
}

























































#pragma mark - 上门服务
-(void)newShangMen:(UIView *)view{
    
    UIView *SMView=[[UIView alloc]initWithFrame:CGRectMake(0, view.bottom+10, self.view.width, 130*self.scale)];
    SMView.backgroundColor=[UIColor whiteColor];
    [_mainScrollView addSubview:SMView];
    UIImageView *topline=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, .5)];
    topline.backgroundColor=blackLineColore;
    [SMView addSubview:topline];
    
    UILabel *RedLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 35*self.scale, 20*self.scale)];
    RedLabel.text=@"一键";
    RedLabel.font=Big15Font(self.scale);
    RedLabel.textColor=[UIColor redColor];
    [SMView addSubview:RedLabel];
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, RedLabel.bottom+10*self.scale, self.view.width-20*self.scale, .5)];
    line.backgroundColor=blackLineColore;
    [SMView addSubview:line];
    

    UILabel *SMLabel=[[UILabel alloc]initWithFrame:CGRectMake(RedLabel.right, RedLabel.top, 100*self.scale, RedLabel.height)];
    SMLabel.text=@"· 上门服务";
    SMLabel.font=Big15Font(self.scale);
    [SMView addSubview:SMLabel];
    UIButton *SJRZ=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-90*self.scale, SMLabel.top, 80*self.scale, SMLabel.height)];
    [SJRZ setTitle:@"商家进驻" forState:UIControlStateNormal];
    [SJRZ setTitleColor:blueTextColor forState:UIControlStateNormal];
    [SJRZ addTarget:self action:@selector(shangjiajinzhu) forControlEvents:UIControlEventTouchUpInside];
    SJRZ.titleLabel.font=SmallFont(self.scale);
    [SMView addSubview:SJRZ];
    [SJRZ sizeToFit];
    SJRZ.right=self.view.width-10*self.scale;
    
    
//    LineView *sotLine=[[LineView alloc]initWithFrame:CGRectMake(0, SMLabel.bottom, self.view.width, 1)];
//    [SMView addSubview:sotLine];
    
    NSMutableArray *title = [NSMutableArray new];
    NSMutableArray *icon = [NSMutableArray new];

    for (NSDictionary *dic in _shangmenData) {
        [title addObject:[dic objectForKey:@"class_name"]];
        [icon addObject:[dic objectForKey:@"icon"]];

    }

    float btnH=(SMView.height-line.bottom-50)/2;
    float btnW=(self.view.width-65*self.scale)/4;
    for (int i=0; i<title.count; i++)
    {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale+i%4*(btnW+15*self.scale),line.bottom+10+i/4*(btnH+10), btnW, btnH)];
        [button setTitle:title[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.alpha=0.7;
        [button setBackgroundImage:[UIImage setImgNameBianShen:@"index_btn"] forState:UIControlStateNormal];
         [button setBackgroundImage:[UIImage setImgNameBianShen:@"index_btn_b"] forState:UIControlStateHighlighted];
        button.titleLabel.font=SmallFont(self.scale);
        button.tag=i+10;
        [button addTarget:self action:@selector(ShangMenFuWuEvent:) forControlEvents:UIControlEventTouchUpInside];
        [SMView addSubview:button];
        
        SMView.height=button.bottom+10*self.scale;
    }
    [self newWeiShang:SMView];
    
    
    UIView *botine = [[UIView alloc]initWithFrame:CGRectMake(0, SMView.height-.5, self.view.width, .5)];
    botine.backgroundColor=blackLineColore;
    [SMView addSubview:botine];
    
}

-(void)shangjiajinzhu{
    [self.view endEditing:YES];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id493901993?mt=8"]];
    self.hidesBottomBarWhenPushed=YES;
    ShangjiaJinZhuViewController *shangjia = [ShangjiaJinZhuViewController new];
    [self.navigationController pushViewController:shangjia animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
}


-(void)newWeiShang:(UIView *)view{
    UIView *WeiShang=[[UIView alloc]initWithFrame:CGRectMake(0, view.bottom+10, self.view.width, 220*self.scale)];
    WeiShang.backgroundColor=[UIColor whiteColor];
    [_mainScrollView addSubview:WeiShang];
    UIImageView *topline=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, .5)];
    topline.backgroundColor=blackLineColore;
    [WeiShang addSubview:topline];
    
    UILabel *SMLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale,10*self.scale, 150*self.scale, 20*self.scale)];
    SMLabel.text=@"精选分类";
//    SMLabel.attributedText=[self stringColorAllString:@"精选分类" redString:@"本地"];
    SMLabel.font=Big15Font(self.scale);
    [WeiShang addSubview:SMLabel];
    UIButton *SJRZ=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-90*self.scale, SMLabel.top, 80*self.scale, SMLabel.height)];
    [SJRZ setTitle:@"我要开网店" forState:UIControlStateNormal];
    [SJRZ setTitleColor:blueTextColor forState:UIControlStateNormal];
    [SJRZ addTarget:self action:@selector(woyaokai) forControlEvents:UIControlEventTouchUpInside];
    SJRZ.titleLabel.font=SmallFont(self.scale);
    [WeiShang addSubview:SJRZ];
    [SJRZ sizeToFit];
    SJRZ.right=self.view.width-10*self.scale;
    
    
    LineView *sotLine=[[LineView alloc]initWithFrame:CGRectMake(0, SMLabel.bottom+10*self.scale, self.view.width, 1)];
    [WeiShang addSubview:sotLine];
    
    
   // NSArray *weidian = @[@"化妆品",@"食品",@"便利店",@"衣服",@"娱乐",@"美甲",@"居家",@"直销"];
    float setX=(self.view.width-35*self.scale)/4;
    float setY=(WeiShang.height-100*self.scale)/2;
    for (int i=0; i<_weishangData.count; i++)
    {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(7*self.scale+i%4*(setX+5*self.scale),sotLine.bottom+10*self.scale+i/4*(setY+18*self.scale), setX, setY)];
        button.backgroundColor=[UIColor clearColor];
        button.tag=i+100;
        [WeiShang addSubview:button];
        
        UIImageView *IconImage=[[UIImageView alloc]initWithFrame:CGRectMake(button.width/2-(button.height-24*self.scale)/2, 0, button.height-14*self.scale, button.height-14*self.scale)];
        //IconImage.backgroundColor=[UIColor yellowColor];
        [IconImage setImageWithURL:[NSURL URLWithString:[_weishangData[i] objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"not_1"]];
        [button addSubview:IconImage];
        
        UILabel *Title=[[UILabel alloc]initWithFrame:CGRectMake(IconImage.left-2.5*self.scale, IconImage.bottom+5*self.scale, IconImage.width+5*self.scale, 20*self.scale)];
        //Title.backgroundColor=[UIColor greenColor];
        Title.textAlignment=NSTextAlignmentCenter;
        Title.font=SmallFont(self.scale);
        Title.text=[_weishangData[i] objectForKey:@"class_name"];
        [button addSubview:Title];
        Title.alpha=0.7;
        [button addTarget:self action:@selector(WeiShangEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        WeiShang.height=button.bottom+20*self.scale;
    }
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, WeiShang.height-.5, self.view.width, .5)];
    line.backgroundColor=blackLineColore;
    [WeiShang addSubview:line];
   
    if (_five) {
        [self bottonViewWithSetYY:WeiShang.bottom];
    }else{
      _mainScrollView.contentSize=CGSizeMake(self.view.width, WeiShang.bottom+10);
    }
    
}


-(void)woyaokai{
    [self.view endEditing:YES];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id493901993?mt=8"]];
    self.hidesBottomBarWhenPushed=YES;
    WoYaoKaiWiDianViewController *kaiweidian = [WoYaoKaiWiDianViewController new];
    [self.navigationController pushViewController:kaiweidian animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

-(void)bottonViewWithSetYY:(CGFloat )setYY{
    
    CGFloat w=self.view.width-20*self.scale;
    CGFloat h=150*self.scale;
    CGFloat setY=setYY+10*self.scale;
    CGFloat x=10*self.scale;
    CGFloat y=setY;
    for (int i=0; i<_adverData.count; i++) {
        
        
        
        UIButton *img = [[UIButton alloc]initWithFrame:CGRectMake(x, y, w, 150*self.scale)];
        img.tag=10000+i;
        [img addTarget:self action:@selector(lunbo:) forControlEvents:UIControlEventTouchUpInside];
        [img setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_adverData[i]]] placeholderImage:[UIImage imageNamed:@"center_img"]];
        [img setBackgroundImageForState:UIControlStateHighlighted withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_adverData[i]]] placeholderImage:[UIImage imageNamed:@"center_img"]];
        
        [_mainScrollView addSubview:img];
        y=img.bottom+10*self.scale;
        setY=img.bottom;
    }
    _mainScrollView.contentSize=CGSizeMake(self.view.width, setY+10*self.scale);
}
#pragma mark - 按钮事件//地址按钮点击事件
- (void)dizhiBtnClick
{
    if (![Stockpile sharedStockpile].isLogin) {
        [self ShowAlertWithMessage:@"请先登录"];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    SheQuManagerViewController * shequMVC = [[SheQuManagerViewController alloc]init];
    shequMVC.nojiantou = YES;
    [self.navigationController pushViewController:shequMVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)shengHuoFuWuBtnClick
{
    self.hidesBottomBarWhenPushed = YES;
    ShangJiaViewController * shangjiaVC = [[ShangJiaViewController alloc]init];
    [self.navigationController pushViewController:shangjiaVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)wuYeZhongXinBtnCLick
{
    
    self.hidesBottomBarWhenPushed = YES;
    WuYeZhongXinViewController * wuyeVC = [[WuYeZhongXinViewController alloc]init];
    self.hongDianImageView.hidden = YES;
    [self.navigationController pushViewController:wuyeVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
-(void)shangjiaJinZhuBtnClick
{
    self.hidesBottomBarWhenPushed = YES;
    ShangjiaJinZhuViewController *shangjiaVC = [[ShangjiaJinZhuViewController alloc]init];
    [self.navigationController pushViewController:shangjiaVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
-(void)ZaoCanEvent:(UIButton *)button{
    
    
    
    [self.view endEditing:YES];
    
    
    self.hidesBottomBarWhenPushed = YES;
    NSInteger tag = button.tag-1;
    NSArray * shopS=(NSArray *)[_lingShouData[tag] objectForKey:@"shop_info"];
   
    if (shopS.count==1) {
        [self skipToDetail:(NSDictionary *)(shopS.firstObject)];
        self.hidesBottomBarWhenPushed=NO;
        return;
    }
    
    
    NSString *ID = [_lingShouData[tag] objectForKey:@"id"];
    NSLog(@"++++%@",_lingShouData);
    BreakFirstViewController *breakF = [[BreakFirstViewController alloc]init];
    breakF.type=@"zancan";
    breakF.ID=ID;
    breakF.shop_type=@"1";
    breakF.is_weishop=@"2";
    breakF.namet = [_lingShouData[tag] objectForKey:@"class_name"];
    [self.navigationController pushViewController:breakF animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    

}
-(void)skipToDetail:(NSDictionary *)shopInfo{
    
    //-----------------是否休息判断
    
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

    
    
    //-----------------是否休息判断end
    [self.view endEditing:YES];
    
    NSString *ID = [shopInfo objectForKey:@"id"];
    NSString * shop_type=[shopInfo objectForKey:@"shop_type"];
    
    if ([shop_type isEqualToString:@"2"]) {
        GanXiShopViewController *ganxi = [GanXiShopViewController new];
        if ([shopInfo[@"is_open_chat"] isEqualToString:@"2"]) {
            ganxi.isOpen=NO;
        }else{
            ganxi.isOpen=YES;
        }
        ganxi.ID=ID;
        ganxi.gonggao = [shopInfo objectForKey:@"notice"];
        ganxi.issleep=issleep;
        ganxi.titlee=[shopInfo objectForKey:@"shop_name"];
        ganxi.topSetimg = [shopInfo objectForKey:@"logo"];
        ganxi.shop_user_id=[shopInfo objectForKey:@"shop_user_id"];
        [self.navigationController pushViewController:ganxi animated:YES];
        
    }else{
        
        
        BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
        
        if ([shopInfo[@"is_open_chat"]isEqualToString:@"2"]) {
            info.isopen=NO;
        }else{
            info.isopen=YES;
        }
        
        info.ID=ID;
        info.titlete=[shopInfo objectForKey:@"shop_name"];
        info.shopImg = [shopInfo objectForKey:@"logo"];
        info.gonggao = [shopInfo objectForKey:@"notice"];
        info.yunfei =[shopInfo objectForKey:@"delivery_fee"];
        info.manduoshaofree=[shopInfo objectForKey:@"free_delivery_amount"];
        info.shop_user_id=[shopInfo objectForKey:@"shop_user_id"];
        info.issleep=issleep;
        /**
         *  2016 8 27
         */
        info.tel=[shopInfo objectForKey:@"hotline"];
        /**
         *  2016.8.27
         */

        

        [self.navigationController pushViewController:info animated:YES];
        
    }
    
    
}


-(void)ShangMenFuWuEvent:(UIButton *)sender{
    [self.view endEditing:YES];
    self.hidesBottomBarWhenPushed=YES;
    NSInteger tag = sender.tag-10;
    
    
    NSArray * shops=[_shangmenData[tag] objectForKey:@"shop_info"];
    if (shops.count==1) {
   
        [self skipToDetail:(NSDictionary *)(shops.firstObject)];
        self.hidesBottomBarWhenPushed=NO;
        return;
        
    }
    
    
  
    NSString *ID = [_shangmenData[tag] objectForKey:@"id"];

    BreakFirstViewController *breakF = [[BreakFirstViewController alloc]init];
    breakF.type=@"weidian";
    breakF.ID=ID;
    breakF.shop_type=@"2";
    breakF.is_weishop=@"2";
    breakF.namet = [_shangmenData[tag] objectForKey:@"class_name"];
    [self.navigationController pushViewController:breakF animated:YES];

    self.hidesBottomBarWhenPushed=NO;
 

    
}

-(void)WeiShangEvent:(UIButton *)button{
    [self.view endEditing:YES];
    self.hidesBottomBarWhenPushed = YES;
    NSInteger tag = button.tag-100;
    
    NSArray * shopS=(NSArray *)[_weishangData[tag] objectForKey:@"shop_info"];
    
    if (shopS.count==1) {
        [self skipToDetail:(NSDictionary *)(shopS.firstObject)];
        self.hidesBottomBarWhenPushed=NO;
        return;
    }
    
    
    NSString *ID = [_weishangData[tag] objectForKey:@"id"];
    
    BreakFirstViewController *breakF = [[BreakFirstViewController alloc]init];
    breakF.type=@"weidian";
    breakF.ID=ID;
    breakF.shop_type=@"1";
    breakF.is_weishop=@"1";
    breakF.namet = [_weishangData[tag] objectForKey:@"class_name"];

    [self.navigationController pushViewController:breakF animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ReshMessage];
        
        [self.appdelegate appNum];
    });
    
}
-(void)ReshMessage{
    int unreadMsgCount =[self.appdelegate ReshData];
    UILabel *CarNum=(UILabel *)[self.view viewWithTag:66];
    UILabel * hiddenCarNum = (UILabel *)[self.view viewWithTag:99];
    if (unreadMsgCount>0) {
        CarNum.hidden=NO;
        hiddenCarNum.hidden = NO;
        CarNum.text=[NSString stringWithFormat:@"%d",unreadMsgCount];
        hiddenCarNum.text=[NSString stringWithFormat:@"%d",unreadMsgCount];
        if (unreadMsgCount>99) {
            CarNum.text=[NSString stringWithFormat:@"99+"];
            hiddenCarNum.text=[NSString stringWithFormat:@"99+"];
        }
        
        NSLog(@"%d",[CarNum.text intValue]);
        
//        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:[CarNum.text intValue]];

    }else{
        CarNum.hidden=YES;
        hiddenCarNum.hidden = YES;
      //  [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    }
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
            [item setBadgeValue:nil];
        }
        else
        {
            [item setBadgeValue:value];
        }
    }
    else
    {
        [item setBadgeValue:nil];
    }
}
#pragma mark - 导航
-(void)newNav{
//   NSString *addrss = [[NSUserDefaults standardUserDefaults]objectForKey:@"commname"];
//
//    
//    self.TitleLabel.text=addrss;
    
//    UIButton *talkImg = [UIButton buttonWithType:UIButtonTypeCustom];
//    [talkImg setBackgroundImage:[UIImage imageNamed:@"index_xiaoxi"] forState:UIControlStateNormal];
//    [talkImg setBackgroundImage:[UIImage imageNamed:@"dian_ico_01"] forState:UIControlStateHighlighted];
//    talkImg.frame=CGRectMake(self.view.width-35*self.scale, self.TitleLabel.top+10*self.scale, 23*self.scale, 23*self.scale);
//    [talkImg addTarget:self action:@selector(talk) forControlEvents:UIControlEventTouchUpInside];
//    [self.NavImg addSubview:talkImg];
//   UITextField *
    
//    self.NavImg.alpha = 0;
    self.Navline.backgroundColor = [UIColor clearColor];
    
    self.NavImg.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    
    //10月26日新加搜索 //17年4.28更换位置和改变样式
    UIView *souVi=[[UIView alloc]initWithFrame:CGRectMake(10*self.scale,22+self.TitleLabel.height/2- (0.087743*(self.view.width-20*self.scale-self.TitleLabel.height))/2, self.view.width-20*self.scale-self.TitleLabel.height, 0.087743*(self.view.width-20*self.scale-self.TitleLabel.height))];
    //    souVi.image=[UIImage imageNamed:@"so_2"];
    souVi.userInteractionEnabled=YES;
    souVi.layer.borderColor = [UIColor whiteColor].CGColor;
    souVi.layer.borderWidth = 0.3;
    souVi.backgroundColor =[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    souVi.clipsToBounds = YES;
    souVi.tag = 12345;
    souVi.layer.cornerRadius = souVi.height/2;
    [self.NavImg addSubview:souVi];
    
    UIImageView *souImg=[[UIImageView alloc]initWithFrame:CGRectMake(souVi.height/2-6*self.scale, 3*self.scale, souVi.height-6*self.scale, souVi.height-6*self.scale)];
    souImg.image=[UIImage imageNamed:@"search_home_ico"];
    souImg.alpha = 0.5;
    [souVi addSubview:souImg];
    
    UITextField *souTf=[[UITextField alloc]initWithFrame:CGRectMake(souImg.right, 0, souVi.width-souImg.right, souVi.height)];
    souTf.returnKeyType = UIReturnKeySearch;
    souTf.placeholder=@"请你输入想要买的商品名称";
    [souTf setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    souTf.font=SmallFont(self.scale);
    souTf.tag=888;
    souTf.delegate = self;
    [souVi addSubview:souTf];
    
    //消息按钮
    
    UIButton *talkImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [talkImg setImage:[UIImage imageNamed:@"lt"] forState:UIControlStateNormal];
    talkImg.tag = 1234;
//    [talkImg setImage:[UIImage imageNamed:@"dian_ico_01"] forState:UIControlStateHighlighted];
    talkImg.frame=CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height,self.TitleLabel.height);
    [talkImg addTarget:self action:@selector(talk) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:talkImg];

    
    UILabel *CarNum=[[UILabel alloc]initWithFrame:CGRectMake(talkImg.width-20, 2, 18, 18)];
    CarNum.backgroundColor=[UIColor redColor];
    CarNum.layer.cornerRadius=CarNum.width/2;
    CarNum.layer.masksToBounds=YES;
    CarNum.textAlignment=NSTextAlignmentCenter;
    CarNum.font=SmallFont(1);
    CarNum.tag=66;
    CarNum.textColor=[UIColor whiteColor];
    CarNum.hidden=YES;
    [talkImg addSubview:CarNum];
}


-(void)talk{
    if ([Stockpile sharedStockpile].isLogin==NO) {
        
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                [self login];
            }
            
        }];
        
        return;
    }

    [self.view endEditing:YES];
    self.hidesBottomBarWhenPushed=YES;
    RCDChatListViewController *rong = [[RCDChatListViewController alloc]init];
    [self.navigationController pushViewController:rong animated:YES];
    self.hidesBottomBarWhenPushed=NO;


}
#pragma mark -- 滑动视图
- (void)srollScrollViewWith:(NSInteger)index
{
    CGFloat  width = 0;
    for (int i=1; i<_shangmenData.count - 4; i++)
    {
        
        if (index == _shangmenData.count - 1)
        {
            index = index - 1;
            
        }
        width = (index+1)/(4+i)*[UIScreen mainScreen].bounds.size.width/5+width;
    }
    
    [_scroll setContentOffset:CGPointMake(width ,0) animated:YES];
    [_hiddenScrollView setContentOffset:CGPointMake(width ,0) animated:YES];
}

#pragma mark -- 键盘监听事件创建
- (void)loadNotificationCell
{
    
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
}
#pragma mark -- 键盘监听事件
-(void)keyboardChangeFrame:(NSNotification *)notification
{
    
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat keyHeigth = self.view.height-rect.origin.y;
        
        CGFloat top =( self.view.width*336/720 + height + 60*self.scale+self.NavImg.bottom);
        CGFloat offset = _mainScrollView.contentOffset.y;
//        
//        CGFloat textbottom= top-offset;
//        
//        if (textbottom>0 && keyHeigth+textbottom>self.view.height) {
//             _mainScrollView.contentOffset=CGPointMake(0,keyHeigth+textbottom-self.view.height+offset);
//        }
//        if (keyHeigth <= 0) {
//            _mainScrollView.contentOffset=CGPointMake(0,0);
//        }
        
        
      
        
        
        //_mainScrollView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width, rect.origin.y-self.NavImg.bottom);
    }];
}

- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSLog(@"keyBoard:%f", keyboardSize.height);
    NSLog(@"键盘将要出现");
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.25];
    //    _bottomView.frame = CGRectMake(0, RM_VHeight - 44*self.scale - keyboardSize.height, RM_VWidth, 44*self.scale);
//    _mainScrollView.frame = CGRectMake(0, self.NavImg.bottom, [UIScreen mainScreen].bounds.size.width, self.view.height-self.NavImg.bottom -keyboardSize.height);
//    _keyeBoardShowHeight = _mainScrollView.contentOffset.y;
//    if (-([UIScreen mainScreen].bounds.size.height -self.NavImg.height-( self.view.width*336/720 + height + 60*self.scale + keyboardSize.height))>_keyeBoardShowHeight)
//    {
////        _mainScrollView.contentOffset = CGPointMake(0, self.view.width*336/720 + height + 60*self.scale - keyboardSize.height);
//        [_mainScrollView setContentOffset:CGPointMake(0, -([UIScreen mainScreen].bounds.size.height -self.NavImg.height-( self.view.width*336/720 + height + 60*self.scale + keyboardSize.height))) animated:NO];
//    }
//    [_mainScrollView setContentOffset:CGPointMake(0, self.view.width*336/720 + height + 60*self.scale - keyboardSize.height) animated:YES];
   
    //    [UIView commitAnimations];
    
}

- (void)keyboardShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    NSLog(@"键盘出现");
    
    
    NSLog(@"keyBoard:%f", keyboardSize.height);
    NSLog(@"键盘将要出现");
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.25];
    //    _bottomView.frame = CGRectMake(0, RM_VHeight - 44*self.scale - keyboardSize.height, RM_VWidth, 44*self.scale);
    //    _mainScrollView.frame = CGRectMake(0, self.NavImg.bottom, [UIScreen mainScreen].bounds.size.width, self.view.height-self.NavImg.bottom -keyboardSize.height);
//    _keyeBoardShowHeight = _mainScrollView.contentOffset.y;
//    if (-([UIScreen mainScreen].bounds.size.height -self.NavImg.height-( self.view.width*336/720 + height + 60*self.scale + keyboardSize.height))>_keyeBoardShowHeight)
//    {
//        //        _mainScrollView.contentOffset = CGPointMake(0, self.view.width*336/720 + height + 60*self.scale - keyboardSize.height);
//        [_mainScrollView setContentOffset:CGPointMake(0, -([UIScreen mainScreen].bounds.size.height -self.NavImg.height-( self.view.width*336/720 + height + 60*self.scale + keyboardSize.height))) animated:NO];
//    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSLog(@"keyBoard:%f", keyboardSize.height);
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.25];
    //    _bottomView.frame = CGRectMake(0, RM_VHeight - 44*self.scale, RM_VWidth, 44*self.scale);
//      _mainScrollView.contentOffset = CGPointMake(0, _keyeBoardShowHeight);
    //    [UIView commitAnimations];
    NSLog(@"键盘将要隐藏");
}

- (void)keyboardHide:(NSNotification *)notif {
    

    if (self.view.hidden == YES)
    {
        return;
    }
    NSLog(@"键盘隐藏");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    

    UITextField *souTf=[self.view viewWithTag:888];
    if ([souTf.text isEmptyString]) {
        [self ShowAlertWithMessage:@"请你输入想要购买的商品名称"];
        [self.view endEditing:YES];
        return [textField resignFirstResponder];
        
      
    }
    
    self.hidesBottomBarWhenPushed=YES;
    SouViewController *vi=[SouViewController new];
    vi.keyword=souTf.text.trimString;
    [self.navigationController pushViewController:vi animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    [self.view endEditing:YES];
    return [textField resignFirstResponder];
  
   
}


@end
