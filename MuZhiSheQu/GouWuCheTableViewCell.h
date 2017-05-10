//
//  GouWuCheTableViewCell.h
//  LunTai
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GouWuCheTableViewCellDelegate <NSObject>
-(void)GouWuCheTableViewCellSelected:(BOOL)selected indexPath:(NSIndexPath *)indexPath;
-(void)GouWuCheTableViewCellNumber:(NSString *)number indexPath:(NSIndexPath *)indexPath;
-(void)GouWuCheTableViewCellIndexpath:(NSIndexPath *)indexPath;
@end
@interface GouWuCheTableViewCell : UITableViewCell
@property(nonatomic,strong)UIButton *SelectedBtn;
@property(nonatomic,strong)UIImageView *GoodsImg;
@property(nonatomic,strong)UILabel *GoodsName;
@property(nonatomic,strong)UILabel *xiaoliangLa;
@property(nonatomic,strong)UILabel *GoodsPrice;
@property(nonatomic,strong)NSString *gnumber;
@property(nonatomic,strong)NSString *gprice;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UILabel *SumLabel;

@property(nonatomic,strong)UILabel * yuanJiaLab;

@property(nonatomic,strong)UILabel * lin;

@property(nonatomic,assign)BOOL isDetail;
@property(nonatomic,assign)BOOL hiddenBtn;
@property(nonatomic,strong)UIImageView *jiantouImg,*selectImg;
@property(nonatomic,assign)id<GouWuCheTableViewCellDelegate>delegate;
@end
