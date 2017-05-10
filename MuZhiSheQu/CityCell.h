//
//  CityCell.h
//  BaoJiaHuHang
//
//  Created by apple on 15/5/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperTableViewCell.h"
@interface CityCell : SuperTableViewCell
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UILabel *titleLabel;
@end
