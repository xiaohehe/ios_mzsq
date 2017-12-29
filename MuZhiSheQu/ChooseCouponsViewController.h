//
//  ChooseCouponsViewController.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "PassValueDelegate.h"

@interface ChooseCouponsViewController : SuperViewController
@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;
@property(nonatomic,copy)NSString * couponID;
@property(nonatomic,copy)NSString * money;
@end
