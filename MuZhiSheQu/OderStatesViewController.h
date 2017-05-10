//
//  OderStatesViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "XiePingJiaViewController.h"
#import "RCDChatViewController.h"

@interface OderStatesViewController : SuperViewController<UIAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray *lines;
@property(nonatomic,strong)NSString *orderid;
@property(nonatomic,strong)NSString *smallOder,*price;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)float again;

@end
