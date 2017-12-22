//
//  EquityTableViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface EquityTableViewCell : SuperTableViewCell
@property(strong,nonatomic)UIImageView *iconIv;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *desLb;
@property(nonatomic,strong)UIImageView *lineView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
