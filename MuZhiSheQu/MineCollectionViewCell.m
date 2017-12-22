//
//  MineCollectionViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/8/12.
//  Copyright © 2017年 apple. All rights reserved.
//
#import "DefaultPageSource.h"
#import "MineCollectionViewCell.h"
@interface MineCollectionViewCell()
@property(nonatomic,assign) float scale;
@end
@implementation MineCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scale=1.0;
        if ([[UIScreen mainScreen] bounds].size.height > 480){
            _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
        }
        float w = ([UIScreen mainScreen].bounds.size.width-10*_scale)/4;
        self.backgroundColor=[UIColor clearColor];
        if (self.coverIv==nil) {
            self.coverIv=[[UIImageView alloc] initWithFrame:CGRectMake((w-25*self.scale)/2, 15*self.scale, 23*self.scale, 20*self.scale)];
            self.coverIv.contentMode=UIViewContentModeScaleAspectFill;
            //self.coverIv.clipsToBounds=YES;
            //self.coverIv.layer.cornerRadius=5;
            //self.coverIv.userInteractionEnabled=YES;
            [self.contentView addSubview:self.coverIv];
        }
        if (self.nameLb==nil) {
            self.nameLb=[[UILabel alloc]initWithFrame:CGRectMake(8*self.scale, self.coverIv.bottom+10*self.scale, w-16*self.scale,15*self.scale)];
            self.nameLb.numberOfLines=2;
            self.nameLb.textColor=[UIColor blackColor];
            self.nameLb.textAlignment = NSTextAlignmentCenter;
            //self.goodsNameLb.alpha=.9;
            self.nameLb.font=SmallFont(self.scale*0.8);
            [self.contentView addSubview:self.nameLb];
        }
    }
    return self;
}

+(CGSize) cellSize{
    CGFloat scale=1.0;
    if ([[UIScreen mainScreen] bounds].size.height > 480){
        scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
    }
    return CGSizeMake(([[UIScreen mainScreen] bounds].size.width-10*scale)/4,70*scale);
}

@end
