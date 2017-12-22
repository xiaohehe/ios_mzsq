//
//  LiftServiceTypeViewController.m
//  MuZhiSheQu
//
//  Crearight © 2017年 apple. All rights reserved.
//ted by lt on 2017/8/16.
//  Copy

#import "LiftServiceTypeViewController.h"
#import "ShengHuoTableViewCell.h"
#import "GanXiShopViewController.h"
#import "BusinessInfoViewController.h"

@interface LiftServiceTypeViewController ()
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation LiftServiceTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNav];
    [self setTableView];
    self.dataArray = [NSMutableArray new];
    self.index = 0;
    [self reshList];
    //self.view.backgroundColor=[UIColor blueColor];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=self.type;
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    //    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom-.5, self.view.width, .5)];
    topline.backgroundColor=blackLineColore;
    [self.NavImg addSubview:topline];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----------表视图
-(void)setTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.bounds.size.height-self.NavImg.bottom) style:UITableViewStylePlain];
    //    self.view.bounds.size.height-100-100/2.25*self.scale-58*self.scale
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    //self.tableView.backgroundColor=[UIColor redColor];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ShengHuoTableViewCell class] forCellReuseIdentifier:@"cell"];
    //[self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
    //[self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    self.tableView.footer.automaticallyRefresh = NO;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShengHuoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
        cell = [[ShengHuoTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.titleLa.text=[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"ShopName"]];
    [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"Logo"]]] placeholderImage:[UIImage imageNamed:@"center_img"]];
    cell.addressLa.text=[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"Address"]];
    [cell.telBtn addTarget:self action:@selector(makePhone:) forControlEvents:UIControlEventTouchUpInside];
    if ([[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"detail"]] isEmptyString]){
        cell.shangPinJianJieLab.text = [NSString stringWithFormat:@"商家简介:%@",@"无"];
    }else{
        cell.shangPinJianJieLab.text = [NSString stringWithFormat:@"商家简介:%@",self.dataArray[indexPath.row][@"detail"]];
    }
    cell.telBtn.tag=10000+indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma  mark -- 获取cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*self.scale;
}

#pragma mark -- cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.hidesBottomBarWhenPushed=YES;
//    if (_selectIndexRow){
//        _selectIndexRow(self.dataArray[indexPath.row]);
//    }
        //BOOL issleep = [self getTimeWith:self.dataArray[indexPath.row]];
        BusinessInfoViewController *shopInfo = [BusinessInfoViewController new];
        shopInfo.shop_id=self.dataArray[indexPath.row][@"ID"];
        shopInfo.shop_id=self.dataArray[indexPath.row][@"ID"];
        [self.navigationController pushViewController:shopInfo animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    
//    self.hidesBottomBarWhenPushed=YES;
//    BOOL issleep = [self getTimeWith:dic];
//    
//    GanXiShopViewController *gan = [GanXiShopViewController new];
//    gan.zongshuju=dic;
//    
//    //    NSLog(@"%@",_dataSource[indexPath.row]);
//    //
//    if ([dic[@"is_open_chat"]isEqualToString:@"2"]) {
//        gan.isOpen=NO;
//    }else{
//        gan.isOpen=YES;
//    }
//    //
//    gan.ID = dic[@"id"];
//    gan.titlee=dic[@"shop_name"];
//    gan.shop_user_id =dic[@"shop_user_id"];
//    gan.issleep=issleep;
//    gan.gonggao=dic[@"notice"];
//    [self.navigationController pushViewController:gan animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
}

#pragma mark -- 获取字体的高度和宽度
- (CGRect)getStringWithFont:(UIFont *)font withWidth:(CGFloat)width withString:(NSString *)string
{
    CGRect stringRect = [string boundingRectWithSize:CGSizeMake(width,2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    return stringRect;
}
#pragma mark -- 拨打商家的电话
-(void)makePhone:(UIButton *)sender{
    if ([[NSString stringWithFormat:@"%@",self.dataArray[sender.tag-10000][@"ContactMobile"]] isEmptyString]) {
        [self ShowAlertWithMessage:@"该商家暂未提供电话！"];
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[NSString stringWithFormat:@"%@",self.dataArray[sender.tag-10000][@"ContactMobile"]]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark -- 下拉刷新
- (void)xiala{
    _index = 0;
    self.tableView.footer.state = MJRefreshFooterStateIdle;
    [self reshList];
}

#pragma mark -- 上拉加载
- (void)shangla{
    [self reshList];
}

#pragma mark -- 上拉加载请求数据
-(void)reshList{
    //_index++;
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"communityid":[self getCommid],@"pindex":[NSString stringWithFormat:@"%ld",(long)_index],@"serverid":[NSString stringWithFormat:@"%@",_typeID]};
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    [anle shangjial:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        NSLog(@"array==%@==%@",dic,models);
        if ([code isEqualToString:@"0"]) {
            if (_index==1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:models];
        }else{
        }
        [self.tableView reloadData];
        if (self.dataArray.count<=0) {
            if(_index==1){
                self.showNothingLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
                self.showNothingLab.text=@"暂无店铺信息！";
                self.showNothingLab.textAlignment=NSTextAlignmentCenter;
                [self.view addSubview:_showNothingLab];
            }else if(models==nil){
              self.tableView.footer.state = MJRefreshFooterStateNoMoreData;
            }
        }
    }];
}

@end
