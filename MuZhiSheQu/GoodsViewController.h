//
//  GoodsViewController.h
//  MuZhiSheQu
//
//  Created by lt on 2017/8/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "ShopModel.h"
#import "OrderConfirmViewController.h"
#import "RCDChatViewController.h"
#import "LoginViewController.h"

@interface GoodsViewController : SuperViewController<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)float numberz;
@property(nonatomic,strong)NSIndexPath *indexp;
@property(nonatomic,strong)UILabel *shopCarLa;
@property(nonatomic,strong)UIButton *numberImg;
@property(nonatomic,strong)NSString *titlete;
@property(nonatomic,strong)NSString *shopImg;
@property(nonatomic,strong)NSMutableDictionary *dic;
@property(nonatomic,assign)BOOL issleep,isopen;
@property(nonatomic,strong)NSString *shop_user_id;
@property(nonatomic,strong)NSString *yunfei,*manduoshaofree;
@property(nonatomic,strong)NSString *gonggao,*tel;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,strong)NSString * shop_id;
@property(nonatomic,strong)NSString * user_id;
@property(nonatomic,strong)NSString * type;
@end
