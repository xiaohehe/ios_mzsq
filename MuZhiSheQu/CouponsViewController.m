//
//  CouponsViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CouponsViewController.h"
#import "CouponsTableViewCell.h"

@interface CouponsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) NSMutableArray* dataArray;
@property(nonatomic,copy)NSString * shopId;
@end

@implementation CouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[[NSMutableArray alloc]init];
    [self newNav];
    [self newListView];
    [self.view addSubview:self.activityVC];
    [self reshData];
}


-(void)reshData{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    _shopId= [[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"];
    NSDictionary *dic = @{@"shopid":self.shopId};
    [anle getMyCouponWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"getMyCouponWithDic==%@",models);
            [_dataArray addObjectsFromArray:models];
            [_tableView reloadData];
        }else{
            [self ShowAlertWithMessage:msg];
        }
    }];
}

-(void) newListView{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.frame.size.width,self.view.height-self.NavImg.height)];
    [_tableView registerClass:[CouponsTableViewCell class] forCellReuseIdentifier:@"CouponsTableViewCell"];
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)newNav{
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    self.TitleLabel.text=@"我的优惠券";
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
    return 70*self.scale;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

#pragma mark -数据源方法
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponsTableViewCell *cell=[CouponsTableViewCell cellWithTableView:tableView];
    [cell.statusIv setImage:[UIImage imageNamed:@"discount_coupon"]];
    NSString* priceString= [NSString stringWithFormat:@"￥%@",_dataArray[indexPath.row][@"Money"]];
    NSString* couponName = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"CouponName"]];
    NSString* describe = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"Describe"]];
    cell.selectedIv.hidden=YES;
    NSString * firstString = @"￥";
    NSMutableAttributedString * priceAttributeString = [[NSMutableAttributedString alloc]initWithString:priceString];
    [priceAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10*self.scale] range:NSMakeRange(0, firstString.length)];
    cell.priceLa.attributedText = priceAttributeString;
    cell.nameLa.text=couponName;
    cell.desLb.text=describe;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
