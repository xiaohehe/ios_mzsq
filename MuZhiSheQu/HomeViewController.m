//
//  HomeViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/9/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HomeViewController.h"
#import "ChoosePlotController.h"
#import "UIColor+Hex.h"
#import "SouViewController.h"
#import "IMViewController.h"
#import "GoodsTableViewCell.h"
#import "AppUtil.h"
#import "DataBase.h"
#import "LoginViewController.h"
#import "ShopInfoViewController.h"
#import "MuZhiSheQu-Swift.h"
#import "MineCollectionViewCell.h"
#import "ForumViewController.h"
#import "LifeServiceViewController.h"
#import "WindowShoppingViewController.h"
#import "RCDChatListViewController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "BusinessLocationViewController.h"
static const NSUInteger SECTION_TAG=1000;
static const NSUInteger MESSAGE_TAG = 10000+1;
static const NSUInteger ADD_CART_TAG = 1000000;//增加购物车商品数量
static const NSUInteger CART_NUM_TAG = 2000000;//购物车商品数量
static const NSUInteger SUB_CART_TAG = 3000000;//减少购物车商品数量
static const NSUInteger FUNCTION_TAG = 400000;//表头小功能
static const NSUInteger IMAGE_TAG = 500000;//表头活动图片


@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,BMKLocationServiceDelegate>{
    UILabel *community;
   // UITextField *souTf;
    UIButton *souTf;
    UITableView* goodsTv;
    NSDictionary *shopData;
    NSMutableArray* goodsArray;//商品数组
    UIView* headerView;
    UIImageView *otherIv;
    UILabel *otherLb;
    UIButton *otherBtn;
    UILabel *addressLb;
    UIButton* followMeBtn;
    UIScrollView* functionSv,*imageSv;
    WEIPageControl* functionPg,*imagePg;
    NSMutableArray* functionArray;//功能数组
    NSMutableArray* imageArray;//活动图片数组
    BMKLocationService *sre;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self returnVi];
    goodsArray=[[NSMutableArray alloc]init];
    shopData=[[NSMutableDictionary alloc] init];
    functionArray=[[NSMutableArray alloc] init];
    imageArray=[[NSMutableArray alloc] init];
    //[self newHeaderView];
    goodsTv=[[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.frame.size.width,self.view.frame.size.height-self.NavImg.height- self.tabBarController.tabBar.frame.size.height ) style:UITableViewStyleGrouped];
    [goodsTv registerClass:[GoodsTableViewCell class] forCellReuseIdentifier:@"GoodsTableViewCell"];
    goodsTv.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:goodsTv];
    goodsTv.delegate=self;
    goodsTv.dataSource=self;
    goodsTv.showsVerticalScrollIndicator=NO;
    goodsTv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.activityVC];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView==functionSv){
        CGPoint offset = scrollView.contentOffset;
        functionPg.currentPage = offset.x / (self.view.bounds.size.width); //计算当前的页码
        [functionSv setContentOffset:CGPointMake(self.view.bounds.size.width * (functionPg.currentPage), functionSv.contentOffset.y) animated:YES]; //设置scrollview的显示为当前滑动到的页面
    }
}

/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
     [self.activityVC startAnimate];
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{
     [self.activityVC stopAnimate];
}

-(void)dingwei{
    if(sre==nil){
        sre = [[BMKLocationService alloc]init];
        sre.delegate = self;
    }
    //启动LocationService
    [sre startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [sre stopUserLocationService];
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    [self ShowAlertWithMessage:@"定位失败"];
}

-(void) skipLinLiQuan{
    if ([Stockpile sharedStockpile].isLogin==NO) {
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                [self login];
            }
        }];
        return;
    }
    ForumViewController* gongGaoQiangViewController=[[ForumViewController alloc]init];
    gongGaoQiangViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:gongGaoQiangViewController animated:YES];
}

-(void)skipWindowShopping{
    WindowShoppingViewController * shangjiaVC = [[WindowShoppingViewController alloc]init];
    shangjiaVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:shangjiaVC animated:YES];
}

-(void)usefulTelephoneNumbers{
    LifeServiceViewController * shangjiaVC = [[LifeServiceViewController alloc]init];
    shangjiaVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:shangjiaVC animated:YES];
}

-(void)functionClick:(UIControl *)sender{
    NSDictionary* dic=functionArray[sender.tag-FUNCTION_TAG];
    if([dic[@"OpenKey"] isEqual:@"Neighbourhood"]){
       [self skipLinLiQuan];
    }else if([dic[@"OpenKey"] isEqual:@"Shopping"]){
        [self skipWindowShopping];
    }else if([dic[@"OpenKey"] isEqual:@"CommonPhone"]){
        [self usefulTelephoneNumbers];
    }
}

-(void)imageClick:(UIControl *)sender{
    NSDictionary* dic=imageArray[sender.tag-IMAGE_TAG];
//    if([dic[@"OpenKey"] isEqual:@"Neighbourhood"]){
//        [self skipLinLiQuan];
//    }else if([dic[@"OpenKey"] isEqual:@"Shopping"]){
//        [self skipWindowShopping];
//    }else if([dic[@"OpenKey"] isEqual:@"CommonPhone"]){
//        [self usefulTelephoneNumbers];
//    }
}

-(void)newHeaderView{
     if([AppUtil arrayIsEmpty:imageArray]){
         headerView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.frame.size.width,100*self.scale)];
     }else{
         headerView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.frame.size.width,160*self.scale)];
     }
    _dataSourceImg=@[@"forum",@"shopping",@"phone"];//,@"borrow"
    _dataSourceName=@[@"邻里圈",@"逛逛街",@"常用电话"];//,@"爱心借"
    NSUInteger count=0;
    if([_dataSourceImg count]%4==0)
        count=[_dataSourceImg count]/4;
    else
        count=[_dataSourceImg count]/4+1;
    functionSv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 70*self.scale)];
    functionSv.delegate = self;
    functionSv.showsHorizontalScrollIndicator = FALSE;
    functionSv.pagingEnabled = true;
    functionSv.contentSize=CGSizeMake(functionSv.width*count, functionSv.height);
    functionSv.scrollEnabled=YES;
    for (int i=0;i<[functionArray count];i++) {
        NSDictionary* functionDic=functionArray[i];
        UIControl *itemCt=[[UIControl alloc] initWithFrame:CGRectMake(self.view.width/4*i, 0, self.view.width/4, functionSv.height)];
        UIImageView *coverIv=[[UIImageView alloc] initWithFrame:CGRectMake(0+(itemCt.width-23*self.scale)/2, 15*self.scale, 23*self.scale, 20*self.scale)];
        //[coverIv setImage:[UIImage imageNamed:_dataSourceImg[i]]];
        [coverIv setImageWithURL:[NSURL URLWithString:functionDic[@"Icon"]] placeholderImage:[UIImage imageNamed:@"not_1"]];
        UILabel *nameLb=[[UILabel alloc]initWithFrame:CGRectMake(0, coverIv.bottom+10*self.scale,itemCt.width,15*self.scale)];
        nameLb.textColor=[UIColor blackColor];
        nameLb.textAlignment = UIViewContentModeScaleAspectFit;
        nameLb.font=SmallFont(self.scale*0.8);;//名称
        nameLb.text=functionDic[@"ModuleName"];
        [itemCt addSubview:coverIv];
        [itemCt addSubview:nameLb];
        itemCt.tag=FUNCTION_TAG+i;
        [itemCt addTarget:self action:@selector(functionClick:) forControlEvents:UIControlEventTouchUpInside];
        [functionSv addSubview:itemCt];
    }
    [headerView addSubview:functionSv];
    functionPg=[[WEIPageControl alloc]initWithFrame:CGRectMake(0, functionSv.bottom-5*self.scale, self.view.width, 5*self.scale)];
    functionPg.isSquare = true;//设置为方型点
    functionPg.numberOfPages=count;//总页数
    //pg.currentWidthMultiple = 2.5;//当前点的宽度为其他点的3倍
    functionPg.currentColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.608 alpha:1.00];
    functionPg.otherColor = [UIColor colorWithRed:0.847 green:0.847 blue:0.847 alpha:1.00];
    functionPg.pointSize = CGSizeMake(14, 2);//方点的size
    [headerView addSubview:functionPg];
    if([AppUtil arrayIsEmpty:imageArray]){
        imageSv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, functionSv.bottom, self.view.width, 0*self.scale)];
    }else{
        imageSv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, functionSv.bottom, self.view.width, 60*self.scale)];
        imageSv.delegate = self;
        imageSv.showsHorizontalScrollIndicator = FALSE;
        imageSv.pagingEnabled = true;
        imageSv.contentSize=CGSizeMake(imageSv.width*imageArray.count, imageSv.height);
        imageSv.scrollEnabled=YES;
        for (int i=0;i<[imageArray count];i++) {
            NSDictionary* imgDic=imageArray[i];
            UIControl *itemCt=[[UIControl alloc] initWithFrame:CGRectMake(self.view.width*i, 0, self.view.width, imageSv.height)];
            UIImageView *coverIv=[[UIImageView alloc] initWithFrame:CGRectMake(10*self.scale, 0, self.view.width-20*self.scale, itemCt.height)];
            [coverIv setImageWithURL:[NSURL URLWithString:imgDic[@"img"]] placeholderImage:[UIImage imageNamed:@"za"]];
            coverIv.layer.cornerRadius=5;
            coverIv.layer.masksToBounds=YES;
            [itemCt addSubview:coverIv];
            itemCt.tag=IMAGE_TAG+i;
            [itemCt addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
            [imageSv addSubview:itemCt];
        }
        [headerView addSubview:imageSv];
        imagePg=[[WEIPageControl alloc]initWithFrame:CGRectMake(0, imageSv.bottom-5*self.scale, self.view.width, 5*self.scale)];
        imagePg.isSquare = true;//设置为方型点
        imagePg.numberOfPages=imageArray.count;//总页数
        //pg.currentWidthMultiple = 2.5;//当前点的宽度为其他点的3倍
        imagePg.currentColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.608 alpha:1.00];
        imagePg.otherColor = [UIColor colorWithRed:0.847 green:0.847 blue:0.847 alpha:1.00];
        imagePg.pointSize = CGSizeMake(14, 2);//方点的size
        [headerView addSubview:imagePg];
    }
    UIImageView* comMarketIv=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale,imageSv.bottom+5*self.scale, 60*self.scale, 20*self.scale)];
    [comMarketIv setImage:[UIImage imageNamed:@"community_supermarket"]];
    [headerView addSubview:comMarketIv];
    addressLb=[[UILabel alloc]initWithFrame:CGRectMake(comMarketIv.right+10*self.scale, comMarketIv.top, self.view.width-comMarketIv.right-40*self.scale, 20*self.scale)];
    addressLb.font=[UIFont systemFontOfSize:11*self.scale];
    addressLb.textColor=[UIColor colorWithRed:0.325 green:0.325 blue:0.325 alpha:1.00];
    [headerView addSubview:addressLb];
    followMeBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-30*self.scale,comMarketIv.top, 20*self.scale, 20*self.scale)];
    [followMeBtn addTarget:self action:@selector(realNavi:) forControlEvents:UIControlEventTouchUpInside];
    followMeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [followMeBtn setImage:[UIImage imageNamed:@"follow_me"] forState:UIControlStateNormal];
    followMeBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    //[followMeBtn setTitle:@"跟着我走" forState:UIControlStateNormal];
    //followMeBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 4, 0, 0);
    //followMeBtn.titleLabel.font=[UIFont systemFontOfSize:11*self.scale];
    //[followMeBtn setTitleColor:[UIColor colorWithRed:0.208 green:0.208 blue:0.208 alpha:1.00] forState:UIControlStateNormal];
    [headerView addSubview: followMeBtn];
    UIImageView *bottomLine=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, comMarketIv.bottom+10*self.scale-.5, self.view.width-20*self.scale, 0.5)];
    bottomLine.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [headerView addSubview:bottomLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)talk{
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
    // self.hidesBottomBarWhenPushed=YES;
    RCDChatListViewController *rong = [[RCDChatListViewController alloc]init];
    rong.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:rong animated:YES];
    // self.hidesBottomBarWhenPushed=NO;
}

#pragma mark -----返回按钮
-(void)returnVi{
    self.NavImg.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self getStartHeight]+44+44);
    self.gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self getStartHeight]+44+44);
    [self.NavImg.layer insertSublayer:self.gradientLayer atIndex:0];
    //17年4.28新添加的消息按钮
    UIButton *talkImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [talkImg setImage:[UIImage imageNamed:@"msg_black"] forState:UIControlStateNormal];
    talkImg.frame=CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top+2*self.scale, self.TitleLabel.height,self.TitleLabel.height);
    [talkImg addTarget:self action:@selector(talk) forControlEvents:UIControlEventTouchUpInside];
    talkImg.tag = MESSAGE_TAG;
    //talkImg.backgroundColor = [UIColor blackColor];
    //talkImg.alpha = 0;
    [self.NavImg  addSubview:talkImg];
    UIImageView *souImg=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, self.TitleLabel.top+8*self.scale, 12*self.scale, 16*self.scale)];
    souImg.image=[UIImage imageNamed:@"location_black"];
   // souImg.alpha = 0.5;
    [self.NavImg addSubview:souImg];
    community = [[UILabel alloc] initWithFrame:CGRectMake(souImg.right+5*self.scale, souImg.top+2*self.scale, self.view.width-souImg.width-talkImg.width-30*self.scale, 15*self.scale)];
    //community.textAlignment=NSTextAlignmentCenter;
    community.textColor = [UIColor blackColor];
    community.userInteractionEnabled=YES;
    community.font=SmallFont(self.scale*1.1);
    //community.text=@"九鼎世家";
    UITapGestureRecognizer *addressTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dizhiBtnClick:)];
    [community addGestureRecognizer:addressTapGesture];
    [self.NavImg addSubview:community];
    UIView *souVi=[[UIView alloc]initWithFrame:CGRectMake(10*self.scale,[self getStartHeight]+44, self.view.width-20*self.scale,34)];
    //    souVi.image=[UIImage imageNamed:@"so_2"];
    souVi.userInteractionEnabled=YES;
    souVi.layer.borderColor = [UIColor whiteColor].CGColor;
    souVi.layer.borderWidth = 0.3;
    souVi.backgroundColor =[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    souVi.clipsToBounds = YES;
    souVi.tag = 12345;
    souVi.layer.cornerRadius = 3;
    [self.NavImg addSubview:souVi];
    souTf=[[UIButton alloc]initWithFrame:CGRectMake(10, 0, souVi.width-20, souVi.height)];
    [souTf setTitle:@" 搜索便利店商品" forState:UIControlStateNormal];
    [souTf setTitleColor:[UIColor colorWithHexString:@"#6A6A6A"] forState:UIControlStateNormal];
    souTf.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [souTf setImage:[UIImage imageNamed:@"search_home_ico"] forState:UIControlStateNormal];
    [souTf.imageView setContentMode:UIViewContentModeCenter];
    [souTf addTarget:self action:@selector(skipToSearchView) forControlEvents:UIControlEventTouchUpInside];
    [souVi addSubview:souTf];
    UILabel *voiceVi=[[UILabel alloc]initWithFrame:CGRectMake(souVi.width-70*self.scale,5, 65*self.scale,34-10)];
    //    souVi.image=[UIImage imageNamed:@"so_2"];
    voiceVi.userInteractionEnabled=YES;
    voiceVi.backgroundColor =[UIColor colorWithRed:0.333 green:0.553 blue:1.000 alpha:1.00];
    voiceVi.clipsToBounds = YES;
    voiceVi.tag = 12345;
    voiceVi.textAlignment = NSTextAlignmentCenter;
    voiceVi.layer.cornerRadius = 3;
    UITapGestureRecognizer *voiceTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(voiceOrder:)];
    [voiceVi addGestureRecognizer:voiceTapGesture];
    [souVi addSubview:voiceVi];
    NSMutableAttributedString *attri1 =  [[NSMutableAttributedString alloc] initWithString:@" 语音下单" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f],NSFontAttributeName : [UIFont systemFontOfSize:13.0]}];
    // 2.添加表情图片
    NSTextAttachment *attch1 = [[NSTextAttachment alloc] init];
    // 表情图片
    attch1.image = [UIImage imageNamed:@"ic_voice"];
    // 设置图片大小
    attch1.bounds = CGRectMake(0, 0, 10, 10);
    // 创建带有图片的富文本
    NSAttributedString *string1 = [NSAttributedString attributedStringWithAttachment:attch1];
    [attri1 insertAttributedString:string1 atIndex:0];// 插入某个位置
    voiceVi.attributedText = attri1;
 }

-(void)dismissKeyBoard{
    [souTf resignFirstResponder];
}

-(void) setAddress{
    NSString* comName=[[NSUserDefaults standardUserDefaults]objectForKey:@"commname"] ;
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:comName];
    // 2.添加表情图片
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"arrows_down"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, 0, 10, 6.5);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:[comName length]];// 插入某个位置
    community.attributedText = attri;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden=NO;
    [self gouWuCheShuZi];
//    //    self.navigationController.navigationBarHidden=YES;
//    [RCIM sharedRCIM].disableMessageAlertSound=NO;
//    [self ReshMessage];
//    [RCIM sharedRCIM].receiveMessageDelegate=self;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    if(self.appdelegate.isRefresh){
//        self.appdelegate.isRefresh=false;
//        [self refreshPage];
//    }
    [self setAddress];
    if ([Stockpile sharedStockpile].isLogin) {
        [self requestShopingCart:true];
    }else{
        [self loadCommunityShop];
    }
}

-(void) setHeaderInfo{
    addressLb.text=shopData[@"address"];
    //priceLb.text=shopData[@"notice"];
}

-(void) loadCommunityShop{
    NSString *commid =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"commid"]];
    NSString *shopid =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"]];
    NSString* comName=[[NSUserDefaults standardUserDefaults]objectForKey:@"commname"] ;
    NSLog(@"shopid==%@==%@",shopid,comName);
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    NSDictionary *dic = @{@"cid":commid,@"shopid":shopid};
    [analy getCommunityShop:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            [goodsArray removeAllObjects];
            [functionArray removeAllObjects];
            [imageArray removeAllObjects];
            shopData=models[@"shopinfo"];
            self.appdelegate.shopInfoDic=models[@"shopinfo"];
            NSArray* funArr=models[@"module"];
            [functionArray addObjectsFromArray:funArr];
            NSArray* imgArr=models[@"advertlist"];
            [imageArray addObjectsFromArray:imgArr];
            [self newHeaderView];
            [self setHeaderInfo];
            NSLog(@"shopData==%@==%@",dic,models);
            NSArray* arr=models[@"prolist"];
            [goodsArray addObjectsFromArray:arr];
            goodsTv.tableHeaderView=headerView;
//            for(NSDictionary* obj in arr){
//                Goods* goods=[[Goods alloc]init];
//                goods.gid=[obj objectForKey:@"id"];
//                goods.shopid=[obj objectForKey:@"shopid"];
//                goods.categoryid=[obj objectForKey:@"categoryid"];
//                goods.prodname=[obj objectForKey:@"prodname"];
//                goods.price=[obj objectForKey:@"price"];
//                goods.unit=[obj objectForKey:@"unit"];
//                goods.des=[obj objectForKey:@"description"];
//                goods.inventory=[obj objectForKey:@"inventory"];
//                goods.salecount=[obj objectForKey:@"salecount"];
//                NSString *string = [NSString stringWithFormat:@"%@",[obj objectForKey:@"imgs"][0]];
//                NSArray *imgArr = [string componentsSeparatedByString:@"|"];
//                goods.imgs=[imgArr mutableCopy];
//                goods.activityid=[obj objectForKey:@"activityid"];
//                goods.isjoinact=[obj objectForKey:@"isjoinact"];
//                goods.actmark=[obj objectForKey:@"actmark"];
//                goods.actmaxbuy=[obj objectForKey:@"actmaxbuy"];
//                goods.actmaxstock=[obj objectForKey:@"actmaxstock"];
//                goods.actmaxdaystock=[obj objectForKey:@"actmaxdaystock"];
//                goods.acticon=[obj objectForKey:@"acticon"];
//                [goodsArray addObject:goods];
//            }
             [goodsTv reloadData];
        }
    }];
}

- (void)gouWuCheShuZi{
    UITabBarItem * item=[self.appdelegate.tabBarController.tabBar.items objectAtIndex:2];
    NSNumber* num=[[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
    NSString * value = [NSString stringWithFormat:@"%@",num];
    if (num==nil||[value isEqualToString:@"0"]){
        [item setBadgeValue:nil];
    }else{
        [item setBadgeValue:value];
    }
}

-(void)loadShopDetail{
//    [self.activityVC startAnimate];
//    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
//    NSDictionary *dic=@{@"shop_id":_gongGaoDic[@"shop_id"]};
//    if ([Stockpile sharedStockpile].isLogin) {
//        dic=@{@"shop_id":_gongGaoDic[@"shop_id"],@"user_id":[self getuserid]};
//    }
//    NSLog(@"%@",dic);
//    [analyze queryShopDetailwithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
//        if ([code isEqualToString:@"0"]) {
//            shopData=models;
//        }
//    }];
}

//语音下单
- (void)voiceOrder:(UITapGestureRecognizer*) tap{
    //    self.hidesBottomBarWhenPushed = YES;
    //    BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
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
    if(shopData==nil)
        return;
    self.hidesBottomBarWhenPushed = YES;
    IMViewController *_conversationVC = [[IMViewController alloc]init];
    _conversationVC.conversationType = ConversationType_PRIVATE;
    _conversationVC.targetId = [NSString stringWithFormat:@"%@",shopData[@"shop_user_id"]];
    NSLog(@"imtargetid==%@",shopData[@"shop_user_id"]);
    // _conversationVC.userName = @"123456";
    _conversationVC.title = shopData[@"shop_name"];
    //_conversationVC.conversation = model;
    [self.navigationController pushViewController:_conversationVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 按钮事件//地址按钮点击事件
- (void)dizhiBtnClick:(UITapGestureRecognizer*) tap{
    NSLog(@"dizhiBtnClick");
    //self.hidesBottomBarWhenPushed = YES;
    ChoosePlotController* choosePlot=[[ChoosePlotController alloc] init];
    choosePlot.isRoot=false;
    choosePlot.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:choosePlot animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*self.scale;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* prodArr=goodsArray[section][@"ProdDetailList"];
    return prodArr.count;
}

#pragma mark -数据源方法
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return goodsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsTableViewCell *cell=[GoodsTableViewCell cellWithTableView:tableView];
    NSArray* prodArr=goodsArray[indexPath.section][@"ProdDetailList"];
    NSDictionary* goods=prodArr[indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@",[goods objectForKey:@"imgs"][0]];
    NSArray *imgArr = [string componentsSeparatedByString:@"|"];
    [cell.headImg setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:[UIImage imageNamed:@"za"]];
    NSInteger activityid=[[NSString stringWithFormat:@"%@",goods[@"actinfo"][@"activityid"]] integerValue];
    if(activityid>0){
        cell.activityImg.hidden=NO;
        NSString *activityImgUrl=[NSString stringWithFormat:@"%@",goods[@"actinfo"][@"acticon"]];
        [cell.activityImg setImageWithURL:[NSURL URLWithString:activityImgUrl] placeholderImage:[UIImage imageNamed:@""]];
    }else{
        cell.activityImg.hidden=YES;
    }
    cell.titleLa.text=goods[@"prodname"];
    if([AppUtil isBlank:goods[@"description"]])
        cell.desLb.text=goods[@"prodname"];
    else
       cell.desLb.text=goods[@"description"];
    //NSLog(@"prodname==%@",goods[@"prodname"]);
    CGFloat pri=[[goods objectForKey:@"price"] floatValue];
    NSString * priceString = [NSString stringWithFormat:@"￥%.1f/%@",pri,goods[@"unit"]];
    NSString * firstString = [NSString stringWithFormat:@"%.1f",pri];
    NSMutableAttributedString * priceAttributeString = [[NSMutableAttributedString alloc]initWithString:priceString];
    [priceAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*self.scale] range:NSMakeRange(1, firstString.length)];
    cell.priceLa.attributedText = priceAttributeString;
    NSString* pid=[NSString stringWithFormat:@"%@",goods[@"id"]];
    int index=[self.appdelegate.shopDictionary[@([pid intValue])] intValue];
    if (index>0&&[Stockpile sharedStockpile].isLogin==YES) {
        cell.subBtn.hidden=NO;
        cell.numLb.hidden=NO;
        cell.numLb.text=self.appdelegate.shopDictionary[@([pid intValue])];
    }else{
        cell.subBtn.hidden=YES;
        cell.numLb.hidden=YES;
    }
    cell.addBt.tag=ADD_CART_TAG+(indexPath.section*SECTION_TAG)+indexPath.row;
    cell.numLb.tag=CART_NUM_TAG+(indexPath.section*SECTION_TAG)+indexPath.row;
    cell.subBtn.tag=SUB_CART_TAG+(indexPath.section*SECTION_TAG)+indexPath.row;
    [cell.addBt addTarget:self action:@selector(changeShopingCartNum:) forControlEvents:UIControlEventTouchUpInside];
    [cell.subBtn addTarget:self action:@selector(changeShopingCartNum:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if((goodsArray.count-indexPath.row)==1){
//        cell.lineView.hidden=YES;
//    }else{
//        cell.lineView.hidden=NO;
//    }
    cell.lineView.hidden=YES;
    return cell;
}

/*请求购物车*/
-(void) requestShopingCart:(BOOL) isRefresh{
    [self.appdelegate.shopDictionary removeAllObjects];
    NSString* shop_id= [[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"];
    NSArray* arr= [[DataBase sharedDataBase] getAllFromCart:shop_id];
    NSLog(@"requestShopingCart==%@",arr);
    if (arr.count>0) {
        for (int i = 0; i < arr.count; i ++) {
            NSArray * Prod_infoArr = arr[i][@"prolist"];
            for (int j = 0; j < Prod_infoArr.count; j ++) {
                [self.appdelegate.shopDictionary setObject:Prod_infoArr[j][@"pro_allnum"] forKey:Prod_infoArr[j][@"pro_id"]];
            }
        }
        NSInteger totalNumber = 0;
        //NSLog(@"%@",arr);
        for (NSDictionary * dic in arr)
        {
            NSInteger number = 0;
            for (NSDictionary * prod_infoDIc in dic[@"prolist"])
            {
                number = number + [prod_infoDIc[@"pro_allnum"] integerValue];
            }
            totalNumber = totalNumber + number;
        }
        //NSLog(@"totalNumber::%ld",totalNumber);
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)totalNumber] forKey:@"GouWuCheShuLiang"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self gouWuCheShuZi];
        //NSLog(@"self.appdelegate.shopDictionary==%@",self.appdelegate.shopDictionary);
        if(isRefresh)
            [self loadCommunityShop];
    }else{
        //[self.appdelegate.shopDictionary removeAllObjects];
        if(isRefresh)
            [self loadCommunityShop];
    }
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
    //商店营业情况，*****需要处理
    // NSLog(@"param=-=-=%@==%@==%@",self.param,self.prod_id,self.appdelegate.shopDictionary);
    NSInteger isOffLine=[[NSString stringWithFormat:@"%@",shopData[@"is_off_online"]] integerValue];
    if(isOffLine==1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"临时歇业中"
                                                            message:@"暂停营业。很快回来^_^!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }else if(![AppUtil isDoBusiness:shopData]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"歇业中"
                                                            message:[NSString stringWithFormat:@"%@",shopData[@"onlinemark"]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSInteger tag=btn.tag;
    NSInteger section=-1;//商品项，为了获取商品id
    NSInteger index=-1;//商品项，为了获取商品id
    UIButton* subBtn=nil;
    UILabel* numLb=nil;
    BOOL isAdd=true;
    if (tag<CART_NUM_TAG) {
        section=(tag-ADD_CART_TAG)/SECTION_TAG;
        index=(tag-ADD_CART_TAG)%SECTION_TAG;//tag-100000;
        numLb=(UILabel *)[self.view viewWithTag:CART_NUM_TAG+(SECTION_TAG*section)+index];
    }else{
        section=(tag-SUB_CART_TAG)/SECTION_TAG;
        index=(tag-SUB_CART_TAG)%SECTION_TAG;//tag-100000;
        numLb=(UILabel *)[self.view viewWithTag:CART_NUM_TAG+(SECTION_TAG*section)+index];
        isAdd=false;
    }
    subBtn=(UIButton *)[self.view viewWithTag:SUB_CART_TAG+(SECTION_TAG*section)+index];
    
    NSArray* prodArr=goodsArray[section][@"ProdDetailList"];
    NSDictionary* goods=prodArr[index];
    
    //NSDictionary* goods=goodsArray[index];
    NSMutableDictionary* par=[goods mutableCopy];
    [par setObject:goods[@"shopid"] forKey:@"shop_id"];
    [par setObject:shopData[@"shopname"] forKey:@"shop_name"];
    [par setObject:shopData[@"logo"] forKey:@"shop_logo"];
    [par setObject:shopData[@"free_delivery_amount"] forKey:@"free_delivery_amount"];
    [par setObject:shopData[@"delivery_fee"] forKey:@"delivery_fee"];
    [par setObject:goods[@"id"] forKey:@"prod_id"];
    [par setObject:goods[@"prodname"] forKey:@"prod_name"];
    NSString *string = [NSString stringWithFormat:@"%@",[goods objectForKey:@"imgs"][0]];
    NSArray *imgArr = [string componentsSeparatedByString:@"|"];
    [par setObject:imgArr[0] forKey:@"img1"];
    [par setObject:goods[@"originPrice"] forKey:@"origin_price"];
    //[par setObject:goods[@"price"]forKey:@"price"];
    //[par setObject:goods[@"unit"] forKey:@"unit"];
    NSInteger num=[self.appdelegate.shopDictionary[@([goods[@"id"]  intValue])] intValue];
    NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
    int cartNum=[value intValue];
    if(isAdd){
        num++;
        NSLog(@"param=-=-1111=%d==%@",num,self.appdelegate.shopDictionary);
        NSInteger activityid=[[NSString stringWithFormat:@"%@",goods[@"activityid"]] integerValue];
        if(activityid>0){
            NSInteger actmaxbuy=[[NSString stringWithFormat:@"%@",goods[@"actmaxbuy"]] integerValue];
            if(actmaxbuy>0&&num>actmaxbuy){
                [AppUtil showToast:self.view withContent:[NSString stringWithFormat:@"活动商品限购%ld份，超出%ld份恢复原价",actmaxbuy,actmaxbuy]];
            }
        }
        [[DataBase sharedDataBase] updateCart:par withType:1];
        [self.appdelegate.shopDictionary setObject:[NSString stringWithFormat:@"%d",num] forKey:@([goods[@"id"] intValue])];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cartNum+1] forKey:@"GouWuCheShuLiang"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        num--;
        [[DataBase sharedDataBase] updateCart:par withType:0];
        [self.appdelegate.shopDictionary setObject:[NSString stringWithFormat:@"%d",num] forKey:@([goods[@"id"] intValue])];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cartNum-1] forKey:@"GouWuCheShuLiang"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSLog(@"param==%@",par);

    numLb.text=[NSString stringWithFormat:@"%d",num];
    if(num<=0){
        numLb.hidden=YES;
        subBtn.hidden=YES;
    }else{
        numLb.hidden=NO;
        subBtn.hidden=NO;
    }
    [self gouWuCheShuZi];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.hidesBottomBarWhenPushed=YES;
    ShopInfoViewController *buess = [ShopInfoViewController new];
    //NSDictionary* param=goodsArray[indexPath.row];
    
    NSArray* prodArr=goodsArray[indexPath.section][@"ProdDetailList"];
    NSDictionary* param=prodArr[indexPath.row];
    
    buess.isgo=YES;
    // buess.issleep=issleep;
    buess.yes=NO;
    buess.price =param[@"originPrice"];
    buess.shop_name=param[@"shopname"];
    buess.orshoucang=YES;
    //buess.shop_user_id=param[@"shop_user_id"];
    buess.shop_id = param[@"shopid"];
    buess.prod_id = param[@"id"];
    //buess.xiaoliang =param[@"sales"];
    //buess.shoucang = param[@"collect_time"];
    //buess.gongGao = param[@"notice"];
    //buess.tel=[NSString stringWithFormat:@"%@",param[@"hotline"]];
    NSLog(@"ShopInfoViewController==%@==%@==%@",param,param[@"id"],self.appdelegate.shopDictionary);
    buess.param=param;
    [self.navigationController pushViewController:buess animated:YES];
      self.hidesBottomBarWhenPushed=NO;
}

//真实GPS导航
- (void)realNavi:(UIButton*)button{
    BusinessLocationViewController* locationVc=[[BusinessLocationViewController alloc]init];
    locationVc.infoDic=shopData;
    locationVc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:locationVc animated:YES];
//    if (![self checkServicesInited]) return;
//    [self dingwei];
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}

-(void)skipToSearchView{
    SouViewController *vi=[SouViewController new];
    vi.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vi animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSDictionary* groupDic=goodsArray[section];
    NSString* isShowAdImg=[NSString stringWithFormat:@"%@",groupDic[@"IsShowAdImg"]];
    if(![isShowAdImg isEqualToString:@"1"]){
        return 30*self.scale;
    }
    CGFloat w=[[NSString stringWithFormat:@"%@",groupDic[@"w"]] floatValue];
    CGFloat h=[[NSString stringWithFormat:@"%@",groupDic[@"w"]] floatValue];
    if(w==0.0||h==0.0){
        w=750;
        h=160;
    }
    return 30*self.scale+self.view.width/w*h;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary* groupDic=goodsArray[section];
    NSString* isShowAdImg=[NSString stringWithFormat:@"%@",groupDic[@"IsShowAdImg"]];
    CGFloat w=[[NSString stringWithFormat:@"%@",groupDic[@"w"]] floatValue];
    CGFloat h=[[NSString stringWithFormat:@"%@",groupDic[@"w"]] floatValue];
    if(w==0.0||h==0.0){
        w=750;
        h=160;
    }
    CGFloat height=30*self.scale;
    if([isShowAdImg isEqualToString:@"1"]){
        height+=self.view.width/w*h;
    }
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, height)];
    UIImageView* flag = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 20*self.scale, 20*self.scale)];
    [flag setImageWithURL:[NSURL URLWithString:goodsArray[section][@"Icon"]] placeholderImage:[UIImage imageNamed:@"not_1"]];
    [headerView addSubview:flag];
    UILabel *specialPriceLb=[[UILabel alloc]initWithFrame:CGRectMake(flag.right+5*self.scale, flag.top, 50*self.scale, 20*self.scale)];
    specialPriceLb.text=goodsArray[section][@"GroupName"];
    specialPriceLb.font=[UIFont boldSystemFontOfSize:12*self.scale];
    specialPriceLb.textColor=[UIColor colorWithRed:0.255 green:0.255 blue:0.255 alpha:1.00];
    [headerView addSubview:specialPriceLb];
    
    UILabel *priceLb=[[UILabel alloc]initWithFrame:CGRectMake(specialPriceLb.right+5*self.scale, flag.top, self.view.width-specialPriceLb.right-15*self.scale, 20*self.scale)];
    priceLb.font=[UIFont systemFontOfSize:12*self.scale];
    priceLb.textColor=[UIColor colorWithRed:0.255 green:0.255 blue:0.255 alpha:1.00];
    priceLb.text=goodsArray[section][@"MoreText"];
    priceLb.textAlignment=NSTextAlignmentRight;
    [headerView addSubview:priceLb];
    if([isShowAdImg isEqualToString:@"1"]){
        UIImageView* adIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30*self.scale, self.view.width, self.view.width/w*h)];
        [adIv setImageWithURL:[NSURL URLWithString:goodsArray[section][@"AdImg"]] placeholderImage:[UIImage imageNamed:@"not_1"]];
        [headerView addSubview:adIv];
    }
    return headerView;
}

@end
