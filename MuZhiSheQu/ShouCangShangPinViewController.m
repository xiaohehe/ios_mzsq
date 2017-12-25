//
//  ShouCangShangPinViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShouCangShangPinViewController.h"
#import "ShangPinTableViewCell.h"
#import "BusinessInfoViewController.h"
#import "UmengCollection.h"
#import "AppUtil.h"
#import "GoodsCollectionViewCell.h"
#import "DataBase.h"
static const NSUInteger ADD_CART_TAG = 100000;//增加购物车商品数量
static const NSUInteger CART_NUM_TAG = 200000;//购物车商品数量
static const NSUInteger SUB_CART_TAG = 300000;//减少购物车商品数量

@interface ShouCangShangPinViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *la;
@property(nonatomic,assign)BOOL isLock;
//@property(nonatomic,assign) CGFloat dangerAreaHeight;
@end

@implementation ShouCangShangPinViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    if(self.appdelegate.isRefresh){
        self.appdelegate.isRefresh=false;
        [self headr];
    }
    _peiSongLab.text = [self xianShiPeiSongFei];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource=[NSMutableArray new];
    //_dangerAreaHeight=self.isIphoneX?34:0;
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    [self reshData];
    NSLog(@"requestShopingCart==%@",self.appdelegate.shopDictionary);
}

-(void) setLock{
    _isLock=false;
    NSLog(@"isLock=false");
}

-(void)reshData{
    [_la removeFromSuperview];
    _index++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    AnalyzeObject *anle =[AnalyzeObject new];
    //NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dic = @{@"pindex":index};//@"user_id":userid,@"collect_type":@"1",
    [anle getCollectListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        NSLog(@"getCollectListWithDic==%@",models);
        if (_index==1) {
            [_dataSource removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {
            [self bottomVi];
            [_dataSource addObjectsFromArray:models];
        }
        if (_dataSource.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
            _la.text=@"暂无收藏商品信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:_la];
        }
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        [self.activityVC stopAnimate];
    }];
}

-(void)newView{
    _tableView=[[UITableView  alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale, self.view.width, self.view.height-self.NavImg.bottom-10*self.scale-43.5*self.scale-self.dangerAreaHeight)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[ShangPinTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footr)];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headr)];
    [self.view addSubview:_tableView];
}

-(void)footr{
    
    [self reshData];
}

-(void)headr{
    _index=0;
    [self reshData];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShangPinTableViewCell *cell=(ShangPinTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *smallImgUrl = _dataSource[indexPath.row][@"img"];
    [cell.HeaderImage setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
    cell.NameLabel.text=_dataSource[indexPath.row][@"prod_name"];
    NSString *xiao = @"";
    if([AppUtil isBlank:[_dataSource[indexPath.row] objectForKey:@"description"]])
        xiao=[_dataSource[indexPath.row] objectForKey:@"prod_name"];
    else
        xiao=[_dataSource[indexPath.row] objectForKey:@"description"];
    cell.NumberLabel.text=xiao;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGFloat pri=[[_dataSource[indexPath.row] objectForKey:@"price"] floatValue];
    NSString * priceString = [NSString stringWithFormat:@"￥%.1f/%@",pri,_dataSource[indexPath.row][@"unit"]];
    NSString * firstString = [NSString stringWithFormat:@"%.1f",pri];
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
    NSString* isInvalid=[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"is_invalid"]];
    if(![isInvalid isEqualToString:@"1"]){
        cell.coverView.hidden=NO;
        cell.subBtn.hidden=YES;
        cell.numLb.hidden=YES;
        cell.addBt.hidden=YES;
    }else{
        cell.coverView.hidden=YES;
        cell.addBt.hidden=NO;
    }
    cell.addBt.tag=ADD_CART_TAG+indexPath.row;
    cell.numLb.tag=CART_NUM_TAG+indexPath.row;
    cell.subBtn.tag=SUB_CART_TAG+indexPath.row;
    [cell.addBt addTarget:self action:@selector(changeShopingCartNum:) forControlEvents:UIControlEventTouchUpInside];
    [cell.subBtn addTarget:self action:@selector(changeShopingCartNum:) forControlEvents:UIControlEventTouchUpInside];
    if((_dataSource.count-indexPath.row)==1){
        cell.lineView.hidden=YES;
    }else{
        cell.lineView.hidden=NO;
    }
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
            [self headr];
    }else{
        //[self.appdelegate.shopDictionary removeAllObjects];
        if(isRefresh)
            [self headr];
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
    //商店营业情况，*****需要处理2017-11-13
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
    [par setObject:goods[@"shop_id"] forKey:@"shop_id"];
    [par setObject:goods[@"shop_name"] forKey:@"shop_name"];
    [par setObject:@"" forKey:@"shop_logo"];//goods[@"logo"]
    [par setObject:goods[@"free_delivery_amount"] forKey:@"free_delivery_amount"];
    [par setObject:goods[@"delivery_fee"] forKey:@"delivery_fee"];
    [par setObject:goods[@"prod_id"] forKey:@"prod_id"];
    [par setObject:goods[@"prod_name"] forKey:@"prod_name"];
    NSString *string = [NSString stringWithFormat:@"%@",[goods objectForKey:@"img"]];
   // NSArray *imgArr = [string componentsSeparatedByString:@"|"];
    [par setObject:string forKey:@"img1"];
    [par setObject:goods[@"origin_price"] forKey:@"origin_price"];
    //[par setObject:goods[@"price"]forKey:@"price"];
    //[par setObject:goods[@"unit"] forKey:@"unit"];
    NSInteger num=[self.appdelegate.shopDictionary[@([goods[@"prod_id"]  intValue])] intValue];
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
        [self.appdelegate.shopDictionary setObject:[NSString stringWithFormat:@"%d",num] forKey:@([goods[@"prod_id"] intValue])];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cartNum+1] forKey:@"GouWuCheShuLiang"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        num--;
        [[DataBase sharedDataBase] updateCart:par withType:0];
        [self.appdelegate.shopDictionary setObject:[NSString stringWithFormat:@"%d",num] forKey:@([goods[@"prod_id"] intValue])];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*self.scale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* isInvalid=[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"is_invalid"]];
    NSLog(@"isInvalid==%@",isInvalid);
    if(![isInvalid isEqualToString:@"1"]){
        [AppUtil showToast:tableView withContent:@"商品已失效"];
        return;
    }
    self.hidesBottomBarWhenPushed=YES;
    BOOL issleep;
    ShangPinTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.addLa isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
        issleep=YES;
    }else{
        issleep=NO;
    }
    ShopInfoViewController *buess = [ShopInfoViewController new];
//    [buess reshChoucang:^(NSString *str) {
//        _index=0;
//        [self reshData];
//        
//    }];
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
    buess.issleep=issleep;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view addSubview:self.activityVC];
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSDictionary *dic = @{@"user_id":[self getuserid],@"collect_id":_dataSource[indexPath.row][@"prod_id"]};
        [anle delCollectWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"0"]) {
                _index=0;
                [self reshData];
            }
            [self.activityVC stopAnimate];
        }];
    }
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"常购商品";
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

//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.view.width-10*self.scale)/3,150*self.scale);
    //return [RightCollectionViewCell ccellSize];
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

//动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //NSLog(@"numberOfItemsInSection==%ld",_rightData.count);
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GoodsCollectionViewCell class]) forIndexPath:indexPath];
    NSString *url=@"";
    //店铺列表图片
    NSString *cut = [_dataSource[indexPath.row] objectForKey:@"img1"];
    NSString *imagename = [cut lastPathComponent];
    NSString *path = [cut stringByDeletingLastPathComponent];
    NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb320."]];
    NSLog(@"smallImgUrl==%@",smallImgUrl);
    // NSLog(@"smallImgUrl===%@",cut);
    //    if (cut.length>0) {
    //        url = [cut substringToIndex:[cut length] - 4];
    //    }
    [cell.goodsCoverIv setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
    NSString* isInvalid=[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"is_invalid"]];
    if([isInvalid isEqualToString:@"1"]){
        //cell.coverView.hidden=NO;
        UIView* coverView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.goodsCoverIv.width, cell.goodsCoverIv.height)];
        coverView.contentMode=UIViewContentModeScaleAspectFill;
        coverView.backgroundColor=[UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.4];
        coverView.clipsToBounds=YES;
        [cell.goodsCoverIv addSubview:coverView];
        UILabel* loseEfficacy=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80*self.scale, cell.goodsCoverIv.height-20*self.scale)];
        loseEfficacy.font=DefaultFont(self.scale);
        loseEfficacy.backgroundColor=[UIColor clearColor];
        loseEfficacy.textAlignment=NSTextAlignmentCenter;
        loseEfficacy.textColor = [UIColor whiteColor];
        loseEfficacy.text=@"已失效";
        [coverView addSubview:loseEfficacy];
        [coverView addSubview:loseEfficacy];
    }else{
        //cell.coverView.hidden=YES;
    }
    cell.goodsNameLb.text=[_dataSource[indexPath.row] objectForKey:@"prod_name"];
    if (![AppUtil isBlank:_dataSource[indexPath.row][@"description"]]) {
        cell.goodsDescLb.text=[_dataSource[indexPath.row][@"description"] trimString];
    }else{
        cell.goodsDescLb.text=[_dataSource[indexPath.row] objectForKey:@"prod_name"];
    }
    CGFloat price=[[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"price"]] floatValue];
    NSString * preceString = [NSString stringWithFormat:@"￥%.1f/%@",price,_dataSource[indexPath.row][@"unit"]];
    NSString * firstString = [NSString stringWithFormat:@"￥%.1f",price];
    NSString * secondString = [NSString stringWithFormat:@"/%@",_dataSource[indexPath.row][@"unit"]];
    CGRect PriceRect = [self getStringWithFont:12*self.scale withString:preceString withWith:999999];
    UIFont* priFont=SmallFont(self.scale*0.8);
    cell.goodsPriceLb.frame=CGRectMake(8*self.scale, cell.goodsDescLb.bottom,PriceRect.size.width,15*self.scale);
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:preceString];
    [attributeString addAttribute:NSFontAttributeName value:priFont range:NSMakeRange(1, firstString.length-1)];
    cell.goodsPriceLb.attributedText = attributeString;
    //原价
    CGFloat originPrice=[[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"origin_price"]] floatValue];
    NSString * oldPriceString = [NSString stringWithFormat:@"￥%.1f",originPrice];
    CGRect oldRect =  [self getStringWithFont:10*self.scale withString:oldPriceString withWith:9999999];
    cell.goodsOldPriceLb.frame =CGRectMake(cell.goodsCoverIv.width-oldRect.size.width-10*self.scale, cell.goodsPriceLb.bottom-oldRect.size.height-1, oldRect.size.width,oldRect.size.height);
    //        oldPrice.backgroundColor = [UIColor redColor];
    cell.goodsOldPriceLb.text=oldPriceString;
    UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(0, cell.goodsOldPriceLb.height/2, cell.goodsOldPriceLb.width, .5)];
    lin.backgroundColor=grayTextColor;
    [cell.goodsOldPriceLb addSubview:lin];
    NSString* prodID=_dataSource[indexPath.row][@"prod_id"];
    int* index=[self.appdelegate.shopDictionary[@([prodID intValue])] intValue];
    if(index>0){
        [self addedCart:cell.goodsCoverIv];
    }
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addToCart:)];
    [cell.goodsCoverIv addGestureRecognizer:tapGesture];
    [tapGesture view].tag=100000+indexPath.row;
    return cell;
}


-(void) addedCart:(UIImageView*)img{
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

-(void)addToCart:(UITapGestureRecognizer*) tap{
    NSMutableDictionary *shopInfo = [_dataSource[[tap view].tag-100000] mutableCopy];
    NSString* prodID=shopInfo[@"id"];
    NSString* shopID=shopInfo[@"shop_id"];
    NSLog(@"img_tag==%@==%@",shopInfo,prodID);
    [shopInfo setObject:prodID forKey:@"prod_id"];
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
    if(_isLock){
        return;
    }else{
        _isLock=true;
        [self performSelector:@selector(setLock) withObject:nil afterDelay:0.3f];
    }
    int index=[self.appdelegate.shopDictionary[@([prodID intValue])] intValue];
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
        [self addedCart:[tap view]];
        [self.appdelegate.shopDictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@([prodID intValue])];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cartNum+1] forKey:@"GouWuCheShuLiang"];
    }
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* isInvalid=[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"is_invalid"]];
    NSLog(@"isInvalid==%@",isInvalid);
    if([isInvalid isEqualToString:@"1"]){
        [AppUtil showToast:collectionView withContent:@"商品已失效"];
        return;
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed=YES;
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GoodsCollectionViewCell class]) forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor greenColor]];
    ShopInfoViewController *buess = [ShopInfoViewController new];
    //    [buess reshChoucang:^(NSString *str) {
    //        _index=0;
    //        [self reshData];
    //    }];
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
   // buess.issleep=issleep;
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
     NSNumber* num = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
    NSString * value = [NSString stringWithFormat:@"%@",num];
    if (num==nil||[value isEqualToString:@""]||[value isEqualToString:@"0"]){
        _numberImg.hidden=YES;
    }else{
        [_numberImg setTitle:[NSString stringWithFormat:@"%@",value] forState:UIControlStateNormal];
        _numberImg.hidden=NO;
    }
    _numberImg.titleLabel.font = Small10Font(self.scale);
    [shopcarImgL addSubview:_numberImg];
    float r = shopcarImgL.right;
    float t = shopcarImgL.top;
    //    _shopCarLa = [[UILabel alloc]initWithFrame:CGRectMake(r+5*self.scale,0, [UIScreen mainScreen].bounds.size.width - r - 110*self.scale , 20*self.scale)];
    //    _shopCarLa.attributedText = [self jiSuanBenDianXiaoFei];
    //    _shopCarLa.font=Small10Font(self.scale);
    //    _shopCarLa.textColor = [UIColor redColor];
    //    [self.botRTwo addSubview:_shopCarLa];
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
    gradientLayer.frame = CGRectMake(0, 0, 80*self.scale , 49*self.scale);
    [shopCarR.layer insertSublayer:gradientLayer atIndex:0];
    
    [self.botRTwo addSubview:shopCarR];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _bottomL.top, self.view.width, .5)];
    line.backgroundColor=blackLineColore;
    [self.view addSubview:line];
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

-(void)godingdan{
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- 购物车的数字
- (void)gouWuCheShuZi
{
    UITabBarItem * item=[self.appdelegate.tabBarController.tabBar.items objectAtIndex:2];
    NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
    NSLog(@"%@",value);
    if (value==nil||[value isEqualToString:@""]||[value isEqualToString:@"0"])
    {
        [item setBadgeValue:@"0"];
        _numberImg.hidden=YES;
    }else{
        [_numberImg setTitle:[NSString stringWithFormat:@"%@",value] forState:UIControlStateNormal];
        _numberImg.hidden=NO;
        [item setBadgeValue:value];
    }
}
@end
