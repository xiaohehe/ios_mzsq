//
//  BusinessInfoViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "CellView.h"
#import <ShareSDK/ShareSDK.h>
#import "LoginViewController.h"

#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

typedef void (^reshshoplist)(NSString *str);
@interface BusinessInfoViewController : SuperViewController<UIWebViewDelegate>
@property(nonatomic,strong)UIImageView *topImg;
@property(nonatomic,strong)UIScrollView *bigScroll;
@property(nonatomic,strong)UIView *shopBigVi,*start;
@property(nonatomic,strong)CellView *gongGaoCell,*jieShaoCell,*pingJiaCell;
@property(nonatomic,strong)UILabel *nameLa;
@property(nonatomic,strong)NSString *shop_id;
@property(nonatomic,strong)UILabel *phoneLa;

-(void)reshShopList:(reshshoplist)block;
@end
