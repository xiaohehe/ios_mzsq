//
//  MessageCenterTableViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface MessageCenterTableViewCell : SuperTableViewCell
@property(strong,nonatomic)UIImageView *headImg;//商品图片
@property(nonatomic,strong)UILabel *titleLa;//商品名称
@property(nonatomic,strong)UILabel *desLb;//商品描述
@property(nonatomic,strong)UILabel *numLb;//数量
@property(strong,nonatomic)UIImageView *rightImg;//商品活动图片
@property(nonatomic,strong)UIImageView *lineView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
