//
//  OrderViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/10/30.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "ShouHuoDiZhiListViewController.h"
#import "CellView.h"
#import "HuodaoSuessViewController.h"
#import "orderSuessViewController.h"

@interface OrderViewController : SuperViewController
@property(nonatomic,strong)UIImageView *stripVi;
@property(nonatomic,strong)UIControl *topCon, *botCon,*bigCenterCon;
@property(nonatomic,strong)UILabel *shouHuoer,*shouName,*shouTal,*shouAddressLa,*addressLa;
@property(nonatomic,strong)UIScrollView *bigScrollVi;
@property(nonatomic,strong)UIImageView *topArrow;



@property(nonatomic,strong)UIImageView *qqq;
@property(nonatomic,strong)NSString *num;
@property(nonatomic,assign)float zongProce,botPrice;

@property(nonatomic,strong)NSMutableDictionary *bigbigArr;
@property(nonatomic,assign)int sum;
@property(nonatomic,strong)NSString *yunfei,*manduoshao;


@property(nonatomic,strong)NSMutableArray *gouwucheData;
@property(nonatomic,strong)NSString *shop_id,*tel;
@end
