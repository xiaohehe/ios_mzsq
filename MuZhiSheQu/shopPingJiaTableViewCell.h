//
//  shopPingJiaTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
#import <UIKit/UIKit.h>

@protocol shopDelegect <NSObject>

-(void)imageChange:(NSIndexPath *)indexPath imgCount:(NSInteger)index number:(NSInteger)number imgData:(NSArray *)imgdata;

@end

typedef void(^ImageBlock)(int ImageCount,NSIndexPath *indexPath);
@interface shopPingJiaTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *headImg,*image1,*image2,*image3,*image4,*image5,*image6;
@property(nonatomic,strong)UILabel *name,*context,*time;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,assign)NSInteger imgCount;
@property(nonatomic,strong)UIView *imgVi;
@property(nonatomic,strong)NSMutableArray *data,*imgData;
@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,assign)id<shopDelegect>delegect;
@end
