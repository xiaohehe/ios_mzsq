//
//  XiangQingTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"


@protocol ShareTableViewCellDelegate <NSObject>
-(void)ShareTableViewCellWith:(NSIndexPath *)indexPath;
-(void)BigImageTableViewCellWith:(NSIndexPath *)indexPath ImageIndex:(NSInteger)index;
-(void)CanZuoTableViewCellWith:(NSIndexPath *)indexPath Selected:(BOOL)selected;
@end



@interface XiangQingTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *HeaderImage;
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,assign)NSInteger zanCount;
@property(nonatomic,strong)UILabel *ContentLabel;
@property(nonatomic,strong)UIImageView *Logo1Image;
@property(nonatomic,strong)UIImageView *Logo2Image;
@property(nonatomic,strong)UIImageView *Logo3Image;
@property(nonatomic,strong)UILabel *DateLabel;

@property(nonatomic,strong)UIButton *CaoZuoButton;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,assign)id<ShareTableViewCellDelegate>delegate;

@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,assign)NSInteger imgCount;
@property(nonatomic,strong)NSMutableArray *imgData;

@property(nonatomic,strong)UIImageView *imgvi;

@property(nonatomic,strong)UIView *BackView;
@property(nonatomic,strong)LineView *lineView;


@property(nonatomic,strong)UIButton *ZanButton;
@end
