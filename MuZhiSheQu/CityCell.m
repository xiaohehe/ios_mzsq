//
//  CityCell.m
//  BaoJiaHuHang
//
//  Created by apple on 15/5/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CityCell.h"
#import "DefaultPageSource.h"
#import "LineView.h"
@interface CityCell()
@property(nonatomic,strong)LineView *blineImg;
@property(nonatomic,strong)UIImageView *rightImg;
@end
@implementation CityCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
    
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.backgroundColor=[UIColor clearColor];
        _titleLabel.font=[UIFont systemFontOfSize:13*self.scale];
        [self.contentView addSubview:_titleLabel];
        
        _rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.width-20*self.scale, self.height/2-9*self.scale, 10*self.scale, 18*self.scale)];
        _rightImg.image=[UIImage imageNamed:@"nr_icon_r"];
        _rightImg.hidden=YES;
        [self.contentView addSubview:_rightImg];
        
        
        _blineImg=[[LineView alloc]initWithFrame:CGRectMake(0, 0, self.width-20*self.scale, 1)];
        [self.contentView addSubview:_blineImg];
    }
    return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.backgroundColor=[UIColor clearColor];
        _titleLabel.font=[UIFont systemFontOfSize:13*self.scale];
        [self.contentView addSubview:_titleLabel];
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.backgroundColor=[UIColor clearColor];
        _titleLabel.font=[UIFont systemFontOfSize:13*self.scale];
        [self.contentView addSubview:_titleLabel];
        
        _rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.width-20*self.scale, self.height/2-9*self.scale, 10*self.scale, 18*self.scale)];
        _rightImg.image=[UIImage imageNamed:@"nr_icon_r"];
        _rightImg.hidden=YES;
        [self.contentView addSubview:_rightImg];
        
        
        _blineImg=[[LineView alloc]initWithFrame:CGRectMake(0, 0, self.width-20*self.scale, 1)];
        [self.contentView addSubview:_blineImg];
        
     
    }
    return self;
}
-(void)layoutSubviews{
    _titleLabel.frame=CGRectMake(10*self.scale, 1, self.width-45*self.scale, self.height-1);
    _rightImg.frame =CGRectMake(self.width-20*self.scale, self.height/2-9*self.scale, 10*self.scale, 18*self.scale);
    _rightImg.contentMode=UIViewContentModeScaleAspectFit;
    _blineImg.frame =CGRectMake(0,0, self.width, 1);
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (indexPath.row == 0) {
        _blineImg.hidden = YES;
       
    }else
    {
        _blineImg.hidden = NO;
    }
}
@end
