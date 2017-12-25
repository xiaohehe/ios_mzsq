//
//  GoodsCollectionViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/8/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCollectionViewCell : UICollectionViewCell
@property(strong,nonatomic)UIImageView *goodsCoverIv;//商品图片
@property(strong,nonatomic)UILabel *goodsNameLb;//商品名称
@property(strong,nonatomic)UILabel *goodsDescLb;//商品描述（副标题）
@property(strong,nonatomic)UILabel *goodsPriceLb;//商品价格
@property(strong,nonatomic)UILabel *goodsOldPriceLb;//商品原价

+(CGSize) cellSize;

@end
