//
//  PaymentCompletionViewController.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperViewController.h"

@interface PaymentCompletionViewController : SuperViewController
@property(nonatomic,strong)NSString *payType;
@property(nonatomic,strong)NSString *integral;
@property(nonatomic,strong)NSString *allMoney;
@property(nonatomic,strong)NSString *orderID;
@end
