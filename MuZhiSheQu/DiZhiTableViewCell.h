//
//  DiZhiTableViewCell.h
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
@protocol DiZhiTableViewCellDelegate <NSObject>
-(void)DiZhiTableViewCellSetDefault:(BOOL)isDefault IndexPath:(NSIndexPath *)indexPath;
-(void)DiZhiTableViewCellCaoZuo:(BOOL) isEdit IndexPath:(NSIndexPath *)indexPath;
@end
@interface DiZhiTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *DefaultImage;
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UILabel *AdressLabel;
@property(nonatomic,strong)UILabel *DefaultLabel;
@property(nonatomic,strong)UIButton *SetDefaultButton;
@property(nonatomic,strong)UIButton *EditButton;
@property(nonatomic,strong)UIButton *DeleteButton;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UIImageView *TopLine;
@property(nonatomic,strong)UIImageView *BottomLine;
@property(nonatomic,assign)BOOL isDefault;
@property(nonatomic,assign)id<DiZhiTableViewCellDelegate>delegate;
@end
