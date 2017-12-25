//
//  GoodsViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/8/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "GoodsViewController.h"
#import "ShopInfoViewController.h"
#import "BusinessInfoViewController.h"
#import "GouWuCheViewController.h"
#import "UmengCollection.h"
#import "SouViewController.h"
#import "DataBase.h"
#import "AppUtil.h"
#import "RightCollectionViewCell.h"
#import "UIColor+Hex.h"
#import "BreakInfoTableViewCell.h"
#import "SortCollectionViewCell.h"
#import "RCDChatListViewController.h"

@interface GoodsViewController ()<BreakInfoCellDelegate>//shopInfoDelegate
@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIView *sortView;
@property(nonatomic,strong)UIButton *sortBtn,*defBtn,*salesBtn;//分类（默认全部），默认排序，销量排序
@property(nonatomic,strong)UITableView *rightTable;
@property(nonatomic,strong)UIButton *souTf;
@property(nonatomic,strong)NSMutableArray *arr,*list;
@property(nonatomic,assign)NSInteger index,number,sort;
@property(nonatomic,strong)NSMutableArray *data,*rightData;
@property(nonatomic,strong)NSMutableDictionary *GoodsList,*carData;
@property(nonatomic,strong)reshshoucang block;
@property(nonatomic,assign)BOOL shoucang;
@property(nonatomic,strong)NSString * carNum;
@property(nonatomic,strong)NSString * carPrice;
@property(nonatomic,assign)BOOL orshou;
@property(nonatomic,strong)UILabel *tishiLa;
@property(nonatomic,strong)NSDictionary * remindDic;
@property(nonatomic,assign)NSInteger pindex;//一级分类的当前项
@property(nonatomic,strong) NSDictionary* shopInfo;
@property(nonatomic,assign)BOOL isLock;
@property(nonatomic,assign)BOOL isOpenCol;
@property(nonatomic,strong)NSString * curClassID;//当前分类ID
@property(nonatomic,assign)BOOL isFirst;
@end

@implementation GoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor whiteColor];
    _shop_id= [[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"];
    if(!_shop_id){
        self.appdelegate.tabBarController.selectedIndex=0;
        return;
    }
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
    [self leftScrollview];
    [self RightTable];
    [self setHeaderView];
   // [self RightCollectionView];
    //[self shangJiaXiangQing];
    [self returnView];
    _index=0;
    _sort=0;
    _pindex=0;
    _isOpenCol=true;
    //[self ReshData];
    [self isDoBusiness];
    _arr = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData)  name:@"reloadNearby" object:nil];
    if ([Stockpile sharedStockpile].isLogin) {
        [self requestShopingCart:true];
    }else{
        [self ReshData];
    }
    _isFirst=true;
}

-(void) reloadData{
    _shop_id= [[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"];
    _index=0;
    [self ReshData];
}

-(void) setLock{
    _isLock=false;
    NSLog(@"isLock=false");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UmengCollection intoPage:NSStringFromClass([self class])];
//    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //[self ReshBotView];
    //[self shangJiaXiangQing];
    if(!_isFirst){
        [_rightTable reloadData];
    }else{
        _isFirst=false;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

-(void) isDoBusiness{
    NSDictionary *dic = [NSDictionary new];
    dic=@{@"ShopID":self.shop_id};
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
-(void)ReshData{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    _index++;
    NSDictionary *dic = [NSDictionary new];
    dic=@{@"shopid":self.shop_id,@"classid":@"0"};
    //NSLog(@"getRetailShopClasswithDicparam==%@",dic);
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    [analyze getRetailShopClasswithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            _data=models;
            NSLog(@"getRetailShopClasswithDic==%@",_data);
            if(_data==nil||_data.count==0){
                return ;
            }
            [self leftScrollview];
            [_collectionView reloadData];
            _curClassID=[_data[0] objectForKey:@"CategoryID"];
            NSDictionary *dic2 = [NSDictionary new];
            if (_isPush) {
                dic2 = @{@"shopid":self.shop_id,@"classid":[_data[0] objectForKey:@"CategoryID"],@"sort":[NSString stringWithFormat:@"%ld",_sort],@"pindex":[NSString stringWithFormat:@"%ld",_index]};
            }else{
                //NSLog(@"shop_id==class_id==%@",[_data[0] objectForKey:@"CategoryID"]);
                dic2 = @{@"shopid":self.shop_id,@"classid":[_data[0] objectForKey:@"CategoryID"],@"sort":[NSString stringWithFormat:@"%ld",_sort],@"pindex":[NSString stringWithFormat:@"%ld",_index]};
            }
            [analyze getProdListByClasswithDic:dic2 WithBlock:^(id models, NSString *code, NSString *msg) {
                NSLog(@"getProdListByClasswithDic==11%@",models);
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
                [self modifyHeaderView:false];
            }];
        }
    }];
    [_collectionView.footer endRefreshing];
    [_collectionView.header endRefreshing];
}

#pragma mark -- 购物车的数字
- (void)gouWuCheShuZi{
    UITabBarItem * item=[self.appdelegate.tabBarController.tabBar.items objectAtIndex:2];
    if ([Stockpile sharedStockpile].isLogin){
        NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"GouWuCheShuLiang"];
        NSLog(@"%@",value);
        if (value==nil||[value isEqualToString:@""]||[value isEqualToString:@"0"]){
            [item setBadgeValue:nil];
        }else{
            [item setBadgeValue:value];
        }
    }else{
        [item setBadgeValue:nil];
    }
}

-(void)ReshBotView{
    NSInteger totalNumber = 0;
    NSString* shop_id= [[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"];
    NSArray* array= [[DataBase sharedDataBase] getAllFromCart:shop_id];
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
-(void)returnView{
    //    NSLog(@"%@",self.titlete);
    //    self.TitleLabel.text=self.titlete;
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    //    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    //    UIButton *xiangqing = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [xiangqing setTitle:@"商家详情" forState:UIControlStateNormal];
    //    xiangqing.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14*self.scale];
    //    xiangqing.frame=CGRectMake(self.view.width-70*self.scale, self.TitleLabel.top, 60*self.scale, self.TitleLabel.height);
    //    [xiangqing addTarget:self action:@selector(xiangqingBtn) forControlEvents:UIControlEventTouchUpInside];
    //    [self.NavImg addSubview:xiangqing];
    UIView *souVi=[[UIView alloc]initWithFrame:CGRectMake(10*self.scale,[self getStartHeight]+self.TitleLabel.height/2- (0.087743*(self.view.width-20*self.scale-self.TitleLabel.height))/2, self.view.width-20*self.scale-self.TitleLabel.height+12*self.scale, 0.087743*(self.view.width-20*self.scale-self.TitleLabel.height))];
    //souVi.alpha =0;
    //    souVi.image=[UIImage imageNamed:@"so_2"];
    souVi.userInteractionEnabled=YES;
    souVi.backgroundColor =[UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1.00];
    souVi.tag = 9999999;
    souVi.clipsToBounds = YES;
    souVi.layer.cornerRadius = 3;//souVi.height/2;
    [self.NavImg addSubview:souVi];
    UIImageView *souImg=[[UIImageView alloc]initWithFrame:CGRectMake(souVi.height/2-6*self.scale, 3*self.scale, souVi.height-6*self.scale, souVi.height-6*self.scale)];
    souImg.image=[UIImage imageNamed:@"search"];
    souImg.alpha = 0.5;
    [souVi addSubview:souImg];
    _souTf=[[UIButton alloc]initWithFrame:CGRectMake(souImg.right, 0, souVi.width-souImg.right, souVi.height)];
    [_souTf setTitle:@" 搜索便利店商品" forState:UIControlStateNormal];
    [_souTf setTitleColor:[UIColor colorWithHexString:@"#6A6A6A"] forState:UIControlStateNormal];
    _souTf.titleLabel.font=[UIFont systemFontOfSize:14.0];
    _souTf.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_souTf addTarget:self action:@selector(skipToSearchView) forControlEvents:UIControlEventTouchUpInside];
    [souVi addSubview:_souTf];
    //17年4.28新添加的消息按钮
    UIButton *talkImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [talkImg setImage:[UIImage imageNamed:@"msg_black"] forState:UIControlStateNormal];
    talkImg.frame=CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top+2*self.scale, self.TitleLabel.height,self.TitleLabel.height);
    [talkImg addTarget:self action:@selector(talk) forControlEvents:UIControlEventTouchUpInside];
    //talkImg.backgroundColor = [UIColor blackColor];
    //talkImg.alpha = 0;
    [self.NavImg  addSubview:talkImg];
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
    self.gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self getStartHeight]+44);
    [self.NavImg.layer insertSublayer:self.gradientLayer atIndex:0];
}

-(void)dismissKeyBoard{
    [_souTf resignFirstResponder];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    if (_isPush){
        //[self dismissViewControllerAnimated:YES completion:nil];
        self.dismissBlock(YES);
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark-------左边Scrollview的设置
-(void)leftScrollview{
    if (_scroll) {
        [_scroll removeFromSuperview];
    }
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, [self getStartHeight]+44, 60*self.scale, self.view.bounds.size.height-([self getStartHeight]+44))];
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
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            // btn.layer.borderWidth=.3;
            //btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            // [btn setTitle:[_data[i] objectForKey:@"class_name"] forState:UIControlStateNormal];
            [btn setTitle:[_data[i] objectForKey:@"CategoryName"] forState:UIControlStateNormal];
            NSDictionary *attrNormalDic = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
            NSDictionary *attrSelectedDic = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:13]};
            NSAttributedString *attrNormal = [[NSAttributedString alloc] initWithString:[_data[i] objectForKey:@"CategoryName"] attributes:attrNormalDic];
            NSAttributedString *attrSelected = [[NSAttributedString alloc] initWithString:[_data[i] objectForKey:@"CategoryName"] attributes:attrSelectedDic];
            [btn setAttributedTitle:attrNormal forState:UIControlStateNormal];
            [btn setAttributedTitle:attrSelected forState:UIControlStateSelected];
            btn.titleLabel.font=DefaultFont(self.scale);
            [btn setBackgroundImage:[UIImage imageNamed:@"dian_hoverY"] forState:UIControlStateSelected];
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
            rightL.backgroundColor = whiteLineColore;
            //[self.scroll addSubview:rightL];
            _scroll.contentSize=CGSizeMake(_scroll.width, btn.bottom);
        }
        if(btn.tag==1){
            btn.selected = YES;
        }
        UIView *topL = [[UIView alloc]initWithFrame:CGRectMake(0, btn.left, 270/2.25*self.scale, .5)];
        topL.backgroundColor =blackLineColore;
        [btn addSubview:topL];
    }
}

#pragma mark--------左侧scrollview中按钮的选择方法
//bool or=NO;
-(void)choose:(UIButton *)sender{
    sender.selected = YES;
    //if(_index==1){
    [_rightTable setContentOffset:CGPointMake(0,0) animated:NO];
   // }
    [self chooseNextSenderTag:sender.tag];
    [self.activityVC startAnimate];
    [_arr removeAllObjects];
    NSInteger tag = sender.tag;
    _pindex=tag-1;
//    if(!_isOpenCol){
//        [self chooseSecondaryClassification];
//    }
    [self modifyHeaderView:false];
    if(![_sortBtn.titleLabel.text isEqualToString:@"全部"])
        [_sortBtn setTitle:@"全部" forState:UIControlStateNormal];
    [_collectionView reloadData];
    _index=1;
    NSString *ID = [_data[tag-1] objectForKey:@"CategoryID"];
    _curClassID=ID;
    [self reloadRightTable:ID];
//    NSDictionary *dic2 = [NSDictionary new];
//    if (_isPush) {
//        dic2=@{@"shopid":self.shop_id,@"classid":ID,@"sort":[NSString stringWithFormat:@"%ld",_sort],@"pindex":[NSString stringWithFormat:@"%ld",_index]};
//    }else{
//        dic2 = @{@"shopid":self.shop_id,@"classid":ID,@"sort":[NSString stringWithFormat:@"%ld",_sort],@"pindex":[NSString stringWithFormat:@"%ld",_index]};
//    }
//    AnalyzeObject *analyze = [AnalyzeObject new];
//    [analyze getProdListByClasswithDic:dic2 WithBlock:^(id models, NSString *code, NSString *msg) {
//        NSLog(@"getProdListByClasswithDic==%@",models);
//        [self.activityVC stopAnimate];
//        [_rightData removeAllObjects];
//        if ([code isEqualToString:@"0"]) {
//            [_rightData addObjectsFromArray:models];
//        }
//         [_rightTable reloadData];
//    }];
}

-(void) reloadRightTable:(NSString*) classid{
    NSDictionary *dic2 = [NSDictionary new];
    if (_isPush) {
        dic2=@{@"shopid":self.shop_id,@"classid":classid,@"sort":[NSString stringWithFormat:@"%ld",_sort],@"pindex":[NSString stringWithFormat:@"%ld",_index]};
    }else{
        dic2 = @{@"shopid":self.shop_id,@"classid":classid,@"sort":[NSString stringWithFormat:@"%ld",_sort],@"pindex":[NSString stringWithFormat:@"%ld",_index]};
    }
    AnalyzeObject *analyze = [AnalyzeObject new];
    [analyze getProdListByClasswithDic:dic2 WithBlock:^(id models, NSString *code, NSString *msg) {
        NSLog(@"getProdListByClasswithDic==22%@",models);
        [self.activityVC stopAnimate];
        [_rightTable.header endRefreshing];
        [_rightTable.footer endRefreshing];
        if(_index==1&&[_rightData count]>0)
            [_rightData removeAllObjects];
        if ([code isEqualToString:@"0"]) {
            NSArray* modArr=models;
            [_rightData addObjectsFromArray:modArr];
            if(_index>1&&[AppUtil arrayIsEmpty:modArr]){
                _rightTable.footer.state=MJRefreshFooterStateNoMoreData;
            }
        }
        [_rightTable reloadData];
    }];
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

-(void)hideHeaderView{
    if(_collectionView.height==0)
        [self modifyHeaderView:false];
    else{
        [self modifyHeaderView:true];
    }
}

-(void) modifyHeaderView:(BOOL) isHide{
    CGRect newFrame = _headerView.frame;
    if(isHide){
        _collectionView.height=0;
    }else{
        if([AppUtil arrayIsEmpty:_data])
            _collectionView.height=30*self.scale;
        else{
            NSArray* subArray=_data[_pindex][@"SubProdClass"];
            if((subArray.count+1)%3==0){
                _collectionView.height=30*self.scale*((subArray.count+1)/3);
            }else{
                _collectionView.height=30*self.scale*(((subArray.count+1)/3)+1);
            }
        }
    }
    _sortView.top=_collectionView.bottom+5*self.scale;
    newFrame.size.height = 30*self.scale+_collectionView.height;
    _headerView.frame = newFrame;
    [_rightTable beginUpdates];
    self.rightTable.tableHeaderView=_headerView;
    [_rightTable endUpdates];
}

//选择二级分类
-(void) chooseSecondaryClassification{
    CGRect newFrame = _headerView.frame;
    if(_isOpenCol){
        _collectionView.height=0;
    }else{
        if([AppUtil arrayIsEmpty:_data])
            _collectionView.height=30*self.scale;
        else{
            NSArray* subArray=_data[_pindex][@"SubProdClass"];
            if((subArray.count+1)%3==0){
                _collectionView.height=30*self.scale*((subArray.count+1)/3);
            }else{
                _collectionView.height=30*self.scale*(((subArray.count+1)/3)+1);
            }
        }
    }
    _sortView.top=_collectionView.bottom+5*self.scale;
    newFrame.size.height = 30*self.scale+_collectionView.height;
    _headerView.frame = newFrame;
    [_rightTable beginUpdates];
    self.rightTable.tableHeaderView=_headerView;
    [_rightTable endUpdates];
    _isOpenCol=!_isOpenCol;
}

-(void) setHeaderView{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(self.scroll.right, [self getStartHeight]+44, self.view.width-self.scroll.right, 30*self.scale)];
    self.headerView.backgroundColor=[UIColor whiteColor];//[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [self RightCollectionView];
    self.sortView = [[UIView alloc]initWithFrame:CGRectMake(10*self.scale, _collectionView.bottom+5*self.scale, self.headerView.width-20*self.scale, 20*self.scale)];
    self.sortView.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    _sortBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.sortView.width/3, self.sortView.height)];
    [_sortBtn setTitle:@"全部" forState:UIControlStateNormal];
    _sortBtn.contentEdgeInsets = UIEdgeInsetsMake(2,0, 0, 10);
    [_sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _sortBtn.titleLabel.font = [UIFont systemFontOfSize: 11.0];
    [_sortBtn addTarget:self action:@selector(hideHeaderView) forControlEvents:UIControlEventTouchUpInside];
   // _sortBtn.backgroundColor=[UIColor redColor];
    [self.sortView addSubview:_sortBtn];
    
    _defBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.sortView.width/3,0 , self.sortView.width/3, self.sortView.height)];
    [_defBtn setTitle:@"默认排序" forState:UIControlStateNormal];
    _defBtn.contentEdgeInsets = UIEdgeInsetsMake(2,0, 0, 0);
    [_defBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_defBtn setTitleColor:[UIColor colorWithRed:1.000 green:0.380 blue:0.000 alpha:1.00] forState:UIControlStateSelected];
    _defBtn.titleLabel.font = [UIFont systemFontOfSize: 11.0];
    [_defBtn addTarget:self action:@selector(setDefSort) forControlEvents:UIControlEventTouchUpInside];
   // _defBtn.backgroundColor=[UIColor greenColor];
    [self.sortView addSubview:_defBtn];
    
    _salesBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.sortView.width/3*2,0 , self.sortView.width/3, self.sortView.height)];
    [_salesBtn setTitle:@"销量排序" forState:UIControlStateNormal];
    _salesBtn.contentEdgeInsets = UIEdgeInsetsMake(2,10, 0, 0);
    [_salesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_salesBtn setTitleColor:[UIColor colorWithRed:1.000 green:0.380 blue:0.000 alpha:1.00] forState:UIControlStateSelected];
    _salesBtn.titleLabel.font = [UIFont systemFontOfSize: 11.0];
    [_salesBtn addTarget:self action:@selector(setSalesSort) forControlEvents:UIControlEventTouchUpInside];
   // _salesBtn.backgroundColor=[UIColor blueColor];
    [self.sortView addSubview:_salesBtn];
    
    [self setSortState];
    [self.headerView addSubview:self.sortView];
    self.rightTable.tableHeaderView=_headerView;
}

-(void)setDefSort{
    if(_sort==0)
        return;
    _sort=0;
    [self setSortState];
    [self reloadRightTable:_curClassID];
}

-(void)setSalesSort{
    if(_sort==1)
        return;
    _sort=1;
    [self setSortState];
    [self reloadRightTable:_curClassID];
}

-(void) setSortState{
    if(_sort==0){
        _defBtn.selected=YES;
        _salesBtn.selected=NO;
    }else{
        _defBtn.selected=NO;
        _salesBtn.selected=YES;
    }
}

-(void) xiala{
    _index=1;
    [self reloadRightTable:_curClassID];
}

-(void) shangla{
    _index++;
    [self reloadRightTable:_curClassID];
}

#pragma mark ----------右边表视图
-(void)RightTable{
    self.rightTable = [[UITableView alloc]initWithFrame:CGRectMake(self.scroll.right, [self getStartHeight]+44, self.view.width-60*self.scale, self.view.bounds.size.height- ([self getStartHeight]+44)-self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
    //    self.view.bounds.size.height-100-100/2.25*self.scale-58*self.scale
    self.rightTable.dataSource=self;
    self.rightTable.delegate=self;
    [self.view addSubview:self.rightTable];
    [_rightTable addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    [_rightTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
    self.rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rightTable registerClass:[BreakInfoCell class] forCellReuseIdentifier:@"cell"];
    //int p = [self.yunfei intValue];
    //int m = [self.manduoshaofree intValue];
}

#pragma mark ----------右边宫格视图
-(void)RightCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _headerView.width, 0) collectionViewLayout:layout];
    self.collectionView.backgroundColor=[UIColor clearColor];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [_headerView addSubview:self.collectionView];
    //self.collectionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerClass:[SortCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SortCollectionViewCell class])];
    //int p = [self.yunfei intValue];
    //int m = [self.manduoshaofree intValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if([AppUtil arrayIsEmpty:_data])
        return 1;
    else{
       NSArray* subArray=_data[_pindex][@"SubProdClass"];
       return subArray.count+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SortCollectionViewCell class]) forIndexPath:indexPath];
    cell.sortNameLb.frame=CGRectMake(0, 12.5*self.scale, self.headerView.width/3,15*self.scale);
    cell.sortNameLb.textAlignment = NSTextAlignmentCenter;
    if(indexPath.row==0)
        cell.sortNameLb.text=@"全部";
    else{
        NSArray* subArray=_data[_pindex][@"SubProdClass"];
        cell.sortNameLb.text=subArray[indexPath.row-1][@"CategoryName"];
    }
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

//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   // return [RightCollectionViewCell ccellSize];
    return CGSizeMake(_headerView.width/3-10*self.scale,30*self.scale);
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

-(void)addToCart:(UITapGestureRecognizer*) tap{
    NSMutableDictionary *shopInfo = [_rightData[[tap view].tag-100000] mutableCopy];
    NSString* prodID=shopInfo[@"id"];
    NSString* shopID=shopInfo[@"shop_id"];
    //NSLog(@"img_tag==%@==%@",shopInfo,prodID);
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
    [self gouWuCheShuZi];
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString* classid=@"";
    if(indexPath.row==0){
        classid=_data[_pindex][@"CategoryID"];
        [_sortBtn setTitle:@"全部" forState:UIControlStateNormal];
    }else{
        NSArray* subArray=_data[_pindex][@"SubProdClass"];
        classid=subArray[indexPath.row-1][@"CategoryID"];
        [_sortBtn setTitle:subArray[indexPath.row-1][@"CategoryName"] forState:UIControlStateNormal];
    }
    _curClassID=classid;
    //[self chooseSecondaryClassification];
    [self modifyHeaderView:YES];
    _index=1;
    [self reloadRightTable:classid];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    CGRectMake(r+10, t, self.contentView.width-100*self.scale, 15*self.scale);
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.width-100*self.scale, 15*self.scale)];
    la.font=DefaultFont(self.scale);
    la.numberOfLines=0;
    la.text=[_rightData[indexPath.row] objectForKey:@"prodname"];
    [la sizeToFit];
//    if (![_rightData[indexPath.row][@"description"] isEmptyString]) {
//        return 80*self.scale+la.height;
//    }else{
    return 80*self.scale;//+la.height;
   // }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rightData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BreakInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate=self;
    NSString *string = [NSString stringWithFormat:@"%@",[_rightData[indexPath.row] objectForKey:@"imgs"][0]];
    NSArray *imgArr = [string componentsSeparatedByString:@"|"];
   // NSLog(@"smallImgUrl==%@",imgArr[0]);
    [cell.headImg setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:[UIImage imageNamed:@"za"]];
    cell.headImg.clipsToBounds=YES;
    cell.headImg.layer.cornerRadius=5;
    cell.selectBtn.tag=indexPath.row;
    NSInteger activityid=[[NSString stringWithFormat:@"%@",_rightData[indexPath.row][@"actinfo"][@"activityid"]] integerValue];
    if(activityid>0){
        if(cell.activityImg.hidden)
            cell.activityImg.hidden=NO;
        NSString *activityImgUrl=[NSString stringWithFormat:@"%@",_rightData[indexPath.row][@"actinfo"][@"acticon"]];
        [cell.activityImg setImageWithURL:[NSURL URLWithString:activityImgUrl] placeholderImage:[UIImage imageNamed:@""]];
    }else{
        if(cell.activityImg.hidden==NO)
            cell.activityImg.hidden=YES;
    }
    [cell.selectBtn addTarget:self action:@selector(didselect:) forControlEvents:UIControlEventTouchUpInside];
    [cell.jianBt setImage:[UIImage imageNamed:@"na8"]forState:UIControlStateNormal];
    [cell.addBt setImage:[UIImage imageNamed:@"na7"] forState:UIControlStateNormal];
    if (![AppUtil isBlank:_rightData[indexPath.row][@"description"]]) {
        cell.descriptionLab.hidden=NO;
        cell.descriptionLab.text=[_rightData[indexPath.row][@"description"] trimString];
    }else{
        cell.descriptionLab.hidden=YES;
    }
    if ([_rightData[indexPath.row][@"inventory"]isEqualToString:@"0"] || [_rightData[indexPath.row][@"inventory"]isEqualToString:@""] ||[_rightData[indexPath.row][@"inventory"]isKindOfClass:[NSNull class]]) {
        cell.addBt.hidden=YES;
    }else{
        cell.addBt.hidden=NO;
    }
    cell.titleLa.text=[_rightData[indexPath.row] objectForKey:@"prodname"];
    NSString *xiao = @"";
    if([AppUtil isBlank:[_rightData[indexPath.row] objectForKey:@"description"]])
        xiao=[_rightData[indexPath.row] objectForKey:@"prodname"];
    else
        xiao=[_rightData[indexPath.row] objectForKey:@"description"];
    cell.salesLa.text = xiao;
    CGFloat pri=[[_rightData[indexPath.row] objectForKey:@"price"] floatValue];
    NSString * priceString = [NSString stringWithFormat:@"￥%.1f/%@",pri,_rightData[indexPath.row][@"unit"]];
    NSString * firstString = [NSString stringWithFormat:@"%.1f",pri];
    NSMutableAttributedString * priceAttributeString = [[NSMutableAttributedString alloc]initWithString:priceString];
    [priceAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12*self.scale] range:NSMakeRange(1, firstString.length)];
    cell.priceLa.attributedText = priceAttributeString;
    cell.indexpath=indexPath;
    //cell.delegate=self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *prod_id = _rightData[indexPath.row][@"id"];
    int index=[self.appdelegate.shopDictionary[@([prod_id intValue])] intValue];
    ShopModel *model=[ShopModel new];
    model.selectNum=index;
    cell.shopModel = model;
    //NSLog(@"index_reload==%d  param==%@",index,self.appdelegate.shopDictionary);
    cell.numberLa.text=[NSString stringWithFormat:@"%d",index];
    if (index==0) {
        cell.jianBt.hidden=YES;
        cell.numberLa.hidden=YES;
    }else{
        cell.jianBt.hidden=NO;
        cell.numberLa.hidden=NO;
    }
    cell.addBt.hidden=NO;
    return cell;
}

-(void)didselect:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
    _list=[[NSMutableArray alloc]init];
    NSDictionary *shopInfodic=[[NSDictionary alloc]initWithObjectsAndKeys:self.shop_id,@"shopid",
                               self.titlete,@"shopname",
                               self.shopImg,@"image",
                               _GoodsList,@"list", nil];
    [_list addObject:shopInfodic];
    NSIndexPath *indexOath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    BreakInfoCell *cell = [self.rightTable cellForRowAtIndexPath:indexOath];
    self.hidesBottomBarWhenPushed=YES;

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
    shopInfo.shop_id = [_rightData[sender.tag] objectForKey:@"shopid"];
    shopInfo.prod_id = [_rightData[sender.tag]objectForKey:@"id"];
    shopInfo.xiaoliang= _rightData[sender.tag][@"sales"];
    shopInfo.shoucang= _rightData[sender.tag][@"collect_time"];
    shopInfo.gongGao=_rightData[sender.tag][@"notice"];
    shopInfo.tel = self.tel;
    //    shopInfo.yunfei=self.yunfei;
    shopInfo.param=_rightData[sender.tag];
    [self.navigationController pushViewController:shopInfo animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

-(void)addNumberindex:(NSInteger)index number:(NSInteger)number jiaAndJian:(BOOL)isAdd{
    [_numberImg setTitle:[NSString stringWithFormat:@"%ld",(long)number] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:_numberImg.titleLabel.text forKey:@"GouWuCheShuLiang"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self BreakInfoCellChangeNumber:[NSNumber numberWithInteger:number] IndexPath:indexPath jiaAndJian:isAdd];
}

//yes是加   no是减
-(void)BreakInfoCellChangeNumber:(NSNumber *)number IndexPath:(NSIndexPath *)indexPath jiaAndJian:(BOOL)jiaAndJian{
    NSString* ID= [_rightData[indexPath.row] objectForKey:@"id"];
    NSMutableDictionary* param=[NSMutableDictionary dictionary];
    [param setObject:ID forKey:@"prod_id"];
    // [param setObject:@"" forKey:@"shop_logo"];
    [param setObject:[_rightData[indexPath.row] objectForKey:@"shopid"] forKey:@"shop_id"];
    [param setObject:@"" forKey:@"shop_name"];
    [param setObject:@"" forKey:@"shop_logo"];
    [param setObject:@"" forKey:@"free_delivery_amount"];
    [param setObject:[_rightData[indexPath.row] objectForKey:@"prodname"] forKey:@"prod_name"];
    NSString *string = [NSString stringWithFormat:@"%@",[_rightData[indexPath.row] objectForKey:@"imgs"][0]];
    NSArray *imgArr = [string componentsSeparatedByString:@"|"];
    [param setObject:imgArr[0] forKey:@"img1"];
    [param setObject:[_rightData[indexPath.row] objectForKey:@"originPrice"] forKey:@"origin_price"];
    [param setObject:[_rightData[indexPath.row] objectForKey:@"price"] forKey:@"price"];
    [param setObject:[_rightData[indexPath.row] objectForKey:@"unit"] forKey:@"unit"];
    NSLog(@"BreakInfoCellChangeNumber==%@",param);
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
    [self gouWuCheShuZi];
    //NSLog(@"index2====%d",[self.appdelegate.shopDictionary[ID] intValue]);
    //[self ReshBotView];
    //[self shangJiaXiangQing];
    //[self.rightTable reloadData];
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"addact" object:nil];
    //self.botRTwo.hidden=NO;
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
            [self reloadData];
    }else{
        //[self.appdelegate.shopDictionary removeAllObjects];
        if(isRefresh)
            [self reloadData];
    }
}

-(void)skipToSearchView{
    SouViewController *vi=[SouViewController new];
    vi.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vi animated:YES];
}

@end
