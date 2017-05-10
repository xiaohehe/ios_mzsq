//
//  ShangPinTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShangPinTableViewCell.h"
@interface ShangPinTableViewCell()
@property(nonatomic,strong)UIImageView *RigthImage;
@property(nonatomic,strong)UIImageView *lineView;
@end
@implementation ShangPinTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    
    _HeaderImage=[[UIImageView alloc]init];
    _HeaderImage.contentMode=UIViewContentModeScaleAspectFill;
    _HeaderImage.clipsToBounds=YES;

    [self.contentView addSubview:_HeaderImage];
    
    _NameLabel=[[UILabel alloc]init];
    _NameLabel.font=DefaultFont(self.scale);
    _NameLabel.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_NameLabel];
    
    _NumberLabel=[[UILabel alloc]init];
    _NumberLabel.backgroundColor=[UIColor clearColor];
    _NumberLabel.textColor=grayTextColor;
    _NumberLabel.font=SmallFont(self.scale);
    [self.contentView addSubview:_NumberLabel];
    
    _PriceLabel=[[UILabel alloc]init];
    _PriceLabel.backgroundColor=[UIColor clearColor];
    _PriceLabel.textColor=[UIColor redColor];
    _PriceLabel.font=DefaultFont(self.scale);
    [self.contentView addSubview:_PriceLabel];
    
    _price_yuan = [UILabel new];
    _price_yuan.font = [UIFont systemFontOfSize:10*self.scale];
    _price_yuan.textColor = grayTextColor;
    [self.contentView addSubview:_price_yuan];
    _lin = [[UILabel alloc]init];
    _lin.backgroundColor=grayTextColor;
    [_price_yuan addSubview:_lin];

    
    _RigthImage=[[UIImageView alloc]init];
     _RigthImage.image=[UIImage imageNamed:@"xq_right"];
    [self.contentView addSubview:_RigthImage];
    
    _lineView=[[UIImageView alloc]init];
    _lineView.backgroundColor=blackLineColore;
    [self.contentView addSubview:_lineView];
}
-(void)layoutSubviews{
    _HeaderImage.frame=CGRectMake(10*self.scale, 10*self.scale, 80*self.scale, self.height-20*self.scale);
    _NameLabel.frame=CGRectMake(_HeaderImage.right+10*self.scale, _HeaderImage.top, self.width-_HeaderImage.right-40*self.scale, 20*self.scale);
    _NumberLabel.frame=CGRectMake(_NameLabel.left, _NameLabel.bottom, _NameLabel.width, _NameLabel.height);
    _PriceLabel.frame=CGRectMake(_NameLabel.left, _NumberLabel.bottom, _NameLabel.width, _NameLabel.height);
    
    [_PriceLabel sizeToFit];
    _PriceLabel.height=10*self.scale;
    
    _price_yuan.frame=CGRectMake(_PriceLabel.right+5*self.scale, _PriceLabel.top, 0, 15*self.scale);
    [_price_yuan sizeToFit];
    _price_yuan.height=15*self.scale;
    
    
    _lin.frame=CGRectMake(0, _price_yuan.height/2, _price_yuan.width, .5);

    _RigthImage.frame=CGRectMake(self.width-30*self.scale, self.height/2-12*self.scale, 24*self.scale, 24*self.scale);
    _lineView.frame=CGRectMake(0, self.height-.5, self.width, .5);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
