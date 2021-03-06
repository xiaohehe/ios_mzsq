//
//  ShopLingShouViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//
/*
 订单请求状态：
 请求时：
 -1：退货中
 1：待付款
 2：待发货
 3：待收货
 4：待评价
 5:全部订单
 6：已取消
 
 返回时：
 退货中 = -1,
 未付款 = 1,
 已付款 = 2,
 已接单 = 3,
 已发货 = 4,
 已完成 = 5,
 已取消 = 6
 
 */
#import "ShopLingShouViewController.h"
#import "CellView.h"
#import "OderStatesViewController.h"
#import "UmengCollection.h"
#import "OrderFileViewController.h"
#import "orderSuessViewController.h"
#import "CannelViewController.h"
#import "AppUtil.h"
@interface ShopLingShouViewController ()
@property(nonatomic,strong)UIView *bigBtnVi,*big;
@property(nonatomic,strong)UIScrollView *bigScrollView,*bigScrollView1,*bigScrollView2,*bigScrollView3,*bigScrollView4;
@property(nonatomic,strong)UILabel *la;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)NSString *zhuang;
@property(nonatomic,strong)NSMutableArray *data,*data1,*data2,*data3, *data4,*bigArr,*priceArr, *bigArr1, *bigArr2,*priceArr1,*priceArr2;
@property(nonatomic,assign)NSInteger index,index1,index2,index3,index4;
@property(nonatomic,assign)int sum;
@property(nonatomic,assign)float ji;
@property(nonatomic,strong) NSMutableArray *biggg;

/**
 *代表待付款的表，向订单详情传输数据时 选择的第几行
 */
@property(nonatomic,assign)NSInteger section,row;

@end

@implementation ShopLingShouViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [UmengCollection intoPage:NSStringFromClass([self class])];
    _index4=0;
    self.navigationController.navigationBarHidden=YES;
    if ([_zhuang isEqualToString:@"5"]) {
        [self sc4h:nil];
    }
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)pingjiresh:(NSNotification *)not{
    [self sc3h:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _zhuang=@"5";
    _data4 = [NSMutableArray new];
    _data = [NSMutableArray new];
    _data1 = [NSMutableArray new];
    _data2 = [NSMutableArray new];
    _data3 = [NSMutableArray new];
    _index=0;
    _index1=0;
    _index2=0;
    _index3=0;
    _index4=0;
    [self topVi];
    //[self BigscrollVi];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pingjiresh:) name:@"pingjiresh" object:nil];
    [self centerAllOderVi];
    [self centerDaiFuKuanOderVi];
    [self centerDaiShouHuoOderVi];
    [self centerDaiFaHuoOderVi];
    [self centerDaiPingJiaOderVi];
    [self returnVi];
 //   [self sc0h:nil];
    [self.view addSubview:self.activityVC];
   
}
-(void)reshData{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    [_data removeAllObjects];
    [_data1 removeAllObjects];
    [_data2 removeAllObjects];
    [_data3 removeAllObjects];
    [_data4 removeAllObjects];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"user_id":self.user_id,@"status":_zhuang,@"pindex":@"1"};
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];

        if ([code isEqualToString:@"0"]) {
           [_data addObjectsFromArray:models];
            
            if ([_zhuang isEqualToString:@"1"]) {
                [_data addObjectsFromArray:models];
                [self centerDaiFuKuanOderVi];
            }else if ([_zhuang isEqualToString:@"2"]){
                [_data1 addObjectsFromArray:models];

                [self centerDaiShouHuoOderVi];
            }else if ([_zhuang isEqualToString:@"3"]){
                [_data2 addObjectsFromArray:models];

                [self centerDaiFaHuoOderVi];
            }else if ([_zhuang isEqualToString:@"4"]){
                [_data3 addObjectsFromArray:models];
                [self centerDaiPingJiaOderVi];
            }else if ([_zhuang isEqualToString:@"5"]){
                [_data4 addObjectsFromArray:models];
                [self centerAllOderVi];
            }
        }
        
        if (_data4.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
            _la.text=@"暂无订单信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:_la];
        }
        
    }];
    
    
}
#pragma mark----代付款，
//代收货，代发货，待评价；
-(void)topVi{
    NSArray *daiArr = @[@"全部",@"待付款",@"待发货",@"待收货",@"已完成"];
    _bigBtnVi = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 90/2.25*self.scale)];
    _bigBtnVi.backgroundColor = [UIColor whiteColor];

    float w =self.view.width/5;
    
    [self.view addSubview:_bigBtnVi];
    for (int i=0; i<5; i++) {
        UIButton *daiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [daiBtn setTitle:daiArr[i] forState:UIControlStateNormal];
        daiBtn.titleLabel.font=DefaultFont(self.scale);
        [daiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        daiBtn.selected=(i==0);
        if (daiBtn.selected) {
            _selectedBtn=daiBtn;
        }
         [daiBtn setTitleColor:blueTextColor forState:UIControlStateSelected];
        daiBtn.frame = CGRectMake(i*w, 0, w, _bigBtnVi.height);
        daiBtn.tag=9+i;
        [daiBtn addTarget:self action:@selector(DaiButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_bigBtnVi addSubview:daiBtn];
        if (i!=5) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(daiBtn.right,_bigBtnVi.height/2-7*self.scale, .5, 14*self.scale)];
            line.backgroundColor = blackLineColore;
            [_bigBtnVi addSubview:line];
        }
    }
    UIView *endLine = [[UIView alloc]initWithFrame:CGRectMake(0, _bigBtnVi.height-.5, self.view.width, .5)];
    endLine.backgroundColor = blackLineColore;
    [_bigBtnVi addSubview:endLine];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, endLine.top, self.view.width/5, endLine.height)];
    line.backgroundColor=blueTextColor;
    line.tag=66666666;
    [_bigBtnVi addSubview:line];
}

//所有订单
-(void)sc4h:(id)send{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    [_la removeFromSuperview];
    _index4=1;
    [_data4 removeAllObjects];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSString *index = [NSString stringWithFormat:@"%d",1];
    NSDictionary *dic = @{@"user_id":self.user_id,@"status":@"5",@"pindex":index};
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        NSLog(@"所有订单==%@",models);
       // CGPoint point = _bigScrollView.contentOffset;
       // point.y=point.y-5*self.scale;
        if (_index4==1) {
            [_data4 removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {
            [_data4 addObjectsFromArray:models];
        }
        [self centerAllOderVi];
        //[_bigScrollView setContentOffset:point animated:NO];
        [self.activityVC stopAnimate];
        [_bigScrollView.header endRefreshing];
        [_bigScrollView.footer endRefreshing];
        if (_data4.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
            _la.text=@"暂无订单信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:_la];
        }
    }];
}

//所有订单
-(void)sc4f:(id)send{
    _index4++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    
    NSDictionary *dic = @{@"user_id":self.user_id,@"status":@"1",@"pindex":index};
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [_bigScrollView.header endRefreshing];
        [_bigScrollView.footer endRefreshing];
        CGPoint point = _bigScrollView.contentOffset;
        if ([code isEqualToString:@"0"]) {
            [_data4 addObjectsFromArray:models];
        }
        [self centerAllOderVi];
        [_bigScrollView setContentOffset:point animated:NO];
        
    }];
}


//0
-(void)sc0h:(id)send{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];

    [_la removeFromSuperview];
    _index=1;
    [_data removeAllObjects];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    AnalyzeObject *anle = [AnalyzeObject new];
    NSString *index = [NSString stringWithFormat:@"%d",1];
    NSDictionary *dic = @{@"user_id":self.user_id,@"status":@"1",@"pindex":index};
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [_bigScrollView.header endRefreshing];
        [_bigScrollView.footer endRefreshing];
        if ([code isEqualToString:@"0"]) {
            
                [_data addObjectsFromArray:models];
            
        }
        [self centerDaiFuKuanOderVi];
        
        if (_data.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
            _la.text=@"暂无订单信息！";
            _la.textAlignment=NSTextAlignmentCenter;

            [self.view addSubview:_la];
        }
        

        
    }];

}
-(void)sc0f:(id)send{
    _index++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    NSDictionary *dic = @{@"user_id":self.user_id,@"status":@"1",@"pindex":index};
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [_bigScrollView.header endRefreshing];
        [_bigScrollView.footer endRefreshing];
         CGPoint point = _bigScrollView.contentOffset;
        if ([code isEqualToString:@"0"]) {
            [_data addObjectsFromArray:models];
        }
        [self centerDaiFuKuanOderVi];
        [_bigScrollView setContentOffset:point animated:NO];
    }];
}

-(void)sc1h:(id)send{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    [_la removeFromSuperview];
    _index1=1;
    [_data1 removeAllObjects];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSString *index = [NSString stringWithFormat:@"%d",1];
    NSDictionary *dic = @{@"user_id":self.user_id,@"status":@"2",@"pindex":index};
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [_bigScrollView1.header endRefreshing];
        [_bigScrollView1.footer endRefreshing];
        if ([code isEqualToString:@"0"]) {
            [_data1 addObjectsFromArray:models];
        }
        [self centerDaiShouHuoOderVi];
        if (_data1.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
            _la.text=@"暂无订单信息！";
            _la.textAlignment=NSTextAlignmentCenter;

            [self.view addSubview:_la];
        }
    }];
}

-(void)sc1f:(id)send{
    _index1++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index1];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dic = @{@"user_id":self.user_id,@"status":@"2",@"pindex":index};
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [_bigScrollView1.header endRefreshing];
        [_bigScrollView1.footer endRefreshing];
        CGPoint point = _bigScrollView1.contentOffset;
        if ([code isEqualToString:@"0"]) {
            [_data1 addObjectsFromArray:models];
        }
        [self centerDaiShouHuoOderVi];
        [_bigScrollView1 setContentOffset:point animated:NO];
    }];
}

-(void)sc2h:(id)send{
    [_la removeFromSuperview];
    _index2=1;
    [_data2 removeAllObjects];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    NSString *index = [NSString stringWithFormat:@"%d",1];
    NSDictionary *dic = @{@"user_id":self.user_id,@"status":@"3",@"pindex":index};
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
       // NSLog(@"sc2h==%@",models);
        [self.activityVC stopAnimate];
        [_bigScrollView2.header endRefreshing];
        [_bigScrollView2.footer endRefreshing];
        if ([code isEqualToString:@"0"]) {
            
            if ([_zhuang isEqualToString:@"3"]) {
                [_data2 addObjectsFromArray:models];
            }
        }
        [self centerDaiFaHuoOderVi];

        if (_data2.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
            _la.text=@"暂无订单信息！";
            _la.textAlignment=NSTextAlignmentCenter;

            [self.view addSubview:_la];
        }
    }];
}

-(void)sc2f:(id)send{
    _index2++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index2];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    NSDictionary *dic = @{@"user_id":self.user_id,@"status":@"3",@"pindex":index};
    
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [_bigScrollView2.header endRefreshing];
        [_bigScrollView2.footer endRefreshing];
        CGPoint point = _bigScrollView2.contentOffset;

        if ([code isEqualToString:@"0"]) {
            [_data2 addObjectsFromArray:models];
   
        }
        [self centerDaiFaHuoOderVi];
        [_bigScrollView2 setContentOffset:point animated:NO];

        
        
    }];
    
}

-(void)sc3h:(id)send{
    [_la removeFromSuperview];
    _index3=1;
    [_data3 removeAllObjects];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSString *index = [NSString stringWithFormat:@"%d",1];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    NSDictionary *dic = @{@"user_id":self.user_id,@"status":@"4",@"pindex":index};
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [_bigScrollView3.header endRefreshing];
        [_bigScrollView3.footer endRefreshing];
        if ([code isEqualToString:@"0"]) {
            
            if ([_zhuang isEqualToString:@"4"]) {
                [_data3 addObjectsFromArray:models];
                
            }
        }
        [self centerDaiPingJiaOderVi];
        if (_data3.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
            _la.text=@"暂无订单信息！";
            _la.textAlignment=NSTextAlignmentCenter;

            [self.view addSubview:_la];
        }
        
    }];

}
-(void)sc3f:(id)send{
    
    _index3++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index3];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    NSDictionary *dic = @{@"user_id":self.user_id,@"status":@"4",@"pindex":index};
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [_bigScrollView3.header endRefreshing];
        [_bigScrollView3.footer endRefreshing];
        CGPoint point = _bigScrollView3.contentOffset;

        if ([code isEqualToString:@"0"]) {
            [_data3 addObjectsFromArray:models];

        }
        [self centerDaiPingJiaOderVi];
        [_bigScrollView3 setContentOffset:point animated:NO];
        
        
    }];
}






#pragma mark -  sssss
-(void)DaiButtonEvent:(UIButton *)button{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    if (_selectedBtn) {
        _selectedBtn.selected=NO;
    }
    _selectedBtn=button;
    button.selected=YES;
    [UIView animateWithDuration:.3 animations:^{
        UIView *line=[self.view viewWithTag:66666666];
        float W=self.view.width/5;
        line.frame=CGRectMake((button.tag-9)*W, _bigBtnVi.height-.5, W, .5);
        
    }];
    switch (button.tag) {
        case 9://全部     5
            for (UIView *vi in [_big subviews]) {
                [vi removeFromSuperview];
            }
            [_big addSubview:_bigScrollView];
            _zhuang=@"5";
            [self sc4h:nil];
            break;
        case 10://待付款  1
            for (UIView *vi in [_big subviews]) {
                [vi removeFromSuperview];
            }
            [_big addSubview:_bigScrollView];
            _zhuang=@"1";
            [self sc0h:nil];
            break;
        case 11://待发货  2
            for (UIView *vi in [_big subviews]) {
                [vi removeFromSuperview];
            }
            [_big addSubview:_bigScrollView1];
            _zhuang=@"2";
            [self sc1h:nil];
            break;
        case 12://待收货  3
            for (UIView *vi in [_big subviews]) {
                [vi removeFromSuperview];
            }
            [_big addSubview:_bigScrollView2];
            _zhuang=@"3";
            [self sc2h:nil];
            break;
        case 13://已完成  4
            for (UIView *vi in [_big subviews]) {
                [vi removeFromSuperview];
            }
            [_big addSubview:_bigScrollView3];
            _zhuang=@"4";//原来是4
            [self sc3h:nil];
            break;

        default:
            break;
    }
}

#pragma mark---所有订单
-(void)centerAllOderVi{
    [self.activityVC stopAnimate];
    if (_big) {
        [_big removeFromSuperview];
    }
    _priceArr = [NSMutableArray new];
    _big = [[UIView alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
    [self.view addSubview:_big];
    
    _bigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _big.width,  _big.height)];
    [_bigScrollView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(sc4f:)];
    [_bigScrollView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(sc4h:)];
    _bigScrollView.backgroundColor=[UIColor clearColor];
    [_big addSubview:_bigScrollView];
    float setY = 10*self.scale;
    float nameCellY=0;
    _biggg  = [NSMutableArray new];
    NSLog(@"centerAllOderVi==%@",_data4);
    for (NSDictionary *dic in _data4) {
        if ([dic[@"order_detail"][0][@"status"] isEqualToString:@"1"]) {
            [_biggg addObject:dic[@"order_detail"]];
        }else{
            for (NSDictionary *orderDic in dic[@"order_detail"]) {
                [_biggg addObject:orderDic];
            }
        }
    }
    for (int i=0; i<_biggg.count; i++) {
        UIView *bigvi = [[UIView alloc]initWithFrame:CGRectMake(0,setY , self.view.width, 0)];
        [_bigScrollView addSubview:bigvi];
        //未付款
        if ([_biggg[i] isKindOfClass:[NSArray class]]) {
            CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
            nameCell.topline.hidden=NO;
            [bigvi addSubview:nameCell];
            UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, nameCell.height/2-10*self.scale, self.view.width, nameCell.height-20*self.scale)];
            nameLa.text =[NSString stringWithFormat:@"订单号：%@",_biggg[i][0][@"order_no"]];
            nameLa.font = DefaultFont(self.scale);
            [nameCell addSubview:nameLa];
            UILabel *states = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameCell.height/2-10*self.scale, 70*self.scale, 20*self.scale)];
            if ([_biggg[i][0][@"status"] isEqualToString:@"1"]) {
                states.text = @"待付款";
            }else if ([_biggg[i][0][@"status"] isEqualToString:@"2"] || [_biggg[i][0][@"status"] isEqualToString:@"3"]){
                states.text = @"待发货";
            }else if ([_biggg[i][0][@"status"] isEqualToString:@"4"]){
                states.text = @"待收货";
            }else if([_biggg[i][0][@"status"] isEqualToString:@"5"]){
                if ([_biggg[i][0][@"is_comment"] isEqualToString:@""] || [_biggg[i][0][@"is_comment"] isEqualToString:@"1"]){
                    states.text = @"待评价";
                }else{
                    states.text = @"已完成";
                }
            }else if([_biggg[i][0][@"status"] isEqualToString:@"-1"]){
                states.text = @"退货中";
            }else{
                states.text = @"已取消";
            }
            states.textAlignment = NSTextAlignmentRight;
            states.textColor = [UIColor redColor];
            states.font = SmallFont(self.scale);
            [nameCell addSubview:states];
            nameCellY=nameCell.bottom;
        }else{
            CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
            nameCell.topline.hidden=NO;
            nameCell.topline.backgroundColor=blackLineColore;
            [bigvi addSubview:nameCell];
            
            UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 30*self.scale, 23*self.scale)];
            [headImg setImageWithURL:[NSURL URLWithString:_biggg[i][@"logo"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
            [nameCell addSubview:headImg];
            nameCell.height=headImg.bottom+10*self.scale;
            
            UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right+5*self.scale, nameCell.height/2-10*self.scale, 30, nameCell.height-20*self.scale)];
            nameLa.text =_biggg[i][@"shop_name"];
            nameLa.font = SmallFont(self.scale);
            [nameCell addSubview:nameLa];
            
            CGSize size = [self sizetoFitWithString:nameLa.text];
            nameLa.width = size.width;
            
            UIButton *teleImg = [[UIButton alloc]initWithFrame:CGRectMake(nameLa.right, nameCell.height/2-10*self.scale, 20*self.scale, 20*self.scale)];
            [teleImg setBackgroundImage:[UIImage imageNamed:@"ganxi_ico_02"] forState:UIControlStateNormal];
            [teleImg addTarget:self action:@selector(talkBtnEvent4:) forControlEvents:UIControlEventTouchUpInside];
            teleImg.tag=i+7000000;
            [nameCell addSubview:teleImg];
            
            UIImageView *jiantouImg = [[UIImageView alloc]initWithFrame:CGRectMake(teleImg.right+10*self.scale, nameCell.height/2-12.5*self.scale, teleImg.width+5*self.scale, teleImg.height+5*self.scale)];
            jiantouImg.image = [UIImage imageNamed:@"xq_right"];
            [nameCell addSubview:jiantouImg];
            
            
            UILabel *states = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameCell.height/2-10*self.scale, 70*self.scale, 20*self.scale)];
            if ([_biggg[i][@"status"] isEqualToString:@"1"]) {
                states.text = @"待付款";
            }else if ([_biggg[i][@"status"] isEqualToString:@"2"] || [_biggg[i][@"status"] isEqualToString:@"3"]){
                states.text = @"待发货";
            }else if ([_biggg[i][@"status"] isEqualToString:@"4"]){
                states.text = @"待收货";
            }else if([_biggg[i][@"status"] isEqualToString:@"5"]){
                if ([_biggg[i][@"is_comment"] isEqualToString:@""] || [_biggg[i][@"is_comment"] isEqualToString:@"1"]){
                    states.text = @"待评价";
                }else{
                    states.text = @"已完成";
                }
            }else if([_biggg[i][@"status"] isEqualToString:@"-1"]){
                states.text = @"退货中";
            }else{
                states.text = @"已取消";
            }
            states.textAlignment = NSTextAlignmentRight;
            states.textColor = [UIColor redColor];
            states.font = SmallFont(self.scale);
            [nameCell addSubview:states];
            
            nameCellY=nameCell.bottom;
        }
        NSMutableArray * dataArr = [NSMutableArray new];
        if ([_biggg[i] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *smDic in _biggg[i]) {
                [dataArr addObjectsFromArray:smDic[@"prods"]];
            }
        }else{
            
            [dataArr addObjectsFromArray:_biggg[i][@"prods"]];
        }
        float line1BotFloat = nameCellY;
        _sum=0;
        _ji=0.0;
        for (int j=0; j<dataArr.count; j++) {
            CellView *contextCell = [[CellView alloc]initWithFrame:CGRectMake(0, line1BotFloat, self.view.width, 175/2.25*self.scale)];
            [bigvi addSubview:contextCell];
            
            UIImageView *cellHeadImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 65*self.scale, 49*self.scale)];
            cellHeadImg.contentMode=UIViewContentModeScaleAspectFill;
            cellHeadImg.clipsToBounds=YES;
            NSString *url=@"";
            NSString *cut = dataArr[j][@"img1"];
            NSString *imagename = [cut lastPathComponent];
            NSString *path = [cut stringByDeletingLastPathComponent];
            NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb320."]];
            
            //            if (cut.length>0) {
            //                url = [cut substringToIndex:[cut length] - 4];
            //
            //            }
            //            [cellHeadImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb640.jpg",url]] placeholderImage:[UIImage imageNamed:@"za"]];
            [cellHeadImg setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
            [contextCell addSubview:cellHeadImg];
            
            
            UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(cellHeadImg.right+10*self.scale, cellHeadImg.top, 200*self.scale, 20*self.scale)];
            nameLa.text = dataArr[j][@"prod_name"];
            nameLa.textAlignment = NSTextAlignmentLeft;
            nameLa.font = DefaultFont(self.scale);
            [contextCell addSubview:nameLa];
            
            
            UILabel *contextLa = [[UILabel alloc]initWithFrame:CGRectMake(nameLa.left, nameLa.bottom+5*self.scale, 170*self.scale, 35*self.scale)];
            contextLa.numberOfLines=0;
            contextLa.text = [NSString stringWithFormat:@"销量%@",dataArr[j][@"sales"]];
            contextLa.textColor = grayTextColor;
            contextLa.font = SmallFont(self.scale);
            //[contextCell addSubview:contextLa];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize size = [contextLa.text boundingRectWithSize:CGSizeMake(contextLa.width, 35*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            contextLa.height = size.height;
            
            
            UILabel *priceLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameLa.bottom-10*self.scale, 70*self.scale, 15*self.scale)];
            priceLa.textColor = grayTextColor;
            priceLa.font = SmallFont(self.scale);
            priceLa.textAlignment = NSTextAlignmentRight;
            priceLa.text = [NSString stringWithFormat:@"￥%@",dataArr[j][@"price"]];
            [contextCell addSubview:priceLa];
            
            UILabel *numberLa = [[UILabel alloc]initWithFrame:CGRectMake(priceLa.left, priceLa.bottom+10*self.scale, priceLa.width, priceLa.height)];
            numberLa.text = [NSString stringWithFormat:@"x%@",dataArr[j][@"prod_count"]];
            numberLa.textAlignment = NSTextAlignmentRight;
            numberLa.textColor = grayTextColor;
            numberLa.font = SmallFont(self.scale);
            [contextCell addSubview:numberLa];
            
            line1BotFloat = contextCell.bottom;
            
            UIButton *oderStatesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            oderStatesBtn.frame = CGRectMake(0, 0, contextCell.width, contextCell.height);
            [oderStatesBtn addTarget:self action:@selector(oderStBtnEvent4:) forControlEvents:UIControlEventTouchUpInside];
            oderStatesBtn.tag=1000000+i;
            [contextCell addSubview:oderStatesBtn];
            id start = _biggg[i];
            int num = [dataArr[j][@"prod_count"] intValue];
            _sum=_sum+num;
            if ([start isKindOfClass:[NSArray class]]) {
                if ([_biggg[i][0][@"status"] isEqualToString:@"1"]) {
                    _ji = [start[0][@"total_amount"] floatValue];
                    
                }else{
                    _ji = [start[0][@"sub_amount"] floatValue];
                }
            }else{
                if ([_biggg[i][@"status"] isEqualToString:@"1"]) {
                    _ji = [start[@"total_amount"] floatValue];
                }else{
                    _ji = [start[@"sub_amount"] floatValue];// + [start[@"delivery_fee"] floatValue] ;
                }
            }
        }
        [_priceArr addObject:[NSString stringWithFormat:@"%.2f",_ji]];
        id start = _biggg[i];
        NSString *starts = [[NSString alloc]init];
        if ([start isKindOfClass:[NSArray class]]) {
            starts = start[0][@"status"];
        }else{
            starts = start[@"status"];
        }
        if ([starts isEqualToString:@"1"]) {
            CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
            [bigvi addSubview:zongJiCell];
            UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, self.view.width-130*self.scale, 20*self.scale)];
            shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];
            shopNumberLa.font = DefaultFont(self.scale);
            [zongJiCell addSubview:shopNumberLa];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize size1 = [shopNumberLa.text boundingRectWithSize:CGSizeMake(shopNumberLa.width, 20*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            shopNumberLa.width = size1.width;
            UIButton *fuKuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            fuKuanBtn.frame = CGRectMake(self.view.width-120*self.scale, zongJiCell.height/2-12.5*self.scale, 50*self.scale, 25*self.scale);
            fuKuanBtn.layer.borderWidth = .5;
            fuKuanBtn.layer.borderColor = blackLineColore.CGColor;
            [fuKuanBtn setTitle:@"付款" forState:UIControlStateNormal];
            [fuKuanBtn addTarget:self action:@selector(fuAndQUxiAO4:) forControlEvents:UIControlEventTouchUpInside];
            fuKuanBtn.titleLabel.font = SmallFont(self.scale);
            [fuKuanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            fuKuanBtn.layer.cornerRadius = 4.0f;
            fuKuanBtn.tag=600+i;
            [zongJiCell addSubview:fuKuanBtn];
            UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            quiXaioBtn.frame = CGRectMake(self.view.width-60*self.scale, zongJiCell.height/2-12.5*self.scale, 50*self.scale, 25*self.scale);
            quiXaioBtn.layer.borderWidth = .5;
            quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
            [quiXaioBtn setTitle:@"取消" forState:UIControlStateNormal];
            [quiXaioBtn addTarget:self action:@selector(fuAndQUxiAO4:) forControlEvents:UIControlEventTouchUpInside];
            quiXaioBtn.titleLabel.font = SmallFont(self.scale);
            [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            quiXaioBtn.backgroundColor = blackLineColore;
            quiXaioBtn.layer.cornerRadius = 4.0f;
            quiXaioBtn.tag=200+i;
            [zongJiCell addSubview:quiXaioBtn];
            zongJiCell.height=quiXaioBtn.bottom+10*self.scale;
            bigvi.size = CGSizeMake(self.view.width, zongJiCell.bottom);
            setY = bigvi.bottom +10*self.scale;
            _bigScrollView.contentSize = CGSizeMake(self.view.width,setY);
        }else if ([starts isEqualToString:@"2"] || [starts isEqualToString:@"3"]){
            CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
            [bigvi addSubview:zongJiCell];
            UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, self.view.width-70*self.scale, 20*self.scale)];
            shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];
            shopNumberLa.font = DefaultFont(self.scale);
            shopNumberLa.textAlignment = NSTextAlignmentLeft;
            [zongJiCell addSubview:shopNumberLa];
            //if ([_biggg[i][@"pay_type"]isEqualToString:@"3"]) {
            UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            quiXaioBtn.frame = CGRectMake(self.view.width-70*self.scale, zongJiCell.height/2-12.5*self.scale, 60*self.scale, 25*self.scale);
            quiXaioBtn.layer.borderWidth = .5;
            quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
            [quiXaioBtn setTitle:@"取消" forState:UIControlStateNormal];
            [quiXaioBtn addTarget:self action:@selector(huodaoQuXiao4:) forControlEvents:UIControlEventTouchUpInside];
            quiXaioBtn.titleLabel.font = SmallFont(self.scale);
            [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            quiXaioBtn.backgroundColor = blackLineColore;
            quiXaioBtn.layer.cornerRadius = 4.0f;
            quiXaioBtn.tag=6000+i;
            [zongJiCell addSubview:quiXaioBtn];
            //}
            bigvi.size = CGSizeMake(self.view.width, zongJiCell.bottom);
            setY = bigvi.bottom +10*self.scale;
            _bigScrollView.contentSize = CGSizeMake(self.view.width,setY);
            
        }else if ([starts isEqualToString:@"4"]){
            
            CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
            [bigvi addSubview:zongJiCell];
            
            UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, self.view.width-150*self.scale, 20*self.scale)];
            shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];
            shopNumberLa.font = DefaultFont(self.scale);
            [zongJiCell addSubview:shopNumberLa];
            //-
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0f], NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize size1 = [shopNumberLa.text boundingRectWithSize:CGSizeMake(300, 20*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            shopNumberLa.width = size1.width;
            UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            quiXaioBtn.frame = CGRectMake(self.view.width-70*self.scale, zongJiCell.height/2-12.5*self.scale, 60*self.scale, 25*self.scale);
            quiXaioBtn.layer.borderWidth = .5;
            quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
            [quiXaioBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [quiXaioBtn addTarget:self action:@selector(querenshouhuo4:) forControlEvents:UIControlEventTouchUpInside];
            quiXaioBtn.titleLabel.font = SmallFont(self.scale);
            [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            quiXaioBtn.backgroundColor = blackLineColore;
            quiXaioBtn.layer.cornerRadius = 4.0f;
            quiXaioBtn.tag=200000+i;
            [zongJiCell addSubview:quiXaioBtn];
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.frame = CGRectMake(self.view.width-140*self.scale, zongJiCell.height/2-12.5*self.scale, 60*self.scale, 25*self.scale);
            cancelBtn.layer.borderWidth = .5;
            cancelBtn.layer.borderColor = blackLineColore.CGColor;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(cancelByShipped4:) forControlEvents:UIControlEventTouchUpInside];
            cancelBtn.tag=400000+i;
            cancelBtn.titleLabel.font = SmallFont(self.scale);
            [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //cancelBtn.backgroundColor = blackLineColore;
            cancelBtn.layer.cornerRadius = 4.0f;
            [zongJiCell addSubview:cancelBtn];
            bigvi.size = CGSizeMake(self.view.width, zongJiCell.bottom);
            setY = bigvi.bottom +10*self.scale;
            _bigScrollView.contentSize = CGSizeMake(self.view.width,setY);
        }else if([starts isEqualToString:@"5"]){
            CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
            [bigvi addSubview:zongJiCell];
            UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, self.view.width-130*self.scale, 20*self.scale)];
            shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];
            shopNumberLa.font = DefaultFont(self.scale);
            [zongJiCell addSubview:shopNumberLa];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0f], NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize size1 = [shopNumberLa.text boundingRectWithSize:CGSizeMake(300, 20*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            shopNumberLa.width = size1.width;
            //       float setYY =self.view.width-70*self.scale;
            if ([_biggg[i][@"is_comment"] isEqualToString:@""] || [_biggg[i][@"is_comment"] isEqualToString:@"1"]) {
                UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                quiXaioBtn.frame = CGRectMake(self.view.width-120*self.scale, zongJiCell.height/2-12.5*self.scale, 50*self.scale, 25*self.scale);
                quiXaioBtn.layer.borderWidth = .5;
                quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
                [quiXaioBtn setTitle:@"去评价" forState:UIControlStateNormal];
                [quiXaioBtn addTarget:self action:@selector(daipingjiaEvent4:) forControlEvents:UIControlEventTouchUpInside];
                quiXaioBtn.titleLabel.font = SmallFont(self.scale);
                [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                quiXaioBtn.layer.cornerRadius = 4.0f;
                quiXaioBtn.tag=60000+i;
                [zongJiCell addSubview:quiXaioBtn];
            }
            UIButton *shanchu = [UIButton buttonWithType:UIButtonTypeCustom];
            shanchu.frame = CGRectMake(self.view.width-60*self.scale, zongJiCell.height/2-12.5*self.scale, 50*self.scale, 25*self.scale);
            shanchu.layer.borderWidth = .5;
            shanchu.layer.borderColor = blackLineColore.CGColor;
            [shanchu setTitle:@"删除" forState:UIControlStateNormal];
            [shanchu addTarget:self action:@selector(daipingjiaEvent4:) forControlEvents:UIControlEventTouchUpInside];
            shanchu.titleLabel.font = SmallFont(self.scale);
            [shanchu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            shanchu.backgroundColor = blackLineColore;
            shanchu.layer.cornerRadius = 4.0f;
            shanchu.tag=70000+i;
            [zongJiCell addSubview:shanchu];
            bigvi.size = CGSizeMake(self.view.width, zongJiCell.bottom);
            setY = bigvi.bottom +10*self.scale;
            _bigScrollView.contentSize = CGSizeMake(self.view.width,setY);
        }else{
            CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
            [bigvi addSubview:zongJiCell];
            UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, self.view.width-20*self.scale, 20*self.scale)];
            //shopNumberLa.backgroundColor=[UIColor yellowColor];
            shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];
            shopNumberLa.font = DefaultFont(self.scale);
            [zongJiCell addSubview:shopNumberLa];
            //-
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0f], NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize size1 = [shopNumberLa.text boundingRectWithSize:CGSizeMake(self.view.width-20*self.scale, 20*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            //shopNumberLa.width = size1.width;
            bigvi.size = CGSizeMake(self.view.width, zongJiCell.bottom);
            setY = bigvi.bottom +10*self.scale;
            _bigScrollView.contentSize = CGSizeMake(self.view.width,setY);
        }
    }
}

#pragma mark---待付款
-(void)centerDaiFuKuanOderVi{
    [self.activityVC stopAnimate];
    if (_big) {
        [_big removeFromSuperview];
    }
    _big = [[UIView alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
    [self.view addSubview:_big];
    _bigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _big.width, _big.height)];
    [_bigScrollView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(sc0f:)];
    [_bigScrollView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(sc0h:)];
    _bigScrollView.backgroundColor=[UIColor clearColor];
    [_big addSubview:_bigScrollView];
    float setY = 10*self.scale;
    for (int i=0; i<_data.count; i++) {
        UIView *bigvi = [[UIView alloc]initWithFrame:CGRectMake(0,setY, self.view.width, 0)];
        [_bigScrollView addSubview:bigvi];
        //------
        CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
        nameCell.topline.hidden=NO;
        [bigvi addSubview:nameCell];
        UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, nameCell.height/2-10*self.scale, 0, nameCell.height-20*self.scale)];
        nameLa.text =[NSString stringWithFormat:@"订单号：%@",_data[i][@"order_no"]];
        nameLa.font = DefaultFont(self.scale);
        [nameCell addSubview:nameLa];
        CGSize size = [self sizetoFitWithString:nameLa.text];
        nameLa.width = size.width;
        UILabel *states = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameCell.height/2-10*self.scale, 70*self.scale, 20*self.scale)];
        states.text = @"待付款";
        states.textAlignment = NSTextAlignmentRight;
        states.textColor = [UIColor redColor];
        states.font = SmallFont(self.scale);
        [nameCell addSubview:states];
        float line1BotFloat = nameCell.bottom;
        NSMutableArray * mutabArr = [NSMutableArray new];;
        for (NSDictionary *dic in _data[i][@"order_detail"]) {
            for (NSDictionary *prodic in dic[@"prods"]) {
                [mutabArr addObject:prodic];
            }
        }
        _sum=0;
        _ji=0.0;
        for (int j=0; j<mutabArr.count; j++) {
            NSLog(@"mutabArrmutabArrmutabArr:%@",mutabArr[j]);
            CellView *contextCell = [[CellView alloc]initWithFrame:CGRectMake(0, line1BotFloat, self.view.width, 175/2.25*self.scale)];
            [bigvi addSubview:contextCell];
            UIImageView *cellHeadImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 65*self.scale, 49*self.scale)];
            [cellHeadImg setImageWithURL:[NSURL URLWithString:mutabArr[j][@"img1"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
            [contextCell addSubview:cellHeadImg];
            UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(cellHeadImg.right+10*self.scale, cellHeadImg.top, 200*self.scale, 20*self.scale)];
            nameLa.text = mutabArr[j][@"prod_name"];
            nameLa.textAlignment = NSTextAlignmentLeft;
            nameLa.font = DefaultFont(self.scale);
            [contextCell addSubview:nameLa];
            UILabel *contextLa = [[UILabel alloc]initWithFrame:CGRectMake(nameLa.left, nameLa.bottom+5*self.scale, 170*self.scale, 35*self.scale)];
            contextLa.numberOfLines=0;
//            if (mutabArr[j][@"sales"]!=nil || [mutabArr[j][@"sales"] isEqualToString:@""]) {
//                contextLa.text = [NSString stringWithFormat:@"销量%@",mutabArr[j][@"sales"]];
//
//            }else{
//                contextLa.text = [NSString stringWithFormat:@"销量:%@",@"0"];
//
//            }
            contextLa.textColor = grayTextColor;
            contextLa.font = SmallFont(self.scale);
            [contextCell addSubview:contextLa];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize size = [contextLa.text boundingRectWithSize:CGSizeMake(contextLa.width, 35*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            contextLa.height = size.height;

            UILabel *priceLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameLa.bottom-10*self.scale, 70*self.scale, 15*self.scale)];
            priceLa.textColor = grayTextColor;
            priceLa.font = SmallFont(self.scale);
            priceLa.textAlignment = NSTextAlignmentRight;
            priceLa.text = [NSString stringWithFormat:@"￥%@",mutabArr[j][@"price"]];
            [contextCell addSubview:priceLa];
            UILabel *numberLa = [[UILabel alloc]initWithFrame:CGRectMake(priceLa.left, priceLa.bottom+10*self.scale, priceLa.width, priceLa.height)];
            numberLa.text = [NSString stringWithFormat:@"x%@",mutabArr[j][@"prod_count"]];
            numberLa.textAlignment = NSTextAlignmentRight;
            numberLa.textColor = grayTextColor;
            numberLa.font = SmallFont(self.scale);
            [contextCell addSubview:numberLa];
            
            line1BotFloat = contextCell.bottom;
            
            UIButton *oderStatesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            oderStatesBtn.frame = CGRectMake(0, 0, contextCell.width, contextCell.height);
            oderStatesBtn.tag=i+1000;
            [oderStatesBtn addTarget:self action:@selector(oderStBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            [contextCell addSubview:oderStatesBtn];

            NSLog(@"%@",_data);
            
            int num = [mutabArr[j][@"prod_count"] intValue];
            _sum=_sum+num;
            
            
            NSLog(@"%@",_data);
            _ji = [_data[i][@"order_detail"][0][@"total_amount"] floatValue];
            
        }

        CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
        [bigvi addSubview:zongJiCell];
        
        UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, 0, 20*self.scale)];
        
        shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];

        shopNumberLa.font = DefaultFont(self.scale);
        [zongJiCell addSubview:shopNumberLa];
        //-
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        CGSize size1 = [shopNumberLa.text boundingRectWithSize:CGSizeMake(shopNumberLa.width, 20*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        shopNumberLa.width = size1.width;

        UIButton *fuKuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fuKuanBtn.frame = CGRectMake(self.view.width-120*self.scale, zongJiCell.height/2-12.5*self.scale, 50*self.scale, 25*self.scale);
        fuKuanBtn.layer.borderWidth = .5;
        fuKuanBtn.layer.borderColor = blackLineColore.CGColor;
        [fuKuanBtn setTitle:@"付款" forState:UIControlStateNormal];
        [fuKuanBtn addTarget:self action:@selector(fuAndQUxiAO:) forControlEvents:UIControlEventTouchUpInside];
        fuKuanBtn.titleLabel.font = SmallFont(self.scale);
        [fuKuanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        fuKuanBtn.layer.cornerRadius = 4.0f;
        fuKuanBtn.tag=500+i;
        [zongJiCell addSubview:fuKuanBtn];
        
        UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quiXaioBtn.frame = CGRectMake(self.view.width-60*self.scale, zongJiCell.height/2-12.5*self.scale, 50*self.scale, 25*self.scale);
        quiXaioBtn.layer.borderWidth = .5;
        quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
        [quiXaioBtn setTitle:@"取消" forState:UIControlStateNormal];
        [quiXaioBtn addTarget:self action:@selector(fuAndQUxiAO:) forControlEvents:UIControlEventTouchUpInside];
        quiXaioBtn.titleLabel.font = SmallFont(self.scale);
        [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        quiXaioBtn.backgroundColor = blackLineColore;
        quiXaioBtn.layer.cornerRadius = 4.0f;
        quiXaioBtn.tag=100+i;
        [zongJiCell addSubview:quiXaioBtn];
        bigvi.size = CGSizeMake(self.view.width, zongJiCell.bottom);
        setY = bigvi.bottom +10*self.scale;
        _bigScrollView.contentSize = CGSizeMake(self.view.width,setY);
    }
}

-(void)wexin:(UIButton *)sender{
   // NSLog(@"wexin==%@",_data[sender.tag-500]);
    [self.appdelegate WXPayNewWithNonceStr:_data[sender.tag-500][@"noncestr"] OrderID:_data[sender.tag-500][@"order_no"] Timestamp:_data[sender.tag-500][@"timestamp"] sign:_data[sender.tag-500][@"sign"] complete:^(BaseResp *resp) {
                            [self.activityVC stopAnimate];
                            if (resp.errCode == WXSuccess) {
                               // [self suessToVi];
                            }
                        }];
}

-(void)fuAndQUxiAO4:(UIButton *)sender{
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    if ([sender.titleLabel.text isEqualToString:@"付款"]) {
        //NSLog(@"-data_pay==%@==%@",_data[sender.tag-500][@"order_detail"][0][@"order_no"],_data[sender.tag-500]);
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        //付款
        if ([_data4[sender.tag-600][@"order_detail"][0][@"pay_type"] isEqualToString:@"2"]) {//微信支付
            AnalyzeObject *anle = [AnalyzeObject new];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:_data4[sender.tag-600][@"order_detail"][0][@"order_no"] forKey:@"orderid"];
            [param setObject: self.user_id forKey:@"user_id"];
            [anle resubmitOrder:[param copy] Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                //NSLog(@"resubmitOrder==%@",models);
                [self.appdelegate WXPayNewWithNonceStr:models[@"noncestr"] OrderID:models[@"order_no"] Timestamp:models[@"timestamp"] sign:models[@"sign"] complete:^(BaseResp *resp) {
                    [self.activityVC stopAnimate];
                    if (resp.errCode == WXSuccess) {
                        [self sc4h:nil];
                        //[self sc0h:nil];
                    }
                }];
            }];
        }else if ([_data4[sender.tag-600][@"order_detail"][0][@"pay_type"] isEqualToString:@"1"]){
            AnalyzeObject *anle = [AnalyzeObject new];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:_data4[sender.tag-600][@"order_detail"][0][@"order_no"] forKey:@"orderid"];
            [param setObject: self.user_id forKey:@"user_id"];
            [anle resubmitOrder:[param copy] Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                [self.appdelegate AliPayNewPrice:models[@"amount"] OrderID:[NSString stringWithFormat:@"%@",models[@"order_no"]] OrderName:@"拇指社区" Sign:models[@"sign"]  OrderDescription:[NSString stringWithFormat:@"%@",models[@"order_no"]] complete:^(NSDictionary *resp) {
                    [self.activityVC stopAnimate];
                    if ([[resp objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                        [self sc4h:nil];
                        //[self sc0h:nil];
                    }
                }];
            }];
        }
    }else{
        //取消
        [self ShowAlertTitle:nil Message:@"确认取消?" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                [self.view addSubview:self.activityVC];
                [self.activityVC startAnimate];
                NSLog(@"1111==%@",_zhuang);
                NSDictionary *dic = @{@"user_id":self.user_id,@"order_no":_biggg[sender.tag-200][0][@"order_no"]};
                AnalyzeObject *anle = [AnalyzeObject new];
                [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                    if ([code isEqualToString:@"0"]) {
                        if(![AppUtil isBlank:msg])
                          [self ShowAlertWithMessage:msg];
                        //[self.activityVC startAnimate];
                        [self sc4h:nil];
//                        AnalyzeObject *anle = [AnalyzeObject new];
//                        NSDictionary *dic = @{@"user_id":self.user_id,@"status":_zhuang,@"pindex":@"1"};
//                        [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
//                            [self.activityVC stopAnimate];
//                            [self sc4h:nil];
//                        }];
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

-(void)fuAndQUxiAO:(UIButton *)sender{
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    if ([sender.titleLabel.text isEqualToString:@"付款"]) {
        //NSLog(@"-data_pay==%@==%@",_data[sender.tag-500][@"order_detail"][0][@"order_no"],_data[sender.tag-500]);
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        //付款
        if ([_data[sender.tag-500][@"order_detail"][0][@"pay_type"] isEqualToString:@"2"]) {//微信支付
           AnalyzeObject *anle = [AnalyzeObject new];
           NSMutableDictionary *param = [NSMutableDictionary dictionary];
          [param setObject:_data[sender.tag-500][@"order_detail"][0][@"order_no"] forKey:@"orderid"];
          [param setObject: self.user_id forKey:@"user_id"];
          [anle resubmitOrder:[param copy] Block:^(id models, NSString *code, NSString *msg) {
               [self.activityVC stopAnimate];
                //NSLog(@"resubmitOrder==%@",models);
              [self.appdelegate WXPayNewWithNonceStr:models[@"noncestr"] OrderID:models[@"order_no"] Timestamp:models[@"timestamp"] sign:models[@"sign"] complete:^(BaseResp *resp) {
                  [self.activityVC stopAnimate];
                  if (resp.errCode == WXSuccess) {
                      [self sc0h:nil];
                      //[self sc4h:nil];
                  }
              }];
            }];
        }else if ([_data[sender.tag-500][@"order_detail"][0][@"pay_type"] isEqualToString:@"1"]){
            AnalyzeObject *anle = [AnalyzeObject new];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:_data[sender.tag-500][@"order_detail"][0][@"order_no"] forKey:@"orderid"];
            [param setObject: self.user_id forKey:@"user_id"];
            [anle resubmitOrder:[param copy] Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
              //  NSLog(@"resubmitOrder==%@",models);
//                [self.appdelegate WXPayNewWithNonceStr:models[@"noncestr"] OrderID:models[@"order_no"] Timestamp:models[@"timestamp"] sign:models[@"sign"]];
                [self.appdelegate AliPayNewPrice:models[@"amount"] OrderID:[NSString stringWithFormat:@"%@",models[@"order_no"]] OrderName:@"拇指社区" Sign:models[@"sign"]  OrderDescription:[NSString stringWithFormat:@"%@",models[@"order_no"]] complete:^(NSDictionary *resp) {
                    [self.activityVC stopAnimate];
                    if ([[resp objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                        [self sc0h:nil];
                       // [self sc4h:nil];
                    }
                }];
            }];
        }
    }else{
    //取消
        [self ShowAlertTitle:nil Message:@"确认删除?" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                [self.view addSubview:self.activityVC];
                [self.activityVC startAnimate];
                NSDictionary *dic = @{@"user_id":self.user_id,@"order_no":_data[sender.tag-100][@"order_detail"][0][@"order_no"]};
                AnalyzeObject *anle = [AnalyzeObject new];
                [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                    if ([code isEqualToString:@"0"]) {
                        if(![AppUtil isBlank:msg])
                            [self ShowAlertWithMessage:msg];
                        [self sc0h:nil];
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


-(void)zhifubao:(UIButton *)sender{

    [self.appdelegate AliPayPrice:[NSString stringWithFormat:@"%@",_data[sender.tag-500][@"order_detail"][0][@"total_amount"]] OrderID:_data[sender.tag-500][@"order_no"] OrderName:@"拇指社区" OrderDescription:_data[sender.tag-500][@"order_no"] complete:^(NSDictionary *resp) {
        if ([[resp objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            AnalyzeObject *anle = [AnalyzeObject new];
            NSDictionary *dic = @{@"user_id":self.user_id,@"status":_zhuang,@"pindex":@"1"};
            [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                self.hidesBottomBarWhenPushed=YES;
                orderSuessViewController *file = [orderSuessViewController new];
                file.price=[NSString stringWithFormat:@"%@",_data[sender.tag-500][@"order_detail"][0][@"total_amount"]];
                [self.navigationController pushViewController:file animated:YES];
                
                [self.activityVC stopAnimate];
                [_data removeAllObjects];
                [_data addObjectsFromArray:models];
                if (![code isEqualToString:@"0"]) {
                    
                    [_data removeAllObjects];
                    
                }
                [self centerDaiFuKuanOderVi];
                
            }];
        }else{
            //                    [self ShowAlertWithMessage:@"支付失败！"];
            self.hidesBottomBarWhenPushed=YES;
            OrderFileViewController *file = [OrderFileViewController new];
            [self.navigationController pushViewController:file animated:YES];
            
        }
    }];

}


-(void)wexin:(UIButton *)sender price:(float)pric{

    [self.appdelegate WXPayPrice:[NSString stringWithFormat:@"%.0f",pric] OrderID:_data[sender.tag-500][@"order_no"] OrderName:_data[sender.tag-500][@"order_no"] complete:^(BaseResp *resp) {
        
        if (resp.errCode == WXSuccess) {
            AnalyzeObject *anle = [AnalyzeObject new];
            NSDictionary *dic = @{@"user_id":self.user_id,@"status":_zhuang,@"pindex":@"1"};
            [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                [_data removeAllObjects];
                [_data addObjectsFromArray:models];
                if (![code isEqualToString:@"0"]) {
                    [_data removeAllObjects];
                }
                [self centerDaiFuKuanOderVi];
                self.hidesBottomBarWhenPushed=YES;
                orderSuessViewController *file = [orderSuessViewController new];
                file.price=[NSString stringWithFormat:@"%.2f",pric/100];
                [self.navigationController pushViewController:file animated:YES];
            }];
        }else{
            self.hidesBottomBarWhenPushed=YES;
            OrderFileViewController *file = [OrderFileViewController new];
            [self.navigationController pushViewController:file animated:YES];
        }
    }];
}

-(void)oderStBtnEvent4:(UIButton *)btn{
    self.hidesBottomBarWhenPushed=YES;
    
    
    //  NSString *str = biggg[btn.tag-1000000][@"status"];
    
    
    id start = _biggg[btn.tag-1000000];
    NSString *starts = [[NSString alloc]init];
    
    if ([start isKindOfClass:[NSArray class]]) {
        starts = start[0][@"status"];
        
    }else{
        starts = start[@"status"];
    }
    
    
    if (![starts isEqualToString:@"1"]) {
        OderStatesViewController *oder = [OderStatesViewController new];
        
        
        oder.price = _priceArr[btn.tag-1000000];
        oder.orderid =_biggg[btn.tag-1000000][@"order_no"];
        oder.smallOder =_biggg[btn.tag-1000000][@"prods"][0][@"sub_order_no"];
        [self.navigationController pushViewController:oder animated:YES];
    }else{
        weifukuanViewController *weifu = [weifukuanViewController new];
        weifu.order_id=_biggg[btn.tag-1000000][0][@"order_no"];
        [self.navigationController pushViewController:weifu animated:YES];
    }  
}


#pragma mark---跳转到订单状态和订单详情的页面
-(void)oderStBtnEvent:(UIButton *)sender{
    
    self.hidesBottomBarWhenPushed=YES;
   
        weifukuanViewController *wei = [weifukuanViewController new];
        wei.order_id =_data[sender.tag-1000][@"order_detail"][0][@"order_no"];
        [self.navigationController pushViewController:wei animated:YES];

}


-(void)oderStBtnEvent1:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    
    self.hidesBottomBarWhenPushed=YES;
 
    OderStatesViewController *oderVC = [OderStatesViewController new];
    oderVC.price=_priceArr[sender.tag-2000];
        oderVC.orderid =_bigArr[sender.tag-2000][@"order_no"];
     oderVC.smallOder =_bigArr[sender.tag-2000][@"sub_order_no"];
        [self.navigationController pushViewController:oderVC animated:YES];

}

-(void)oderStBtnEvent2:(UIButton *)sender{
    
    
    self.hidesBottomBarWhenPushed=YES;
    
        OderStatesViewController *oderVC = [OderStatesViewController new];
    oderVC.price=_priceArr1[sender.tag-3000];

        oderVC.orderid =_data2[sender.tag-3000][@"order_detail"][0][@"order_no"];
     oderVC.smallOder =_data2[sender.tag-3000][@"order_detail"][0][@"sub_order_no"];
        [self.navigationController pushViewController:oderVC animated:YES];
 
}

-(void)oderStBtnEvent3:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
        OderStatesViewController *oderVC = [OderStatesViewController new];
    oderVC.price=_priceArr2[sender.tag-4000];
        oderVC.orderid =_data3[sender.tag-4000][@"order_detail"][0][@"order_no"];
    oderVC.smallOder =_data3[sender.tag-4000][@"order_detail"][0][@"sub_order_no"];
        [self.navigationController pushViewController:oderVC animated:YES];
}

#pragma mark -----返回按钮,导航栏
-(void)returnVi{
    self.TitleLabel.text=@"我的订单";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"已取消" forState:UIControlStateNormal];//
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = BigFont(self.scale);
//    [rightBtn setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [rightBtn setTitleColor:grayTextColor forState:(UIControlStateNormal)];
    rightBtn.frame = CGRectMake(self.view.right-80*self.scale,self.TitleLabel.top,80*self.scale,self.TitleLabel.height);
    [rightBtn addTarget:self action:@selector(cannelOder:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:rightBtn];
}

-(void)cannelOder:(UIButton *)sender
{
    self.hidesBottomBarWhenPushed=YES;
    CannelViewController *all = [CannelViewController new];
    [self.navigationController pushViewController:all animated:YES];
}

-(void)allOder:(UIButton *)sender
{
    self.hidesBottomBarWhenPushed=YES;
    AllorderShopViewController *all = [AllorderShopViewController new];
    [self.navigationController pushViewController:all animated:YES];
}


#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    if (_ispop) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark-----待收货的 订单view
-(void)centerDaiShouHuoOderVi{
    if (_big) {
        [_big removeFromSuperview];
    }
    _priceArr = [NSMutableArray new];
    _big = [[UIView alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
    [self.view addSubview:_big];
    _bigScrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _big.width, _big.height)];
    [_bigScrollView1 addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(sc1f:)];
    [_bigScrollView1 addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(sc1h:)];
    _bigScrollView1.backgroundColor=[UIColor clearColor];
    [_big addSubview:_bigScrollView1];
    _bigArr = [NSMutableArray new];
    for (NSDictionary *dic in _data1) {
        for (NSDictionary *orderDic in dic[@"order_detail"]) {
            [_bigArr addObject:orderDic];
        }
    }
    float setY = 10*self.scale;
    for (int i=0; i<_bigArr.count; i++) {
        UIView *bigvi1 = [[UIView alloc]initWithFrame:CGRectMake(0,setY, self.view.width, 0)];
        bigvi1.backgroundColor = [UIColor yellowColor];
        [_bigScrollView1 addSubview:bigvi1];
        CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
        nameCell.topline.backgroundColor=blackLineColore;
        nameCell.topline.hidden=NO;
        [bigvi1 addSubview:nameCell];
        UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 30*self.scale, 23*self.scale)];
        [headImg setImageWithURL:[NSURL URLWithString:_bigArr[i][@"logo"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
        [nameCell addSubview:headImg];
        nameCell.height=headImg.bottom+10*self.scale;
        UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right+5*self.scale, nameCell.height/2-10*self.scale, 0, nameCell.height-20*self.scale)];
        nameLa.text = _bigArr[i][@"shop_name"];
        nameLa.font = SmallFont(self.scale);
        [nameCell addSubview:nameLa];
        CGSize size = [self sizetoFitWithString:nameLa.text];
        nameLa.width = size.width+5*self.scale;
//        UIButton *talkImg = [[UIButton alloc]initWithFrame:CGRectMake(nameLa.right, nameLa.top+3*self.scale, 20*self.scale, 20*self.scale)];
//        [talkImg setBackgroundImage:[UIImage imageNamed:@"ganxi_ico_01"] forState:UIControlStateNormal];
//        [talkImg addTarget:self action:@selector(talkBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
//        talkImg.tag=i+1000000;
//        [talkImg setTitle:@"talk" forState:UIControlStateNormal];
//        [talkImg setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//        [nameCell addSubview:talkImg];
        UIButton *teleImg = [[UIButton alloc]initWithFrame:CGRectMake(nameLa.right, nameLa.top+3*self.scale, 20*self.scale, 20*self.scale)];
        [teleImg setBackgroundImage:[UIImage imageNamed:@"ganxi_ico_02"] forState:UIControlStateNormal];
        [teleImg addTarget:self action:@selector(talkBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        teleImg.tag=i+2000000;
        [teleImg setTitle:@"tel" forState:UIControlStateNormal];
        [teleImg setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [nameCell addSubview:teleImg];
        UIImageView *jiantouImg = [[UIImageView alloc]initWithFrame:CGRectMake(teleImg.right+10*self.scale, nameLa.top+0*self.scale, teleImg.width+5*self.scale, teleImg.height+5*self.scale)];
        jiantouImg.image = [UIImage imageNamed:@"xq_right"];
        [nameCell addSubview:jiantouImg];
        UILabel *states = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameCell.height/2-10*self.scale, 70*self.scale, 20*self.scale)];
        states.text = @"待发货";
        states.textAlignment = NSTextAlignmentRight;
        states.textColor = [UIColor redColor];
        states.font = SmallFont(self.scale);
        [nameCell addSubview:states];
        float line1BotFloat = nameCell.bottom;
        _sum=0;
        _ji=0.0;
        for (int j=0; j<[_bigArr[i][@"prods"] count]; j++) {
            CellView *contextCell = [[CellView alloc]initWithFrame:CGRectMake(0, line1BotFloat, self.view.width, 175/2.25*self.scale)];
            [bigvi1 addSubview:contextCell];
            
            UIImageView *cellHeadImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 65*self.scale, 49*self.scale)];
            cellHeadImg.contentMode=UIViewContentModeScaleAspectFill;
            cellHeadImg.clipsToBounds=YES;
            NSString *url=@"";
            NSString *cut = _bigArr[i][@"prods"][j][@"img1"];
            NSString *imagename = [cut lastPathComponent];
            NSString *path = [cut stringByDeletingLastPathComponent];
            NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb640."]];
//            if (cut.length>0) {
//                url = [cut substringToIndex:[cut length] - 4];
//            }
//            [cellHeadImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb640.jpg",url]] placeholderImage:[UIImage imageNamed:@"za"]];
            [cellHeadImg setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
            [contextCell addSubview:cellHeadImg];
            UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(cellHeadImg.right+10*self.scale, cellHeadImg.top, 200*self.scale, 20*self.scale)];
            nameLa.text = _bigArr[i][@"prods"][j][@"prod_name"];
            nameLa.textAlignment = NSTextAlignmentLeft;
            nameLa.font = DefaultFont(self.scale);
            [contextCell addSubview:nameLa];
            UILabel *contextLa = [[UILabel alloc]initWithFrame:CGRectMake(nameLa.left, nameLa.bottom+5*self.scale, 170*self.scale, 35*self.scale)];
            contextLa.numberOfLines=0;
//            if (_bigArr[i][@"prods"][j][@"sales"]!=nil || [_bigArr[i][@"prods"][j][@"sales"] isEqualToString:@""]) {
//                contextLa.text = [NSString stringWithFormat:@"销量%@",_bigArr[i][@"prods"][j][@"sales"]];
//            }else{
//                contextLa.text = [NSString stringWithFormat:@"销量%@",@"0"];
//            }
            contextLa.textColor = grayTextColor;
            contextLa.font = SmallFont(self.scale);
            [contextCell addSubview:contextLa];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize size = [contextLa.text boundingRectWithSize:CGSizeMake(contextLa.width, 35*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            contextLa.height = size.height;
            UILabel *priceLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameLa.bottom-10*self.scale, 70*self.scale, 15*self.scale)];
            priceLa.textColor = grayTextColor;
            priceLa.font = SmallFont(self.scale);
            priceLa.textAlignment = NSTextAlignmentRight;
            priceLa.text = [NSString stringWithFormat:@"￥%@",_bigArr[i][@"prods"][j][@"price"]];
            [contextCell addSubview:priceLa];
            UILabel *numberLa = [[UILabel alloc]initWithFrame:CGRectMake(priceLa.left, priceLa.bottom+10*self.scale, priceLa.width, priceLa.height)];
            numberLa.text = [NSString stringWithFormat:@"x%@",_bigArr[i][@"prods"][j][@"prod_count"]];
            numberLa.textAlignment = NSTextAlignmentRight;
            numberLa.textColor = grayTextColor;
            numberLa.font = SmallFont(self.scale);
            [contextCell addSubview:numberLa];
            line1BotFloat = contextCell.bottom;
            UIButton *oderStatesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            oderStatesBtn.frame = CGRectMake(0, 0, contextCell.width, contextCell.height);
            oderStatesBtn.tag=i+2000;
            [oderStatesBtn addTarget:self action:@selector(oderStBtnEvent1:) forControlEvents:UIControlEventTouchUpInside];
            [contextCell addSubview:oderStatesBtn];
            int num = [_bigArr[i][@"prods"][j][@"prod_count"] intValue];
            _sum=_sum+num;
            
            
            float pri = [_bigArr[i][@"prods"][j][@"price"] floatValue];
            
            _ji = _ji+num*pri;
            
//满多少免运费
            NSLog(@"%@",_bigArr[i]);
            _ji = [_bigArr[i][@"sub_amount"] floatValue];// + [_bigArr[i][@"delivery_fee"] floatValue];
            
            
        }
        [_priceArr addObject:[NSString stringWithFormat:@"%.2f",_ji]];

        CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
        [bigvi1 addSubview:zongJiCell];
        
        UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, self.view.width-70*self.scale, 20*self.scale)];
        shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];
        shopNumberLa.font = DefaultFont(self.scale);
        shopNumberLa.textAlignment = NSTextAlignmentLeft;
        [zongJiCell addSubview:shopNumberLa];
        bigvi1.size = CGSizeMake(self.view.width, zongJiCell.bottom);
        setY = bigvi1.bottom +10*self.scale;
        _bigScrollView1.contentSize = CGSizeMake(self.view.width,setY);
       // if ([_bigArr[i][@"pay_type"]isEqualToString:@"3"]) {
            UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            quiXaioBtn.frame = CGRectMake(self.view.width-70*self.scale, zongJiCell.height/2-12.5*self.scale, 60*self.scale, 25*self.scale);
            quiXaioBtn.layer.borderWidth = .5;
            quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
            [quiXaioBtn setTitle:@"取消" forState:UIControlStateNormal];
            [quiXaioBtn addTarget:self action:@selector(huodaoQuXiao:) forControlEvents:UIControlEventTouchUpInside];
            quiXaioBtn.titleLabel.font = SmallFont(self.scale);
            [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            quiXaioBtn.backgroundColor = blackLineColore;
            quiXaioBtn.layer.cornerRadius = 4.0f;
            quiXaioBtn.tag=5000+i;
            [zongJiCell addSubview:quiXaioBtn];
      //  }
    }
}

-(void)huodaoQuXiao:(UIButton *)sender{
    [self ShowAlertTitle:nil Message:@"确认取消?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            NSDictionary *dic = @{@"user_id":self.user_id,@"sub_order_no":_bigArr[sender.tag-5000][@"sub_order_no"],@"order_no":_bigArr[sender.tag-5000][@"order_no"]};
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                if ([code isEqualToString:@"0"]) {
                    if(![AppUtil isBlank:msg])
                        [self ShowAlertWithMessage:msg];
                    [self sc1h:sender];
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

-(void)talkBtnEvent:(UIButton *)sender{
    
    
    self.hidesBottomBarWhenPushed=YES;
    
    
    if ([sender.titleLabel.text isEqualToString:@"talk"]) {
        //聊天
//        if ([_bigArr[sender.tag-1000000][@"is_open_chat"]isEqualToString:@"2"]) {
//            [self ShowAlertWithMessage:@"该商家暂未开通聊天功能！"];
//            return;
//        }
//        
//        
//        RCDChatViewController *chatService = [RCDChatViewController new];
//        chatService.targetId = _bigArr[sender.tag-1000000][@"shop_user_id"];
//        chatService.conversationType = ConversationType_PRIVATE;
//        chatService.title = _bigArr[sender.tag-1000000][@"shop_name"];
//        [self.navigationController pushViewController: chatService animated:YES];
    }else{
        //电话
        
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%@",_bigArr[sender.tag-2000000][@"shop_id"]] forKey:@"shop_id"];
        [dic setObject:[NSString stringWithFormat:@"%@",_bigArr[sender.tag-2000000][@"hotline"]] forKey:@"tel"];
        if ([Stockpile sharedStockpile].isLogin) {
            [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
        }
        
        [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
            }
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_bigArr[sender.tag-2000000][@"hotline"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
    }
}

#pragma mark---待发货的view
-(void)centerDaiFaHuoOderVi{
    if (_big) {
        [_big removeFromSuperview];
    }
    _priceArr1 = [NSMutableArray new];

    _big = [[UIView alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
    [self.view addSubview:_big];
    
    _bigScrollView2 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _big.width, _big.height)];
    [_bigScrollView2 addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(sc2f:)];
    [_bigScrollView2 addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(sc2h:)];
    
    _bigScrollView1.backgroundColor=[UIColor clearColor];
    [_big addSubview:_bigScrollView2];

    _bigArr1 = [NSMutableArray new];
    
    for (NSDictionary *dic in _data2) {
        for (NSDictionary *orderDic in dic[@"order_detail"]) {
            [_bigArr1 addObject:orderDic];
        }
    }
    
    
    float setY = 10*self.scale;
    for (int i=0; i<_bigArr1.count; i++) {
        UIView *bigvi = [[UIView alloc]initWithFrame:CGRectMake(0,setY, self.view.width, 0)];
        [_bigScrollView2 addSubview:bigvi];
        //------
        CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
        nameCell.topline.hidden=NO;
        [bigvi addSubview:nameCell];
        
        UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 30*self.scale, 23*self.scale)];
        [headImg setImageWithURL:[NSURL URLWithString:_bigArr1[i][@"logo"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
        [nameCell addSubview:headImg];
        nameCell.height=headImg.bottom+10*self.scale;
        UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right+5*self.scale, nameCell.height/2-10*self.scale, 0, nameCell.height-20*self.scale)];
        nameLa.text = _bigArr1[i][@"shop_name"];
        nameLa.font = SmallFont(self.scale);
        [nameCell addSubview:nameLa];
        CGSize size = [self sizetoFitWithString:nameLa.text];
        nameLa.width = size.width;
//        UIButton *talkImg = [[UIButton alloc]initWithFrame:CGRectMake(nameLa.right, nameLa.top+3*self.scale, 20*self.scale, 20*self.scale)];
//        [talkImg setBackgroundImage:[UIImage imageNamed:@"ganxi_ico_01"] forState:UIControlStateNormal];
//        [talkImg addTarget:self action:@selector(daishouTalk:) forControlEvents:UIControlEventTouchUpInside];
//        [talkImg setTitle:@"talk" forState:UIControlStateNormal];
//        [talkImg setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//        talkImg.tag=i+3000000;
//        [nameCell addSubview:talkImg];
        
        UIButton *teleImg = [[UIButton alloc]initWithFrame:CGRectMake(nameLa.right, nameLa.top+3*self.scale, 20*self.scale, 20*self.scale)];
        [teleImg setBackgroundImage:[UIImage imageNamed:@"ganxi_ico_02"] forState:UIControlStateNormal];
        [teleImg addTarget:self action:@selector(daishouTalk:) forControlEvents:UIControlEventTouchUpInside];
        [teleImg setTitle:@"tel" forState:UIControlStateNormal];
        [teleImg setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        teleImg.tag=i+4000000;
        [nameCell addSubview:teleImg];
        UIImageView *jiantouImg = [[UIImageView alloc]initWithFrame:CGRectMake(teleImg.right+10*self.scale, nameLa.top+0*self.scale, teleImg.width+5*self.scale, teleImg.height+5*self.scale)];
        jiantouImg.image = [UIImage imageNamed:@"xq_right"];
        [nameCell addSubview:jiantouImg];
        UILabel *states = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameCell.height/2-10*self.scale, 70*self.scale, 20*self.scale)];
        states.text = @"待收货";
        states.textAlignment = NSTextAlignmentRight;
        states.textColor = [UIColor redColor];
        states.font = SmallFont(self.scale);
        [nameCell addSubview:states];
        //---
        NSInteger q;
        if ([_bigArr1[i][@"prods"] isKindOfClass:[NSArray class]]) {
            q = [_bigArr1[i][@"prods"] count];
        }else{
            q=0;
        }
        float line1BotFloat = nameCell.bottom;
        _sum=0;
        _ji=0.0;
        for (int j=0; j<q; j++) {
            CellView *contextCell = [[CellView alloc]initWithFrame:CGRectMake(0, line1BotFloat, self.view.width, 175/2.25*self.scale)];
            [bigvi addSubview:contextCell];
            
            UIImageView *cellHeadImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 65*self.scale, 49*self.scale)];
            cellHeadImg.contentMode=UIViewContentModeScaleAspectFill;
            cellHeadImg.clipsToBounds=YES;
            NSString *url=@"";
            NSString *cut = _bigArr1[i][@"prods"][j][@"img1"];
            NSString *imagename = [cut lastPathComponent];
            NSString *path = [cut stringByDeletingLastPathComponent];
            NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb640."]];
//            if (cut.length>0) {
//                url = [cut substringToIndex:[cut length] - 4];
//                
//            }
//            [cellHeadImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb640.jpg",url]] placeholderImage:[UIImage imageNamed:@"za"]];
             [cellHeadImg setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
            [contextCell addSubview:cellHeadImg];
            UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(cellHeadImg.right+10*self.scale, cellHeadImg.top, 200*self.scale, 20*self.scale)];
            nameLa.text = _bigArr1[i][@"prods"][j][@"prod_name"];
            nameLa.textAlignment = NSTextAlignmentLeft;
            nameLa.font = DefaultFont(self.scale);
            [contextCell addSubview:nameLa];
            UILabel *contextLa = [[UILabel alloc]initWithFrame:CGRectMake(nameLa.left, nameLa.bottom+5*self.scale, 170*self.scale, 35*self.scale)];
            contextLa.numberOfLines=0;
//            contextLa.text = [NSString stringWithFormat:@"销量:%@",_bigArr1[i][@"prods"][j][@"sales"]];
            if (_bigArr1[i][@"prods"][j][@"sales"]!=nil || [_bigArr1[i][@"prods"][j][@"sales"] isEqualToString:@""]) {
                contextLa.text = [NSString stringWithFormat:@"销量%@",_bigArr1[i][@"prods"][j][@"sales"]];
            }else{
                contextLa.text = [NSString stringWithFormat:@"销量%@",@"0"];
            }
            contextLa.textColor = grayTextColor;
            contextLa.font = SmallFont(self.scale);
            [contextCell addSubview:contextLa];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize size = [contextLa.text boundingRectWithSize:CGSizeMake(contextLa.width, 35*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            contextLa.height = size.height;
            UILabel *priceLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameLa.bottom-10*self.scale, 70*self.scale, 15*self.scale)];
            priceLa.textColor = grayTextColor;
            priceLa.font = SmallFont(self.scale);
            priceLa.textAlignment = NSTextAlignmentRight;
            priceLa.text = [NSString stringWithFormat:@"￥%@",_bigArr1[i][@"prods"][j][@"price"]];
            [contextCell addSubview:priceLa];
            
            UILabel *numberLa = [[UILabel alloc]initWithFrame:CGRectMake(priceLa.left, priceLa.bottom+10*self.scale, priceLa.width, priceLa.height)];
            numberLa.text = [NSString stringWithFormat:@"x%@",_bigArr1[i][@"prods"][j][@"prod_count"]];
            numberLa.textAlignment = NSTextAlignmentRight;
            numberLa.textColor = grayTextColor;
            numberLa.font = SmallFont(self.scale);
            [contextCell addSubview:numberLa];
            
            line1BotFloat = contextCell.bottom;
            
            UIButton *oderStatesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            oderStatesBtn.frame = CGRectMake(0, 0, contextCell.width, contextCell.height);
            oderStatesBtn.tag=i+3000;
            [oderStatesBtn addTarget:self action:@selector(oderStBtnEvent2:) forControlEvents:UIControlEventTouchUpInside];
            [contextCell addSubview:oderStatesBtn];
            int num = [_bigArr1[i][@"prods"][j][@"prod_count"] intValue];
            _sum=_sum+num;
            NSLog(@"%@",_bigArr1[i]);
            float pri = [_bigArr1[i][@"prods"][j][@"price"] floatValue];
            
            _ji = _ji+num*pri;
//满多少免运费
            _ji = [_bigArr1[i][@"sub_amount"] floatValue] ;//+ [_bigArr1[i][@"delivery_fee"] floatValue]
//            _ji = [_bigArr1[i][@"sub_amount"] floatValue];
            [_priceArr1 addObject:[NSString stringWithFormat:@"%.2f",_ji]];
        }
        CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
        [bigvi addSubview:zongJiCell];
        UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, self.view.width-90*self.scale, 20*self.scale)];
        shopNumberLa.textAlignment=NSTextAlignmentLeft;
        shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];
        shopNumberLa.font = DefaultFont(self.scale);
        [zongJiCell addSubview:shopNumberLa];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0f], NSParagraphStyleAttributeName:paragraphStyle.copy};
//        CGSize size1 = [shopNumberLa.text boundingRectWithSize:CGSizeMake(300, 20*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//        shopNumberLa.width = size1.width;
        UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quiXaioBtn.frame = CGRectMake(self.view.width-70*self.scale, zongJiCell.height/2-12.5*self.scale, 60*self.scale, 25*self.scale);
        quiXaioBtn.layer.borderWidth = .5;
        quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
        [quiXaioBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [quiXaioBtn addTarget:self action:@selector(querenshouhuo:) forControlEvents:UIControlEventTouchUpInside];
        quiXaioBtn.tag=100000+i;
        quiXaioBtn.titleLabel.font = SmallFont(self.scale);
        [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        quiXaioBtn.backgroundColor = blackLineColore;
        quiXaioBtn.layer.cornerRadius = 4.0f;
        [zongJiCell addSubview:quiXaioBtn];
        bigvi.size = CGSizeMake(self.view.width, zongJiCell.bottom);
        setY = bigvi.bottom +10*self.scale;
        _bigScrollView2.contentSize = CGSizeMake(self.view.width,setY);
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(self.view.width-140*self.scale, zongJiCell.height/2-12.5*self.scale, 60*self.scale, 25*self.scale);
        cancelBtn.layer.borderWidth = .5;
        cancelBtn.layer.borderColor = blackLineColore.CGColor;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelByShipped:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.tag=300000+i;
        cancelBtn.titleLabel.font = SmallFont(self.scale);
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //cancelBtn.backgroundColor = blackLineColore;
        cancelBtn.layer.cornerRadius = 4.0f;
        [zongJiCell addSubview:cancelBtn];
    }
}

-(void)daishouTalk:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
    if ([sender.titleLabel.text isEqualToString:@"talk"]) {
        //聊天
//        RCDChatViewController *chatService = [RCDChatViewController new];
////        chatService.userName = _data2[sender.tag-3000000][@"order_detail"][0][@"shop_name"];
//        chatService.targetId = _data2[sender.tag-3000000][@"order_detail"][0][@"shop_user_id"];
//        chatService.conversationType = ConversationType_PRIVATE;
//        chatService.title = _data2[sender.tag-3000000][@"order_detail"][0][@"shop_name"];
//        [self.navigationController pushViewController: chatService animated:YES];
    }else{
        //电话
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%@",_data2[sender.tag-4000000][@"order_detail"][0][@"shop_id"]] forKey:@"shop_id"];
        [dic setObject:[NSString stringWithFormat:@"%@",_data2[sender.tag-4000000][@"order_detail"][0][@"hotline"]] forKey:@"tel"];
        if ([Stockpile sharedStockpile].isLogin) {
            [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
        }
        [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
            }
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_data2[sender.tag-4000000][@"order_detail"][0][@"hotline"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        //        [[[UIAlertView alloc]initWithTitle:@"在线联系卖家电话" message:_data1[sender.tag-2000000][@"order_detail"][0][@"hotline"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil]show ] ;
    }
}


-(void)cancelByShipped4:(UIButton *)btn{
    [self ShowAlertTitle:nil Message:@"确认取消?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            NSInteger tag = btn.tag-400000;
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            NSDictionary *dic = @{@"user_id":self.user_id,@"sub_order_no":_biggg[tag][@"sub_order_no"],@"order_no":_biggg[tag][@"order_no"]};
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                if ([code isEqualToString:@"0"]) {
                    if(![AppUtil isBlank:msg])
                        [self ShowAlertWithMessage:msg];
                    [self sc4h:nil];
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

-(void)cancelByShipped:(UIButton *)btn{
    [self ShowAlertTitle:nil Message:@"确认取消?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            NSInteger tag = btn.tag-300000;
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            NSDictionary *dic = @{@"user_id":self.user_id,@"sub_order_no":_data2[tag][@"order_detail"][0][@"sub_order_no"],@"order_no":_data2[tag][@"order_detail"][0][@"order_no"]};
            //NSLog(@"cancelOrderWithDic_param==%@",dic);
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                if ([code isEqualToString:@"0"]) {
                    if(![AppUtil isBlank:msg])
                        [self ShowAlertWithMessage:msg];
                    [self sc2h:nil];
                }else{
                    if([AppUtil isBlank:msg])
                        [AppUtil showToast:self.view withContent:@"取消失败"];
                    else{
                        [AppUtil showToast:self.view withContent:msg];
                    }
                }
            }];
//            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
//            NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":_data2[tag][@"order_detail"][0][@"sub_order_no"]};
//            
//            AnalyzeObject *anle = [AnalyzeObject new];
//            [anle finishOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
//                if ([code isEqualToString:@"0"]) {
//                    [self sc2h:nil];
//                }
//                [self.activityVC stopAnimate];
//            }];
        }
    }];
}


-(void)querenshouhuo:(UIButton *)btn{

    [self ShowAlertTitle:nil Message:@"确认收货?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            NSInteger tag = btn.tag-100000;
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            
            NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":_data2[tag][@"order_detail"][0][@"sub_order_no"]};
            
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle finishOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                if ([code isEqualToString:@"0"]) {
                    [self sc2h:nil];
                }
                [self.activityVC stopAnimate];
            }];

        }
    }];
}

-(void)centerDaiPingJiaOderVi{
    
    if (_big) {
        [_big removeFromSuperview];
    }
    _priceArr2 = [NSMutableArray new];

    _big = [[UIView alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
    [self.view addSubview:_big];
    
    _bigScrollView3 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _big.width, _big.height)];
    [_bigScrollView3 addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(sc3f:)];
    [_bigScrollView3 addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(sc3h:)];
    
    _bigScrollView1.backgroundColor=[UIColor clearColor];
    [_big addSubview:_bigScrollView3];
    
  
    _bigArr2 = [NSMutableArray new];
    
    for (NSDictionary *dic in _data3) {
        for (NSDictionary *orderDic in dic[@"order_detail"]) {
            [_bigArr2 addObject:orderDic];
        }
    }

    
    float setY = 10*self.scale;
    for (int i=0; i<_bigArr2.count; i++) {
        if ([_bigArr2[i][@"is_comment"] isEqualToString:@"2"]) {
            continue;
        }

        
        UIView *bigvi = [[UIView alloc]initWithFrame:CGRectMake(0,setY, self.view.width, 0)];
        [_bigScrollView3 addSubview:bigvi];
//------
        CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
        nameCell.topline.hidden=NO;
        [bigvi addSubview:nameCell];
        
        UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 30*self.scale, 23*self.scale)];
        [headImg setImageWithURL:[NSURL URLWithString:_bigArr2[i][@"logo"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
        [nameCell addSubview:headImg];
        nameCell.height=headImg.bottom+10*self.scale;
        
        UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right+5*self.scale, nameCell.height/2-10*self.scale, 0, nameCell.height-20*self.scale)];
        nameLa.text =_bigArr2[i][@"shop_name"];
        nameLa.font = SmallFont(self.scale);
        [nameCell addSubview:nameLa];
        
        CGSize size = [self sizetoFitWithString:nameLa.text];
        nameLa.width = size.width+5*self.scale;
        
//        UIButton *talkImg = [[UIButton alloc]initWithFrame:CGRectMake(nameLa.right, nameLa.top+3*self.scale, 20*self.scale, 20*self.scale)];
//        [talkImg setBackgroundImage:[UIImage imageNamed:@"ganxi_ico_01"] forState:UIControlStateNormal];
//        [talkImg addTarget:self action:@selector(daipingtalk:) forControlEvents:UIControlEventTouchUpInside];
//        talkImg.tag=i+5000000;
//        [talkImg setTitle:@"talk" forState:UIControlStateNormal];
//        [talkImg setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//        [nameCell addSubview:talkImg];
        
        UIButton *teleImg = [[UIButton alloc]initWithFrame:CGRectMake(nameLa.right, nameLa.top+3*self.scale, 20*self.scale, 20*self.scale)];
        [teleImg setBackgroundImage:[UIImage imageNamed:@"ganxi_ico_02"] forState:UIControlStateNormal];
        [teleImg addTarget:self action:@selector(daipingtalk:) forControlEvents:UIControlEventTouchUpInside];
        teleImg.tag=i+6000000;
        [teleImg setTitle:@"tel" forState:UIControlStateNormal];
        [teleImg setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [nameCell addSubview:teleImg];
        
        UIImageView *jiantouImg = [[UIImageView alloc]initWithFrame:CGRectMake(teleImg.right+10*self.scale, nameLa.top+0*self.scale, teleImg.width+5*self.scale, teleImg.height+5*self.scale)];
        jiantouImg.image = [UIImage imageNamed:@"xq_right"];
        [nameCell addSubview:jiantouImg];
        
        
        UILabel *states = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameCell.height/2-10*self.scale, 70*self.scale, 20*self.scale)];
        states.text = @"待评价";
        states.textAlignment = NSTextAlignmentRight;
        states.textColor = [UIColor redColor];
        states.font = SmallFont(self.scale);
        [nameCell addSubview:states];
        //---
        NSArray *dataArr = _bigArr2[i][@"prods"];
        NSInteger q;
        if ([dataArr isKindOfClass:[NSArray class]]) {
            q = [dataArr count];
        }else{
            q=0;
        }

      
        
        float line1BotFloat = nameCell.bottom;
        _sum=0;
        _ji=0.0;
        for (int j=0; j<q; j++) {
            CellView *contextCell = [[CellView alloc]initWithFrame:CGRectMake(0, line1BotFloat, self.view.width, 175/2.25*self.scale)];
            [bigvi addSubview:contextCell];
            
            UIImageView *cellHeadImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 65*self.scale, 49*self.scale)];
            cellHeadImg.contentMode=UIViewContentModeScaleAspectFill;
            cellHeadImg.clipsToBounds=YES;
            NSString *url=@"";
            NSString *cut = dataArr[j][@"img1"];
            NSString *imagename = [cut lastPathComponent];
            NSString *path = [cut stringByDeletingLastPathComponent];
            NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb640."]];
            
//            if (cut.length>0) {
//                url = [cut substringToIndex:[cut length] - 4];
//                
//            }
//            [cellHeadImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb640.jpg",url]] placeholderImage:[UIImage imageNamed:@"za"]];
            [cellHeadImg setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
            [contextCell addSubview:cellHeadImg];
            
            
            UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(cellHeadImg.right+10*self.scale, cellHeadImg.top, 200*self.scale, 20*self.scale)];
            nameLa.text = dataArr[j][@"prod_name"];
            nameLa.textAlignment = NSTextAlignmentLeft;
            nameLa.font = DefaultFont(self.scale);
            [contextCell addSubview:nameLa];
            
            
            UILabel *contextLa = [[UILabel alloc]initWithFrame:CGRectMake(nameLa.left, nameLa.bottom+5*self.scale, 170*self.scale, 35*self.scale)];
            contextLa.numberOfLines=0;
            if (_bigArr2[i][@"prods"][j][@"sales"]!=nil || [_bigArr2[i][@"prods"][j][@"sales"] isEqualToString:@""]) {
                contextLa.text = [NSString stringWithFormat:@"销量%@",_bigArr2[i][@"prods"][j][@"sales"]];
                
            }else{
                contextLa.text = [NSString stringWithFormat:@"销量%@",@"0"];
                
            }
//            contextLa.text =[NSString stringWithFormat:@"销量:%@",dataArr[j][@"sales"]];
            contextLa.textColor = grayTextColor;
            contextLa.font = SmallFont(self.scale);
            [contextCell addSubview:contextLa];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize size = [contextLa.text boundingRectWithSize:CGSizeMake(contextLa.width, 35*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            contextLa.height = size.height;
            
            
            UILabel *priceLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameLa.bottom-10*self.scale, 70*self.scale, 15*self.scale)];
            priceLa.textColor = grayTextColor;
            priceLa.font = SmallFont(self.scale);
            priceLa.textAlignment = NSTextAlignmentRight;
            priceLa.text = [NSString stringWithFormat:@"￥%@",dataArr[j][@"price"]];
            [contextCell addSubview:priceLa];
            
            UILabel *numberLa = [[UILabel alloc]initWithFrame:CGRectMake(priceLa.left, priceLa.bottom+10*self.scale, priceLa.width, priceLa.height)];
            numberLa.text = [NSString stringWithFormat:@"x%@",dataArr[j][@"prod_count"]];
            numberLa.textAlignment = NSTextAlignmentRight;
            numberLa.textColor = grayTextColor;
            numberLa.font = SmallFont(self.scale);
            [contextCell addSubview:numberLa];
            
            line1BotFloat = contextCell.bottom;
            
            UIButton *oderStatesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            oderStatesBtn.frame = CGRectMake(0, 0, contextCell.width, contextCell.height);
            oderStatesBtn.tag=i+4000;
            [oderStatesBtn addTarget:self action:@selector(oderStBtnEvent3:) forControlEvents:UIControlEventTouchUpInside];
            [contextCell addSubview:oderStatesBtn];
            
            
            
            
            int num = [dataArr[j][@"prod_count"] intValue];
            _sum=_sum+num;
            
            
            float pri = [dataArr[j][@"price"] floatValue];
            
            _ji = _ji+num*pri;
         
//满多少免运费
             _ji = [_bigArr2[i][@"sub_amount"] floatValue] + [_bigArr2[i][@"delivery_fee"] floatValue];
//            _ji = [_bigArr2[i][@"sub_amount"] floatValue];

            
        }
        [_priceArr2 addObject:[NSString stringWithFormat:@"%.2f",_ji]];

        
        CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
        [bigvi addSubview:zongJiCell];
        
        UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, self.view.width-90*self.scale, 20*self.scale)];
        shopNumberLa.textAlignment=NSTextAlignmentLeft;
         shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];
        
        
        
        shopNumberLa.font = DefaultFont(self.scale);
        [zongJiCell addSubview:shopNumberLa];
        //-


        UIButton *pingjiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pingjiaBtn.frame = CGRectMake(self.view.width-120*self.scale, zongJiCell.height/2-12.5*self.scale, 50*self.scale, 25*self.scale);
        pingjiaBtn.layer.borderColor=blackLineColore.CGColor;
        pingjiaBtn.layer.borderWidth=.5;
        pingjiaBtn.layer.cornerRadius=4.0f;
        [pingjiaBtn setTitle:@"去评价" forState:UIControlStateNormal];
        [pingjiaBtn addTarget:self action:@selector(daipingjiaEvent:) forControlEvents:UIControlEventTouchUpInside];
        pingjiaBtn.titleLabel.font = SmallFont(self.scale);
        pingjiaBtn.tag=i+10000;
        [pingjiaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [zongJiCell addSubview:pingjiaBtn];
        
        
        
        UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quiXaioBtn.frame = CGRectMake(self.view.width-60*self.scale, zongJiCell.height/2-12.5*self.scale, 50*self.scale, 25*self.scale);
        quiXaioBtn.layer.borderWidth = .5;
        quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
        [quiXaioBtn setTitle:@"删除" forState:UIControlStateNormal];
        [quiXaioBtn addTarget:self action:@selector(daipingjiaEvent:) forControlEvents:UIControlEventTouchUpInside];
        quiXaioBtn.titleLabel.font = SmallFont(self.scale);
        [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        quiXaioBtn.tag=i+50000;
        quiXaioBtn.backgroundColor = blackLineColore;
        quiXaioBtn.layer.cornerRadius = 4.0f;
        [zongJiCell addSubview:quiXaioBtn];
        
        
        bigvi.size = CGSizeMake(self.view.width, zongJiCell.bottom);
        setY = bigvi.bottom +10*self.scale;
        _bigScrollView3.contentSize = CGSizeMake(self.view.width,setY);
        
        
    }
    
}


-(void)daipingtalk:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
    if ([sender.titleLabel.text isEqualToString:@"talk"]) {
        //聊天
//        RCDChatViewController *chatService = [RCDChatViewController new];
////        chatService.userName = _data3[sender.tag-5000000][@"order_detail"][0][@"shop_name"];
//        chatService.targetId = _data3[sender.tag-5000000][@"order_detail"][0][@"shop_user_id"];
//        chatService.conversationType = ConversationType_PRIVATE;
//        chatService.title = _data3[sender.tag-5000000][@"order_detail"][0][@"shop_name"];
//        [self.navigationController pushViewController: chatService animated:YES];
        
        
        
    }else{
        //电话
        
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%@",_data3[sender.tag-6000000][@"order_detail"][0][@"shop_id"]] forKey:@"shop_id"];
        [dic setObject:[NSString stringWithFormat:@"%@",_data3[sender.tag-6000000][@"order_detail"][0][@"hotline"]] forKey:@"tel"];
        if ([Stockpile sharedStockpile].isLogin) {
            [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
        }
        
        [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
            }
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_data3[sender.tag-6000000][@"order_detail"][0][@"hotline"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        

        
        
        
    }
    
    
}

-(void)daipingjiaEvent:(UIButton *)btn{

    [self.view addSubview:self.activityVC];
    
    if ([btn.titleLabel.text isEqualToString:@"去评价"]) {
        
        self.hidesBottomBarWhenPushed=YES;
        XiePingJiaViewController *pingjia= [XiePingJiaViewController new];
        pingjia.is_order_on=YES;
        pingjia.order_on = _data3[btn.tag-10000][@"order_detail"][0][@"prods"][0][@"sub_order_no"];
        pingjia.shopid = _data3[btn.tag-10000][@"order_detail"][0][@"shop_id"];
        
        [pingjia reshBlock:^(NSMutableArray *arr) {
            [self.activityVC startAnimate];
          [self sc3h:nil];            
        }];
        
        [self.navigationController pushViewController:pingjia animated:YES];

        
    }else{
        [self ShowAlertTitle:nil Message:@"确认删除?" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                
                [self.activityVC startAnimate];
                NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
                
                
                
                NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":_data3[btn.tag-50000][@"order_detail"][0][@"sub_order_no"]};
                
                AnalyzeObject *anle = [AnalyzeObject new];
                [anle delOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                    if ([code isEqualToString:@"0"]) {
                        [self sc3h:nil];
                        
                    }
                }];

            }
        }];
    }
}
-(CGSize)sizetoFitWithString:(NSString *)string{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(self.view.width-50*self.scale, 35*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return size;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)talkAndTel:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
    if ([sender.titleLabel.text isEqualToString:@"talk"]) {
        //聊天
        //        RCDChatViewController *chatService = [RCDChatViewController new];
        ////        chatService.userName = _data[sender.tag-5000000][@"shop_name"];
        //        chatService.targetId = _data[sender.tag-5000000][@"shop_user_id"];
        //        chatService.conversationType = ConversationType_PRIVATE;
        //        chatService.title = _data[sender.tag-5000000][@"shop_name"];
        //        [self.navigationController pushViewController: chatService animated:YES];
    }else{
        //电话
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%@",_data[sender.tag-8000000][@"shop_id"]] forKey:@"shop_id"];
        [dic setObject:[NSString stringWithFormat:@"%@",_data[sender.tag-8000000][@"hotline"]] forKey:@"tel"];
        if ([Stockpile sharedStockpile].isLogin) {
            [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
        }
        
        [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
            }
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_data[sender.tag-8000000][@"hotline"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        //        [[[UIAlertView alloc]initWithTitle:@"在线联系卖家电话" message:_data1[sender.tag-2000000][@"order_detail"][0][@"hotline"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil]show ] ;
    }   
}



-(void)talkBtnEvent4:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
    if ([sender.titleLabel.text isEqualToString:@"talk"]) {
        //聊天
        //        if ([_bigArr[sender.tag-1000000][@"is_open_chat"]isEqualToString:@"2"]) {
        //            [self ShowAlertWithMessage:@"该商家暂未开通聊天功能！"];
        //            return;
        //        }
        //
        //
        //        RCDChatViewController *chatService = [RCDChatViewController new];
        //        chatService.targetId = _bigArr[sender.tag-1000000][@"shop_user_id"];
        //        chatService.conversationType = ConversationType_PRIVATE;
        //        chatService.title = _bigArr[sender.tag-1000000][@"shop_name"];
        //        [self.navigationController pushViewController: chatService animated:YES];
    }else{
        //电话
        
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%@",_biggg[sender.tag-7000000][@"shop_id"]] forKey:@"shop_id"];
        [dic setObject:[NSString stringWithFormat:@"%@",_biggg[sender.tag-7000000][@"hotline"]] forKey:@"tel"];
        if ([Stockpile sharedStockpile].isLogin) {
            [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
        }
        
        [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
            }
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_biggg[sender.tag-7000000][@"hotline"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
    }
}

-(void)huodaoQuXiao4:(UIButton *)sender{
    [self ShowAlertTitle:nil Message:@"确认取消?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            NSDictionary *dic = @{@"user_id":self.user_id,@"sub_order_no":_biggg[sender.tag-6000][@"sub_order_no"],@"order_no":_biggg[sender.tag-6000][@"order_no"]};
            //NSLog(@"cancelOrderWithDic_param==%@",dic);
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                if ([code isEqualToString:@"0"]) {
                    if(![AppUtil isBlank:msg])
                        [self ShowAlertWithMessage:msg];
                    [self sc4h:sender];
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

-(void)querenshouhuo4:(UIButton *)btn{
    [self ShowAlertTitle:nil Message:@"确认收货?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            NSInteger tag = btn.tag-200000;
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            //_data2[tag][@"order_detail"][0][@"sub_order_no"]
            NSLog(@"");
            NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":_biggg[tag][@"sub_order_no"]};
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle finishOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                if ([code isEqualToString:@"0"]) {
                    [self sc4h:nil];
                }
                [self.activityVC stopAnimate];
            }];
        }
    }];
}

-(void)daipingjiaEvent4:(UIButton *)btn{
    
    [self.view addSubview:self.activityVC];
    
    if ([btn.titleLabel.text isEqualToString:@"去评价"]) {
        
        self.hidesBottomBarWhenPushed=YES;
        XiePingJiaViewController *pingjia= [XiePingJiaViewController new];
        pingjia.is_order_on=YES;
        pingjia.order_on = _biggg[btn.tag-60000][@"sub_order_no"];
        pingjia.shopid = _biggg[btn.tag-60000][@"shop_id"];
        [pingjia reshBlock:^(NSMutableArray *arr) {
            [self.activityVC startAnimate];
            [self sc4h:nil];
        }];
        [self.navigationController pushViewController:pingjia animated:YES];
    }else{
        [self ShowAlertTitle:nil Message:@"确认删除?" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                [self.activityVC startAnimate];
                NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
                NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":_biggg[btn.tag-70000][@"sub_order_no"]};
                AnalyzeObject *anle = [AnalyzeObject new];
                [anle delOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                    if ([code isEqualToString:@"0"]) {
                        [self sc4h:nil];
                    }
                }];
            }
        }];
    }
}

@end
