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
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UILabel *NumberLabel;
@property(nonatomic,strong)UILabel *PriceLabel;
@property(nonatomic,strong)NSString *addLa;


@property(nonatomic,strong)UILabel *price_yuan;//原价
@property(nonatomic,strong)UILabel *lin;

@end
