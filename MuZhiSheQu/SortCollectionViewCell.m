//
//  SortCollectionViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/10/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SortCollectionViewCell.h"
#import "DefaultPageSource.h"

@interface SortCollectionViewCell()
@property(nonatomic,assign) float scale;
@end

@implementation SortCollectionViewCell

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
       // float w = ([UIScreen mainScreen].bounds.size.width-80-10*3)/2;
        self.backgroundColor=[UIColor clearColor];
        
        if (self.sortNameLb==nil) {
            self.sortNameLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width/3,15*self.scale)];
            self.sortNameLb.numberOfLines=1;
            self.sortNameLb.textColor=[UIColor blackColor];

            self.sortNameLb.font=SmallFont(self.scale*0.8);
            [self.contentView addSubview:self.sortNameLb];
        }
    }
    return self;
}
@end
