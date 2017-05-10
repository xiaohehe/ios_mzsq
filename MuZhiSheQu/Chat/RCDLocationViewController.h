//
//  RCDLocationViewController.h
//  AdultStore
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface RCDLocationViewController : RCLocationPickerViewController
@property(nonatomic,assign)BOOL orcancal;//是否返回详细地址；
@property(nonatomic,strong)UIButton *btn;
@end
