//
//  LoginViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#include <RongIMKit/RongIMKit.h>
typedef void (^reshGonggao)(NSString *str);
@interface LoginViewController : SuperViewController
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)NSString *first;



@property(nonatomic,assign)BOOL f;
-(void)resggong:(reshGonggao)block;
@end
