//
//  LiuYanTableViewCell.h
//  BaoJiaHuHang
//
//  Created by apple on 15-1-19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperTableViewCell.h"
@interface LiuYanTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UIImageView *StateImage;
@property(nonatomic,strong)UIButton *bianji;
@end
