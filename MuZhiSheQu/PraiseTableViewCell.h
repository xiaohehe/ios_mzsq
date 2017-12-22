//
//  PraiseTableViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface PraiseTableViewCell : SuperTableViewCell
@property(strong,nonatomic)UIImageView *headImg;//头像
@property(nonatomic,strong)UILabel *nameLa;//姓名
@property(nonatomic,strong)UILabel *desLb;//描述
@property(nonatomic,strong)UILabel *dateLa;//日期
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
