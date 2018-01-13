//
//  SystemMessageTableViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface SystemMessageTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UILabel *timeLb;//时间
@property(nonatomic,strong)UIView *contentV;
@property(nonatomic,strong)UILabel *titleLa;//
@property(nonatomic,strong)UILabel *contentLb;//
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
