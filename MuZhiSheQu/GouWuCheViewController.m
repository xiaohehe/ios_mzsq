//
//  GouWuCheViewController.m
//  LunTai
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "GouWuCheViewController.h"
#import "GouWuCheTableViewCell.h"
#import "UmengCollection.h"
#import "BreakInfoViewController.h"
#import "DataBase.h"
#import "AppUtil.h"
#import "LoginViewController.h"
#import "RCDChatListViewController.h"

@interface GouWuCheViewController()<UITableViewDataSource,UITableViewDelegate,GouWuCheTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource,*btnArr,*data;
@property(nonatomic,strong)NSMutableDictionary *Dic;
@property(nonatomic,assign)BOOL isHasPreson;
@property(nonatomic,strong)UIButton *selectedBtn;
@property (nonatomic,strong)NSMutableDictionary *dataDic;
@property (nonatomic,strong)NSMutableDictionary *quanXuanDic,*bigbigd;
@property(nonatomic,strong)UIView *bigVi;
@property(nonatomic,strong)UIImageView *otherIv;
@property(nonatomic,strong)UILabel *otherLb;
@property(nonatomic,strong) UIButton *otherBtn;
@property(nonatomic,strong)UILabel *goShop;
@property (nonatomic,strong)NSMutableArray *daArr;
@property (nonatomic,strong)NSMutableDictionary *GoodsListDic;
@property (nonatomic,strong)NSMutableDictionary * goodsPriceDic;
@property(nonatomic,strong) UIButton *editBtn;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong)UILabel *totalPriceLb;
@property(nonatomic,strong)UILabel *shippingFeeLb;
@property(nonatomic,strong) UIButton *settleAccountBtn;
@property(nonatomic,strong) UIView *delView;
@property(nonatomic,strong) UIButton *checkAllBtn;
@property(nonatomic,strong) UIButton *delBtn;
@property(nonatomic,strong)NSMutableArray *clearingArray,*delArray;

@end
@implementation GouWuCheViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    [self ReshData];
    [UmengCollection intoPage:NSStringFromClass([self class])];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    _daArr = [[NSMutableArray alloc] init];
    _dataDic = [[NSMutableDictionary alloc] init];
    _quanXuanDic = [[NSMutableDictionary alloc] init];
    _bigbigd=[NSMutableDictionary new];
    _data=[NSMutableArray new];
    _dataSource=[[NSMutableArray alloc]init];
    _Dic=[[NSMutableDictionary alloc]init];
    _btnArr=[[NSMutableArray alloc]init];
    _GoodsListDic=[NSMutableDictionary new];
    _goodsPriceDic = [NSMutableDictionary new];
    if(_isShowBack)
      [ self returnVi];
    [self newNav];
    [self newView];
    [self newBottomView];
    _clearingArray=[[NSMutableArray alloc]init];
    _delArray=[[NSMutableArray alloc]init];
}

-(void)jixugouwu{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark------全选按钮
-(void)SelectedEvent{
//    button.selected=!button.selected;
    UIButton *button = (UIButton *)[self.view viewWithTag:6666];
    button.selected=!button.selected;
    if (button.selected)
    {
    for (NSDictionary *ShopInfo in _dataSource) {
            NSMutableArray *arr = [[ShopInfo objectForKey:@"prod_info"] mutableCopy];
            for (NSDictionary *prodDic in arr) {
                 NSString *key = [NSString stringWithFormat:@"%@",prodDic[@"prod_id"]];
                if (![prodDic[@"prod_count"] isEqualToString:@"0"]) {
                    [_GoodsListDic setObject:prodDic forKey:key];
                }
            }
        }
    }else{
        [_GoodsListDic removeAllObjects];
    }
    [_tableView reloadData];
    UILabel * carLa = (UILabel *)[_bigVi viewWithTag:100];
    NSString * heJiString = [NSString stringWithFormat:@"合计:￥%.2f",[self jiSuanAmount]];
    CGRect rect = [self getStringWithFont:12*self.scale withString:heJiString withWith:[UIScreen mainScreen].bounds.size.width];
    carLa.frame = CGRectMake(self.view.width - rect.size.width - 90*self.scale-10, _bigVi.height/2-10*self.scale, rect.size.width+30, 20*self.scale);
    carLa.attributedText = [self getAmountFuWenBenWithStirng:heJiString];
}

-(void) goShoping {
    NSLog(@"goshoping_id==%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"shop_id"]);
    self.hidesBottomBarWhenPushed = YES;
    BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
    info.ID = [[NSUserDefaults standardUserDefaults] objectForKey:@"shop_id"];
    info.shop_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"shop_id"];
    [self.navigationController pushViewController:info animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)removeOtherView{
    if (_otherIv) {
        [_otherIv removeFromSuperview];
    }
    if (_otherLb) {
        [_otherLb removeFromSuperview];
    }
    if (_otherBtn) {
        [_otherBtn removeFromSuperview];
    }
}

-(void) otherView{
    if (!_otherIv) {
        _otherIv = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width/2-20*self.scale, self.NavImg.bottom+80*self.scale, 40*self.scale, 40*self.scale)];
    }
    [self.view addSubview:_otherIv];
    if (!_otherLb) {
        _otherLb = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+130*self.scale, self.view.width, 30*self.scale)];
        _otherLb.textAlignment=NSTextAlignmentCenter;
        _otherLb.font=SmallFont(self.scale*0.8);
        _otherLb.textColor=[UIColor colorWithRed:0.247 green:0.247 blue:0.247 alpha:1.00];
    }
    [self.view addSubview:_otherLb];
    if (!_otherBtn) {
        _otherBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2-75*self.scale, self.otherLb.bottom+10*self.scale, 150*self.scale, 53*self.scale)];
        [_otherBtn setBackgroundImage:[UIImage imageNamed:@"other"] forState:UIControlStateNormal];
        [_otherBtn setBackgroundImage:[UIImage imageNamed:@"other"] forState:UIControlStateHighlighted];
        [_otherBtn setBackgroundImage:[UIImage imageNamed:@"other"] forState:UIControlStateSelected];
        [_otherBtn setTitleColor:[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00] forState:UIControlStateNormal];
        [_otherBtn setTitleColor:[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00] forState:UIControlStateSelected];
        [_otherBtn addTarget:self action:@selector(loginOrShopping) forControlEvents:UIControlEventTouchUpInside];
        _otherBtn.titleLabel.font=[UIFont systemFontOfSize:13*self.scale];
    }
    [self.view addSubview:_otherBtn];
}

-(void) loginOrShopping{
    if(!_otherBtn.selected){
        LoginViewController *login = [self login];
        [login resggong:^(NSString *str) {
            [self ReshData];
        }];
    }else{
        self.tabBarController.selectedIndex=1;
    }
}

-(void)settleAccount{
    NSMutableString *ids=[NSMutableString string];
    NSMutableArray *settleArray=[NSMutableArray array];
    CGFloat amount=0.0;
    for(int i=0;i<_dataSource.count;i++){
        if([_clearingArray[i] boolValue]){
            //[settleArray addObject:_dataSource[i]];
            [ids appendString:[NSString stringWithFormat:@"%@,",_dataSource[i][@"pro_id"]]];
            NSMutableDictionary* dic=[_dataSource[i] mutableCopy];
            amount+=[_dataSource[i][@"pro_amount"] floatValue];
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
    }
    if(settleArray.count==0){
        [self ShowAlertWithMessage:@"请至少选择一件商品"];
        return;
    }
    if(ids.length>0){
        NSRange deleteRange = { [ids length] - 1, 1 };
        [ids deleteCharactersInRange:deleteRange];
    }
    NSLog(@"ids==%@",ids);
    CGFloat delivery_free=[_dataDic[@"delivery_free"] floatValue];
    CGFloat delivery_fee=[_dataDic[@"delivery_fee"] floatValue];
    CGFloat total=amount;
    if(amount<delivery_free){
        total+=delivery_fee;
    }
    NSMutableDictionary* settleDic=[NSMutableDictionary dictionary];
    [settleDic setObject:_dataDic[@"delivery_fee"] forKey:@"delivery_fee"];
    [settleDic setObject:_dataDic[@"delivery_free"] forKey:@"delivery_free"];
    [settleDic setObject:_dataDic[@"shop_icon"] forKey:@"shop_icon"];
    [settleDic setObject:_dataDic[@"shop_id"] forKey:@"shop_id"];
    [settleDic setObject:_dataDic[@"shop_name"] forKey:@"shop_name"];
    [settleDic setObject:[NSString stringWithFormat:@"%.1f",amount] forKey:@"amount"];
    [settleDic setObject:[NSString stringWithFormat:@"%.1f",total] forKey:@"total"];
    [settleDic setObject:[NSString stringWithFormat:@"%@",ids] forKey:@"ids"];

    NSLog(@"dic==%@",settleDic);
    OrderViewController *orde = [OrderViewController new];
    orde.hidesBottomBarWhenPushed=YES;
    orde.dataArray = settleArray;
    orde.dataDic=settleDic;
    //orde.tel=self.
    // orde.gouwucheData=_dataSource;
    [self.navigationController pushViewController:orde animated:YES];
}

-(void) newBottomView{
    if (_bottomView) {
        [_bottomView removeFromSuperview];
    }
    if(!_bottomView){
       _bottomView= [[UIView alloc]initWithFrame:CGRectMake(0, _tableView.bottom, self.view.width, 40*self.scale)];
        UIView* leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width-80*self.scale, 40*self.scale)];
        leftView.backgroundColor=[UIColor colorWithRed:0.345 green:0.345 blue:0.345 alpha:1.00];
        _totalPriceLb=[[UILabel alloc]initWithFrame:CGRectMake(5*self.scale, 5*self.scale, self.view.width-75*self.scale, 15*self.scale)];
        _totalPriceLb.font=[UIFont boldSystemFontOfSize:10*self.scale];
        _totalPriceLb.textColor=[UIColor whiteColor];
        [leftView addSubview:_totalPriceLb];
        _shippingFeeLb=[[UILabel alloc]initWithFrame:CGRectMake(8*self.scale, _totalPriceLb.bottom, self.view.width-72*self.scale, 15*self.scale)];
        _shippingFeeLb.font=[UIFont boldSystemFontOfSize:10*self.scale];
        _shippingFeeLb.textColor=[UIColor colorWithRed:0.706 green:0.706 blue:0.706 alpha:1.00];
        [leftView addSubview:_shippingFeeLb];
        [_bottomView addSubview:leftView];
        UIView* rightView=[[UIView alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, 0,80*self.scale , 40*self.scale)];
        _settleAccountBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,80*self.scale , 40*self.scale)];
        [_settleAccountBtn setTitle:@"去结算" forState:UIControlStateNormal];
        [_settleAccountBtn addTarget:self action:@selector(settleAccount) forControlEvents:UIControlEventTouchUpInside];
        _settleAccountBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13*self.scale];
        [_settleAccountBtn setTitleColor:[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00] forState:UIControlStateNormal];
        [rightView addSubview:_settleAccountBtn];
        CAGradientLayer *gradientLayer=[CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:1.000 green:0.925 blue:0.000 alpha:1.00].CGColor, (__bridge id)[UIColor colorWithRed:0.996 green:0.800 blue:0.000 alpha:1.00].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = CGRectMake(0, 0, 80*self.scale , 40*self.scale);
        [rightView.layer insertSublayer:gradientLayer atIndex:0];
        [_bottomView addSubview:rightView];
        [self.view addSubview:_bottomView];
    }
    if (_delView) {
        [_delView removeFromSuperview];
    }
    if(!_delView){
        _delView= [[UIView alloc]initWithFrame:CGRectMake(0, _tableView.bottom, self.view.width, 40*self.scale)];
        _delView.backgroundColor=[UIColor whiteColor];
        UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, .5)];
        topline.backgroundColor=[UIColor colorWithRed:0.847 green:0.855 blue:0.863 alpha:1.00];
        [_delView addSubview:topline];
        
        _checkAllBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,80*self.scale , 40*self.scale)];
        [_checkAllBtn setImage:[UIImage imageNamed:@"na9"] forState:UIControlStateNormal];
        [_checkAllBtn setImage:[UIImage imageNamed:@"na10"] forState:UIControlStateSelected];
        [_checkAllBtn setTitle:@" 全选" forState:UIControlStateNormal];
        [_checkAllBtn addTarget:self action:@selector(checkAll) forControlEvents:UIControlEventTouchUpInside];
        _checkAllBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13*self.scale];
        [_checkAllBtn setTitleColor:[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00] forState:UIControlStateNormal];
        [_delView addSubview:_checkAllBtn];
        
        _delBtn= [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-60*self.scale, 7.5*self.scale, 50*self.scale, 25*self.scale)];
        _delBtn.clipsToBounds = YES;
        _delBtn.layer.cornerRadius = 5*self.scale;
        _delBtn.layer.borderColor = [[UIColor colorWithRed:1.000 green:0.353 blue:0.239 alpha:1.00] CGColor];
        _delBtn.layer.borderWidth = 0.5;
        [_delBtn setTitle:@"删除" forState:(UIControlStateNormal)];
        [_delBtn addTarget:self action:@selector(delAll) forControlEvents:UIControlEventTouchUpInside];
        [_delBtn setTitleColor:[UIColor colorWithRed:1.000 green:0.353 blue:0.239 alpha:1.00] forState:(UIControlStateNormal)];
        _delBtn.titleLabel.font = [UIFont systemFontOfSize:12*self.scale];;
        [_delView addSubview:_delBtn];
        //_checkAllBtn.selected=YES;
        [self.view addSubview:_delView];
        _delView.hidden=YES;
    }
}

-(void)delAll{
    NSMutableString *ids=[NSMutableString string];
    for(int i=0;i<_delArray.count;i++){
        if([_delArray[i] boolValue]){
            [ids appendString:[NSString stringWithFormat:@"%@,",_dataSource[i][@"pro_id"]]];
        }
    }
    if([AppUtil isBlank:ids]){
        [self ShowAlertWithMessage:@"请至少选择一项"];
        return;
    }
    if(ids.length>0){
        //[ids substringToIndex:([ids length]-1)];
        NSRange deleteRange = { [ids length] - 1, 1 };
        [ids deleteCharactersInRange:deleteRange];
    }
    NSLog(@"ids==%@",ids);
    [[DataBase sharedDataBase] deleteCartWithProID:ids];
    _bottomView.hidden=NO;
    _delView.hidden=YES;
    if(_checkAllBtn.selected)
        _checkAllBtn.selected=NO;
    [self ReshData];
}

-(void) checkAll{
    _checkAllBtn.selected=!_checkAllBtn.selected;
    for(int i=0;i<_delArray.count;i++){
        [_delArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:_checkAllBtn.selected]];
    }
    [_tableView reloadData];
}

-(void)ReshData{
    //[_otherLb removeFromSuperview];
    [_goShop removeFromSuperview];
    [_dataSource removeAllObjects];
    [_clearingArray removeAllObjects];
    [_delArray removeAllObjects];
    [self removeOtherView];
    NSString* shop_id= [[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"];
    NSArray* array= [[DataBase sharedDataBase] getAllFromCart:shop_id];
    NSLog(@"array==%@",array);
    if(![Stockpile sharedStockpile].isLogin){
        [self otherView];
        [_otherIv setImage:[UIImage imageNamed:@"fingerprint"]];
        _otherLb.text=@"Sorry，您还没有登录！";
        [_otherBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_otherBtn setTitle:@"登录" forState:UIControlStateSelected];
        _otherBtn.selected=NO;
        if (_tableView) {
            _tableView.hidden=YES;
        }
        if (_bottomView&&_bottomView.hidden==NO) {
            _bottomView.hidden=YES;
        }
        if(_editBtn.hidden==NO)
            _editBtn.hidden=YES;
    }else if([AppUtil arrayIsEmpty:array]){
        [self otherView];
        [_otherIv setImage:[UIImage imageNamed:@"distressed"]];
        _otherLb.text=@"购物车还没有商品";
        [_otherBtn setTitle:@"去逛逛?" forState:UIControlStateNormal];
        [_otherBtn setTitle:@"去逛逛?" forState:UIControlStateSelected];
        _otherBtn.selected=YES;
        if (_tableView) {
            _tableView.hidden=YES;
        }
        if (_bottomView&&_bottomView.hidden==NO) {
            _bottomView.hidden=YES;
        }
        [self huoQuGouWuCheShuLiang];
        if(_editBtn.hidden==NO)
            _editBtn.hidden=YES;
    }else if(array.count>0){
        if(_tableView.hidden)
            _tableView.hidden=NO;
        if (_bottomView.hidden) {
            _bottomView.hidden=NO;
        }
        if(_editBtn.hidden)
            _editBtn.hidden=NO;
        if(_editBtn.selected)
            _editBtn.selected=NO;
        NSLog(@"shopingcart==%@==%d",array,_tableView.hidden);
        NSMutableArray* arrParam=[NSMutableArray array];
        for(NSDictionary* item in array){
            NSMutableDictionary* dic=[NSMutableDictionary dictionary];
            [dic setObject:item[@"shop_id"] forKey:@"shop_id"];
            NSArray* prods=item[@"prolist"];
            NSMutableArray* prodsParam=[NSMutableArray array];
            for(NSDictionary* prod in prods){
                NSMutableDictionary* d=[NSMutableDictionary dictionary];
                [d setObject:prod[@"pro_id"] forKey:@"prod_id"];
                [d setObject:prod[@"pro_allnum"] forKey:@"prod_count"];
                [prodsParam addObject:d];
            }
            [dic setObject:prodsParam forKey:@"prods"];
            [arrParam addObject:dic];
        }
        NSMutableDictionary* param=[NSMutableDictionary dictionary];
        [param setObject:[self DataTOjsonString:arrParam] forKey:@"cartinfo"];
        AnalyzeObject *anal=[AnalyzeObject new];
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        [anal checkCart:param Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            NSLog(@"checkCart==%@==%@==%@==%@",param,models,code,msg);
            if ([code isEqualToString:@"0"]) {
                _dataDic=[models[0] mutableCopy];
                NSArray *proList=models[0][@"prolist"];
                [self fillData:proList];
            }
        }];
    }
}

-(void) setBottomData{
    CGFloat amount=0;//[_dataDic[@"amount"] floatValue];
    for(int i=0;i<_dataSource.count;i++){
        if([_clearingArray[i] boolValue]){
            amount+=[_dataSource[i][@"pro_amount"] floatValue];
            continue;
        }
    }
    CGFloat delivery_free=[_dataDic[@"delivery_free"] floatValue];
    CGFloat delivery_fee=[_dataDic[@"delivery_fee"] floatValue];
    CGFloat totalPrice=0.0;
    NSString* priceSmall=nil;
    if(amount<delivery_free){
        if(amount>0)
             totalPrice=amount+delivery_fee;
        priceSmall=[NSString stringWithFormat:@"%.1f+%.1f",amount,delivery_fee];
    }else{
        totalPrice=amount;
        priceSmall=[NSString stringWithFormat:@"%.1f+0",amount];
    }
    NSString *priceStr=[NSString stringWithFormat:@"￥%.1f %@",totalPrice,priceSmall];
    NSString * totalStr = [NSString stringWithFormat:@"￥%.1f",totalPrice];
    NSMutableAttributedString * priceAttributeString = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [priceAttributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14*self.scale] range:NSMakeRange(0, totalStr.length)];
    _totalPriceLb.attributedText = priceAttributeString;
    _shippingFeeLb.text=[NSString stringWithFormat:@"配送费%.1f，满%.1f免配送费",delivery_fee,delivery_free];
}

-(void) fillData:(NSArray*)array{
    for( int i=0; i<array.count; i++){
        [_clearingArray addObject:[NSNumber numberWithBool:true]];
        [_delArray addObject:[NSNumber numberWithBool:false]];
    }
    [_dataSource addObjectsFromArray:array];
    [self huoQuGouWuCheShuLiang];
    [self setBottomData];
    [_tableView reloadData];
}

-(NSString*)DataTOjsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    // return jsonString;
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

-(void)newView{
    if (_tableView) {
        [_tableView removeFromSuperview];
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom-40*self.scale-self.tabBarController.tabBar.frame.size.height) style:(UITableViewStyleGrouped)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[GouWuCheTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    self.view.backgroundColor=[UIColor colorWithRed:0.976 green:0.976 blue:0.976 alpha:1.00];
   // [self RooterView];
}

#pragma mark - UITableViewDelegate & UITableViewDatasource
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return _dataSource.count;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *prodDic=[_dataSource objectAtIndex:indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%@",prodDic[@"pro_id"]];
    GouWuCheTableViewCell *cell=(GouWuCheTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(_editBtn.selected){
        if([_delArray[indexPath.row] boolValue]){
            cell.SelectedBtn.selected=YES;
        }else{
            cell.SelectedBtn.selected=NO;
        }
    }else{
        if([_clearingArray[indexPath.row] boolValue]){
            cell.SelectedBtn.selected=YES;
        }else{
            cell.SelectedBtn.selected=NO;
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.GoodsImg setImageWithURL:[NSURL URLWithString:[prodDic objectForKey:@"pro_cover"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
    cell.GoodsName.text=[NSString stringWithFormat:@"%@",[prodDic objectForKey:@"pro_name"]];
    NSString* des=[prodDic objectForKey:@"pro_subname"];
    NSLog(@"des==%@",des);
    if([AppUtil isBlank:des]){
        des=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@
                                              "%@",[prodDic objectForKey:@"pro_name"]]];
    }
    cell.xiaoliangLa.text = des;
    CGFloat pri=[[prodDic objectForKey:@"pro_price"] floatValue];
    NSInteger activityid=[[NSString stringWithFormat:@"%@",prodDic[@"activity_id"]] integerValue];
    NSInteger actmaxbuy=[[NSString stringWithFormat:@"%@",[prodDic objectForKey:@"actmaxbuy"]] integerValue];
    NSInteger havedbuy=[[NSString stringWithFormat:@"%@",[prodDic objectForKey:@"havedbuy"]] integerValue];
    if(activityid>0&&((actmaxbuy>0&&(actmaxbuy-havedbuy)>0)||actmaxbuy==0)){
        UIImageView *activityImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20*self.scale, 20*self.scale)];
        activityImg.contentMode=UIViewContentModeScaleAspectFill;
        activityImg.clipsToBounds=YES;
        NSString *activityImgUrl=[NSString stringWithFormat:@"%@",prodDic[@"acticon"]];
        UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:activityImg.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(5,0)];
        CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
        maskLayer.frame=activityImg.bounds;
        maskLayer.path=maskPath.CGPath;
        activityImg.layer.mask=maskLayer;
        [activityImg setImageWithURL:[NSURL URLWithString:activityImgUrl] placeholderImage:[UIImage imageNamed:@""]];
        [cell.GoodsImg addSubview:activityImg];
        pri=[[prodDic objectForKey:@"pro_actprice"] floatValue];
        cell.xiaoliangLa.text = [prodDic objectForKey:@"actmark"];
        cell.xiaoliangLa.textColor = [UIColor colorWithRed:1.000 green:0.373 blue:0.000 alpha:1.00];
        cell.yuanJiaLab.hidden = NO;
    }else{
        cell.yuanJiaLab.hidden = YES;
    }
    NSString * priceString = [NSString stringWithFormat:@
                               "￥%.1f/%@",pri,[prodDic objectForKey:@"unit"]];
    CGRect priceRect = [self getStringWithFont:12*self.scale withString:priceString withWith:self.view.width];
    NSString * firstString = [NSString stringWithFormat:@"%.1f",pri];
    NSMutableAttributedString * priceAttributeString = [[NSMutableAttributedString alloc]initWithString:priceString];
    [priceAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*self.scale] range:NSMakeRange(1, firstString.length)];
    cell.GoodsPrice.attributedText = priceAttributeString;
    cell.GoodsPrice.frame = CGRectMake(0, 35*self.scale, priceRect.size.width, 15*self.scale);
    CGFloat yuanJiaF = 32.0;
    CGFloat xianJiaF = [[prodDic objectForKey:@"price"] floatValue];
    //NSLog(@"--原价：%f,现价：%f",yuanJiaF,xianJiaF);
    if (yuanJiaF>=xianJiaF){
        cell.yuanJiaLab.hidden = YES;
    }else{
        cell.yuanJiaLab.hidden = YES;
        NSString *  yuanJiastring = [NSString stringWithFormat:@"￥%@",@"1000"];
        CGRect yuanJiaRect = [self getStringWithFont:13*self.scale withString:yuanJiastring withWith:self.view.width];
        cell.yuanJiaLab.text = yuanJiastring;
        cell.yuanJiaLab.frame = CGRectMake(cell.GoodsPrice.right+5*self.scale, 40*self.scale, yuanJiaRect.size.width, 20*self.scale);
        cell.lin.frame = CGRectMake(0, 10*self.scale, cell.yuanJiaLab.width, 0.5);
    }
    cell.gnumber=[NSString stringWithFormat:@
                  "%@",[prodDic objectForKey:@"pro_allnum"]];
    //cell.SelectedBtn.selected=([_GoodsListDic objectForKey:key] !=nil);
    cell.indexPath=indexPath;
    cell.delegate=self;
    if ([_GoodsListDic objectForKey:key]) {
        [_GoodsListDic setObject:prodDic forKey:key];
    }
    [_btnArr addObject:cell.SelectedBtn];
    if((_dataSource.count-indexPath.row)==1)
        cell.lingView.hidden=YES;
    else
        cell.lingView.hidden=NO;
    return cell;
}

-(void)GouWuCheTableViewCellIndexpath:(NSIndexPath *)indexPath{
    NSLog(@"%@",@"xuanzhuang");
//    NSLog(@"------%@",_dataSource[indexPath.section][@"prod_info"][indexPath.row][@"prod_id"]);
//    dsa
//    NSString *prod_idStr = [NSString stringWithFormat:@"%@",_dataSource[indexPath.section][@"prod_info"][indexPath.row][@"prod_id"]];
//    
//    if (_dataDic[prod_idStr]) {
//        [_dataDic removeObjectForKey:prod_idStr];
//    }else{
//        [_dataDic setObject:@"" forKey:prod_idStr];
//    }
//    NSLog(@"------%@",_dataDic);
//    
//    UIButton *quanXuanBtn = (UIButton *)[self.view viewWithTag:6666];
//    if (_dataDic.count == _quanXuanDic.count) {
//        
//        quanXuanBtn.selected=YES;
//    }else{
//        quanXuanBtn.selected=NO;
//    }
//    
//    [_daArr removeAllObjects];
//    NSMutableDictionary *xiaoArr = [[NSMutableDictionary alloc] init];
//    for (int i = 0; i < _dataSource.count; i ++) {
//        NSArray * Prod_infoArr = _dataSource[i][@"prod_info"];
//        xiaoArr = [[NSMutableDictionary alloc] init];
//        for (int j = 0; j < Prod_infoArr.count; j ++) {
//            NSString * prod_id = [NSString stringWithFormat:@"%@",_dataSource[i][@"prod_info"][j][@"prod_id"]];
//            NSDictionary *prod_infoDic =_dataSource[i][@"prod_info"][j];
//            if (_dataDic[prod_id]) {
//                [xiaoArr setObject:prod_infoDic forKey:prod_id];
//            }
//        }
//        if (xiaoArr.count>0) {
//            [_daArr addObject:xiaoArr];
//                   }
//    }
//    [_bigbigd setObject:_daArr forKey:@"list"];
//    [_bigbigd setObject:[_dataSource[indexPath.section] objectForKey:@"prod_info"][indexPath.row][@"shop_id"] forKey:@"shop_id"];
//    [_bigbigd setObject:[_dataSource[indexPath.section] objectForKey:@"prod_info"][indexPath.row][@"prod_img1"] forKey:@"image"];
//    [_bigbigd setObject:[_dataSource[indexPath.section]objectForKey:@"shop_name"] forKey:@"shopname"];
//    NSMutableDictionary *zong = [NSMutableDictionary new];
//    NSMutableDictionary *list = [NSMutableDictionary new];
//    
//    for (NSString *ID in _dataDic) {
//        for (NSDictionary *dic in _dataSource[indexPath.section][@"prod_info"]) {
//            
//            NSMutableDictionary *shop = [NSMutableDictionary new];
//            
//            if ([dic[@"prod_id"] isEqualToString:ID]) {
//                [list setObject:prod_info forKey:ID];
//                [shop setObject:list forKey:@"list"];
//
//            }else{
//            }
//            [shopArr setObject:shop forKey:@""];
//        }
//    }
//   NSDictionary *dic = [[_dataSource objectAtIndex:indexPath.section] objectForKey:@"prod_info"][indexPath.row] ;
//
//    NSMutableArray *arr = [[[_dataSource objectAtIndex:indexPath.section] objectForKey:@"prod_info"] mutableCopy];
//    if ([arr containsObject:dic]) {
//        
//        [arr removeObject:dic];
//        
//        
//    }else{
//        [arr addObject:dic];
//    }
//    
//    [[[_data objectAtIndex:indexPath.section] mutableCopy] setObject:arr forKey:@"prod_info"];
//    
//    
//    NSLog(@"---------%@",_data);
//    
//    
//    if ([_data isEqualToArray:_dataSource]) {
//        
//        NSLog(@"00000");
//    }else{
//    
//        NSLog(@"11111");
//    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40*self.scale;
}

-(NSInteger)getProNum{
    NSInteger total=0;
    for(int i=0;i<[_dataSource count];i++){
        total+=[((NSNumber*)_dataSource[i][@"pro_allnum"])  integerValue];
    }
    return total;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 30*self.scale)];
    headerLb.backgroundColor=self.view.backgroundColor;
    if(_dataSource.count>0)
       headerLb.text=[NSString stringWithFormat:@"  共%ld件商品",[self getProNum]];
    headerLb.textColor=[UIColor colorWithRed:0.408 green:0.408 blue:0.408 alpha:1.00];
    headerLb.font=[UIFont systemFontOfSize:12*self.scale];
    return headerLb;
}

//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 60*self.scale)];
//    UILabel * yunFeiLab = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, self.view.width - 150*self.scale,30*self.scale)];
//    CGFloat amount = [_dataSource[section][@"amount"] floatValue];
//    CGFloat free_delivery_amount = [_dataSource[section][@"free_delivery_amount"] floatValue];
//    //NSLog(@"viewForFooterInSection====%@",_dataSource[section]);
//    if (amount>=free_delivery_amount)
//    {
//        yunFeiLab.text = [NSString stringWithFormat:@"本店消费%.2f元,已免配送费",amount];
//    }else{
//        yunFeiLab.text = [NSString stringWithFormat:@"本店消费%.2f元,差%.2f元免配送费",amount,free_delivery_amount-amount];
//    }
//    yunFeiLab.numberOfLines=0;
//    yunFeiLab.textColor = grayTextColor;
//    yunFeiLab.font = SmallFont(self.scale);
//    [footerView addSubview:yunFeiLab];
//    UIButton * jiXuGouWuBtn = [[UIButton alloc]initWithFrame:CGRectMake(yunFeiLab.right+ 5*self.scale, 10*self.scale, 30*self.scale/3.0*6, 30*self.scale)];
//    jiXuGouWuBtn.clipsToBounds = YES;
//    jiXuGouWuBtn.layer.cornerRadius = 5*self.scale;
//    jiXuGouWuBtn.layer.borderColor = [[UIColor colorWithRed:0.565 green:0.580 blue:0.612 alpha:1.00] CGColor];
//    jiXuGouWuBtn.layer.borderWidth = 0.5;
//    [jiXuGouWuBtn setTitle:@"继续购物" forState:(UIControlStateNormal)];
//    [jiXuGouWuBtn setTitleColor:[UIColor colorWithRed:0.565 green:0.580 blue:0.612 alpha:1.00] forState:(UIControlStateNormal)];
//    jiXuGouWuBtn.titleLabel.font = SmallFont(self.scale);
//    [jiXuGouWuBtn addTarget:self action:@selector(jiXuGouWuBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
//    jiXuGouWuBtn.tag = section + 100;
//    [footerView addSubview:jiXuGouWuBtn];
//    UIButton *jiesuan = [UIButton buttonWithType:UIButtonTypeCustom];
//    [jiesuan setTitle:@"去结算" forState:UIControlStateNormal];
//    jiesuan.frame=CGRectMake(jiXuGouWuBtn.right+10*self.scale, 10*self.scale, 30*self.scale/3.0*6, 30*self.scale);
//    jiesuan.titleLabel.font=DefaultFont(self.scale*0.9);
//    [jiesuan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    jiesuan.backgroundColor=[UIColor colorWithRed:1.000 green:0.863 blue:0.357 alpha:1.00];
//    jiesuan.clipsToBounds = YES;
//    jiesuan.layer.cornerRadius = 5*self.scale;
//    [jiesuan addTarget:self action:@selector(JieSuanEvent:) forControlEvents:UIControlEventTouchUpInside];
//    jiesuan.tag = section + 200;
//    [footerView addSubview:jiesuan];
//    footerView.backgroundColor = [UIColor whiteColor];
//    return footerView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 50*self.scale;
//}

#pragma mark -- 点击区头跳转商铺
- (void)sectionGaoShop:(UITapGestureRecognizer *)tap
{
    self.hidesBottomBarWhenPushed = YES;
    BreakInfoViewController * breakInf = [[BreakInfoViewController alloc]init];
    breakInf.ID = _dataSource[tap.view.tag- 10][@"shop_id"];
    breakInf.shop_id = _dataSource[tap.view.tag- 10][@"shop_id"];
    breakInf.titlete = _dataSource[tap.view.tag - 10][@"shop_name"];
    [self.navigationController pushViewController:breakInf animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark -- 继续购物按钮点击事件
- (void)jiXuGouWuBtnClick:(UIButton *)sender{
    //100;
    NSLog(@"jiXuGouWuBtnClick==%@",_dataSource[sender.tag - 100]);
    self.hidesBottomBarWhenPushed = YES;
    BreakInfoViewController * breakInf = [[BreakInfoViewController alloc]init];
    breakInf.ID = _dataSource[sender.tag - 100][@"shop_id"];
    breakInf.shop_id =_dataSource[sender.tag - 100][@"shop_id"];
    breakInf.titlete = _dataSource[sender.tag - 100][@"shop_name"];
    [self.navigationController pushViewController:breakInf animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 商户信息
-(void)DetailView:(UIView *)headerView viewForHeaderInSection:(NSInteger)section{
    //NSDictionary *merchant=[_dataSource objectAtIndex:section];
   UIImageView *dianPuImg = [[UIImageView alloc] initWithFrame:CGRectMake(10*self.scale,10*self.scale, 35*self.scale, 35*self.scale)];
    //dianPuImg.backgroundColor = [UIColor yellowColor];
   // [dianPuImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgDuanKou,merchant[@"logo"]]] placeholderImage:[UIImage imageNamed:@""]];
    [dianPuImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_dataSource[section] objectForKey:@"logo"]] ]  placeholderImage:[UIImage imageNamed:@"mz_logo"]];
    [headerView addSubview:dianPuImg];
    UILabel *dianPuTitleL=[[UILabel alloc]initWithFrame:CGRectMake(dianPuImg.right+10*self.scale, dianPuImg.top, 140*self.scale, dianPuImg.height)];
   dianPuTitleL.font=[UIFont systemFontOfSize:13*self.scale];
    dianPuTitleL.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    dianPuTitleL.backgroundColor = [UIColor clearColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:dianPuTitleL.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [_dataSource[section][@"shop_name"] boundingRectWithSize:CGSizeMake(140*self.scale, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    dianPuTitleL.frame=CGRectMake(dianPuImg.right+10*self.scale, dianPuImg.top, size.width, dianPuImg.height);
    dianPuTitleL.text =_dataSource[section][@"shop_name"];
    dianPuTitleL.numberOfLines = 0;
    [headerView addSubview:dianPuTitleL];
    UIImageView *jiantouImg = [[UIImageView alloc]initWithFrame:CGRectMake(dianPuTitleL.right+5*self.scale, headerView.height/2-7.5*self.scale, 17*self.scale, 17*self.scale)];
    jiantouImg.image=[UIImage imageNamed:@"dd_right"];
    [headerView addSubview:jiantouImg];
//    UILabel *selfLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.width-50*self.scale, headerView.height/2-8*self.scale, 40*self.scale, 16*self.scale)];
//    selfLabel.textColor=grayTextColor;
//    selfLabel.text=@"编辑";
//    selfLabel.textAlignment=NSTextAlignmentCenter;
//    selfLabel.layer.masksToBounds=YES;
//    selfLabel.font=SmallFont(self.scale);
//   // selfLabel.hidden= ([[NSString stringWithFormat:@"%@",merchant[@"isself"]] isEqualToString:@"0"]);
//    [headerView addSubview:selfLabel];
}

#pragma mark - 底部结算
-(void)UpdateBottomView{
    if (_dataSource.count>0 &&  !_tableView.tableFooterView) {
        //[self RooterView];
    }else if( _dataSource.count<1){
        _tableView.tableFooterView=nil;
    }
    NSInteger number=0;
    double sam=0;
    NSInteger Sum=0;
    NSInteger ssum=0;
    for ( NSDictionary *mer in _dataSource)
    {
          NSArray *Plist=[mer objectForKey:@"plist"];
        if ([[NSString stringWithFormat:@"%@",mer[@"isself"]] isEqualToString:@"0"])
        {
            for ( NSDictionary *shop in Plist)
            {
                Sum++;
                if ([_Dic objectForKey:[shop objectForKey:@"pid"]]) {
                    number=number+[shop[@"num"] integerValue];
                    sam=sam+[shop[@"num"] integerValue]*[shop[@"newprice"] floatValue];
                    ssum++;
                }
            }
        }else{
            for ( NSDictionary *shop in Plist)
            {
                Sum++;
                if ([_Dic objectForKey:[shop objectForKey:@"pid"]]) {
                    number=number+[shop[@"num"] integerValue];
                    sam=sam+[shop[@"num"] integerValue]*[shop[@"newprice"] floatValue];
                    ssum++;
                }
            }
            UIButton *button=(UIButton *)[self.view viewWithTag:557];
            [button setTitle:[NSString stringWithFormat:@"结算(%ld)",(long)number] forState:UIControlStateNormal];
            UILabel *Sm=(UILabel *)[self.view viewWithTag:556];
            Sm.text=[NSString stringWithFormat:@"合计：￥%.2f",sam];
           
            UIButton *btn=(UIButton *)[self.view viewWithTag:888];
            btn.selected=(ssum==Sum&& Sum>0);
            ssum=0;
            Sum=0;
            sam=0;
            number=0;
        }
    }
    UIButton *button=(UIButton *)[self.view viewWithTag:668];
    [button setTitle:[NSString stringWithFormat:@"结算(%ld)",(long)number] forState:UIControlStateNormal];
    UILabel *Sm=(UILabel *)[self.view viewWithTag:667];
    Sm.text=[NSString stringWithFormat:@"合计：￥%.2f",sam];
    UIButton *btn =(UIButton *)[self.view viewWithTag:666];
    btn.selected=(ssum==Sum && Sum>0 );
}

-(void)BottomView:(BOOL)isSection{
    NSLog(@"底部商品列表====%@",_GoodsListDic);
    NSInteger number=0;
    double sam=0;
    if (isSection){
        NSDictionary *mer=_dataSource[0];
          NSArray *Plist=[mer objectForKey:@"plist"];
        for (NSDictionary *shop in Plist)
        {
            if ([_Dic objectForKey:[shop objectForKey:@"pid"]]) {
                number=number+[shop[@"num"] integerValue];
                sam=sam+[shop[@"num"] integerValue]*[shop[@"newprice"] floatValue];
            }
        }
    }else{
        for ( NSDictionary *mer in _dataSource)
        {
            NSArray *Plist=[mer objectForKey:@"plist"];
            if ([[NSString stringWithFormat:@"%@",mer[@"isself"]] isEqualToString:@"0"])
            {
                for ( NSDictionary *shop in Plist)
                {
                    if ([_Dic objectForKey:[shop objectForKey:@"pid"]]) {
                        number=number+[shop[@"num"] integerValue];
                        sam=sam+[shop[@"num"] integerValue]*[shop[@"newprice"] floatValue];
                    }
                }
            }
        }
    }
    if (_bigVi)
    {
        [_bigVi removeFromSuperview];
    }
    _bigVi =[[UIView alloc]initWithFrame:CGRectMake(0, _tableView.bottom, self.view.width, 45)];
    _bigVi.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_bigVi];
    
    UIView *line= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, .5)];
    line.backgroundColor=blackLineColore;
    [_bigVi addSubview:line];
    
    UIButton *select = [[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, _bigVi.height/2-10*self.scale, 20*self.scale, 20*self.scale)];
    [select setBackgroundImage:[UIImage imageNamed:@"na3"] forState:UIControlStateNormal];
    [select setBackgroundImage:[UIImage imageNamed:@"green"] forState:UIControlStateSelected];
    select.selected=YES;
    select.tag=6666;
    [select addTarget:self action:@selector(SelectedEvent) forControlEvents:UIControlEventTouchUpInside];
    [_bigVi addSubview:select];
    
    
    UILabel *quanxuan = [[UILabel alloc]initWithFrame:CGRectMake(select.right+3*self.scale, _bigVi.height/2-10*self.scale, 50*self.scale, 20*self.scale)];
    quanxuan.text=@"全选";
    quanxuan.userInteractionEnabled=YES;
    quanxuan.font=DefaultFont(self.scale);
    [_bigVi addSubview:quanxuan];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SelectedEvent)];
    [quanxuan addGestureRecognizer:tap];

    
//    UIButton *big = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-190*self.scale, _bigVi.height/2-15*self.scale, 100*self.scale, 30*self.scale)];
//    big.layer.cornerRadius=4.0f;
//    big.backgroundColor=[UIColor colorWithRed:1 green:0/255.0 blue:0/255.0 alpha:.7];
//    [big addTarget:self action:@selector(jixugouwu) forControlEvents:UIControlEventTouchUpInside];
//    [_bigVi addSubview:big];
//
    NSString * hejiString = [NSString stringWithFormat:@"合计:￥%.2f",[self jiSuanAmount]];
    CGRect rect = [self getStringWithFont:12*self.scale withString:hejiString withWith:[UIScreen mainScreen].bounds.size.width];
    UILabel *carLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width - rect.size.width - 90*self.scale-10, _bigVi.height/2-10*self.scale, rect.size.width+30, 20*self.scale)];
    carLa.font=[UIFont fontWithName:@"Helvetica-Bold" size:12*self.scale];
    carLa.textColor=blueTextColor;
    carLa.tag = 100;
    carLa.attributedText = [self getAmountFuWenBenWithStirng:hejiString];
    [_bigVi addSubview:carLa];
    UIButton *jiesuan = [UIButton buttonWithType:UIButtonTypeCustom];
//    jiesuan.layer.cornerRadius=4.0;
    [jiesuan setTitle:@"结算    " forState:UIControlStateNormal];
    jiesuan.frame=CGRectMake(carLa.right+10*self.scale, 0, 80*self.scale,_bigVi.height);
    jiesuan.titleLabel.font=DefaultFont(self.scale);
    [jiesuan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    jiesuan.backgroundColor=blueTextColor;
//    jiesuan.alpha=.7;
    [jiesuan addTarget:self action:@selector(JieSuanEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_bigVi addSubview:jiesuan];
    [self.view addSubview:self.activityVC];
}

-(void) shipAccount:(UIButton *)button{
    NSString* shopID = [NSString stringWithFormat:@"%@",_dataSource[button.tag - 200][@"shop_id"]];
    
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       shopID, @"ShopID",
                       nil];
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle getShopOnlineTime:dic Block:^(id models, NSString *code, NSString *msg) {
        NSDictionary* shopInfo=models;
        NSInteger isOffLine=[[NSString stringWithFormat:@"%@",shopInfo[@"is_off_online"]] integerValue];
        if(isOffLine==1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"临时歇业中"
                                                                message:@"暂停营业。很快回来^_^!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }else if(![AppUtil isDoBusiness:shopInfo]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"歇业中"
                                                                message:[NSString stringWithFormat:@"%@",shopInfo[@"onlinemark"]]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
        NSLog(@"JieSuanEvent==%@",_GoodsListDic);
        NSMutableDictionary *settleDic=[NSMutableDictionary dictionary];
        for (NSString *key in [_GoodsListDic allKeys]) {
            NSString *shopid =[NSString stringWithFormat:@"%@",[_GoodsListDic objectForKey:key][@"shop_id"]];// [_GoodsListDic objectForKey:key][@"shop_id"];
            if([shopID isEqualToString:shopid]){
                [settleDic setObject:[_GoodsListDic objectForKey:key] forKey:key];
            }
        }
        self.hidesBottomBarWhenPushed=YES;
        OrderViewController *orde = [OrderViewController new];
        orde.dataDic = settleDic;
        //    orde.tel=self.
        // orde.gouwucheData=_dataSource;
        [self.navigationController pushViewController:orde animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }];
}

#pragma mark - 结算
-(void)JieSuanEvent:(UIButton *)button{
//    if (_GoodsListDic.count<=0) {
//        [self ShowAlertWithMessage:@"请至少选择一件商品"];
//        return;
//    }
    if ([Stockpile sharedStockpile].isLogin==NO) {
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {//登录成功后需要加载的数据
                    NSLog(@"登录成功");
                    //[self performSelector:@selector(shipAccount:) withObject:button afterDelay:0.5f];
                }];
            }
        }];
        return;
    }
    NSString* shopID = [NSString stringWithFormat:@"%@",_dataSource[button.tag - 200][@"shop_id"]];
    
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       shopID, @"ShopID",
                       nil];
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle getShopOnlineTime:dic Block:^(id models, NSString *code, NSString *msg) {
        NSDictionary* shopInfo=models;
        NSInteger isOffLine=[[NSString stringWithFormat:@"%@",shopInfo[@"is_off_online"]] integerValue];
        if(isOffLine==1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"临时歇业中"
                                                                message:@"暂停营业。很快回来^_^!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }else if(![AppUtil isDoBusiness:shopInfo]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"歇业中"
                                                                message:[NSString stringWithFormat:@"%@",shopInfo[@"onlinemark"]]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
        NSLog(@"JieSuanEvent==%@",_GoodsListDic);
        NSMutableDictionary *settleDic=[NSMutableDictionary dictionary];
        for (NSString *key in [_GoodsListDic allKeys]) {
            NSString *shopid =[NSString stringWithFormat:@"%@",[_GoodsListDic objectForKey:key][@"shop_id"]];// [_GoodsListDic objectForKey:key][@"shop_id"];
            if([shopID isEqualToString:shopid]){
                [settleDic setObject:[_GoodsListDic objectForKey:key] forKey:key];
            }
        }
        self.hidesBottomBarWhenPushed=YES;
        OrderViewController *orde = [OrderViewController new];
        orde.dataDic = settleDic;
        //    orde.tel=self.
        // orde.gouwucheData=_dataSource;
        [self.navigationController pushViewController:orde animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self ShowAlertTitle:nil Message:@"是否要从购物车把该商品移除" Delegate:self Block:^(NSInteger index) {
        if (index == 1) {
            [self.view addSubview:self.activityVC];
            NSString *number=@"0";
            NSMutableDictionary* param=[NSMutableDictionary dictionary];
            NSString* prodID=[_dataSource[indexPath.row] objectForKey:@"pro_id"];
            [param setObject:prodID forKey:@"prod_id"];
            [param setObject:number forKey:@"number"];
            [[DataBase sharedDataBase] updateCart:param withType:-2];
            [self.appdelegate.shopDictionary setObject:number forKey:@([prodID intValue])];
            [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"GouWuCheShuLiang"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.appdelegate.isRefresh=true;
            if([Stockpile sharedStockpile].isLogin){
//                NSMutableDictionary* groupDic=[[_dataSource objectAtIndex:indexPath.section] mutableCopy];
//                NSMutableArray* listDic=[[groupDic objectForKey:@"prolist"] mutableCopy];
                
                NSMutableDictionary *itemDic=[[_dataSource objectAtIndex:indexPath.row] mutableCopy];
                NSInteger activityid=[[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"activity_id"]] integerValue];
                NSInteger actmaxbuy=[[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"actmaxbuy"]] integerValue];
                NSInteger havedbuy=[[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"havedbuy"]] integerValue];
                NSInteger pro_allnum=[[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"pro_allnum"]] integerValue];
                [_dataSource removeObjectAtIndex:indexPath.row];
                [_clearingArray removeObjectAtIndex:indexPath.row];
                if(_dataSource.count>0){
                    CGFloat amount=[[_dataDic objectForKey:@"amount"] floatValue];
                    CGFloat pro_price=[[itemDic objectForKey:@"pro_price"] floatValue];
                    CGFloat pro_actprice=[[itemDic objectForKey:@"pro_actprice"] floatValue];
                    if(activityid>0){
                        if(actmaxbuy>0){
                            if((actmaxbuy-havedbuy)>0){
                                if((pro_allnum-(actmaxbuy-havedbuy))>0){
                                    amount-=(pro_actprice*(actmaxbuy-havedbuy));
                                    amount-=(pro_price*(pro_allnum-(actmaxbuy-havedbuy)));
                                }else{
                                    amount-=(pro_actprice*pro_allnum);
                                }
                            }else{
                                amount-=(pro_price*pro_allnum);
                            }
                        }else{
                            amount-=(pro_price*pro_allnum);
                        }
                    }else{
                        amount-=(pro_price*pro_allnum);
                    }
                    //[groupDic setObject:[NSString stringWithFormat:@"%f",amount] forKey:@"amount"];
                    //[_dataSource replaceObjectAtIndex:indexPath.section withObject:groupDic];
                    [self setBottomData];
                    [_tableView reloadData];
                }else  if(_dataSource.count==0)
                    [self ReshData];
                [self huoQuGouWuCheShuLiang];
            }else
                [self ReshData];
            [_GoodsListDic removeAllObjects];
            for (NSDictionary *ShopInfo in _dataSource) {
                NSMutableArray *arr = [[ShopInfo objectForKey:@"prod_info"] mutableCopy];
                for (NSDictionary *prodDic in arr) {
                    NSString *key = [NSString stringWithFormat:@"%@",prodDic[@"prod_id"]];
                    if (![prodDic[@"prod_count"] isEqualToString:@"0"]) {
                        [_GoodsListDic setObject:prodDic forKey:key];
                    }
                }
            }
            GouWuCheTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"%@",number);
            if ([number isEqualToString:@"0"])
            {
                [self newView];
            }
        }
    }];
}

#pragma mark - GouWuCheTableViewCellDelegate
#pragma mark - 更新数据库的数量并刷新界面数据
//加减号
-(void)GouWuCheTableViewCellNumber:(NSString *)number indexPath:(NSIndexPath *)indexPath{
    NSDictionary *prodDic=[_dataSource objectAtIndex:indexPath.row];
    NSInteger num=[[NSString stringWithFormat:@"%@",[prodDic objectForKey:@"pro_allnum"]] integerValue];
    //NSLog(@"GouWuCheTableViewCellNumber====%@==%ld",number,num);
    NSInteger activityid=[[NSString stringWithFormat:@"%@",[prodDic objectForKey:@"activity_id"]] integerValue];
    NSInteger actmaxbuy=[[NSString stringWithFormat:@"%@",[prodDic objectForKey:@"actmaxbuy"]] integerValue];
    NSInteger havedbuy=[[NSString stringWithFormat:@"%@",[prodDic objectForKey:@"havedbuy"]] integerValue];
    Boolean isAdd=[number integerValue]>num;
    if(isAdd&&[Stockpile sharedStockpile].isLogin&&activityid>0){
        num=[number integerValue];
        NSInteger actstock=[[NSString stringWithFormat:@"%@",[prodDic objectForKey:@"actstock"]] integerValue];
        if(num>actstock){
            [AppUtil showToast:self.view withContent:@"活动商品，库存不足"];
            return;
        }
        if(actmaxbuy>0&&(havedbuy<actmaxbuy||num>(actmaxbuy-havedbuy))){
            if((num-(actmaxbuy-havedbuy))==1)
                [AppUtil showToast:self.view withContent:[NSString stringWithFormat:@"活动商品限购%ld份，超出%ld份恢复原价",actmaxbuy,actmaxbuy]];
        }
    }
    [self.view addSubview:self.activityVC];
    //NSInteger num=[number integerValue];
    NSMutableDictionary* param=[NSMutableDictionary dictionary];
    NSString* prodID=_dataSource[indexPath.row][@"pro_id"];
    [param setObject:prodID forKey:@"prod_id"];
    [param setObject:number forKey:@"number"];
    [[DataBase sharedDataBase] updateCart:param withType:-2];
    [self.appdelegate.shopDictionary setObject:number forKey:@([prodID intValue])];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"GouWuCheShuLiang"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.appdelegate.isRefresh=true;
    NSMutableDictionary *itemDic=[prodDic mutableCopy];

    if(_dataSource.count==0){
        //[_dataSource removeObjectAtIndex:indexPath.section];
        [self ReshData];
    }else{
        CGFloat amount=[[_dataDic objectForKey:@"amount"] floatValue];
        CGFloat pro_price=[[prodDic objectForKey:@"pro_price"] floatValue];
        CGFloat pro_actprice=[[prodDic objectForKey:@"pro_actprice"] floatValue];
        CGFloat pro_amount=[[prodDic objectForKey:@"pro_amount"] floatValue];
        if(activityid>0){
            if(isAdd){
                if(actmaxbuy>0){
                    if((actmaxbuy-havedbuy)>0&&([number integerValue]-(actmaxbuy-havedbuy))<=0){
                        amount+=pro_actprice;
                        pro_amount+=pro_actprice;
                    }else{
                        amount+=pro_price;
                        pro_amount+=pro_price;
                    }
                }else{
                    amount+=pro_actprice;
                    pro_amount+=pro_actprice;
                }
            }else{
                if(actmaxbuy>0){
                    if((actmaxbuy-havedbuy)>0&&([number integerValue]-(actmaxbuy-havedbuy))<0){
                        amount-=pro_actprice;
                        pro_amount-=pro_actprice;
                    }else{
                        amount-=pro_price;
                        pro_amount-=pro_price;
                    }
                }else{
                    amount-=pro_actprice;
                    pro_amount-=pro_actprice;
                }
            }
        }else{
            if(isAdd){
                amount+=pro_price;
                pro_amount+=pro_price;
            }else{
                amount-=pro_price;
                pro_amount-=pro_price;
            }
        }
        [_dataDic setObject:[NSString stringWithFormat:@"%f",amount] forKey:@"amount"];
        if([number integerValue]<=0){
            [_dataSource removeObjectAtIndex:indexPath.row];
            [_clearingArray removeObjectAtIndex:indexPath.row];
        }else{
            [itemDic setObject:number forKey:@"pro_allnum"];
            [itemDic setObject:[NSString stringWithFormat:@"%f",pro_amount] forKey:@"pro_amount"];
            [_dataSource replaceObjectAtIndex:indexPath.row withObject:itemDic];
        }
    }
    
    if(_dataSource.count==0)
        [self ReshData];
    else{
        [self setBottomData];
        [_tableView reloadData];
    }
    [self huoQuGouWuCheShuLiang];
    [_GoodsListDic removeAllObjects];
    for (NSDictionary *ShopInfo in _dataSource) {
        NSMutableArray *arr = [[ShopInfo objectForKey:@"prolist"] mutableCopy];
        for (NSDictionary *prodDic in arr) {
            NSString *key = [NSString stringWithFormat:@"%@",prodDic[@"pro_id"]];
            if (![prodDic[@"pro_allnum"] isEqualToString:@"0"]) {
                [_GoodsListDic setObject:prodDic forKey:key];
            }
        }
    }
    GouWuCheTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",number);
    if ([number isEqualToString:@"0"])
    {
        [self newView];
    }
}

//选中
-(void)GouWuCheTableViewCellSelected:(BOOL)selected indexPath:(NSIndexPath *)indexPath{
    if(_editBtn.selected){
        [_delArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:selected]];
        for(id b in _delArray){
            if([b boolValue])
                continue;
            else
                return;
        }
        _checkAllBtn.selected=YES;
    }else{
        [_clearingArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:selected]];
        [self setBottomData];
    }
    
//    NSDictionary *ShopInfo=[_dataSource objectAtIndex:indexPath.section];
//    NSLog(@"%@",ShopInfo);
//    NSMutableArray *arr = [[ShopInfo objectForKey:@"prod_info"] mutableCopy];
//    NSDictionary *prodDic=[arr objectAtIndex:indexPath.row];
//    NSString *key = [NSString stringWithFormat:@"%@",prodDic[@"prod_id"]];
//    if (selected) {
//        if (![prodDic[@"prod_count"] isEqualToString:@"0"]) {
//            [_GoodsListDic setObject:prodDic forKey:key];
//        }
//    }else{
//        [_GoodsListDic removeObjectForKey:key];
//    }
//    NSInteger Sum=0;
//    for (NSDictionary *ShopInfo in _dataSource) {
//        NSMutableArray *arr = [[ShopInfo objectForKey:@"prod_info"] mutableCopy];
//        Sum=Sum+arr.count;
//    }
//    UIButton *AllBtn=(UIButton *)[self.view viewWithTag:6666];
//    AllBtn.selected=(Sum!=0 && [_GoodsListDic allKeys].count == Sum);
//    UILabel * carLa = (UILabel *)[_bigVi viewWithTag:100];
//    NSString * heJiString = [NSString stringWithFormat:@"合计:￥%.2f",[self jiSuanAmount]];
//    CGRect rect = [self getStringWithFont:12*self.scale withString:heJiString withWith:[UIScreen mainScreen].bounds.size.width];
//    carLa.frame = CGRectMake(self.view.width - rect.size.width - 90*self.scale-10, _bigVi.height/2-10*self.scale, rect.size.width+30, 20*self.scale);
//    carLa.attributedText = [self getAmountFuWenBenWithStirng:heJiString];
}

#pragma mark -- 获取购物车的数字
- (void)huoQuGouWuCheShuLiang
{
    NSInteger totalNumber = 0;
    NSLog(@"%@",_dataSource);
    
    NSInteger number = 0;
    for (NSDictionary * prod_infoDIc in _dataSource)
    {
        number = number + [prod_infoDIc[@"pro_allnum"] integerValue];
    }
    totalNumber = totalNumber + number;
    NSLog(@"totalNumber::%ld",totalNumber);
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)totalNumber] forKey:@"GouWuCheShuLiang"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self gouWuCheShuZi];
}

#pragma mark -- 购物车的数字
- (void)gouWuCheShuZi
{
    UITabBarItem * item=[self.appdelegate.tabBarController.tabBar.items objectAtIndex:2];
    if ([Stockpile sharedStockpile].isLogin)
    {
        NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
        NSLog(@"%@",value);
        if (value==nil||[value isEqualToString:@""]||[value isEqualToString:@"0"])
        {
            [item setBadgeValue:nil];
        }
        else
        {
            [item setBadgeValue:value];
        }
    }else{
        [item setBadgeValue:nil];
    }
}

-(void) editCart{
    _editBtn.selected=!_editBtn.selected;
    if(_editBtn.selected){
        _delView.hidden=NO;
        _bottomView.hidden=YES;
    }else{
        _delView.hidden=YES;
        _bottomView.hidden=NO;
        for( int i=0; i<_dataSource.count; i++){
            [_delArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:false]];
        }
        if(_checkAllBtn.selected)
            _checkAllBtn.selected=NO;
    }
    [_tableView reloadData];
}

-(void)talk{
    if ([Stockpile sharedStockpile].isLogin==NO) {
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {//登录成功后需要加载的数据
                    NSLog(@"登录成功");
                    [self ReshData];
                }];
            }
        }];
        return;
    }
    RCDChatListViewController *rong = [[RCDChatListViewController alloc]init];
    rong.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:rong animated:YES];
}

#pragma mark - 导航
-(void)newNav{
     self.TitleLabel.text = @"购物车";
    self.TitleLabel.font =[UIFont systemFontOfSize:15*self.scale];
//    UIButton * popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [popBtn setFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
//    [popBtn setImage:[UIImage imageNamed:@"left"] forState:0];
//    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
//    [popBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
//    [self.NavImg addSubview:popBtn];
    _editBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitle:@"完成" forState:UIControlStateSelected];
    _editBtn.frame=CGRectMake(10*self.scale, self.TitleLabel.top+7.5*self.scale, 70*self.scale, 25*self.scale);
    _editBtn.titleLabel.font=DefaultFont(self.scale);
    [_editBtn addTarget:self action:@selector(editCart) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:_editBtn];
    [_editBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_editBtn sizeToFit];
    //17年4.28新添加的消息按钮
    UIButton *talkImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [talkImg setImage:[UIImage imageNamed:@"msg_black"] forState:UIControlStateNormal];
    talkImg.frame=CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top+2*self.scale, self.TitleLabel.height,self.TitleLabel.height);
    [talkImg addTarget:self action:@selector(talk) forControlEvents:UIControlEventTouchUpInside];
    //talkImg.tag = MESSAGE_TAG;
    //talkImg.backgroundColor = [UIColor blackColor];
    //talkImg.alpha = 0;
    [self.NavImg  addSubview:talkImg];
    self.gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self getStartHeight]+44);
    [self.NavImg.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)pop{
    if (_reshNum) {
        _reshNum(@"ok");
    }
    if (_popTwoVi) {
        if (_islunbo) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        UIViewController *vi = self.navigationController.viewControllers[1];
        if ([vi isKindOfClass:[BreakInfoViewController class]]) {
            [self .navigationController popToViewController:vi animated:YES];
        }
        return;
    }else if (_fromLingShou){
        if (_reshLingShou) {
            _reshLingShou(@"ok");
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)qingEvent{
    [self ShowAlertTitle:nil Message:@"你确定清空购物车吗？" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
           // [self ReshData];
            [[DataBase sharedDataBase] clearCart];
            self.appdelegate.isRefresh=true;
            //    [self ShowAlertWithMessage:msg];
            [_dataSource removeAllObjects];
            [self huoQuGouWuCheShuLiang];
            [self newView];
            _bigVi.hidden=YES;
            if (_ifQing) {
                _ifQing(@"ok");
            }
            _otherLb = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 30*self.scale)];
            _otherLb.textAlignment=NSTextAlignmentCenter;
            _otherLb.font=SmallFont(self.scale);
            _otherLb.text=@"购物车暂无商品";
            [self.view addSubview:_otherLb];
            _goShop=[[UILabel alloc] initWithFrame:CGRectMake(self.view.width/2-40*self.scale, self.otherLb.bottom+50*self.scale,80*self.scale, 30*self.scale)];
            _goShop.textAlignment=NSTextAlignmentCenter;
            _goShop.font=SmallFont(self.scale*1.2);
            _goShop.text=@"去购物";
            _goShop.userInteractionEnabled=YES;
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goShoping)];
            [_goShop addGestureRecognizer:tapGesture];
            _goShop.clipsToBounds = YES;
            _goShop.layer.cornerRadius = 3;
            _goShop.layer.borderColor = [UIColor  colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0].CGColor;
            _goShop.layer.borderWidth = 1;
            NSString* shopid= [[NSUserDefaults standardUserDefaults] objectForKey:@"shop_id"];
            if(shopid)
            [self.view addSubview:_goShop];
//            [self.view addSubview:self.activityVC];
//            [self.activityVC startAnimate];
//            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
//            NSDictionary *dic = @{@"user_id":userid};
//            AnalyzeObject *anle = [AnalyzeObject new];
//            [anle clearCartWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
//                [self.activityVC stopAnimate];
//                if ([code isEqualToString:@"0"]) {
//                    self.appdelegate.isRefresh=true;
//                //    [self ShowAlertWithMessage:msg];
//                    [_dataSource removeAllObjects];
//                    [self huoQuGouWuCheShuLiang];
//                    [self newView];
//                    _bigVi.hidden=YES;
//                    if (_ifQing) {
//                        _ifQing(@"ok");
//                    }
//                    _tishi = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 30*self.scale)];
//                    _tishi.textAlignment=NSTextAlignmentCenter;
//                    _tishi.font=SmallFont(self.scale);
//                    _tishi.text=@"购物车暂无商品";
//                    [self.view addSubview:_tishi];
//                }
//            }];
        }
    }];
}

#pragma mark -- 富文本
- (NSMutableAttributedString *)getAmountFuWenBenWithStirng:(NSString *)string{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:blackTextColor range:NSMakeRange(0, 3)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10*self.scale] range:NSMakeRange(3, 1)];
    return attributedString;
}
#pragma mark -- 计算总价格
- (CGFloat)jiSuanAmount
{
    CGFloat amount = 0.0;
    for (NSDictionary *ShopInfo in _dataSource) {
        NSMutableArray *arr = [[ShopInfo objectForKey:@"prod_info"] mutableCopy];
        for (NSDictionary *prodDic in arr) {
            NSString *key = [NSString stringWithFormat:@"%@",prodDic[@"prod_id"]];
            if (![prodDic[@"prod_count"] isEqualToString:@"0"]) {
                 amount = amount + [_GoodsListDic[key][@"price"] floatValue]*[_GoodsListDic[key][@"prod_count"] integerValue];
            }
        }
    }
    return amount;
}

#pragma mark -----返回按钮
-(void)returnVi{
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}

-(void)PopVC:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
}


@end
