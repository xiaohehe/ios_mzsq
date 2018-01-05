//
//  OrderDetailsViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/20.
//  Copyright © 2017年 apple. All rights reserved.
//
/*
 订单请求状态：
 请求时：
 -1：退货中
 1：待付款
 2：待发货
 3：待收货
 4：待评价
 5:全部订单
 6：已取消
 
 返回时：
 退货中 = -1,
 未付款 = 1,
 已付款 = 2,
 已接单 = 3,
 已发货 = 4,
 已完成 = 5,
 已取消 = 6
 */
#import "OrderDetailsViewController.h"
#import "AppUtil.h"
#import "PaymentOrderViewController.h"
#import "OrderViewController.h"

@interface OrderDetailsViewController ()
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)UIScrollView *sv;
@property(nonatomic,strong)UIImageView *statusIv;
@property(nonatomic,strong)UILabel *statusLb;
@property(nonatomic,strong) UIView *addressView;
@property(nonatomic,strong) UIView *goodsView;
@property(nonatomic,strong) UIView *moreView;
@property(nonatomic,strong) UIView *totalView;
@property(nonatomic,strong) UIView *detailsView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,assign)BOOL isShowAll;
@property(nonatomic,assign) CGFloat bottom;
@end

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data =[NSMutableArray new];
    _isShowAll=false;
    [self newNav];
}

- (void)viewWillAppear:(BOOL)animated{
    [self reshData];
    [self.view addSubview:self.activityVC];
}

-(void) setOrderInfo{
    if(!_sv){
        _sv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom-(50*self.scale+self.dangerAreaHeight))];
        _sv.backgroundColor=[UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.00];
        [self.view addSubview:_sv];
    }
    //if(!_statusIv){
    _statusIv=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width/750*140)];
    [_statusIv setImage:[self getStatusImage]];
    [_sv addSubview:_statusIv];
    // }
    //if(!_statusLb){
    _statusLb=[[UILabel alloc]initWithFrame:CGRectMake(0, _statusIv.bottom, self.view.width, 40*self.scale)];
    _statusLb.backgroundColor=[UIColor whiteColor];
    _statusLb.font=SmallFont(self.scale);
    _statusLb.text=[self getStatusInfo];
    _statusLb.textColor=[UIColor colorWithRed:0.290 green:0.302 blue:0.369 alpha:1.00];
    [_sv addSubview:_statusLb];
    //}
    //if(!_addressView){
    _addressView=[[UIView alloc]initWithFrame:CGRectMake(0, _statusLb.bottom+15*self.scale, self.view.width, 60*self.scale)];
    _addressView.backgroundColor=[UIColor whiteColor];
    [_sv addSubview:_addressView];
    UIImageView *locationIv=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 13*self.scale, 15*self.scale)];
    [locationIv setImage:[UIImage imageNamed:@"location1"]];
    [_addressView addSubview:locationIv];
    UILabel *mobileLb=[[UILabel alloc] initWithFrame:CGRectMake(locationIv.right+10*self.scale, locationIv.top, self.view.width-locationIv.right-20*self.scale, 15*self.scale)];
    mobileLb.text=[NSString stringWithFormat:@"%@  %@",_data[0][@"delivery_address"][@"real_name"],_data[0][@"delivery_address"][@"mobile"]];
    mobileLb.font=SmallFont(self.scale);
    mobileLb.textColor=[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.00];
    [_addressView addSubview:mobileLb];
    
    UILabel *addressLb=[[UILabel alloc] initWithFrame:CGRectMake(locationIv.right+10*self.scale, mobileLb.bottom+10*self.scale, self.view.width-locationIv.right-20*self.scale, 15*self.scale)];
    addressLb.text=[NSString stringWithFormat:@"地址：%@",_data[0][@"delivery_address"][@"address"]];
    addressLb.font=SmallFont(self.scale*0.9);
    addressLb.textColor=[UIColor colorWithRed:0.608 green:0.608 blue:0.608 alpha:1.00];
    [_addressView addSubview:addressLb];
    //}
    NSArray* prods=_data[0][@"prods"];
    CGFloat height=0.0;
    NSInteger pCount=0;
    BOOL isMore=NO;
    if([prods count]>2){
        pCount=2;
        isMore=YES;
    }else{
        pCount=[prods count];
    }
    [self setProdsView:pCount];
    _bottom=_goodsView.bottom;
    if(isMore){//
        _moreView=[[UIView alloc]initWithFrame:CGRectMake(0, _bottom, self.view.width, 50*self.scale)];
        _moreView.backgroundColor=[UIColor whiteColor];
        [_sv addSubview:_moreView];
        UIButton *moreBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2-40*self.scale, 10*self.scale, 80*self.scale, 20*self.scale)];
        moreBtn.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
        [moreBtn setTitle:@"显示全部" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithRed:0.608 green:0.608 blue:0.608 alpha:1.00] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(showMoreView) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.titleLabel.font =SmallFont(self.scale);
        moreBtn.layer.masksToBounds=YES;
        moreBtn.layer.cornerRadius=10*self.scale;
        [_moreView addSubview:moreBtn];
        _bottom=_moreView.bottom;
    }
    [self setBottomView];
    [self setMenuView];
}

-(void)setProdsView:(NSUInteger)pCount{
    _goodsView=[[UIView alloc]initWithFrame:CGRectMake(0, _addressView.bottom+15*self.scale, self.view.width, 50*self.scale*pCount)];
    _goodsView.backgroundColor=[UIColor whiteColor];
    [_sv addSubview:_goodsView];
    for(int i=0;i<pCount;i++){
        UIImageView* coverIv=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale*(i+1), 10*self.scale, 30*self.scale, 30*self.scale)];
        NSArray* imgs=[_data[0][@"prods"][i] objectForKey:@"img"];
        //NSLog(@"img===%lu",imgs.count);
        if(imgs.count>0){
            NSString *string = [NSString stringWithFormat:@"%@",[_data[0][@"prods"][i] objectForKey:@"img"][0]];
            NSArray *imgArr = [string componentsSeparatedByString:@"|"];
            [coverIv setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:[UIImage imageNamed:@"not_1"]];
            coverIv.layer.masksToBounds=YES;
            coverIv.layer.cornerRadius=5;
            [_goodsView addSubview:coverIv];
        }else{
            [coverIv setImage:[UIImage imageNamed:@"not_1"]];
        }
        UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(coverIv.right+10*self.scale, coverIv.top, self.view.width/3*2-coverIv.right-10*self.scale, 15*self.scale)];
        nameLa.text =_data[0][@"prods"][i][@"prod_name"];
        nameLa.textColor=[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00];
        nameLa.font = DefaultFont(self.scale);
        [_goodsView addSubview:nameLa];
        
        UILabel *priceLa = [[UILabel alloc]initWithFrame:CGRectMake(nameLa.left, nameLa.bottom+5*self.scale, self.view.width/3*2-coverIv.right-10*self.scale, 10*self.scale)];
        priceLa.text = [NSString stringWithFormat:@"￥%@/%@",_data[0][@"prods"][i][@"price"],_data[0][@"prods"][i][@"unit"]];
        priceLa.textColor=[UIColor colorWithRed:0.616 green:0.616 blue:0.616 alpha:1.00];
        priceLa.font = SmallFont(self.scale*0.9);
        [_goodsView addSubview:priceLa];
        
        UILabel *numberLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/3*2, coverIv.top+10*self.scale, 30*self.scale, 15*self.scale)];
        numberLa.text = [NSString stringWithFormat:@"x%@",_data[0][@"prods"][i][@"prod_count"]];
        numberLa.font = DefaultFont(self.scale);
        numberLa.textColor=[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00];
        [_goodsView addSubview:numberLa];
        
        UILabel *totalPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(numberLa.right, numberLa.top, self.view.width/3-40*self.scale, 15*self.scale)];
        totalPriceLb.text = [NSString stringWithFormat:@"%@元",_data[0][@"prods"][i][@"amount"]];
        totalPriceLb.font = DefaultFont(self.scale);
        totalPriceLb.textColor=[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00];
        totalPriceLb.textAlignment=NSTextAlignmentRight;
        [_goodsView addSubview:totalPriceLb];
    }
}

-(void)setMenuView{
    _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.height-(50*self.scale+self.dangerAreaHeight), self.view.width, 50*self.scale+self.dangerAreaHeight)];
    _bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_bottomView];
    NSInteger status=[_data[0][@"status"] integerValue];
    switch (status) {
        case -1:
            [self setRightButton:@"再来一单"];
            break;
        case 1:
            [self setRightButton:@"立即付款"];
            [self setmiddleButton:@"取消订单"];
            break;
        case 2:
            [self setRightButton:@"再来一单"];
            [self setmiddleButton:@"取消订单"];
            break;
        case 3:
        case 4:
            [self setRightButton:@"再来一单"];
            [self setmiddleButton:@"取消订单"];
            break;
        case 5:
            [self setRightButton:@"再来一单"];
            //[self setmiddleButton:@"取消订单"];
            [self setLeftButton:@"删除订单"];
            break;
        case 6:
            [self setLeftButton:@"删除订单"];
            break;
    }
}

-(void)setLeftButton:(NSString*) title{
    UIButton* leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 30*self.scale/70*169, 30*self.scale)];
    [leftBtn setTitle:title forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithRed:0.216 green:0.216 blue:0.196 alpha:1.00] forState:UIControlStateNormal];
    leftBtn.titleLabel.font=SmallFont(self.scale);
    [leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:leftBtn];
}

-(void)leftClick{
    //[self.view addSubview:self.activityVC];
    [self ShowAlertTitle:nil Message:@"确认删除?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            [self.activityVC startAnimate];
            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":self.orderId};
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle delOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                if ([code isEqualToString:@"0"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self ShowAlertWithMessage:msg];
                }
            }];
        }
    }];
}

-(void)setmiddleButton:(NSString*) title{
    UIButton* middleBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-(30*self.scale/70*169+10*self.scale)*2, 10*self.scale, 30*self.scale/70*169, 30*self.scale)];
    [middleBtn setTitle:title forState:UIControlStateNormal];
    [middleBtn setTitleColor:[UIColor colorWithRed:0.216 green:0.216 blue:0.196 alpha:1.00] forState:UIControlStateNormal];
    middleBtn.titleLabel.font=SmallFont(self.scale);
    middleBtn.layer.cornerRadius = middleBtn.height/2;
    middleBtn.layer.borderWidth = .5;
    middleBtn.layer.borderColor = blackLineColore.CGColor;
    [middleBtn addTarget:self action:@selector(middleClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:middleBtn];
}

-(void)middleClick{
    [self ShowAlertTitle:nil Message:@"确认取消?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":self.orderId,@"order_no":self.orderId};
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                if ([code isEqualToString:@"0"]) {
                    if(![AppUtil isBlank:msg])
                        [self ShowAlertWithMessage:msg];
                    //[self dropDownRefresh];
                    [self reshData];
                }else{
                    if([AppUtil isBlank:msg])
                        [AppUtil showToast:self.view withContent:@"取消失败"];
                    else{
                        [AppUtil showToast:self.view withContent:msg];
                    }
                }
            }];
        }
    }];
}

-(void)setRightButton:(NSString*) title{
    UIButton* rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-(30*self.scale/70*169)-10*self.scale, 10*self.scale, 30*self.scale/70*169, 30*self.scale)];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"bg_order"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:0.216 green:0.216 blue:0.196 alpha:1.00] forState:UIControlStateNormal];
    rightBtn.titleLabel.font=SmallFont(self.scale);
     [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:rightBtn];
}

-(void)rightClick{
    NSInteger status=[_data[0][@"status"] integerValue];
    if(status==1){
        [self paymentOrder];
    }else if(status!=6){
        [self singleAgainClick];
    }
}

-(void)paymentOrder{
    NSMutableDictionary *orderDic=[NSMutableDictionary dictionary];
    [orderDic setObject:_data[0][@"isOnLinePay"] forKey:@"isOnLinePay"];
    [orderDic setObject:self.orderId forKey:@"OrderID"];
    [orderDic setObject:_data[0][@"total_amount"] forKey:@"AllMoney"];
    PaymentOrderViewController* paymentOrderView=[[PaymentOrderViewController alloc] init];
    paymentOrderView.hidesBottomBarWhenPushed=YES;
    paymentOrderView.orderDic=orderDic;
    [self.navigationController pushViewController:paymentOrderView animated:YES];
}

/*
 *再来一单
 */
-(void)singleAgainClick{
    [self ShowAlertTitle:nil Message:@"再来一单?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            [self.activityVC startAnimate];
            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            NSDictionary *dic = @{@"orderid":self.orderId};
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle reOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                if ([code isEqualToString:@"0"]) {
                    NSLog(@"reOrder==%@==%@",dic,models);
                    [self settleAccount:models];
                }
            }];
        }
    }];
}

-(void)settleAccount:(NSDictionary*) models{
    NSArray *dataSource=models[@"prodList"];
    if(dataSource.count==0){
        [self ShowAlertWithMessage:@"当前商品已下架"];
        return;
    }
    NSDictionary* dataDic=models[@"shopinfo"];
    NSMutableArray *settleArray=[NSMutableArray array];
    CGFloat amount=0.0;
    for(int i=0;i<dataSource.count;i++){
        NSMutableDictionary* dic=[dataSource[i] mutableCopy];
        [dic setObject:dataSource[i][@"prod_id"] forKey:@"pro_id"];
        [dic setObject:dataSource[i][@"prod_count"] forKey:@"pro_allnum"];
        [dic setObject:dataSource[i][@"price"] forKey:@"pro_price"];
        NSArray* imgs=dataSource[i][@"img"];
        if(imgs.count>0){
            NSString *string = [NSString stringWithFormat:@"%@",imgs[0]];
            NSArray *imgArr = [string componentsSeparatedByString:@","];
            [dic setObject:imgArr[0] forKey:@"pro_cover"];
        }
        amount+=[dataSource[i][@"price"] floatValue];
        NSInteger activityid=[[NSString stringWithFormat:@"%@",dic[@"activity_id"]] integerValue];
        if(activityid>0){
            NSInteger actmaxbuy=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"actmaxbuy"]] integerValue];
            NSInteger havedbuy=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"havedbuy"]] integerValue];
            if(actmaxbuy>0){
                NSInteger pro_allnum=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"pro_allnum"]] integerValue];
                NSInteger sub=pro_allnum-(actmaxbuy-havedbuy);
                if(sub>0){
                    if((actmaxbuy-havedbuy)>0){
                        [dic setObject:[NSNumber numberWithInteger:(actmaxbuy-havedbuy)] forKey:@"pro_allnum"];
                        [settleArray addObject:dic];
                    }
                    NSMutableDictionary* dic1=[dic mutableCopy];
                    [dic1 setObject:[NSNumber numberWithInteger:sub] forKey:@"pro_allnum"];
                    [dic1 setObject:[NSNumber numberWithInteger:0] forKey:@"activity_id"];
                    [settleArray addObject:dic1];
                }else{
                    [settleArray addObject:dic];
                }
            }else{
                [settleArray addObject:dic];
            }
        }else{
            [settleArray addObject:dic];
        }
    }
    CGFloat delivery_free=[dataDic[@"delivery_free"] floatValue];
    CGFloat delivery_fee=[dataDic[@"delivery_fee"] floatValue];
    CGFloat total=amount;
    if(amount<delivery_free){
        total+=delivery_fee;
    }
    NSMutableDictionary* settleDic=[NSMutableDictionary dictionary];
    [settleDic setObject:dataDic[@"delivery_fee"] forKey:@"delivery_fee"];
    [settleDic setObject:dataDic[@"delivery_free"] forKey:@"delivery_free"];
    [settleDic setObject:dataDic[@"shop_icon"] forKey:@"shop_icon"];
    [settleDic setObject:dataDic[@"shop_id"] forKey:@"shop_id"];
    [settleDic setObject:dataDic[@"shop_name"] forKey:@"shop_name"];
    [settleDic setObject:[NSString stringWithFormat:@"%.1f",amount] forKey:@"amount"];
    [settleDic setObject:[NSString stringWithFormat:@"%.1f",total] forKey:@"total"];
    
    NSLog(@"dic==%@",settleDic);
    OrderViewController *orde = [OrderViewController new];
    orde.hidesBottomBarWhenPushed=YES;
    orde.dataArray = settleArray;
    orde.dataDic=settleDic;
    orde.couponDic=models[@"coupon"];
    orde.isReOrder=YES;
    // orde.gouwucheData=_dataSource;
    [self.navigationController pushViewController:orde animated:YES];
}


-(void)setBottomView{
    //if(!_totalView){
    _totalView=[[UIView alloc]initWithFrame:CGRectMake(0, _bottom, self.view.width, 40*self.scale)];
    _totalView.backgroundColor=[UIColor whiteColor];
    [_sv addSubview:_totalView];
    UIView* line=[[UIView alloc]initWithFrame:CGRectMake(10*self.scale, 0, self.view.width-20*self.scale, .5)];
    line.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [_totalView addSubview:line];
    
    UILabel *totalLb = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, self.view.width-20*self.scale, 20*self.scale)];
    totalLb.text = [NSString stringWithFormat:@"共%lu件商品  小计%@元",[self getGoodsNumber],_data[0][@"total_amount"]];
    totalLb.font = [UIFont boldSystemFontOfSize:15];
    totalLb.textColor=[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00];
    totalLb.textAlignment=NSTextAlignmentRight;
    [_totalView addSubview:totalLb];
    _detailsView=[[UIView alloc]initWithFrame:CGRectMake(0,_totalView.bottom+15*self.scale, self.view.width, 110*self.scale)];
    _detailsView.backgroundColor=[UIColor whiteColor];
    [_sv addSubview:_detailsView];
    
    UILabel* titleLb1=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale,10*self.scale, 60*self.scale, 15*self.scale)];
    titleLb1.textColor=[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00];
    titleLb1.text=@"商品金额：";
    titleLb1.font=SmallFont(self.scale*0.9);
    titleLb1.textAlignment=NSTextAlignmentRight;
    [_detailsView addSubview:titleLb1];
    
    UILabel* contentLb1=[[UILabel alloc]initWithFrame:CGRectMake(titleLb1.right+10*self.scale,titleLb1.top, self.view.width-(titleLb1.right+20*self.scale), 15*self.scale)];
    contentLb1.textColor=[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00];
    contentLb1.text=[NSString stringWithFormat:@"￥%@",_data[0][@"total_amount"]];
    contentLb1.font=SmallFont(self.scale*0.9);
    contentLb1.textAlignment=NSTextAlignmentRight;
    [_detailsView addSubview:contentLb1];
    
    UILabel* titleLb2=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale,titleLb1.bottom+10*self.scale, 60*self.scale, 15*self.scale)];
    titleLb2.textColor=[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00];
    titleLb2.text=@"配送费：";
    titleLb2.font=SmallFont(self.scale*0.9);
    titleLb2.textAlignment=NSTextAlignmentRight;
    [_detailsView addSubview:titleLb2];
    CGFloat freeDeliveryAmount=[_data[0][@"free_delivery_amount"] floatValue];
    CGFloat totalAmount=[_data[0][@"total_amount"] floatValue];
    NSString* shippingFee=@"+￥0.0";
    if(totalAmount<freeDeliveryAmount){
        shippingFee=[NSString stringWithFormat:@"+￥%@",_data[0][@"delivery_fee"]];
    }
    UILabel* contentLb2=[[UILabel alloc]initWithFrame:CGRectMake(titleLb2.right+10*self.scale,titleLb2.top, self.view.width-(titleLb1.right+20*self.scale), 15*self.scale)];
    contentLb2.textColor=[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00];
    contentLb2.text=shippingFee;
    contentLb2.font=SmallFont(self.scale*0.9);
    contentLb2.textAlignment=NSTextAlignmentRight;
    [_detailsView addSubview:contentLb2];
    
    UILabel* titleLb3=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale,titleLb2.bottom+10*self.scale, 60*self.scale, 15*self.scale)];
    titleLb3.textColor=[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00];
    titleLb3.text=@"优惠券：";
    titleLb3.font=SmallFont(self.scale*0.9);
    titleLb3.textAlignment=NSTextAlignmentRight;
    [_detailsView addSubview:titleLb3];
    
    CGFloat discountCoupon=[_data[0][@"discount_coupon"] floatValue];
    UILabel* contentLb3=[[UILabel alloc]initWithFrame:CGRectMake(titleLb3.right+10*self.scale,titleLb3.top, self.view.width-(titleLb1.right+20*self.scale), 15*self.scale)];
    if(![AppUtil isBlank:_data[0][@"discount_coupon"]]||discountCoupon>0){
        contentLb3.textColor=[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00];
        contentLb3.text=[NSString stringWithFormat:@"-￥%@",_data[0][@"discount_coupon"]];
    }else{
        contentLb3.textColor=[UIColor colorWithRed:0.655 green:0.655 blue:0.655 alpha:1.00];
        contentLb3.text=[NSString stringWithFormat:@"暂无优惠券"];
    }
    contentLb3.font=SmallFont(self.scale*0.9);
    contentLb3.textAlignment=NSTextAlignmentRight;
    [_detailsView addSubview:contentLb3];
    
    UILabel* paymentLb=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale,titleLb3.bottom+10*self.scale, self.view.width-20*self.scale, 15*self.scale)];
    paymentLb.textColor=[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00];
    paymentLb.text=[NSString stringWithFormat:@"实付：%@",_data[0][@"total_amount"]];
    paymentLb.font=[UIFont boldSystemFontOfSize:14];
    paymentLb.textAlignment=NSTextAlignmentRight;
    [_detailsView addSubview:paymentLb];
    _bottom=_detailsView.bottom+20*self.scale+self.dangerAreaHeight;
    if(_bottom<=_sv.height){
        _sv.contentSize = CGSizeMake(self.view.width,_sv.height);
    }else{
        _sv.contentSize = CGSizeMake(self.view.width,_bottom);
    }
}

-(NSUInteger) getGoodsNumber{
    NSUInteger num=0;
    NSArray* prods=_data[0][@"prods"];
    for(int i=0;i<[prods count];i++){
        num+=[prods[i][@"prod_count"] integerValue];
    }
    return num;
}

-(void)showMoreView{
    _moreView.height=0;
    [_goodsView removeFromSuperview];
    [_totalView removeFromSuperview];
    [_detailsView removeFromSuperview];
    NSArray* prods=_data[0][@"prods"];
    [self setProdsView:[prods count]];
    _bottom=_goodsView.bottom;
    [self setBottomView];
}

-(NSString*) getStatusInfo{
    NSInteger status=[_data[0][@"status"] integerValue];
    NSString* statusName=@"  ";
    switch (status) {
        case -1:
            statusName=@"  商品退货中";
            break;
        case 1:
            statusName=@"  请您尽快完成付款，15分钟订单会自动取消";
            break;
        case 2:
            statusName=@"  拇指小哥正在备货，我们感谢您的耐心等待……";
            break;
        case 3:
        case 4:
            statusName=@"  拇指小哥狂奔中，马上到:)";
            break;
        case 5:
            statusName=@"  已完成，拇指便利感谢您的光临。";
            break;
        case 6:
            statusName=@"  订单已取消";
            break;
    }
    return  statusName;
}

-(UIImage*) getStatusImage{
    NSInteger status=[_data[0][@"status"] integerValue];
    NSString* statusName=@"center_img";
    switch (status) {
        case -1:
            statusName=@"detail_thz";
            break;
        case 1:
            statusName=@"detail_dfk";
            break;
        case 2:
            statusName=@"detail_dfh";
            break;
        case 3:
        case 4:
            statusName=@"detail_psz";
            break;
        case 5:
            statusName=@"detail_ywc";
            break;
        case 6:
            statusName=@"detail_yqx";
            break;
    }
    return   [UIImage imageNamed:statusName];
}

-(void)reshData{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dic = @{@"user_id":userid,@"order_id":self.orderId,@"sub_order_id":self.subOrderId};
    [anle myOrderDetailWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        NSLog(@"myOrderDetailWithDic==%@",models);
        if ([code isEqualToString:@"0"]) {
            [_data removeAllObjects];
            [_data addObjectsFromArray:models];
            [self setOrderInfo];
        }
        [self.activityVC stopAnimate];
    }];
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"订单详情";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    //    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}

-(void)PopVC:(id)sender{
    if(_isToRoot){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
