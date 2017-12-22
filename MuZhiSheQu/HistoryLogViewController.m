//
//  HistoryLogViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HistoryLogViewController.h"
#import "HistoryLogTableViewCell.h"

@interface HistoryLogViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) NSMutableArray* dataArray;//
@end

@implementation HistoryLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[[NSMutableArray alloc]init];
    [self newNav];
    [self newListView];
    [self reshData];
}

-(void)reshData{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"mid":self.mid};
    NSLog(@"familyOrder==%@",dic);
    [anle getFamilyExchangeLogWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"getFamilyExchangeLogWithDic==%@",models);
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:models];
            if([_dataArray count]==0){
                [self ShowAlertWithMessage:@"暂无记录"];
            }
            [_tableView reloadData];
        }else{
            [self ShowAlertWithMessage:msg];
        }
    }];
}


-(void) newListView{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.frame.size.width,self.view.height-self.NavImg.height)];
    [_tableView registerClass:[HistoryLogTableViewCell class] forCellReuseIdentifier:@"HistoryLogTableViewCell"];
    _tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"历史记录";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    //    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    UIView *botline = [[UIView alloc]initWithFrame:CGRectMake(0, [self getStartHeight]+44-.5, self.view.width, .5)];
    botline.backgroundColor=blackLineColore;
    [self.NavImg addSubview:botline];
}

-(void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*self.scale;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

#pragma mark -数据源方法
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryLogTableViewCell *cell=[HistoryLogTableViewCell cellWithTableView:tableView];
    cell.nameLb.text=_dataArray[indexPath.row][@"ProName"];
    cell.timeLb.text=_dataArray[indexPath.row][@"CreateTime"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
