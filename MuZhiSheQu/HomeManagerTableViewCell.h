//
//  HomeManagerTableViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface HomeManagerTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UILabel *nameLb;
//@property(nonatomic,strong)UILabel *statusLb;
@property(nonatomic,strong)UILabel *phoneLb;
@property(nonatomic,strong)UIImageView *lineView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
