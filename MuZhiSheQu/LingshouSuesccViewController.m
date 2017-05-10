
//
//  LingshouSuesccViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LingshouSuesccViewController.h"
#import "UmengCollection.h"

@interface LingshouSuesccViewController ()

@end

@implementation LingshouSuesccViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
    [self newView];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

-(void)newView{
    
    UIView *bigVi = [[UIView alloc]initWithFrame:self.view.bounds];
    bigVi.size = CGSizeMake(260, 200);
    bigVi.center=self.view.center;
    bigVi.centerY=bigVi.centerY-50;
    [self.view addSubview:bigVi];
    bigVi.centerY=self.NavImg.bottom+bigVi.height/2+50*self.scale;

    
    UILabel *gongxi = [[UILabel alloc]initWithFrame:CGRectMake(0, 10*self.scale, bigVi.width, 20*self.scale)];
    gongxi.text = @"您已成功下单";
    gongxi.textAlignment=NSTextAlignmentCenter;
    gongxi.font=[UIFont fontWithName:@"Helvetica-Bold" size:14*self.scale];
    [bigVi addSubview:gongxi];
    [gongxi sizeToFit];
    gongxi.centerX=bigVi.width/2;
    
    
    UIImageView *dui = [[UIImageView alloc]initWithFrame:CGRectMake(gongxi.left-30*self.scale, 8*self.scale, 20*self.scale, 20*self.scale)];
    dui.image = [UIImage imageNamed:@"fu_ok"];
    [bigVi addSubview:dui];

    
    
    
    
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(dui.left-50*self.scale, gongxi.bottom+10*self.scale, self.view.width, 20*self.scale)];
    price.font=SmallFont(self.scale);
    price.text = [NSString stringWithFormat:@"谢谢您的下单，我们会尽快安排人员上门服务"];
    [price sizeToFit];
    price.textAlignment=NSTextAlignmentCenter;
    [bigVi addSubview:price];
    
    UILabel *help = [[UILabel alloc]initWithFrame:CGRectMake(dui.left-20*self.scale, price.bottom+10*self.scale, 50*self.scale, 20*self.scale)];
    help.font=SmallFont(self.scale);
    help.text = [NSString stringWithFormat:@"您可以"];
    [bigVi addSubview:help];
    
    
    UIButton *chakan = [[UIButton alloc]initWithFrame:CGRectMake(help.right, help.top, 80*self.scale, 20*self.scale)];
    [chakan setTitle:@"查看我的订单" forState:UIControlStateNormal];
    chakan.titleLabel.textColor=[UIColor blackColor];
    chakan.titleLabel.font=SmallFont(self.scale);
    [chakan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [chakan addTarget:self action:@selector(chakan) forControlEvents:UIControlEventTouchUpInside];
    [bigVi addSubview:chakan];
    
    
    UIButton *huodao = [[UIButton alloc]initWithFrame:CGRectMake(chakan.right+0*self.scale, help.top, 80*self.scale, 20*self.scale)];
    [huodao setTitle:@"返回首页" forState:UIControlStateNormal];
    [huodao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    huodao.titleLabel.font=SmallFont(self.scale);
    [huodao addTarget:self action:@selector(huodao) forControlEvents:UIControlEventTouchUpInside];
    [bigVi addSubview:huodao];
    
    
    
}

-(void)help{
    
    
    
}


-(void)chakan{
    self.hidesBottomBarWhenPushed=YES;
    FuWuLeiDingDanViewController *shop = [FuWuLeiDingDanViewController new];
    [self.navigationController pushViewController:shop animated:YES];
    
    
}

-(void)huodao{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


-(void)jixu{
    
    NSInteger num = self.navigationController.viewControllers.count;
    
    UIViewController *viewCtl = self.navigationController.viewControllers[num-4];
    
    [self.navigationController popToViewController:viewCtl animated:YES];
}
#pragma mark -----返回按钮
-(void)returnVi{
    
    
    self.TitleLabel.text = @"货到付款";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
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
