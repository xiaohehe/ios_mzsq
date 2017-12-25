//
//  PlotCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/5/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlotCell : UITableViewCell
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *distance;
@property(nonatomic,strong)UIView *line;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
