//
//  ImageTableViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface ImageTableViewCell : SuperTableViewCell
@property(strong,nonatomic)UIImageView *advertisingImg;//商品图片
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
