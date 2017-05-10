//
//  CenterCell.h
//  BaoJiaHuHang
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperTableViewCell.h"
@interface CenterCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UILabel *cityLabel;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,assign)BOOL isRandHeard;
@property(nonatomic,assign)BOOL hiddenRight;
@property(nonatomic,assign)BOOL hiddenLine;
@end
