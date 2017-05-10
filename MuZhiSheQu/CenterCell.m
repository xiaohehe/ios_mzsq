//
//  CenterCell.m
//  BaoJiaHuHang
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CenterCell.h"
#import "SuperViewController.h"

@interface CenterCell()
@property(nonatomic,strong)UIImageView *blineImg;
@property(nonatomic,strong)UIImageView *wlineImg;
@property(nonatomic,strong)UIImageView *rightImg;
@end
@implementation CenterCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    
        
        _blineImg=[[UIImageView alloc]init];
        _blineImg.backgroundColor=blackLineColore;
        [self.contentView addSubview:_blineImg];
        _wlineImg=[[UIImageView alloc]init];
        _wlineImg.backgroundColor=blackLineColore;
        [self.contentView addSubview:_wlineImg];
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.font=DefaultFont(self.scale);
        _titleLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        _cityLabel=[[UILabel alloc]init];
        _cityLabel.font=SmallFont(self.scale);
        _cityLabel.backgroundColor=[UIColor clearColor];
        _cityLabel.textColor=grayTextColor;
        [self.contentView addSubview:_cityLabel];
        
        _phoneLabel=[[UILabel alloc]init];
        _phoneLabel.font=SmallFont(self.scale);
        _phoneLabel.textAlignment=NSTextAlignmentRight;
        _phoneLabel.textColor = grayTextColor;
        [self.contentView addSubview:_phoneLabel];
    
        _headImage=[[UIImageView alloc]init];
         _headImage.contentMode=UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_headImage];
        
        _rightImg=[[UIImageView alloc]init];
        _rightImg.image=[UIImage imageNamed:@"xq_right"];
        [self.contentView addSubview:_rightImg];
        
    }
    return self;
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
//    _indexPath = indexPath;
//    if (indexPath.row == 0) {
//        _blineImg.hidden = YES;
//        _wlineImg.hidden = YES;
//    }else
//    {
//        _blineImg.hidden = NO;
//        _wlineImg.hidden = NO;
//    }
}
-(void)setHiddenLine:(BOOL)hiddenLine{
    _blineImg.hidden=hiddenLine;
}
-(void)setHiddenRight:(BOOL)hiddenRight{
    _rightImg.hidden=hiddenRight;
   _wlineImg.hidden=!hiddenRight;
}
-(void)layoutSubviews{
    _headImage.frame=CGRectMake(10*self.scale, self.height/2-10*self.scale, 20*self.scale, 20*self.scale);
    _titleLabel.frame=CGRectMake(_headImage.right+10*self.scale, 0, self.width-_headImage.right-35*self.scale, self.height-1*self.scale) ;
    _phoneLabel.frame=CGRectMake(self.width/2, _titleLabel.top, self.width/2-35*self.scale, _titleLabel.height);
    _rightImg.frame=CGRectMake(self.width-30*self.scale, self.height/2-12*self.scale, 24*self.scale, 24*self.scale);
    _blineImg.frame=CGRectMake(10*self.scale, self.height-.5, self.width-20*self.scale, 0.5);
    _wlineImg.frame=CGRectMake(0, self.height-.5, self.width, 0.5);
    if (_isRandHeard)
    {
         _titleLabel.frame=CGRectMake(_headImage.right+10*self.scale, 5*self.scale, self.width-_headImage.right-45*self.scale, (self.height-1*self.scale)/2) ;
        _cityLabel.frame=CGRectMake(_titleLabel.left, _titleLabel.bottom, _titleLabel.width, _titleLabel.height/2);
        _headImage.layer.masksToBounds=YES;
        _headImage.layer.cornerRadius = _headImage.height/2;
    }
}
@end
