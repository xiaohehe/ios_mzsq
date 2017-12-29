//
//  MyOrderViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MuZhiSheQu-Swift.h"
#import "SubOrderViewController.h"

@interface MyOrderViewController ()
@property(nonatomic,strong)LPSliderView *sliderView;
@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor yellowColor];
    [self newNav];
    [self newView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)newView{
    SubOrderViewController* allOrder=[[SubOrderViewController alloc]initWithType:@"5"];
    SubOrderViewController* obligationOrder=[[SubOrderViewController alloc]initWithType:@"1"];
    SubOrderViewController* waitOrder=[[SubOrderViewController alloc]initWithType:@"3"];
    SubOrderViewController* finishOrder=[[SubOrderViewController alloc]initWithType:@"4"];
    SubOrderViewController* cancelOrder=[[SubOrderViewController alloc]initWithType:@"6"];
    [self addChildViewController:allOrder];
    [self addChildViewController:obligationOrder];
    [self addChildViewController:waitOrder];
    [self addChildViewController:finishOrder];
    [self addChildViewController:cancelOrder];
    CGRect listFrame=CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom);
    NSArray* titles=[NSArray arrayWithObjects:@"全部", @"待付款", @"待收货", @"已完成", @"已取消", nil];
    NSArray* contentViews=[NSArray arrayWithObjects:[allOrder view],[obligationOrder view],[waitOrder view],[finishOrder view],[cancelOrder view], nil];
    // 初始化方式一：（推荐）
    _sliderView =[[LPSliderView alloc] initWithFrame:listFrame titles:titles contentViews:contentViews ];
    _sliderView.backgroundColor=[UIColor redColor];
    _sliderView.titleNormalColor = [UIColor colorWithRed:0.486 green:0.486 blue:0.486 alpha:1.00];
    _sliderView.titleSelectedColor = [UIColor colorWithRed:0.314 green:0.314 blue:0.314 alpha:1.00];
    _sliderView.sliderColor = [UIColor colorWithRed:1.000 green:0.816 blue:0.000 alpha:1.00];
    _sliderView.sliderWidth = 100;
    _sliderView.sliderHeight = 2;
    // 视图切换闭包回调（可选。。。）
    [_sliderView setViewChangeClosure:^(NSInteger index) {
        NSLog(@"视图切换，下标---%ld", index);
    }];
    _sliderView.selectedIndex = 0 ;// 默认选中第2个
    [ self.view addSubview:_sliderView];
}

-(void)newNav{
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    self.TitleLabel.text=@"我的订单";
    self.TitleLabel.font =[UIFont systemFontOfSize:15*self.scale];
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.height-.5, self.view.width, .5)];
    bottomLine.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [self.NavImg addSubview:bottomLine];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
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
