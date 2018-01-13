//
//  ShoppingOffViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2018/1/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShoppingOffViewController.h"

@interface ShoppingOffViewController ()
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIImageView *logoIv;
@property(nonatomic,strong)UILabel *desLb;
@property(nonatomic,strong)UIButton *goBtn;
@end

@implementation ShoppingOffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNav];
    [self setNewView];
}

-(void)setNewView{
    _topView=[[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale, self.view.width, 120*self.scale)];
    _topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_topView];
    _logoIv=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width/2-10*self.scale, 15*self.scale, 20*self.scale, 38*self.scale)];
    [_logoIv setImage:[UIImage imageNamed:@"express_finish"]];
    [_topView addSubview:_logoIv];
    
    _desLb=[[UILabel alloc]initWithFrame:CGRectMake(0, _logoIv.bottom+15*self.scale, self.view.width, 20*self.scale)];
    _desLb.textColor=[UIColor colorWithRed:0.247 green:0.247 blue:0.247 alpha:1.00];;
    _desLb.text=@"您的快递会随您的购物订单一起送达！";
    _desLb.font=[UIFont systemFontOfSize:15];
    _desLb.textAlignment=NSTextAlignmentCenter;
    [_topView addSubview:_desLb];
    
    _goBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, _topView.bottom+15*self.scale, self.view.width-20*self.scale, 35*self.scale)];
    [_goBtn setTitle:@"去购物" forState:UIControlStateNormal];
    _goBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [_goBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _goBtn.backgroundColor=[UIColor colorWithRed:0.000 green:0.533 blue:0.961 alpha:1.00];
    _goBtn.layer.cornerRadius = 5;
    _goBtn.layer.masksToBounds = YES;
    [_goBtn addTarget:self action:@selector(goShopping) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_goBtn];
}

-(void)goShopping{
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)newNav{
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    self.TitleLabel.text=@"购物代送";
    self.TitleLabel.font =[UIFont systemFontOfSize:15*self.scale];
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.height-.5, self.view.width, .5)];
    bottomLine.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [self.NavImg addSubview:bottomLine];

}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
