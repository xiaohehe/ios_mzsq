//
//  OrderFileViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/12/19.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "OrderFileViewController.h"
#import "UmengCollection.h"
@interface OrderFileViewController ()

@end

@implementation OrderFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newView];
    [self returnVi];
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
    bigVi.size = CGSizeMake(260*self.scale, 200*self.scale);
    bigVi.center=self.view.center;
    bigVi.centerY=bigVi.centerY-50*self.scale;
    [self.view addSubview:bigVi];
    //bigVi.backgroundColor=[UIColor redColor];
    bigVi.centerY=self.NavImg.bottom+bigVi.height/2+50*self.scale;
    
    UILabel *gongxi = [[UILabel alloc]initWithFrame:CGRectMake(bigVi.width/2-40*self.scale, 10*self.scale, 70*self.scale, 20*self.scale)];
    gongxi.text = @"支付失败！";
    gongxi.textAlignment=NSTextAlignmentCenter;
    gongxi.font=[UIFont fontWithName:@"Helvetica-Bold" size:14*self.scale];
    [bigVi addSubview:gongxi];
//    [gongxi sizeToFit];
    gongxi.centerX=bigVi.width/2;
    
    //gongxi.backgroundColor=[UIColor blueColor];
    UIImageView *dui = [[UIImageView alloc]initWithFrame:CGRectMake(gongxi.left-30*self.scale, 8*self.scale, 20*self.scale, 20*self.scale)];
    dui.image = [UIImage imageNamed:@"fu_no"];
    [bigVi addSubview:dui];
    
//    
//    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(gongxi.left, gongxi.bottom+10*self.scale, self.view.width, 20*self.scale)];
//    price.font=[UIFont fontWithName:@"Helvetica-Bold" size:12*self.scale];
//    price.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"付款金额：￥%@ ",self.price] redString:[NSString stringWithFormat:@"￥%@ ",self.price]];
//    [bigVi addSubview:price];
    
    UILabel *help = [[UILabel alloc]initWithFrame:CGRectMake(dui.left, dui.bottom+10*self.scale, 40*self.scale, 20*self.scale)];
    help.font=SmallFont(self.scale);
    help.text = [NSString stringWithFormat:@"您可以"];
    [bigVi addSubview:help];
    
    
    
    UIButton *chakan = [[UIButton alloc]initWithFrame:CGRectMake(help.right+0*self.scale, help.top, 100*self.scale, 20*self.scale)];
    [chakan setTitle:@"查看已买到得宝贝" forState:UIControlStateNormal];
    chakan.titleLabel.textColor=[UIColor blackColor];
    chakan.titleLabel.font=SmallFont(self.scale);
    [chakan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [chakan addTarget:self action:@selector(chakan) forControlEvents:UIControlEventTouchUpInside];
    [bigVi addSubview:chakan];
    
    
    
    
    UIButton *jixu = [[UIButton alloc]initWithFrame:CGRectMake(bigVi.width/2-90*self.scale, help.bottom+10*self.scale, 80*self.scale, 30*self.scale)];
    jixu.backgroundColor=blueTextColor;
    jixu.layer.cornerRadius=4;
    [jixu setTitle:@"继续购物" forState:UIControlStateNormal];
    jixu.titleLabel.font=DefaultFont(self.scale);
    [jixu addTarget:self action:@selector(jixu) forControlEvents:UIControlEventTouchUpInside];
    
    [bigVi addSubview:jixu];
    
    
    UIButton *huodao = [[UIButton alloc]initWithFrame:CGRectMake(jixu.right+20*self.scale, help.bottom+10*self.scale, 80*self.scale, 30*self.scale)];
    [huodao setTitle:@"返回首页" forState:UIControlStateNormal];
    huodao.layer.cornerRadius=4;
    huodao.layer.borderColor=blackLineColore.CGColor;
    huodao.layer.borderWidth=.5;
    [huodao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    huodao.titleLabel.font=DefaultFont(self.scale);
    [huodao addTarget:self action:@selector(huodao) forControlEvents:UIControlEventTouchUpInside];
    [bigVi addSubview:huodao];
    
    
    
}

-(void)chakan{
    self.hidesBottomBarWhenPushed=YES;
    ShopLingShouViewController *shop = [ShopLingShouViewController new];
    shop.ispop=NO;
    [self.navigationController pushViewController:shop animated:YES];
    
    
}

-(void)huodao{
    self.tabBarController.selectedIndex=0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


-(void)jixu{
    
    self.tabBarController.selectedIndex=1;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
//    NSInteger num = self.navigationController.viewControllers.count;
//    
//    UIViewController *viewCtl = self.navigationController.viewControllers[num-4];
//    
//    [self.navigationController popToViewController:viewCtl animated:YES];
}

#pragma mark -----返回按钮
-(void)returnVi{
    
    
    self.TitleLabel.text = @"支付失败";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
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
