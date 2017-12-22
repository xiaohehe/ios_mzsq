//
//  WindowShoppingViewController.m
//  MuZhiSheQu
//  逛街
//  Created by lt on 2017/11/28.
//  Copyright © 2017年 apple. All rights reserved.
//
#import "MerchantTableViewCell.h"
#import "WindowShoppingViewController.h"
#import "AppUtil.h"
#import "BreakInfoViewController.h"

@interface WindowShoppingViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView* tableView;
    NSMutableArray *data;
    UILabel* la;
}
@end

@implementation WindowShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    data=[[NSMutableArray alloc]init];
    [self newNav];
    [self newListView];
    [self reshData];
}

-(void)newListView{
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.frame.size.width,self.view.frame.size.height-self.NavImg.height)];
    [tableView registerClass:[MerchantTableViewCell class] forCellReuseIdentifier:@"GoodsTableViewCell"];
    tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tableView];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)reshData{
    AnalyzeObject *anle = [AnalyzeObject new];
    NSString *commid =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"commid"]];
    NSDictionary *dic = @{@"communityid":commid};//@"user_id":userid,
    [anle windowShopping:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            [data addObjectsFromArray:models];
        }
        NSLog(@"windowShopping==%@",models);
        if ([AppUtil arrayIsEmpty:data]) {
            la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
            la.text=@"收货地址是空的，你可以添加新的收货地址";
            la.textAlignment=NSTextAlignmentCenter;
            la.font=DefaultFont(self.scale);
            la.alpha=.6;
            [self.view addSubview:la];
        }
        [tableView reloadData];
    }];
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"逛街";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    //    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.height-.5, self.view.width, .5)];
    topline.backgroundColor=blackLineColore;
    [self.NavImg addSubview:topline];
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
    return 100*self.scale;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MerchantTableViewCell *cell=[MerchantTableViewCell cellWithTableView:tableView];
    NSDictionary* shop=data[indexPath.row];
    [cell.headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",shop[@"ShopZhaopai"]]] placeholderImage:[UIImage imageNamed:@"za"]];
    cell.nameLa.text=shop[@"ShopName"];
    cell.summaryLb.text=shop[@"Summary"];
    cell.addressLa.text=shop[@"Address"];
    cell.noticeLb.text=shop[@"Notice"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* shop=data[indexPath.row];
    BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
    info.remindDic=shop;
    info.isHide=YES;
    info.shop_id=shop[@"ShopID"];
    info.ID=shop[@"ShopID"];
    [self.navigationController pushViewController:info animated:YES];
}


@end
