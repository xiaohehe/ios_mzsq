//
//  weifukuanViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "weifukuanViewController.h"
#import "CellView.h"
#import "UmengCollection.h"
@interface weifukuanViewController ()
@property(nonatomic,strong)UIView *bigBtnVi,*bigVi,*UIView ,*bigStateVi;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)UIScrollView *bigXaingQingVi;
@property(nonatomic,strong)NSMutableArray *lines;
@property(nonatomic,strong)UIView *shopCellVi,*dingDanCellVi,*PingJiaCellVi;

@property(nonatomic,strong)NSMutableArray *data;
@end

@implementation weifukuanViewController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    _lines = [NSMutableArray new];
    _data=[NSMutableArray new];
    [self oderXiangQingVi];
    [self xiangQingCellVi];
    [self reshData];
    
    [self returnVi];
}

-(void)reshData{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
        NSDictionary *dic = @{@"user_id":userid,@"order_id":self.order_id};
    
        [anle myOrderDetailWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"0"]) {
                [_data addObjectsFromArray:models];
            }
            [self oderXiangQingVi];
            [self.activityVC stopAnimate];
        }];
    
    
}

#pragma mark----订单详情-----
-(void)oderXiangQingVi{
    
    if (_bigXaingQingVi) {
        [_bigXaingQingVi removeFromSuperview];
    }
    
    _bigXaingQingVi = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, [UIScreen mainScreen].bounds.size.height-self.NavImg.bottom)];
    _bigXaingQingVi.contentSize = CGSizeMake(self.view.width, 1000);
    [self.view addSubview:_bigXaingQingVi];
    
    
    _shopCellVi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    _shopCellVi.backgroundColor = [UIColor whiteColor];
    [_bigXaingQingVi addSubview:_shopCellVi];
    
    CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    [_bigXaingQingVi addSubview:nameCell];

    
    UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, nameCell.height/2-10*self.scale, self.view.width, 20*self.scale)];
    nameLa.text = [NSString stringWithFormat:@"订单号：%@",self.order_id];
    nameLa.font = DefaultFont(self.scale);
    [nameCell addSubview:nameLa];
    

    float setY = nameCell.bottom;
    
    NSInteger q=0;
    NSArray *dataArr=nil;
    if (_data.count>0) {
        dataArr = _data[0][@"prods"];
        
        if ([dataArr isKindOfClass:[NSArray class]]) {
            q = [_data[0][@"prods"] count];
        }else{
            q=0;
        }
    }
    
    
//    for (NSDictionary *dic in _data[0][@"order_detail"]) {
//        
//        for (NSDictionary *prodic in dic[@"prods"]) {
//            NSMutableArray *mutabArr = [NSMutableArray new];
//            [mutabArr addObject:prodic];
//        }
//    }
    
    NSMutableArray *prodArr = [NSMutableArray new];
    for (NSDictionary *dic in _data) {
        for (NSDictionary *prodic in dic[@"prods"]) {
            
            [prodArr addObject:prodic];

        }
    }
  
    
    for (int i=0; i<prodArr.count; i++) {
        CellView *goodsCell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 44)];
        [_shopCellVi addSubview:goodsCell];
        
        UIImageView *dianImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, goodsCell.height/2-2.5*self.scale, 5*self.scale, 5*self.scale)];
        dianImg.backgroundColor = grayTextColor;
        dianImg.layer.cornerRadius=2.5f;
        [goodsCell addSubview:dianImg];
        
        
        UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(dianImg.right+5*self.scale, goodsCell.height/2-10*self.scale, 170*self.scale, 20*self.scale)];
        nameLa.text =prodArr[i][@"prod_name"];
        
        nameLa.font = DefaultFont(self.scale);
        [goodsCell addSubview:nameLa];
        
        
        UILabel *numberLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/2+20*self.scale, goodsCell.height/2-10*self.scale, 30*self.scale, 20*self.scale)];
        numberLa.text = [NSString stringWithFormat:@"x%@",prodArr[i][@"prod_count"]];
        numberLa.font = DefaultFont(self.scale);
        [goodsCell addSubview:numberLa];
        
        UILabel *priceLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/2+50*self.scale, goodsCell.height/2-10*self.scale, 100*self.scale, 20*self.scale)];
        priceLa.text = [NSString stringWithFormat:@"￥%@",prodArr[i][@"price"]];
        priceLa.font = DefaultFont(self.scale);
        priceLa.textAlignment=NSTextAlignmentRight;
        [goodsCell addSubview:priceLa];
        
        setY = goodsCell.bottom;
    }
    
    
    
    CellView *heJiCell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 44)];
    NSString *zongPrice=nil;
    if (_data.count>0) {
       zongPrice = _data[0][@"total_amount"];
    }else{
        zongPrice = nil;
    }
    
    
    
   
    if (zongPrice.length>0) {
        heJiCell.contentLabel.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"合计：￥%@",zongPrice] redString:[NSString stringWithFormat:@"￥%@",zongPrice]];
        
        
//         heJiCell.contentLabel.text = [NSString stringWithFormat:@"合计：%@",zongPrice];
    }else{
        heJiCell.contentLabel.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"合计：￥%@",zongPrice] redString:@"￥0"];
//        heJiCell.contentLabel.text = [NSString stringWithFormat:@"合计：0"];
    }
//    heJiCell.contentLabel.textColor = [UIColor redColor];
    heJiCell.contentLabel.textAlignment = NSTextAlignmentRight;
    [_shopCellVi addSubview:heJiCell];
    
    
    CellView *sendTimeCell = [[CellView alloc]initWithFrame:CGRectMake(0, heJiCell.bottom, self.view.width, 44)];
    sendTimeCell.title = @"配送时间";
    
    
    
    NSString *delivery_time;
    NSString *memo;
    if (_data.count<=0) {
        delivery_time=@"";
        memo=@"";
    }else{
        memo = _data[0][@"memo"];
        delivery_time = _data[0][@"send_time"];
    }
         sendTimeCell.contentLabel.text = delivery_time;


    sendTimeCell.contentLabel.textColor=grayTextColor;
    [_shopCellVi addSubview:sendTimeCell];
    
    CellView *beiZhuCell = [[CellView alloc]initWithFrame:CGRectMake(0, sendTimeCell.bottom, self.view.width, 44)];
    beiZhuCell.titleLabel.text =@"备注";
    beiZhuCell.titleLabel.textColor = [UIColor redColor];
    

    beiZhuCell.contentLabel.text = memo;
    if ([[NSString stringWithFormat:@"%@",memo] isEmptyString]) {
        beiZhuCell.contentLabel.text = @"";
        
    }

    
    beiZhuCell.contentLabel.textColor=grayTextColor;
    [_shopCellVi addSubview:beiZhuCell];
    
    _shopCellVi.height = beiZhuCell.bottom;
    
    [self xiangQingCellVi];
}
//-(void)lianxiMaijia:(UIButton *)sender{
//    
//    if (sender.tag==100) {
//        //聊天
//        
//        
//    }else{
//        //电话
//        [[[UIAlertView alloc]initWithTitle:@"在线联系卖家电话" message:@"13838003800" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil]show ] ;
//        
//        
//    }
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertView.message]];
        
    }
    
}

#pragma mark------详情；
-(void)xiangQingCellVi{
    NSArray *dataArr = nil;
    if (_data.count>0) {
        dataArr = _data;
    }
    
    
    _dingDanCellVi = [[UIView alloc]initWithFrame:CGRectMake(0, _shopCellVi.bottom+10*self.scale, self.view.width, 1000)];
    [_bigXaingQingVi addSubview:_dingDanCellVi];
    
    CellView *xiangQingCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    [_dingDanCellVi addSubview:xiangQingCell];
    
    UIImageView *dingDanImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, xiangQingCell.height/2-7.5*self.scale, 12.5*self.scale, 15*self.scale)];
    
    dingDanImg.image = [UIImage imageNamed:@"leibie"];
    [xiangQingCell addSubview:dingDanImg];
    
    UILabel *xiangQingLa = [[UILabel alloc]initWithFrame:CGRectMake(dingDanImg.right+5*self.scale, dingDanImg.top, self.view.width-20*self.scale, 15*self.scale)];
    xiangQingLa.text = @"订单详情";
    xiangQingLa.font = DefaultFont(self.scale);
    [xiangQingCell addSubview:xiangQingLa];
    
    CellView *dingDanHaoCell = [[CellView alloc]initWithFrame:CGRectMake(0, xiangQingCell.bottom, self.view.width, 44)];
    dingDanHaoCell.title=@"订单号：";
    dingDanHaoCell.contentLabel.text = self.order_id;
    [dingDanHaoCell setHidden:NO];
    [_dingDanCellVi addSubview:dingDanHaoCell];
    
    CellView *xiaDanTimeCell = [[CellView alloc]initWithFrame:CGRectMake(0, dingDanHaoCell.bottom, self.view.width, 44)];
    xiaDanTimeCell.title=@"下单时间：";
    
    NSString *send_time = dataArr[0][@"send_time"];
    if (send_time.length>0) {
        xiaDanTimeCell.contentLabel.text = send_time;
    }else{
        xiaDanTimeCell.contentLabel.text = [NSString stringWithFormat:@""];
    }
    
    
    [_dingDanCellVi addSubview:xiaDanTimeCell];
    
    CellView *zhiFuTypeCell = [[CellView alloc]initWithFrame:CGRectMake(0, xiaDanTimeCell.bottom, self.view.width, 44)];
    zhiFuTypeCell.title=@"支付方式：";
    
    NSString *pay_type = dataArr[0][@"pay_type"];
    if (pay_type.length>0) {
        if ([pay_type isEqualToString:@"1"]) {
            pay_type=@"支付宝支付";
        }else if ([pay_type isEqualToString:@"2"]){
        pay_type=@"微信支付";
        }else{
        pay_type=@"货到付款";
        }
        
        
        zhiFuTypeCell.contentLabel.text = pay_type;
    }else{
        zhiFuTypeCell.contentLabel.text = [NSString stringWithFormat:@""];
    }
    
    
    [_dingDanCellVi addSubview:zhiFuTypeCell];
    
    CellView *teleCell = [[CellView alloc]initWithFrame:CGRectMake(0, zhiFuTypeCell.bottom, self.view.width, 44)];
    teleCell.title=@"手机号码：";
    
    NSString *mobile = dataArr[0][@"delivery_address"][@"mobile"];
    if (mobile.length>0) {
        teleCell.contentLabel.text = mobile;
    }else{
        teleCell.contentLabel.text = [NSString stringWithFormat:@""];
    }
    
    [_dingDanCellVi addSubview:teleCell];
    
    CellView *adressCell = [[CellView alloc]initWithFrame:CGRectMake(0, teleCell.bottom, self.view.width, 44)];
    //adressCell.contentLabel.numberOfLines=0;
    
    NSString *ad = dataArr[0][@"delivery_address"][@"address"];
    
    if (![dataArr[0][@"delivery_address"][@"house_number"] isEqualToString:@""]) {
        ad = [ad stringByAppendingString:dataArr[0][@"delivery_address"][@"house_number"]];
        
    }
    
    ad = [ad stringByAppendingString:dataArr[0][@"delivery_address"][@"house_number"]];
    

    if (ad.length>0) {
        adressCell.content = ad;
    }else{
        adressCell.contentLabel.text = [NSString stringWithFormat:@""];
         }
    
    [adressCell.contentLabel sizeToFit];
    adressCell.height=adressCell.contentLabel.bottom+10*self.scale;
    adressCell.contentLabel.top=adressCell.titleLabel.top;
    adressCell.contentLabel.font = DefaultFont(self.scale);
    adressCell.titleLabel.text = @"收货地址：";
    adressCell.titleLabel.font = DefaultFont(self.scale);
    
    [_dingDanCellVi addSubview:adressCell];
    
    
    UIButton *queding = [[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, adressCell.bottom +20*self.scale, self.view.width-20*self.scale, 35*self.scale)];
    queding.backgroundColor=[UIColor redColor];
    queding.layer.cornerRadius=4;
    queding.layer.masksToBounds=YES;
    queding.titleLabel.font=Big16Font(1);
    [queding setTitle:@"去支付" forState:UIControlStateNormal];
    [queding addTarget:self action:@selector(zhifu) forControlEvents:UIControlEventTouchUpInside];
    [_dingDanCellVi addSubview:queding];
    
    
    
    _dingDanCellVi.height = queding.bottom+0*self.scale;
    _bigXaingQingVi.contentSize=CGSizeMake(self.view.width, _dingDanCellVi.bottom+20*self.scale);
    
}

-(void)zhifu{
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSString *zongPrice=nil;
    if (_data.count>0) {
        zongPrice = _data[0][@"total_amount"];
    }else{
        zongPrice = @"0";
    }
    float price = [zongPrice floatValue]*100;
    NSLog(@"quzhifu==%@",_data[0]);
    if ([_data[0][@"pay_type"] isEqualToString:@"2"]) {
        AnalyzeObject *anle = [AnalyzeObject new];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:_data[0][@"order_no"] forKey:@"orderid"];
        [param setObject: self.user_id forKey:@"user_id"];
        [anle resubmitOrder:[param copy] Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            //NSLog(@"resubmitOrder==%@",models);
            [self.appdelegate WXPayNewWithNonceStr:models[@"noncestr"] OrderID:models[@"order_no"] Timestamp:models[@"timestamp"] sign:models[@"sign"] complete:^(BaseResp *resp) {
                [self.activityVC stopAnimate];
                if (resp.errCode == WXSuccess) {
                     [self suessToVi:zongPrice];
                }
            }];
        }];
//        [self.appdelegate WXPayPrice:[NSString stringWithFormat:@"%.0f",price] OrderID:self.order_id OrderName:self.order_id complete:^(BaseResp *resp) {
//                    if (resp.errCode == WXSuccess) {
//                        [self suessToVi:zongPrice];
//                    }
//        
//                }];

    }else if ([_data[0][@"pay_type"] isEqualToString:@"1"]){
        AnalyzeObject *anle = [AnalyzeObject new];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:_data[0][@"order_no"]  forKey:@"orderid"];
        [param setObject: self.user_id forKey:@"user_id"];
        [anle resubmitOrder:[param copy] Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            //  NSLog(@"resubmitOrder==%@",models);
            //                [self.appdelegate WXPayNewWithNonceStr:models[@"noncestr"] OrderID:models[@"order_no"] Timestamp:models[@"timestamp"] sign:models[@"sign"]];
            [self.appdelegate AliPayNewPrice:models[@"amount"] OrderID:[NSString stringWithFormat:@"%@",models[@"order_no"]] OrderName:@"拇指社区" Sign:models[@"sign"]  OrderDescription:[NSString stringWithFormat:@"%@",models[@"order_no"]] complete:^(NSDictionary *resp) {
                [self.activityVC stopAnimate];
                if ([[resp objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                    [self suessToVi:zongPrice];
                }
            }];
        }];

//        [self.appdelegate AliPayPrice:zongPrice OrderID:self.order_id OrderName:@"拇指社区" OrderDescription:self.order_id complete:^(NSDictionary *resp) {
//            if ([[resp objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
//                [self suessToVi:zongPrice];
//            }
//            
//        }];

        
    }

    
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"支付方式" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.appdelegate AliPayPrice:zongPrice OrderID:self.order_id OrderName:nil OrderDescription:nil complete:^(NSDictionary *resp) {
//              if ([[resp objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
//                  [self suessToVi:zongPrice];
//              }
//            
//        }];
//
//    }];
//    
//    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.appdelegate WXPayPrice:[NSString stringWithFormat:@"%.0f",price] OrderID:self.order_id OrderName:nil complete:^(BaseResp *resp) {
//            if (resp.errCode == WXSuccess) {
//                [self suessToVi:zongPrice];
//            }
//
//        }];
//
//        
//    }];
//    
//    [alert addAction:act1];
//    [alert addAction:act2];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//
}

-(void)suessToVi:(NSString *)price{
    self.hidesBottomBarWhenPushed=YES;
    orderSuessViewController *suess = [orderSuessViewController new];
    suess.price=price;
    [self.navigationController pushViewController:suess animated:YES];
}


#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"等待处理";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGSize)sizetoFitWithString:(NSString *)string wideth:(float)width{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, 350*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return size;
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
