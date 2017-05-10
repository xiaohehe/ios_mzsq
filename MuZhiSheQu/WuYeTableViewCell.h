//
//  WuYeTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 17/3/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface WuYeTableViewCell : SuperTableViewCell
@property (nonatomic,retain)NSMutableArray * pictureArray;
@property (nonatomic,retain)UILabel * titleLab;
@property (nonatomic,retain)UILabel * contentLab;
@property (nonatomic,retain)UIView * pictureView;
@property (nonatomic,retain)UILabel * timeLab;
@property (nonatomic,assign)NSInteger pictureNumber;
@property (nonatomic,retain)NSString * contentString;
@property (nonatomic,retain)NSString * titleString;
@property (nonatomic,strong)NSIndexPath * indexPath;
@property (nonatomic,retain)UILabel *lin;
@property (nonatomic,assign)id delegate;
@end
@protocol WuYeTableViewCellDelegate <NSObject>
-(void)BigImageTableViewCellWith:(NSIndexPath *)indexPath ImageIndex:(NSInteger)index;
@end
