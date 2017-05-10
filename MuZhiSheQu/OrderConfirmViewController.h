//strong
//  OrderConfirmViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "orderSuessViewController.h"
#import "HuodaoSuessViewController.h"
#import "OrderFileViewController.h"
@interface OrderConfirmViewController : SuperViewController
@property(nonatomic,strong)UIImageView *stripVi;
@property(nonatomic,strong)UIControl *topCon, *botCon,*bigCenterCon;
@property(nonatomic,strong)UILabel *shouHuoer,*shouName,*shouTal,*shouAddressLa,*addressLa;
@property(nonatomic,strong)UIScrollView *bigScrollVi;
@property(nonatomic,strong)UIImageView *topArrow;
@property(nonatomic,strong)UITextView *beizhuTF;


@property(nonatomic,strong)UIImageView *qqq;
//@property(nonatomic,strong)NSString *zongProce;
@property(nonatomic,assign)float zongProce;
@property(nonatomic,assign)int num;
@property(nonatomic,strong)NSMutableDictionary *bigbigArr;


@property(nonatomic,strong)NSString *yunfei,*manduoshao;

@property(nonatomic,strong)NSString *shop_id,*tel;

@end
