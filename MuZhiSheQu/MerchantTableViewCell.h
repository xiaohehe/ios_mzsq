//
//  MerchantTableViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface MerchantTableViewCell : SuperTableViewCell
@property(strong,nonatomic)UIImageView *headImg;//商品图片
@property(nonatomic,strong)UILabel *nameLa;//商品名称
@property(nonatomic,strong)UILabel *summaryLb;
@property(nonatomic,strong)UILabel *addressLa;
@property(nonatomic,strong)UILabel *noticeLb;
@property(nonatomic,strong)UIView *lineView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
