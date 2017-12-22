//
//  HistoryLogTableViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface HistoryLogTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UILabel *nameLb;
@property(nonatomic,strong)UILabel *timeLb;
@property(nonatomic,strong)UIImageView *lineView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
