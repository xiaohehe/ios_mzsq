//
//  OrderDetailsViewController.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ScrollViewController.h"

@interface OrderDetailsViewController : ScrollViewController
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong)NSString *subOrderId;
@end
