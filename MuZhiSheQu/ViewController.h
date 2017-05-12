//
//  ViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "RCDChatListViewController.h"
#import "LunBoWebViewController.h"
#import "ShangjiaJinZhuViewController.h"
#import "WoYaoKaiWiDianViewController.h"
#import "deiletWebViewViewController.h"
#import "BreakInfoViewController.h"
#import "ShopInfoViewController.h"

@interface ViewController : SuperViewController
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong) NSMutableDictionary* shopDictionary;//购物车商品及数量字典

@end

