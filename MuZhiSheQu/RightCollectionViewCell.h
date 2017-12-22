//
//  rightCollectionViewCell.h
//  CoCoaLumberjackTest
//
//  Created by wujunyang on 15/10/10.
//  Copyright © 2015年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GoodsCellDelegate <NSObject>

//yes是加   no是减
-(void)BreakInfoCellChangeNumber:(NSNumber *)number IndexPath:(NSIndexPath *)index jiaAndJian:(BOOL)jiaAndJian;
@end

@interface RightCollectionViewCell : UICollectionViewCell
@property(strong,nonatomic)UIImageView *coverIv;//商品图片
//@property(strong,nonatomic)UIView* coverView;//已添加购物车商品覆盖层
@property(strong,nonatomic)UILabel *goodsNameLb;//商品名称
@property(strong,nonatomic)UILabel *goodsDescLb;//商品描述（副标题）
@property(strong,nonatomic)UILabel *goodsPriceLb;//商品价格
@property(strong,nonatomic)UILabel *goodsOldPriceLb;//商品原价

+(CGSize)ccellSize;

@end
