//
//  ShengHuoTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 17/1/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShengHuoTableViewCell.h"

@implementation ShengHuoTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}

-(void)newView{

    _img = [UIImageView new];
    _img.contentMode=UIViewContentModeScaleAspectFill;
    _img.clipsToBounds=YES;
    [self.contentView addSubview:_img];

    _titleLa = [UILabel new];
    _titleLa.numberOfLines=0;
    _titleLa.font=DefaultFont(self.scale);
    [self.contentView addSubview:_titleLa];
    
    _addressLa = [UILabel new];
    _addressLa.numberOfLines=3;

    _addressLa.font=SmallFont(self.scale);
    _addressLa.textColor=grayTextColor;
    [self.contentView addSubview:_addressLa];
    
    _telBtn = [UIButton new];

    [_telBtn setImage:[UIImage imageNamed:@"tel_new"] forState:0];
    [self.contentView addSubview:_telBtn];
    
    _shangPinJianJieLab = [UILabel new];
    _shangPinJianJieLab.font = SmallFont(self.scale);
    _shangPinJianJieLab.textColor = grayTextColor;
    [self.contentView addSubview:_shangPinJianJieLab];
    
    _line=[UIView new ];
    _line.backgroundColor=blackLineColore;
    [self.contentView addSubview:_line];

}

-(void)layoutSubviews{

    
    _img.frame=CGRectMake(15*self.scale, 15*self.scale, 80*self.scale, 60*self.scale);
    _titleLa.frame=CGRectMake(_img.right+10*self.scale, _img.top, self.contentView.width-_img.right-60*self.scale, 20*self.scale);
    _addressLa.frame=CGRectMake(_titleLa.left, _titleLa.bottom+0*self.scale, _titleLa.width, 0);
    [_addressLa sizeToFit];
    
    _telBtn.frame=CGRectMake(self.contentView.width-40*self.scale, self.contentView.centerY, 30*self.scale, 30*self.scale);
    _telBtn.centerY=self.contentView.centerY;
    
    CGFloat shangPinJianJieY = _addressLa.bottom > _telBtn.bottom?_addressLa.bottom:_telBtn.bottom;
  
    [_shangPinJianJieLab sizeToFit];
    _shangPinJianJieLab.frame = CGRectMake(_img.right + 10*self.scale, shangPinJianJieY+10*self.scale,self.contentView.size.width - (15+20)*self.scale - _img.width, _shangPinJianJieLab.height);
    
    _line.frame=CGRectMake(10*self.scale, self.contentView.height-.5, self.contentView.width-20*self.scale, .5);
}

@end
