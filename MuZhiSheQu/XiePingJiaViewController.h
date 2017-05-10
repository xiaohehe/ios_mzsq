//
//  XiePingJiaViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^reshdalock)(NSMutableArray *arr);
@interface XiePingJiaViewController : SuperViewController
@property(nonatomic,strong)NSMutableArray *assetss;
@property(nonatomic,strong)NSString *shopid;

@property(nonatomic,assign)BOOL is_order_on;

@property(nonatomic,strong)NSString *order_on;
@property(nonatomic,assign)BOOL lingshou;
-(void)reshBlock:(reshdalock)block;


@end
