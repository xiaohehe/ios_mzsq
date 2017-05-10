//
//  ShangJiaTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
#import "ShopInfoViewController.h"
@protocol ShangJiaTableViewCellDelegate <NSObject>
-(void)ShangJiaTableViewCellEnterShop:(NSIndexPath *)indexPath;
@end

@interface ShangJiaTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *HeadImage;
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UILabel *TypeLabel;
@property(nonatomic,strong)UILabel *AdressLabel;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,assign)id<ShangJiaTableViewCellDelegate>delegate;
@end
