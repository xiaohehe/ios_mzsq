//
//  BreakFirstViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "GanXiShopViewController.h"

@interface BreakFirstViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *shop_type;
@property(nonatomic,strong)NSString *is_weishop;
@property(nonatomic,strong)NSString *namet;
@end
