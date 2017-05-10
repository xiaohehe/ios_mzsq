//
//  shopPingJiaViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "ZLPickerBrowserPhoto.h"

@interface shopPingJiaViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *bigTable;
@property(nonatomic,strong)NSString *shop_id;

@end
