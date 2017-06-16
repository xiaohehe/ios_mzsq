//
//  ShangJiaFenleiViewController.m
//  MuZhiSheQu
//
//  Created by apple on 17/2/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShangJiaFenleiViewController.h"
#import "ShengHuoTableViewCell.h"
#import "GanXiShopViewController.h"
@interface ShangJiaFenleiViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ShangJiaFenleiViewController
- (instancetype)initWithIdString:(NSString *)idStrng
{
    self=[super init];
    if (self)
    {
        self.IdString = idStrng;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.NavImg.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = [NSMutableArray new];
    NSLog(@"%@",self.IdString);
    [self createTableView];
    self.index = 0;
    [self reshList];
    // Do any additional setup after loading the view.
}

#pragma mark -- 创建tableView
- (void)createTableView
{
    self.shenghuoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, [UIScreen mainScreen].bounds.size.height - 64 - 70*self.scale) style:(UITableViewStyleGrouped)];
    self.shenghuoTableView.delegate = self;
    self.shenghuoTableView.dataSource = self;
//    self.shenghuoTableView.bounces = NO;
//    self.shenghuoTableView.scrollEnabled = NO;
    self.shenghuoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.shenghuoTableView registerClass:[ShengHuoTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.shenghuoTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
    [self.shenghuoTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    self.shenghuoTableView.footer.automaticallyRefresh = NO;
    [self.view addSubview:self.shenghuoTableView];
}
#pragma mark ------- tableView协议方法
#pragma  mark -- 获取区头的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark -- 获取tableViewcell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark -- 配置tableViewcell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShengHuoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[ShengHuoTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    
    cell.titleLa.text=[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"shop_name"]];
    [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"logo"]]] placeholderImage:[UIImage imageNamed:@"center_img"]];
    cell.addressLa.text=[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"address"]];
    [cell.telBtn addTarget:self action:@selector(makePhone:) forControlEvents:UIControlEventTouchUpInside];
    if ([[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"detail"]] isEmptyString])
    {
        cell.shangPinJianJieLab.text = [NSString stringWithFormat:@"商家简介:%@",@"无"];
    }
    else
    {
        cell.shangPinJianJieLab.text = [NSString stringWithFormat:@"商家简介:%@",self.dataArray[indexPath.row][@"detail"]];
    }
    
    cell.telBtn.tag=10000+indexPath.row;
    return cell;
}

#pragma  mark -- 获取cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CGRect addressH = [self getStringWithFont:[UIFont systemFontOfSize:12*self.scale] withWidth:[UIScreen mainScreen].bounds.size.width - 155*self.scale withString:[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"address"]]];
    
    CGFloat height = addressH.size.height>30*self.scale?addressH.size.height:30*self.scale;
    
    ;
    return (15+20+10+20)*self.scale + height;
}
#pragma mark -- 定义区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
#pragma mark -- 定义区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    
    view.backgroundColor = superBackgroundColor;
    
    return view;
    
}
#pragma mark -- cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.hidesBottomBarWhenPushed=YES;
    if (_selectIndexRow)
    {
        _selectIndexRow(self.dataArray[indexPath.row]);
    }
    
//    BOOL issleep = [self getTimeWith:self.dataArray[indexPath.row]];
//    
//    GanXiShopViewController *gan = [GanXiShopViewController new];
//    gan.zongshuju=self.dataArray[indexPath.row];
//    
//    //    NSLog(@"%@",_dataSource[indexPath.row]);
//    //
//    if ([self.dataArray[indexPath.row][@"is_open_chat"]isEqualToString:@"2"]) {
//        gan.isOpen=NO;
//    }else{
//        gan.isOpen=YES;
//    }
//    //
//    gan.ID = self.dataArray[indexPath.row][@"id"];
//    gan.titlee=self.dataArray[indexPath.row][@"shop_name"];
//    gan.shop_user_id =self.dataArray[indexPath.row][@"shop_user_id"];
//    gan.issleep=issleep;
//    gan.gonggao=self.dataArray[indexPath.row][@"notice"];
//    
//    [self.navigationController pushViewController:gan animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark -- 获取字体的高度和宽度
- (CGRect)getStringWithFont:(UIFont *)font withWidth:(CGFloat)width withString:(NSString *)string
{
    CGRect stringRect = [string boundingRectWithSize:CGSizeMake(width,2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    return stringRect;
}
#pragma mark -- 拨打商家的电话
-(void)makePhone:(UIButton *)sender{
    
    if ([[NSString stringWithFormat:@"%@",self.dataArray[sender.tag-10000][@"hotline"]] isEmptyString]) {
        [self ShowAlertWithMessage:@"该商家暂未提供电话！"];
        return;
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[NSString stringWithFormat:@"%@",self.dataArray[sender.tag-10000][@"hotline"]]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
#pragma mark -- 下拉刷新
- (void)xiala
{
    _index = 0;
    [self reshList];
}

#pragma mark -- 上拉加载 
- (void)shangla
{
    [self reshList];
}
#pragma mark -- 上拉加载请求数据
-(void)reshList{
    _index++;
    AnalyzeObject *anle = [AnalyzeObject new];
    
    NSDictionary *dic = @{@"community_id":[self getCommid],@"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],@"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]],@"pindex":[NSString stringWithFormat:@"%ld",(long)_index],@"shop_type":@"2",@"profession_class":[NSString stringWithFormat:@"%@",_IdString]};
    

    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    
    
    
    [anle shangjial:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [self.shenghuoTableView.header endRefreshing];
        [self.shenghuoTableView.footer endRefreshing];
        NSLog(@"array==%@",models);
        if ([code isEqualToString:@"0"]) {
            if (_index==1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:models];
        }else{
        }
        [self.shenghuoTableView reloadData];
        
        [self.showNothingLab removeFromSuperview];
        if (self.dataArray.count<=0) {
            self.showNothingLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
            self.showNothingLab.text=@"暂无店铺信息！";
            self.showNothingLab.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:_showNothingLab];
        }
   }];
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

@end
