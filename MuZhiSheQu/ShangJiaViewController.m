//
//  ShangJiaViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShangJiaViewController.h"
#import "ShangJiaTableViewCell.h"
//#import "GanXiShopViewController.h"
#import "UmengCollection.h"
#import "ShengHuoTableViewCell.h"
@interface ShangJiaViewController()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ShangJiaTableViewCellDelegate>{
    UIView *lineFen;
}
@property(nonatomic,strong)UIScrollView *ToolView;
//@property(nonatomic,strong)UILabel *la;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource,*topData;
//@property(nonatomic,strong)NSMutableArray *buttonArr;
//@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)NSInteger index,Tag;
@property(nonatomic,strong)NSString *IdStr,*guanliTel;
@property(nonatomic,strong)UILabel *la;
@property(nonatomic,assign)float X;
@property(nonatomic,strong)UIScrollView * bottomScrollView;
@property(nonatomic,strong)DCNavTabBarController * dcNavTabarVC;
@property(nonatomic,strong)UIButton * reshBtn;
//@property(nonatomic,strong)NSMutableArray *topData,*botData;
//@property(nonatomic,strong)UITextField *searchText;
//@property(nonatomic,strong)CellView *heardView;
//@property(nonatomic,assign)int typee;
@end
@implementation ShangJiaViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    self.navigationController.navigationBarHidden=YES;
//    NSString *addrss = [[NSUserDefaults standardUserDefaults]objectForKey:@"commname"];
//    self.TitleLabel.text=addrss;
//    
//    
//    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"changeCommShang"]) {
//        _topData = [NSMutableArray new];
//        _botData=[NSMutableArray new];
        _IdStr=@"!";
        _index=0;
        _Tag=1;
        [self reshData];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"changeCommShang"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else{
        
//        self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
//        if (self.commid==nil || [self.commid isEqualToString:@""]) {
//            // [self ShowAlertWithMessage:@"没有数据，请重新选择社区"];
//        }
//        
//        return;
        
    }
    //
    
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
//    _typee=0;
//    _is_weishang=@"2";
//    _shoptype=@"1";
//    _topData = [NSMutableArray new];
//    _botData=[NSMutableArray new];
//    _index=0;
//    if (_ToolView) {
//        [_ToolView removeFromSuperview];
//    }
//    
//    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changeCommShang"];
//    if ([self getCommid]==nil || [[self getCommid] isEqualToString:@""]) {
//        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"changeCommShang"];
//    }
//    
//    _ToolView=[[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 40*self.scale)];
//    _ToolView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:_ToolView];
//    [self newToolButton];
//    if (_tableView) {
//        [_tableView removeFromSuperview];
//    }
//    [self newNav];
//    [self newView];
//    [self.view addSubview:self.activityVC];
//    [self.activityVC startAnimate];
//    [self reshData];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    _X=0;
    _index=0;
    _Tag=1;
    _IdStr=@"!";
    _dataSource = [NSMutableArray new];
    _topData = [NSMutableArray new];
    [self newNav];
//    [self newView];
//    [self botView];
    [self reshData];
    
    
    

}




//-(void)newView{
//
//    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64-49-30*self.scale)];
//    _tableView.dataSource=self;
//    _tableView.delegate=self;
//    _tableView.footer.automaticallyRefresh=NO ;
//    _tableView.scrollEnabled = NO;
////    _tableView.rowHeight=90*self.scale;
//    [self.view addSubview:_tableView];
//    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
////    [_tableView registerClass:[ShengHuoTableViewCell class] forCellReuseIdentifier:@"cell"];
////    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
//    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
//  
//  
//}

-(void)botView{

    float h = 30*self.scale;
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-h, self.view.width, h)];
    vi.backgroundColor=[UIColor colorWithRed:245/255.0 green:1 blue:170/255.0 alpha:1];
    [self.view addSubview:vi];
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 0, 0, 0)];
    la.text=@"如果您也想为社区提供服务，点击联系管理员";
    la.font=[UIFont systemFontOfSize:11*self.scale];
    [la sizeToFit];
    la.height=h;
    [vi addSubview:la];

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    btn.titleLabel.font=DefaultFont(self.scale);
    [btn setTitle:@"管理员" forState:0];
    [btn addTarget:self action:@selector(teltalk) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor=blueTextColor;
    btn.layer.cornerRadius=4;
    btn.titleLabel.font=SmallFont(self.scale);
    [btn sizeToFit];
    btn.width=btn.width+7*self.scale;
    btn.height=btn.height-7*self.scale;

    btn.right=vi.width-10*self.scale;
    btn.centerY=la.centerY;
    [vi addSubview:btn];
    
    
    la.width=vi.width-btn.width-20*self.scale;
    
    
}
#pragma mark -- 获取电话号码
-(void)teltalk{
    
//    if (![[NSString stringWithFormat:@"%@",_guanliTel] isEmptyString]) {
//        [self telWithTel:_guanliTel];
//        return;
//    }
    
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    
    NSDictionary *dic = @{@"pindex":[NSString stringWithFormat:@"%d",1],@"community_id":[self getCommid]};
    
    AnalyzeObject *anle =[AnalyzeObject new];
    [anle showCommonTelWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"tel==%@",models);
            _guanliTel=[NSString stringWithFormat:@"%@",models[@"platform_tel"]];
            [self telWithTel:_guanliTel];

        }
    }];

    
    
    
    
}

#pragma mark-- 管理员点击按钮
-(void)telWithTel:(NSString *)str{

    NSMutableString * str1=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",str];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str1]];

}
#pragma mark -- 创建刷新按钮
- (void)createReshBtn
{
    if (_reshBtn)
    {
        [_reshBtn removeFromSuperview];
        _reshBtn= nil;
    }
    _reshBtn= [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_reshBtn setTitle:@"重新获取数据" forState:(UIControlStateNormal)];
     [_reshBtn sizeToFit];
    _reshBtn.centerX= [UIScreen mainScreen].bounds.size.width/2;
    _reshBtn.centerY = [UIScreen mainScreen].bounds.size.height/2;
   
    _reshBtn.layer.cornerRadius = 0.5;
    _reshBtn.clipsToBounds = YES;
    _reshBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _reshBtn.layer.borderWidth = 0.5;
    _reshBtn.titleLabel.font = [UIFont systemFontOfSize:12*self.scale];
    [_reshBtn addTarget:self action:@selector(reshBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [_reshBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    
    [self.view addSubview:_reshBtn];
    
    
}
#pragma mark -- reshBtn按钮点击事件
- (void)reshBtnClick
{
    [self reshData];
}
//#pragma mark -- 分类标题按钮点击事件
//-(void)TopBtnEvent:(UIButton *)sender{
//
//    for (UIButton *btn in _ToolView.subviews) {
//        if ([btn isKindOfClass:[UIButton class]]) {
//            btn.selected=NO;
//        }
//    }
//    
//    sender.selected=YES;
//
//    
//    [UIView animateWithDuration:.3 animations:^{
//        
//        lineFen.frame=CGRectMake((sender.tag-1)*70*self.scale, _ToolView.height-2, 70*self.scale, 2);
//        
//    }];
//
//    _index=0;
//    _IdStr = [NSString stringWithFormat:@"%@",_topData[sender.tag-1][@"id"]];
//    _Tag=sender.tag;
//    _X = _ToolView.contentOffset.x;
////    [self reshList];
//    
//}

//-(void)shangla{
//
//    [self reshList];
//}

-(void)xiala{
//    _index=0;
    [self reshData];

}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    if (_ToolView) {
//        
//       [ _ToolView removeFromSuperview];
//        _ToolView=nil;
//    }
//    
//    _ToolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40*self.scale)];
//    _ToolView.backgroundColor=superBackgroundColor;
//    _ToolView.showsHorizontalScrollIndicator=NO;
//    _ToolView.showsVerticalScrollIndicator=NO;
//
//    float setY = 0*self.scale;
//    
//    for (int i=0; i<_topData.count; i++) {
//        
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(setY+0*self.scale, 0, 0, 0)];
//        [btn setTitle:[NSString stringWithFormat:@"%@",_topData[i][@"class_name"]] forState:0];
//        [btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.7] forState:0];
//        btn.tag=1+i;
//
//        btn.titleLabel.font=SmallFont(self.scale);
//        [btn setTitleColor:[UIColor colorWithRed:0 green:134/255.0 blue:237/255.0 alpha:1] forState:UIControlStateSelected];
//        [btn addTarget:self action:@selector(TopBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
////        [btn sizeToFit];
//        
//        btn.width=70*self.scale;
//        
//        btn.height=40*self.scale;
//        setY = btn.right;
//        [_ToolView addSubview:btn];
//        _ToolView.contentSize=CGSizeMake(btn.right+10*self.scale, 0);
//        
//        if (_Tag==btn.tag) {
//            btn.selected=YES;
//        }
//
//        
//        [_ToolView setContentOffset:CGPointMake(_X, 0)];
//    }
//    
//    if (!lineFen) {
//        lineFen = [[UIView alloc] initWithFrame:CGRectMake(0, _ToolView.height-2, 70*self.scale, 2)];
//        lineFen.backgroundColor=[UIColor colorWithRed:0 green:134/255.0 blue:237/255.0 alpha:1];
//        
//    }
//    [_ToolView addSubview:lineFen];
//
//    
//    return _ToolView;
//
//}
//- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40*self.scale;
//
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
////    NSLog(@"dataSource%@",self.dataSource);
//    if (_topData.count>0)
//    {
//        return 1;
//    }
//    else
//    {
//        return 0;
//    }
// 
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
////    ShengHuoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
////    
//////    if (!cell)
//////    {
//////        cell = [[ShengHuoTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
//////    }
////    
////    cell.titleLa.text=[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"shop_name"]];
////    [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"logo"]]] placeholderImage:[UIImage imageNamed:@"center_img"]];
////    cell.addressLa.text=[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"address"]];
////    [cell.telBtn addTarget:self action:@selector(makePhone:) forControlEvents:UIControlEventTouchUpInside];
////    if ([[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"detail"]] isEmptyString])
////    {
////        cell.shangPinJianJieLab.text = [NSString stringWithFormat:@"商家简介:%@",@"无"];
////    }
////    else
////    {
////        cell.shangPinJianJieLab.text = [NSString stringWithFormat:@"商家简介:%@",_dataSource[indexPath.row][@"detail"]];
////    }
////   
////    cell.telBtn.tag=10000+indexPath.row;
//    
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell)
//    {
//        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
////        [cell.contentView addSubview:[self createSonViewControllerWith:self.topData]];
//    }
//    
////    cell.backgroundColor = [UIColor whiteColor];
//    
//    
//    
//    return cell;
//}
//#pragma  mark -- 获取cell的高度
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
// 
//    
//    CGRect addressH = [self getStringWithFont:[UIFont systemFontOfSize:12*self.scale] withWidth:[UIScreen mainScreen].bounds.size.width - 155*self.scale withString:[NSString stringWithFormat:@"%@",_dataSource[indexPath.row][@"address"]]];
//    
//    CGFloat height = addressH.size.height>30*self.scale?addressH.size.height:30*self.scale;
//
//                          ;
//    return (15+20+10+20)*self.scale + height;
//}
-(void)makePhone:(UIButton *)sender{
    
    if ([[NSString stringWithFormat:@"%@",_dataSource[sender.tag-10000][@"hotline"]] isEmptyString]) {
        [self ShowAlertWithMessage:@"该商家暂未提供电话！"];
        return;
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[NSString stringWithFormat:@"%@",_dataSource[sender.tag-10000][@"hotline"]]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.hidesBottomBarWhenPushed=YES;
//    
//   BOOL issleep = [self getTimeWith:_dataSource[indexPath.row]];
//    
//            GanXiShopViewController *gan = [GanXiShopViewController new];
//        gan.zongshuju=_dataSource[indexPath.row];
//    
////    NSLog(@"%@",_dataSource[indexPath.row]);
////    
//            if ([_dataSource[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
//                gan.isOpen=NO;
//            }else{
//                gan.isOpen=YES;
//            }
////
//            gan.ID = _dataSource[indexPath.row][@"id"];
//            gan.titlee=_dataSource[indexPath.row][@"shop_name"];
//            gan.shop_user_id =_dataSource[indexPath.row][@"shop_user_id"];
//            gan.issleep=issleep;
//            gan.gonggao=_dataSource[indexPath.row][@"notice"];
//
//    [self.navigationController pushViewController:gan animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
//}
#pragma mark -- 初始化数据和刷新数据
-(void)reshData{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    
    NSDictionary *dic = @{@"community_id":[self getCommid],@"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],@"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]]};
    [anle leibiaol:dic Block:^(id models, NSString *code, NSString *msg) {
        [_topData removeAllObjects];
        [self.activityVC stopAnimate];
        [_tableView.header endRefreshing];
        if ([code isEqualToString:@"0"])
        {
            NSLog(@"init==%@",models);
            [_topData addObjectsFromArray:models];
            if (_topData.count>0 && [_IdStr isEqualToString:@"!"]) {
//                _IdStr = [NSString stringWithFormat:@"%@",_topData[0][@"id"]];
                [self createSonViewControllerWith:_topData];
            }
        }else{
            [self createReshBtn];
//            [self.activityVC stopAnimate];
//            [_tableView.header endRefreshing];
//          
//            [_tableView reloadData];
        }
////        [_tableView.header endRefreshing];
////        [_tableView.footer endRefreshing];
//        [_tableView reloadData];
     
//        [self reshList];
        
       

    }];
    

}
//#pragma mark -- 上拉加载
//-(void)reshList{
//    _index++;
//    AnalyzeObject *anle = [AnalyzeObject new];
//    
//    NSDictionary *dic = @{@"community_id":[self getCommid],@"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],@"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]],@"pindex":[NSString stringWithFormat:@"%ld",(long)_index],@"shop_type":@"2",@"profession_class":[NSString stringWithFormat:@"%@",_IdStr]};
//    
//    
//    [self.view addSubview:self.activityVC];
//    [self.activityVC startAnimate];
//    
//    
//    
//    [anle shangjial:dic Block:^(id models, NSString *code, NSString *msg) {
//        [self.activityVC stopAnimate];
//        [_tableView.header endRefreshing];
//        [_tableView.footer endRefreshing];
//        if (_index==1) {
//            [_dataSource removeAllObjects];
//        }
//
//        if ([code isEqualToString:@"0"]) {
//            
//            [_dataSource addObjectsFromArray:models];
//            NSLog(@"%@",self.dataSource);
//            
//        }else
//        {
//        }
//        [_tableView reloadData];
//        
//        [_la removeFromSuperview];
//        if (_dataSource.count<=0) {
//            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
//            _la.text=@"暂无店铺信息！";
//            _la.textAlignment=NSTextAlignmentCenter;
//            [self.view addSubview:_la];
//        }
//
//        
//    }];
//
//}
#pragma mark -- 创建子视图控制器
- (void)createSonViewControllerWith:(NSMutableArray *)titleArray
{
    
    
//    if (self.bottomScrollView)
//    {
//        [self.bottomScrollView removeFromSuperview];
//    }
//    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 49 - self.NavImg.height - 40*self.scale - 30*self.scale)];
//    self.bottomScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * titleArray.count, [UIScreen mainScreen].bounds.size.height - 49 - self.NavImg.height - 40*self.scale - 30*self.scale);
//    
//    self.bottomScrollView.pagingEnabled = YES;
//    
//    self.bottomScrollView.delegate = self;
    
    NSMutableArray * sonVCArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<titleArray.count; i++)
    {
        ShangJiaFenleiViewController * shangjiafenleiVC = [[ShangJiaFenleiViewController alloc]initWithIdString:titleArray[i][@"id"]];
        [shangjiafenleiVC.NavImg removeFromSuperview];
        shangjiafenleiVC.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.height-64-30*self.scale);
        __block ShangJiaFenleiViewController *weakVC = shangjiafenleiVC;
        weakVC.selectIndexRow=^(NSDictionary *dic){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hidesBottomBarWhenPushed=YES;
                BOOL issleep = [self getTimeWith:dic];
                
                GanXiShopViewController *gan = [GanXiShopViewController new];
                gan.zongshuju=dic;
                
                //    NSLog(@"%@",_dataSource[indexPath.row]);
                //
                if ([dic[@"is_open_chat"]isEqualToString:@"2"]) {
                    gan.isOpen=NO;
                }else{
                    gan.isOpen=YES;
                }
                //
                gan.ID = dic[@"id"];
                gan.titlee=dic[@"shop_name"];
                gan.shop_user_id =dic[@"shop_user_id"];
                gan.issleep=issleep;
                gan.gonggao=dic[@"notice"];
                
                [self.navigationController pushViewController:gan animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            });
            
        };
//        shangjiafenleiVC.view.backgroundColor = [UIColor redColor];
//        shangjiafenleiVC.IdString = _topData[i][@"id"];
//        
//        NSLog(@"%@",_topData[i][@"id"]);
//        
////        NSLog(@"5@")
        
        shangjiafenleiVC.title = _topData[i][@"class_name"];
//        [self.bottomScrollView addSubview:shangjiafenleiVC.view];
        
        [sonVCArray addObject:shangjiafenleiVC];

    
    }
    if (_dcNavTabarVC) {
        
        for (UIView *vi in _dcNavTabarVC.view.subviews) {
            [vi removeFromSuperview];
        }
        
        [_dcNavTabarVC removeFromParentViewController];
        _dcNavTabarVC=nil;
    }
    
    _dcNavTabarVC = [[DCNavTabBarController alloc]initWithSubViewControllers:sonVCArray];
    _dcNavTabarVC.view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, self.view.height-64-30*self.scale);
//    _dcNavTabarVC.view.backgroundColor = [UIColor redColor];

    _dcNavTabarVC.btnTextNomalColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    _dcNavTabarVC.btnTextSeletedColor=[UIColor colorWithRed:0 green:134/255.0 blue:237/255.0 alpha:1];
//    _dcNavTabarVC.topBar.backgroundColor = superBackgroundColor;
    
    [self.view addSubview:_dcNavTabarVC.view];
    [self addChildViewController:_dcNavTabarVC];
    
     [self botView];
    
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self.view endEditing:YES];
//    return YES;
//}

//- (void)TextFieldChange{
//    if ([_searchText.text isEqualToString:@""]) {
//        _typee=0;
//    }else{
//        _typee=1;
//    }
//    
//    _index=0;
//    [self reshBotView];
//    
//    
//}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
//}
//
//-(void)reshData{
//    [self.appdelegate dingwei];
//    [self.activityVC startAnimate];
//    AnalyzeObject *anle = [AnalyzeObject new];
//    NSDictionary *dic = @{@"shop_type":self.shoptype};
//    [anle getShopClassListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
//
//        if ([code isEqualToString:@"0"]) {
//            NSLog(@"%@",models);
//            [_topData removeAllObjects];
//            [_botData removeAllObjects];
//
//            [_topData addObjectsFromArray:models];
//            _index=0;
//        }else{
//            [self.activityVC stopAnimate];
//        }
//        
//        
//        [_la removeFromSuperview];
//        if (_topData.count<=0) {
//            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
//            _la.text=@"暂无店铺信息！";
//            _la.textAlignment=NSTextAlignmentCenter;
//            [self.tableView addSubview:_la];
//        }
//
//        
//        [self newView];
//        _index=0;
//        [self reshBotView];
//
//    }];
//    
//    
//}
//
//
//-(void)reshBotView{
////    if (_topData.count>0) {
//    
//    
//    _index++;
//    AnalyzeObject *anle = [AnalyzeObject new];
//    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
//    NSDictionary *dic1 =@{@"pindex":index,@"community_id":[self getCommid],@"shop_type":_shoptype,@"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],@"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]],@"key":@""};
//    
//    
//    
//    
//    if (_typee==1) {
//        dic1 =@{@"pindex":index,@"community_id":[self getCommid],@"key":_searchText.text,@"shop_type":_shoptype,@"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],@"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]]};
//    }
//    
//    
//    [anle queryShopByKeyWithDic:dic1 Block:^(id models, NSString *code, NSString *msg) {
//        if (_index==1) {
//            [_botData removeAllObjects];
//        }
//
//        if ([code isEqualToString:@"0"]) {
//            [_botData addObjectsFromArray:models];
//            
//        }
//        
//       
//
//        
//        [_tableView reloadData];
//        [self.activityVC stopAnimate];
//        [_tableView.header endRefreshing];
//        [_tableView.footer endRefreshing];
//        
//    }];
////    }
//
//
//}
//-(void)newView{
//    if (_tableView) {
//        [_tableView removeFromSuperview];
//    }
//    
//    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _ToolView.bottom, self.view.width, [UIScreen mainScreen].bounds.size.height-_ToolView.bottom-49)];
//    _tableView.delegate=self;
//    _tableView.backgroundColor=[UIColor clearColor];
//    _tableView.dataSource=self;
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [_tableView registerClass:[BreakfastCellTableViewCell class] forCellReuseIdentifier:@"Cell"];
//    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footevent)];
//    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headevent)];
//    [self.view addSubview:_tableView];
//    [self newHeardView];
//}
//
//-(void)footevent{
////    _index++;
////    [self.view addSubview:self.activityVC];
////    [self.activityVC startAnimate];
////    
////    AnalyzeObject *anle = [AnalyzeObject new];
////    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
////    NSDictionary *dic1 =@{@"pindex":index,@"profession_class":[NSString stringWithFormat:@"%@",self.profession_class],@"community_id":[self getCommid],@"shop_type":_shoptype,@"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],@"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]]};
////    if (_typee==1) {
////        dic1 =@{@"pindex":index,@"profession_class":[NSString stringWithFormat:@"%@",self.profession_class],@"community_id":[self getCommid],@"key":_searchText.text,@"shop_type":_shoptype,@"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],@"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]]};
////    }
////    
////    
////    [anle queryShopByKeyWithDic:dic1 Block:^(id models, NSString *code, NSString *msg) {
////        [self.activityVC stopAnimate];
////        [_tableView.header endRefreshing];
////        [_tableView.footer endRefreshing];
////        if (_index==1) {
////            [_botData removeAllObjects];
////        }
////        if ([code isEqualToString:@"0"]) {
////            [_botData addObjectsFromArray:models];
////            
////        }
////        [_tableView reloadData];
////        [self.activityVC stopAnimate];
////    }];
//    
//
//    
//    [self reshBotView];
//}
//
//-(void)headevent{
//    for (UIButton *btn in _heardView.subviews) {
//        if ([btn isKindOfClass:[UIButton class]]) {
//            btn.selected=NO;
//        }
//    }
//
//    
//    _index=0;
//    [self reshData];
//}
//
//#pragma mark - HeardView
//-(void)newHeardView{
//    _heardView=[[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150*self.scale)];
//    _heardView.topline.hidden=NO;
//    _heardView.bottomline.hidden=NO;
//    _heardView.bottomline.backgroundColor=[UIColor redColor];
//    _heardView.backgroundColor=[UIColor whiteColor];
//    
//    
//    UIImageView *SearchBG=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10, self.view.width-20*self.scale, 32*self.scale)];
//    SearchBG.image=[UIImage setImgNameBianShen:@"gg_pingjia_box"];
//    SearchBG.userInteractionEnabled=YES;
//    [_heardView addSubview:SearchBG];
//    
//    UIImageView *IconImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SearchBG.height, SearchBG.height)];
//    IconImage.image=[UIImage imageNamed:@"search"];
//    [SearchBG addSubview:IconImage];
//    
//    _searchText=[[UITextField alloc]initWithFrame:CGRectMake(IconImage.right, 0, SearchBG.width-IconImage.right-5 , SearchBG.height)];
//    _searchText.font=DefaultFont(self.scale);
//    _searchText.placeholder=@"请输入店名/商品";
//    _searchText.delegate=self;
//    [SearchBG addSubview:_searchText];
//    
//    
//    
//    LineView *line=[[LineView alloc]initWithFrame:CGRectMake(0, SearchBG.bottom+10, self.view.width, 1)];
//    [_heardView addSubview:line];
//    CellView *cline=nil;
//    float btnH=(_heardView.height-line.bottom-50)/2;
//    float btnW=(self.view.width-65*self.scale)/4;
//    
////    float btnH=(SMView.height-line.bottom-50)/2;
////    float btnW=(self.view.width-65*self.scale)/4;
////    for (int i=0; i<title.count; i++)
////    {
////        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale+i%4*(btnW+15*self.scale),line.bottom+20+i/4*(btnH+10), btnW, btnH)];
////    
//    for (int i=0; i<_topData.count; i++) {
//        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale+i%4*(btnW+15*self.scale),line.bottom+10*self.scale+i/4*(btnH+5*self.scale), btnW, 25*self.scale)];
//        [button setTitle:[_topData[i] objectForKey:@"class_name"] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage setImgNameBianShen:@"index_btn"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage setImgNameBianShen:@"index_btn_b"] forState:UIControlStateSelected];
//        button.titleLabel.font=SmallFont(self.scale);
//        button.tag=i-1000;
//      
//        
//        [button addTarget:self action:@selector(ShangMenFuWuEvent:) forControlEvents:UIControlEventTouchUpInside];
//        [_heardView addSubview:button];
//        
//        if (_topData.count-i==1) {
//            cline = [[CellView alloc]initWithFrame:CGRectMake(0, button.bottom+10*self.scale, self.view.width, 10*self.scale)];
//            cline.backgroundColor=superBackgroundColor;
//            [_heardView addSubview:cline];
//            cline.topline.hidden=NO;
//            _heardView.height = cline.bottom+0*self.scale;
//        _tableView.tableHeaderView=_heardView;
//        }
//        
//        if (_topData.count<=0) {
//             cline.bottomline.hidden=NO;
//        }else{
//            cline.bottomline.hidden=YES;
//        }
//        
//        
//    }
//    
//    
//}
//
//
//-(void)ShangMenFuWuEvent:(UIButton *)sender{
//    for (UIButton *btn in _heardView.subviews) {
//        if ([btn isKindOfClass:[UIButton class]]) {
//            btn.selected=NO;
//        }
//    }
//    sender.selected=YES;
//    
//    
//    
//    
//    
//    [self.view addSubview:self.activityVC];
//    [self.activityVC startAnimate];
//    [_botData removeAllObjects];
//    AnalyzeObject *anle = [AnalyzeObject new];
//    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
//    self.profession_class = [_topData[sender.tag+1000] objectForKey:@"id"];
//    NSDictionary *dic1 =@{@"pindex":@"1",@"profession_class":_topData[sender.tag+1000][@"id"],@"community_id":[self getCommid],@"shop_type":_shoptype,@"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],@"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]]};
//    if (_typee==1) {
//        dic1 =@{@"pindex":index,@"profession_class":_topData[sender.tag+1000][@"id"],@"community_id":[self getCommid],@"key":_searchText.text,@"shop_type":_shoptype,@"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],@"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]]};
//    }
//    
//    
//    [anle queryShopByKeyWithDic:dic1 Block:^(id models, NSString *code, NSString *msg) {
//        [self.activityVC stopAnimate];
//        if ([code isEqualToString:@"0"]) {
//            [_botData addObjectsFromArray:models];
//            
//        }
//        [_tableView reloadData];
//        [self.activityVC stopAnimate];
//    }];
//
//    
//}
//#pragma mark - ToolView
//-(void)newToolButton{
//    
//    NSArray *Arr=@[@"零售类",@"服务类"];
//    for (int i=0; i<Arr.count; i++) {
//        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(i*self.view.width/2, 0, self.view.width/2, _ToolView.height-.5)];
//        [button setTitle:Arr[i] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//         [button setTitleColor:blueTextColor forState:UIControlStateSelected];
//        button.titleLabel.font=BigFont(self.scale);
//        button.selected=i==0;
//        button.tag=i+1;
//        [button addTarget:self action:@selector(ToolButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//        [_ToolView addSubview:button];
//    }
//    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, _ToolView.height-.5, self.view.width, .5)];
//    line.backgroundColor=blackLineColore;
//    [_ToolView addSubview:line];
//    UIImageView *Hline=[[UIImageView alloc]initWithFrame:CGRectMake(0, line.top, self.view.width/2, .5)];
//    Hline.backgroundColor=blueTextColor;
//    Hline.tag=3;
//    [_ToolView addSubview:Hline];
//    
//    
//    
//}
//#pragma mark - 按钮事件
//-(void)ToolButtonEvent:(UIButton *)button{
//    [self.view addSubview:self.activityVC];
//    [self.activityVC startAnimate];
//    
//    UIButton *FButton=(UIButton *)[self.view viewWithTag:1];
//    FButton.selected=NO;
//    UIButton *SButton=(UIButton *)[self.view viewWithTag:2];
//    SButton.selected=NO;
//    button.selected=!button.selected;
//    if (button.selected)
//    {
//        [UIView animateWithDuration:0.3 animations:^{
//            UIImageView *Hline=(UIImageView *)[self.view viewWithTag:3];
//            Hline.frame=CGRectMake((button.tag-1)*self.view.width/2, _ToolView.height-.5, self.view.width/2, .5) ;
//        }];
//    }
//    if (button.tag==1) {
//         self.is_weishang=@"2";
//        self.shoptype=@"1";
//    }else{
//    self.is_weishang=@"1";
//        self.shoptype=@"2";
//    }
//    _index=0;
//    [self reshData];
//}
//
//- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
//    
//    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
//    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    
//    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
//    
//    [calendar setTimeZone: timeZone];
//    
//    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
//    
//    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
//    
//    return [weekdays objectAtIndex:theComponents.weekday];
//    
//}
//#pragma mark - UITableViewDelegate & UITableViewDataSource
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _botData.count;
//}
//
//
//
//- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
//{
//    //设置源日期时区
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
//    //设置转换后的目标日期时区
//    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
//    //得到源日期与世界标准时间的偏移量
//    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
//    //目标日期与本地时区的偏移量
//    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
//    //得到时间偏移量的差值
//    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
//    //转为现在时间
//    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate] ;
//    return destinationDateNow;
//}
//
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
////    ShangJiaTableViewCell *cell=(ShangJiaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
////    [cell.HeadImage setImageWithURL:[NSURL URLWithString:[_botData[indexPath.row] objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
////    
////    cell.NameLabel.text=[_botData[indexPath.row] objectForKey:@"shop_name"];
////    cell.TypeLabel.text=[_botData[indexPath.row] objectForKey:@"buss_scope"];
////    cell.AdressLabel.text=[NSString stringWithFormat:@"地址:%@",[_botData[indexPath.row] objectForKey:@"address"]];
////    cell.delegate=self;
////    cell.indexPath=indexPath;
////    cell.selectionStyle=UITableViewCellSelectionStyleNone;
////    return cell;
//    
//    BreakfastCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell.addressImg.image = [UIImage imageNamed:@"address"];
//    cell.addImg.image = [UIImage imageNamed:@"xiaoxi"];
//    if (_botData.count<=0) {
//        return cell;
//    }
//    
//    
//    NSString *url=@"";
//    NSString *cut = [_botData[indexPath.row] objectForKey:@"logo"];
//    if (cut.length>0) {
//        url = [cut substringToIndex:[cut length] - 4];
//        
//    }
//    
//    
//    [cell.headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb320.jpg",url]] placeholderImage:[UIImage imageNamed:@"za"]];
//    
//    cell.headImg.contentMode=UIViewContentModeScaleAspectFill;
//    cell.headImg.clipsToBounds=YES;
//    cell.titleLa.text =[_botData[indexPath.row] objectForKey:@"shop_name"];
//    
//    
//    if ([[NSString stringWithFormat:@"%@",_botData[indexPath.row][@"is_auth"]] isEqualToString:@"2"]) {
//        cell.renZheng.hidden=NO;
//        cell.isJin=YES;
//
//    }else{
//        cell.renZheng.hidden=YES;
//        cell.isJin=NO;
//
//    }
//    NSString *stras = [_botData[indexPath.row] objectForKey:@"rating"];
//    
//    if (stras==nil || [stras isEqualToString:@""] || [stras isEqualToString:@"0"]) {
//        cell.StartNumber=@"0";
//
//    }else{
//        cell.StartNumber=[_botData[indexPath.row] objectForKey:@"rating"];
//
//    }
//    
//    cell.contextLa.text = [_botData[indexPath.row] objectForKey:@"summary"];
//    if ([cell.contextLa.text isEqualToString:@""]) {
//        cell.contextLa.text=@"暂无简介";
//    }
//    
//    cell.addressLa.text = [_botData[indexPath.row] objectForKey:@"address"];
//    
//    
//    
//    float dis = [[_botData[indexPath.row] objectForKey:@"distance"] floatValue];
//    
//    if (dis<1000) {
//        cell.distanceLa.text = [NSString stringWithFormat:@"%.0fm", dis];
//        
//    }else{
//        dis = dis/1000;
//        
//        cell.distanceLa.text = [NSString stringWithFormat:@"%.1fkm", dis];
//        
//    }
//    if ([[_botData[indexPath.row] objectForKey:@"notice"] isEqualToString:@""] || [[_botData[indexPath.row] objectForKey:@"notice"] isKindOfClass:[NSNull class]]) {
//        cell.addLa.text = @"暂无公告";
//
//    }else{
//    
//    cell.addLa.text = [_botData[indexPath.row] objectForKey:@"notice"];
//    }
//    
//    
//    
////-----------------是否休息判断
//    
//    
//    if ([_botData[indexPath.row][@"status"] isEqualToString:@"3"]) {
//        cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//        cell.addLa.textColor=[UIColor redColor];
//        
//        return cell;
//    }else{
//        NSString *week = [self weekdayStringFromDate:[NSDate date]];
//        if ([week isEqualToString:@"周六"]) {
//            if ([_botData[indexPath.row][@"off_on_saturday"] isEqualToString:@"2"]) {
//                cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//                cell.addLa.textColor=[UIColor redColor];
//                return cell;
//            }
//        }else if ([week isEqualToString:@"周日"]){
//            if ([_botData[indexPath.row][@"off_on_sunday"] isEqualToString:@"2"]) {
//                cell.addLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//                cell.addLa.textColor=[UIColor redColor];
//                return cell;
//            }
//        }
//    }
//    
//    BOOL isSleep1=YES;
//    BOOL isSleep2=YES;
//    BOOL isSleep3=YES;
//    
//    NSLog(@"%@",_botData[indexPath.row][@"business_start_hour1"]);
//    
//    NSArray *timArr  = [_botData[indexPath.row][@"business_hour"] componentsSeparatedByString:@","];
//    
//    NSDate *now = [NSDate date];
//    NSDateFormatter *nowFo = [[NSDateFormatter alloc]init];
//    [nowFo setDateFormat:@"yyyy-MM-dd"];
//    NSString *noewyers = [nowFo stringFromDate:now];
//    
//    for (NSString *str in timArr) {
//        if ([str isEqualToString:@"1"]) {
//            
//            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_botData[indexPath.row][@"business_start_hour1"]]];
//            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_botData[indexPath.row][@"business_end_hour1"]]];
//            
//            
//            
//            NSDateFormatter *fo = [[NSDateFormatter alloc]init];
//            [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate *das = [fo dateFromString:timeStart1];
//            NSDate *dad = [fo dateFromString:timeEnd1];
//            
//            NSDate *dates = [self getNowDateFromatAnDate:das];
//            NSDate *dated = [self getNowDateFromatAnDate:dad];
//            NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
//
//            NSLog(@"%@",[NSDate date]);
//            
//            
//            //开始的时间戳
//            double times = [dates timeIntervalSince1970];
//            //结束的时间戳
//            double timed = [dated timeIntervalSince1970];
//            //现在的时间戳
//            double timen = [daten timeIntervalSince1970];
//            
//            
//            
//            if (timen>times && timen<timed) {
//                isSleep1=NO;
//            }else{
//                isSleep1=YES;
//            }
//            
//            
//            
//        }
//        
//        
//        
//        
//        else if ([str isEqualToString:@"2"]) {
//            
//            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_botData[indexPath.row][@"business_start_hour2"]]];
//            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_botData[indexPath.row][@"business_end_hour2"]]];
//            NSDateFormatter *fo = [[NSDateFormatter alloc]init];
//            [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate *das = [fo dateFromString:timeStart1];
//            NSDate *dad = [fo dateFromString:timeEnd1];
//            
//            
//            NSDate *dates = [self getNowDateFromatAnDate:das];
//            NSDate *dated = [self getNowDateFromatAnDate:dad];
//            NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
//            
//            //开始的时间戳
//            double times = [dates timeIntervalSince1970];
//            //结束的时间戳
//            double timed = [dated timeIntervalSince1970];
//            //现在的时间戳
//            double timen = [daten timeIntervalSince1970];
//            
//            
//            
//            if (timen>times && timen<timed) {
//                isSleep2=NO;
//            }else{
//                isSleep2=YES;
//            }
//            
//            
//            
//        }
//        
//        
//        else  if ([str isEqualToString:@"3"]) {
//            
//            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_botData[indexPath.row][@"business_start_hour3"]]];
//            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_botData[indexPath.row][@"business_end_hour3"]]];
//            NSDateFormatter *fo = [[NSDateFormatter alloc]init];
//            [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate *das = [fo dateFromString:timeStart1];
//            NSDate *dad = [fo dateFromString:timeEnd1];
//            
//            
//            NSDate *dates = [self getNowDateFromatAnDate:das];
//            NSDate *dated = [self getNowDateFromatAnDate:dad];
//            NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
//
//            //开始的时间戳
//            double times = [dates timeIntervalSince1970];
//            //结束的时间戳
//            double timed = [dated timeIntervalSince1970];
//            //现在的时间戳
//            double timen = [daten timeIntervalSince1970];
//            
//            
//            
//            if (timen>times && timen<timed) {
//                isSleep3=NO;
//            }else{
//                isSleep3=YES;
//            }
//            
//        }
//        
//        
//    }
//    //-----------------
//    if (isSleep1==NO || isSleep2==NO || isSleep3==NO) {
//        
//        cell.addLa.text = [_botData[indexPath.row] objectForKey:@"notice"];
//        cell.addLa.textColor=blueTextColor;
//        if ([cell.addLa.text isEqualToString:@""]) {
//            cell.addLa.text=@"暂无公告";
//        }
//        
//    }else{
//        cell.addLa.text = @"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//        cell.addLa.textColor=[UIColor redColor];
//
//    }
//    
//    if ([_botData[indexPath.row][@"business_hour"] isEqualToString:@""]) {
//        cell.addLa.text = [_botData[indexPath.row] objectForKey:@"notice"];
//        cell.addLa.textColor=blueTextColor;
//        if ([cell.addLa.text isEqualToString:@""]) {
//            cell.addLa.text=@"暂无公告";
//        }
//        
//    }
//    
//    
//    //-----------------是否休息判断end
//
//    
//    
//    
//    
//    return cell;
//
//    
//    
//    
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//    
//    
//    //-----------------是否休息判断
//  
//    if (_botData.count<=0) {
//        return 0;
//    }
//    
//    BOOL isSleep1=YES;
//    BOOL isSleep2=YES;
//    BOOL isSleep3=YES;
//    
//    NSArray *timArr  = [_botData[indexPath.row][@"business_hour"] componentsSeparatedByString:@","];
//    
//    NSDate *now = [NSDate date];
//    NSDateFormatter *nowFo = [[NSDateFormatter alloc]init];
//    [nowFo setDateFormat:@"yyyy-MM-dd"];
//    NSString *noewyers = [nowFo stringFromDate:now];
//    
//    for (NSString *str in timArr) {
//        if ([str isEqualToString:@"1"]) {
//            
//            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_botData[indexPath.row][@"business_start_hour1"]]];
//            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_botData[indexPath.row][@"business_end_hour1"]]];
//            
//            
//            
//            NSDateFormatter *fo = [[NSDateFormatter alloc]init];
//            [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate *das = [fo dateFromString:timeStart1];
//            NSDate *dad = [fo dateFromString:timeEnd1];
//            
//            NSDate *dates = [self getNowDateFromatAnDate:das];
//            NSDate *dated = [self getNowDateFromatAnDate:dad];
//            NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
//            
//            
//            
//            //开始的时间戳
//            double times = [dates timeIntervalSince1970];
//            //结束的时间戳
//            double timed = [dated timeIntervalSince1970];
//            //现在的时间戳
//            double timen = [daten timeIntervalSince1970];
//            
//            
//            
//            if (timen>times && timen<timed) {
//                isSleep1=NO;
//            }else{
//                isSleep1=YES;
//            }
//            
//        }
//        
//        
//        else if ([str isEqualToString:@"2"]) {
//            
//            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_botData[indexPath.row][@"business_start_hour2"]]];
//            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_botData[indexPath.row][@"business_end_hour2"]]];
//            NSDateFormatter *fo = [[NSDateFormatter alloc]init];
//            [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate *das = [fo dateFromString:timeStart1];
//            NSDate *dad = [fo dateFromString:timeEnd1];
//            
//            
//            NSDate *dates = [self getNowDateFromatAnDate:das];
//            NSDate *dated = [self getNowDateFromatAnDate:dad];
//            NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
//            
//            //开始的时间戳
//            double times = [dates timeIntervalSince1970];
//            //结束的时间戳
//            double timed = [dated timeIntervalSince1970];
//            //现在的时间戳
//            double timen = [daten timeIntervalSince1970];
//            
//            
//            
//            if (timen>times && timen<timed) {
//                isSleep2=NO;
//            }else{
//                isSleep2=YES;
//            }
//            
//            
//            
//        }
//        
//        
//        else  if ([str isEqualToString:@"3"]) {
//            
//            NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_botData[indexPath.row][@"business_start_hour3"]]];
//            NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_botData[indexPath.row][@"business_end_hour3"]]];
//            NSDateFormatter *fo = [[NSDateFormatter alloc]init];
//            [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate *das = [fo dateFromString:timeStart1];
//            NSDate *dad = [fo dateFromString:timeEnd1];
//            
//            
//            NSDate *dates = [self getNowDateFromatAnDate:das];
//            NSDate *dated = [self getNowDateFromatAnDate:dad];
//            NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
//            
//            //开始的时间戳
//            double times = [dates timeIntervalSince1970];
//            //结束的时间戳
//            double timed = [dated timeIntervalSince1970];
//            //现在的时间戳
//            double timen = [daten timeIntervalSince1970];
//            
//            
//            
//            if (timen>times && timen<timed) {
//                isSleep3=NO;
//            }else{
//                isSleep3=YES;
//            }
//            
//        }
//        
//        
//    }
//    
//    
//    
//    
//    UILabel *add = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width-120*self.scale, 10)];
//    add.font=SmallFont(self.scale);
//    add.numberOfLines=0;
//    
//
//    
//    
//    //-----------------
//    if (isSleep1==NO || isSleep2==NO || isSleep3==NO) {
//        add.text=[_botData[indexPath.row] objectForKey:@"notice"];
//        
//    }else{
//        add.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//        
//    }
//    
//    if ([_botData[indexPath.row][@"business_hour"] isEqualToString:@""]) {
//        add.text=[_botData[indexPath.row] objectForKey:@"notice"];
//        
//    }
//    
//    if ([_botData[indexPath.row][@"status"] isEqualToString:@"3"]) {
//        add.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//    }else{
//        NSString *week = [self weekdayStringFromDate:[NSDate date]];
//        if ([week isEqualToString:@"周六"]) {
//            if ([_botData[indexPath.row][@"off_on_saturday"] isEqualToString:@"2"]) {
//                add.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//            }
//        }else if ([week isEqualToString:@"周日"]){
//            if ([_botData[indexPath.row][@"off_on_sunday"] isEqualToString:@"2"]) {
//                add.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
//            }
//        }
//    }
//    
//    if ([add.text isEqualToString:@""]) {
//        add.text=@"暂无公告";
//    }
//    
//    
//    NSLog(@"%@  %f",add.text,add.height);
//    
//
//    if (add.height>30*self.scale) {
//        add.height=30*self.scale;
//    }
//    if (add.height<20*self.scale) {
//        add.height=20*self.scale;
//    }
//    
//    
//    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width-180*self.scale, 10)];
//    la.font=DefaultFont(self.scale);
//    la.numberOfLines=0;
//    la.text=[_botData[indexPath.row] objectForKey:@"address"];
//    [la sizeToFit];
//    if (la.height>30*self.scale) {
//        la.height=30*self.scale;
//    }
//    
//    
//    
//    UILabel *buss = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width-130*self.scale, 10)];
//    buss.text=[_botData[indexPath.row] objectForKey:@"summary"];
//    if ([buss.text isEqualToString:@""]) {
//        buss.text=@"暂无简介";
//    }
//    buss.font=SmallFont(self.scale);
//    buss.numberOfLines=0;
//    [buss sizeToFit];
//    if (buss.height>30*self.scale) {
//        buss.height=35*self.scale;
//    }
//    if (buss.height<20*self.scale) {
//        buss.height=20*self.scale;
//    }
//    
//
//
//    
//    
//    float h = la.height+ 60*self.scale+buss.height+add.height;
//    if ([_botData[indexPath.row] objectForKey:@"rating"]==nil || [[_botData[indexPath.row] objectForKey:@"rating"]isEqualToString:@""]) {
//        h=h-15*self.scale;
//    }
//    
//    
//    NSLog(@"%f",h);
//    NSLog(@"   内容%f   地址%f  公告%f",buss.height,la.height,add.height);
//
//    
//    return h+0*self.scale;
//}
//
////-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
////    return 10;
////}
////-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
////    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
////    view.backgroundColor=superBackgroundColor;
////    UIImageView *Tline=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, .5)];
////    Tline.backgroundColor=blackLineColore;
////    [view addSubview:Tline];
////    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, view.height-.5, self.view.width, .5)];
////    line.backgroundColor=blackLineColore;
////    [view addSubview:line];
////    return view;
////}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.hidesBottomBarWhenPushed=YES;
//    BOOL issleep;
//    BreakfastCellTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    NSLog(@"%@",cell.addLa.text);
//    
//    if ([cell.addLa.text isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
//        issleep=YES;
//    }else{
//        issleep=NO;
//    }
//    
//    
//    
//    
//    if ([_botData[indexPath.row][@"shop_type"] isEqualToString:@"2"]) {
//        GanXiShopViewController *gan = [GanXiShopViewController new];
//        
//        if ([_botData[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
//            gan.isOpen=NO;
//        }else{
//            gan.isOpen=YES;
//        }
//        
//        gan.ID = _botData[indexPath.row][@"id"];
//        gan.titlee=_botData[indexPath.row][@"shop_name"];
//        gan.shop_user_id =_botData[indexPath.row][@"shop_user_id"];
//        gan.issleep=issleep;
//        gan.gonggao=_botData[indexPath.row][@"notice"];
//        NSLog(@"%@",gan.shop_user_id);
//        [self.navigationController pushViewController:gan animated:YES];
//    }else{
//        
//        
//        
//        
//        BreakInfoViewController *ganxi = [BreakInfoViewController new];
//        NSLog(@"%@",_botData[indexPath.row][@"is_open_chat"]);
//        
//        if ([_botData[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
//            ganxi.isopen=NO;
//        }else{
//            ganxi.isopen=YES;
//        }
//        ganxi.tel = [NSString stringWithFormat:@"%@",_botData[indexPath.row][@"hotline"]];
//        ganxi.shop_user_id=_botData[indexPath.row][@"shop_user_id"];
//        ganxi.ID = _botData[indexPath.row][@"id"];
//        ganxi.gonggao =_botData[indexPath.row][@"notice"];
//        ganxi.titlete =_botData[indexPath.row][@"shop_name"];
//        ganxi.yunfei = _botData[indexPath.row][@"delivery_fee"];
//        ganxi.manduoshaofree = _botData[indexPath.row][@"free_delivery_amount"];
//        ganxi.gonggao=_botData[indexPath.row][@"notice"];
//        ganxi.issleep=issleep;
//        
//        [self.navigationController pushViewController:ganxi animated:YES];
//    }
//    self.hidesBottomBarWhenPushed=NO;
//    
//}
//-(void)ShangJiaTableViewCellEnterShop:(NSIndexPath *)indexPath{
//    self.hidesBottomBarWhenPushed=YES;
//
//    
//    if ([_botData[indexPath.row][@"shop_type"] isEqualToString:@"2"]) {
//        GanXiShopViewController *gan = [GanXiShopViewController new];
//        gan.ID = _botData[indexPath.row][@"id"];
//        gan.titlee=_botData[indexPath.row][@"shop_name"];
//        [self.navigationController pushViewController:gan animated:YES];
//    }else{
//    
//    BreakInfoViewController *ganxi = [BreakInfoViewController new];
//    ganxi.ID = _botData[indexPath.row][@"id"];
//    ganxi.titlete =_botData[indexPath.row][@"shop_name"];
//        ganxi.yunfei = _botData[indexPath.row][@"delivery_fee"];
//        ganxi.manduoshaofree = _botData[indexPath.row][@"free_delivery_amount"];
//        ganxi.gonggao=_botData[indexPath.row][@"notice"];
//        ganxi.shop_user_id=[_botData[indexPath.row] objectForKey:@"shop_user_id"];
//    [self.navigationController pushViewController:ganxi animated:YES];
//    }
//    self.hidesBottomBarWhenPushed=NO;
// 
//}
//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}
#pragma mark -- 获取字体的高度和宽度
- (CGRect)getStringWithFont:(UIFont *)font withWidth:(CGFloat)width withString:(NSString *)string
{
    CGRect stringRect = [string boundingRectWithSize:CGSizeMake(width,2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    return stringRect;
}
#pragma mark - 导航
-(void)newNav{
//    NSString *addrss = [[NSUserDefaults standardUserDefaults]objectForKey:@"commname"];
    
    
    self.TitleLabel.text=@"生活服务";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
