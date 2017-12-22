//
//  MineCollectionViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/8/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCollectionViewCell : UICollectionViewCell
@property(strong,nonatomic)UIImageView *coverIv;//图片
@property(strong,nonatomic)UILabel *nameLb;//名称
+(CGSize) cellSize;
@end
