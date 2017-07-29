//
//  WuYeZhongXinViewController.m
//  MuZhiSheQu
//
//  Created by apple on 17/3/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "WuYeZhongXinViewController.h"
#import "WuYeTableViewCell.h"
#import "UITabBar+badge.h"
#import "ScrollViewController.h"
#import "SolveRedViewController.h"
@interface WuYeZhongXinViewController ()<UITableViewDataSource,UITableViewDelegate,WuYeTableViewCellDelegate>
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,retain)UITableView * wuyetableView;
@property (nonatomic,retain)UILabel * la;
@property (nonatomic,retain)NSMutableArray * data;
@property (nonatomic,retain)NSMutableDictionary * community_infoDic;
@property (nonatomic,retain)ScrollViewController * scrollVC;

@end

@implementation WuYeZhongXinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _data = [NSMutableArray new];
    _community_infoDic = [NSMutableDictionary new];
//    _index = 1;
    [self createDaoHang];
    [self createTableView];
    [self reshData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -- 设置导航
- (void)createDaoHang{
    self.TitleLabel.text = @"物业中心";
    UIButton * wuYeTelBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - self.TitleLabel.height/60*144,self.TitleLabel.top, self.TitleLabel.height/60*144, self.TitleLabel.height)];
    [wuYeTelBtn setImage:[UIImage imageNamed:@"wuyeCall"] forState:(UIControlStateNormal)];
    [wuYeTelBtn setTitle:@"呼叫物业" forState:(UIControlStateNormal)];
    wuYeTelBtn.titleLabel.font = [UIFont systemFontOfSize:13*self.scale];
    [wuYeTelBtn addTarget:self action:@selector(callWuYe) forControlEvents:(UIControlEventTouchUpInside)];
    [wuYeTelBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [wuYeTelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
//    wuYeTelBtn.backgroundColor = [UIColor redColor];
    [self.NavImg addSubview:wuYeTelBtn];
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 创建tabelView
- (void)createTableView{
    _wuyetableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 ) style:(UITableViewStylePlain)];
    _wuyetableView.delegate = self;
    _wuyetableView.dataSource =self;
    _wuyetableView.separatorColor = [UIColor clearColor];
    [_wuyetableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
    [_wuyetableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    [self.view addSubview:_wuyetableView];
}

#pragma mark -- tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WuYeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[WuYeTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    if (indexPath.row == _data.count - 1)
    {
        cell.lin.hidden = YES;
    }
    else
    {
        cell.lin.hidden = NO;
    }
    NSDictionary * dataDic = _data[indexPath.row];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.titleString = dataDic[@"title"];
    cell.contentString = dataDic[@"content"];
    cell.pictureArray = dataDic[@"imgs"];
    cell.pictureNumber =  cell.pictureArray.count;
    cell.timeLab.text = dataDic[@"create_time"];
    cell.indexPath = indexPath;
    cell.delegate = self;
    NSLog(@"%@",self.community_infoDic);
    NSLog(@"%@",dataDic[@"content"]);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect titleRect = [self getStringWithFont:15*self.scale withString:_data[indexPath.row][@"title"] withWith:2000];
    CGRect contentRect = [self getStringWithFont:14*self.scale withString:_data[indexPath.row][@"content"] withWith:[UIScreen mainScreen].bounds.size.width - 20*self.scale];
    NSMutableArray * picarray = _data[indexPath.row][@"imgs"];
    NSInteger number = ceil(picarray.count/3.0);
    CGRect timeRect = [self getStringWithFont:12*self.scale withString:_data[indexPath.row][@"create_time"] withWith:2000];
    
    return 20*self.scale + titleRect.size.height + contentRect.size.height + number*(([UIScreen mainScreen].bounds.size.width-40*self.scale)/3*0.75+10*self.scale)+timeRect.size.height + 20*self.scale;
}

-(void)shangla{
    
    [self reshData];
}
-(void)xiala{
    
    _index=0;
    [self reshData];
    
}
-(void)reshData{
    [self.activityVC startAnimate];
    
    _index++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    AnalyzeObject *anle = [AnalyzeObject new];
//    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    
    
    NSDictionary *dic = @{@"pindex":index,@"community_id":self.commid};
    [anle wuyYeZhongxin:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if (_index==1) {
            [_data removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {
            
            [_data addObjectsFromArray:models[@"notice_list"]];
            [_community_infoDic removeAllObjects];
//            [_community_infoArray addObjectsFromArray:models[@"community_info"]];
            [self.community_infoDic addEntriesFromDictionary:models[@"community_info"]];
            
            NSInteger hunm = [[[NSUserDefaults standardUserDefaults]objectForKey:@"wuyeNum"] integerValue];
            
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)hunm] forKey:@"wuyeNum"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            

          
//            NSLog(@"%@",_data);
        }
        
        if (_la) {
            [_la removeFromSuperview];
            _la=nil;
        }
        if (_data.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-self.NavImg.bottom)];
            _la.text=@"暂无公告信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            [_wuyetableView addSubview:_la];
        }
        [_wuyetableView reloadData];
        [_wuyetableView.header endRefreshing];
        [_wuyetableView.footer endRefreshing];
        
    }];
}
- (void)BigImageTableViewCellWith:(NSIndexPath *)indexPath ImageIndex:(NSInteger)index
{
//    _scrollVC = [[ScrollViewController alloc] init];
//    _scrollVC.imgArr = _data[indexPath.row][@"imgs"];
//    _scrollVC.index = index;
//    [_scrollVC newScrollV];
//    
//    [_scrollVC getScrollVBlock:^(NSString *str) {
//        
//        [UIView animateWithDuration:.3 animations:^{
//            
//            _scrollVC.view.alpha = 0;
//            
//        }completion:^(BOOL finished) {
//            
//            [_scrollVC.view removeFromSuperview];
//            _scrollVC= nil;
//        }];
//        
//    }];
////    [self presentViewController:_scrollVC animated:NO completion:nil];
//    [self.view addSubview:_scrollVC.view];
////    NSMutableArray *a = [NSMutableArray new];
////        [self setHidesBottomBarWhenPushed:YES];
//    
////    for (int i=0; i<9; i++) {
////        NSString *str = [NSString stringWithFormat:@"img%d",i+1];
////        NSString *na = _data[indexPath.row][str];
////        if (![na isEqualToString:@""]) {
////            [a addObject:na];
////        }
////    }
//
    SolveRedViewController *sole = [SolveRedViewController new];
    sole.data=_data[indexPath.row][@"imgs"];
    sole.index=index;
    [self presentViewController:sole animated:NO completion:nil];
    
}
- (void)callWuYe
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.community_infoDic[@"tel"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
