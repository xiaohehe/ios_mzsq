//
//  BreakInfoViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//
//零售商家 BreakInfoViewController 零售商家
#import "SuperViewController.h"
#import "ShopModel.h"
#import "OrderConfirmViewController.h"
#import "RCDChatViewController.h"
#import "LoginViewController.h"
typedef void(^reshshoucang) (NSString *str);

@interface BreakInfoViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) ShopModel *shopModel;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,assign)float numberz;
@property(nonatomic,strong)NSIndexPath *indexp;
@property(nonatomic,strong)UILabel *shopCarLa;
@property(nonatomic,strong)UIButton *numberImg;
@property(nonatomic,strong)NSString *titlete;
@property(nonatomic,strong)NSString *shopImg;
@property(nonatomic,strong)NSMutableDictionary *dic;
-(void)reshshocuang:(reshshoucang)block;

@property(nonatomic,assign)BOOL issleep,isopen;
@property(nonatomic,strong)NSString *shop_user_id;
@property(nonatomic,strong)NSString *yunfei,*manduoshaofree;

@property(nonatomic,strong)NSString *gonggao,*tel;
@property(nonatomic,assign)BOOL isPush;

@property(nonatomic,strong)NSString * shop_id;
@property(nonatomic,strong)NSString * user_id;
@property(nonatomic,strong)NSString * type;

@end
