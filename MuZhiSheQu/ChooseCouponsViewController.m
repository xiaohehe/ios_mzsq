//
//  ChooseCouponsViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChooseCouponsViewController.h"
#import "CouponsTableViewCell.h"

@interface ChooseCouponsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)BOOL isUsable;
@property(nonatomic,strong)UIButton *usableBtn;
@property(nonatomic,strong)UIView *usableFlag;
@property(nonatomic,strong)UIButton *disabledBtn;
@property(nonatomic,strong)UIView *disabledFlag;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) NSMutableArray* usableArray;//
@property(nonatomic,strong) NSMutableArray* disabledArray;//
@property(nonatomic,copy)NSString * shopId;
@property(nonatomic,strong) UIControl* otherBtn;
@property(nonatomic,assign)NSInteger current;
@end

@implementation ChooseCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"couponID==%d",[_couponID integerValue]);
    [self newNav];
    _current=-1;
    _isUsable=YES;
    _usableArray=[[NSMutableArray alloc]init];
    _disabledArray=[[NSMutableArray alloc]init];
    [self setHeadlineView];
    [self newListView];
    [self setBottomView];
    [self.view addSubview:self.activityVC];
    [self reshData];
}

-(void) setBottomView{
    _otherBtn=[[UIControl alloc]initWithFrame:CGRectMake(0, self.view.height-(49+self.dangerAreaHeight), self.view.width, 49+self.dangerAreaHeight)];
    _otherBtn.backgroundColor=[UIColor whiteColor];
    [_otherBtn addTarget:self action:@selector(noCoupons) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_otherBtn];
    UILabel* bottomLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 49)];
    bottomLb.text=@"不使用优惠券";
    bottomLb.textAlignment=NSTextAlignmentCenter;
    bottomLb.textColor=[UIColor blackColor];
    [_otherBtn addSubview:bottomLb];
}

-(void)reshData{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    _shopId= [[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"];
    NSDictionary *dic = @{@"shopid":self.shopId,@"money":self.money};
    [anle getMyCouponWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"getMyCouponWithDic==%@",models);
            NSArray *array=models;
            for (NSDictionary* obj in array) {
                NSString* isCanUse=[NSString stringWithFormat:@"%@",obj[@"IsCanUse"]];
                if([isCanUse isEqualToString:@"1"]){
                    [_usableArray addObject:obj];
                }else{
                    [_disabledArray addObject:obj];
                }
            }
            [_usableBtn setTitle:[NSString stringWithFormat:@"可用优惠券(%lu)",_usableArray.count] forState:UIControlStateNormal];
            [_disabledBtn setTitle:[NSString stringWithFormat:@"不可用优惠券(%lu)",_disabledArray.count] forState:UIControlStateNormal];
            [_tableView reloadData];
        }else{
            [self ShowAlertWithMessage:msg];
        }
    }];
}

-(void) newListView{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom+35*self.scale, self.view.frame.size.width,self.view.height-self.NavImg.height-(49+self.dangerAreaHeight)-40*self.scale)];
    [_tableView registerClass:[CouponsTableViewCell class] forCellReuseIdentifier:@"CouponsTableViewCell"];
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) setHeadlineView{
    UIView* headView=[[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 30*self.scale)];
    headView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headView];
    _usableBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width/2, 28*self.scale)];
    [headView addSubview:_usableBtn];
    [_usableBtn setTitle:@"可用优惠券" forState:UIControlStateNormal];
    [_usableBtn setTitleColor:[UIColor colorWithRed:0.310 green:0.310 blue:0.310 alpha:1.00] forState:UIControlStateNormal];
    [_usableBtn addTarget:self action:@selector(cutUsadle) forControlEvents:UIControlEventTouchUpInside];
    CAGradientLayer *gradientLayer=[CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:1.000 green:0.925 blue:0.000 alpha:1.00].CGColor, (__bridge id)[UIColor colorWithRed:0.996 green:0.800 blue:0.000 alpha:1.00].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame =CGRectMake(0, 0, 100*self.scale, 2*self.scale);
    
    _usableFlag=[[UIView alloc]initWithFrame:CGRectMake(self.view.width/4-50*self.scale, _usableBtn.bottom, 100*self.scale, 2*self.scale)];
    [_usableFlag.layer insertSublayer:gradientLayer atIndex:0];
    [headView addSubview:_usableFlag];

    _disabledBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2, 0, self.view.width/2, 28*self.scale)];
    [headView addSubview:_disabledBtn];
    [_disabledBtn setTitle:@"不可用优惠券" forState:UIControlStateNormal];
    [_disabledBtn setTitleColor:[UIColor colorWithRed:0.310 green:0.310 blue:0.310 alpha:1.00] forState:UIControlStateNormal];
     [_disabledBtn addTarget:self action:@selector(cutDisabled) forControlEvents:UIControlEventTouchUpInside];
    _disabledFlag=[[UIView alloc]initWithFrame:CGRectMake(self.view.width/4*3-50*self.scale, _disabledBtn.bottom, 100*self.scale, 2*self.scale)];
    CAGradientLayer *gradientLayer2=[CAGradientLayer layer];
    gradientLayer2.colors = @[(__bridge id)[UIColor colorWithRed:1.000 green:0.925 blue:0.000 alpha:1.00].CGColor, (__bridge id)[UIColor colorWithRed:0.996 green:0.800 blue:0.000 alpha:1.00].CGColor];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1.0, 0);
    gradientLayer2.frame =CGRectMake(0, 0, 100*self.scale, 2*self.scale);
    [_disabledFlag.layer insertSublayer:gradientLayer2 atIndex:0];
    [headView addSubview:_disabledFlag];
    [self cutFlag];
}

-(void) cutFlag{
    if(_isUsable){
        _usableFlag.hidden=NO;
        _disabledFlag.hidden=YES;
    }else{
        _usableFlag.hidden=YES;
        _disabledFlag.hidden=NO;
    }
}

-(void)cutUsadle{
    if(_isUsable)
        return;
    _isUsable=YES;
    [self cutFlag];
    [self.tableView reloadData];
}

-(void)cutDisabled{
    if(!_isUsable)
        return;
    _isUsable=NO;
    [self cutFlag];
    [self.tableView reloadData];
}

-(void)newNav{
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    self.TitleLabel.text=@"选择优惠券";
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
    if(_isUsable)
        return [_usableArray count];
    else
        return [_disabledArray count];
}

#pragma mark -数据源方法
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponsTableViewCell *cell=[CouponsTableViewCell cellWithTableView:tableView];
    NSString* priceString=@"";
    NSString* couponName=@"";
    NSString* describe=@"";
    if(_isUsable){
        [cell.statusIv setImage:[UIImage imageNamed:@"discount_coupon"]];
        priceString = [NSString stringWithFormat:@"￥%@",_usableArray[indexPath.row][@"Money"]];
        couponName = [NSString stringWithFormat:@"%@",_usableArray[indexPath.row][@"CouponName"]];
        describe = [NSString stringWithFormat:@"%@",_usableArray[indexPath.row][@"Describe"]];
        cell.selectedIv.hidden=NO;
        NSString* couponID=[NSString stringWithFormat:@"%@",_usableArray[indexPath.row][@"CouponID"]];
        if([couponID isEqualToString:self.couponID]){
            _current=indexPath.row;
            [cell.selectedIv setImage:[UIImage imageNamed:@"na10"]];
        }else{
            [cell.selectedIv setImage:[UIImage imageNamed:@"na9"]];
        }
    }else{
        [cell.statusIv setImage:[UIImage imageNamed:@"discount_coupon_gray"]];
        priceString = [NSString stringWithFormat:@"￥%@",_disabledArray[indexPath.row][@"Money"]];
        couponName = [NSString stringWithFormat:@"%@",_disabledArray[indexPath.row][@"CouponName"]];
        describe = [NSString stringWithFormat:@"%@",_disabledArray[indexPath.row][@"Describe"]];
        cell.selectedIv.hidden=YES;
    }
    NSString *firstString = @"￥";
    NSMutableAttributedString * priceAttributeString = [[NSMutableAttributedString alloc]initWithString:priceString];
    [priceAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10*self.scale] range:NSMakeRange(0, firstString.length)];
    cell.priceLa.attributedText = priceAttributeString;
    cell.nameLa.text=couponName;
    cell.desLb.text=describe;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_isUsable)
        return;
    if(_current!=indexPath.row){
        NSMutableArray* valueArray=[NSMutableArray array];
        [valueArray addObject:@"success"];
        [valueArray addObject:_usableArray[indexPath.row]];
        [_delegate passValue:valueArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)noCoupons{
    NSMutableArray* valueArray=[NSMutableArray array];
    [valueArray addObject:@"success"];
    [valueArray addObject:[NSMutableDictionary dictionary]];
    [_delegate passValue:valueArray];
    [self.navigationController popViewControllerAnimated:YES];
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
