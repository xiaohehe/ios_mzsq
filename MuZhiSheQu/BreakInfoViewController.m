//
//  BreakInfoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BreakInfoViewController.h"
#import "BreakInfoTableViewCell.h"
#import "ShopInfoViewController.h"
#import "BusinessInfoViewController.h"
#import "GouWuCheViewController.h"
#import "UmengCollection.h"
#import "SouViewController.h"
#import "DataBase.h"
#import "AppUtil.h"

@interface BreakInfoViewController ()<BreakInfoCellDelegate,shopInfoDelegate>
@property(nonatomic,strong)UITableView *leftTable,*rightTable;
@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,strong)UIImageView *bottomR,*bottomL;
@property(nonatomic,strong)UIView *botROne,*botRTwo,*bigTopVi;
@property(nonatomic,strong)NSMutableArray *arr,*list;
@property(nonatomic,assign)NSInteger index,number;;
@property(nonatomic,strong)NSMutableArray *data,*rightData;
@property(nonatomic,strong)NSMutableDictionary *GoodsList,*carData;
@property(nonatomic,strong)reshshoucang block;
@property(nonatomic,assign)BOOL shoucang;
@property(nonatomic,strong)NSString * carNum;
@property(nonatomic,strong)NSString * carPrice;
@property(nonatomic,assign)BOOL orshou;
@property(nonatomic,strong)UILabel *tishiLa;
@property(nonatomic,strong)NSDictionary * remindDic;
@property (nonatomic,strong)UIButton * shouCangbtn;
@property (nonatomic,strong)UILabel * peiSongLab;
@property(nonatomic,assign)NSInteger pindex;
@property(nonatomic,strong) NSDictionary* shopInfo;
@end

@implementation BreakInfoViewController

-(void)reshshocuang:(reshshoucang)block{
    _block=block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // NSLog(@"break_type====%@",self.ID);
    _shoucang=NO;
    _orshou=NO;
    _data=[NSMutableArray new];
    _rightData=[NSMutableArray new];
    _GoodsList=[[NSMutableDictionary alloc]init];
    _dic = [NSMutableDictionary new];
    _remindDic = [NSDictionary new];
    _numberz=0;
    _carNum = @"0";
    _gonggao = @"";
    //    if (_isPush)
    //    {
    NSDictionary *dic = @{@"shop_id": self.shop_id,
                          @"user_id":[Stockpile sharedStockpile].ID};
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    [analyze getRetailShopClassPushwithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"%@",models);
            NSString *ID = [models objectForKey:@"id"];
            if ([models[@"is_open_chat"]isEqualToString:@"2"]) {
                self.isopen=NO;
            }else{
                self.isopen=YES;
            }
            self.tel=[NSString stringWithFormat:@"%@",[models objectForKey:@"hotline"]];
            self.ID=ID;
            self.titlete=[models objectForKey:@"shop_name"];
            self.shopImg = [models objectForKey:@"logo"];
            self.gonggao = [models objectForKey:@"notice"];
            self.yunfei =[models objectForKey:@"delivery_fee"];
            self.manduoshaofree=[models objectForKey:@"free_delivery_amount"];
            self.shop_user_id=[models objectForKey:@"shop_user_id"];
            self.issleep=[self getTimeWith:models];
            if (_isPush)
                self.TitleLabel.text = self.titlete;
        }
    }];
    //}
    [self remind];
    [self leftScroll];
    [self RightTable];
    [self bottomVi];
    [self shangJiaXiangQing];
    [self returnVi];
    [self ReshData];
    [self isDoBusiness];
    _arr = [NSMutableArray array];
//    if (_issleep) {
//        [self ShowAlertWithMessage:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"];
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [self ReshBotView];
    [self shangJiaXiangQing];
    [_rightTable reloadData];
    [self remind];
    //self.navigationController.navigationBarHidden=YES;
    if ([Stockpile sharedStockpile].isLogin) {
        AnalyzeObject *analyze = [AnalyzeObject new];
        NSDictionary *d = [NSDictionary new];
        if (_isPush)
        {
            d = @{@"user_id":[self getuserid],@"collect_id":self.shop_id,@"collect_type":@"2"};
        }else{
            d = @{@"user_id":[self getuserid],@"collect_id":self.ID,@"collect_type":@"2"};
        }
        [analyze isCollectWithDic:d Block:^(id models, NSString *code, NSString *msg) {
            if ([[NSString stringWithFormat:@"%@",models] isEqualToString:@"2"]) {

                _shoucang=YES;
                _orshou=YES;

                
//                UIButton *vi = (UIButton *)[self.view viewWithTag:909];
//                UILabel *la = (UILabel *)[self.view viewWithTag:908];
                    if (_orshou) {
                        _shouCangbtn.selected=YES;
//                        la.text=@"取消收藏";
//                        la.textColor=blueTextColor;
                    }
            }
            
        }];
    }
//    UIButton *btn = (UIButton *)[self.view viewWithTag:907];
//    
//    NSArray *ar = _carData[@"cart_info"];
//    
//    if (ar.count <=0) {
//        [btn setBackgroundColor:grayTextColor];
//        btn.userInteractionEnabled=NO;
//        
//    }else{
//        [btn setBackgroundColor:[UIColor redColor]];
//        btn.userInteractionEnabled=YES;
//        
//    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

-(void) isDoBusiness{
    NSDictionary *dic = [NSDictionary new];
    if (_isPush) {
        dic=@{@"ShopID":self.shop_id};
    }else{
        dic = @{@"ShopID":self.ID};
    }
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle getShopOnlineTime:dic Block:^(id models, NSString *code, NSString *msg) {
        NSLog(@"getShopOnlineTime==%@",models);
        self.shopInfo=models;
        NSInteger isOffLine=[[NSString stringWithFormat:@"%@",self.shopInfo[@"is_off_online"]] integerValue];
        if(isOffLine==1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"临时歇业中"
                                                                message:@"暂停营业。很快回来^_^!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }else if(![AppUtil isDoBusiness:self.shopInfo]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"歇业中"
                                                                message:[NSString stringWithFormat:@"%@",self.shopInfo[@"onlinemark"]]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }

    }];
}

#pragma mark - 数据块
-(void)ReshData
{    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    _index++;
    NSDictionary *dic = [NSDictionary new];
    if (_isPush) {
        dic=@{@"shop_id":self.shop_id};
    }else{
        dic = @{@"shop_id":self.ID};
    }
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    [analyze getRetailShopClasswithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            _data=models;
            NSLog(@"getRetailShopClasswithDic==%@",models);
            if(_data==nil||_data.count==0){
                return ;
            }
            [self leftScroll];
            NSDictionary *dic2 = [NSDictionary new];
            if (_isPush) {
                dic2 = @{@"shop_id":self.shop_id,@"class_id":[_data[0] objectForKey:@"id"]};
            }else{
                NSLog(@"shop_id==class_id==%@",[_data[0] objectForKey:@"id"]);
                dic2 = @{@"shop_id":self.ID,@"class_id":[_data[0] objectForKey:@"id"]};
            }
            [analyze getProdListByClasswithDic:dic2 WithBlock:^(id models, NSString *code, NSString *msg) {
                NSLog(@"getProdListByClasswithDic==%@",models);
                if ([code isEqualToString:@"0"]) {
                    if ([(NSArray *)models count]>0) {
                        self.yunfei=[NSString stringWithFormat:@"%@",models[0][@"delivery_fee"]];
                        self.manduoshaofree = [NSString stringWithFormat:@"%@",models[0][@"free_delivery_amount"]];
                        int p = [self.yunfei intValue];
                        int m = [self.manduoshaofree intValue];
                        _tishiLa.text = [NSString stringWithFormat:@"本店配送费%d元",p];
                    }
                    [_rightData removeAllObjects];
                    [_rightData addObjectsFromArray:models];
                }
                [_rightTable reloadData];
                
                [self remind];
            }];
        }
        
    }];
    [_rightTable.footer endRefreshing];
    [_rightTable.header endRefreshing];
}

#pragma mark -- 商家详情接口
-(void)shangJiaXiangQing
{
//    [self.activityVC startAnimate];
    NSDictionary *dic=[NSDictionary new];
    if (_isPush) {
        dic = @{@"shop_id":self.shop_id};
    }else{
        dic = @{@"shop_id":self.ID};
    }
    if ([Stockpile sharedStockpile].isLogin) {
        if (_isPush) {
            dic=@{@"user_id":[self getuserid],@"shop_id":self.shop_id};
        }else{
            dic = @{@"user_id":[self getuserid],@"shop_id":self.ID};
        }
        
    }
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];

    [analyze ShopshopInfoWithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        
        if ([code isEqualToString:@"0"]) {
            //            _data=models;
            _remindDic = models;
            NSLog(@"商家详情==%@",models);
            //            [self BigScrollView];
            [self remind];
            _shopCarLa.attributedText = [self jiSuanBenDianXiaoFei];
            _peiSongLab.text = [self xianShiPeiSongFei];
//            [self bottomVi];
        }
        //        [self.activityVC stopAnimate];
    }];
}

#pragma mark -- 购物车的数字
- (void)gouWuCheShuZi
{
    UITabBarItem * item=[self.appdelegate.tabBarController.tabBar.items objectAtIndex:2];
    if ([Stockpile sharedStockpile].isLogin){
        NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
        NSLog(@"%@",value);
        if (value==nil||[value isEqualToString:@""]||[value isEqualToString:@"0"]){
            [item setBadgeValue:nil];
        }else{
            [item setBadgeValue:value];
        }
    }
    else
    {
        [item setBadgeValue:nil];
    }
}


-(void)ReshBotView{
//    if (![Stockpile sharedStockpile].isLogin){
//        return;
//    }
    NSInteger totalNumber = 0;
    NSArray* array=[[DataBase sharedDataBase] getAllFromCart];
    for (NSDictionary * dic in array)
    {
        NSInteger number = 0;
        for (NSDictionary * prod_infoDIc in dic[@"prod_info"])
        {
            number = number + [prod_infoDIc[@"prod_count"] integerValue];
        }
        totalNumber = totalNumber + number;
    }
    NSLog(@"totalNumber::%ld",totalNumber);
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)totalNumber] forKey:@"GouWuCheShuLiang"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
    NSLog(@"totalNumber==%@",value);
    if (![value isEqualToString:@"0"]){
        _numberImg.hidden=NO;
        [_numberImg setTitle:[NSString stringWithFormat:@"%@",value] forState:UIControlStateNormal];
    }else{
        _numberImg.hidden=YES;
        NSLog(@"totalNumber==_numberImg.HIDDEN");
        [_numberImg setTitle:[NSString stringWithFormat:@"%@",value] forState:UIControlStateNormal];
    }
}

#pragma mark -----返回按钮
-(void)returnVi{
//    NSLog(@"%@",self.titlete);
//    self.TitleLabel.text=self.titlete;
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    [self daoHangBtn];
//    UIButton *xiangqing = [UIButton buttonWithType:UIButtonTypeCustom];
//    [xiangqing setTitle:@"商家详情" forState:UIControlStateNormal];
//    xiangqing.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14*self.scale];
//    xiangqing.frame=CGRectMake(self.view.width-70*self.scale, self.TitleLabel.top, 60*self.scale, self.TitleLabel.height);
//    [xiangqing addTarget:self action:@selector(xiangqingBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.NavImg addSubview:xiangqing];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    if (_isPush){
        //        [self dismissViewControllerAnimated:YES completion:nil];
        self.dismissBlock(YES);
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)xiangqingBtn{
    self.hidesBottomBarWhenPushed=YES;
    BusinessInfoViewController *shopInfo = [BusinessInfoViewController new];
    [shopInfo reshShopList:^(NSString *str) {
        UIButton *btn = (UIButton *)[_bottomL viewWithTag:909];
        UILabel *btn1 = (UILabel *)[_bottomL viewWithTag:908];
        if ([str isEqualToString:@"nook"]) {
            btn.selected=NO;
            btn1.text=@"收藏店铺";
            btn1.textColor=blackTextColor;
        }else{
            btn.selected=YES;
            btn1.text=@"取消收藏";
            btn1.textColor=blueTextColor;
        }
    }];
    if (_isPush) {
        shopInfo.shop_id=self.shop_id;
    }else{
        shopInfo.shop_id=self.ID;
    }
    [self.navigationController pushViewController:shopInfo animated:YES];
}

#pragma mark -- 导航上的联系商家，收藏和搜索
- (void)daoHangBtn{
    //收藏按钮
    _shouCangbtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - self.NavImg.height+22, 22, self.NavImg.height-22, self.NavImg.height-22)];
    [_shouCangbtn setImage:[UIImage imageNamed:@"sc"] forState:(UIControlStateNormal)];
    [_shouCangbtn setImage:[UIImage imageNamed:@"sc_1"] forState:(UIControlStateSelected)];
    _shouCangbtn.tag = 11;
    if (_orshou){
        _shouCangbtn.selected = YES;
    }
    [_shouCangbtn addTarget:self action:@selector(leftClinck:) forControlEvents:(UIControlEventTouchUpInside)];
//    _shouCangbtn.backgroundColor = [UIColor blueColor];
    [self.NavImg addSubview:_shouCangbtn];
    
    //搜索按钮
    UIButton * sousuoBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - (self.NavImg.height-22)*2, 22, self.NavImg.height-22, self.NavImg.height-22)];
    [sousuoBtn setImage:[UIImage imageNamed:@"soso1"] forState:(UIControlStateNormal)];
    sousuoBtn.tag = 12;
    [sousuoBtn addTarget:self action:@selector(leftClinck:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.NavImg addSubview:sousuoBtn];
    
    //联系商家btn
    CGRect lianXiRect = [self getStringWithFont:12*self.scale withString:@"联系商家" withWith:999999];
    UIButton * lianxiShangJiaBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - (self.NavImg.height-22)*3-lianXiRect.size.width, 22, self.NavImg.height - 22 + lianXiRect.size.width, self.NavImg.height - 22)];
    lianxiShangJiaBtn.tag = 10;
    [lianxiShangJiaBtn addTarget:self action:@selector(leftClinck:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.NavImg addSubview:lianxiShangJiaBtn];
    
    UIButton * imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.NavImg.height - 22, self.NavImg.height - 22)];
    [imageBtn setImage:[UIImage imageNamed:@"tel"] forState:(UIControlStateNormal)];
    imageBtn.userInteractionEnabled = NO;
    [lianxiShangJiaBtn addSubview:imageBtn];
    
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(imageBtn.right, 0, lianxiShangJiaBtn.width - imageBtn.width, lianxiShangJiaBtn.height)];
    lab.text = @"联系商家";
    lab.textColor = blueTextColor;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = SmallFont(self.scale);
    [lianxiShangJiaBtn addSubview:lab];
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
    [_numberImg setTitle:[NSString stringWithFormat:@"%@",_carNum] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:_numberImg.titleLabel.text forKey:@"GouWuCheShuLiang"];
    _numberImg.titleLabel.font = Small10Font(self.scale);
    [shopcarImgL addSubview:_numberImg];
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
    shopCarR.layer.cornerRadius = 3.0f;
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

#pragma mark-------去购物车，  去订单订单详情
-(void)goShopCar{
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)godingdan{
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark--------左下角按钮方法
-(void)leftClinck:(UIButton *)sender{
    if (sender.tag != 12){
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
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (_isPush) {
            [dic setObject:self.shop_id forKey:@"shop_id"];
        }else{
            [dic setObject:self.ID forKey:@"shop_id"];
        }
        NSLog(@"tel====%@",_tel);
        [dic setObject:_tel forKey:@"tel"];
        if ([Stockpile sharedStockpile].isLogin) {
            [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
        }
        [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
            }
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_tel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
    }else if (sender.tag == 11){
        //收藏
        AnalyzeObject *anle = [AnalyzeObject new];
        NSDictionary *dd = [NSDictionary new];
        if (_isPush) {
            dd = @{@"user_id":[self getuserid],@"collect_id":self.shop_id};
        }else{
            dd = @{@"user_id":[self getuserid],@"collect_id":self.ID};
        }
        if (_orshou) {
            [anle delCollectWithDic:dd Block:^(id models, NSString *code, NSString *msg) {
                if ([code isEqualToString:@"0"]) {
                    _orshou = NO;
                    _shouCangbtn.selected=NO;
//                    btn1.text=@"收藏商铺";
//                    btn1.textColor=blackTextColor;
                    if (_block) {
                        _block(@"ok");
                    }
                }
            }];
            return;
        }
        NSDictionary *dic = [NSDictionary new];
        if (_isPush) {
            dic = @{@"user_id":[self getuserid],@"collect_type":@"2",@"collect_id":self.shop_id};
        }else{
            dic = @{@"user_id":[self getuserid],@"collect_type":@"2",@"collect_id":self.ID};
        }
        [anle addCollectWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"0"]) {
                [self ShowAlertWithMessage:@"收藏成功"];
                _orshou = YES;
                _shouCangbtn.selected=YES;
//                btn1.text=@"取消收藏";
//                btn1.textColor=blueTextColor;
                if (_block) {
                    _block(@"ok");
                }
            }
        }];
    }else if (sender.tag == 12){
        self.hidesBottomBarWhenPushed = YES;
        SouViewController * souView = [[SouViewController alloc]init];
        NSLog(@"%@",_remindDic[@"shop_info"][@"id"]);
        souView.shop_id = _remindDic[@"shop_info"][@"id"];
        souView.keyword = @"";
        [self.navigationController pushViewController:souView animated:YES];
    }
}

#pragma mark -------提示下单事件的view
-(void)remind{
    if (_bigTopVi) {
        [_bigTopVi removeFromSuperview];
    }
    _bigTopVi = [[UIView alloc]initWithFrame:CGRectMake(0,self.NavImg.bottom,[UIScreen mainScreen].bounds.size.width,83*self.scale)];
    _bigTopVi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bigTopVi];
    //商店图片
    UIView * putImageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80*self.scale, 80*self.scale)];
    putImageView.backgroundColor = [UIColor whiteColor];
    UIImageView * headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale,60*self.scale, 60*self.scale)];
    headImageView.clipsToBounds = YES;
    headImageView.layer.cornerRadius = 6*self.scale;
    headImageView.backgroundColor = [UIColor redColor];
    NSString *cut = _remindDic[@"shop_info"][@"logo"];
    NSString *imagename = [cut lastPathComponent];
    NSString *path = [cut stringByDeletingLastPathComponent];
    NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"."]];
    [headImageView setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
    [putImageView addSubview:headImageView];
    UITapGestureRecognizer * viewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xiangqingBtn)];
    [_bigTopVi addGestureRecognizer:viewtap];
    //箭头图片
    UIImageView * jinatouIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 20*self.scale, 30*self.scale, 20*self.scale, 20*self.scale)];
    jinatouIamgeView.image = [UIImage imageNamed:@"right"];
    [_bigTopVi addSubview:jinatouIamgeView];
    //商店名字
    UILabel * shopNameLab = [[UILabel alloc]init];
    shopNameLab.frame  = CGRectMake(headImageView.right+10*self.scale, headImageView.top, [UIScreen mainScreen].bounds.size.width - headImageView.right - 20*self.scale, 20*self.scale);
    shopNameLab.text = _remindDic[@"shop_info"][@"shop_name"];
    shopNameLab.font = DefaultFont(self.scale);
    shopNameLab.textColor = blackTextColor;
    [_bigTopVi addSubview:shopNameLab];
    //商店说明
    UILabel * shopShuoMingLab = [[UILabel alloc]initWithFrame:CGRectMake(headImageView.right + 10*self.scale,shopNameLab.bottom,[UIScreen mainScreen].bounds.size.width - headImageView.right - 20*self.scale, 20*self.scale)];
    shopShuoMingLab.text = _remindDic[@"shop_info"][@"summary"];
    shopShuoMingLab.font = SmallFont(self.scale);
    shopShuoMingLab.textColor = grayTextColor;
    [_bigTopVi addSubview:shopShuoMingLab];

    UILabel *remLa = [[UILabel alloc]initWithFrame:CGRectMake(headImageView.right + 10*self.scale,shopShuoMingLab.bottom,[UIScreen mainScreen].bounds.size.width-headImageView.right - 20*self.scale,20*self.scale)];
    [_bigTopVi addSubview:remLa];
    remLa.font = SmallFont(self.scale);
    remLa.textColor = blueTextColor;
    remLa.tag=654;
    if (_remindDic[@"shop_info"][@"notice"]==nil || [_remindDic[@"shop_info"][@"notice"] isEqualToString:@""]) {
         remLa.text= @"暂无公告";
    }else{
        remLa.text=[NSString stringWithFormat:@"公告：%@",_remindDic[@"shop_info"][@"notice"]] ;
    }
   // NSLog(@"公告====%@",_remindDic);
    if (_issleep) {
        remLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
    }
    remLa.textAlignment=NSTextAlignmentLeft;
    [remLa sizeToFit];
    remLa.height = 20*self.scale;
    if (remLa.width>[UIScreen mainScreen].bounds.size.width-headImageView.right - 20*self.scale) {
        CGRect frame = remLa.frame;
        frame.origin.x = self.view.width;
        remLa.frame = frame;
        [UIView beginAnimations:@"testAnimation" context:NULL];
        [UIView setAnimationDuration:20];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationRepeatCount:999999];
        frame = remLa.frame;
        frame.origin.x = -frame.size.width;
        remLa.frame = frame;
        [UIView commitAnimations];
    }
    UILabel * lin = [[UILabel alloc]initWithFrame:CGRectMake(0, 80*self.scale, [UIScreen mainScreen].bounds.size.width, 3*self.scale)];
    lin.backgroundColor = superBackgroundColor;
    [_bigTopVi addSubview:lin];
    [_bigTopVi addSubview:remLa];
    [_bigTopVi addSubview:putImageView];
}

#pragma mark-------左边Scrollview的设置
-(void)leftScroll{
    if (_scroll) {
        [_scroll removeFromSuperview];
    }
    
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _bigTopVi.bottom, self.view.bounds.size.width-540/2.25*self.scale, self.view.bounds.size.height-58*self.scale-self.scroll.frame.origin.y)];
    self.scroll.backgroundColor = superBackgroundColor;
    [self.view addSubview:self.scroll];
    _scroll.showsHorizontalScrollIndicator=NO;
    _scroll.showsVerticalScrollIndicator=NO;
    
    for (int i=0; i<_data.count+1; i++) {
        UIButton *btn=nil;
        if (i!=_data.count) {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0,i*80/2.25*self.scale, _scroll.width, 80/2.25*self.scale);
            btn.tag = i+1;
            btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
            btn.titleLabel.numberOfLines=2;
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
           // btn.layer.borderWidth=.3;
            //btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
           // [btn setTitle:[_data[i] objectForKey:@"class_name"] forState:UIControlStateNormal];
            [btn setTitle:[_data[i] objectForKey:@"class_name"] forState:UIControlStateNormal];
            btn.titleLabel.font=DefaultFont(self.scale);
            [btn setBackgroundImage:[UIImage imageNamed:@"dian_hoverX"] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"bg_02"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            
            [btn setTitleColor:blackTextColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
            [self.scroll addSubview:btn];
        }else{
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0,i*80/2.25*self.scale, 178/2.25*self.scale, 80/2.25*self.scale);
            [self.scroll addSubview:btn];
            
            UIView *rightL = [[UIView alloc]initWithFrame:CGRectMake(self.scroll.width-.5, btn.top, .5, self.scroll.height)];
            rightL.backgroundColor = blackLineColore;
            [self.scroll addSubview:rightL];
            
            _scroll.contentSize=CGSizeMake(_scroll.width, btn.bottom);
                   }
        
        if(btn.tag==1){
            btn.selected = YES;
        }
            UIView *topL = [[UIView alloc]initWithFrame:CGRectMake(0, btn.left, 270/2.25*self.scale, .5)];
            topL.backgroundColor = blackLineColore;
            [btn addSubview:topL];
        }
    
    
    
    
    
}
#pragma mark--------左侧scrollview中按钮的选择方法
bool or=NO;
-(void)choose:(UIButton *)sender{
    sender.selected = YES;
    [self chooseNextSenderTag:sender.tag];
    [self.activityVC startAnimate];
    [_arr removeAllObjects];
    NSInteger tag = sender.tag;
    
    NSString *ID = [_data[tag-1] objectForKey:@"id"];
    NSDictionary *dic2 = [NSDictionary new];
    if (_isPush) {
        dic2=@{@"shop_id":self.shop_id,@"class_id":ID};
    }else{
        dic2 = @{@"shop_id":self.ID,@"class_id":ID};
    }
    
    AnalyzeObject *analyze = [AnalyzeObject new];
    [analyze getProdListByClasswithDic:dic2 WithBlock:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [_rightData removeAllObjects];

        if ([code isEqualToString:@"0"]) {
            [_rightData addObjectsFromArray:models];
        }
        [_rightTable reloadData];
    }];
}

#pragma mark ----------右边表视图
-(void)RightTable{
    self.rightTable = [[UITableView alloc]initWithFrame:CGRectMake(self.scroll.right, _bigTopVi.bottom, 540/2.25*self.scale, self.view.bounds.size.height-83*self.scale -64-58*self.scale+9*self.scale) style:UITableViewStylePlain];
    
//    self.view.bounds.size.height-100-100/2.25*self.scale-58*self.scale
    self.rightTable.dataSource=self;
    self.rightTable.delegate=self;
    [self.view addSubview:self.rightTable];
    self.rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rightTable registerClass:[BreakInfoCell class] forCellReuseIdentifier:@"cell"];
    int p = [self.yunfei intValue];
    int m = [self.manduoshaofree intValue];
//    _tishiLa = [[UILabel alloc]initWithFrame:CGRectMake(_rightTable.left, _rightTable.bottom, _rightTable.width, 35*self.scale)];
//    _tishiLa.text = [NSString stringWithFormat:@"本店配送费%d元",p];
//    _tishiLa.font=Small10Font(self.scale);
//    _tishiLa.textAlignment=NSTextAlignmentCenter;
//    _tishiLa.backgroundColor=[UIColor colorWithRed:250/255.0 green:255/255.0 blue:182/255.0 alpha:1];
//    [self.view addSubview:_tishiLa];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    CGRectMake(r+10, t, self.contentView.width-100*self.scale, 15*self.scale);

    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.width-100*self.scale, 15*self.scale)];
    la.font=DefaultFont(self.scale);
    la.numberOfLines=0;
    la.text=[_rightData[indexPath.row] objectForKey:@"prod_name"];
    [la sizeToFit];
    
    if (![_rightData[indexPath.row][@"description"] isEmptyString]) {
        return 80*self.scale+la.height;
    }else{
        return 60*self.scale+la.height;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _rightData.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BreakInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *url=@"";
    //店铺列表图片
    NSString *cut = [_rightData[indexPath.row] objectForKey:@"img1"];
    NSString *imagename = [cut lastPathComponent];
    NSString *path = [cut stringByDeletingLastPathComponent];
    
    NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb320."]];
    //NSLog(@"smallImgUrl==%@",smallImgUrl);
   // NSLog(@"smallImgUrl===%@",cut);
//    if (cut.length>0) {
//        url = [cut substringToIndex:[cut length] - 4];
//    }
    [cell.headImg setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
    
    cell.headImg.clipsToBounds=YES;
    cell.headImg.layer.cornerRadius=5;
    
    cell.selectBtn.tag=indexPath.row;
//    cell.headImg.userInteractionEnabled=YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didselect:)];
//    [cell.headImg addGestureRecognizer:tap];
    [cell.selectBtn addTarget:self action:@selector(didselect:) forControlEvents:UIControlEventTouchUpInside];
    [cell.jianBt setImage:[UIImage imageNamed:@"na1"]forState:UIControlStateNormal];
    [cell.addBt setImage:[UIImage imageNamed:@"na2"] forState:UIControlStateNormal];
    if (![_rightData[indexPath.row][@"description"] isEmptyString]) {
        cell.descriptionLab.hidden=NO;
        cell.descriptionLab.text=[_rightData[indexPath.row][@"description"] trimString];
    }else{
        //[cell.descriptionLab removeFromSuperview];
        cell.descriptionLab.hidden=YES;
        //cell.descriptionLab.text=@"";
    }
    if ([_rightData[indexPath.row][@"inventory"]isEqualToString:@"0"] || [_rightData[indexPath.row][@"inventory"]isEqualToString:@""] ||[_rightData[indexPath.row][@"inventory"]isKindOfClass:[NSNull class]]) {
        cell.addBt.hidden=YES;
    }else{
        cell.addBt.hidden=NO;
    }
    cell.titleLa.text=[_rightData[indexPath.row] objectForKey:@"prod_name"];
    NSString *xiao = @"";
    if ([[_rightData[indexPath.row] objectForKey:@"sales"] isEqualToString:@""] || [_rightData[indexPath.row] objectForKey:@"sales"]==nil) {
        xiao=[NSString stringWithFormat:@"销量%@",@"0"];
    }else{
        xiao=[NSString stringWithFormat:@"销量%@",[_rightData[indexPath.row] objectForKey:@"sales"]];
    }
    cell.salesLa.text = xiao;
    NSString * priceString = [NSString stringWithFormat:@"%@元/%@",[_rightData[indexPath.row] objectForKey:@"price"],_rightData[indexPath.row][@"unit"]];
    NSString * firstString = [NSString stringWithFormat:@"%@元",[_rightData[indexPath.row] objectForKey:@"price"]];
    NSString * lastString = [NSString stringWithFormat:@"/%@",_rightData[indexPath.row][@"unit"]];
    NSMutableAttributedString * priceAttributeString = [[NSMutableAttributedString alloc]initWithString:priceString];
    [priceAttributeString addAttribute:NSForegroundColorAttributeName value:blackTextColor range:NSMakeRange(firstString.length, lastString.length)];
    cell.priceLa.attributedText = priceAttributeString;
    cell.price_yuan.text=[NSString stringWithFormat:@"￥%@",[_rightData[indexPath.row] objectForKey:@"origin_price"]];
    float yuan = [[NSString stringWithFormat:@"%@",[_rightData[indexPath.row] objectForKey:@"origin_price"]] floatValue];
    float xian = [[NSString stringWithFormat:@"%@",[_rightData[indexPath.row] objectForKey:@"price"]] floatValue];
    if (xian>=yuan) {
        cell.price_yuan.hidden=YES;
        cell.lin.hidden=YES;
    }else{
        cell.price_yuan.hidden=NO;
        cell.lin.hidden=NO;
    }
//    if ([[NSString stringWithFormat:@"%@",[_rightData[indexPath.row] objectForKey:@"origin_price"]] isEqualToString:[NSString stringWithFormat:@"%@",[_rightData[indexPath.row] objectForKey:@"price"]]]) {
//        cell.price_yuan.hidden=YES;
//        cell.lin.hidden=YES;
//    }else{
//        cell.price_yuan.hidden=NO;
//        cell.lin.hidden=NO;
//    }
    cell.indexpath=indexPath;
    cell.delegate=self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ShopModel *model = [_dic objectForKey:[_rightData[indexPath.row]objectForKey:@"id"]];
    NSLog(@"model====%@",[_dic objectForKey:[_rightData[indexPath.row]objectForKey:@"id"]]);
    if (!model) {
        model=[ShopModel new];
        [_dic setObject:model forKey:[_rightData[indexPath.row]objectForKey:@"id"]];
    }
    NSString *prod_id = _rightData[indexPath.row][@"id"];
    BOOL yes=NO;
    for (NSDictionary *dic in _carData[@"cart_info"]) {
        if (yes) {
            break;
        }
        if ([dic[@"prod_id"] isEqualToString:prod_id]) {
            model.selectNum=[dic[@"prod_count"] intValue];
            _number = _number + [dic[@"prod_count"] intValue];
            yes=YES;
        }else{
            model.selectNum=0;
        }
    }
    if ([_carData[@"cart_info"] count]<=0) {
        model.selectNum=0;
    }
    cell.shopModel = model;
//    if (model.selectNum==0) {
//        cell.jianBt.hidden=YES;
//        cell.numberLa.hidden=YES;
//    }
   // self.appdelegate.shopDictionary[prod_id] intValue]
    int* index=[self.appdelegate.shopDictionary[@([prod_id intValue])] intValue];
    NSLog(@"index_reload==%d  param==%@",index,self.appdelegate.shopDictionary);
    cell.numberLa.text=[NSString stringWithFormat:@"%d",index];
    if (index==0) {
        cell.jianBt.hidden=YES;
        cell.numberLa.hidden=YES;
    }else{
        cell.jianBt.hidden=NO;
        cell.numberLa.hidden=NO;
    }
    cell.addBt.hidden=NO;
    NSArray *ar = _carData[@"cart_info"];
    return cell;
}

-(void)didselect:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
    _list=[[NSMutableArray alloc]init];
    NSDictionary *shopInfodic=[[NSDictionary alloc]initWithObjectsAndKeys:_ID,@"shopid",
                            self.titlete,@"shopname",
                            self.shopImg,@"image",
                            _GoodsList,@"list", nil];
    [_list addObject:shopInfodic];
    NSIndexPath *indexOath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    BreakInfoCell *cell = [self.rightTable cellForRowAtIndexPath:indexOath];
    ShopInfoViewController *shopInfo = [ShopInfoViewController new];
    shopInfo.indexs=[cell.numberLa.text integerValue];
    shopInfo.yes=NO;
    shopInfo.isopen=_isopen;
    shopInfo.price =_shopCarLa.text;
    shopInfo.delegate=self;
    shopInfo.numb = [_numberImg.titleLabel.text intValue];
    shopInfo.shop_name=self.titlete;
    shopInfo.shop_user_id=self.shop_user_id;
    shopInfo.indexNumber = sender.tag;
    shopInfo.shop_id = [_rightData[sender.tag] objectForKey:@"shop_id"];
    shopInfo.prod_id = [_rightData[sender.tag]objectForKey:@"id"];
    shopInfo.xiaoliang= _rightData[sender.tag][@"sales"];
    shopInfo.shoucang= _rightData[sender.tag][@"collect_time"];
    shopInfo.gongGao=_rightData[sender.tag][@"notice"];
    shopInfo.tel = self.tel;
//    shopInfo.yunfei=self.yunfei;
    shopInfo.param=_rightData[sender.tag];
    [self.navigationController pushViewController:shopInfo animated:YES];
}

-(void)addNumberindex:(NSInteger)index number:(NSInteger)number jiaAndJian:(BOOL)isAdd{
    [_numberImg setTitle:[NSString stringWithFormat:@"%ld",(long)number] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:_numberImg.titleLabel.text forKey:@"GouWuCheShuLiang"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self BreakInfoCellChangeNumber:[NSNumber numberWithInteger:number] IndexPath:indexPath jiaAndJian:isAdd];
}

#pragma mark-----计算总价格   加
-(void)BreakInfoCellChangeNumber:(NSNumber *)number IndexPath:(NSIndexPath *)indexPath jiaAndJian:(BOOL)jiaAndJian{
    NSString* ID= [_rightData[indexPath.row] objectForKey:@"id"];
    NSMutableDictionary* param=[_rightData[indexPath.row] mutableCopy];
    [param setObject:ID forKey:@"prod_id"];
   // [param setObject:@"" forKey:@"shop_logo"];
    NSLog(@"BreakInfoCellChangeNumber==%@",param);
    NSInteger isOffLine=[[NSString stringWithFormat:@"%@",self.shopInfo[@"is_off_online"]] integerValue];
    if(isOffLine==1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"临时歇业中"
                                                            message:@"暂停营业。很快回来^_^!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }else if(![AppUtil isDoBusiness:self.shopInfo]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"歇业中"
                                                            message:[NSString stringWithFormat:@"%@",self.shopInfo[@"onlinemark"]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    int index=[self.appdelegate.shopDictionary[@([ID intValue])] intValue];
    NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
    int cartNum=[value intValue];
    if(jiaAndJian){
        index++;
        [[DataBase sharedDataBase] updateCart:param withType:1];
        [self.appdelegate.shopDictionary setObject:[NSString stringWithFormat:@"%d",index] forKey:@([ID intValue])];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cartNum+1] forKey:@"GouWuCheShuLiang"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        index--;
        [[DataBase sharedDataBase] updateCart:param withType:0];
        [self.appdelegate.shopDictionary setObject:[NSString stringWithFormat:@"%d",index] forKey:@([ID intValue])];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cartNum-1] forKey:@"GouWuCheShuLiang"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //NSLog(@"index2====%d",[self.appdelegate.shopDictionary[ID] intValue]);
    [self ReshBotView];
    [self shangJiaXiangQing];
    [self.rightTable reloadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addact" object:nil];
    self.botRTwo.hidden=NO;
    //self.numberImg.hidden=NO;
}


#pragma mark------刷新总价格view
-(void)ReshPrice:(NSMutableDictionary *)dic withNum:(NSMutableDictionary *)num JiaAndJian:(BOOL)JiaAndJian price:(NSString *)price{
    NSInteger i=0;
    double pric=0.0;
    if (JiaAndJian) {
        i = [_carNum integerValue];
        i++;
        _carNum=[NSString stringWithFormat:@"%ld",(long)i];
        
        pric = [_carPrice doubleValue];
        pric = pric+[price doubleValue];
        _carPrice=[NSString stringWithFormat:@"%.2f",pric];
    }else{
        i = [_carNum integerValue];
        i--;
        _carNum=[NSString stringWithFormat:@"%ld",(long)i];
        
        pric = [_carPrice doubleValue];
        pric = pric-[price doubleValue];
        _carPrice=[NSString stringWithFormat:@"%.2f",pric];
    }
    if ([_carNum isEqualToString:@"0"]) {
        [_numberImg setTitle:@"0" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:_numberImg.titleLabel.text forKey:@"GouWuCheShuLiang"];
//        self.botRTwo.hidden=YES;
//        self.numberImg.hidden=YES;
    }
    [_numberImg setTitle:[NSString stringWithFormat:@"%ld",(long)i] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:_numberImg.titleLabel.text forKey:@"GouWuCheShuLiang"];
    _shopCarLa.attributedText = [self jiSuanBenDianXiaoFei];
    _peiSongLab.text = [self xianShiPeiSongFei];
//    _shopCarLa.text = [NSString stringWithFormat:@"共%@元",_carPrice];

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.hidesBottomBarWhenPushed=YES;
//    ShopInfoViewController *shopInfo = [ShopInfoViewController new];
//    
//    [self.navigationController pushViewController:shopInfo animated:YES];
    
}

-(void)chooseNextSenderTag:(NSInteger)senderTag{
    NSArray *b = [self.scroll subviews];
    for (UIButton *but in b) {
        if ([but isKindOfClass:[UIButton class]]) {
            if (but.tag != senderTag) {
                but.selected = NO;
            }
        }
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _carPrice = [NSString stringWithFormat:@"本店消费￥%.2f元",[self jiSuanAmount]];//total];
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:_carPrice];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 4)];
    return attributeString;
}

#pragma mark -- 计算总价格
- (CGFloat)jiSuanAmount
{
    CGFloat amount = 0.0;
    NSString* shopID=@"";
    if (_isPush) {
       shopID=[NSString stringWithFormat:@"%@",self.shop_id];
    }else{
       shopID=[NSString stringWithFormat:@"%@",self.ID];
    }
    NSArray* array=[[DataBase sharedDataBase] getAllFromCart];
    for (NSDictionary *ShopInfo in array) {
        NSMutableArray *arr = [[ShopInfo objectForKey:@"prod_info"] mutableCopy];
        for (NSDictionary *prodDic in arr) {
            NSString* prodShopID= [NSString stringWithFormat:@"%@",prodDic[@"shop_id"]];
            NSLog(@"prodShopID==%@==%@",shopID,prodShopID);
            if([shopID isEqualToString:prodShopID]){
                //NSLog(@"shopID==95==%d====%@",[prodShopID isEqualToString:@"195"],prodShopID);
                NSString *key = [NSString stringWithFormat:@"%@",prodDic[@"prod_id"]];
                if (![prodDic[@"prod_count"] isEqualToString:@"0"]) {
                    amount = amount + [prodDic[@"price"] floatValue]*[prodDic[@"prod_count"] integerValue];
                }
            }
        }
    }
    return amount;
}

#pragma mark -- 显示配送费
- (NSString *)xianShiPeiSongFei
{
    NSInteger* deliveryFee=[[NSString stringWithFormat:@"%@",_remindDic[@"shop_info"][@"delivery_fee"]] integerValue]  ;
    NSInteger* freeDeliveryAmount=[[NSString stringWithFormat:@"%@",_remindDic[@"shop_info"][@"free_delivery_amount"]] integerValue];
    NSString * peiSongFei = [NSString stringWithFormat:@"配送费%d元，满%d元免配送费",deliveryFee ,freeDeliveryAmount];
//    NSString * peiSongFei = [NSString stringWithFormat:@"配送费%@元，满%@元免配送费",_remindDic[@"shop_info"][@"delivery_fee"],_remindDic[@"shop_info"][@"free_delivery_amount"]];
    return peiSongFei;
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
