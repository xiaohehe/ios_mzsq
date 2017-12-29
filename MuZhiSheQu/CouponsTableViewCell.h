//
//  CouponsTableViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface CouponsTableViewCell : SuperTableViewCell
@property(strong,nonatomic)UIImageView *statusIv;
@property(nonatomic,strong)UILabel *priceLa;
@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,strong)UILabel *nameLa;
@property(nonatomic,strong)UILabel *desLb;
@property(nonatomic,strong)UIImageView *selectedIv;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
