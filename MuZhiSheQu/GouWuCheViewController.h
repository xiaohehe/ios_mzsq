//
//  GouWuCheViewController.h
//  LunTai
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "SuperViewController.h"
#import "OrderViewController.h"
#import "OrderConfirmViewController.h"
#import "BreakInfoViewController.h"



@interface GouWuCheViewController : SuperViewController
@property(nonatomic,assign)BOOL popTwoVi,islunbo,fromLingShou;
@property(nonatomic,assign)BOOL isShowBack;
@property(nonatomic,strong)void (^reshNum)(NSString *str);
@property(nonatomic,strong)void (^ifQing)(NSString *str);
@property(nonatomic,strong)void (^reshLingShou)(NSString *str);

@end
