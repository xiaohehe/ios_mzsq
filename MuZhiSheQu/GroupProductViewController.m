//
//  GroupProductViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GroupProductViewController.h"
#import "ShangPinTableViewCell.h"
#import "DataBase.h"
#import "ShopInfoViewController.h"
#import "AppUtil.h"

static const NSUInteger ADD_CART_TAG = 100000;//增加购物车商品数量
static const NSUInteger CART_NUM_TAG = 200000;//购物车商品数量
static const NSUInteger SUB_CART_TAG = 300000;//减少购物车商品数量
@interface GroupProductViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UIImageView *bottomR,*bottomL;
@property(nonatomic,strong)UIView *botROne,*botRTwo;
@property(nonatomic,strong)UIButton * numberImg;
@property(nonatomic,strong)UILabel * peiSongLab;
@end

@implementation GroupProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource=[NSMutableArray new];
    self.view.backgroundColor=[UIColor whiteColor];
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    //[self reshData];
    [self requestShopingCart:true];
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=_dataDic[@"GroupName"];
    self.TitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15*self.scale];
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    UIView *botline = [[UIView alloc]initWithFrame:CGRectMake(0, [self getStartHeight]+44-.5, self.view.width, .5)];
    botline.backgroundColor=blackLineColore;
    [self.NavImg addSubview:botline];
}

-(void)PopVC:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)newView{
    _tableView=[[UITableView  alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom-43.5*self.scale-self.dangerAreaHeight)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[ShangPinTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}

-(void)reshData{
    AnalyzeObject *anle =[AnalyzeObject new];
    NSString * shopid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"]];
    NSDictionary *dic = @{@"shopid":shopid,@"groupid":_dataDic[@"GroupID"]};
    [anle getProductGroupDetailWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        //NSLog(@"getProductGroupDetailWithDic==%@",models);
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            [self bottomVi];
            [_dataSource addObjectsFromArray:models];
        }
        [_tableView reloadData];
    }];
}

#pragma mark-------底部UI设置，购物车。
-(void)bottomVi{
    if (_bottomR) {
        [_bottomR removeFromSuperview];
    }
    //右边购物车
    self.bottomR = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-58*self.scale-self.dangerAreaHeight, self.view.bounds.size.width, 58*self.scale+self.dangerAreaHeight)];
    self.bottomR.userInteractionEnabled = YES;
    //[self.bottomR setImage:[UIImage imageNamed:@"cart_bottom"]];
    //    [self.bottomR.backgroundColor =
    [self.view addSubview:_bottomR];
    if (_botRTwo) {
        [_botRTwo removeFromSuperview];
    }
    UIImageView* botTop=[[UIImageView alloc]initWithFrame:CGRectMake(12*self.scale,0, 42*self.scale, 12*self.scale)];
    [botTop setImage:[UIImage imageNamed:@"settle_top"]];
    [self.bottomR addSubview:botTop];
    self.botRTwo = [[UIView alloc]initWithFrame:CGRectMake(0,botTop.bottom, self.view.bounds.size.width, self.bottomR.height-botTop.height)];
    self.botRTwo.backgroundColor=[UIColor colorWithPatternImage: [UIImage imageNamed:@"settle_bottom"]];
    //_botRTwo.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    [self.bottomR addSubview:_botRTwo];
    UIButton *shopcarImgL = [[UIButton alloc]initWithFrame:CGRectMake(13*self.scale, 5, 40*self.scale, 40*self.scale)];
    [shopcarImgL setBackgroundImage:[UIImage imageNamed:@"shopping_cart2"] forState:UIControlStateNormal];
    [shopcarImgL addTarget:self action:@selector(godingdan) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomR addSubview:shopcarImgL];
    //购物车左上角的红色数字;
    _numberImg = [[UIButton alloc]initWithFrame:CGRectMake(shopcarImgL.width-15*self.scale,3*self.scale-5, 15*self.scale, 15*self.scale)];
    _numberImg.backgroundColor = [UIColor redColor];
    _numberImg.layer.cornerRadius=_numberImg.width/2;
    NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
    if (value==nil||[value isEqualToString:@""]||[value isEqualToString:@"0"]){
        _numberImg.hidden=YES;
    }else{
        [_numberImg setTitle:[NSString stringWithFormat:@"%@",value] forState:UIControlStateNormal];
        _numberImg.hidden=NO;
    }
    _numberImg.titleLabel.font = Small10Font(self.scale);
    [shopcarImgL addSubview:_numberImg];
    float r = shopcarImgL.right;
    //float t = shopcarImgL.top;
    _peiSongLab = [[UILabel alloc]initWithFrame:CGRectMake(r+5*self.scale, 14*self.scale, [UIScreen mainScreen].bounds.size.width - r - 110*self.scale, 20*self.scale)];
    _peiSongLab.text = [self xianShiPeiSongFei];
    _peiSongLab.font = Small10Font(self.scale);
    _peiSongLab.textColor = [UIColor whiteColor];
    [self.botRTwo addSubview:_peiSongLab];
    UIButton *shopCarR = [UIButton buttonWithType:UIButtonTypeSystem];
    shopCarR.frame = CGRectMake([UIScreen mainScreen].bounds.size.width -80*self.scale , 0, 80*self.scale, 46*self.scale+self.dangerAreaHeight);
    //    shopCarR.layer.cornerRadius = 3.0f;
    shopCarR.tag=907;
    //    shopCarR.userInteractionEnabled=NO;
    [shopCarR setBackgroundColor:[UIColor colorWithRed:1.000 green:0.867 blue:0.306 alpha:1.00]];
    [shopCarR setTitle:@"去结算" forState:UIControlStateNormal];
    shopCarR.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    [shopCarR setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shopCarR addTarget:self action:@selector(godingdan) forControlEvents:UIControlEventTouchUpInside];
    
    CAGradientLayer *gradientLayer=[CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:1.000 green:0.925 blue:0.000 alpha:1.00].CGColor, (__bridge id)[UIColor colorWithRed:0.996 green:0.800 blue:0.000 alpha:1.00].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, shopCarR.width , shopCarR.height);
    [shopCarR.layer insertSublayer:gradientLayer atIndex:0];
    
    [self.botRTwo addSubview:shopCarR];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _bottomL.top, self.view.width, .5)];
    line.backgroundColor=blackLineColore;
    [self.view addSubview:line];
}

-(void)godingdan{
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- 显示配送费
- (NSString *)xianShiPeiSongFei{
    NSString * string = [NSString stringWithFormat:@"已消费:￥%.2f",[self jiSuanAmount]];
    return string;
}


#pragma mark -- 计算总价格
- (CGFloat)jiSuanAmount{
    CGFloat amount = 0.0;
    NSString* shop_id= [[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"];
    NSArray* array= [[DataBase sharedDataBase] getAllFromCart:shop_id];
    //NSArray* array=[[DataBase sharedDataBase] getAllFromCart];
    for (NSDictionary *ShopInfo in array) {
        NSMutableArray *arr = [[ShopInfo objectForKey:@"prolist"] mutableCopy];
        for (NSDictionary *prodDic in arr) {
            amount = amount + [prodDic[@"pro_price"] floatValue]*[prodDic[@"pro_allnum"] integerValue];
        }
    }
    return amount;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*self.scale;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShangPinTableViewCell *cell=(ShangPinTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray* imgs=_dataSource[indexPath.row][@"imgs"];
    if(imgs.count>0){
        NSString *string = [NSString stringWithFormat:@"%@",imgs[0]];
        NSArray *imgArr = [string componentsSeparatedByString:@"|"];
        NSString *smallImgUrl = imgArr[0];
        [cell.HeaderImage setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
    }else{
        [cell.HeaderImage setImage:[UIImage imageNamed:@"za"]];
    }
    
    cell.NameLabel.text=_dataSource[indexPath.row][@"prodname"];
    NSString *xiao = @"";
    if([AppUtil isBlank:[_dataSource[indexPath.row] objectForKey:@"description"]])
        xiao=[_dataSource[indexPath.row] objectForKey:@"prodname"];
    else
        xiao=[_dataSource[indexPath.row] objectForKey:@"description"];
    cell.NumberLabel.text=xiao;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGFloat pri=[[_dataSource[indexPath.row] objectForKey:@"price"] floatValue];
    NSString * priceString = [NSString stringWithFormat:@"￥%.2f/%@",pri,_dataSource[indexPath.row][@"unit"]];
    NSString * firstString = [NSString stringWithFormat:@"%.2f",pri];
    NSMutableAttributedString * priceAttributeString = [[NSMutableAttributedString alloc]initWithString:priceString];
    [priceAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*self.scale] range:NSMakeRange(1, firstString.length)];
    cell.PriceLabel.attributedText = priceAttributeString;
    NSString *prod_id = _dataSource[indexPath.row][@"prod_id"];
    int index=[self.appdelegate.shopDictionary[@([prod_id intValue])] intValue];
    cell.numLb.text=[NSString stringWithFormat:@"%d",index];
    if (index==0) {
        cell.subBtn.hidden=YES;
        cell.numLb.hidden=YES;
    }else{
        cell.subBtn.hidden=NO;
        cell.numLb.hidden=NO;
    }
    cell.addBt.tag=ADD_CART_TAG+indexPath.row;
    cell.numLb.tag=CART_NUM_TAG+indexPath.row;
    cell.subBtn.tag=SUB_CART_TAG+indexPath.row;
    [cell.addBt addTarget:self action:@selector(changeShopingCartNum:) forControlEvents:UIControlEventTouchUpInside];
    [cell.subBtn addTarget:self action:@selector(changeShopingCartNum:) forControlEvents:UIControlEventTouchUpInside];
    cell.coverView.hidden=YES;
    if((_dataSource.count-indexPath.row)==1){
        cell.lineView.hidden=YES;
    }else{
        cell.lineView.hidden=NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopInfoViewController *buess = [ShopInfoViewController new];
    if ([_dataSource[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
        buess.isopen=NO;
    }else{
        buess.isopen=YES;
    }
    buess.isgo=YES;
    buess.yes=NO;
    buess.tel=[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"hotline"]];
    buess.price =_dataSource[indexPath.row][@"prod_price"];
    buess.shop_name=_dataSource[indexPath.row][@"shop_name"];
    buess.orshoucang=YES;
    buess.shop_user_id=_dataSource[indexPath.row][@"shop_id"];//shop_user_id
    NSLog(@"%@",_dataSource[indexPath.row][@"shop_user_id"]);
    buess.shop_id = _dataSource[indexPath.row][@"shop_id"];
    buess.prod_id = _dataSource[indexPath.row][@"prod_id"];
    buess.xiaoliang = _dataSource[indexPath.row][@"sales"];
    buess.shoucang = _dataSource[indexPath.row][@"collect_time"];
    NSLog(@"shop_id==%@",_dataSource[indexPath.row][@"shop_id"]);
    buess.gongGao = _dataSource[indexPath.row][@"notice"];
    buess.param=_dataSource[indexPath.row];
    [self.navigationController pushViewController:buess animated:YES];
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
            [self reshData];
    }else{
        //[self.appdelegate.shopDictionary removeAllObjects];
        if(isRefresh)
            [self reshData];
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
    NSInteger isOffLine=[[NSString stringWithFormat:@"%@",self.appdelegate.shopInfoDic[@"is_off_online"]] integerValue];
    if(isOffLine==1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"临时歇业中"
                                                            message:@"暂停营业。很快回来^_^!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }else if(![AppUtil isDoBusiness:self.appdelegate.shopInfoDic]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"歇业中"
                                                            message:[NSString stringWithFormat:@"%@",self.appdelegate.shopInfoDic[@"onlinemark"]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSInteger tag=btn.tag;
    NSInteger index=-1;//商品项，为了获取商品id
    UIButton* subBtn=nil;
    UILabel* numLb=nil;
    BOOL isAdd=true;
    if (tag<CART_NUM_TAG) {
        index=tag-ADD_CART_TAG;//tag-100000;
        numLb=(UILabel *)[self.view viewWithTag:CART_NUM_TAG+index];
    }else{
        index=btn.tag-SUB_CART_TAG;
        numLb=(UILabel *)[self.view viewWithTag:CART_NUM_TAG+index];
        isAdd=false;
    }
    subBtn=(UIButton *)[self.view viewWithTag:SUB_CART_TAG+index];
    NSDictionary* goods=_dataSource[index];
    NSMutableDictionary* par=[goods mutableCopy];
    [par setObject:goods[@"shopid"] forKey:@"shop_id"];
    [par setObject:_shopData[@"shopname"] forKey:@"shop_name"];
    [par setObject:_shopData[@"logo"] forKey:@"shop_logo"];
    [par setObject:_shopData[@"free_delivery_amount"] forKey:@"free_delivery_amount"];
    [par setObject:_shopData[@"delivery_fee"] forKey:@"delivery_fee"];
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
        //NSLog(@"param=-=-1111=%d==%@",num,self.appdelegate.shopDictionary);
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
    _peiSongLab.text = [self xianShiPeiSongFei];
    [self gouWuCheShuZi];
}

#pragma mark -- 购物车的数字
- (void)gouWuCheShuZi
{
    UITabBarItem * item=[self.appdelegate.tabBarController.tabBar.items objectAtIndex:2];
    //    if ([Stockpile sharedStockpile].isLogin)
    //    {
    NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
    NSLog(@"%@",value);
    if (value==nil||[value isEqualToString:@""]||[value isEqualToString:@"0"])
    {
        //[item setBadgeValue:nil];
        [item setBadgeValue:@"0"];
        _numberImg.hidden=YES;
    }
    else
    {
        [_numberImg setTitle:[NSString stringWithFormat:@"%@",value] forState:UIControlStateNormal];
        _numberImg.hidden=NO;
        [item setBadgeValue:value];
    }
    //    }else{
    //        //[item setBadgeValue:nil];
    //        [item setBadgeValue:@"0"];
    //    }
}


@end
