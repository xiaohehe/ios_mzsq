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


@interface GouWuCheViewController()<UITableViewDataSource,UITableViewDelegate,GouWuCheTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource,*btnArr,*data;
@property(nonatomic,strong)NSMutableDictionary *Dic;
@property(nonatomic,assign)BOOL isHasPreson;

@property(nonatomic,strong)UIButton *selectedBtn;

@property (nonatomic,strong)NSMutableDictionary *dataDic;
@property (nonatomic,strong)NSMutableDictionary *quanXuanDic,*bigbigd;

@property(nonatomic,strong)UIView *bigVi;
@property(nonatomic,strong)UILabel *tishi;
@property (nonatomic,strong)NSMutableArray *daArr;

@property (nonatomic,strong)NSMutableDictionary *GoodsListDic;

@property (nonatomic,strong)NSMutableDictionary * goodsPriceDic;

@end
@implementation GouWuCheViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self newNav];
    [self newView];
    [self ReshData];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

-(void)viewDidLoad{
    [super viewDidLoad];
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
//    [self ReshData];
    if(_isShowBack)
      [ self returnVi];
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

-(void)ReshData{
    [_tishi removeFromSuperview];
    
    [_dataSource removeAllObjects];

    [self.activityVC startAnimating];
    
    NSString *userid =  [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dic = @{@"user_id":userid};

    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy showCartWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            
            [_dataSource addObjectsFromArray:models];
            [self huoQuGouWuCheShuLiang];
            
            for (int i = 0; i < _dataSource.count; i ++) {
                
                NSArray * Prod_infoArr = _dataSource[i][@"prod_info"];
                
                for (int j = 0; j < Prod_infoArr.count; j ++) {
                    
                     NSString *Prod_infoStr = [NSString stringWithFormat:@"%@",Prod_infoArr[j][@"prod_id"]];
                    [_quanXuanDic setObject:@"" forKey:Prod_infoStr];
                }
            }
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
            
            //默认全选
            for (NSDictionary *ShopInfo in _dataSource) {
                NSMutableArray *arr = [[ShopInfo objectForKey:@"prod_info"] mutableCopy];
                for (NSDictionary *prodDic in arr) {
                    NSString *key = [NSString stringWithFormat:@"%@",prodDic[@"prod_id"]];
                    if (![prodDic[@"prod_count"] isEqualToString:@"0"]) {
                        [_GoodsListDic setObject:prodDic forKey:key];
                    }
                }
            }
            UIButton *b = (UIButton *)[self.view viewWithTag:6666];
            b.selected=YES;
            [_tableView reloadData];
        }else{
            if (_dataSource.count<=0) {
                _bigVi.hidden=YES;
                _tishi = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 30*self.scale)];
                _tishi.textAlignment=NSTextAlignmentCenter;
                _tishi.font=SmallFont(self.scale);
                _tishi.text=@"购物车暂无商品";
                [self.view addSubview:_tishi];
                 [self huoQuGouWuCheShuLiang];
                return ;
            }
        }
        [_tableView reloadData];
        [self BottomView:NO];
    }];
}

-(void)newView{
    if (_tableView) {
        [_tableView removeFromSuperview];
    }
    NSInteger height= [UIScreen mainScreen].bounds.size.height-self.NavImg.bottom-44;
    if(!_isShowBack)
        height-=49;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, height) style:(UITableViewStyleGrouped)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[GouWuCheTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
 
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
   // [self RooterView];
}

#pragma mark - UITableViewDelegate & UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
    //return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_dataSource[section] objectForKey:@"prod_info"] count];
    //return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *ShopInfo=[_dataSource objectAtIndex:indexPath.section];
    NSArray *arr = [ShopInfo objectForKey:@"prod_info"];
    NSDictionary *prodDic=[arr objectAtIndex:indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%@",prodDic[@"prod_id"]];
    
    GouWuCheTableViewCell *cell=(GouWuCheTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.GoodsImg setImageWithURL:[NSURL URLWithString:[prodDic objectForKey:@"prod_img1"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
    cell.GoodsName.text=[NSString stringWithFormat:@"%@",[prodDic objectForKey:@"prod_name"]];
//    cell.xiaoliangLa.text = [NSString stringWithFormat:@
//                             "销量%@",[prodDic objectForKey:@"sales"]];
    
    NSString * priceString = [NSString stringWithFormat:@
                               "￥%@/%@",[prodDic objectForKey:@"price"],[prodDic objectForKey:@"unit"]];
    CGRect priceRect = [self getStringWithFont:13*self.scale withString:priceString withWith:self.view.width];
    NSMutableAttributedString * priceAttributeString = [[NSMutableAttributedString alloc]initWithString:priceString];
    
    NSString * firstString = [NSString stringWithFormat:@"￥%@",[prodDic objectForKey:@"price"]];
    NSString * lastString = [NSString stringWithFormat:@"/%@",[prodDic objectForKey:@"unit"]];
    
    [priceAttributeString addAttribute:NSForegroundColorAttributeName value:blackTextColor range:NSMakeRange(firstString.length, lastString.length)];

    cell.GoodsPrice.attributedText = priceAttributeString;
    
    cell.GoodsPrice.frame = CGRectMake(0, 40*self.scale, priceRect.size.width, 20*self.scale);
    
    CGFloat yuanJiaF = 32.0;
    CGFloat xianJiaF = [[prodDic objectForKey:@"price"] floatValue];
    //NSLog(@"--原价：%f,现价：%f",yuanJiaF,xianJiaF);
    if (yuanJiaF>=xianJiaF)
    {
        cell.yuanJiaLab.hidden = YES;
        
    }
    else
    {
        cell.yuanJiaLab.hidden = YES;
        NSString *  yuanJiastring = [NSString stringWithFormat:@"￥%@",@"1000"];
        
        CGRect yuanJiaRect = [self getStringWithFont:13*self.scale withString:yuanJiastring withWith:self.view.width];
        
        cell.yuanJiaLab.text = yuanJiastring;
        cell.yuanJiaLab.frame = CGRectMake(cell.GoodsPrice.right+5*self.scale, 40*self.scale, yuanJiaRect.size.width, 20*self.scale);
        cell.lin.frame = CGRectMake(0, 10*self.scale, cell.yuanJiaLab.width, 0.5);
    }
    

    cell.gnumber=[NSString stringWithFormat:@
                  "%@",[prodDic objectForKey:@"prod_count"]];
  
    cell.SelectedBtn.selected=([_GoodsListDic objectForKey:key] !=nil);
    
    cell.indexPath=indexPath;
    cell.delegate=self;
    if ([_GoodsListDic objectForKey:key]) {
        
        [_GoodsListDic setObject:prodDic forKey:key];
    }
    [_btnArr addObject:cell.SelectedBtn];
    return cell;
}
-(void)GouWuCheTableViewCellIndexpath:(NSIndexPath *)indexPath{
    
    NSLog(@"%@",@"xuanzhuang");
//   // NSLog(@"------%@",_dataSource[indexPath.section][@"prod_info"][indexPath.row][@"prod_id"]);
////    dsa
//    
//    NSString *prod_idStr = [NSString stringWithFormat:@"%@",_dataSource[indexPath.section][@"prod_info"][indexPath.row][@"prod_id"]];
//    
//    if (_dataDic[prod_idStr]) {
//        [_dataDic removeObjectForKey:prod_idStr];
//    }else{
//        [_dataDic setObject:@"" forKey:prod_idStr];
//    }
//   // NSLog(@"------%@",_dataDic);
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
//    
//    
//    for (int i = 0; i < _dataSource.count; i ++) {
//        
//        NSArray * Prod_infoArr = _dataSource[i][@"prod_info"];
//        
//        xiaoArr = [[NSMutableDictionary alloc] init];
//        for (int j = 0; j < Prod_infoArr.count; j ++) {
//            
//            NSString * prod_id = [NSString stringWithFormat:@"%@",_dataSource[i][@"prod_info"][j][@"prod_id"]];
// 
//            NSDictionary *prod_infoDic =_dataSource[i][@"prod_info"][j];
//            
//            
//            
//            if (_dataDic[prod_id]) {
//                [xiaoArr setObject:prod_infoDic forKey:prod_id];
//               
//            }
//        }
//        
//       
//        
//        if (xiaoArr.count>0) {
//            [_daArr addObject:xiaoArr];
//                   }
//        
//    }
//    
//    [_bigbigd setObject:_daArr forKey:@"list"];
//    [_bigbigd setObject:[_dataSource[indexPath.section] objectForKey:@"prod_info"][indexPath.row][@"shop_id"] forKey:@"shop_id"];
//    [_bigbigd setObject:[_dataSource[indexPath.section] objectForKey:@"prod_info"][indexPath.row][@"prod_img1"] forKey:@"image"];
//    [_bigbigd setObject:[_dataSource[indexPath.section]objectForKey:@"shop_name"] forKey:@"shopname"];
//
//    
//    
//   
//    
    
    
    
//    
//    NSMutableDictionary *zong = [NSMutableDictionary new];
//    
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
//                
//
//            }
//            [shopArr setObject:shop forKey:@""];
//    
//        }
//        
//    }
//    
//    
//    NSLog(@"%@",shopArr);
//    
//    
  //  NSLog(@"%@",zong);
    
    
    
//    NSLog(@"%@",_dataSource);
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
    return 80*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60*self.scale;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *HeaderViewBG=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 60*self.scale)];
    HeaderViewBG.backgroundColor=self.view.backgroundColor;
    HeaderViewBG.tag = section + 10;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionGaoShop:)];
    [HeaderViewBG addGestureRecognizer:tap];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 10*self.scale, self.view.width, HeaderViewBG.height-10*self.scale)];
    headerView.backgroundColor=[UIColor whiteColor];
    [HeaderViewBG addSubview:headerView];
    
    [self DetailView:headerView viewForHeaderInSection:section];
    
    UIImageView *_lingView=[[UIImageView alloc]initWithFrame:CGRectMake(0, HeaderViewBG.height-.5, self.view.width, .5)];
    
    _lingView.backgroundColor  = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [HeaderViewBG addSubview:_lingView];
    return HeaderViewBG;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 60*self.scale)];
    UILabel * yunFeiLab = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, self.view.width - 30*self.scale - 30*self.scale/3.0*8,30*self.scale)];
    CGFloat amount = [_dataSource[section][@"amount"] floatValue];
    CGFloat free_delivery_amount = [_dataSource[section][@"free_delivery_amount"] floatValue];
    
    if (amount>=free_delivery_amount)
    {
         yunFeiLab.text = [NSString stringWithFormat:@"本店消费%.2f元,已免配送费",amount];
    }
    else
    {
        yunFeiLab.text = [NSString stringWithFormat:@"本店消费%.2f元,差%.2f元免配送费",amount,free_delivery_amount-amount];
    }
//    yunFeiLab.text = ;
    yunFeiLab.textColor = grayTextColor;
    yunFeiLab.font = SmallFont(self.scale);
    [footerView addSubview:yunFeiLab];
    
    UIButton * jiXuGouWuBtn = [[UIButton alloc]initWithFrame:CGRectMake(yunFeiLab.right+ 10*self.scale, 10*self.scale, 30*self.scale/3.0*8, 30*self.scale)];
    jiXuGouWuBtn.clipsToBounds = YES;
    jiXuGouWuBtn.layer.cornerRadius = 5*self.scale;
    jiXuGouWuBtn.layer.borderColor = [blueTextColor CGColor];
    jiXuGouWuBtn.layer.borderWidth = 0.5;
    [jiXuGouWuBtn setTitle:@"继续购物" forState:(UIControlStateNormal)];
    [jiXuGouWuBtn setTitleColor:blueTextColor forState:(UIControlStateNormal)];
    jiXuGouWuBtn.titleLabel.font = SmallFont(self.scale);
    [jiXuGouWuBtn addTarget:self action:@selector(jiXuGouWuBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    jiXuGouWuBtn.tag = section + 100;
    [footerView addSubview:jiXuGouWuBtn];
    
    footerView.backgroundColor = [UIColor whiteColor];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50*self.scale;
}
#pragma mark -- 点击区头跳转商铺
- (void)sectionGaoShop:(UITapGestureRecognizer *)tap
{
    self.hidesBottomBarWhenPushed = YES;
    BreakInfoViewController * breakInf = [[BreakInfoViewController alloc]init];
    breakInf.ID = _dataSource[tap.view.tag- 10][@"shop_id"];
    breakInf.titlete = _dataSource[tap.view.tag - 10][@"shop_name"];
    [self.navigationController pushViewController:breakInf animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark -- 继续购物按钮点击事件
- (void)jiXuGouWuBtnClick:(UIButton *)sender
{
    //100;
    self.hidesBottomBarWhenPushed = YES;
    BreakInfoViewController * breakInf = [[BreakInfoViewController alloc]init];
    breakInf.ID = _dataSource[sender.tag - 100][@"shop_id"];
    breakInf.titlete = _dataSource[sender.tag - 100][@"shop_name"];
    [self.navigationController pushViewController:breakInf animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

#pragma mark - 商户信息
-(void)DetailView:(UIView *)headerView viewForHeaderInSection:(NSInteger)section{
    
    //NSDictionary *merchant=[_dataSource objectAtIndex:section];
   UIImageView *dianPuImg = [[UIImageView alloc] initWithFrame:CGRectMake(10*self.scale,10*self.scale, 40*self.scale, 30*self.scale)];
    //dianPuImg.backgroundColor = [UIColor yellowColor];
   // [dianPuImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgDuanKou,merchant[@"logo"]]] placeholderImage:[UIImage imageNamed:@""]];
    [dianPuImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_dataSource[section] objectForKey:@"logo"]] ]  placeholderImage:[UIImage imageNamed:@"center_ing"]];
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
    
    NSLog(@"%@",_GoodsListDic);
    NSInteger number=0;
    double sam=0;
    if (isSection)
    {
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
    [jiesuan setTitle:@"结算" forState:UIControlStateNormal];
    jiesuan.frame=CGRectMake(carLa.right+10*self.scale, 0, 80*self.scale,_bigVi.height);
    jiesuan.titleLabel.font=DefaultFont(self.scale);
    [jiesuan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    jiesuan.backgroundColor=blueTextColor;
//    jiesuan.alpha=.7;
    [jiesuan addTarget:self action:@selector(JieSuanEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_bigVi addSubview:jiesuan];
    [self.view addSubview:self.activityVC];
    
}

#pragma mark - 结算
-(void)JieSuanEvent:(UIButton *)button{
    
    
    
    
    if (_GoodsListDic.count<=0) {
        [self ShowAlertWithMessage:@"请至少选择一件商品"];
        return;
    }
    

    /*
    NSLog(@"%@",_bigbigd);
    
    for (NSMutableDictionary *dic in _bigbigd[@"list"]) {
       
        for (id key in [dic allKeys]) {
          
            for (NSDictionary *d in _dataSource) {
                
                
                
                for (NSDictionary *prodDic in d[@"prod_info"]) {
                    
                    if ([prodDic[@"prod_id"] isEqualToString:[NSString stringWithFormat:@"%@",key]]) {
                        
                        NSString *counts = prodDic[@"prod_count"];
                        NSMutableDictionary *pricont = [[dic objectForKey:key] mutableCopy];
                        [pricont setObject:counts forKey:@"prod_count"];
                        [dic setObject:prodDic forKey:key];
                        NSArray *a = [NSArray arrayWithObject:dic];
                        
                        
                        [_bigbigd setObject:a forKey:@"list"];
                        
                    }
                }
            }
            
        }
    }
    NSLog(@"%@",_bigbigd);
    */
    
    self.hidesBottomBarWhenPushed=YES;
    OrderViewController *orde = [OrderViewController new];
     orde.bigbigArr = _GoodsListDic;
//    orde.tel=self.
   // orde.gouwucheData=_dataSource;
    [self.navigationController pushViewController:orde animated:YES];
    self.hidesBottomBarWhenPushed = NO;

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
        
        self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

        if (index == 1) {
            AnalyzeObject *anle = [AnalyzeObject new];
            NSDictionary *dic =@{@"user_id":self.user_id,@"prod_id":[[_dataSource[indexPath.section] objectForKey:@"prod_info"][indexPath.row] objectForKey:@"prod_id"]};
            [anle delProdInCartWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                if ([code isEqualToString:@"0"]) {
                   // [self ShowAlertWithMessage:msg];
                    [self ReshData];
                    [self newView];
                    
                }
            }];
            
            
        }
    }];
}
/*#pragma mark - 全选
-(void)SelectedEvent:(UIButton *)button{
    button.selected = !button.selected;
//    if (button.tag == 888) {
//        _selectedBtn=button;
//        for ( NSDictionary *mer in _dataSource)
//        {
//            NSArray *Plist=[mer objectForKey:@"plist"];
//            if ([[NSString stringWithFormat:@"%@",mer[@"isself"]] isEqualToString:@"1"])
//            {
//                for ( NSDictionary *shop in Plist)
//                {
//                    if (_selectedBtn.selected) {
//                        [_Dic setObject:shop forKey:[shop objectForKey:@"pid"]];
//                    }else{
//                        [_Dic removeObjectForKey:[shop objectForKey:@"pid"]];
//                    }
//                }
//            }
//        }
//        
//    }else{
//        for ( NSDictionary *mer in _dataSource)
//        {
//            NSArray *Plist=[mer objectForKey:@"plist"];
//            if ([[NSString stringWithFormat:@"%@",mer[@"isself"]] isEqualToString:@"0"])
//            {
//                for ( NSDictionary *shop in Plist)
//                {
//                    if (button.selected) {
//                        [_Dic setObject:shop forKey:[shop objectForKey:@"pid"]];
//                    }else{
//                        [_Dic removeObjectForKey:[shop objectForKey:@"pid"]];
//                    }
//                }
//            }
//        }
//    }
//    [_tableView reloadData];
//     [self UpdateBottomView];
}
 */

//-(NSMutableArray *)FengZhuangJieSuan:(BOOL)isself{
//    NSMutableArray *list=[[NSMutableArray alloc]init];
//    for ( NSDictionary *mer in _dataSource)
//    {
//        NSArray *Plist=[mer objectForKey:@"plist"];
//        NSMutableArray *Arr=[[NSMutableArray alloc]init];
//        for ( NSDictionary *shop in Plist){
//
//            if ([_Dic objectForKey:[shop objectForKey:@"pid"]]) {
//                NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
//                [dic setObject:[shop objectForKey:@"logo1"] forKey:@"logo1"];
//                [dic setObject:[shop objectForKey:@"mail"] forKey:@"mail"];
//                [dic setObject:[shop objectForKey:@"newprice"] forKey:@"nowprice"];
//                [dic setObject:[shop objectForKey:@"num"] forKey:@"number"];
//                [dic setObject:[shop objectForKey:@"oldprice"] forKey:@"oldprice"];
//                 [dic setObject:[shop objectForKey:@"pid"] forKey:@"pid"];
//                 [dic setObject:[shop objectForKey:@"pname"] forKey:@"name"];
//                
//                 [dic setObject:[mer objectForKey:@"shopid"] forKey:@"shopid"];
//                 [dic setObject:[mer objectForKey:@"shopname"] forKey:@"shopname"];
//                [dic setObject:[mer objectForKey:@"star"] forKey:@"star"];
//                [dic setObject:[mer objectForKey:@"isself"] forKey:@"isself"];
//                 [dic setObject:[mer objectForKey:@"logo"] forKey:@"shoplogo"];
//                if(isself){
//                    if ([[NSString stringWithFormat:@"%@",mer[@"isself"]] isEqualToString:@"1"]){
//                        [Arr addObject:dic];
//                    }
//                }else{
//                    if ([[NSString stringWithFormat:@"%@",mer[@"isself"]] isEqualToString:@"0"]){
//                        [Arr addObject:dic];
//                    }
//                }
//            }
//        }
//        if (Arr.count>0) {
//            [list addObject:Arr];
//        }
//    }
//    return list;
//}
#pragma mark - GouWuCheTableViewCellDelegate
#pragma mark - 更新数据库的数量并刷新界面数据
//加减号
-(void)GouWuCheTableViewCellNumber:(NSString *)number indexPath:(NSIndexPath *)indexPath{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
 
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    NSString *num = [NSString stringWithFormat:@"%@",number];
    NSDictionary *dicc = @{@"user_id":self.user_id,@"prod_id":[[_dataSource[indexPath.section] objectForKey:@"prod_info"][indexPath.row] objectForKey:@"prod_id"],@"prod_count":num,@"shop_id":[[_dataSource[indexPath.section] objectForKey:@"prod_info"][indexPath.row] objectForKey:@"shop_id"] };
    
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle addProdWithDic:dicc Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            self.appdelegate.isRefresh=true;
            NSMutableDictionary *dic = [[_dataSource objectAtIndex:indexPath.section] mutableCopy];
            NSMutableArray *arr = [[dic objectForKey:@"prod_info"] mutableCopy];
            
            NSMutableDictionary *prod = [[arr objectAtIndex:indexPath.row] mutableCopy];
            
            [prod setObject:number forKey:@"prod_count"];
            [arr replaceObjectAtIndex:indexPath.row withObject:prod];
            
            [dic setObject:arr forKey:@"prod_info"];
            [_dataSource replaceObjectAtIndex:indexPath.section withObject:dic];
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
//            if ([cell.SumLabel.text isEqualToString:@"1"]) {
//                [self newView];
//            }

        }else{
            GouWuCheTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            NSInteger num = [number integerValue];
            num--;
            cell.gnumber=[NSString stringWithFormat:@"%ld",(long)num];
            [self ShowAlertWithMessage:msg];
        }
    }];
}

//选中
-(void)GouWuCheTableViewCellSelected:(BOOL)selected indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *ShopInfo=[_dataSource objectAtIndex:indexPath.section];
    
    NSLog(@"%@",ShopInfo);
    NSMutableArray *arr = [[ShopInfo objectForKey:@"prod_info"] mutableCopy];
    NSDictionary *prodDic=[arr objectAtIndex:indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%@",prodDic[@"prod_id"]];
    if (selected) {
        if (![prodDic[@"prod_count"] isEqualToString:@"0"]) {
            [_GoodsListDic setObject:prodDic forKey:key];
        }

    }else{
        [_GoodsListDic removeObjectForKey:key];
    }
    
    NSInteger Sum=0;
    for (NSDictionary *ShopInfo in _dataSource) {
        NSMutableArray *arr = [[ShopInfo objectForKey:@"prod_info"] mutableCopy];
        Sum=Sum+arr.count;
    }
    
    UIButton *AllBtn=(UIButton *)[self.view viewWithTag:6666];
    AllBtn.selected=(Sum!=0 && [_GoodsListDic allKeys].count == Sum);
    
    UILabel * carLa = (UILabel *)[_bigVi viewWithTag:100];
    NSString * heJiString = [NSString stringWithFormat:@"合计:￥%.2f",[self jiSuanAmount]];
    CGRect rect = [self getStringWithFont:12*self.scale withString:heJiString withWith:[UIScreen mainScreen].bounds.size.width];
    carLa.frame = CGRectMake(self.view.width - rect.size.width - 90*self.scale-10, _bigVi.height/2-10*self.scale, rect.size.width+30, 20*self.scale);
    carLa.attributedText = [self getAmountFuWenBenWithStirng:heJiString];
}

#pragma mark -- 获取购物车的数字
- (void)huoQuGouWuCheShuLiang
{
    NSInteger totalNumber = 0;
    NSLog(@"%@",_dataSource);
    for (NSDictionary * dic in _dataSource)
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
        if ([value isEqualToString:@"0"])
        {
            [item setBadgeValue:nil];
        }
        else
        {
            [item setBadgeValue:value];
        }
    }
    else
    {
        [item setBadgeValue:nil];
    }
}
#pragma mark - 导航
-(void)newNav{
     self.TitleLabel.text = @"结算中心";
//    UIButton * popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [popBtn setFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
//    [popBtn setImage:[UIImage imageNamed:@"left"] forState:0];
//    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
//    [popBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
//    [self.NavImg addSubview:popBtn];
    UIButton *qingkong =[UIButton buttonWithType:UIButtonTypeCustom];
    [qingkong setTitle:@"清空" forState:UIControlStateNormal];
    qingkong.frame=CGRectMake(self.view.width-80*self.scale, self.TitleLabel.top+10*self.scale, 70*self.scale, 25*self.scale);
    qingkong.titleLabel.font=DefaultFont(self.scale);
    [qingkong addTarget:self action:@selector(qingEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:qingkong];
    [qingkong setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [qingkong sizeToFit];
    qingkong.right=self.view.width-15*self.scale;
    qingkong.bottom=60;
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
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            NSDictionary *dic = @{@"user_id":userid};
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle clearCartWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                if ([code isEqualToString:@"0"]) {
                    self.appdelegate.isRefresh=true;
                //    [self ShowAlertWithMessage:msg];
                    [_dataSource removeAllObjects];
                    [self huoQuGouWuCheShuLiang];
                    [self newView];
                    _bigVi.hidden=YES;
                    if (_ifQing) {
                        _ifQing(@"ok");
                    }
                    
                    _tishi = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 30*self.scale)];
                    _tishi.textAlignment=NSTextAlignmentCenter;
                    _tishi.font=SmallFont(self.scale);
                    _tishi.text=@"购物车暂无商品";
                    [self.view addSubview:_tishi];
                }
                
            }];
        }
    
    }];

}
#pragma mark -- 富文本
- (NSMutableAttributedString *)getAmountFuWenBenWithStirng:(NSString *)string
{
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
