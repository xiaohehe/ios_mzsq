//
//  MessageCenterCollectionViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterCollectionViewCell : UICollectionViewCell
@property(strong,nonatomic)UIImageView *coverIv;//图片
@property(strong,nonatomic)UILabel *nameLb;//名称
+(CGSize) cellSize;
@end
