//
//  GoodsCollectionViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/8/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "GoodsCollectionViewCell.h"
#import "DefaultPageSource.h"

@interface GoodsCollectionViewCell()
@property(nonatomic,assign) float scale;
@end
@implementation GoodsCollectionViewCell
//这边很关键 CollectionViewCell重用
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scale=1.0;
        if ([[UIScreen mainScreen] bounds].size.height > 480){
            _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
        }
        float w = ([UIScreen mainScreen].bounds.size.width-10*_scale)/3;
        self.backgroundColor=[UIColor clearColor];
        if (self.goodsCoverIv==nil) {
            self.goodsCoverIv=[[UIImageView alloc] initWithFrame:CGRectMake(8*self.scale, 5*self.scale, w-16*self.scale, w-16*self.scale)];
            self.goodsCoverIv.contentMode=UIViewContentModeScaleAspectFill;
            self.goodsCoverIv.clipsToBounds=YES;
            self.goodsCoverIv.layer.cornerRadius=5;
            self.goodsCoverIv.userInteractionEnabled=YES;
            [self.contentView addSubview:self.goodsCoverIv];
        }
        if (self.goodsNameLb==nil) {
            self.goodsNameLb=[[UILabel alloc]initWithFrame:CGRectMake(8*self.scale, self.goodsCoverIv.bottom+5*self.scale, w-16*self.scale,15*self.scale)];
            self.goodsNameLb.numberOfLines=2;
            self.goodsNameLb.textColor=[UIColor blackColor];
            //la.textAlignment = NSTextAlignmentCenter;
            //self.goodsNameLb.alpha=.9;
            self.goodsNameLb.font=SmallFont(self.scale*0.8);
            [self.contentView addSubview:self.goodsNameLb];
        }
        if (self.goodsDescLb==nil) {
            self.goodsDescLb=[[UILabel alloc]initWithFrame:CGRectMake(8*self.scale, self.goodsNameLb.bottom, w-16*self.scale, 15*self.scale)];
            self.goodsDescLb.textColor = grayTextColor;
            self.goodsDescLb.font = Small10Font(self.scale*0.75);
            [self.contentView addSubview:self.goodsDescLb];
        }
        if (self.goodsPriceLb==nil) {
            self.goodsPriceLb=[[UILabel alloc]init];
            self.goodsPriceLb.textColor = [UIColor colorWithRed:1.000 green:0.149 blue:0.149 alpha:1.00];
            self.goodsPriceLb.font = Small10Font(self.scale*0.6);
            [self.contentView addSubview:self.goodsPriceLb];
        }
        if (self.goodsOldPriceLb==nil) {
            self.goodsOldPriceLb=[[UILabel alloc]init];
            self.goodsOldPriceLb.textColor = grayTextColor;
            self.goodsOldPriceLb.font = Small10Font(self.scale*0.75);
            [self.contentView addSubview:self.goodsOldPriceLb];
        }
    }
    return self;
}

+(CGSize) cellSize{
    CGFloat scale=1.0;
    if ([[UIScreen mainScreen] bounds].size.height > 480){
        scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
    }
    return CGSizeMake(([[UIScreen mainScreen] bounds].size.width-10*scale)/3,140*scale);
}

@end
