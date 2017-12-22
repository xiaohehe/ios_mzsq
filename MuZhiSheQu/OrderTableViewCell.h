//
//  OrderTableViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/11/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface OrderTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UILabel *titleLa;//商品名称
@property(nonatomic,strong)UILabel *numLb;//数量
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
