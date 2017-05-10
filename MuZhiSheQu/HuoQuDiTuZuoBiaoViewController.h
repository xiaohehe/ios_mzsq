//
//  HuoQuDiTuZuoBiaoViewController.h
//  HuanBaoWeiShi
//
//  Created by mac on 15/7/15.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "SuperViewController.h"

typedef void(^HuoQuDiTuZuoBiaoBlock)(NSDictionary *dic);

@interface HuoQuDiTuZuoBiaoViewController : SuperViewController

- (void)getZuoBiaoBlock:(HuoQuDiTuZuoBiaoBlock)block;

@end
