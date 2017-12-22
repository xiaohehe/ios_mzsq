//
//  HotSearchCollectionViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HotSearchCollectionViewCell.h"

@interface HotSearchCollectionViewCell()
@property(nonatomic,assign) float scale;
@end

@implementation HotSearchCollectionViewCell
//这边很关键 CollectionViewCell重用
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scale=1.0;
        if ([[UIScreen mainScreen] bounds].size.height > 480)
        {
            _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
        }
        float w = ([UIScreen mainScreen].bounds.size.width-10*self.scale-10)/4;
        self.backgroundColor=[UIColor clearColor];
        if (self.keywordsLb==nil) {
            self.keywordsLb=[[UILabel alloc]initWithFrame:CGRectMake(5*self.scale, 5*self.scale, w-10*self.scale,25*self.scale)];
            self.keywordsLb.textColor=[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.00];
            self.keywordsLb.font=[UIFont systemFontOfSize:15.0f];
            self.keywordsLb.textAlignment=NSTextAlignmentCenter;
            _keywordsLb.layer.cornerRadius = 5.;//边框圆角大小
            _keywordsLb.layer.masksToBounds = YES;
            _keywordsLb.layer.borderColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.00].CGColor;//边框颜色
            _keywordsLb.layer.borderWidth = 1;//边框宽度

            [self.contentView addSubview:self.keywordsLb];
        }
    }
    return self;
}

+(CGSize)ccellSize{
    CGFloat scale=1.0;
    if ([[UIScreen mainScreen] bounds].size.height > 480){
        scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
    }
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-10*scale-10)/4,35*scale);
}

@end
