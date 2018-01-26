//
//  SouViewController.m
//  MuZhiSheQu
//
//  Created by lmy on 2016/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SouViewController.h"
#import "SouListCell.h"
#import "ShopInfoViewController.h"
#import "BreakfastCellTableViewCell.h"
#import "GouWuCheViewController.h"
#import "BreakInfoViewController.h"
#import "DataBase.h"
#import "AppUtil.h"
#import "GoodsCollectionViewCell.h"
#import "ShangPinTableViewCell.h"
#import "HotSearchCollectionViewCell.h"
#import "PlotCell.h"

static const NSUInteger ADD_CART_TAG = 100000;//增加购物车商品数量
static const NSUInteger CART_NUM_TAG = 200000;//购物车商品数量
static const NSUInteger SUB_CART_TAG = 300000;//减少购物车商品数量
@interface SouViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *la;
@property(nonatomic,strong)UIButton * numberImg;
@property(nonatomic,strong)NSString * carPrice;
@property(nonatomic,strong)NSDictionary * remindDic;
@property(nonatomic,strong)UILabel * peiSongLab;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)CGFloat totalPrice;
@property(nonatomic,assign)BOOL isLock;
@property(nonatomic,strong)UIView *keywordsView;
@property(nonatomic,strong)UICollectionView *hotSearchCollectionView;//热搜
@property(nonatomic,strong)UITableView *historyTableView;//搜索历史
@property(nonatomic,strong)UILabel *hotSearchLb;//热搜
@property(nonatomic,strong)UILabel *searchHistoryLb;//搜索历史
@property(nonatomic,strong)NSMutableArray *hotSearchData;
@property(nonatomic,strong)NSMutableArray *searchHistoryData;
@property(nonatomic,assign)BOOL isFirst;

@end
@implementation SouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirst=YES;
    _data=[NSMutableArray new];
    _index=0;
    if ([_shop_id isEqualToString:@""] || [_shop_id isEqual:[NSNull null]] || _shop_id == nil){
        _shop_id = @"";
        _shop_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"]];
    }
    [self returnVi];
    [self newView];
    [self.view addSubview:self.activityVC];
    _dataSource=[[NSMutableArray alloc]init];
    _hotSearchData=[[NSMutableArray alloc]init];
    _searchHistoryData=[[NSMutableArray alloc]init];
    [self newKeywordsView];
    if(_isRedirectTo){
        UITextField *souTf=[self.view viewWithTag:888];
        souTf.text=_keyword;
        [self startSearch:souTf];
    }
}

-(void)newKeywordsView{
    _keywordsView= [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom-self.dangerAreaHeight)];
    _keywordsView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_keywordsView];
    _hotSearchLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 35*self.scale)];
    _hotSearchLb.backgroundColor=[UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.00];
    _hotSearchLb.text=@"    热门搜索";
    _hotSearchLb.font=[UIFont systemFontOfSize:15];
    _hotSearchLb.textColor=[UIColor colorWithRed:0.290 green:0.290 blue:0.290 alpha:1.00];
    [_keywordsView addSubview:_hotSearchLb];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.hotSearchCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(5*self.scale, self.hotSearchLb.bottom+5*self.scale, self.view.width-10*self.scale, 80*self.scale) collectionViewLayout:layout];
    self.hotSearchCollectionView.backgroundColor=[UIColor whiteColor];
    self.hotSearchCollectionView.dataSource=self;
    self.hotSearchCollectionView.delegate=self;
    //self.collectionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.hotSearchCollectionView.showsHorizontalScrollIndicator=NO;
    self.hotSearchCollectionView.showsVerticalScrollIndicator=NO;
    [self.hotSearchCollectionView registerClass:[HotSearchCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HotSearchCollectionViewCell class])];
    [_keywordsView addSubview:self.hotSearchCollectionView];
    
    _searchHistoryLb=[[UILabel alloc]initWithFrame:CGRectMake(0, _hotSearchCollectionView.bottom, self.view.width, 35*self.scale)];
    _searchHistoryLb.backgroundColor=[UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.00];
    _searchHistoryLb.text=@"    搜索历史";
    _searchHistoryLb.font=[UIFont systemFontOfSize:15];
    _searchHistoryLb.textColor=[UIColor colorWithRed:0.290 green:0.290 blue:0.290 alpha:1.00];
    [_keywordsView addSubview:_searchHistoryLb];
    
    _historyTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, _searchHistoryLb.bottom, self.view.frame.size.width,self.view.height-_searchHistoryLb.bottom )];
    [_historyTableView registerClass:[PlotCell class] forCellReuseIdentifier:@"PlotCell"];
    _historyTableView.backgroundColor=[UIColor whiteColor];
    [_keywordsView addSubview:_historyTableView];
    _historyTableView.showsVerticalScrollIndicator = NO;
    _historyTableView.delegate=self;
    _historyTableView.dataSource=self;
    _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    if(self.appdelegate.isRefresh){
        self.appdelegate.isRefresh=false;
        [self xiala];
    }
     _peiSongLab.text = [self xianShiPeiSongFei];
}

-(void) setLock{
    _isLock=false;
    NSLog(@"isLock=false");
}

-(void)reshData{
    _index++;
    self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    [self.activityVC startAnimating];
    UITextField *tf=[self.view viewWithTag:888];
    AnalyzeObject *anal=[AnalyzeObject new];
    NSDictionary *dic=@{@"skey":tf.text.trimString,@"pindex":[NSString stringWithFormat:@"%ld",(long)_index],@"shopid":_shop_id};
    if(_index==1)
        [[DataBase sharedDataBase] updateHistory:tf.text.trimString];
    [anal shouYeSouList:dic Block:^(id models, NSString *code, NSString *msg) {
        //NSLog(@"sou_result====:%@",models);
        [self shangJiaXiangQing];
        [self.activityVC stopAnimate];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if (_index==1) {
            [_data removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {
            if(_isFirst)
                _isFirst=NO;
            NSArray* modArr=models;
            [self bottomVi];
            [_data addObjectsFromArray:models];
            if(_index>1&&[AppUtil arrayIsEmpty:modArr]){
                _tableView.footer.state=MJRefreshFooterStateNoMoreData;
            }
        }
        [_tableView reloadData];
        if (_la) {
            [_la removeFromSuperview];
        }
        if (_data.count<=0){
            _la = [[UILabel alloc]initWithFrame:self.view.bounds];
            _la.alpha=.6;
            _la.font=DefaultFont(self.scale);
            _la.text=@"暂无内容！";
            _la.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:_la];
        }
    }];
}

-(void)shangla{
    [self reshData];
}

-(void)xiala{
    _index=0;
    [self reshData];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void) startSearch:(UITextField *)textField{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    [self xiala];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self startSearch:textField];
    return YES;
}

-(void)dismissKeyBoard{
    UITextField *souTf=[self.view viewWithTag:888];
    [souTf resignFirstResponder];
}

-(void)newView{
    self.view.backgroundColor=superBackgroundColor;
    UIImageView *souVi=[[UIImageView alloc]initWithFrame:CGRectMake(self.TitleLabel.height-5*self.scale, [self getStartHeight]+(self.isIphoneX?0:5*self.scale), self.view.width-5*self.scale-self.TitleLabel.height, 25*self.scale)];
    souVi.layer.cornerRadius=5;
    souVi.userInteractionEnabled=YES;
    souVi.backgroundColor=whiteLineColore;
    souVi.layer.borderWidth=.5;
    souVi.layer.borderColor=[[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1] CGColor];
    [self.view addSubview:souVi];
    UIImageView *souImg=[[UIImageView alloc]initWithFrame:CGRectMake(5*self.scale, 5*self.scale, souVi.height-10*self.scale, souVi.height-10*self.scale)];
    souImg.image=[UIImage imageNamed:@"search"];
    [souVi addSubview:souImg];
    
    UITextField *souTf=[[UITextField alloc]initWithFrame:CGRectMake(souImg.right+5*self.scale, 0, souVi.width-souImg.right, souVi.height)];
    souTf.placeholder=@"请你输入想要买的商品名称";
    [souTf setValue:[UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    souTf.textColor=[UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1];
    souTf.font=SmallFont(self.scale);
    souTf.tag=888;
    souTf.delegate=self;
    souTf.returnKeyType=UIReturnKeySearch;
    [souTf becomeFirstResponder];
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收起" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [souTf setInputAccessoryView:topView];

    [souVi addSubview:souTf];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, souVi.bottom+10*self.scale, self.view.width, self.view.height-souVi.bottom-10*self.scale-43.5*self.scale-self.dangerAreaHeight)];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
    self.tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ShangPinTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_historyTableView]) {
        return _searchHistoryData.count;
    }
    return _data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_historyTableView]) {
        PlotCell *cell=[PlotCell cellWithTableView:tableView];
        cell.name.text=_searchHistoryData[indexPath.row];
        cell.line.hidden=YES;
        return cell;
    }
    ShangPinTableViewCell *cell=(ShangPinTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *cut = [_data[indexPath.row] objectForKey:@"imgs"][0];
    NSArray *imgArr = [cut componentsSeparatedByString:@"|"];
    NSString *imagename = [imgArr[0] lastPathComponent];
    NSString *path = [cut stringByDeletingLastPathComponent];
    NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"."]];
    //NSString *smallImgUrl = _dataSource[indexPath.row][@"imgs"][0];
    [cell.HeaderImage setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
    cell.NameLabel.text=_data[indexPath.row][@"prodname"];
    NSString *xiao = @"";
    if([AppUtil isBlank:[_data[indexPath.row] objectForKey:@"description"]])
        xiao=[_data[indexPath.row] objectForKey:@"prodname"];
    else
        xiao=[_data[indexPath.row] objectForKey:@"description"];
    cell.NumberLabel.text=xiao;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGFloat pri=[[_data[indexPath.row] objectForKey:@"price"] floatValue];
    NSString * priceString = [NSString stringWithFormat:@"￥%.1f/%@",pri,_data[indexPath.row][@"unit"]];
    NSString * firstString = [NSString stringWithFormat:@"%.1f",pri];
    NSMutableAttributedString * priceAttributeString = [[NSMutableAttributedString alloc]initWithString:priceString];
    [priceAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*self.scale] range:NSMakeRange(1, firstString.length)];
    cell.PriceLabel.attributedText = priceAttributeString;
    NSString *prod_id = _data[indexPath.row][@"id"];
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
    if((_data.count-indexPath.row)==1){
        cell.lineView.hidden=YES;
    }else{
        cell.lineView.hidden=NO;
    }
    return cell;
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

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate{
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_historyTableView]) {
        return 50;
    }
    return 80*self.scale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_historyTableView]) {
        UITextField *souTf=[self.view viewWithTag:888];
        souTf.text=_searchHistoryData[indexPath.row];
        [self startSearch:souTf];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed=YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //NSString *ID = [_data[indexPath.row]objectForKey:@"id"];
    BOOL issleep;
    BreakfastCellTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.addLa.text isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
        issleep=YES;
    }else{
        issleep=NO;
    }
    ShopInfoViewController *buess = [ShopInfoViewController new];
    if ([_data[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
        buess.isopen=NO;
    }else{
        buess.isopen=YES;
    }
    buess.isgo=YES;
    buess.issleep=issleep;
    buess.yes=NO;
    buess.price =_data[indexPath.row][@"prod_price"];
    buess.shop_name=_data[indexPath.row][@"shop_name"];
    buess.orshoucang=YES;
    buess.shop_user_id=_data[indexPath.row][@"shop_user_id"];
    buess.shop_id = _data[indexPath.row][@"shop_id"];
    buess.prod_id = _data[indexPath.row][@"id"];
    buess.xiaoliang = _data[indexPath.row][@"sales"];
    buess.shoucang = _data[indexPath.row][@"collect_time"];
    buess.gongGao = _data[indexPath.row][@"notice"];
    buess.tel=[NSString stringWithFormat:@"%@",_data[indexPath.row][@"hotline"]];
    NSLog(@"ShopInfoViewController==%@==%@==%@",_data[indexPath.row],_data[indexPath.row][@"id"],self.appdelegate.shopDictionary);
    buess.param=_data[indexPath.row];
    [self.navigationController pushViewController:buess animated:YES];
}

#pragma mark -----返回按钮
-(void)returnVi{
    //self.TitleLabel.text=@"产品搜索列表";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    UIImageView *topLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom-0.5, self.view.width, 0.5)];
    topLine.backgroundColor=blackLineColore;
    [self.NavImg addSubview:topLine];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    if(_isFirst){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if(_keywordsView.hidden==NO){
        _keywordsView.hidden=YES;
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [self xiala];
    }else{
        //[self.appdelegate.shopDictionary removeAllObjects];
        if(isRefresh)
            [self xiala];
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
    NSDictionary* goods=_data[index];
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
    NSNumber* num=[[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
    NSString * value = [NSString stringWithFormat:@"%@",num];
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

#pragma mark -- 计算本店消费多少元
-  (NSMutableAttributedString *)jiSuanBenDianXiaoFei{
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
    NSNumber* num=[[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
    NSString * value = [NSString stringWithFormat:@"%@",num];
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
    
#pragma mark -- 商家详情接口
-(void)shangJiaXiangQing{
    NSDictionary *dic=[NSDictionary new];
    dic = @{@"shop_id":self.shop_id};
    if ([Stockpile sharedStockpile].isLogin) {
        dic=@{@"user_id":[self getuserid],@"shop_id":self.shop_id};
    }
    //NSLog(@"商家详情参数==%@",dic);
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    [analyze ShopshopInfoWithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            _remindDic = models;
            //NSLog(@"商家详情==%@",models);
            //_shopCarLa.attributedText = [self jiSuanBenDianXiaoFei];
            _peiSongLab.text = [self xianShiPeiSongFei];
        }
    }];
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
//    if ([Stockpile sharedStockpile].isLogin==NO) {
//        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
//            if (index==1) {
//                LoginViewController *login = [self login];
//                [login resggong:^(NSString *str) {
//                    [self requestShopingCart:true];
//                }];
//            }
//        }];
//        return;
//    }
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
 }

#pragma mark-------去购物车，  去订单订单详情
-(void)goShopCar{
//    if ([Stockpile sharedStockpile].isLogin==NO) {
//        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
//            if (index==1) {
//                LoginViewController *login = [self login];
//                [login resggong:^(NSString *str) {
//                    [self requestShopingCart:true];
//                }];
//            }
//        }];
//        return;
//    }
    self.hidesBottomBarWhenPushed=YES;
    GouWuCheViewController *gouwuceh = [GouWuCheViewController new];
    gouwuceh.isShowBack=true;
    [self.navigationController pushViewController:gouwuceh animated:YES];
}

-(void)loadShopingCart{
    NSString *userid =  [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dic = @{@"user_id":userid};
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy showCartWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            [_dataSource addObjectsFromArray:models];
            for (NSDictionary *ShopInfo in _dataSource) {
                NSMutableArray *arr = [[ShopInfo objectForKey:@"prod_info"] mutableCopy];
                for (NSDictionary *prodDic in arr) {
                    if (![prodDic[@"prod_count"] isEqualToString:@"0"]) {
                        self.totalPrice += [prodDic[@"price"] floatValue]*[prodDic[@"prod_count"] integerValue];
                    }
                }
            }
            NSLog(@"price:%f",self.totalPrice);
        }
    }];
}


//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [HotSearchCollectionViewCell ccellSize];
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
    return _hotSearchData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HotSearchCollectionViewCell class]) forIndexPath:indexPath];
    //cell.keywordsLb.text=@"测试";
    cell.keywordsLb.text=_hotSearchData[indexPath.row];
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
    NSMutableDictionary *shopInfo = [_data[[tap view].tag-100000] mutableCopy];
    NSString* prodID=shopInfo[@"id"];
    NSString* shopID=shopInfo[@"shop_id"];
    NSLog(@"img_tag==%@==%@",shopInfo,prodID);
    
    [shopInfo setObject:prodID forKey:@"prod_id"];
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
    if(_isLock){
        return;
    }else{
        _isLock=true;
        [self performSelector:@selector(setLock) withObject:nil afterDelay:0.3f];
    }
    int index=[self.appdelegate.shopDictionary[@([prodID intValue])] intValue];
    NSMutableDictionary* param=[shopInfo mutableCopy];
    //[param setObject:@"" forKey:@"shop_logo"];
    NSNumber* num=[[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
    NSString * value = [NSString stringWithFormat:@"%@",num];
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
    [self gouWuCheShuZi];
    
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UITextField *souTf=[self.view viewWithTag:888];
    souTf.text=_hotSearchData[indexPath.row];
    [self startSearch:souTf];
}

-(void) setHistoryViewData{
    //[self.view addSubview:_keywordsView];
    _keywordsView.hidden=NO;
    if([_hotSearchData count]==0){
        AnalyzeObject *anle = [AnalyzeObject new];
        NSDictionary *dic=@{@"shopid":_shop_id};
        [anle getHotSearchKey:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
                [_hotSearchData addObjectsFromArray:models];
                NSLog(@"getHotSearchKey==%d==%@",_hotSearchData.count,_hotSearchData);
                [_hotSearchCollectionView reloadData];
            }
        }];
    }
    [_searchHistoryData removeAllObjects];
    NSMutableArray* hisArr=[[DataBase sharedDataBase] getAllFromHistory];
    [_searchHistoryData addObjectsFromArray:hisArr];
    NSLog(@"history==%d==%@",_searchHistoryData.count,_searchHistoryData);
    [_historyTableView reloadData];
}

// 获得焦点
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self setHistoryViewData];
    return YES;
}

// 失去焦点
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _keywordsView.hidden=YES;
}


@end
