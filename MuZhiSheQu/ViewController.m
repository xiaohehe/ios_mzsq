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
//#import "GanXiShopViewController.h"
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
#import "IMViewController.h"
#import "DataBase.h"
#import "AppUtil.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

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
    BOOL isLock;
    //NSTimer *timer;
    NSString* onlinemark;
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
@property(nonatomic,strong) UIView * hiddleGongGaoView;
@property(nonatomic,strong)NSMutableDictionary *shopData;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden=NO;
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
    if(self.appdelegate.isRefresh){
        self.appdelegate.isRefresh=false;
        [self refreshPage];
    }
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
            [self ShowAlertWithMessage:@"没有数据，请重新选择社区"];
        }
        return;
    }
}

/*请求购物车*/
-(void) requestShopingCart:(BOOL) isRefresh{
    [self.appdelegate.shopDictionary removeAllObjects];
//    NSString *userid =  [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
//    if(userid==nil)
//        return;
    NSArray* arr=[[DataBase sharedDataBase] getAllFromCart];
    //NSLog(@"shop_cart====%@",arr);
    if (arr.count>0) {
//        if(arr==nil||arr.count==0){
//            [self.appdelegate.shopDictionary removeAllObjects];
//            if(isRefresh)
//                [self xiala];
//            return ;
//        }
        for (int i = 0; i < arr.count; i ++) {
            NSArray * Prod_infoArr = arr[i][@"prod_info"];
            for (int j = 0; j < Prod_infoArr.count; j ++) {
                [self.appdelegate.shopDictionary setObject:Prod_infoArr[j][@"prod_count"] forKey:Prod_infoArr[j][@"prod_id"]];
                //NSLog(@"prodid==%@,prodcount==%@",Prod_infoArr[j][@"prod_id"],Prod_infoArr[j][@"prod_count"]);
            }
        }
        
        NSInteger totalNumber = 0;
        //NSLog(@"%@",arr);
        for (NSDictionary * dic in arr)
        {
            NSInteger number = 0;
            for (NSDictionary * prod_infoDIc in dic[@"prod_info"])
            {
                number = number + [prod_infoDIc[@"prod_count"] integerValue];
            }
            totalNumber = totalNumber + number;
        }
        //NSLog(@"totalNumber::%ld",totalNumber);
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)totalNumber] forKey:@"GouWuCheShuLiang"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self gouWuCheShuZi];
        //NSLog(@"self.appdelegate.shopDictionary==%@",self.appdelegate.shopDictionary);
        if(isRefresh)
            [self xiala];
    }else{
        //[self.appdelegate.shopDictionary removeAllObjects];
        if(isRefresh)
            [self xiala];
    }
//    NSDictionary *dic = @{@"user_id":userid};
//    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
//    [analy showCartWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
//        //NSLog(@"cartCode==%@ msg=%@",code,msg);
//        if ([code isEqualToString:@"0"]) {
//            NSArray* arr=models;
//            if(arr==nil||arr.count==0){
//                [self.appdelegate.shopDictionary removeAllObjects];
//                if(isRefresh)
//                    [self xiala];
//                return ;            }
//            for (int i = 0; i < arr.count; i ++) {
//                NSArray * Prod_infoArr = arr[i][@"prod_info"];
//                for (int j = 0; j < Prod_infoArr.count; j ++) {
//                    [self.appdelegate.shopDictionary setObject:Prod_infoArr[j][@"prod_count"] forKey:Prod_infoArr[j][@"prod_id"]];
//                }
//            }
//            if(isRefresh)
//                [self xiala];
//        }else if([code isEqualToString:@"1"]){
//            [self.appdelegate.shopDictionary removeAllObjects];
//            if(isRefresh)
//                [self xiala];
//        }
//    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshPage" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestShopingCart:false];
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
        /**
         *广告
         */
        [anle ADD:@{@"community_id":[self getCommid]} Block:^(id models, NSString *code, NSString *msg) {
            NSLog(@"广告==%@",models);
            if ([code isEqualToString:@"0"]) {
                _ADDic=models;
                //[self ADData:models];
            }
        }];
    }
    if ([Stockpile sharedStockpile].isLogin) {
        [self gongGaoDian];
    }
    [self createShangJiaJinZhuBtn];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage)  name:@"refreshPage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage)  name:@"refreshPage" object:nil];
  // timer= [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(setLock) userInfo:nil repeats:NO];
}

-(void) setLock{
    isLock=false;
    NSLog(@"isLock=false");
}

-(void) refreshPage{
    NSLog(@"--refreshPage");
    [self requestShopingCart:true];
}

- (void)createShangJiaJinZhuBtn{
    if (_shangjiaJinZhuBtn)
    {
        [_shangjiaJinZhuBtn removeFromSuperview];
    }
    _shangjiaJinZhuBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/5*4, [UIScreen mainScreen].bounds.size.height - 44 - 20*self.scale - [UIScreen mainScreen].bounds.size.width/5/216*60,  [UIScreen mainScreen].bounds.size.width/5,  [UIScreen mainScreen].bounds.size.width/5/216*60)];
    [_shangjiaJinZhuBtn setImage:[UIImage imageNamed:@"voice_order"] forState:(UIControlStateNormal)];
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;.\
//    [window addSubview:_shangjiaJinZhuBtn];
//    [_shangjiaJinZhuBtn bringSubviewToFront:self.view];
    [_shangjiaJinZhuBtn addTarget:self action:@selector(voiceOrder) forControlEvents:(UIControlEventTouchUpInside)];
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
        } else if ([str isEqualToString:@"2"]) {
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
        }else  if ([str isEqualToString:@"3"]) {
            
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
            info.shop_id=_ADDic[@"shop_id"];
            info.titlete=_ADDic[@"shop_info"][@"shop_name"];
            info.shopImg = _ADDic[@"shop_info"][@"logo"];
            info.gonggao = _ADDic[@"shop_info"][@"notice"];
            info.yunfei =_ADDic[@"shop_info"][@"delivery_fee"];
            info.manduoshaofree=_ADDic[@"shop_info"][@"free_delivery_amount"];
            info.shop_user_id=_ADDic[@"shop_info"][@"user_id"];
            info.type=@"-(void)tiao:(BOOL)issleep";
            [self.navigationController pushViewController:info animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
    }else{
        //商品
        self.hidesBottomBarWhenPushed=YES;
        ShopInfoViewController *buess = [ShopInfoViewController new];
        //NSLog(@"ShopInfoViewController   tiao商品");
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
       // NSLog(@"shop_info==%@",_ADDic[@"shop_info"]);
//        buess.yunfei=
        /**
         *  2016 8 27
         */
        buess.tel=_ADDic[@"prod_info"][@"hotline"];
        /**
         *  2016.8.27
         */
        buess.param=_ADDic;
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
    NSLog(@"communityid====%@",self.commid);
    //零售
    //  [_lingShouData removeAllObjects];
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    [analyze getRetailShopList:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        NSLog(@"getRetailShopList====%@",models);
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
            NSLog(@"_shangmenData=model=%@",models);
            [_shangmenData addObjectsFromArray:models];
//            [_shangmenData addObjectsFromArray:models];
            if (_shangmenData.count>0) {
//                goodsListID = [NSString stringWithFormat:@"%@",_shangmenData[0][@"id"]];
//                NSLog(@"%d",fenleiIndex);
                 goodsListID = [NSString stringWithFormat:@"%@",_shangmenData[fenleiIndex][@"id"]];
                viewNumber = _shangmenData.count;
                for (int i = 0; i<_shangmenData.count; i++){
                    NSMutableArray * fenleiArray  = [NSMutableArray new];
                    [self.fenLeiDictionary setValue:fenleiArray forKey:_shangmenData[i][@"id"]];
                    NSString * index = @"0";
                    [self.indexDictionary setValue:index forKey:_shangmenData[i][@"id"]];
                    NSString * xiaLaH = [NSString stringWithFormat:@"%f",0.0];
                    [self.xialaHDictionary setValue:xiaLaH  forKey:_shangmenData[i][@"id"]];
                }
            }else{
                [self.activityVC stopAnimate];
                [self.activityVC removeFromSuperview];
                [self newShopView];
            }
        }
        if (_shangmenData.count>0){
             [self cool];
        }
        // [self newView];
    }];
    //轮播图片
    [_lunda removeAllObjects];
    [_lunboData removeAllObjects];
    AnalyzeObject *anle1 = [AnalyzeObject new];
    //NSLog(@"轮播图片_+param==%@",self.commid);
    [anle1 mu_zhi_adwithDic:@{@"community_id":self.commid} WithBlock:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            //NSLog(@"轮播图片==%@",models);
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
        if ([code isEqualToString:@"0"]){
            //NSLog(@"社区==%@==%ld",models,[AppUtil isDoBusiness:_gongGaoDic]);
            _gongGaoDic = models;
            NSInteger isOffLine=[[NSString stringWithFormat:@"%@",_gongGaoDic[@"is_off_online"]] integerValue];
            if(isOffLine==1){
                onlinemark=_gongGaoDic[@"onlinemark"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"临时歇业中"
                                                                    message:@"暂停营业。很快回来^_^!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                NSMutableDictionary *dict002 = [NSMutableDictionary dictionaryWithDictionary:_gongGaoDic];
                [dict002 setValue:@"暂停营业。很快回来^_^!"forKey:@"slogan" ];
                _gongGaoDic=[dict002 copy];
            }else if(![AppUtil isDoBusiness:_gongGaoDic]){
                onlinemark=_gongGaoDic[@"onlinemark"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"歇业中"
                                                                    message:[NSString stringWithFormat:@"%@",_gongGaoDic[@"onlinemark"]]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                NSMutableDictionary *dict002 = [NSMutableDictionary dictionaryWithDictionary:_gongGaoDic];
                 [dict002 setValue:[NSString stringWithFormat:@"%@",_gongGaoDic[@"onlinemark"]] forKey:@"slogan" ];
                _gongGaoDic=[dict002 copy];
            }
            [[NSUserDefaults standardUserDefaults]setObject:_gongGaoDic[@"shop_id"] forKey:@"shop_id"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self loadShopDetail];
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
    //    }];
}

-(void)loadShopDetail{
    [self.activityVC startAnimate];
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    NSDictionary *dic=@{@"shop_id":_gongGaoDic[@"shop_id"]};
    if ([Stockpile sharedStockpile].isLogin) {
        dic=@{@"shop_id":_gongGaoDic[@"shop_id"],@"user_id":[self getuserid]};
    }
  //  NSDictionary *dic=@{@"shop_id":_gongGaoDic[@"shop_id"],@"user_id":[self getuserid]};
    NSLog(@"%@",dic);
    [analyze queryShopDetailwithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            _shopData=models;
        }
    }];
}

-(void)stop{
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
            NSLog(@"获取商品信息models==%@",models);
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
        if ([code isEqualToString:@"0"]){
            NSArray* mod=models;
            if(mod==nil||mod.count==0){
                _mainScrollView.footer.state=MJRefreshFooterStateNoMoreData;
            }
            NSMutableArray * Array = [self.fenLeiDictionary objectForKey:goodsListID];
            [Array addObjectsFromArray:models];
            [self.fenLeiDictionary setObject:Array forKey:goodsListID];
            [self.indexDictionary setObject:[NSString stringWithFormat:@"%ld",index] forKey:goodsListID];
        }else if ([code isEqualToString:@"1"]){
            NSArray* mod=models;
            if(mod==nil||mod.count==0){
                _mainScrollView.footer.state=MJRefreshFooterStateNoMoreData;
            }
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"--scrollView_offset=%f--",_mainScrollView.contentOffset.y);
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
    }else if (_mainScrollView.contentOffset.y>0){
        yinCangDeView.alpha = 0;
        talkbtn.alpha = 0;
        self.NavImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:_mainScrollView.contentOffset.y/(self.view.width*336/720-64)];
        self.NavImg.alpha = 1;
    }else if (_mainScrollView.contentOffset.y<0){
        if ([_mainScrollView.header isRefreshing]){
            NSLog(@"正在刷新");
        }else{
            yinCangDeView.alpha = 1;
            talkbtn.alpha = 1;
            self.NavImg.alpha = 0;
            yinCangDeTextField.text = daoHanTextField.text;
            
        }
    }else if (_mainScrollView.contentOffset.y==0){
        self.NavImg.alpha = 1;
        yinCangDeView.alpha = 0;
        talkbtn.alpha = 0;
        self.NavImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
       
        UIView * view = (UIView *)[self.NavImg viewWithTag:12345];
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        UIButton * talkImg = (UIButton *)[self.NavImg viewWithTag:1234];
        [talkImg setImage:[UIImage imageNamed:@"lt"] forState:UIControlStateNormal];
    }
    if (_mainScrollView.contentOffset.y>=self.view.width*336/720 + height - 64-self.view.width/75*8){
        //NSLog(@"111111");
        _hiddleGongGaoView.hidden=NO;
        _hiddenScrollView.hidden = NO;
    }else{
        // NSLog(@"222222");
        _hiddleGongGaoView.hidden=YES;
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

/*scrollview停止滑动的时候执行*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview{
    ii = scrollview.contentOffset.x / scrollview.frame.size.width;
    [_pageControl setCurrentPage:ii];
    if (scrollview.tag == 300){
        _shangPinPageControl.currentPage = _shangPinScrollView.contentOffset.x/_shangPinScrollView.frame.size.width;
    }
    if (scrollview.tag == 200){
        CGFloat offset=self.view.width*336/720+30*self.scale+self.view.width/15*2;
        NSLog(@"scrollViewDidEndDecelerating==%f==%f",offset,_fenLeiScrollView.contentOffset.y);
        if(_mainScrollView.contentOffset.y>offset){
            //[_mainScrollView setContentOffset:CGPointMake(scrollview.contentOffset.x, offset)];
            //[_mainScrollView setContentOffset:CGPointMake(scrollview.contentOffset.x, scrollview.contentOffset.y)];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:2];
            //_mainScrollView.contentOffset = CGPointMake(scrollview.contentOffset.x, offset);
            _fenLeiScrollView.contentOffset = CGPointMake(scrollview.contentOffset.x, 0);
            [UIView commitAnimations];
//            [UIView animateWithDuration:0.25  animations:^{
//                [_mainScrollView setContentOffset:CGPointMake(scrollview.contentOffset.x, offset)];
//            } ];
        }
        NSInteger m = (NSInteger)scrollview.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
        goodsListID = _shangmenData[m][@"id"];
        fenleiIndex = m;
        Tag = fenleiIndex + 1000000000;
        hiddenTag = -(fenleiIndex + 1000000000);
        for (UIButton * fenBtn in self.fenBtnArr){
            fenBtn.selected = NO;
            if (fenBtn.tag == Tag)
            {
                fenBtn.selected = YES;
            }
        }
        for (UIButton * hiddenBtn in self.hiddenArray){
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
        if (_mainScrollView.contentOffset.y>=self.view.width*336/720 + height){
            _xialaH = self.view.width*336/720 + height;
            //         [_mainScrollView setContentOffset:CGPointMake(0, _xialaH)];
        }else{
            _xialaH = _mainScrollView.contentOffset.y;
        }
        NSMutableArray * dataArray =[self.fenLeiDictionary objectForKey:goodsListID];
        if (dataArray.count == 0)
        {
            //            NSLog(@"%ld",[[self.indexDictionary objectForKey:goodsListID] integerValue]);
            [self GoosdListshangla];
            
        }else{
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
    //NSLog(@"xiala==%d",fenleiIndex);
//    [self.mainScrollView.header endRefreshing];
    if([AppUtil isBlank:goodsListID])
        goodsListID = [NSString stringWithFormat:@"%@",_shangmenData[fenleiIndex][@"id"]];
    Tag=1000000000+fenleiIndex;
    hiddenTag = -(1000000000+fenleiIndex);
   // NSLog(@"goodsListID==%@==%@",goodsListID,[NSString stringWithFormat:@"%@",_shangmenData[fenleiIndex][@"id"]]);
    [self.indexDictionary setObject:[NSString stringWithFormat:@"%d",0] forKey:goodsListID];
    [self reshData];
}

-(void)shangla{
    _xialaH=_mainScrollView.contentOffset.y;
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
    _mainScrollView.footer.automaticallyRefresh = YES;

//    tv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        isLoad=true;
//        currentPage++;
//        previousPage=currentPage;
//        [httpDelegate requestHotWithPage:currentPage flag:0];
//    }];

    
    //_mainScrollView.footer.automaticallyRefresh=NO;
    [self.view insertSubview:_mainScrollView belowSubview:self.NavImg];
     //语音下单 [self createShangJiaJinZhuBtn];
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
    souTf.placeholder=@"搜索便利店商品";
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
    //_shangPinScrollView.backgroundColor = [UIColor redColor];
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
   // _shangPinPageControl.backgroundColor=[UIColor blueColor];
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
    fuJinImageView.image = [UIImage imageNamed:@"jingxuan"];
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
    UIView* gongGaoView = [[UIView alloc]initWithFrame:CGRectMake(0, dizhiView.bottom, self.view.width, self.view.width/75*8)];
    //gongGaoView.backgroundColor = [UIColor redColor];
    [shopView addSubview:gongGaoView];
//    //公告lab
    NSString * gongGaoString = _gongGaoDic[@"slogan"];
    CGRect gongGaoMoreRect = [self getStringWithFont:12*self.scale withString:@"更多" withWith:self.view.width];
    CGRect  rect = [self getStringWithFont:12*self.scale withString:gongGaoString withWith:self.view.width];
    UIView * labView = [[UIView alloc]initWithFrame:CGRectMake(10*self.scale +(gongGaoView.height - 14*self.scale)/21*62 + 5*self.scale,7*self.scale,self.view.width - (10*self.scale +(gongGaoView.height - 14*self.scale)/21*62) - 30*self.scale - gongGaoMoreRect.size.width + 20*self.scale, gongGaoView.height- 14*self.scale)];
     //labView.backgroundColor=[UIColor greenColor];
    [gongGaoView addSubview:labView];
    if (rect.size.width > labView.width ){
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, labView.height)];
        lab1.font = SmallFont(self.scale);
        lab1.text =gongGaoString;
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
    }else{
        UILabel * gongGaoLab = [[UILabel alloc]initWithFrame:CGRectMake(0,0,labView.width,labView.height)];
        gongGaoLab.font = SmallFont(self.scale);
        gongGaoLab.text =gongGaoString;
        [labView addSubview:gongGaoLab];
    }
    //公告图片
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (gongGaoView.height - 14*self.scale)/21*62+10*self.scale+5*self.scale, gongGaoView.height)];
    v.backgroundColor = [UIColor whiteColor];

    [gongGaoView addSubview:v];
    UIImageView * gongGaoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 7*self.scale, (gongGaoView.height - 14*self.scale)/21*62, gongGaoView.height- 14*self.scale)];
    gongGaoImageView.image = [UIImage imageNamed:@"sq"];
    [v addSubview:gongGaoImageView];
    
    
//     UIView * gongGaoMoreBg = [[UIView alloc]initWithFrame:CGRectMake(self.view.width - gongGaoMoreRect.size.width - 15*self.scale , gongGaoImageView.top, gongGaoMoreRect.size.width, gongGaoImageView.height)];
    //公告更多按钮
    UIButton * gongGaoMoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width - gongGaoMoreRect.size.width - 15*self.scale , gongGaoImageView.top, gongGaoMoreRect.size.width+30, gongGaoImageView.height)];
    [gongGaoMoreBtn setImage:[UIImage imageNamed:@"classify"] forState:UIControlStateNormal];
    
    gongGaoMoreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 25);
    
//    [gongGaoMoreBtn setTitle:@"分类" forState:(UIControlStateNormal)];
//    gongGaoMoreBtn.titleLabel.font = SmallFont(self.scale);
//    [gongGaoMoreBtn setTitleColor:grayTextColor forState:(UIControlStateNormal)];
   [gongGaoMoreBtn addTarget:self action:@selector(gongGaoMoreBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    //  [gongGaoMoreBtn addTarget:self action:@selector(talk) forControlEvents:(UIControlEventTouchUpInside)];
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
            }else if ([str isEqualToString:@"2"]) {
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
            }else  if ([str isEqualToString:@"3"]) {
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
            info.shop_id=data[tag][@"shop_id"];
            info.titlete=_lunda[tag][@"shop_info"][@"shop_name"];
            info.shopImg = data[tag][@"shop_info"][@"logo"];
            info.gonggao = data[tag][@"shop_info"][@"notice"];
            info.yunfei =data[tag][@"shop_info"][@"delivery_fee"];
            info.manduoshaofree=data[tag][@"shop_info"][@"free_delivery_amount"];
            info.shop_user_id=data[tag][@"shop_info"][@"user_id"];
            info.type=@"-(void)lunbo:(UIButton *)vi";
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
            }else if ([str isEqualToString:@"2"]) {
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
            }else  if ([str isEqualToString:@"3"]) {
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
        //NSLog(@"ShopInfoViewController   lunbo");
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
        buess.param=data[tag];
        [self.navigationController pushViewController:buess animated:YES];
    }
    self.hidesBottomBarWhenPushed=NO;
}

#pragma mark -- 公告更多按钮点击事件
- (void)gongGaoMoreBtnClick{
    NSString* shopID=[NSString stringWithFormat:@"%@",_gongGaoDic[@"shop_id"]];
    if(shopID==nil||[shopID isEqualToString:@""]){
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
    info.ID = shopID;
    info.shop_id=shopID;
    [self.navigationController pushViewController:info animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//语音下单
- (void)voiceOrder
{
//    self.hidesBottomBarWhenPushed = YES;
//    BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
//    
//    info.ID = _gongGaoDic[@"shop_id"];
//    [self.navigationController pushViewController:info animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    if ([Stockpile sharedStockpile].isLogin==NO) {
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                [self login];
            }
        }];
        return;
    }
    if(_shopData==nil)
        return;
    self.hidesBottomBarWhenPushed = YES;
    IMViewController *_conversationVC = [[IMViewController alloc]init];
    _conversationVC.conversationType = ConversationType_PRIVATE;
    _conversationVC.targetId = [NSString stringWithFormat:@"%@",_shopData[@"shop_user_id"]];
    NSLog(@"imtargetid==%@",_shopData[@"shop_user_id"]);
   // _conversationVC.userName = @"123456";
    _conversationVC.title = _shopData[@"shop_name"];
    //NSLog(@"shopUserID==%@",_shopData[@"shop_user_id"]);
    //_conversationVC.conversation = model;
    [self.navigationController pushViewController:_conversationVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)souBtnEvent:(UIButton *)sender{
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark -- 分类按钮点击事件
-(void)changeFenLei:(UIButton *)sender{

    [self srollScrollViewWith:sender.tag - 1000000000];
    for (UIButton *btn in _fenBtnArr)
    {
        btn.selected=NO;
//        NSLog(@"按钮的个数%d",)
    }
    NSLog(@"sender.tag%ld",sender.tag-1000000001);
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
    }else{
        _xialaH = _mainScrollView.contentOffset.y;
    }
    NSMutableArray * dataArray =[self.fenLeiDictionary objectForKey:goodsListID];
    if (dataArray.count == 0){
        [self GoosdListshangla];
    }else{
        UIScrollView * bScrollView = (UIScrollView *)[_fenLeiScrollView viewWithTag:2000+fenleiIndex];
        [self GoodsF:bScrollView withArray:[self.fenLeiDictionary objectForKey:goodsListID]];
//        _xialaH = [[self.xialaHDictionary objectForKey:goodsListID] floatValue];
        [_mainScrollView setContentOffset:CGPointMake(0, _xialaH)];
    }
}

#pragma mark -- 创建滑动的ScrollView
-(void)GoodsF:(UIScrollView *)view withArray:(NSArray *)array{
    view.backgroundColor = [UIColor whiteColor];
    for (UIButton * btn in view.subviews){
        [btn removeFromSuperview];
    }
    float w = (self.view.width-10*self.scale)/3;
    for (int i=0; i<array.count; i++) {
        NSLog(@"=array=%@",array[i]);
        float x = i%3*w+10*self.scale/2;//0;
        float y = 150*self.scale*(int)(i/3);
        UIButton *bgVi = [[UIButton alloc]initWithFrame:CGRectMake(x,y,w,150*self.scale)];
        bgVi.backgroundColor=[UIColor clearColor];
        [view addSubview:bgVi];
        [bgVi addTarget:self action:@selector(goodsEvent:) forControlEvents:UIControlEventTouchUpInside];
        bgVi.tag=1000000000000+i;
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(8*self.scale, 8*self.scale, w-16*self.scale, w-16*self.scale)];
        img.contentMode=UIViewContentModeScaleAspectFill;
        img.clipsToBounds=YES;
        img.layer.cornerRadius=5;
        img.userInteractionEnabled=YES;
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addCart:)];
        [img addGestureRecognizer:tapGesture];
        [tapGesture view].tag=100000+i;
        NSString *cut = array[i][@"img1"];
        NSString *imagename = [cut lastPathComponent];
        NSString *path = [cut stringByDeletingLastPathComponent];
        NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb320."]];
        NSLog(@"%@",smallImgUrl);
          [img setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"center_img"]];
        [bgVi addSubview:img];
        //商品名称
        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(8*self.scale, img.bottom+5*self.scale, bgVi.width-16*self.scale,15*self.scale)];
        la.text=[NSString stringWithFormat:@"%@",array[i][@"prod_name"]];
        la.numberOfLines=2;
        la.textColor=[UIColor blackColor];
        //la.textAlignment = UITextAlignmentCenter;
        la.alpha=.9;
        la.font=SmallFont(self.scale*0.75);
        [bgVi addSubview:la];
        //来自哪里
        UILabel * comeFromlab = [[UILabel alloc]initWithFrame:CGRectMake(8*self.scale, la.bottom, bgVi.width-16*self.scale, 15*self.scale)];
        comeFromlab.textColor = grayTextColor;
        comeFromlab.font = Small10Font(self.scale*0.75);
        NSString* des=[NSString stringWithFormat:@"%@",array[i][@"description"]];
        if([des length]==0||[des isEqualToString:@""]|| des==nil){
            des=[NSString stringWithFormat:@"%@",array[i][@"prod_name"]];
        }
        comeFromlab.text = des;
        [bgVi addSubview:comeFromlab];
        //商品价格
        CGFloat price=[[NSString stringWithFormat:@"%@",array[i][@"price"]] floatValue];
        NSString * preceString = [NSString stringWithFormat:@"￥%.1f/%@",price,array[i][@"unit"]];
        NSString * firstString = [NSString stringWithFormat:@"￥%.1f",price];
        NSString * secondString = [NSString stringWithFormat:@"/%@",array[i][@"unit"]];
        CGRect PriceRect = [self getStringWithFont:12*self.scale withString:preceString withWith:999999];
        UILabel *newPrice = [[UILabel alloc]initWithFrame:CGRectMake(8*self.scale, comeFromlab.bottom,PriceRect.size.width,15*self.scale)];
        newPrice.font = SmallFont(self.scale*0.6);
        newPrice.textColor=[UIColor colorWithRed:1.000 green:0.149 blue:0.149 alpha:1.00];
        UIFont* priFont=SmallFont(self.scale*0.8);
        NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:preceString];
        [attributeString addAttribute:NSFontAttributeName value:priFont range:NSMakeRange(1, firstString.length-1)];
        newPrice.attributedText = attributeString;
        [bgVi addSubview:newPrice];
        //原价
        CGFloat originPrice=[[NSString stringWithFormat:@"%@",array[i][@"origin_price"]] floatValue];

        NSString * oldPriceString = [NSString stringWithFormat:@"￥%.1f",originPrice];
        CGRect oldRect =  [self getStringWithFont:10*self.scale withString:oldPriceString withWith:9999999];
        UILabel *oldPrice = [[UILabel alloc]initWithFrame:CGRectMake(w-oldRect.size.width-10*self.scale, newPrice.bottom-oldRect.size.height-1, oldRect.size.width,oldRect.size.height)];
//        oldPrice.backgroundColor = [UIColor redColor];
        oldPrice.text=oldPriceString;
//        oldPrice.font=[UIFont boldSystemFontOfSize:10*self.scale];
        oldPrice.font = Small10Font(self.scale*0.8);
        oldPrice.textColor=grayTextColor;
        [bgVi addSubview:oldPrice];
     //销售数量
        UILabel * xiaoshouShuLiangLab = [[UILabel alloc]initWithFrame:CGRectMake(w-30*self.scale, comeFromlab.bottom, 30*self.scale, 15*self.scale)];
        xiaoshouShuLiangLab.textColor = [UIColor colorWithRed:0.302 green:0.557 blue:0.996 alpha:1.00];
        xiaoshouShuLiangLab.font = Small10Font(self.scale*0.8);
        NSString * sales = [NSString stringWithFormat:@"%@",array[i][@"sales"]];
        //xiaoshouShuLiangLab.text = [NSString stringWithFormat:@"已售%@",sales];
        xiaoshouShuLiangLab.text = @"详情";
       // [bgVi addSubview:xiaoshouShuLiangLab];
        UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(0, oldPrice.height/2, oldPrice.width, .5)];
        lin.backgroundColor=grayTextColor;
        [oldPrice addSubview:lin];
        NSInteger gid=[goodsListID integerValue];
        UIButton *jiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [jiaBtn setImage:[UIImage imageNamed:@"na2"] forState:UIControlStateNormal];
        jiaBtn.frame=CGRectMake(SCREEN_WIDTH-40, comeFromlab.bottom, 32*self.scale, 32*self.scale);
        [jiaBtn addTarget:self action:@selector(changeShopingCartNum:) forControlEvents:UIControlEventTouchUpInside];
        jiaBtn.tag=100000*gid+i;
        UILabel *num = [[UILabel alloc]initWithFrame:CGRectMake(jiaBtn.frame.origin.x-25*self.scale, comeFromlab.bottom+5*self.scale, 25*self.scale, 22*self.scale)];
        num.font=SmallFont(self.scale);
        num.tag=200000*gid+i;
        NSString* prodID=array[i][@"prod_id"];
        int* index=[self.appdelegate.shopDictionary[@([prodID intValue])] intValue];
        num.text=[NSString stringWithFormat:@"%d",index];
        UIButton *jianBtn = [[UIButton alloc]initWithFrame:CGRectMake(num.frame.origin.x-32*self.scale, comeFromlab.bottom, 32*self.scale, 32*self.scale)];
        [jianBtn setImage:[UIImage imageNamed:@"na1"] forState:UIControlStateNormal];
        [jianBtn addTarget:self action:@selector(changeShopingCartNum:) forControlEvents:UIControlEventTouchUpInside];
        jianBtn.tag=300000*gid+i;
        //[bgVi addSubview:jianBtn];
        if (index==0) {
            jianBtn.hidden=YES;
            num.hidden=YES;
        }else{
            jianBtn.hidden=NO;
            num.hidden=NO;
        }
        num.textColor=grayTextColor;
        num.textAlignment=NSTextAlignmentCenter;
        if(index>0){
           // [self addShopingCartView:img];
            UIView* coverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,img.frame.size.width,img.frame.size.height)];
            coverView.backgroundColor=[UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.4];
            coverView.clipsToBounds=YES;
            coverView.layer.cornerRadius=5;
            [img addSubview:coverView];
            UILabel *addCart = [[UILabel alloc] initWithFrame:CGRectMake(0, coverView.frame.size.height/2-10*self.scale, img.frame.size.width, 15*self.scale)];
            addCart.textAlignment=NSTextAlignmentCenter;
            addCart.textColor = [UIColor whiteColor];
            addCart.font=SmallFont(self.scale*0.8);
            // 1.创建一个富文本
            NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:@"已加入购物车"];
            // 2.添加表情图片
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"shopping_cart.png"];
            // 设置图片大小
            attch.bounds = CGRectMake(0, -self.scale*4, 15*self.scale, 15*self.scale);
            // 创建带有图片的富文本
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:0];// 插入某个位置
            // 用label的attributedText属性来使用富文本
            addCart.attributedText = attri;
            [coverView addSubview:addCart];
            UILabel* cancel=[[UILabel alloc] initWithFrame:CGRectMake(0,img.frame.size.height-25*self.scale,img.frame.size.width,10*self.scale)];
            cancel.textAlignment=NSTextAlignmentCenter;
            cancel.textColor = [UIColor colorWithRed:0.844 green:0.792 blue:0.791 alpha:1.00];
            cancel.font=SmallFont(self.scale*0.7);
            cancel.text=@"点击取消";
            [img addSubview:cancel];

        }
        float yuan = [[NSString stringWithFormat:@"%@",array[i][@"origin_price"]] floatValue];
        float xian = [[NSString stringWithFormat:@"%@",array[i][@"price"]] floatValue];
        if (xian>=yuan) {
            oldPrice.hidden=YES;
            lin.hidden=YES;
        }
        view.size = CGSizeMake([UIScreen mainScreen].bounds.size.width,bgVi.bottom);
        _fenLeiScrollView.size = CGSizeMake([UIScreen mainScreen].bounds.size.width,view.bottom );
        _fenLeiScrollView.scrollEnabled = YES;
        _mainScrollView.contentSize=CGSizeMake(0, _fenLeiScrollView.bottom);
       // NSLog(@"高度1111==%f",bgVi.bottom);

    }
    if(view.size.height<(self.view.height-self.view.width/75*8-64-self.tabBarController.tabBar.height)){
        //view.size = CGSizeMake([UIScreen mainScreen].bounds.size.width,1500);
        _fenLeiScrollView.size = CGSizeMake([UIScreen mainScreen].bounds.size.width,(self.view.height-self.view.width/75*8-64-self.tabBarController.tabBar.height));
        _fenLeiScrollView.scrollEnabled = YES;
        _mainScrollView.contentSize=CGSizeMake(0, _fenLeiScrollView.bottom);
    }
    //NSLog(@"高度==%f",view.size.height);
}

-(void) addShopingCartView:(UIImageView*) img{
    NSLog(@"添加到购物车");
    UIView* coverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,img.frame.size.width,img.frame.size.height)];
    coverView.backgroundColor=[UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.4];
    coverView.clipsToBounds=YES;
    coverView.layer.cornerRadius=5;
    [img addSubview:coverView];
    UILabel *addCart = [[UILabel alloc] initWithFrame:CGRectMake(0, coverView.frame.size.height/2-10*self.scale, img.frame.size.width, 15*self.scale)];
    addCart.textAlignment=NSTextAlignmentCenter;
    addCart.textColor = [UIColor whiteColor];
    addCart.font=SmallFont(self.scale*0.8);
    // 1.创建一个富文本
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:@"已加入购物车"];
    // 2.添加表情图片
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"shopping_cart.png"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -self.scale*4, 15*self.scale, 15*self.scale);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];// 插入某个位置
    // 用label的attributedText属性来使用富文本
    addCart.attributedText = attri;
    [coverView addSubview:addCart];
    UILabel* cancel=[[UILabel alloc] initWithFrame:CGRectMake(0,img.frame.size.height-25*self.scale,img.frame.size.width,10*self.scale)];
    cancel.textAlignment=NSTextAlignmentCenter;
    cancel.textColor = [UIColor colorWithRed:0.844 green:0.792 blue:0.791 alpha:1.00];
    cancel.font=SmallFont(self.scale*0.7);
    cancel.text=@"点击取消";
    [img addSubview:cancel];
}

-(void)addCart:(UITapGestureRecognizer*) tap{
//    if ([Stockpile sharedStockpile].isLogin==NO) {
//        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
//            if (index==1) {
//                LoginViewController *login = [self login];
//                [login resggong:^(NSString *str) {//登录成功后需要加载的数据
//                    NSLog(@"登录成功");
//                    [self requestShopingCart:true];
//                }];
//            }
//        }];
//        return;
//    }
    NSInteger gid=[goodsListID integerValue];
    NSMutableArray * dataArray = [self.fenLeiDictionary objectForKey:goodsListID];
    NSDictionary *shopInfo = dataArray[[tap view].tag-100000];
    NSString* prodID=shopInfo[@"prod_id"];
    NSString* shopID=shopInfo[@"shop_id"];
    NSInteger isOffLine=[[NSString stringWithFormat:@"%@",shopInfo[@"is_off_online"]] integerValue];
    if(isOffLine==1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"临时歇业中"
                                                            message:@"暂停营业。很快回来^_^!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }else if(![AppUtil isDoBusiness:_gongGaoDic]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"歇业中"
                                                            message:[NSString stringWithFormat:@"%@",onlinemark]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if(isLock){
        return;
    }else{
        isLock=true;
        [self performSelector:@selector(setLock) withObject:nil afterDelay:0.3f];
    }
   // NSLog(@"img_tag==%d",[tap view].tag);
   
    int index=[self.appdelegate.shopDictionary[@([prodID intValue])] intValue];
   // NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dicc = nil;
    //NSLog(@"proname==%@,pid==%@,index==%d,cart==%@",shopInfo[@"prod_name"],prodID,index,self.appdelegate.shopDictionary);
    if(index>0){
        dicc= @{@"prod_id":prodID,@"prod_count":[NSNumber numberWithInt:0],@"shop_id":shopID};
    }else{
        dicc= @{@"prod_id":prodID,@"prod_count":[NSNumber numberWithInt:1],@"shop_id":shopID};
    }
    NSMutableDictionary* param=[shopInfo mutableCopy];
    //[param setObject:@"" forKey:@"shop_logo"];
    NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
    int cartNum=[value intValue];
    if(index>0){
        [[DataBase sharedDataBase] updateCart:param withType:-1];
        for(UIView* v in [tap view].subviews)
            [v removeFromSuperview];
        [self.appdelegate.shopDictionary setObject:[NSString stringWithFormat:@"%d",0] forKey:@([prodID intValue])];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",(cartNum-index)] forKey:@"GouWuCheShuLiang"];
    }else{
        [[DataBase sharedDataBase] updateCart:param withType:1];
        [self addShopingCartView:[tap view]];
        [self.appdelegate.shopDictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@([prodID intValue])];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cartNum+1] forKey:@"GouWuCheShuLiang"];
    }
    [self gouWuCheShuZi];

    //[param setObject:shopInfo[@"img1"] forKey:@"prod_img"];
   // [[DataBase sharedDataBase] clearCart];
   // [[DataBase sharedDataBase] updateCart:param withType:1];
    //NSArray* array= [[DataBase sharedDataBase] getAllFromCart];
    //NSLog(@"array====%@",array);
//    [param setObject:shopID forKey:@"user_id"];
//    [param setObject:@"" forKey:@"shop_logo"];
//    [param setObject:@"" forKey:@"free_delivery_amount"];

    
    
//    AnalyzeObject *anle = [AnalyzeObject new];
//    [anle addProdWithDic:dicc Block:^(id models, NSString *code, NSString *msg) {
//        NSLog(@"addcart=%@",models);
//        //[self ReshBotView];
//        //[self shangJiaXiangQing];
//        [self.activityVC stopAnimate];
//        if ([code isEqualToString:@"0"]) {
//            NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
//            int cartNum=[value intValue];
//            if(index==0){
//                [self addShopingCartView:[tap view]];
//                [self.appdelegate.shopDictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:prodID];
//                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cartNum+1] forKey:@"GouWuCheShuLiang"];
//            }else{
//                for(UIView* v in [tap view].subviews)
//                    [v removeFromSuperview];
//                [self.appdelegate.shopDictionary setObject:[NSString stringWithFormat:@"%d",0] forKey:prodID];
//                 [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",(cartNum-index)] forKey:@"GouWuCheShuLiang"];
//            }
//
//            [self gouWuCheShuZi];
//        }else{
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:@"提示" // 指定标题
//                                  message:msg  // 指定消息
//                                  delegate:nil
//                                  cancelButtonTitle:@"确定" // 为底部的取消按钮设置标题
//                                  // 不设置其他按钮
//                                  otherButtonTitles:nil];
//            [alert show];
//        }
//    }];
}

#pragma mark -- 创建隐藏的scrollView
- (void)createHiddenVeiw
{
    if(_hiddleGongGaoView){
        [_hiddleGongGaoView removeFromSuperview];
        for (UIView * view in _hiddleGongGaoView.allSubviews)
        {
            [view removeFromSuperview];
        }
        _hiddleGongGaoView = nil;
    }
    //公告View
    
    _hiddleGongGaoView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.width/75*8)];
    _hiddleGongGaoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_hiddleGongGaoView];
    
    //    //公告lab
    NSString * gongGaoString = _gongGaoDic[@"slogan"];
    CGRect gongGaoMoreRect = [self getStringWithFont:12*self.scale withString:@"更多" withWith:self.view.width];
    CGRect  rect = [self getStringWithFont:12*self.scale withString:gongGaoString withWith:self.view.width];
    UIView * labView = [[UIView alloc]initWithFrame:CGRectMake(10*self.scale +(_hiddleGongGaoView.height - 14*self.scale)/21*62 + 5*self.scale,7*self.scale,self.view.width - (10*self.scale +(_hiddleGongGaoView.height - 14*self.scale)/21*62) - 30*self.scale - gongGaoMoreRect.size.width + 20*self.scale, _hiddleGongGaoView.height- 14*self.scale)];
    [_hiddleGongGaoView addSubview:labView];
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
    }else{
        UILabel * gongGaoLab = [[UILabel alloc]initWithFrame:CGRectMake(0,0,labView.width,labView.height)];
        gongGaoLab.font = SmallFont(self.scale);
        gongGaoLab.text = gongGaoString;
        [labView addSubview:gongGaoLab];
    }
    //公告图片
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (_hiddleGongGaoView.height - 14*self.scale)/21*62+10*self.scale+5*self.scale, _hiddleGongGaoView.height)];
    v.backgroundColor = [UIColor whiteColor];
    [_hiddleGongGaoView addSubview:v];
    UIImageView * gongGaoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 7*self.scale, (_hiddleGongGaoView.height - 14*self.scale)/21*62, _hiddleGongGaoView.height- 14*self.scale)];
    gongGaoImageView.image = [UIImage imageNamed:@"sq"];
    [v addSubview:gongGaoImageView];
    //公告更多按钮
    UIButton * gongGaoMoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width - gongGaoMoreRect.size.width - 15*self.scale , gongGaoImageView.top, gongGaoMoreRect.size.width+30, gongGaoImageView.height)];
//    [gongGaoMoreBtn setTitle:@"分类" forState:(UIControlStateNormal)];
//    gongGaoMoreBtn.titleLabel.font = SmallFont(self.scale);
//    [gongGaoMoreBtn setTitleColor:grayTextColor forState:(UIControlStateNormal)];
    [gongGaoMoreBtn setImage:[UIImage imageNamed:@"classify"] forState:UIControlStateNormal];
    gongGaoMoreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 25);
    [gongGaoMoreBtn addTarget:self action:@selector(gongGaoMoreBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_hiddleGongGaoView addSubview:gongGaoMoreBtn];
    gongGaoMoreBtn.backgroundColor = [UIColor whiteColor];
    _hiddleGongGaoView.hidden = YES;

    
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
     _hiddenScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64+self.view.width/75*8, [UIScreen mainScreen].bounds.size.width, 30*self.scale)];
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

- (void)hiddenChangeFenLei:(UIButton *)sender{
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
    if (_mainScrollView.contentOffset.y>=self.view.width*336/720 + height + 60*self.scale){
        _xialaH = self.view.width*336/720 + height+60*self.scale;
        //         [_mainScrollView setContentOffset:CGPointMake(0, _xialaH)];
    }else{
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
    else{
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
    //NSLog(@"ShopInfoViewController   goodsEvent");
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
    buess.param=shopInfo;
    NSLog(@"shop_info==%@",shopInfo);


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
//    if (![Stockpile sharedStockpile].isLogin) {
//        //[self ShowAlertWithMessage:@"请先登录"];
//        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
//            if (index==1) {
//                LoginViewController *login = [self login];
//                [login resggong:^(NSString *str) {//登录成功后需要加载的数据
//                    NSLog(@"登录成功");
//                    [self requestShopingCart:true];
//                }];
//            }
//        }];
//        return;
//    }
    //self.hidesBottomBarWhenPushed = YES;
    ChoosePlotController* choosePlot=[[ChoosePlotController alloc] init];
    choosePlot.isRoot=false;
    [self.navigationController pushViewController:choosePlot animated:YES];
   // self.hidesBottomBarWhenPushed = NO;
//    self.hidesBottomBarWhenPushed = YES;
//    SheQuManagerViewController * shequMVC = [[SheQuManagerViewController alloc]init];
//    shequMVC.nojiantou = YES;
//    [self.navigationController pushViewController:shequMVC animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
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
        }else if ([str isEqualToString:@"2"]) {
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
        }else  if ([str isEqualToString:@"3"]) {
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
        info.shop_id=ID;
        info.titlete=[shopInfo objectForKey:@"shop_name"];
        info.shopImg = [shopInfo objectForKey:@"logo"];
        info.gonggao = [shopInfo objectForKey:@"notice"];
        info.yunfei =[shopInfo objectForKey:@"delivery_fee"];
        info.manduoshaofree=[shopInfo objectForKey:@"free_delivery_amount"];
        info.shop_user_id=[shopInfo objectForKey:@"shop_user_id"];
        info.issleep=issleep;
        info.type=@"-(void)skipToDetail:(NSDictionary *)shopInfo";

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
    //if ([Stockpile sharedStockpile].isLogin)
    //{
        NSNumber* num=[[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
        NSString * value = [NSString stringWithFormat:@"%@",num];
       // NSLog(@"%@",value);
        if (num==nil||[value isEqualToString:@"0"])
        {
            [item setBadgeValue:nil];
        }else{
            [item setBadgeValue:value];
        }
//    }else{
//        [item setBadgeValue:nil];
//    }
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
    souTf.placeholder=@"搜索便利店商品";
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
- (void)loadNotificationCell{
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
        [self ShowAlertWithMessage:@"搜索便利店商品"];
        [self.view endEditing:YES];
        return [textField resignFirstResponder];
    }
    self.hidesBottomBarWhenPushed=YES;
    SouViewController *vi=[SouViewController new];
    //vi.shop_id= shopInfo[@"shop_id"];
    //NSLog(@"shop_id:--%@",shopInfo[@"shop_id"]);

    vi.keyword=souTf.text.trimString;
    [self.navigationController pushViewController:vi animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    [self.view endEditing:YES];
    return [textField resignFirstResponder];
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
    //[self.view addSubview:self.activityVC];
   // [self.activityVC startAnimate];
    NSInteger gid=[goodsListID integerValue];
    NSInteger num=0;//购物车商品数量
    NSInteger index=-1;//商品项，为了获取商品id
    NSInteger tag=btn.tag/gid;
    UILabel* numLb=nil;
    //UIScrollView * bScrollView = (UIScrollView *)[_fenLeiScrollView viewWithTag:2000+fenleiIndex];
    if (tag<200000) {
        index=btn.tag-100000*gid;//tag-100000;
        numLb=(UILabel *)[self.view viewWithTag:200000*gid+index];
        num=[numLb.text intValue];
        num++;
    }else{
        index=btn.tag-300000*gid;
        numLb=(UILabel *)[self.view viewWithTag:200000*gid+index];
        num=[numLb.text intValue];
        num--;
    }
    if (num<0) {
        num=0;
    }
    NSLog(@"index==%d   gid==%d   tag==%d",index,gid,tag);
    NSMutableArray * dataArray = [self.fenLeiDictionary objectForKey:goodsListID];
    NSDictionary *shopInfo = dataArray[index];
    NSString* prodID=shopInfo[@"prod_id"];
    NSString* shopID=shopInfo[@"shop_id"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dicc = @{@"user_id":userid,@"prod_id":prodID,@"prod_count":[NSNumber numberWithInt:num],@"shop_id":shopID};
        AnalyzeObject *anle = [AnalyzeObject new];
        [anle addProdWithDic:dicc Block:^(id models, NSString *code, NSString *msg) {
            NSLog(@"addcart=%@",models);
            //[self ReshBotView];
            //[self shangJiaXiangQing];
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
                numLb.text=[NSString stringWithFormat:@"%d",num];
                UIButton* subBtn=(UIButton *)[self.view viewWithTag:300000*gid+index];
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
                if(tag<200000){
                    cartNum++;
                }else{
                    cartNum--;
                    if(cartNum<0)cartNum=0;
                }
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cartNum] forKey:@"GouWuCheShuLiang"];
                [self gouWuCheShuZi];
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

@end
