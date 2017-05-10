//
//  ShopInfoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShopInfoViewController.h"
#import "OrderConfirmViewController.h"
#import "BusinessInfoViewController.h"
#import "GouWuCheViewController.h"
#import "IntroControll.h"
#import "IntroModel.h"
#import "UmengCollection.h"
#import "BreakInfoViewController.h"
#import "ScrollViewController.h"
#import "SouViewController.h"

@interface ShopInfoViewController ()
@property(nonatomic,strong)IntroControll *IntroV;
@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)UILabel *name,*infoName,*info;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UIScrollView *scrollView,*imgScroll;
@property(nonatomic,strong)NSMutableArray *data,*GoodsList,*arr;
@property(nonatomic,strong)UIView *bigvi;
@property(nonatomic,strong)UILabel *priceLa, *shopCarLa;
@property(nonatomic,strong)reshChoucang block;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,assign)int i;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)BOOL popTwo;
@property(nonatomic,strong)NSString * carNum;
@property(nonatomic,assign)float zongPrice;
@property(nonatomic,strong)NSString * carPrice;
@property(nonatomic,strong)NSMutableDictionary *carData;
@property(nonatomic,strong)ScrollViewController * scrollVC;

@property(nonatomic,strong)UIButton * shouCangbtn;

@property(nonatomic,strong)NSDictionary * remindDic;

@property(nonatomic,strong)UILabel * peiSongLab;

@property(nonatomic,strong)UIButton * numberImg;


@property(nonatomic,assign)BOOL istop;
@end

@implementation ShopInfoViewController

-(void)reshChoucang:(reshChoucang)block{
    _block=block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isPush)
    {
        
        NSDictionary *dic = @{@"shop_id":self.shop_id,@"prod_id":self.prod_id};
        if ([Stockpile sharedStockpile].isLogin) {
            dic = @{@"shop_id":self.shop_id,@"prod_id":self.prod_id,@"user_id":
                        [self getuserid]};
        }
        AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
        [analyze getprodDetailPushwithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
            
            if ([code isEqualToString:@"0"]) {
                self.indexs=0;
                self.yes=NO;
                if ([[NSString stringWithFormat:@"%@",models[0][@"shop_info"][@"is_open_chat"]] isEqualToString:@"2"]) {
                    self.isopen=NO;
                }else{
                    self.isopen=YES;
                }
                self.price =models[0][@"price"];
                //                self.numb = 0;
                self.shop_name=models[0][@"shop_info"][@"shop_name"];
                self.shop_user_id=models[0][@"shop_info"][@"shop_user_id"];
                //                self.indexNumber = 0;
                self.shop_id = [models[0] objectForKey:@"shop_id"];
                self.prod_id = [models[0] objectForKey:@"id"];
                self.xiaoliang= models[0][@"sales"];
                self.shoucang= models[0][@"collect_time"];
                self.tel = models[0][@"shop_info"][@"contact_mobile"];
            }
            
            
        }];
        
    }
    

    
    
    
    
//    _data = [NSMutableArray new];
    _carNum = @"0";
    if (!_numb) {
        _numb=0;
    }
//    _yes=NO;
    _popTwo=NO;
    _i=0;
    _index=_indexs;
    
    
    
    
    
    
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shibaijian) name:@"addshibai" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actrectstop) name:@"addact" object:nil];

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self ReshData];
//    [self shangJiaXiangQing];
    [self returnVi];

}

//-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden=YES;
////    if (_islunbo) {
//        [self ReshBotView];
//    
////    }else{
////        [self bottomVi];
////    }
//
//}
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
#pragma mark - 数据块
-(void)ReshData
{
    
    [self.view addSubview:self.activityVC];

    [self.activityVC startAnimate];
    
    
    NSDictionary *dic = @{@"shop_id":self.shop_id,@"prod_id":self.prod_id};
    
    
    if ([Stockpile sharedStockpile].isLogin) {
        dic = @{@"shop_id":self.shop_id,@"prod_id":self.prod_id,@"user_id":
                    [self getuserid]};
    }
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    [analyze getprodDetailwithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [self ReshBotView];
        [self shangJiaXiangQing];
        if ([code isEqualToString:@"0"]) {
            //            [_data addObjectsFromArray:models];
            _data=models;
            NSString *str= [_data [0]objectForKey:@"description"];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            _soapResults = [[NSMutableString alloc] init];
            NSXMLParser *xml = [[NSXMLParser alloc]initWithData:data];
            if ([_data[0][@"is_collect"] isEqualToString:@"2"])
            {
                _shouCangbtn.selected = YES;
            }

            xml.delegate=self;
            [xml setShouldResolveExternalEntities:YES];
            [xml parse];
            [self TopImg];
            [self bottomVi];
            [self centerCont];
            
            if (_orshoucang) {
                if (_issleep) {
                    [self ShowAlertWithMessage:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"];
                }
            }
            
        }
        
        
    }];

    
}

#pragma mark -- 商家详情接口
-(void)shangJiaXiangQing
{
    //    [self.activityVC startAnimate];
    
    NSDictionary *dic=[NSDictionary new];
//    if (_isPush) {
        dic = @{@"shop_id":self.shop_id};
//    }else{
////        dic = @{@"shop_id":self.ID};
//    }
    if ([Stockpile sharedStockpile].isLogin) {
//        if (_isPush) {
            dic=@{@"user_id":[self getuserid],@"shop_id":self.shop_id};
//        }else{
//            dic = @{@"user_id":[self getuserid],@"shop_id":self.ID};
//        }
        
    }
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    
    [analyze ShopshopInfoWithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        
        if ([code isEqualToString:@"0"]) {
            //            _data=models;
            _remindDic = models;
            NSLog(@"%@",models);
            
            //            [self BigScrollView];
            
//            [self remind];
            _shopCarLa.attributedText = [self jiSuanBenDianXiaoFei];
            _peiSongLab.text = [self xianShiPeiSongFei];
            //            [self bottomVi];
        }
        //        [self.activityVC stopAnimate];
        
        
    }];
    
    
}
-(void)ReshBotView{
    
    
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    
    AnalyzeObject *analyze = [AnalyzeObject new];
    
    NSDictionary *dic = @{@"shop_id":self.shop_id};
    
    if ([Stockpile sharedStockpile].isLogin) {
        dic = @{@"user_id":[self getuserid],@"shop_id":self.shop_id};
    }

    [analyze getShopingCartDataWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            _carPrice = models[@"total_amount"] ;
            _carNum= models[@"total_num"] ;
            _carData=models;
            _zongPrice = [_carPrice floatValue];
            _numb = [_carNum intValue];
            
//            [self bottomVi];///////------------
//            UIButton *btn = (UIButton *)[self.view viewWithTag:666];
//            UIButton *xuan = (UIButton *)[self.view viewWithTag:907];

//            [btn setTitle:[NSString stringWithFormat:@"%d",_numb] forState:0];
//            _shopCarLa.text = [NSString stringWithFormat:@"共%.2f元",_zongPrice];

            [_numberImg setTitle:[NSString stringWithFormat:@"%d",_numb] forState:(UIControlStateNormal)];
            [[NSUserDefaults standardUserDefaults] setObject:_numberImg.titleLabel.text forKey:@"GouWuCheShuLiang"];
            
            for (NSDictionary *dic in models[@"cart_info"]) {
                
                if ([dic[@"prod_id"] isEqualToString:self.prod_id]) {
                    _index = [dic[@"prod_count"] integerValue];
                }
            }
            if ([models[@"cart_info"] count]<=0) {
                _index=0;
            }

            
//            if (_numb<=0) {
//                _botRTwo.hidden=YES;
//            }else{
//                _botRTwo.hidden=NO;
//                
//                if (_index<=0) {
////                    xuan.hidden=YES;
//                    xuan.backgroundColor=grayTextColor;
//                    xuan.userInteractionEnabled=NO;
//                }else{
////                    xuan.hidden=NO;
//                    xuan.backgroundColor=[UIColor redColor];
//                    xuan.userInteractionEnabled=YES;
//                }
//            }
            

            
//            [self bottomVi];

            
            
            
            [self centerCont];
            
//            if ([Stockpile sharedStockpile].isLogin) {
//                
//                UIButton *btn = (UIButton *)[_bottomL viewWithTag:909];
//                UILabel *btn1 = (UILabel *)[_bottomL viewWithTag:908];
//                
//                NSDictionary *d = @{@"user_id":[self getuserid],@"collect_id":self.prod_id,@"collect_type":@"1"};                    [self bottomVi];
//
//                [analyze isCollectWithDic:d Block:^(id models, NSString *code, NSString *msg) {
//                    if ([[NSString stringWithFormat:@"%@",models] isEqualToString:@"2"]) {
////                        btn.selected=YES;
////                        btn1.text=@"取消收藏";
////                        btn1.textColor=blueTextColor;
//                        
//                    }
//                    
//                }];
            
//            }
            
        }else{
            _index=0;
            [self centerCont];
        }
        
    }];
}
#pragma mark-------顶部商品图片

-(void)TopImg{
    if (_scrollView) {
        [_scrollView removeFromSuperview];
    }
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64-49*self.scale)];
    _scrollView.backgroundColor=superBackgroundColor;
    [self.view addSubview:_scrollView];
    
    _imgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*3/4)];
    _imgScroll.backgroundColor=[UIColor whiteColor];
    _imgScroll.pagingEnabled=YES;
    [_scrollView addSubview:_imgScroll];
    
    _arr = [NSMutableArray new];
    for (int i=1; i<10; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i];
        str = _data[0][str];
        
        NSLog(@"%@",_data);
        NSLog(@"%@",str);
        if (![str isEqualToString:@""]) {
            
//            NSString *url=@"";
            NSString *cut = str;
            NSString *imagename = [cut lastPathComponent];
            NSString *path = [cut stringByDeletingLastPathComponent];
             NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb640."]];
            NSLog(@"%@",smallImgUrl);
            [_arr addObject:smallImgUrl];
       
//            if (cut.length>0) {
//                if ([cut containsString:@".jpeg"])
//                {
//                    url = [cut substringToIndex:[cut length] - 5];
//                     [_arr addObject:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@_thumb640.jpeg",url]]];
//                }
//                else if ([cut containsString:@".jpg"])
//                {
//                     url = [cut substringToIndex:[cut length] - 4];
//                     [_arr addObject:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@_thumb640.jpg",url]]];
//                }
//                else
//                {
//                    
//                }
//               
//                
//            }
//            else
//            {
//                 [_arr addObject:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@_thumb640.jpg",url]]];
//            }
            
           
//            NSLog(@"%@",[NSString stringWithFormat:@"%@_thumb640.jpg",url]);

        }
        
    }
    _imgScroll.contentSize=CGSizeMake(_imgScroll.width*1, _imgScroll.height);
    if (_arr.count==0) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _imgScroll.width, _imgScroll.height)];
        [img setImage:[UIImage imageNamed:@"za"]];
        [_imgScroll addSubview:img];
    }else{
        for (int i=0; i<1; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i*_imgScroll.width, 0, _imgScroll.width, _imgScroll.height)];
            [img setImageWithURL:[NSURL URLWithString:_arr[i]] placeholderImage:[UIImage imageNamed:@"za"]];
            img.userInteractionEnabled=YES;
            [_imgScroll addSubview:img];
            img.tag=1000+i;
            
            img.contentMode=UIViewContentModeScaleAspectFill;
            img.clipsToBounds=YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgbig:)];
            [img addGestureRecognizer:tap];
        }

    }
    //************
   
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, _imgScroll.height-45*self.scale, _imgScroll.width, 20*self.scale)];
    _pageControl.currentPageIndicatorTintColor=blueTextColor;
    _pageControl.pageIndicatorTintColor=[UIColor whiteColor];
    _pageControl.numberOfPages=_arr.count;
    //************
    _pageControl.hidden=YES;
    [_scrollView addSubview:_pageControl];

    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
//    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(lunbo) userInfo:nil repeats:YES];
    

//    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, _imgScroll.bottom-25*self.scale, _imgScroll.width, 25*self.scale)];
//    vi.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
//    [_scrollView addSubview:vi];
//    
//    
//
//    
//    UIImageView *xiaoImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 12*self.scale, 15*self.scale)];
//    xiaoImg.image = [UIImage imageNamed:@"dian_xq_ico_01"];
//    [vi addSubview:xiaoImg];
//    
//    UILabel *xiao = [[UILabel alloc]initWithFrame:CGRectMake(xiaoImg.right, xiaoImg.top, 10*self.scale, vi.height)];
//    if ([self.xiaoliang isEqualToString:@""] || [self.xiaoliang isKindOfClass:[NSNull class]]) {
//        self.xiaoliang=@"0";
//    }
//    xiao.text=[NSString stringWithFormat:@" 销量%@",self.xiaoliang];
//    xiao.font=SmallFont(self.scale);
//    xiao.textColor=[UIColor whiteColor];
//    [xiao sizeToFit];
//    [vi addSubview:xiao];
//    
//    
//    UIImageView *shouImg = [[UIImageView alloc]initWithFrame:CGRectMake(xiao.right+10*self.scale, 5*self.scale, 15*self.scale, 15*self.scale)];
//    shouImg.image = [UIImage imageNamed:@"dian_xq_ico_02"];
//    [vi addSubview:shouImg];
//    
//    UILabel *shou = [[UILabel alloc]initWithFrame:CGRectMake(shouImg.right, shouImg.top, 10*self.scale, vi.height)];
//    shou.font=SmallFont(self.scale);
//    shou.textColor=[UIColor whiteColor];
//    if ([self.shoucang isEqualToString:@""] || [self.shoucang isKindOfClass:[NSNull class]]) {
//         self.shoucang=@"0";
//    }
//    
//    shou.text=[NSString stringWithFormat:@" 收藏:%@",self.shoucang];
//    [shou sizeToFit];
//    [vi addSubview:shou];
    

    [self centerCont];
    
}

-(void)imgbig:(UIGestureRecognizer *)view{


    _scrollVC = [[ScrollViewController alloc] init];
    _scrollVC.imgArr = _arr;
    _scrollVC.index = 0;
    [_scrollVC newScrollV];
    
    [_scrollVC getScrollVBlock:^(NSString *str) {
        
        [UIView animateWithDuration:.3 animations:^{
            
            _scrollVC.view.alpha = 0;
            
        }completion:^(BOOL finished) {
            
            [_scrollVC.view removeFromSuperview];
            _scrollVC= nil;
        }];
        
    }];
    
    [self.view addSubview:_scrollVC.view];
    
//    NSLog(@"%@",_arr);
//    NSMutableArray *arr = [NSMutableArray new];
//    for (int i=1; i<10; i++) {
//        NSString *str = [NSString stringWithFormat:@"img%d",i];
//        str = _data[0][str];
//        if (![str isEqualToString:@""]) {
//            
//            [arr addObject:str];
//        }
//        
//    }
//    
//    NSMutableArray *pagesArr = [[NSMutableArray alloc] init];
//    if (_arr.count==0) {
//        return;
//    }else{
//        if (view.view.tag>1000) {
//            for (int i = 1; i <arr.count; i ++) {
//                
//                IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:[NSString stringWithFormat:@"%@",arr[i]]];
//                [pagesArr addObject:model1];
//            }
// 
//        }else{
//            IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:[NSString stringWithFormat:@"%@",arr[0]]];
//            [pagesArr addObject:model1];
//        }
//        
//    }
//    
//    
//    _IntroV = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:pagesArr];
//    if (view.view.tag==1000) {
//      [_IntroV index:view.view.tag-1000];
//    }else{
//        [_IntroV index:view.view.tag-10000];
//    }
    
    self.tabBarController.tabBar.hidden=YES;
//    [[[UIApplication sharedApplication].delegate window] addSubview:_IntroV];


}


-(void)lunbo{
    
    static int i=1;
    if (i<_arr.count)
    {
        [_imgScroll setContentOffset:CGPointMake((i)*_imgScroll.width, 0) animated:YES];
        _pageControl.currentPage = i;
        i++;
    }else
    {
        i=0;
        [_imgScroll setContentOffset:CGPointMake((i)*_imgScroll.width, 0) animated:NO];
        _pageControl.currentPage = i;
        i++;
    }

    
    
}
#pragma mark-------中间的内容设置

-(void)centerCont{
    
    
    if (_bigvi) {
        [_bigvi removeFromSuperview];
    }
    
    _bigvi = [[UIView alloc]initWithFrame:CGRectMake(0, _imgScroll.bottom, self.view.width, 70*self.scale)];
    _bigvi.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:_bigvi];
    
    UIView *jiageD = [[UIView alloc]initWithFrame:CGRectMake(0*self.scale, 0*self.scale, self.view.width, 60*self.scale)];
    [_bigvi addSubview:jiageD];

    
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale,10*self.scale, self.view.width-20*self.scale, 20*self.scale)];
    self.name.text = [_data[0] objectForKey:@"prod_name"];
    self.name.font = DefaultFont(self.scale);
    [jiageD addSubview:_name];
//    jiageD.backgroundColor = [UIColor greenColor];
//    self.name.numberOfLines=0;
//    [self.name sizeToFit];
//    self.name.backgroundColor=[UIColor redColor];
//    jiageD.height=_name.bottom;
    
    
    UIView *vi1 = [[UIView alloc]initWithFrame:CGRectMake(0,self.name.bottom+ 5*self.scale, [UIScreen mainScreen].bounds.size.width, 25*self.scale)];
//    vi1.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    [jiageD addSubview:vi1];
    
    
    
    
//    UIImageView *xiaoImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 12*self.scale, 15*self.scale)];
//    xiaoImg.image = [UIImage imageNamed:@"dian_xq_ico_01"];
//    [vi1 addSubview:xiaoImg];
    
    UILabel *xiao = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale,0, 10*self.scale, vi1.height)];
    if ([self.xiaoliang isEqualToString:@""] || [self.xiaoliang isKindOfClass:[NSNull class]]) {
        self.xiaoliang=@"0";
    }
    xiao.text=[NSString stringWithFormat:@" 月销%@",self.xiaoliang];
    xiao.font=Small10Font(self.scale);
    xiao.textColor=grayTextColor;
    [xiao sizeToFit];
    [vi1 addSubview:xiao];
    
    
//    UIImageView *shouImg = [[UIImageView alloc]initWithFrame:CGRectMake(xiao.right+10*self.scale, 5*self.scale, 15*self.scale, 15*self.scale)];
//    shouImg.image = [UIImage imageNamed:@"dian_xq_ico_02"];
//    [vi1 addSubview:shouImg];
    
    UILabel *shou = [[UILabel alloc]initWithFrame:CGRectMake(xiao.right+10*self.scale, xiao.top, 10*self.scale, vi1.height)];
    shou.font=Small10Font(self.scale);
    shou.textColor=grayTextColor;
    if ([self.shoucang isEqualToString:@""] || [self.shoucang isKindOfClass:[NSNull class]]) {
        self.shoucang=@"0";
    }
    
    shou.text=[NSString stringWithFormat:@" 收藏:%@",self.shoucang];
    [shou sizeToFit];
    [vi1 addSubview:shou];

    
    UIButton *jianBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-95*self.scale, jiageD.bottom+0*self.scale, 22*self.scale, 22*self.scale)];
    [jianBtn setImage:[UIImage imageNamed:@"na1"] forState:UIControlStateNormal];
    jianBtn.tag=456;
    [jianBtn addTarget:self action:@selector(jiaBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_bigvi addSubview:jianBtn];
//    _bigvi.backgroundColor = [UIColor redColor];
    
    
    UILabel *num = [[UILabel alloc]initWithFrame:CGRectMake(jianBtn.right+5*self.scale, jiageD.bottom+3*self.scale, 33*self.scale, 17*self.scale)];
//    num.layer.borderWidth=.5;
//    num.layer.borderColor=[UIColor colorWithRed:204/255.0 green:205/255.0 blue:206/255.0 alpha:1].CGColor;
    num.font=SmallFont(self.scale);
    num.tag=678;
    num.text=[NSString stringWithFormat:@"%ld",(long)self.index];
    if (_index==0) {
        jianBtn.hidden=YES;
        num.hidden=YES;
    }else{
        jianBtn.hidden=NO;
        num.hidden=NO;
    }
    num.textColor=grayTextColor;
    num.textAlignment=NSTextAlignmentCenter;
    [_bigvi addSubview:num];
    
    
    UIButton *jiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [jiaBtn setImage:[UIImage imageNamed:@"na2"] forState:UIControlStateNormal];
    jiaBtn.frame=CGRectMake(num.right+5*self.scale, jiageD.bottom+0*self.scale, 22*self.scale, 22*self.scale);
    jiaBtn.tag=567;
    [jiaBtn addTarget:self action:@selector(jiaBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_bigvi addSubview:jiaBtn];

    if ([_data[0][@"inventory"] isEqualToString:@"0"]) {
        jiaBtn.hidden=YES;
    }else{
        jiaBtn.hidden=NO;
    }
    
    if (_data.count<=0) {
        jiaBtn.hidden=YES;
    }
    
    
    
    _priceLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, jiageD.bottom+5*self.scale, self.view.width -120*self.scale, _name.height)];
    
    _priceLa.textColor = [UIColor redColor];
    if (_data.count>0) {
        NSString * priceString =[NSString stringWithFormat:@"￥%@/%@",[_data[0] objectForKey:@"price"],_data[0][@"unit"]];
        NSString * firstString = [NSString stringWithFormat:@"￥%@",[_data[0] objectForKey:@"price"]];
        NSString * secondString = [NSString stringWithFormat:@"/%@",[_data[0] objectForKey:@"unit"]];
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:priceString];
        
        [string addAttribute:NSForegroundColorAttributeName value:grayTextColor range:NSMakeRange(firstString.length, secondString.length)];
        
        _priceLa.attributedText = string;
//        _priceLa.text=[NSString stringWithFormat:@"￥%@/%@",[_data[0] objectForKey:@"price"],_data[0][@"unit"]];
    }else{
        
        NSString * priceString =[NSString stringWithFormat:@"￥%@/%@",@"0",_data[0][@"unit"]];
        NSString * firstString = [NSString stringWithFormat:@"￥%@",@"0"];
        NSString * secondString = [NSString stringWithFormat:@"/%@",[_data[0] objectForKey:@"unit"]];
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:priceString];
        [string addAttribute:NSForegroundColorAttributeName value:grayTextColor range:NSMakeRange(firstString.length, secondString.length)];
        
        _priceLa.attributedText = string;
//        _priceLa.text=[NSString stringWithFormat:@"￥%@/%@",@"0",_data[0][@"unit"]];
    }
    _priceLa.textAlignment=NSTextAlignmentLeft;
    _priceLa.font = DefaultFont(self.scale);
  
    [_bigvi addSubview:_priceLa];
//    _name.width=self.view.width-_priceLa.left;
    _name.numberOfLines=0;
    [_name sizeToFit];
    jiageD.height=_name.bottom+30*self.scale;
    
    _priceLa.top=jiageD.bottom;
    
    
    [_priceLa sizeToFit];
    _priceLa.height=_name.height;
    
    
    
    
    UILabel *oldPrice = [[UILabel alloc]initWithFrame:CGRectMake(_priceLa.right+5*self.scale, 0, 0, 0)];
    oldPrice.font=[UIFont boldSystemFontOfSize:10*self.scale];
    oldPrice.textColor=grayTextColor;
    [_bigvi addSubview:oldPrice];
    if (_data.count>0) {
        oldPrice.text=[NSString stringWithFormat:@"￥%@",_data[0][@"origin_price"]];
    }else{
        oldPrice.text=[NSString stringWithFormat:@"￥%@",@"0"];
    }
    [oldPrice sizeToFit];
    oldPrice.centerY=_priceLa.centerY;


    UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(0, oldPrice.height/2, oldPrice.width, .5)];
    lin.backgroundColor=grayTextColor;
    [oldPrice addSubview:lin];

    
    float yuan = [[NSString stringWithFormat:@"%@",_data[0][@"origin_price"]] floatValue];
    float xian = [[NSString stringWithFormat:@"%@",[_data[0] objectForKey:@"price"]] floatValue];
    
    if (xian>=yuan) {
        oldPrice.hidden=YES;
        lin.hidden=YES;
    }
    
//    if ([[NSString stringWithFormat:@"%@",_data[0][@"origin_price"]] isEqualToString:[NSString stringWithFormat:@"%@",[_data[0] objectForKey:@"price"]]]) {
//        oldPrice.hidden=YES;
//        lin.hidden=YES;
//    }

    
    _bigvi.height=_priceLa.bottom+15*self.scale;
    
    
    
    
    
    
    
    
    UIView *prodNameLine = [[UIView alloc]initWithFrame:CGRectMake(0, _bigvi.height-.5, self.view.width, .5)];
    prodNameLine.backgroundColor=blackLineColore;
    [_bigvi addSubview:prodNameLine];
    
    if (_infoName) {
        [_infoName removeFromSuperview];
    }
    self.infoName = [[UILabel alloc]initWithFrame:CGRectMake(0*self.scale, _bigvi.bottom, self.view.width, 70/2.25*self.scale)];
    self.infoName.text = @"     商品简介";
    _infoName.backgroundColor=superBackgroundColor;
    _infoName.font=Big15Font(self.scale);
    [_scrollView addSubview:_infoName];
    _scrollView.backgroundColor=[UIColor whiteColor];
    
    
    UIView *infoLine = [[UIView alloc]initWithFrame:CGRectMake(-10*self.scale, self.infoName.height-.5, self.view.width, .5)];
    infoLine.backgroundColor = blackLineColore;
    [self.infoName addSubview:infoLine];
    
    
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, self.infoName.bottom, self.view.bounds.size.width, 540/2.25*self.scale) ];
    vi.backgroundColor= [UIColor whiteColor];
    [_scrollView addSubview:vi];
    
    

    
    self.info = [[UILabel alloc]initWithFrame:CGRectMake(20*self.scale, 10*self.scale, vi.width-40*self.scale,vi.height-40*self.scale)];
    self.info.numberOfLines=0;
    self.info.textAlignment = NSTextAlignmentLeft;
    self.info.font=DefaultFont(self.scale);
    self.info.textColor = grayTextColor;
    self.info.text = [NSString stringWithFormat:@"%@",[[_data [0]objectForKey:@"description"] trimString]];
    [vi addSubview:_info];
    
    if (!self.info.text) {
        self.info.text=@"";
        
    }
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 5;// 字体的行间距
//    
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 };
//    _info.attributedText = [[NSAttributedString alloc] initWithString:_info.text attributes:attributes];
//    
//    
//    
//    
//    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    NSDictionary *attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle1.copy};
//    
//    CGSize size = [self.info.text boundingRectWithSize:CGSizeMake(self.info.width,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes1 context:nil].size;
//    
//    _info.height = size.height;
    [_info sizeToFit];
    //vi.backgroundColor=[UIColor redColor];
    vi.height = _info.bottom+10*self.scale;
    
    if (_arr.count==0||_arr.count==1) {
         _scrollView.contentSize = CGSizeMake(self.view.width, vi.bottom);
        
    }else{
        NSLog(@"%@",_arr);
        for (int i=0; i<_arr.count-1; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(8*self.scale, vi.bottom+210*self.scale*i, self.view.width-16*self.scale, 200*self.scale)];
            NSLog(@"%@",_arr);
            [img setImageWithURL:[NSURL URLWithString:_arr[i+1]] placeholderImage:[UIImage imageNamed:@"za"]];
            NSLog(@"%@",_arr[i+1]);
            img.userInteractionEnabled=YES;
            [_scrollView addSubview:img];
            img.tag=10000+i;
            
            img.contentMode=UIViewContentModeScaleAspectFill;
            img.clipsToBounds=YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgbig:)];
            [img addGestureRecognizer:tap];
            _scrollView.contentSize = CGSizeMake(self.view.width, img.bottom);
        }
    }
    
  

    
    
   
   
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if( string )
    {
        [_soapResults appendString: string];
    }
    
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
  //  NSString *str=[NSString stringWithFormat:@"%@",_soapResults];
  //  NSData *dataresult=[str dataUsingEncoding:NSUTF8StringEncoding];
 //   NSString *textt = [[NSString alloc]initWithData:dataresult encoding:NSUTF8StringEncoding];
    
    [self centerCont];
}

-(void)jiaBtnEvent:(UIButton *)btn{
   
    
    if ([Stockpile sharedStockpile].isLogin==NO) {
        
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {
                    
                    [self ReshData];
                }];
            }
            
        }];
        
        return;
    }
   
  
    
    
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    
    if (_orshoucang) {
        if (btn.tag==456) {
            _numb--;
            _index--;
            _type=@"1";
        }else{
            _numb++;
            _index++;
            _type=@"2";
        }
        if (_numb<=0) {
            _numb=0;
//            _botRTwo.hidden=YES;
            
            //            return;
        }
        if (_index<=0) {
            _index=0;
        }

        NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
        NSString *num = [NSString stringWithFormat:@"%ld",(long)_index];
        NSDictionary *dicc = @{@"user_id":userid,@"prod_id":self.prod_id,@"prod_count":num,@"shop_id":self.shop_id};
        
        AnalyzeObject *anle = [AnalyzeObject new];
        [anle addProdWithDic:dicc Block:^(id models, NSString *code, NSString *msg) {
            [self ReshBotView];
            [self shangJiaXiangQing];
            [self.activityVC stopAnimate];

            if ([code isEqualToString:@"0"]) {
               
//                UIButton *jianBtn = (UIButton *)[self.view viewWithTag:456];
//                UILabel *num = (UILabel *)[self.view viewWithTag:678];
//                num.text=[NSString stringWithFormat:@"%ld",(long)_index];

//                if (_index<=0) {
//                    jianBtn.hidden=YES;
//                    num.hidden=YES;
//                    _botRTwo.hidden=YES;
//                }else{
//                    jianBtn.hidden=NO;
//                    num.hidden=NO;
//                    _botRTwo.hidden=NO;
//                }
//                
                
                
            
                
            }else{
                if (btn.tag==456) {
                    _numb++;
                    _index++;
                    _type=@"1";
                }else{
                    _numb--;
                    _index--;
                    _type=@"2";
                }
                [self ShowAlertWithMessage:msg];
            }
        
         
         }];
    }else{
        

        if (btn.tag==456) {
            _numb--;
            _index--;
            _type=@"1";
        }else{
            _numb++;
            _index++;
            _type=@"2";
        }
        if (_numb<=0) {
            _numb=0;
//            _botRTwo.hidden=YES;

//            return;
        }
        if (_index<=0) {
            _index=0;
        }
   
//        UIButton *jianBtn = (UIButton *)[self.view viewWithTag:456];
//        UILabel *num = (UILabel *)[self.view viewWithTag:678];
////        num.text=[NSString stringWithFormat:@"%ld",(long)_index];
//        if (_index<=0) {
//            jianBtn.hidden=YES;
//            num.hidden=YES;
//            _botRTwo.hidden=YES;
//            
//            if (_numb<=0) {
//                _botRTwo.hidden=YES;
//            }
//     
//            
//        }else{
//            jianBtn.hidden=NO;
//            num.hidden=NO;
//            _botRTwo.hidden=NO;
//        }

        if (_delegate && [_delegate respondsToSelector:@selector(addNumberindex:number:)]) {
            [_delegate addNumberindex:self.indexNumber number:_index];
            
        }
    }
    
//    if (btn.tag==456) {
//        _zongPrice = _zongPrice-[_data[0][@"price"]floatValue];
//    }else{
//        _zongPrice = _zongPrice+[_data[0][@"price"]floatValue];
//    }
    
    
    
    
    
    
    
    

    
}

//增加失败后要让数量减一
-(void)shibaijian{
    [self.activityVC stopAnimate];
//    if ([_type isEqualToString:@"1"]) {
//        _index++;
//        _numb++;
//    }else{
//        _index--;
//        _numb--;
//    }
//    UILabel *la = (UILabel *)[self.view viewWithTag:678];
//    la.text=[NSString stringWithFormat:@"%ld",(long)_index];
//
//    if (_delegate && [_delegate respondsToSelector:@selector(addNumberindex:number:)]) {
//       // [_delegate addNumberindex:self.indexNumber number:_numb];
//    }
//    [self ReshBotView];

}

-(void)actrectstop{
    [self ReshBotView];
    [self shangJiaXiangQing];
//    UILabel *num = (UILabel *)[self.view viewWithTag:678];
//    UIButton *jianBtn = (UIButton *)[self.view viewWithTag:456];
//
//    num.text=[NSString stringWithFormat:@"%ld",(long)_index];
//    if (_index<=0) {
//        jianBtn.hidden=YES;
//        num.hidden=YES;
//        _botRTwo.hidden=YES;
//        
//        if (_numb<=0) {
//            _botRTwo.hidden=YES;
//        }
//        
//        
//    }else{
//        jianBtn.hidden=NO;
//        num.hidden=NO;
//        _botRTwo.hidden=NO;
//    }
//
    [self.activityVC stopAnimate];
}

//#pragma mark-------底部UI设置，购物车，联系买家，收藏。
//-(void)bottomVi{
////    
////    if (_bottomL) {
////        [_bottomL removeFromSuperview];
////    }
////    
////    
////    self.bottomL = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-49*self.scale, 258/2.25*self.scale, 49*self.scale)];
////    self.bottomL.backgroundColor = [UIColor whiteColor];
////    self.bottomL.userInteractionEnabled=YES;
////    [self.view addSubview:self.bottomL];
////    self.view.userInteractionEnabled=YES;
////    //左边按钮图片
////    NSArray *imgArr = @[@"dian_ico_01",@"dian_ico_02"];
////    NSArray *textArr = @[@"联系卖家",@"收藏商品"];
////    for (int i=0; i<2; i++) {
////        UIButton *vi = [[UIButton alloc]initWithFrame:CGRectMake(20+40*self.scale*i*1.4, 7*self.scale, 45/2.25*self.scale, 45/2.25*self.scale)];
////        [vi setBackgroundImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
////        [self.bottomL addSubview:vi];
////        
////        
////    
////        
////        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(vi.left-12.5, vi.bottom+5, 50*self.scale, 15)];
////        la.text = textArr[i];
////        
////        la.font = [UIFont systemFontOfSize:12];
////        [self.bottomL addSubview:la];
////      
////        
////        
////        if (i==1) {
////            
////            vi.tag=909;
////            la.tag=908;
////            [vi setBackgroundImage:[UIImage imageNamed:@"12"] forState:UIControlStateSelected];
////            if ([_data[0][@"is_collect"] isEqualToString:@"2"]) {
////                vi.selected=YES;
////                la.text=@"取消收藏";
////                la.textColor=blueTextColor;
////            }
////            
////        }
////        
////        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
////        b.frame = CGRectMake(10+40*self.scale*i*1.2, 7, 105/2.25*self.scale, 70/2.25*self.scale);
////        b.tag = 10+i;
////        [b addTarget:self action:@selector(leftClinck:) forControlEvents:UIControlEventTouchUpInside];
////        [self.bottomL addSubview:b];
////    }
////    
//    if (_bottomR) {
//        [_bottomR removeFromSuperview];
//    }
//    //右边购物车
//    self.bottomR = [[UIImageView alloc]initWithFrame:CGRectMake(self.bottomL.right, self.view.bounds.size.height-49*self.scale, self.view.bounds.size.width-258/2.25*self.scale, 49*self.scale)];
//    self.bottomR.userInteractionEnabled = YES;
//    [self.view addSubview:_bottomR];
//    float l = self.bottomR.left;
//    
//    //右下角购物车第一种形式----购物车是空的
//    self.botROne = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width-258/2.25*self.scale, 49*self.scale)];
//    _botROne.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
//    [self.bottomR addSubview:_botROne];
//    
//    UILabel *shop = [[UILabel alloc]init];
//    shop.frame = CGRectMake(l-40, 10, 150*self.scale, 30*self.scale);
//    shop.text = @"购物车是空的";
//    shop.font=DefaultFont(self.scale);
//    shop.textColor = grayTextColor;
//    [_botROne addSubview:shop];
//    
//    
//    
//    UIImageView *garCar = [[UIImageView alloc]initWithFrame:CGRectMake(shop.left-30*self.scale, _botROne.height/2-10*self.scale, 25*self.scale, 20*self.scale)];
//    garCar.image=[UIImage imageNamed:@"dian_ico_03"];
//    [_botROne addSubview:garCar];
//
//    
//    
//    
//    
////右下角购物车第二种形式-----购物车有东西
//    self.botRTwo = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width-258/2.25*self.scale, 49*self.scale)];
//    _botRTwo.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
//    [self.bottomR addSubview:_botRTwo];
//    
//
//
//    
//    
//    UIButton *shopcarImgL = [[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, 7*self.scale, 35*self.scale, 35*self.scale)];
//    [shopcarImgL setImage:[UIImage imageNamed:@"dian_shopping"] forState:UIControlStateNormal];
//    [shopcarImgL addTarget:self action:@selector(goShopCar) forControlEvents:UIControlEventTouchUpInside];
//    [self.botRTwo addSubview:shopcarImgL];
//    
//    //购物车左上角的红色数字;
//    UIButton *numberImg = [[UIButton alloc]initWithFrame:CGRectMake(shopcarImgL.width-12*self.scale,0, 15*self.scale, 15*self.scale)];
//    numberImg.backgroundColor = [UIColor redColor];
//    numberImg.layer.cornerRadius=numberImg.width/2;
//    [numberImg setTitle:[NSString stringWithFormat:@"%d",_numb] forState:UIControlStateNormal];
////    if (_islunbo) {
////        [numberImg setTitle:[NSString stringWithFormat:@"%@",_carNum] forState:UIControlStateNormal];
////    }
//    numberImg.tag=666;
//    numberImg.titleLabel.font = Small10Font(self.scale);
//    [shopcarImgL addSubview:numberImg];
//    
//    
//    
//    
//    
//    float r = shopcarImgL.right;
//    float t = shopcarImgL.top;
//    
//
//
//
//    
//    
//    
//    _shopCarLa = [[UILabel alloc]initWithFrame:CGRectMake(r+10, t+10, 70*self.scale, 20)];
//
//    
////        NSString *cccc = [_price substringToIndex:[_price length] - 1];
////        cccc=[cccc substringFromIndex:1];
//    
//    _shopCarLa.text = [NSString stringWithFormat:@"共%.2f元",_zongPrice];
//
//    
//    _shopCarLa.textColor = [UIColor redColor];
//    _shopCarLa.font=SmallFont(self.scale);
//    [self.botRTwo addSubview:_shopCarLa];
//    _i++;
//
//    
//    UIButton *shopCarR = [UIButton buttonWithType:UIButtonTypeSystem];
//    shopCarR.frame = CGRectMake(self.bottomR.right-190*self.scale, 12.5*self.scale, 144/2.25*self.scale, 61/2.25*self.scale);
//    shopCarR.layer.cornerRadius = 3.0f;
//    [shopCarR setBackgroundColor:[UIColor redColor]];
//    [shopCarR setTitle:@"选好了" forState:UIControlStateNormal];
//    shopCarR.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
//    shopCarR.tag=907;
//    [shopCarR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [shopCarR addTarget:self action:@selector(gooderi) forControlEvents:UIControlEventTouchUpInside];
//    [self.botRTwo addSubview:shopCarR];
//    
//    
//    
//    if (_index<=0 && _numb<=0) {
//        _botRTwo.hidden=YES;
//    }else if(_index<=0){
//        
//        shopCarR.backgroundColor=[UIColor grayColor];
//        shopCarR.userInteractionEnabled=NO;
//        
//        
//    }else{
//        shopCarR.backgroundColor=[UIColor redColor];
//        shopCarR.userInteractionEnabled=YES;
//
//    }
//    
//    
//    if (_numb<=0) {
//        _botRTwo.hidden=YES;
//    }
//    
//    if ([Stockpile sharedStockpile].isLogin==NO) {
//        self.botRTwo.hidden=YES;
//    }
//    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _bottomL.top, self.view.width, .5)];
//    line.backgroundColor=blackLineColore;
//    [self.view addSubview:line];
//    _yes=YES;
//}

#pragma mark-------底部UI设置，购物车。
-(void)bottomVi{
    
    //    if (_bottomL) {
    //        [_bottomL removeFromSuperview];
    //    }
    //
    //    self.bottomL = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 258/2.25*self.scale, 49*self.scale)];
    //    self.bottomL.backgroundColor = [UIColor whiteColor];
    //    self.bottomL.userInteractionEnabled=YES;
    //    self.bottomL.backgroundColor = [UIColor redColor];
    //    [self.NavImg addSubview:self.bottomL];
    //    self.view.userInteractionEnabled=YES;
    //
    //
    //
    //    //左边按钮图片
    //    NSArray *imgArr = @[@"dian_ico_01",@"dian_ico_02"];
    //    NSArray *textArr = @[@"联系卖家",@"收藏店铺"];
    //    for (int i=0; i<2; i++)
    //    {
    //        UIButton *vi = [[UIButton alloc]initWithFrame:CGRectMake(20+40*self.scale*i*1.4, 7*self.scale, 45/2.25*self.scale, 45/2.25*self.scale)];
    //        [vi setBackgroundImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
    //
    //        [self.bottomL addSubview:vi];
    //
    //        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(vi.left-12.5, vi.bottom+5, 50*self.scale, 15)];
    //        la.text = textArr[i];
    //        la.font = [UIFont systemFontOfSize:12];
    //        [self.bottomL addSubview:la];
    //
    //
    //
    ////        NSLog(@"%@   ///// %@",_data,_rightData);
    ////                        UIButton *btn = (UIButton *)[_bottomL viewWithTag:909];
    ////                        UILabel *btn1 = (UILabel *)[_bottomL viewWithTag:908];
    //
    //
    //        if (i==1) {
    //            vi.tag=909;
    //            la.tag=908;
    //            [vi setBackgroundImage:[UIImage imageNamed:@"12"] forState:UIControlStateSelected];
    //
    //
    //            if (_orshou)
    //            {
    //                _shouCangbtn.selected=YES;
    //                la.text=@"取消收藏";
    //                la.textColor=blueTextColor;
    //
    //            }
    //
    ////            AnalyzeObject *analyze = [AnalyzeObject new];
    ////        NSDictionary *d = @{@"user_id":[self getuserid],@"collect_id":self.ID,@"collect_type":@"2"};
    ////        [analyze isCollectWithDic:d Block:^(id models, NSString *code, NSString *msg) {
    ////            if ([[NSString stringWithFormat:@"%@",models] isEqualToString:@"2"]) {
    ////                vi.selected=YES;
    ////                la.text=@"取消收藏";
    ////                la.textColor=blueTextColor;
    ////                _shoucang=YES;
    ////                _orshou=YES;
    ////            }
    ////
    ////        }];
    //
    //        }
    //
    //
    //
    //
    //
    //
    //
    ////
    ////            if ([_rightData[0][@"is_collect"] isEqualToString:@"2"]) {
    ////                vi.selected=YES;
    ////                la.text=@"取消收藏";
    ////                la.textColor=blueTextColor;
    ////            }
    //
    //
    ////        if (i==1) {
    ////            vi.tag=909;
    ////            la.tag=908;
    ////            [vi setBackgroundImage:[UIImage imageNamed:@"12"] forState:UIControlStateSelected];
    ////        }
    //
    //
    //        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    //        b.frame = CGRectMake(10+40*self.scale*i*1.2, 7, 105/2.25*self.scale, 80/2.25*self.scale);
    //        b.tag = 10+i;
    //        //b.backgroundColor=[UIColor redColor];
    //        [b addTarget:self action:@selector(leftClinck:) forControlEvents:UIControlEventTouchUpInside];
    //        [self.bottomL addSubview:b];
    //    }
    
    //
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
    [_numberImg setTitle:[NSString stringWithFormat:@"%d",_numb] forState:UIControlStateNormal];
   [[NSUserDefaults standardUserDefaults] setObject:_numberImg.titleLabel.text forKey:@"GouWuCheShuLiang"];
    _numberImg.titleLabel.font = Small10Font(self.scale);
    [shopcarImgL addSubview:_numberImg];
    
    
    //    if ([_numberImg.titleLabel.text isEqualToString:@"0"] || [_numberImg.titleLabel.text isEqualToString:@""] || _numberImg.titleLabel.text==nil) {
    //
    //        self.botRTwo.hidden=YES;
    //    }
    //    if ([_carNum isEqualToString:@""] || !_carNum) {
    //        self.botRTwo.hidden=YES;
    //
    //    }
    //
    //    if ([Stockpile sharedStockpile].isLogin==NO) {
    //        self.botRTwo.hidden=YES;
    //    }
    
    
    float r = shopcarImgL.right;
    float t = shopcarImgL.top;
    
    _shopCarLa = [[UILabel alloc]initWithFrame:CGRectMake(r+5*self.scale,0, [UIScreen mainScreen].bounds.size.width - r - 110*self.scale , 20*self.scale)];
    _shopCarLa.attributedText = [self jiSuanBenDianXiaoFei];
    _shopCarLa.font=Small10Font(self.scale);
    _shopCarLa.textColor = [UIColor redColor];
    [self.botRTwo addSubview:_shopCarLa];
    
    
    _peiSongLab = [[UILabel alloc]initWithFrame:CGRectMake(r+5*self.scale, _shopCarLa.bottom, _shopCarLa.width, 20*self.scale)];
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
-(void)gooderi{
    self.hidesBottomBarWhenPushed = YES;
    GouWuCheViewController *shoppingCar = [GouWuCheViewController new];
    shoppingCar.islunbo=YES;
//    shoppingCar.popTwoVi=YES;
    shoppingCar.reshLingShou = ^(NSString *str){
        
        [self ReshBotView];
        [self shangJiaXiangQing];
        
    };
    shoppingCar.fromLingShou=YES;

    _yes=NO;
    _numb=0;
    [self.navigationController pushViewController:shoppingCar animated:YES];

//    self.hidesBottomBarWhenPushed=YES;
//    OrderConfirmViewController *con = [OrderConfirmViewController new];
//    con.shop_id = self.shop_id;
//    con.tel=self.tel;
////    con.yunfei=self.yunfei;
//    [self.navigationController pushViewController:con animated:YES];
}



//-(void)goShopCar{
//    self.hidesBottomBarWhenPushed = YES;
//    GouWuCheViewController *shoppingCar = [GouWuCheViewController new];
//    shoppingCar.islunbo=YES;
//    //    shoppingCar.popTwoVi=YES;
//    shoppingCar.reshLingShou = ^(NSString *str){
//        
//        [self ReshBotView];
//        
//    };
//    shoppingCar.fromLingShou=YES;
//    
//    _yes=NO;
//    _numb=0;
//    [self.navigationController pushViewController:shoppingCar animated:YES];
//    
//    
////    self.tabBarController.selectedIndex = 2;
//
////    self.hidesBottomBarWhenPushed = YES;
////    GouWuCheViewController *shoppingCar = [GouWuCheViewController new];
////    shoppingCar.islunbo=YES;
////    shoppingCar.popTwoVi=YES;
////    _yes=NO;
////    _numb=0;
////    [self.navigationController pushViewController:shoppingCar animated:YES];
//    
//}

#pragma mark--------左下角按钮方法
-(void)leftClinck:(UIButton *)sender{
    
    if (sender.tag != 12)
    {
        if ([Stockpile sharedStockpile].isLogin==NO) {
            
            [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
                if (index==1) {
                    LoginViewController *login = [self login];
                    [login resggong:^(NSString *str) {
                        
                        [self ReshData];
                    }];
                }
                
            }];
            
            return;
        }
    }


    
    if (sender.tag==10) {
        //联系卖家
//        if (!_isopen) {
//            [self ShowAlertWithMessage:@"该商家暂未开通聊天功能！"];
//            return;
//        }
//        self.hidesBottomBarWhenPushed=YES;
//        RCDChatViewController *rcd = [RCDChatViewController new];
//        rcd.targetId=self.shop_user_id;
//        rcd.conversationType = ConversationType_PRIVATE;
//        rcd.title = self.shop_name;
//        [self.navigationController pushViewController: rcd animated:YES];
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.shop_id forKey:@"shop_id"];
            [dic setObject:[NSString stringWithFormat:@"%@",self.tel] forKey:@"tel"];
        if ([Stockpile sharedStockpile].isLogin) {
            [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
        }
        
        [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
                
                
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.tel];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                
            }
            
        }];

    }else if (sender.tag == 11)
    {
        //收藏
        
        AnalyzeObject *anle = [AnalyzeObject new];
        NSDictionary *dd = @{@"user_id":[self getuserid],@"collect_id":self.prod_id};

        if (_shouCangbtn.selected == YES)
        {
            [anle delCollectWithDic:dd Block:^(id models, NSString *code, NSString *msg) {
                if ([code isEqualToString:@"0"])
                {
                    _shouCangbtn.selected = NO;
                    if (_block) {
                        _block(@"ok");
                    }
                }
                
            }];
            
            
            return;
        }

        NSDictionary *dic = @{@"user_id":[self getuserid],@"collect_type":@"1",@"collect_id":_data[0][@"id"]};
        

        [anle addCollectWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"0"] || [code isEqualToString:@"1"]) {
                [self ShowAlertWithMessage:@"收藏成功"];
                _shouCangbtn.selected = YES;
                if (_block) {
                    _block(@"ok");
                }
            }
        }];
        
        
        
        
        
    }
    else if (sender.tag == 12)
    {
        self.hidesBottomBarWhenPushed = YES;
        SouViewController * souView = [[SouViewController alloc]init];
        NSLog(@"%@",_remindDic[@"shop_id"]);
        souView.shop_id = _remindDic[@"shop_info"][@"id"];
        souView.keyword = @"";
        [self.navigationController pushViewController:souView animated:YES];
    }
   
    
}

#pragma mark -----返回按钮
-(void)returnVi{
//    self.TitleLabel.text=@"商品详情";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
//    if (_isgo) {
//        UIButton *xiangqing = [UIButton buttonWithType:UIButtonTypeCustom];
//        [xiangqing setTitle:@"进入店铺" forState:UIControlStateNormal];
//        xiangqing.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14*self.scale];
//        xiangqing.frame=CGRectMake(self.view.width-70*self.scale, self.TitleLabel.top, 60*self.scale, self.TitleLabel.height);
//        [xiangqing addTarget:self action:@selector(goshop) forControlEvents:UIControlEventTouchUpInside];
//        [self.NavImg addSubview:xiangqing];
//
//    }
    [self daoHangBtn];
    
}
#pragma mark -- 导航上的联系商家，收藏和搜索
- (void)daoHangBtn
{
    
    CGFloat w = 0.0;
    if (_isgo){
        UIButton *xiangqing = [UIButton buttonWithType:UIButtonTypeCustom];
        [xiangqing setTitle:@"进入店铺" forState:UIControlStateNormal];
        xiangqing.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14*self.scale];
        [xiangqing setTitleColor:blueTextColor forState:(UIControlStateNormal)];
        xiangqing.frame=CGRectMake(self.view.width-70*self.scale, self.TitleLabel.top, 70*self.scale, self.TitleLabel.height);
        [xiangqing addTarget:self action:@selector(goshop) forControlEvents:UIControlEventTouchUpInside];
        [self.NavImg addSubview:xiangqing];
        w = xiangqing.width;
    }
    
    //收藏按钮
    _shouCangbtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - self.TitleLabel.height-w,self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [_shouCangbtn setImage:[UIImage imageNamed:@"sc"] forState:(UIControlStateNormal)];
    [_shouCangbtn setImage:[UIImage imageNamed:@"sc_1"] forState:(UIControlStateSelected)];
    
    _shouCangbtn.tag = 11;
    
    
    
    [_shouCangbtn addTarget:self action:@selector(leftClinck:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //    _shouCangbtn.backgroundColor = [UIColor blueColor];
    [self.NavImg addSubview:_shouCangbtn];
    
    //搜索按钮
    UIButton * sousuoBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - (self.TitleLabel.height)*2-w, self.TitleLabel.top,self.TitleLabel.height, self.TitleLabel.height)];
    [sousuoBtn setImage:[UIImage imageNamed:@"soso1"] forState:(UIControlStateNormal)];
    sousuoBtn.tag = 12;
    [sousuoBtn addTarget:self action:@selector(leftClinck:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.NavImg addSubview:sousuoBtn];
    
    //联系商家btn
//    CGRect lianXiRect = [self getStringWithFont:12*self.scale withString:@"联系商家" withWith:999999];
    UIButton * lianxiShangJiaBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - (self.TitleLabel.height)*3 - w, self.TitleLabel.top,self.TitleLabel.height, self.TitleLabel.height)];
    lianxiShangJiaBtn.tag = 10;
    [lianxiShangJiaBtn addTarget:self action:@selector(leftClinck:) forControlEvents:(UIControlEventTouchUpInside)];
    [lianxiShangJiaBtn setImage:[UIImage imageNamed:@"tel"] forState:(UIControlStateNormal)];
    [self.NavImg addSubview:lianxiShangJiaBtn];
    
//    UIButton * imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.NavImg.height - 22, self.NavImg.height - 22)];
//    [imageBtn setImage:[UIImage imageNamed:@"tel"] forState:(UIControlStateNormal)];
//    imageBtn.userInteractionEnabled = NO;
//    [lianxiShangJiaBtn addSubview:imageBtn];
//    
//    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(imageBtn.right, 0, lianxiShangJiaBtn.width - imageBtn.width, lianxiShangJiaBtn.height)];
//    lab.text = @"联系商家";
//    lab.textColor = blueTextColor;
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.font = SmallFont(self.scale);
//    [lianxiShangJiaBtn addSubview:lab];
}


-(void)goshop{

    self.hidesBottomBarWhenPushed=YES;
   
    BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
    
//    if ([_data[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
//        info.isopen=NO;
//    }else{
//        info.isopen=YES;
//    }
    
    
         info.gonggao = self.gongGao;
         info.tel=_tel;
         info.titlete=_shop_name;
         info.shop_user_id=_shop_user_id;
         info.issleep=_issleep;
         info.manduoshaofree=[_data[0] objectForKey:@"free_delivery_amount"];
    
    NSString *ID = [_data[0]objectForKey:@"id"];

//    info.tel=[NSString stringWithFormat:@"%@",[_data[0] objectForKey:@"hotline"]];
   
    info.ID=_shop_id;
   
//    info.shopImg = [_data[0] objectForKey:@"logo"];
//    info.gonggao = [_data[0] objectForKey:@"notice"];
  
    NSLog(@"%@",_data[0]);
    NSLog(@"%@",[_data[0] objectForKey:@"notice"]);
//    info.yunfei =[_data[0] objectForKey:@"delivery_fee"];
    
    NSLog(@"%@",info.manduoshaofree);
   
//
    NSLog(@"%@",info.shop_user_id);
    
   
    [self.navigationController pushViewController:info animated:YES];

}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    if (_timer) {
        
    
    [_timer invalidate];
    _timer=nil;
    }

//    if (_popTwo) {
//        UIViewController *vi = self.navigationController.viewControllers[1];
//        if ([vi isKindOfClass:[BreakInfoViewController class]]) {
//            vi =self.navigationController.viewControllers[0];
//        }
//        [self.navigationController popToViewController:vi animated:YES];
//
//        
//    }else{
    if (_isPush)
    {
//        [self dismissViewControllerAnimated:YES completion:nil];
         self.dismissBlock(YES);
    }
    else
    {
      [self.navigationController popViewControllerAnimated:YES];
    }
//    }
    

    
    
}
-(void)dealloc{
  //  [super dealloc];
    [[NSNotificationCenter defaultCenter]removeObserver:self];


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

#pragma mark -- 显示配送费
- (NSString *)xianShiPeiSongFei
{
    
    
    NSString * peiSongFei = [NSString stringWithFormat:@"配送费%@元，满%@元免配送费",_remindDic[@"shop_info"][@"delivery_fee"],_remindDic[@"shop_info"][@"free_delivery_amount"]];
    
    return peiSongFei;
}
#pragma mark-------去购物车，  去订单订单详情
-(void)goShopCar{
    
    //    if () {
    //        <#statements#>
    //    }
    //    self.hidesBottomBarWhenPushed = YES;
    //    GouWuCheViewController *gouwuceh = [GouWuCheViewController new];
    ////    gouwuceh.reshNum=^(NSString *str){
    ////
    ////        for (int i = 0; i < _rightData.count; i ++) {
    ////
    ////
    ////            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
    ////
    ////            BreakInfoCell *cell = [_rightTable  cellForRowAtIndexPath:index];
    ////
    ////
    ////
    ////            [cell shopNumberClinck:nil];
    ////
    ////        }
    ////
    ////
    ////
    ////    };
    //    gouwuceh.reshLingShou = ^(NSString *str){
    //
    //        [self ReshBotView];
    //
    //    };
    //    gouwuceh.fromLingShou=YES;
    //    [self.rightTable reloadData];
    //    [self.navigationController pushViewController:gouwuceh animated:YES];
    
    if ([Stockpile sharedStockpile].isLogin==NO) {
        
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {
                    
                    [self ReshData];
                }];
            }
            
        }];
        
        return;
    }
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
    //    self.tabBarController.selectedIndex = 2;
    
}
-(void)godingdan{
    
    
    if ([Stockpile sharedStockpile].isLogin==NO) {
        
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {
                    
                    [self ReshData];
                }];
            }
            
        }];
        
        return;
    }
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //    self.hidesBottomBarWhenPushed = YES;
    //    GouWuCheViewController *gouwuceh = [GouWuCheViewController new];
    //    gouwuceh.reshLingShou = ^(NSString *str){
    //
    //        [self ReshBotView];
    //        [self shangJiaXiangQing];
    //
    //    };
    //    gouwuceh.fromLingShou=YES;
    //    [self.rightTable reloadData];
    //    [self.navigationController pushViewController:gouwuceh animated:YES];
    
    //    self.hidesBottomBarWhenPushed = YES;
    //
    ////    _list=[[NSMutableArray alloc]init];
    ////    NSDictionary *shopInfo=[[NSDictionary alloc]initWithObjectsAndKeys:_ID,@"shopid",
    ////                            self.titlete,@"shopname",
    ////                            self.shopImg,@"image",
    ////                            _GoodsList,@"list", nil];
    ////    [_list addObject:shopInfo];
    //
    //    OrderConfirmViewController *gouwuceh = [OrderConfirmViewController new];
    //    gouwuceh.shop_id=_ID;
    //    gouwuceh.yunfei=self.yunfei;
    //    gouwuceh.tel=self.tel;
    //    [self.navigationController pushViewController:gouwuceh animated:YES];
    
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
