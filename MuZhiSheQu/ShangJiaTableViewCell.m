//
//  ShangJiaTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShangJiaTableViewCell.h"
@interface ShangJiaTableViewCell()
@property(nonatomic,strong)UIImageView *lineView;
@property(nonatomic,strong)UIButton *EnterButton;
@end
@implementation ShangJiaTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    _HeadImage=[[UIImageView alloc]init];
   _HeadImage.layer.masksToBounds=YES;
    [self.contentView addSubview:_HeadImage];
    
    _NameLabel=[[UILabel alloc]init];
    _NameLabel.font=DefaultFont(self.scale);
    _NameLabel.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_NameLabel];
    
    _TypeLabel=[[UILabel alloc]init];
    _TypeLabel.font=SmallFont(self.scale);
    _TypeLabel.textColor=grayTextColor;
    [self.contentView addSubview:_TypeLabel];
    
    _AdressLabel=[[UILabel alloc]init];
    _AdressLabel.font=SmallFont(self.scale);
    _AdressLabel.textColor=grayTextColor;
    _AdressLabel.numberOfLines=0;
    [self.contentView addSubview:_AdressLabel];
    
    _EnterButton=[[UIButton alloc]init];
    [_EnterButton setBackgroundImage:[UIImage setImgNameBianShen:@"index_btn_b"] forState:UIControlStateNormal];
    [_EnterButton setBackgroundImage:[UIImage setImgNameBianShen:@"btn"] forState:UIControlStateHighlighted];
    [_EnterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_EnterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _EnterButton.titleLabel.font=Small10Font(self.scale);
    [_EnterButton setTitle:@"进入店铺" forState:UIControlStateNormal];
    [_EnterButton addTarget:self action:@selector(EnterButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_EnterButton];
    
    _lineView=[[UIImageView alloc]init];
    _lineView.backgroundColor=blackLineColore;
    [self.contentView addSubview:_lineView];
    
}
-(void)EnterButton:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(ShangJiaTableViewCellEnterShop:)]) {
        [_delegate ShangJiaTableViewCellEnterShop:_indexPath];
    }
}
-(void)layoutSubviews{
    _HeadImage.frame=CGRectMake(10*self.scale, 10*self.scale, self.height-20*self.scale, self.height-20*self.scale) ;
    _HeadImage.layer.cornerRadius=_HeadImage.height/4;
    
    _NameLabel.frame=CGRectMake(_HeadImage.right+10*self.scale, _HeadImage.top, self.width-_HeadImage.right-90*self.scale, 20*self.scale) ;
    _TypeLabel.frame=CGRectMake(_NameLabel.left, _NameLabel.bottom, _NameLabel.width, 15*self.scale) ;
    _AdressLabel.frame=CGRectMake(_NameLabel.left, _TypeLabel.bottom, _NameLabel.width, 35*self.scale);
    _EnterButton.frame=CGRectMake(self.width-75*self.scale, _TypeLabel.bottom, 60*self.scale, 20*self.scale);
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
