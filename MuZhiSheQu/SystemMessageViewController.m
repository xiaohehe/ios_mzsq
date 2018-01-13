//
//  SystemMessageViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2018/1/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SystemMessageTableViewCell.h"
#import "AppUtil.h"

@interface SystemMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) NSMutableArray* dataSource;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *la;
@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource=[NSMutableArray new];
    self.view.backgroundColor=[UIColor colorWithRed:0.953 green:0.957 blue:0.965 alpha:1.00];
    [self newNav];
    [self newView];
    _index=0;
    [self reshData];
}

-(void)reshData{
    if(_la)
        [_la removeFromSuperview];
    _index++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    AnalyzeObject *anle =[AnalyzeObject new];
    NSString* shop_id= [[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"];
    NSDictionary *dic = @{@"shopid":shop_id,@"pindex":index};
    [anle getMessagesWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        NSLog(@"getMessagesWithDic==%@",models);
        [self.activityVC stopAnimate];
        if (_index==1) {
            [_dataSource removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {
            if(models==nil){
                self.tableView.footer.state = MJRefreshFooterStateNoMoreData;
            }else{
                [_dataSource addObjectsFromArray:models];
            }
        }
        if (_dataSource.count<=0&&_index==1) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
            _la.text=@"暂无系统消息！";
            _la.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:_la];
        }
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

-(void)footr{
    [self reshData];
}

-(void)headr{
    _index=0;
    self.tableView.footer.state = MJRefreshFooterStateIdle;
    [self reshData];
}

-(void)newView{
    _tableView=[[UITableView  alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[SystemMessageTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footr)];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headr)];
    [self.view addSubview:_tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)newNav{
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    self.TitleLabel.text=@"系统消息";
    self.TitleLabel.font =[UIFont systemFontOfSize:15*self.scale];
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.height-.5, self.view.width, .5)];
    bottomLine.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [self.NavImg addSubview:bottomLine];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*self.scale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self ShowAlertWithMessage:_dataSource[indexPath.row][@"MsgContent"]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemMessageTableViewCell *cell=(SystemMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary* dic=_dataSource[indexPath.row];
    cell.timeLb.text=[AppUtil postSendTime3:dic[@"AddTime"]];
    cell.titleLa.text=dic[@"MsgTitle"];
    cell.contentLb.text=dic[@"MsgContent"];
    return cell;
}

@end
