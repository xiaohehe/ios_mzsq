//
//  GoodsTableViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsTableViewCell : UITableViewCell
@property(strong,nonatomic)UIImageView *headImg;//商品图片
@property(strong,nonatomic)UIImageView *activityImg;//商品活动图片
@property(nonatomic,strong)UILabel *titleLa;//商品名称
@property(nonatomic,strong)UILabel *desLb;//商品描述
@property(nonatomic,strong)UILabel *priceLa;//商品价格
@property(nonatomic,strong)UIButton *addBt,*subBtn;//增加、减少
@property(nonatomic,strong)UILabel *numLb;//数量
@property(nonatomic,strong)UIImageView *lineView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
