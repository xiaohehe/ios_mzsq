//
//  GeRenZhongXinViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GeRenZhongXinViewController.h"
#import "CenterCell.h"
#import "LoginViewController.h"
#import "ShopLingShouViewController.h"
#import "FuWuLeiDingDanViewController.h"
#import "ShouCangShangPinViewController.h"
#import "ShouCangDianPuViewController.h"
#import "WoDeGongGaoViewController.h"
#import "SettingViewController.h"
#import "GouWuCheViewController.h"
#import "ShouHuoDiZhiListViewController.h"
#import "SheQuManagerViewController.h"
#import "ZhangHuGuanLiViewController.h"
#import "WoYaoKaiWiDianViewController.h"
#import "MineCollectionViewCell.h"
#import "GongGaoQiangViewController.h"
#import "NeighborhoodViewController.h"
#import "OrderTableViewCell.h"
#import "AppUtil.h"
#import "ForumViewController.h"
#import "RCDCustomerServiceViewController.h"
#import "MyOrderViewController.h"
#import "ImageTableViewCell.h"
#import "SigningViewController.h"
#import "FamilyViewController.h"
#import "OrderDetailsViewController.h"
#import "CouponsViewController.h"
#import "PaymentOrderViewController.h"
#import "MessageCenterViewController.h"
#import "LunBoWebViewController.h"
#import "SouViewController.h"
static const NSUInteger MESSAGE_TAG = 66;

static const NSUInteger ORDER_HEADER_TAG = 1000000;
//static const NSUInteger ORDER_PROD_TAG = 2000000;
static const NSUInteger SINGLE_AGAIN_TAG = 1000;
static const NSUInteger DELETE_ORDER_TAG = 2000;

//#define SERVICE_ID @"KEFU151236833413783"

@interface GeRenZhongXinViewController()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,RCIMReceiveMessageDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIButton *familyBtn;
@property(nonatomic,strong)UIButton *integralBtn;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *dataSourceImg;
@property(nonatomic,strong)NSArray *dataSourceName;
@property(nonatomic,strong)UIImageView *HeaderImg;
@property(nonatomic,strong) NSMutableArray* orderArray;//
@property(nonatomic,strong) NSDictionary* familyDic;//
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIButton *coverImg;
@end
@implementation GeRenZhongXinViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logok) name:@"logsuccedata" object:nil];
    _orderArray=[[NSMutableArray alloc]init];
    [self newNav];
    [self newListView];
    [self newHeaderView];
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    if (![Stockpile sharedStockpile].isLogin) {
        [self reshData];
    }
    [RCIM sharedRCIM].disableMessageAlertSound=NO;
    [RCIM sharedRCIM].receiveMessageDelegate=self;
}

-(void)dropDownRefresh{
    [self reshData];
}

-(void) newHeaderView{
    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 70*self.scale+140*self.scale)];
    _headerView.backgroundColor=[UIColor whiteColor];
    _headerView.userInteractionEnabled=YES;
    [self newLogin];
    [self newView];
    _tableView.tableHeaderView=_headerView;
}

-(void) newListView{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.frame.size.width,self.view.frame.size.height-self.NavImg.height-self.tabBarController.tabBar.frame.size.height ) style:UITableViewStyleGrouped];
    [_tableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"OrderTableViewCell"];
    [_tableView registerClass:[ImageTableViewCell class] forCellReuseIdentifier:@"ImageTableViewCell"];
    _tableView.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
}

-(void)logok{
    if ([Stockpile sharedStockpile].isLogin) {
        _loginBtn.frame=CGRectMake(60*self.scale, 5*self.scale, self.view.width-100*self.scale, 20*self.scale);
        [_loginBtn setTitle:[Stockpile sharedStockpile].nickName forState:UIControlStateNormal];
        _loginBtn.userInteractionEnabled=NO;
        [_loginBtn setBackgroundImage:[UIImage setImgNameBianShen:@""] forState:UIControlStateNormal];
        _loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        _loginBtn.frame=CGRectMake(60*self.scale, 18*self.scale, 80*self.scale, 20*self.scale);
        _loginBtn.userInteractionEnabled=YES;
        [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        _loginBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark -- 下拉刷新
- (void)xiala{
    self.tableView.footer.state = MJRefreshFooterStateIdle;
    [self reshData];
}

-(void)reshData{
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSString *com = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    NSDictionary *dic = @{@"communityId":com};
    [anle myCentreWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"_orderArray==%@==%@",dic,models);
            [_orderArray removeAllObjects];
            if([models isKindOfClass:[NSArray class]]){
                 [_orderArray addObjectsFromArray:models];
                if ([Stockpile sharedStockpile].isLogin) {
                    [[Stockpile sharedStockpile] setIsLogin:NO];
                    [[Stockpile sharedStockpile]setID:@""];
                    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"user_id"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GouWuCheShuLiang"];
                    [self.appdelegate.shopDictionary removeAllObjects];
                    NSLog(@"islogin==%d",[Stockpile sharedStockpile].isLogin);
                    [self logok];
                    [self setFamilyInfo];
                    _coverImg.selected=NO;
                    [_coverImg setBackgroundImage:[UIImage imageNamed:@"head_sculpture"] forState:UIControlStateNormal];
                }
            }else{
                [_orderArray addObjectsFromArray:models[@"Order"]];
                _familyDic=models[@"Family"];
                [self setFamilyInfo];
                _tableView.tableFooterView=[self footerView];
            }
            [_tableView reloadData];
        }
    }];
}

-(void)setFamilyInfo{
    if ([Stockpile sharedStockpile].isLogin) {
        _integralBtn.hidden=NO;
        NSString* fid=[NSString stringWithFormat:@"%@",_familyDic[@"FID"]];
        if([fid isEqualToString:@"0"]){
            _integralBtn.width=70*self.scale*0.75;
            [_integralBtn setBackgroundImage:[UIImage imageNamed:@"no_sign"] forState:UIControlStateNormal];
        }else{
            for(UIView *view in [_integralBtn subviews]){
                [view removeFromSuperview];
            }
            NSString* integral=[NSString stringWithFormat:@"家庭积分:%@ >",_familyDic[@"Integral"]];
            _integralBtn.backgroundColor=[UIColor colorWithRed:0.180 green:0.196 blue:0.271 alpha:1.00];
            UIImageView* logo=[[UIImageView alloc] initWithFrame:CGRectMake(8, 3, _integralBtn.height-6, _integralBtn.height-6)];
            [logo setImage:[UIImage imageNamed:@"jewel"]];
            [_integralBtn addSubview:logo];
            UILabel* content=[[UILabel alloc] initWithFrame:CGRectMake(logo.right+5, 3, _integralBtn.height-6, _integralBtn.height-6)];
            content.text=integral;
            content.textColor=[UIColor colorWithRed:0.792 green:0.675 blue:0.416 alpha:1.00];
            content.font=[UIFont systemFontOfSize: 11.0];
            CGSize titleSize = [integral sizeWithFont:[UIFont systemFontOfSize: 11.0] constrainedToSize:CGSizeMake(MAXFLOAT, _integralBtn.height-6)];
            content.width=titleSize.width;
            [_integralBtn addSubview:content];
            _integralBtn.width=content.right+8;
            NSLog(@"");
            _integralBtn.layer.masksToBounds = YES;
            _integralBtn.layer.cornerRadius = _integralBtn.height/2;
        }
    }else{
        _integralBtn.hidden=YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    if ([Stockpile sharedStockpile].isLogin) {
        [self reshData];
    }
    [self ReshMessage];
    [self gouWuCheShuZi];
    self.navigationController.navigationBarHidden=YES;
    NSString *commid =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"commid"]];// ;
    //NSLog(@"commid222222==%@",commid);
    if ([commid isEqualToString:@"0"] && [Stockpile sharedStockpile].isLogin==YES) {
        SheQuManagerViewController *shequ = [SheQuManagerViewController new];
        shequ.hidesBottomBarWhenPushed=YES;
        shequ.nojiantou=NO;
        [self.navigationController pushViewController:shequ animated:NO];
    }
}

-(void)newLogin{
    _HeaderImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 70*self.scale)];
    [_HeaderImg setImage:[UIImage imageNamed:@"round_edge"]];
    _HeaderImg.userInteractionEnabled=YES;
    [_headerView addSubview:_HeaderImg];
    _coverImg=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 40*self.scale, 40*self.scale)];
    _coverImg.layer.masksToBounds=YES;
    _coverImg.layer.cornerRadius=_coverImg.height/2;
    _coverImg.userInteractionEnabled=YES;
    if ([Stockpile sharedStockpile].isLogin) {
        _coverImg.selected=YES;
        [_coverImg setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[Stockpile sharedStockpile].logo] placeholderImage:[UIImage imageNamed:@"head_sculpture"]];
    }else{
        _coverImg.selected=NO;
        [_coverImg setBackgroundImage:[UIImage imageNamed:@"head_sculpture"] forState:UIControlStateNormal];
    }
    [_coverImg addTarget:self action:@selector(gozhanghumanager:) forControlEvents:UIControlEventTouchUpInside];
    [_HeaderImg addSubview:_coverImg];
    _loginBtn=[[UIButton alloc]initWithFrame:CGRectMake(60*self.scale, 15*self.scale, self.view.width-_coverImg.right-50*self.scale, 20*self.scale)];
    if ([Stockpile sharedStockpile].isLogin) {
        _loginBtn.frame=CGRectMake(60*self.scale, 5*self.scale, self.view.width-_coverImg.right-50*self.scale, 20*self.scale);
        [_loginBtn setTitle:[Stockpile sharedStockpile].nickName forState:UIControlStateNormal];
        _loginBtn.userInteractionEnabled=NO;
        _loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        _loginBtn.frame=CGRectMake(60*self.scale, 18*self.scale, 80*self.scale, 20*self.scale);
        _loginBtn.userInteractionEnabled=YES;
        [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        //_loginBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
        [_loginBtn setTitleColor:[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00] forState:UIControlStateNormal];
    }
    [_loginBtn addTarget:self action:@selector(LoginViewEvent:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.titleLabel.font=DefaultFont(self.scale);
    [_HeaderImg addSubview:_loginBtn];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipUserInfo)];
    [_HeaderImg addGestureRecognizer:tapGesture];
    _familyBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-(self.view.width/750*265), 70*self.scale-(self.view.width/750*110), (self.view.width/750*265), (self.view.width/750*110))];
    [_familyBtn addTarget:self action:@selector(skipSigning) forControlEvents:UIControlEventTouchUpInside];
    //_familyBtn.backgroundColor=[UIColor greenColor];
    [_HeaderImg addSubview:_familyBtn];
     _integralBtn=[[UIButton alloc]initWithFrame:CGRectMake(_loginBtn.left, 30*self.scale, 113*self.scale*0.75, 15*self.scale)];
//    [_integralBtn setTitleColor:[UIColor colorWithRed:0.792 green:0.675 blue:0.416 alpha:1.00] forState:UIControlStateNormal];
//    _integralBtn.titleLabel.font = [UIFont systemFontOfSize: 11.0];
    [_integralBtn addTarget:self action:@selector(skipSigning) forControlEvents:UIControlEventTouchUpInside];
    [self setFamilyInfo];
    [_HeaderImg addSubview:_integralBtn];
}

-(void)skipUserInfo{
    NSLog(@"skipUserInfo");
    if ([Stockpile sharedStockpile].isLogin==NO) {
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {//登录成功后需要加载的数据
                    NSLog(@"登录成功");
                    [self dropDownRefresh];
                }];
            }
        }];
        return;
    }
    //self.hidesBottomBarWhenPushed=YES;
    ZhangHuGuanLiViewController *zhang = [ZhangHuGuanLiViewController new];
    zhang.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:zhang animated:YES];
    //self.hidesBottomBarWhenPushed=NO;
}

-(void)gozhanghumanager:(UIButton *)btn{
    NSLog(@"gozhanghumanager");
    if (btn.selected==NO) {
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {//登录成功后需要加载的数据
                    NSLog(@"登录成功");
                    [self dropDownRefresh];
                }];
            }
        }];
        return;
    }
    //self.hidesBottomBarWhenPushed=YES;
    ZhangHuGuanLiViewController *zhang = [ZhangHuGuanLiViewController new];
    zhang.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:zhang animated:YES];
    //self.hidesBottomBarWhenPushed=NO;
}

-(void)newView{
    _dataSourceImg=@[@"forum",@"my_order",@"collection_goods",@"shipping_address",@"discount_coupon_icon"];
    _dataSourceName=@[@"邻里圈",@"我的订单",@"常购清单",@"收货地址",@"优惠券"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, self.HeaderImg.bottom+0*self.scale, self.view.width, 140*self.scale) collectionViewLayout:layout];
    self.collectionView.backgroundColor=[UIColor clearColor];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    //[self.view addSubview:self.collectionView];
    //self.collectionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerClass:[MineCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([MineCollectionViewCell class])];
    [_headerView addSubview:self.collectionView];
}

#pragma mark - 按钮事件
-(void)ButtonEvent:(UIButton *)button{
    if ([Stockpile sharedStockpile].isLogin==NO) {
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {//登录成功后需要加载的数据
                    NSLog(@"登录成功");
                    [self dropDownRefresh];
                }];
            }
        }];
        return;
    }
    if (button.tag==1)
    {
        WoDeGongGaoViewController *gonggaoVc=[[WoDeGongGaoViewController alloc]init];
        gonggaoVc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:gonggaoVc animated:YES];
    }else{
        ShouCangShangPinViewController *shangpinVc=[[ShouCangShangPinViewController alloc]init];
        shangpinVc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:shangpinVc animated:YES];
    }
}

-(void)LoginViewEvent:(UIButton *)button{
    [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            LoginViewController *login = [self login];
            [login resggong:^(NSString *str) {//登录成功后需要加载的数据
                NSLog(@"登录成功");
               // [self dropDownRefresh];
            }];
        }
    }];
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ReshMessage];
        [self.appdelegate appNum];
    });
}

-(void)ReshMessage{
    int unreadMsgCount =[self.appdelegate ReshData];
    UILabel * CarNum = (UILabel *)[self.view viewWithTag:MESSAGE_TAG];
    if (unreadMsgCount>0) {
        CarNum.hidden = NO;
        CarNum.text=[NSString stringWithFormat:@"%d",unreadMsgCount];
        if (unreadMsgCount>99) {
            CarNum.text=[NSString stringWithFormat:@"99+"];
            CarNum.width=25;
        }else{
            CarNum.width=20;
        }
    }else{
        CarNum.hidden = YES;
    }
}

#pragma mark -- 购物车的数字
- (void)gouWuCheShuZi{
    UITabBarItem * item=[self.appdelegate.tabBarController.tabBar.items objectAtIndex:2];
    //    if ([Stockpile sharedStockpile].isLogin)
    //    {
    NSNumber* num=[[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
    NSString * value = [NSString stringWithFormat:@"%@",num];
    NSLog(@"value==%@",value);
    if (num==nil||[value isEqualToString:@"0"]){
        [item setBadgeValue:nil];
    }else{
        [item setBadgeValue:value];
    }
}

#pragma mark - 导航
-(void)newNav{
    //self.TitleLabel.text=@"个人中心";
    self.TitleLabel.textColor  = [UIColor whiteColor];
    self.NavImg.backgroundColor = [UIColor colorWithRed:1.000 green:0.792 blue:0.000 alpha:1.00];
    UIButton *talkImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [talkImg setImage:[UIImage imageNamed:@"msg_black"] forState:UIControlStateNormal];
//  [talkImg setImage:[UIImage imageNamed:@"dian_ico_01"] forState:UIControlStateHighlighted];
    talkImg.frame=CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top+2*self.scale, self.TitleLabel.height,self.TitleLabel.height);
    [talkImg addTarget:self action:@selector(talk) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:talkImg];
    UILabel *CarNum=[[UILabel alloc]initWithFrame:CGRectMake(talkImg.width-25, 2, 20, 18)];
    CarNum.backgroundColor=[UIColor redColor];
    CarNum.layer.cornerRadius=CarNum.height/2;
    CarNum.layer.masksToBounds=YES;
    CarNum.textAlignment=NSTextAlignmentCenter;
    CarNum.font=SmallFont(1);
    CarNum.tag=MESSAGE_TAG;
    CarNum.textColor=[UIColor whiteColor];
    CarNum.hidden=YES;
    [talkImg addSubview:CarNum];
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setImage:[UIImage imageNamed:@"setup"] forState:UIControlStateNormal];
    setBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    //  [talkImg setImage:[UIImage imageNamed:@"dian_ico_01"] forState:UIControlStateHighlighted];
    setBtn.frame=CGRectMake(talkImg.left-self.TitleLabel.height-10*self.scale, self.TitleLabel.top+2*self.scale, self.TitleLabel.height,self.TitleLabel.height);
    [setBtn addTarget:self action:@selector(setup) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:setBtn];
    self.gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self getStartHeight]+44);
    //[self.view.layer addSublayer:gradientLayer];
    [self.NavImg.layer insertSublayer:self.gradientLayer atIndex:0];
}

-(void) setup{
    SettingViewController *setVC=[[SettingViewController alloc]init];
    setVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:setVC animated:YES];
}

-(void)talk{
    if ([Stockpile sharedStockpile].isLogin==NO) {
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {//登录成功后需要加载的数据
                    NSLog(@"登录成功");
                    [self dropDownRefresh];
                }];
            }
        }];
        return;
    }
    MessageCenterViewController *rong = [[MessageCenterViewController alloc]init];
    rong.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:rong animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //NSLog(@"numberOfItemsInSection==%ld",_rightData.count);
    return _dataSourceImg.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MineCollectionViewCell class]) forIndexPath:indexPath];
    [cell.coverIv setImage:[UIImage imageNamed:_dataSourceImg[indexPath.row]]];
    cell.nameLb.text=_dataSourceName[indexPath.row];
    return cell;
}

//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [MineCollectionViewCell cellSize];
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

//动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==5){
        SettingViewController *setVC=[[SettingViewController alloc]init];
        setVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:setVC animated:YES];
        return;
    }
    if ([Stockpile sharedStockpile].isLogin==NO) {
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {//登录成功后需要加载的数据
                    NSLog(@"登录成功");
                    [self dropDownRefresh];
                }];
            }
        }];
        return;
    }
    switch (indexPath.row) {
        case 0:
            [self skipLinLiQuan];
            break;
        case 1:
            [self myOrder];
            break;
        case 2:
            [self skipCollectGoods];
            break;
        case 3:
            [self shippingAddress];
            break;
        case 4:
            [self skipCouponsView];
            break;
    }
}

-(void)skipCouponsView{
    CouponsViewController* couponsViewController=[[CouponsViewController alloc]init];
    couponsViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:couponsViewController animated:YES];
}

-(void) skipLinLiQuan{
    //NeighborhoodViewController* gongGaoQiangViewController=[[NeighborhoodViewController alloc]init];
    ForumViewController* gongGaoQiangViewController=[[ForumViewController alloc]init];
    gongGaoQiangViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:gongGaoQiangViewController animated:YES];
}

-(void)skipCollectGoods{
    ShouCangShangPinViewController *shangpinVc=[[ShouCangShangPinViewController alloc]init];
    shangpinVc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:shangpinVc animated:YES];
}

-(void)shippingAddress{
    ShouHuoDiZhiListViewController *lingShou=[[ShouHuoDiZhiListViewController alloc]init];
    lingShou.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:lingShou animated:YES];
}

-(void) myOrder{
    //ShopLingShouViewController *lingShou=[[ShopLingShouViewController alloc]init];
    MyOrderViewController *lingShou=[[MyOrderViewController alloc]init];
    lingShou.hidesBottomBarWhenPushed=YES;
    //lingShou.ispop=YES;
    [self.navigationController pushViewController:lingShou animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([Stockpile sharedStockpile].isLogin) {
        return 30*self.scale;
    }else{
        NSInteger height=[_orderArray[indexPath.row][@"h"] integerValue];
        NSInteger width=[_orderArray[indexPath.row][@"w"] integerValue];
        return self.view.width/width*height;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([Stockpile sharedStockpile].isLogin) {
        return [_orderArray[section][@"order_detail"][0][@"prods"] count];
    }else{
        return [_orderArray count];
    }
}

#pragma mark -数据源方法
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if ([Stockpile sharedStockpile].isLogin) {
        return [_orderArray count];
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([Stockpile sharedStockpile].isLogin) {
        OrderTableViewCell *cell=[OrderTableViewCell cellWithTableView:tableView];
        NSDictionary* itemDic=_orderArray[indexPath.section][@"order_detail"][0][@"prods"][indexPath.row];
        cell.titleLa.text=itemDic[@"prod_name"];
        cell.numLb.text=[NSString stringWithFormat:@"x%@",itemDic[@"prod_count"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ImageTableViewCell *cell=[ImageTableViewCell cellWithTableView:tableView];
        NSString *imgUrl=[NSString stringWithFormat:@"%@",_orderArray[indexPath.row][@"img"]];
        [cell.advertisingImg setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
        return cell;
    }
}

-(void)skipRedirectTo:(NSString*) redirectTo openKey:(NSString*)openKey {
    if([AppUtil isBlank:openKey]||[AppUtil isBlank:redirectTo]||[redirectTo isEqualToString:@"1"])
        return;
    if ([redirectTo isEqualToString:@"2"]){
        LunBoWebViewController *lunbo = [LunBoWebViewController new];
        lunbo.hidesBottomBarWhenPushed=YES;
        lunbo.url = openKey;
        [self.navigationController pushViewController:lunbo animated:YES];
    }else if ([redirectTo isEqualToString:@"4"]){
        BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
        info.hidesBottomBarWhenPushed=YES;
        info.shop_id=openKey;
        info.ID=openKey;
        [self.navigationController pushViewController:info animated:YES];
    }else if ([redirectTo isEqualToString:@"5"]){
        ShopInfoViewController *buess = [ShopInfoViewController new];
        buess.hidesBottomBarWhenPushed=YES;
        buess.prod_id=openKey;
        [self.navigationController pushViewController:buess animated:YES];
    }else if ([redirectTo isEqualToString:@"6"]){
        SouViewController *souView = [SouViewController new];
        souView.hidesBottomBarWhenPushed=YES;
        souView.isRedirectTo=YES;
        souView.keyword=openKey;
        [self.navigationController pushViewController:souView animated:YES];
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![Stockpile sharedStockpile].isLogin) {
        NSDictionary* dic= _orderArray[indexPath.section];
        NSString* redirectTo=[NSString stringWithFormat:@"%@",dic[@"redirect_to"]];
        [self skipRedirectTo:redirectTo openKey:dic[@"OpenKey"]];
        return;
    }
    id start = _orderArray[indexPath.section];
    OrderDetailsViewController* details=[[OrderDetailsViewController alloc] init];
    details.hidesBottomBarWhenPushed=YES;
    details.orderId =start[@"order_detail"][0][@"order_no"];
    details.subOrderId =start[@"order_detail"][0][@"prods"][0][@"sub_order_no"];
    [self.navigationController pushViewController:details animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([Stockpile sharedStockpile].isLogin) {
        return 45*self.scale;
    }else{
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([Stockpile sharedStockpile].isLogin) {
        return 70*self.scale;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (![Stockpile sharedStockpile].isLogin) {
        return nil;
    }
    NSDictionary* groupDic=_orderArray[section];
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 70*self.scale)];
    footerView.backgroundColor=[UIColor whiteColor];
    UILabel *totalLb = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/2, 0, self.view.width/2-10*self.scale, 15*self.scale)];
    int total=0;
    for(int i=0;i<[groupDic[@"order_detail"][0][@"prods"] count];i++){
        NSDictionary* dic=groupDic[@"order_detail"][0][@"prods"][i];
        int count=[dic[@"prod_count"] intValue];
        total+=count;
    }
    totalLb.textAlignment = NSTextAlignmentRight;
    totalLb.font =[UIFont systemFontOfSize:11*self.scale];
    totalLb.textColor =[UIColor colorWithRed:0.204 green:0.204 blue:0.204 alpha:1.00];
    CGFloat total_amount=[groupDic[@"order_detail"][0][@"total_amount"] floatValue];
    NSString *content=[NSString stringWithFormat:@"共%d件商品，实付￥%.2f",total,total_amount];
    NSString * firstString = [NSString stringWithFormat:@"共%d件商品，实付",total];
    NSMutableAttributedString * priceAttributeString = [[NSMutableAttributedString alloc]initWithString:content];
    [priceAttributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:11*self.scale] range:NSMakeRange(0, firstString.length)];
    [priceAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.459 green:0.459 blue:0.459 alpha:1.00] range:NSMakeRange(0, firstString.length)];
    totalLb.attributedText = priceAttributeString;
    //totalLb.text =[NSString stringWithFormat:@"%d",total];
    [footerView addSubview:totalLb];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10*self.scale,totalLb.bottom+10*self.scale, self.view.width-10*self.scale, .5)];
    line.backgroundColor=blackLineColore;
    [footerView addSubview:line];
    NSString* status=groupDic[@"order_detail"][0][@"status"];
    if ([status isEqualToString:@"-1"]) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(self.view.width-82.5*self.scale, line.bottom+7.5*self.scale, 72.5*self.scale, 30*self.scale);
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"bg_order"] forState:UIControlStateNormal];
        [rightBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(singleAgainClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.titleLabel.font = SmallFont(self.scale);
        [rightBtn setTitleColor:[UIColor colorWithRed:0.216 green:0.216 blue:0.196 alpha:1.00] forState:UIControlStateNormal];
        rightBtn.tag=SINGLE_AGAIN_TAG+section;
        [footerView addSubview:rightBtn];
    }else if ([status isEqualToString:@"1"]) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(self.view.width-82.5*self.scale, line.bottom+7.5*self.scale, 72.5*self.scale, 30*self.scale);
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"bg_order"] forState:UIControlStateNormal];
        [rightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(fuAndQUxiAO:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.titleLabel.font = SmallFont(self.scale);
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightBtn.tag=600+section;
        [footerView addSubview:rightBtn];
        UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quiXaioBtn.frame = CGRectMake(self.view.width-165*self.scale, rightBtn.top, 72.5*self.scale, 30*self.scale);
        quiXaioBtn.layer.cornerRadius = quiXaioBtn.height/2;
        quiXaioBtn.layer.borderWidth = .5;
        quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
        [quiXaioBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [quiXaioBtn addTarget:self action:@selector(fuAndQUxiAO:) forControlEvents:UIControlEventTouchUpInside];
        quiXaioBtn.titleLabel.font = SmallFont(self.scale);
        [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        quiXaioBtn.backgroundColor = [UIColor whiteColor];
        quiXaioBtn.tag=200+section;
        [footerView addSubview:quiXaioBtn];
    }else if ([status isEqualToString:@"2"] ){
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(self.view.width-82.5*self.scale, line.bottom+7.5*self.scale, 72.5*self.scale, 30*self.scale);
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"bg_order"] forState:UIControlStateNormal];
        [rightBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(singleAgainClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.titleLabel.font = SmallFont(self.scale);
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightBtn.tag=SINGLE_AGAIN_TAG+section;
        [footerView addSubview:rightBtn];
        UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quiXaioBtn.frame = CGRectMake(self.view.width-165*self.scale, line.bottom+7.5*self.scale, 72.5*self.scale, 30*self.scale);
        quiXaioBtn.layer.borderWidth = .5;
        quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
        [quiXaioBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [quiXaioBtn addTarget:self action:@selector(huodaoQuXiao:) forControlEvents:UIControlEventTouchUpInside];
        quiXaioBtn.titleLabel.font = SmallFont(self.scale);
        [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        quiXaioBtn.backgroundColor = [UIColor whiteColor];
        quiXaioBtn.layer.cornerRadius = quiXaioBtn.height/2;
        quiXaioBtn.tag=6000+section;
        [footerView addSubview:quiXaioBtn];
    }else if ([status isEqualToString:@"3"]|| [status isEqualToString:@"4"]){
        UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quiXaioBtn.frame =CGRectMake(self.view.width-82.5*self.scale, line.bottom+7.5*self.scale, 72.5*self.scale, 30*self.scale);
        [quiXaioBtn setBackgroundImage:[UIImage imageNamed:@"bg_order"] forState:UIControlStateNormal];
        [quiXaioBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [quiXaioBtn addTarget:self action:@selector(singleAgainClick:) forControlEvents:UIControlEventTouchUpInside];
        quiXaioBtn.titleLabel.font = SmallFont(self.scale);
        [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        quiXaioBtn.backgroundColor = blackLineColore;
        quiXaioBtn.tag=SINGLE_AGAIN_TAG+section;
        [footerView addSubview:quiXaioBtn];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(self.view.width-165*self.scale, quiXaioBtn.top, 72.5*self.scale, 30*self.scale);
        cancelBtn.layer.borderWidth = .5;
        cancelBtn.layer.borderColor = blackLineColore.CGColor;
        [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelByShipped:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.tag=400000+section;
        cancelBtn.titleLabel.font = SmallFont(self.scale);
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.layer.cornerRadius = cancelBtn.height/2;
        [footerView addSubview:cancelBtn];
    }else if([status isEqualToString:@"5"]){
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(self.view.width-82.5*self.scale, line.bottom+7.5*self.scale, 72.5*self.scale, 30*self.scale);
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"bg_order"] forState:UIControlStateNormal];
        [rightBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(singleAgainClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.titleLabel.font = SmallFont(self.scale);
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightBtn.tag=SINGLE_AGAIN_TAG+section;
        [footerView addSubview:rightBtn];
        
        UIButton *shanchu = [UIButton buttonWithType:UIButtonTypeCustom];
        shanchu.frame = CGRectMake(10*self.scale, line.bottom+7.5*self.scale, 72.5*self.scale, 30*self.scale);
        [shanchu setTitle:@"删除订单" forState:UIControlStateNormal];
        [shanchu addTarget:self action:@selector(daipingjiaEvent:) forControlEvents:UIControlEventTouchUpInside];
        shanchu.titleLabel.font = SmallFont(self.scale);
        [shanchu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        shanchu.tag=DELETE_ORDER_TAG+section;
        [footerView addSubview:shanchu];
    }else{
        UIButton *shanchu = [UIButton buttonWithType:UIButtonTypeCustom];
        shanchu.frame = CGRectMake(10*self.scale, line.bottom+7.5*self.scale, 72.5*self.scale, 30*self.scale);
        [shanchu setTitle:@"删除订单" forState:UIControlStateNormal];
        [shanchu addTarget:self action:@selector(daipingjiaEvent:) forControlEvents:UIControlEventTouchUpInside];
        shanchu.titleLabel.font = SmallFont(self.scale);
        [shanchu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        shanchu.tag=DELETE_ORDER_TAG+section;
        [footerView addSubview:shanchu];
    }
    return footerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (![Stockpile sharedStockpile].isLogin) {
        return nil;
    }
    NSDictionary* groupDic=_orderArray[section];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 45*self.scale)];
    //headerView.backgroundColor=[UIColor clearColor];
    headerView.userInteractionEnabled=YES;
    UIControl *mainView=[[UIControl alloc]initWithFrame:CGRectMake(0, 10*self.scale, self.view.width, 35*self.scale)];
    mainView.backgroundColor=[UIColor whiteColor];
    [mainView addTarget:self action:@selector(oderStBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    mainView.tag=ORDER_HEADER_TAG+section;
    [headerView addSubview:mainView];
    UIImageView* statusIv=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 48*self.scale, 15*self.scale)];
    NSInteger status=[groupDic[@"order_detail"][0][@"status"] integerValue];
    NSString *statusStr=@"";
    switch (status) {
        case -1:
            statusStr=@"order_thz";
            break;
        case 1:
            statusStr=@"order_dfk";
            break;
        case 2:
            statusStr=@"order_dfh";
            break;
        case 3:
        case 4:
            statusStr=@"order_psz";
            break;
        case 5:
            statusStr=@"order_ywc";
            break;
        case 6:
            statusStr=@"order_yqx";
            break;
    }
    [statusIv setImage:[UIImage imageNamed:statusStr]];
    [mainView addSubview:statusIv];
    UILabel *timeLa = [[UILabel alloc]initWithFrame:CGRectMake(statusIv.right+10*self.scale, statusIv.top, (self.view.width-statusIv.width-20*self.scale)/2, 15*self.scale)];
    NSString* time=groupDic[@"order_detail"][0][@"sub_create_time"];
    if(time.length>=5){
        time=[time substringFromIndex:5];
    }
    timeLa.text =time;
    timeLa.font = SmallFont(self.scale);
    [mainView addSubview:timeLa];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(timeLa.left,mainView.height-.5, self.view.width-timeLa.left, .5)];
    line.backgroundColor=blackLineColore;
    [mainView addSubview:line];
    return headerView;
}

-(void)oderStBtnEvent:(UIControl*)btn{
    NSLog(@"oderStBtnEvent4");
    id start = _orderArray[btn.tag-ORDER_HEADER_TAG];
    OrderDetailsViewController* details=[[OrderDetailsViewController alloc] init];
    details.hidesBottomBarWhenPushed=YES;
    details.orderId =start[@"order_detail"][0][@"order_no"];
    details.subOrderId =start[@"order_detail"][0][@"prods"][0][@"sub_order_no"];
    [self.navigationController pushViewController:details animated:YES];
}

-(void)fuAndQUxiAO:(UIButton *)sender{
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    if ([sender.titleLabel.text isEqualToString:@"立即付款"]) {
        NSMutableDictionary *orderDic=[NSMutableDictionary dictionary];
        [orderDic setObject:_orderArray[sender.tag-600][@"isOnLinePay"] forKey:@"isOnLinePay"];
        [orderDic setObject:_orderArray[sender.tag-600][@"order_detail"][0][@"order_no"] forKey:@"OrderID"];
        [orderDic setObject:_orderArray[sender.tag-600][@"order_detail"][0][@"total_amount"] forKey:@"AllMoney"];
        PaymentOrderViewController* paymentOrderView=[[PaymentOrderViewController alloc] init];
        paymentOrderView.hidesBottomBarWhenPushed=YES;
        paymentOrderView.orderDic=orderDic;
        [self.navigationController pushViewController:paymentOrderView animated:YES];
    }else{
        //取消
        [self ShowAlertTitle:nil Message:@"确认取消?" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                [self.view addSubview:self.activityVC];
                [self.activityVC startAnimate];//_orderArray[sender.tag-600][@"order_detail"][0][@"order_no"]
                NSDictionary *dic = @{@"user_id":self.user_id,@"order_no":_orderArray[sender.tag-200][@"order_detail"][0][@"order_no"]};
                AnalyzeObject *anle = [AnalyzeObject new];
                [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                    if ([code isEqualToString:@"0"]) {
                        if(![AppUtil isBlank:msg])
                            [self ShowAlertWithMessage:msg];
                       [self dropDownRefresh];
                    }else{
                        if([AppUtil isBlank:msg])
                            [AppUtil showToast:self.view withContent:@"取消失败"];
                        else{
                            [AppUtil showToast:self.view withContent:msg];
                        }
                    }
                }];
            }
        }];
    }
}

-(void)huodaoQuXiao:(UIButton *)sender{
    [self ShowAlertTitle:nil Message:@"确认取消?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            NSDictionary *dic = @{@"user_id":self.user_id,@"sub_order_no":_orderArray[sender.tag-6000][@"order_detail"][0][@"sub_order_no"],@"order_no":_orderArray[sender.tag-6000][@"order_no"]};
            //NSLog(@"cancelOrderWithDic_param==%@",dic);
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                if ([code isEqualToString:@"0"]) {
                    if(![AppUtil isBlank:msg])
                        [self ShowAlertWithMessage:msg];
                    [self dropDownRefresh];
                }else{
                    if([AppUtil isBlank:msg])
                        [AppUtil showToast:self.view withContent:@"取消失败"];
                    else{
                        [AppUtil showToast:self.view withContent:msg];
                    }
                }
            }];
        }
        [self.activityVC stopAnimate];
    }];
}

-(void)cancelByShipped:(UIButton *)btn{
    [self ShowAlertTitle:nil Message:@"确认取消?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            NSInteger tag = btn.tag-400000;
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            NSDictionary *dic = @{@"user_id":self.user_id,@"sub_order_no":_orderArray[tag][@"order_detail"][0][@"sub_order_no"],@"order_no":_orderArray[tag][@"order_no"]};
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                if ([code isEqualToString:@"0"]) {
                    if(![AppUtil isBlank:msg])
                        [self ShowAlertWithMessage:msg];
                    [self dropDownRefresh];
                }else{
                    if([AppUtil isBlank:msg])
                        [AppUtil showToast:self.view withContent:@"取消失败"];
                    else{
                        [AppUtil showToast:self.view withContent:msg];
                    }
                }
            }];
        }
    }];
}

-(void)daipingjiaEvent:(UIButton *)btn{
    [self.view addSubview:self.activityVC];
    [self ShowAlertTitle:nil Message:@"确认删除?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            [self.activityVC startAnimate];
            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":_orderArray[btn.tag-DELETE_ORDER_TAG][@"order_detail"][0][@"sub_order_no"]};
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle delOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                if ([code isEqualToString:@"0"]) {
                    [AppUtil showToast:self.view withContent:msg];
                    [self dropDownRefresh];
                }else{
                    [self ShowAlertWithMessage:msg];
                }
            }];
        }
    }];
}

- (void)skipSigning{
    if (![Stockpile sharedStockpile].isLogin) {
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {//登录成功后需要加载的数据
                    NSLog(@"登录成功");
                    //[self dropDownRefresh];
                }];
            }
        }];
        return;
    }
    NSString* fid=[NSString stringWithFormat:@"%@",_familyDic[@"FID"]];
    if([fid isEqualToString:@"0"]){
        SigningViewController* signingViewController=[[SigningViewController alloc] init];
        signingViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:signingViewController animated:YES];
    }else{
        FamilyViewController* familyViewController=[[FamilyViewController alloc] init];
        familyViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:familyViewController animated:YES];
    }
}

/*
 *再来一单
 */
-(void)singleAgainClick:(UIButton *)btn{
    [self ShowAlertTitle:nil Message:@"再来一单?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            [self.activityVC startAnimate];
            //NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            NSDictionary *dic = @{@"orderid":_orderArray[btn.tag-SINGLE_AGAIN_TAG][@"order_detail"][0][@"order_no"]};
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle reOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                if ([code isEqualToString:@"0"]) {
                    NSLog(@"reOrder==%@==%@",dic,models);
                    [self settleAccount:models];
                }
            }];
        }
    }];
}

-(void)settleAccount:(NSDictionary*) models{
    NSArray *dataSource=models[@"prodList"];
    if(dataSource.count==0){
        [self ShowAlertWithMessage:@"当前商品已下架"];
        return;
    }
    NSDictionary* dataDic=models[@"shopinfo"];
    NSMutableArray *settleArray=[NSMutableArray array];
    CGFloat amount=0.0;
    for(int i=0;i<dataSource.count;i++){
        NSMutableDictionary* dic=[dataSource[i] mutableCopy];
        [dic setObject:dataSource[i][@"prod_id"] forKey:@"pro_id"];
        [dic setObject:dataSource[i][@"prod_count"] forKey:@"pro_allnum"];
        [dic setObject:dataSource[i][@"price"] forKey:@"pro_price"];
        NSArray* imgs=dataSource[i][@"img"];
        if(imgs.count>0){
            NSString *string = [NSString stringWithFormat:@"%@",imgs[0]];
            NSArray *imgArr = [string componentsSeparatedByString:@","];
            [dic setObject:imgArr[0] forKey:@"pro_cover"];
        }
        amount+=[dataSource[i][@"price"] floatValue];
        NSInteger activityid=[[NSString stringWithFormat:@"%@",dic[@"activity_id"]] integerValue];
        if(activityid>0){
            NSInteger actmaxbuy=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"actmaxbuy"]] integerValue];
            NSInteger havedbuy=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"havedbuy"]] integerValue];
            if(actmaxbuy>0){
                NSInteger pro_allnum=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"pro_allnum"]] integerValue];
                NSInteger sub=pro_allnum-(actmaxbuy-havedbuy);
                if(sub>0){
                    if((actmaxbuy-havedbuy)>0){
                        [dic setObject:[NSNumber numberWithInteger:(actmaxbuy-havedbuy)] forKey:@"pro_allnum"];
                        [settleArray addObject:dic];
                    }
                    NSMutableDictionary* dic1=[dic mutableCopy];
                    [dic1 setObject:[NSNumber numberWithInteger:sub] forKey:@"pro_allnum"];
                    [dic1 setObject:[NSNumber numberWithInteger:0] forKey:@"activity_id"];
                    [settleArray addObject:dic1];
                }else{
                    [settleArray addObject:dic];
                }
            }else{
                [settleArray addObject:dic];
            }
        }else{
            [settleArray addObject:dic];
        }
    }
    CGFloat delivery_free=[dataDic[@"delivery_free"] floatValue];
    CGFloat delivery_fee=[dataDic[@"delivery_fee"] floatValue];
    CGFloat total=amount;
    if(amount<delivery_free){
        total+=delivery_fee;
    }
    NSMutableDictionary* settleDic=[NSMutableDictionary dictionary];
    [settleDic setObject:dataDic[@"delivery_fee"] forKey:@"delivery_fee"];
    [settleDic setObject:dataDic[@"delivery_free"] forKey:@"delivery_free"];
    [settleDic setObject:dataDic[@"shop_icon"] forKey:@"shop_icon"];
    [settleDic setObject:dataDic[@"shop_id"] forKey:@"shop_id"];
    [settleDic setObject:dataDic[@"shop_name"] forKey:@"shop_name"];
    [settleDic setObject:[NSString stringWithFormat:@"%.2f",amount] forKey:@"amount"];
    [settleDic setObject:[NSString stringWithFormat:@"%.2f",total] forKey:@"total"];
    
    NSLog(@"dic==%@",settleDic);
    OrderViewController *orde = [OrderViewController new];
    orde.hidesBottomBarWhenPushed=YES;
    orde.dataArray = settleArray;
    orde.dataDic=settleDic;
    orde.couponDic=models[@"coupon"];
    orde.isReOrder=YES;
    // orde.gouwucheData=_dataSource;
    [self.navigationController pushViewController:orde animated:YES];
}

-(UILabel*)footerView{
    UILabel* footer=[[UILabel alloc]initWithFrame:CGRectMake(0, 10*self.scale,self.view.width,40*self.scale)];
    footer.text=@"----  更多订单请至我的订单查看  ----";
    footer.font=SmallFont(self.scale*0.8);
    footer.textColor=[UIColor colorWithRed:0.686 green:0.686 blue:0.690 alpha:1.00];
    footer.textAlignment=NSTextAlignmentCenter;
    return footer;
}

@end
