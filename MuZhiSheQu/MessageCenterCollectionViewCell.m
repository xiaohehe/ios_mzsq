//
//  MessageCenterCollectionViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//
#import "DefaultPageSource.h"
#import "MessageCenterCollectionViewCell.h"
@interface MessageCenterCollectionViewCell()
@property(nonatomic,assign) float scale;
@end
@implementation MessageCenterCollectionViewCell
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
        if (self.coverIv==nil) {
            self.coverIv=[[UIImageView alloc] initWithFrame:CGRectMake((w-40*self.scale)/2, 10*self.scale, 40*self.scale, 40*self.scale)];
            self.coverIv.contentMode=UIViewContentModeScaleAspectFill;
            //self.coverIv.backgroundColor=[UIColor redColor];
            [self.contentView addSubview:self.coverIv];
        }
        if (self.nameLb==nil) {
            self.nameLb=[[UILabel alloc]initWithFrame:CGRectMake(8*self.scale, self.coverIv.bottom+10*self.scale, w-16*self.scale,15*self.scale)];
            self.nameLb.numberOfLines=2;
            self.nameLb.textColor=[UIColor colorWithRed:0.263 green:0.263 blue:0.263 alpha:1.00];
            self.nameLb.textAlignment = NSTextAlignmentCenter;
            //self.goodsNameLb.alpha=.9;
            self.nameLb.font=SmallFont(self.scale);
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
    return CGSizeMake(([[UIScreen mainScreen] bounds].size.width-10*scale)/3,85*scale);
}
@end
