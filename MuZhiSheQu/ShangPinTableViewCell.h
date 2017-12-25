//
//  ShangPinTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface ShangPinTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *HeaderImage;
@property(strong,nonatomic)UIImageView *activityImg;//商品活动图片
@property(nonatomic,strong)UIView* coverView;
@property(nonatomic,strong)UILabel* loseEfficacy;

@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UILabel *NumberLabel;
@property(nonatomic,strong)UILabel *PriceLabel;
@property(nonatomic,strong)NSString *addLa;
@property(nonatomic,strong)UIButton *addBt,*subBtn;//增加、减少
@property(nonatomic,strong)UILabel *numLb;//数量

@property(nonatomic,strong)UILabel *price_yuan;//原价
@property(nonatomic,strong)UILabel *lin;
@property(nonatomic,strong)UIImageView *lineView;

@end
