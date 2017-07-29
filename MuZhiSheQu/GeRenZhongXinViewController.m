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

@interface GeRenZhongXinViewController()<UITableViewDataSource,UITableViewDelegate,RCIMReceiveMessageDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)UIView *LoginView;
@property(nonatomic,strong)UIImageView *HeaderImg;
@end
@implementation GeRenZhongXinViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    
//    if (![Stockpile sharedStockpile].isLogin) {
//        UINavigationController *navView=[[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
//       LoginViewController *login = [[LoginViewController alloc]init];
//        login.first=@"1";
//        [self presentViewController:login animated:YES completion:nil];
//       
//    }
    
  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logok) name:@"logsuccedata" object:nil];

    [self newNav];
    [self newView];
    [self newLogin];
    //[self newMeView];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return  UIStatusBarStyleLightContent;
}


-(void)logok{
//    [self newNav];
    [self newView];
    [self newLogin];
    [self gongGaoDian];
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self ReshMessage];
    [RCIM sharedRCIM].disableMessageAlertSound=NO;
    [self gouWuCheShuZi];
    self.navigationController.navigationBarHidden=YES;
    [RCIM sharedRCIM].receiveMessageDelegate=self;

    NSString *commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    
    NSLog(@"%@",commid);
    
    if ([commid isEqualToString:@"0"] && [Stockpile sharedStockpile].isLogin==YES) {
        
        
            self.hidesBottomBarWhenPushed=YES;
            SheQuManagerViewController *shequ = [SheQuManagerViewController new];
            shequ.nojiantou=NO;
            [self.navigationController pushViewController:shequ animated:NO];
            self.hidesBottomBarWhenPushed=NO;

    }

}

-(void)newLogin{
    if (_LoginView) {
        [_LoginView removeFromSuperview];
    }
    _LoginView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, _HeaderImg.width, _HeaderImg.height)];
    
    
//  NSString *str =  [[NSUserDefaults standardUserDefaults]objectForKey:@"touxiang" ];
//    
//    NSLog(@"%@",str);
//    if (<#condition#>) {
//        <#statements#>
//    }
    
    
//    RCUserInfo *_currentUserInfo = [[RCUserInfo alloc]initWithUserId:[self getuserid] name:[Stockpile sharedStockpile].nickName portrait:[NSString stringWithFormat:@"%@",str]];
//    [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
//    [RCIM sharedRCIM].currentUserInfo=_currentUserInfo;
    
    UIButton *Image=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2-40*self.scale, 5*self.scale, 80*self.scale, 80*self.scale)];
    Image.layer.masksToBounds=YES;
    Image.layer.cornerRadius=Image.height/2;
    if ([Stockpile sharedStockpile].isLogin) {
        Image.userInteractionEnabled=YES;
        Image.selected=YES;
        [Image setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[Stockpile sharedStockpile].logo] placeholderImage:[UIImage imageNamed:@"not_1"]];
    }else{
            Image.userInteractionEnabled=YES;
        Image.selected=NO;
        [Image setBackgroundImage:[UIImage imageNamed:@"not_1"] forState:UIControlStateNormal];
    }
    [Image addTarget:self action:@selector(gozhanghumanager:) forControlEvents:UIControlEventTouchUpInside];
    [_LoginView addSubview:Image];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(_LoginView.width/2-40*self.scale, Image.bottom+5*self.scale, 80*self.scale, 25*self.scale)];
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    [button setBackgroundImage:[UIImage setImgNameBianShen:@"center_index_btn"] forState:UIControlStateNormal];
    if ([Stockpile sharedStockpile].isLogin) {
        [button setTitle:[Stockpile sharedStockpile].nickName forState:UIControlStateNormal];
        button.userInteractionEnabled=NO;
        [button setBackgroundImage:[UIImage setImgNameBianShen:@""] forState:UIControlStateNormal];
        button.titleLabel.textAlignment=NSTextAlignmentCenter;

        button.frame = CGRectMake(0, Image.bottom+5*self.scale, _LoginView.width, 25*self.scale);
        
    }else{
        [button setTitle:@"登录/注册" forState:UIControlStateNormal];
    }
    //[button setTitle:[Stockpile sharedStockpile].nickName forState:UIControlStateSelected];
    [button addTarget:self action:@selector(LoginViewEvent:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=DefaultFont(self.scale);
    [_LoginView addSubview:button];
    
    [_HeaderImg addSubview:_LoginView];
}
-(void)gozhanghumanager:(UIButton *)btn{
    
    if (btn.selected==NO) {
        [self ShowAlertWithMessage:@"请先登录"];
        
        return;
    }
    
    self.hidesBottomBarWhenPushed=YES;
    ZhangHuGuanLiViewController *zhang = [ZhangHuGuanLiViewController new];
    [self.navigationController pushViewController:zhang animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

-(void)newMeView{
    if (_LoginView) {
        [_LoginView removeFromSuperview];
    }
    [self ReshMessage];
    _LoginView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, _HeaderImg.width, _HeaderImg.height)];
    
    UIImageView *Image=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width/2-40*self.scale, 5*self.scale, 80*self.scale, 80*self.scale)];
    Image.layer.masksToBounds=YES;
    Image.layer.cornerRadius=Image.height/2;
    //Image.image=[UIImage imageNamed:@"center_img"];
    [Image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@""]] placeholderImage:[UIImage imageNamed:@"center_img"]];
    [_LoginView addSubview:Image];
    
    UILabel *Name=[[UILabel alloc]initWithFrame:CGRectMake(40*self.scale, Image.bottom+5*self.scale, self.view.width-80*self.scale, 20*self.scale)];
    Name.textAlignment=NSTextAlignmentCenter;
    Name.textColor=[UIColor whiteColor];
    Name.font=DefaultFont(self.scale);
//    Name.text=@"你是个兄啊";
    [_LoginView addSubview:Name];
    
    UILabel *Adress=[[UILabel alloc]initWithFrame:CGRectMake(Name.left, Name.bottom, Name.width, 15*self.scale)];
    Adress.textAlignment=NSTextAlignmentCenter;
    Adress.textColor=Name.textColor;
    Adress.font=SmallFont(self.scale);
//    Adress.text=@"招银大厦2105郑州软盟";
    [_LoginView addSubview:Adress];
    [_HeaderImg addSubview:_LoginView];
}


-(void)headView{
    UIView *HeaderView=[[UIView alloc]init];
    HeaderView.backgroundColor=[UIColor whiteColor];
    _HeaderImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 130*self.scale)];
    _HeaderImg.backgroundColor=blueTextColor;
    [HeaderView addSubview:_HeaderImg];
    _HeaderImg.userInteractionEnabled = YES;
    //NSArray *buttonArr=@[@[@"center_index_ico_01",@"center_index_ico_02",@"center_index_ico_03"],@[@"收藏的商品",@"收藏的店铺",@"我的公告"]];
     NSArray *buttonArr=@[@[@"center_index_ico_01",@"center_index_ico_03"],@[@"收藏的商品",@"我的公告"]];
    for (int i=0; i<2; i++)
    {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(i*self.view.width/2, _HeaderImg.bottom, self.view.width/2, 44*self.scale)];
        button.tag = i;
        UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake(8*self.scale, button.height/2-10*self.scale, 20*self.scale, 20*self.scale)];
        logo.contentMode=UIViewContentModeScaleToFill;
        logo.image=[UIImage imageNamed:buttonArr[0][i]];
        [button addSubview:logo];
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(logo.right+3*self.scale, logo.top, button.width-logo.right-2*self.scale, logo.height)];
        title.text=buttonArr[1][i];
        title.font=DefaultFont(self.scale);
        [button addSubview:title];
       [button addTarget:self action:@selector(ButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [HeaderView addSubview:button];
    }
    HeaderView.frame=CGRectMake(0, 0, self.view.width, 174*self.scale);
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, HeaderView.height-.5, self.view.width, .5)];
    line.backgroundColor=blackLineColore;
    [HeaderView addSubview:line];
    _tableView.tableHeaderView =HeaderView;
}

-(void)newView{
    if (_tableView) {
        [_tableView removeFromSuperview];
    }
//    _dataSource=@[@[@"我的订单",@"服务类订单",@"我的购物车"],@[@"收货地址",@"所属社区管理",@"二手闲置",@"我要开店"],@[@"软件设置"]];
    _dataSource=@[@[@"我的订单"],@[@"收货地址",@"我要开店"],@[@"软件设置"]];
//@[@[@"我的订单"],@[@"收货地址",@"所属社区管理",@"二手闲置",@"我要开店"],@[@"软件设置"]];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, [UIScreen mainScreen].bounds.size.height-self.NavImg.bottom-49)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[CenterCell class] forCellReuseIdentifier:@"CenterCell"];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self headView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_dataSource objectAtIndex:section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *imgArr=@[@[@"center_index_ico_04",@"center_index_ico_06"],@[@"center_index_ico_07",@"center_index_ico_09"],@[@"center_index_ico_10"]];//@[@[@"center_index_ico_04",@"center_index_ico_06"],@[@"center_index_ico_07",@"center_index_ico_08",@"vvz",@"center_index_ico_09"],@[@"center_index_ico_10"]];

//    NSArray *imgArr=@[@[@"center_index_ico_04",@"center_index_ico_05",@"center_index_ico_06"],@[@"center_index_ico_07",@"center_index_ico_08",@"vvz",@"center_index_ico_09"],@[@"center_index_ico_10"]];
    CenterCell *Cell=(CenterCell *)[tableView dequeueReusableCellWithIdentifier:@"CenterCell" forIndexPath:indexPath];
    Cell.titleLabel.text = _dataSource[indexPath.section][indexPath.row];
    Cell.headImage.image=[UIImage imageNamed:imgArr[indexPath.section][indexPath.row]];
    Cell.hiddenLine= (indexPath.row ==[[imgArr objectAtIndex: indexPath.section] count]-1);
    Cell.indexPath = indexPath;
    Cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return Cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 10*self.scale)];
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, view.height-.5, self.view.width, .5)];
    line.backgroundColor=blackLineColore;
    view.backgroundColor=superBackgroundColor;
    [view addSubview:line];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section ==1  && indexPath.row == 1) {
        
        self.hidesBottomBarWhenPushed=YES;
        WoYaoKaiWiDianViewController *woyao = [WoYaoKaiWiDianViewController new];
        [self.navigationController pushViewController:woyao animated:YES];
        woyao.dian=YES;
        self.hidesBottomBarWhenPushed=NO;
        return;
    }
    if (![Stockpile sharedStockpile].isLogin && indexPath.section!=2) {
        [self ShowAlertWithMessage:@"请先登录"];
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed=YES;
    if (indexPath.section ==0  && indexPath.row == 0) {
        ShopLingShouViewController *lingShou=[[ShopLingShouViewController alloc]init];
        lingShou.ispop=YES;
        [self.navigationController pushViewController:lingShou animated:YES];
    }
    
//    if (indexPath.section ==0  && indexPath.row == 1) {
//      FuWuLeiDingDanViewController *lingShou=[[FuWuLeiDingDanViewController alloc]init];
//        [self.navigationController pushViewController:lingShou animated:YES];
//    }
    
    if (indexPath.section ==0  && indexPath.row == 1) {
      GouWuCheViewController *lingShou=[[GouWuCheViewController alloc]init];
        [self.navigationController pushViewController:lingShou animated:YES];
    }
    
    if (indexPath.section ==1  && indexPath.row == 0) {
        ShouHuoDiZhiListViewController *lingShou=[[ShouHuoDiZhiListViewController alloc]init];
        [self.navigationController pushViewController:lingShou animated:YES];
    }
    
    if (indexPath.section ==1  && indexPath.row == 1) {
        SheQuManagerViewController *lingShou=[[SheQuManagerViewController alloc]init];
        lingShou.nojiantou=YES;
        [self.navigationController pushViewController:lingShou animated:YES];
    } 
       if (indexPath.section ==1  && indexPath.row == 2) {
        WoDeGongGaoViewController *wode = [WoDeGongGaoViewController new];
        wode.isErShou=YES;
        [self.navigationController pushViewController:wode animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        SettingViewController *setVC=[[SettingViewController alloc]init];
        [self.navigationController pushViewController:setVC animated:YES];
    }
    self.hidesBottomBarWhenPushed=NO;
}
#pragma mark - 按钮事件
-(void)ButtonEvent:(UIButton *)button{
    
    if (![Stockpile sharedStockpile].isLogin) {
        [self ShowAlertWithMessage:@"请先登录"];
        return;
    }
    
    
    self.hidesBottomBarWhenPushed=YES;
    if (button.tag==1)
    {
        WoDeGongGaoViewController *gonggaoVc=[[WoDeGongGaoViewController alloc]init];
        [self.navigationController pushViewController:gonggaoVc animated:YES];
    }
//    else if (button.tag==1){
//        ShouCangDianPuViewController *dianpuVc=[[ShouCangDianPuViewController alloc]init];
//        [self.navigationController pushViewController:dianpuVc animated:YES];
//    }
    else{
        ShouCangShangPinViewController *shangpinVc=[[ShouCangShangPinViewController alloc]init];
        [self.navigationController pushViewController:shangpinVc animated:YES];
    }
    
    self.hidesBottomBarWhenPushed=NO;
}
-(void)LoginViewEvent:(UIButton *)button{

    UINavigationController *navView=[[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init] ];
    [self presentViewController:navView animated:YES completion:nil];
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ReshMessage];
        [self.appdelegate appNum];

    });
    
}
-(void)ReshMessage{
    int unreadMsgCount =[self.appdelegate ReshData];
    UILabel *CarNum=(UILabel *)[self.view viewWithTag:666];
    if (unreadMsgCount>0) {
        CarNum.hidden=NO;
        CarNum.text=[NSString stringWithFormat:@"%d",unreadMsgCount];
        if (unreadMsgCount>99) {
            CarNum.text=[NSString stringWithFormat:@"99+"];
        }
//        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:[CarNum.text intValue]];

    }else{
//        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
        CarNum.hidden=YES;
    }
}

#pragma mark -- 购物车的数字
- (void)gouWuCheShuZi
{
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
    //    }
    //    else
    //    {
    //        [item setBadgeValue:nil];
    //    }
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"个人中心";
    self.TitleLabel.textColor  = [UIColor whiteColor];
    self.NavImg.backgroundColor = blueTextColor;
    
    UIButton *talkImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [talkImg setImage:[UIImage imageNamed:@"lt"] forState:UIControlStateNormal];
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
    CarNum.tag=666;
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
    
    
    self.hidesBottomBarWhenPushed=YES;
    RCDChatListViewController *rong = [[RCDChatListViewController alloc]init];
    [self.navigationController pushViewController:rong animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
@end
