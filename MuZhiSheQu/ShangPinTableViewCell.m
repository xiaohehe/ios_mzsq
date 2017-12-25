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
    _HeaderImage.layer.cornerRadius=5;
    _HeaderImage.layer.masksToBounds=YES;
    [self.contentView addSubview:_HeaderImage];
    _coverView=[[UIImageView alloc]init];
    _coverView.contentMode=UIViewContentModeScaleAspectFill;
    _coverView.backgroundColor=[UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.4];
    _coverView.clipsToBounds=YES;
    _coverView.layer.cornerRadius=5;
    _coverView.layer.masksToBounds=YES;
    _loseEfficacy=[[UILabel alloc]init];
    _loseEfficacy.font=DefaultFont(self.scale);
    _loseEfficacy.backgroundColor=[UIColor clearColor];
    _loseEfficacy.textAlignment=NSTextAlignmentCenter;
    _loseEfficacy.textColor = [UIColor whiteColor];
    _loseEfficacy.text=@"已失效";
    [_coverView addSubview:_loseEfficacy];
    [self.contentView addSubview:_coverView];
    _NameLabel=[[UILabel alloc]init];
    _NameLabel.font=DefaultFont(self.scale);
    _NameLabel.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_NameLabel];
    _NumberLabel=[[UILabel alloc]init];
    _NumberLabel.backgroundColor=[UIColor clearColor];
    _NumberLabel.textColor=grayTextColor;
    _NumberLabel.font=SmallFont(self.scale*0.9);
    [self.contentView addSubview:_NumberLabel];
    _PriceLabel=[[UILabel alloc]init];
    _PriceLabel.backgroundColor=[UIColor clearColor];
    _PriceLabel.textColor=[UIColor colorWithRed:1.000 green:0.373 blue:0.000 alpha:1.00];
    _PriceLabel.font=SmallFont(self.scale*0.7);
    [self.contentView addSubview:_PriceLabel];
    _price_yuan = [UILabel new];
    _price_yuan.font = [UIFont systemFontOfSize:10*self.scale];
    _price_yuan.textColor = grayTextColor;
    [self.contentView addSubview:_price_yuan];
    _lin = [[UILabel alloc]init];
    _lin.backgroundColor=grayTextColor;
    [_price_yuan addSubview:_lin];
//    _RigthImage=[[UIImageView alloc]init];
//     _RigthImage.image=[UIImage imageNamed:@"xq_right"];
//    [self.contentView addSubview:_RigthImage];
    self.numLb = [UILabel new];
    self.numLb.textAlignment = NSTextAlignmentCenter;
    self.numLb.font = SmallFont(self.scale);
    [self.contentView addSubview:_numLb];
    self.addBt = [UIButton new];
    self.addBt.titleLabel.font = SmallFont(self.scale);
    [self.addBt setImage:[UIImage imageNamed:@"na7"]forState:UIControlStateNormal];
    //self.addBt.tag = 1000;
    [self.contentView addSubview:_addBt];
    self.subBtn = [UIButton new];
    //self.subBtn.tag = 1001;
    [self.subBtn setImage:[UIImage imageNamed:@"na8"] forState:UIControlStateNormal];
    self.subBtn.titleLabel.font = SmallFont(self.scale);
    [self.contentView addSubview:_subBtn];
    
    _lineView=[[UIImageView alloc]init];
    [_lineView setImage:[UIImage imageNamed:@"imaginary_line"]];
    //_lineView.backgroundColor=blackLineColore;
    [self.contentView addSubview:_lineView];
}

-(void)layoutSubviews{
    _HeaderImage.frame=CGRectMake(10*self.scale, 10*self.scale, 60*self.scale, 60*self.scale);
    _coverView.frame=CGRectMake(10*self.scale, 10*self.scale, 60*self.scale, 60*self.scale);
    _loseEfficacy.frame=CGRectMake(0, 0, 60*self.scale, 60*self.scale);
    _NameLabel.frame=CGRectMake(_HeaderImage.right+10*self.scale, _HeaderImage.top, self.contentView.width-90*self.scale, 20*self.scale);
    _NumberLabel.frame=CGRectMake(_NameLabel.left, _NameLabel.bottom+5*self.scale,self.contentView.width-95*self.scale-80*self.scale, 15*self.scale);
    _PriceLabel.frame=CGRectMake(_NameLabel.left, _NumberLabel.bottom+5*self.scale, 100*self.scale, 15*self.scale);
    [_PriceLabel sizeToFit];
    //_PriceLabel.height=10*self.scale;
    //_price_yuan.frame=CGRectMake(_PriceLabel.right+5*self.scale, _PriceLabel.top, 0, 15*self.scale);
    //[_price_yuan sizeToFit];
   // _price_yuan.height=15*self.scale;
   // _lin.frame=CGRectMake(0, _price_yuan.height/2, _price_yuan.width, .5);
   // _RigthImage.frame=CGRectMake(self.width-30*self.scale, self.height/2-12*self.scale, 24*self.scale, 24*self.scale);
    _lineView.frame=CGRectMake(10*self.scale, self.height-.5, self.width-20*self.scale, .5);
    self.subBtn.frame = CGRectMake(_NumberLabel.right+5*self.scale-6*self.scale, _NumberLabel.top-9*self.scale, 28*self.scale, 40*self.scale);
    self.subBtn.contentEdgeInsets = UIEdgeInsetsMake(9*self.scale,3*self.scale, 9*self.scale, 3*self.scale);
   // r = self.subBtn.right;
    //t = self.subBtn.top;
    self.numLb.frame = CGRectMake(self.subBtn.right+4*self.scale-3*self.scale, self.subBtn.top+5.5*self.scale+6*self.scale, 25*self.scale, 17*self.scale);
    //r = self.numLb.right;
    self.addBt.frame = CGRectMake(self.numLb.right+4*self.scale-6*self.scale, self.subBtn.top, 28*self.scale, 40*self.scale);
    self.addBt.contentEdgeInsets = UIEdgeInsetsMake(9*self.scale,3*self.scale, 9*self.scale, 3*self.scale);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
