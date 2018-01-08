//
//  PaymentOrderViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PaymentOrderViewController.h"
#import "orderSuessViewController.h"
//#import "HuodaoSuessViewController.h"
#import "PaymentCompletionViewController.h"

@interface PaymentOrderViewController ()
@property(nonatomic,strong)UIView *orderView;
@property(nonatomic,strong)UILabel *orderIDLb;
@property(nonatomic,strong)UILabel *orderPriceLb;
@property(nonatomic,strong)UILabel *codTitleLb;
@property(nonatomic,strong)UIControl *codCtl;
@property(nonatomic,strong)UIImageView *codIv;
@property(nonatomic,strong)UILabel *onlinePaymentTitleLb;
@property(nonatomic,strong)UIControl *weChatPayCtl;
@property(nonatomic,strong)UIImageView *weChatPayIv;
@property(nonatomic,strong)UIControl *alipayCtl;
@property(nonatomic,strong)UIImageView *alipayIv;
@property(nonatomic,assign)CGFloat bottom;
@property(nonatomic,strong)UIButton *payBtn;
@property(nonatomic,copy)NSString *payType;
@property(nonatomic,assign)float zongProce;
@property(nonatomic,strong)NSMutableDictionary *payDic;
@property(nonatomic,strong) UIView* hideView;
@end

@implementation PaymentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _zongProce=[[NSString stringWithFormat:@"%@",_orderDic[@"AllMoney"]] floatValue];
    [self newNav];
    [self setOrderView];
    [self setCODView];
    [self setOnlinePaymentView];
    [self setPayView];
}

-(void)setPayView{
    _payBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, _bottom+20*self.scale, self.view.width-30, (self.view.width-30)/710*130)];
    [_payBtn setBackgroundImage:[UIImage imageNamed:@"mzbg_btn"] forState:UIControlStateNormal];
    [_payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_payBtn];
    UILabel* payContentLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _payBtn.width, _payBtn.height)];
    payContentLb.textColor=[UIColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1.00];
    payContentLb.font=[UIFont boldSystemFontOfSize:12*self.scale];
    payContentLb.textAlignment=NSTextAlignmentCenter;
    [_payBtn addSubview:payContentLb];
    NSString* priceString = [NSString stringWithFormat:@"确认支付 ￥%@",_orderDic[@"AllMoney"]];
    NSString *firstString = @"￥";
    NSMutableAttributedString * priceAttributeString = [[NSMutableAttributedString alloc]initWithString:priceString];
    [priceAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(5, firstString.length)];
    payContentLb.attributedText = priceAttributeString;
}

-(void)payClick{
    NSMutableDictionary* param=[NSMutableDictionary dictionary];
    NSString* shop_id= [[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"];
    [param setObject:shop_id forKey:@"shopid"];
    [param setObject:_payType forKey:@"paytype"];
    [param setObject:[NSString stringWithFormat:@"%@",_orderDic[@"AllMoney"]] forKey:@"AllMoney"];
    [param setObject:[NSString stringWithFormat:@"%@",_orderDic[@"OrderID"]] forKey:@"OrderID"];
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle orderPayWithDic:param Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        NSLog(@"orderPay==%@==%@==%@==%@",param,models,code,msg);
        if ([code isEqualToString:@"0"]) {
            _payDic=models;
            if([_payType isEqualToString:@"2"]){
                if (![WXApi isWXAppInstalled]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                [self.appdelegate WXPayNewWithNonceStr:models[@"noncestr"] OrderID:models[@"order_no"] Timestamp:models[@"timestamp"] sign:models[@"sign"]complete:^(BaseResp *resp) {
                    [self.activityVC stopAnimate];
                    NSLog(@"wxresult====%d==%@",resp.errCode,resp.errStr);
                    if (resp.errCode == WXSuccess) {
                        [self suessToVi];
                    }
                }];
            }else  if([_payType isEqualToString:@"1"]){
                [self.appdelegate AliPayNewPrice:[NSString stringWithFormat:@"%.2f",_zongProce] OrderID:[NSString stringWithFormat:@"%@",models[@"order_no"]] OrderName:@"拇指社区" Sign:models[@"sign"]  OrderDescription:[NSString stringWithFormat:@"%@",models[@"order_no"]] complete:^(NSDictionary *resp) {
                    [self.activityVC stopAnimate];
                    if ([[resp objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                        [self suessToVi];
                    }
                }];
            }else{
                [self suessToVi];
            }
        }else{
            [self ShowAlertWithMessage:msg];
        }
    }];
}

-(void)suessToVi{
//    self.hidesBottomBarWhenPushed=YES;
//    orderSuessViewController *suecc = [orderSuessViewController new];
//    suecc.price = [NSString stringWithFormat:@"%.2f",_zongProce];
//    [self.navigationController pushViewController:suecc animated:YES];
    PaymentCompletionViewController *huodao = [PaymentCompletionViewController new];
    huodao.payType=@"3";
    huodao.integral=[NSString stringWithFormat:@"%@",_payDic[@"amount"]];
    huodao.allMoney=[NSString stringWithFormat:@"%@",_orderDic[@"AllMoney"]];
    huodao.orderID=[NSString stringWithFormat:@"%@",_orderDic[@"OrderID"]];
    [self.navigationController pushViewController:huodao animated:YES];
}

-(void)setOnlinePaymentView{
    CGFloat money=[[NSString stringWithFormat:@"%@",_orderDic[@"AllMoney"]] floatValue];
    if(money>0.0){
        _onlinePaymentTitleLb=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, _bottom+5*self.scale, 100*self.scale, 15*self.scale)];
        _onlinePaymentTitleLb.textColor=[UIColor colorWithRed:0.659 green:0.659 blue:0.659 alpha:1.00];
        _onlinePaymentTitleLb.font=SmallFont(self.scale*0.9);
        _onlinePaymentTitleLb.text=@"在线支付";
        [self.view addSubview:_onlinePaymentTitleLb];
        _weChatPayCtl=[[UIControl alloc]initWithFrame:CGRectMake(0, _onlinePaymentTitleLb.bottom+5*self.scale, self.view.width, 35*self.scale)];
        [_weChatPayCtl addTarget:self action:@selector(weChatPayClick) forControlEvents:UIControlEventTouchUpInside];
        _weChatPayCtl.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_weChatPayCtl];
        UIImageView* weChatPayLogoIv=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 15*self.scale, 15*self.scale)];
        [weChatPayLogoIv setImage:[UIImage imageNamed:@"wechat_pay"]];
        [_weChatPayCtl addSubview:weChatPayLogoIv];
        UILabel* titleLb=[[UILabel alloc]initWithFrame:CGRectMake(weChatPayLogoIv.right+10*self.scale, weChatPayLogoIv.top, 100*self.scale, 15*self.scale)];
        titleLb.font=DefaultFont(self.scale*0.8);
        titleLb.textColor=[UIColor colorWithRed:0.349 green:0.349 blue:0.349 alpha:1.00];
        titleLb.text=@"微信支付";
        [_weChatPayCtl addSubview:titleLb];
        _weChatPayIv=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-30*self.scale, 10*self.scale, 15*self.scale, 15*self.scale)];
        [_weChatPayIv setImage:[UIImage imageNamed:@"na9"]];
        [_weChatPayCtl addSubview:_weChatPayIv];
        _alipayCtl=[[UIControl alloc]initWithFrame:CGRectMake(0, _weChatPayCtl.bottom, self.view.width, 35*self.scale)];
        _alipayCtl.backgroundColor=[UIColor whiteColor];
        [_alipayCtl addTarget:self action:@selector(alipayClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_alipayCtl];
        UIImageView* alipayLogoIv=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 15*self.scale, 15*self.scale)];
        [alipayLogoIv setImage:[UIImage imageNamed:@"alipay"]];
        [_alipayCtl addSubview:alipayLogoIv];
        UILabel* titleLb1=[[UILabel alloc]initWithFrame:CGRectMake(alipayLogoIv.right+10*self.scale, alipayLogoIv.top, 100*self.scale, 15*self.scale)];
        titleLb1.font=DefaultFont(self.scale*0.8);
        titleLb1.textColor=[UIColor colorWithRed:0.349 green:0.349 blue:0.349 alpha:1.00];
        titleLb1.text=@"支付宝支付";
        [_alipayCtl addSubview:titleLb1];
        _alipayIv=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-30*self.scale, 10*self.scale, 15*self.scale, 15*self.scale)];
        [_alipayIv setImage:[UIImage imageNamed:@"na10"]];
        _payType=@"1";
        [_alipayCtl addSubview:_alipayIv];
        _bottom=_alipayCtl.bottom;
    }else{
        [_codIv setImage:[UIImage imageNamed:@"na10"]];
        _payType=@"3";
    }
}

-(void)weChatPayClick{
    _payType=@"2";
    [_codIv setImage:[UIImage imageNamed:@"na9"]];
    [_weChatPayIv setImage:[UIImage imageNamed:@"na10"]];
    [_alipayIv setImage:[UIImage imageNamed:@"na9"]];
}

-(void)alipayClick{
    _payType=@"1";
    [_codIv setImage:[UIImage imageNamed:@"na9"]];
    [_weChatPayIv setImage:[UIImage imageNamed:@"na9"]];
    [_alipayIv setImage:[UIImage imageNamed:@"na10"]];
}

-(void)codClick{
    _payType=@"3";
    [_codIv setImage:[UIImage imageNamed:@"na10"]];
    [_weChatPayIv setImage:[UIImage imageNamed:@"na9"]];
    [_alipayIv setImage:[UIImage imageNamed:@"na9"]];
}

-(void)setCODView{
    NSString* isOnLinePay=[NSString stringWithFormat:@"%@",_orderDic[@"isOnLinePay"]];
    if(![isOnLinePay isEqualToString:@"1"]){
        _codTitleLb=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, _bottom+5*self.scale, 100*self.scale, 15*self.scale)];
        _codTitleLb.textColor=[UIColor colorWithRed:0.659 green:0.659 blue:0.659 alpha:1.00];
        _codTitleLb.font=SmallFont(self.scale*0.9);
        _codTitleLb.text=@"货到付款";
        [self.view addSubview:_codTitleLb];
        _bottom=_codTitleLb.bottom+5*self.scale;
        _codCtl=[[UIControl alloc]initWithFrame:CGRectMake(0, _bottom, self.view.width, 50*self.scale)];
        _codCtl.backgroundColor=[UIColor whiteColor];
        [_codCtl addTarget:self action:@selector(codClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_codCtl];
        _bottom=_codCtl.bottom;
        UIImageView* codLogoIv=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 15*self.scale, 15*self.scale)];
        [codLogoIv setImage:[UIImage imageNamed:@"cod"]];
        [_codCtl addSubview:codLogoIv];
        UILabel* titleLb=[[UILabel alloc]initWithFrame:CGRectMake(codLogoIv.right+10*self.scale, codLogoIv.top, 100*self.scale, 15*self.scale)];
        titleLb.font=DefaultFont(self.scale*0.9);
        titleLb.textColor=[UIColor colorWithRed:0.349 green:0.349 blue:0.349 alpha:1.00];
        titleLb.text=@"货到付款";
        [_codCtl addSubview:titleLb];
        UILabel* desLb=[[UILabel alloc]initWithFrame:CGRectMake(codLogoIv.right+10*self.scale, codLogoIv.bottom+5*self.scale, 150*self.scale, 10*self.scale)];
        desLb.font=SmallFont(self.scale*0.8);
        desLb.textColor=[UIColor colorWithRed:0.659 green:0.659 blue:0.659 alpha:1.00];
        desLb.text=@"支持现金或微信转账…";
        [_codCtl addSubview:desLb];
        _codIv=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-30*self.scale, 10*self.scale, 15*self.scale, 15*self.scale)];
        [_codIv setImage:[UIImage imageNamed:@"na9"]];
        [_codCtl addSubview:_codIv];
    }else{
        _hideView=[[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom , self.view.width, 20*self.scale)];
        _hideView.backgroundColor=[UIColor colorWithRed:0.922 green:0.361 blue:0.192 alpha:1.00];
        [self.view addSubview:_hideView];
        UIImageView* markIv=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 10*self.scale, 10*self.scale)];
        [markIv setImage:[UIImage imageNamed:@"exclamation_mark"]];
        [markIv setContentMode:UIViewContentModeScaleAspectFill];
        [_hideView addSubview:markIv];
        UILabel* hideLb=[[UILabel alloc]initWithFrame:CGRectMake(markIv.right+5*self.scale, 2.5*self.scale, self.view.width-(markIv.right+35*self.scale), 15*self.scale)];
        hideLb.font=SmallFont(self.scale*0.7);
        hideLb.textColor=[UIColor whiteColor];
        hideLb.text=@"您选择的优惠券仅支持在线支付";
        [_hideView addSubview:hideLb];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"popup_close_white2"] forState:UIControlStateNormal];
        closeBtn.frame=CGRectMake(self.view.width-20*self.scale, 5*self.scale, 10*self.scale, 10*self.scale);
        [closeBtn addTarget:self action:@selector(closeHideView) forControlEvents:UIControlEventTouchUpInside];
        [_hideView addSubview:closeBtn];
    }
}

-(void) closeHideView{
    [_hideView removeFromSuperview];
}

-(void)setOrderView{
    _orderView=[[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale, self.view.width, 50*self.scale)];
    _orderView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_orderView];
    UIImageView* logoIv=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 30*self.scale, 30*self.scale)];
    [logoIv setImage:[UIImage imageNamed:@"mz_logo"]];
    [_orderView addSubview:logoIv];
    _orderIDLb=[[UILabel alloc]initWithFrame:CGRectMake(logoIv.right+10*self.scale, logoIv.top, self.view.width-(logoIv.right+20*self.scale), 10*self.scale)];
    _orderIDLb.textColor=[UIColor colorWithRed:0.396 green:0.396 blue:0.396 alpha:1.00];
    _orderIDLb.font=SmallFont(self.scale*0.9);
    [_orderView addSubview:_orderIDLb];
    _orderIDLb.text=[NSString stringWithFormat:@"订单编号:%@",_orderDic[@"OrderID"]];
    
    _orderPriceLb=[[UILabel alloc]initWithFrame:CGRectMake(logoIv.right+10*self.scale, _orderIDLb.bottom+5*self.scale, self.view.width-(logoIv.right+20*self.scale), 15*self.scale)];
    _orderPriceLb.textColor=[UIColor colorWithRed:0.290 green:0.290 blue:0.290 alpha:1.00];
    _orderPriceLb.font=DefaultFont(self.scale);
    [_orderView addSubview:_orderPriceLb];
    NSString* priceString = [NSString stringWithFormat:@"￥%@",_orderDic[@"AllMoney"]];
    NSString *firstString = @"￥";
    NSMutableAttributedString * priceAttributeString = [[NSMutableAttributedString alloc]initWithString:priceString];
    [priceAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10*self.scale] range:NSMakeRange(0, firstString.length)];
    _orderPriceLb.attributedText = priceAttributeString;
    _bottom=_orderView.bottom;
}

-(void)newNav{
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    self.TitleLabel.text=@"支付订单";
    self.TitleLabel.font =[UIFont systemFontOfSize:15*self.scale];
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.height-.5, self.view.width, .5)];
    bottomLine.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [self.NavImg addSubview:bottomLine];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
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
