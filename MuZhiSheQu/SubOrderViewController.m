//
//  SubOrderViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SubOrderViewController.h"
#import "OrderTableViewCell.h"
#import "OderStatesViewController.h"
#import "weifukuanViewController.h"
#import "AppUtil.h"

static const NSUInteger ORDER_HEADER_TAG = 1000000;
static const NSUInteger ORDER_PROD_TAG = 2000000;

@interface SubOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong) NSMutableArray* orderArray;//
@end

@implementation SubOrderViewController

-(id)initWithType:(NSString*)type{
    if (self=[super init])
    {//初始化对象的成员变量
        _type = type;
    }
    //返回已初始化的成员变量
    return self;
}

-(void) newListView{
    _tableView=[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [_tableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"OrderTableViewCell"];
    _tableView.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blueColor];
    _orderArray=[[NSMutableArray alloc]init];
    _index=0;
    [self newListView];
    [self reshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 下拉刷新
- (void)xiala{
    _index = 0;
    self.tableView.footer.state = MJRefreshFooterStateIdle;
    [self reshData];
}

#pragma mark -- 上拉加载
- (void)shangla{
    [self reshData];
}

-(void)reshData{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    _index++;
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"user_id":self.user_id,@"status":_type,@"pindex":[NSNumber numberWithInteger:_index]};
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([code isEqualToString:@"0"]) {
            //NSLog(@"_orderArray==%@",models);
            if(_index==1&&_orderArray.count>0)
                [_orderArray removeAllObjects];
            [_orderArray addObjectsFromArray:models];
            [_tableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_orderArray[section][@"order_detail"][0][@"prods"] count];
}

#pragma mark -数据源方法
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [_orderArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell *cell=[OrderTableViewCell cellWithTableView:tableView];
    NSDictionary* itemDic=_orderArray[indexPath.section][@"order_detail"][0][@"prods"][indexPath.row];
    cell.titleLa.text=itemDic[@"prod_name"];
    cell.numLb.text=[NSString stringWithFormat:@"x%@",itemDic[@"prod_count"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //self.hidesBottomBarWhenPushed=YES;
    id start = _orderArray[indexPath.section];
    NSString *starts = [[NSString alloc]init];
    starts=start[@"order_detail"][0][@"status"];
    if (![starts isEqualToString:@"1"]) {
        OderStatesViewController *oder = [OderStatesViewController new];
        oder.hidesBottomBarWhenPushed=YES;
        oder.price = start[@"order_detail"][0][@"total_amount"];
        oder.orderid =start[@"order_detail"][0][@"order_no"];
        oder.smallOder =start[@"order_detail"][0][@"prods"][0][@"sub_order_no"];
        [self.navigationController pushViewController:oder animated:YES];
    }else{
        weifukuanViewController *weifu = [weifukuanViewController new];
        weifu.hidesBottomBarWhenPushed=YES;
        weifu.order_id=start[@"order_detail"][0][@"order_no"];
        [self.navigationController pushViewController:weifu animated:YES];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45*self.scale;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70*self.scale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
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
    NSString *content=[NSString stringWithFormat:@"共%d件商品，实付￥%.1f",total,total_amount];
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
    if ([status isEqualToString:@"1"]) {
        UIButton *fuKuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fuKuanBtn.frame = CGRectMake(self.view.width-82.5*self.scale, line.bottom+7.5*self.scale, 72.5*self.scale, 30*self.scale);
        [fuKuanBtn setBackgroundImage:[UIImage imageNamed:@"bg_order"] forState:UIControlStateNormal];
        [fuKuanBtn setTitle:@"付款" forState:UIControlStateNormal];
        [fuKuanBtn addTarget:self action:@selector(fuAndQUxiAO:) forControlEvents:UIControlEventTouchUpInside];
        fuKuanBtn.titleLabel.font = SmallFont(self.scale);
        [fuKuanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        fuKuanBtn.tag=600+section;
        [footerView addSubview:fuKuanBtn];
        UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quiXaioBtn.frame = CGRectMake(self.view.width-165*self.scale, fuKuanBtn.top, 72.5*self.scale, 30*self.scale);
        quiXaioBtn.layer.cornerRadius = quiXaioBtn.height/2;
        quiXaioBtn.layer.borderWidth = .5;
        quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
        [quiXaioBtn setTitle:@"取消" forState:UIControlStateNormal];
        [quiXaioBtn addTarget:self action:@selector(fuAndQUxiAO:) forControlEvents:UIControlEventTouchUpInside];
        quiXaioBtn.titleLabel.font = SmallFont(self.scale);
        [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        quiXaioBtn.backgroundColor = [UIColor whiteColor];
        quiXaioBtn.tag=200+section;
        [footerView addSubview:quiXaioBtn];
    }else if ([status isEqualToString:@"2"] || [status isEqualToString:@"3"]){
        UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quiXaioBtn.frame = CGRectMake(self.view.width-82.5*self.scale, line.bottom+7.5*self.scale, 72.5*self.scale, 30*self.scale);
        quiXaioBtn.layer.borderWidth = .5;
        quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
        [quiXaioBtn setTitle:@"取消" forState:UIControlStateNormal];
        [quiXaioBtn addTarget:self action:@selector(huodaoQuXiao:) forControlEvents:UIControlEventTouchUpInside];
        quiXaioBtn.titleLabel.font = SmallFont(self.scale);
        [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        quiXaioBtn.backgroundColor = [UIColor whiteColor];
        quiXaioBtn.layer.cornerRadius = quiXaioBtn.height/2;
        quiXaioBtn.tag=6000+section;
        [footerView addSubview:quiXaioBtn];
    }else if ([status isEqualToString:@"4"]){
        UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quiXaioBtn.frame =CGRectMake(self.view.width-82.5*self.scale, line.bottom+7.5*self.scale, 72.5*self.scale, 30*self.scale);
        [quiXaioBtn setBackgroundImage:[UIImage imageNamed:@"bg_order"] forState:UIControlStateNormal];
        [quiXaioBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [quiXaioBtn addTarget:self action:@selector(querenshouhuo:) forControlEvents:UIControlEventTouchUpInside];
        quiXaioBtn.titleLabel.font = SmallFont(self.scale);
        [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        quiXaioBtn.backgroundColor = blackLineColore;
        quiXaioBtn.tag=200000+section;
        [footerView addSubview:quiXaioBtn];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(self.view.width-165*self.scale, quiXaioBtn.top, 72.5*self.scale, 30*self.scale);
        cancelBtn.layer.borderWidth = .5;
        cancelBtn.layer.borderColor = blackLineColore.CGColor;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelByShipped:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.tag=400000+section;
        cancelBtn.titleLabel.font = SmallFont(self.scale);
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.layer.cornerRadius = cancelBtn.height/2;
        [footerView addSubview:cancelBtn];
    }else if([status isEqualToString:@"5"]){
        UIButton *shanchu = [UIButton buttonWithType:UIButtonTypeCustom];
        shanchu.frame = CGRectMake(self.view.width-82.5*self.scale, line.bottom+7.5*self.scale, 72.5*self.scale, 30*self.scale);
        shanchu.layer.borderWidth = .5;
        shanchu.layer.borderColor = blackLineColore.CGColor;
        [shanchu setTitle:@"删除" forState:UIControlStateNormal];
        [shanchu addTarget:self action:@selector(daipingjiaEvent:) forControlEvents:UIControlEventTouchUpInside];
        shanchu.titleLabel.font = SmallFont(self.scale);
        [shanchu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        shanchu.backgroundColor = blackLineColore;
        shanchu.layer.cornerRadius = shanchu.height/2;
        shanchu.tag=70000+section;
        [footerView addSubview:shanchu];
        if ([groupDic[@"order_detail"][0][@"is_comment"] isEqualToString:@""] || [groupDic[@"order_detail"][0][@"is_comment"] isEqualToString:@"1"]) {
            UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            quiXaioBtn.frame =CGRectMake(self.view.width-165*self.scale, shanchu.top, 72.5*self.scale, 30*self.scale);;
            quiXaioBtn.layer.borderWidth = .5;
            quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
            [quiXaioBtn setTitle:@"去评价" forState:UIControlStateNormal];
            [quiXaioBtn addTarget:self action:@selector(daipingjiaEvent:) forControlEvents:UIControlEventTouchUpInside];
            quiXaioBtn.titleLabel.font = SmallFont(self.scale);
            [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            quiXaioBtn.layer.cornerRadius = quiXaioBtn.height/2;
            quiXaioBtn.tag=60000+section;
            [footerView addSubview:quiXaioBtn];
        }
    }
    return footerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
    //self.hidesBottomBarWhenPushed=YES;
    id start = _orderArray[btn.tag-ORDER_HEADER_TAG];
    NSString *starts = [[NSString alloc]init];
    //    if ([start isKindOfClass:[NSArray class]]) {
    //        starts=start[@"order_detail"][0][@"status"];
    //    }else{
    //        starts = start[@"status"];
    //    }
    starts=start[@"order_detail"][0][@"status"];
    if (![starts isEqualToString:@"1"]) {
        OderStatesViewController *oder = [OderStatesViewController new];
        oder.hidesBottomBarWhenPushed=YES;
        oder.price = start[@"order_detail"][0][@"total_amount"];
        oder.orderid =start[@"order_detail"][0][@"order_no"];
        oder.smallOder =start[@"order_detail"][0][@"prods"][0][@"sub_order_no"];
        [self.navigationController pushViewController:oder animated:YES];
    }else{
        weifukuanViewController *weifu = [weifukuanViewController new];
        weifu.hidesBottomBarWhenPushed=YES;
        weifu.order_id=start[@"order_detail"][0][@"order_no"];
        [self.navigationController pushViewController:weifu animated:YES];
    }
}

-(void)fuAndQUxiAO:(UIButton *)sender{
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    if ([sender.titleLabel.text isEqualToString:@"付款"]) {
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        //付款
        if ([_orderArray[sender.tag-600][@"order_detail"][0][@"pay_type"] isEqualToString:@"2"]) {//微信支付
            AnalyzeObject *anle = [AnalyzeObject new];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:_orderArray[sender.tag-600][@"order_detail"][0][@"order_no"] forKey:@"orderid"];
            [param setObject: self.user_id forKey:@"user_id"];
            [anle resubmitOrder:[param copy] Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                //NSLog(@"resubmitOrder==%@",models);
                [self.appdelegate WXPayNewWithNonceStr:models[@"noncestr"] OrderID:models[@"order_no"] Timestamp:models[@"timestamp"] sign:models[@"sign"] complete:^(BaseResp *resp) {
                    [self.activityVC stopAnimate];
                    if (resp.errCode == WXSuccess) {
                        [self dropDownRefresh];
                    }
                }];
            }];
        }else if ([_orderArray[sender.tag-600][@"order_detail"][0][@"pay_type"] isEqualToString:@"1"]){
            AnalyzeObject *anle = [AnalyzeObject new];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:_orderArray[sender.tag-600][@"order_detail"][0][@"order_no"] forKey:@"orderid"];
            [param setObject: self.user_id forKey:@"user_id"];
            [anle resubmitOrder:[param copy] Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                [self.appdelegate AliPayNewPrice:models[@"amount"] OrderID:[NSString stringWithFormat:@"%@",models[@"order_no"]] OrderName:@"拇指社区" Sign:models[@"sign"]  OrderDescription:[NSString stringWithFormat:@"%@",models[@"order_no"]] complete:^(NSDictionary *resp) {
                    [self.activityVC stopAnimate];
                    if ([[resp objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                        [self dropDownRefresh];
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
                NSDictionary *dic = @{@"user_id":self.user_id,@"order_no":_orderArray[sender.tag-200][0][@"order_no"]};
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

-(void)querenshouhuo:(UIButton *)btn{
    [self ShowAlertTitle:nil Message:@"确认收货?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            NSInteger tag = btn.tag-200000;
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            //_data2[tag][@"order_detail"][0][@"sub_order_no"]
            NSLog(@"");
            NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":_orderArray[tag][@"order_detail"][0][@"sub_order_no"]};
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle finishOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                if ([code isEqualToString:@"0"]) {
                    [self dropDownRefresh];
                }
                [self.activityVC stopAnimate];
            }];
        }
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
    if ([btn.titleLabel.text isEqualToString:@"去评价"]) {
        XiePingJiaViewController *pingjia= [XiePingJiaViewController new];
        pingjia.hidesBottomBarWhenPushed=YES;
        pingjia.is_order_on=YES;
        pingjia.order_on = _orderArray[btn.tag-60000][@"sub_order_no"];
        pingjia.shopid = _orderArray[btn.tag-60000][@"shop_id"];
        [pingjia reshBlock:^(NSMutableArray *arr) {
            [self.activityVC startAnimate];
            [self dropDownRefresh];
        }];
        [self.navigationController pushViewController:pingjia animated:YES];
    }else{
        [self ShowAlertTitle:nil Message:@"确认删除?" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                [self.activityVC startAnimate];
                NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
                NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":_orderArray[btn.tag-70000][@"order_detail"][0][@"sub_order_no"]};
                AnalyzeObject *anle = [AnalyzeObject new];
                [anle delOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                    if ([code isEqualToString:@"0"]) {
                        [self dropDownRefresh];
                    }
                }];
            }
        }];
    }
}

-(void)dropDownRefresh{
    _index=0;
    [self reshData];
}

@end
