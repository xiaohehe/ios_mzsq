//
//  PaymentCompletionViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PaymentCompletionViewController.h"
#import "OrderDetailsViewController.h"
#import "SigningViewController.h"

@interface PaymentCompletionViewController ()
@property(nonatomic,strong)UIButton* orderBtn;
@property(nonatomic,strong)UIControl* familyCtl;
@property(nonatomic,strong)UILabel* integralLb;
@end

@implementation PaymentCompletionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self returnVi];
    UIImageView* statusIv=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.width/750*200)];
    [statusIv setImage:[UIImage imageNamed:@"pay_complete"]];
    [self.view addSubview:statusIv];
    UILabel* payTypetitleLb=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale,statusIv.bottom+15*self.scale, 60*self.scale, 15*self.scale)];
    payTypetitleLb.textColor=[UIColor colorWithRed:0.341 green:0.341 blue:0.341 alpha:1.00];
    payTypetitleLb.text=@"支付方式：";
    payTypetitleLb.font=SmallFont(self.scale*0.9);
    [self.view addSubview:payTypetitleLb];
    UILabel* payTypeLb=[[UILabel alloc]initWithFrame:CGRectMake(payTypetitleLb.right,payTypetitleLb.top, 100*self.scale, 15*self.scale)];
    payTypeLb.textColor=[UIColor colorWithRed:0.290 green:0.290 blue:0.290 alpha:1.00];
    payTypeLb.text=[self getPayType];
    payTypeLb.font=SmallFont(self.scale*0.9);
    [self.view addSubview:payTypeLb];
    
    UILabel* payPricetitleLb=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale,payTypetitleLb.bottom+5*self.scale, 60*self.scale, 15*self.scale)];
    payPricetitleLb.textColor=[UIColor colorWithRed:0.341 green:0.341 blue:0.341 alpha:1.00];
    payPricetitleLb.text=@"订单金额：";
    payPricetitleLb.font=SmallFont(self.scale*0.9);
    [self.view addSubview:payPricetitleLb];
    UILabel* payPriceLb=[[UILabel alloc]initWithFrame:CGRectMake(payPricetitleLb.right,payPricetitleLb.top, 100*self.scale, 15*self.scale)];
    payPriceLb.textColor=[UIColor colorWithRed:0.290 green:0.290 blue:0.290 alpha:1.00];
    payPriceLb.text=[NSString stringWithFormat:@"￥%@",_allMoney];
    payPriceLb.font=SmallFont(self.scale*0.9);
    [self.view addSubview:payPriceLb];
    
    UILabel* integraltitleLb=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale,payPricetitleLb.bottom+5*self.scale, 80*self.scale, 15*self.scale)];
    integraltitleLb.textColor=[UIColor colorWithRed:0.341 green:0.341 blue:0.341 alpha:1.00];
    integraltitleLb.text=@"拇指家庭积分：";
    integraltitleLb.font=SmallFont(self.scale*0.9);
    [self.view addSubview:integraltitleLb];
    _integralLb=[[UILabel alloc]initWithFrame:CGRectMake(integraltitleLb.right,integraltitleLb.top, 100*self.scale, 15*self.scale)];
    _integralLb.textColor=[UIColor colorWithRed:0.290 green:0.290 blue:0.290 alpha:1.00];
    //integralLb.text=[NSString stringWithFormat:@"%@",_integral];
    _integralLb.font=SmallFont(self.scale*0.9);
    [self.view addSubview:_integralLb];
    
    _orderBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2-80*self.scale, _integralLb.bottom+100*self.scale, 160*self.scale, 30*self.scale)];
    [_orderBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    _orderBtn.titleLabel.font=DefaultFont(self.scale);
    [_orderBtn setTitleColor:[UIColor colorWithRed:0.384 green:0.384 blue:0.384 alpha:1.00] forState:UIControlStateNormal];
    [_orderBtn addTarget:self action:@selector(skipOrderDetails) forControlEvents:UIControlEventTouchUpInside];
    _orderBtn.layer.cornerRadius=5;
    _orderBtn.layer.masksToBounds=YES;
    _orderBtn.layer.borderColor = [UIColor colorWithRed:0.384 green:0.384 blue:0.384 alpha:1.00].CGColor;
    _orderBtn.layer.borderWidth = .5;
    [self.view addSubview:_orderBtn];
    [self orderFinish];
    //[self setFamilyView];
}

-(void)orderFinish{
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    NSDictionary *dic = @{@"orderid":_orderID};
    [analy orderFinishWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        NSLog(@"orderFinis==%@",models);
        if ([code isEqualToString:@"0"]) {
            NSString* myfamily=[NSString stringWithFormat:@"%@",models[@"myfamily"]];
            if([myfamily isEqualToString:@"0"]){
                [self setFamilyView];
                _integralLb.text=@"无";
            }else{
                _integralLb.text=[NSString stringWithFormat:@"%@",models[@"Integral"]];
            }
        }
    }];
}

-(void)setFamilyView{
    _familyCtl=[[UIControl alloc]initWithFrame:CGRectMake(0, _orderBtn.top-80*self.scale, self.view.width, 25*self.scale)];
    [_familyCtl addTarget:self action:@selector(skipFamily) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_familyCtl];
    UIImageView* topLine=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 0, self.view.width-20*self.scale, .5)];
    [topLine setImage:[UIImage imageNamed:@"imaginary_line"]];
    [_familyCtl addSubview:topLine];
    UIImageView* bottomLine=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, _familyCtl.bottom-.5, self.view.width-20*self.scale, .5)];
    [bottomLine setImage:[UIImage imageNamed:@"imaginary_line"]];
    [_familyCtl addSubview:bottomLine];
    
    UILabel* desLb=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale,5*self.scale, self.view.width-80*self.scale, 15*self.scale)];
    desLb.textColor=[UIColor colorWithRed:0.624 green:0.624 blue:0.624 alpha:1.00];
    desLb.text=@"您还没有加入拇指家庭，无法获得家庭积分";
    desLb.font=SmallFont(self.scale*0.8);
    [_familyCtl addSubview:desLb];
    
    UILabel* familyLb=[[UILabel alloc]initWithFrame:CGRectMake(self.view.width-60*self.scale,5*self.scale, 50*self.scale, 15*self.scale)];
    familyLb.textColor=[UIColor colorWithRed:0.624 green:0.624 blue:0.624 alpha:1.00];
    familyLb.text=@"拇指家庭";
    familyLb.textAlignment=NSTextAlignmentCenter;
    familyLb.font=SmallFont(self.scale*0.8);
    
    familyLb.layer.cornerRadius=7.5*self.scale;
    familyLb.layer.masksToBounds=YES;
    familyLb.layer.borderColor =[UIColor colorWithRed:0.592 green:0.592 blue:0.592 alpha:1.00].CGColor;
    familyLb.layer.borderWidth = 1;
    
    [_familyCtl addSubview:familyLb];
}

-(void)skipFamily{
    SigningViewController* signingViewController=[[SigningViewController alloc] init];
    signingViewController.hidesBottomBarWhenPushed=YES;
    signingViewController.isToRoot=YES;
    [self.navigationController pushViewController:signingViewController animated:YES];
}

-(void)skipOrderDetails{
    OrderDetailsViewController* details=[[OrderDetailsViewController alloc] init];
    details.hidesBottomBarWhenPushed=YES;
    details.isToRoot=YES;
    details.orderId =_orderID;
    details.subOrderId =@"";
    [self.navigationController pushViewController:details animated:YES];
}

-(NSString*)getPayType{
    if([_payType isEqualToString:@"2"])
        return @"微信支付";
    else if([_payType isEqualToString:@"1"])
        return @"支付宝支付";
    else
        return @"货到付款";
}

#pragma mark -----返回按钮
-(void)returnVi{
    self.TitleLabel.text = @"订单支付完成";
    UIButton* finishBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-50*self.scale, self.TitleLabel.top, 40*self.scale, self.TitleLabel.height)];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:grayTextColor forState:(UIControlStateNormal)];
    finishBtn.titleLabel.font=DefaultFont(self.scale);
    [finishBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:finishBtn];
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
