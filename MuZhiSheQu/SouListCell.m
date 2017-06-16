//
//  SouListCell.m
//  MuZhiSheQu
//
//  Created by lmy on 2016/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SouListCell.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@implementation SouListCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    _headImg=[UIImageView new];
    _headImg.contentMode=UIViewContentModeScaleAspectFill;
    _headImg.clipsToBounds=YES;
    [self.contentView addSubview:_headImg];
    
    _titleLa=[UILabel new];
    _titleLa.font=DefaultFont(self.scale);
    [self.contentView addSubview:_titleLa];
    
    _salesLa=[UILabel new];
    _salesLa.font=SmallFont(self.scale);
    _salesLa.textColor=grayTextColor;
    [self.contentView addSubview:_salesLa];
    
    _priceLa=[UILabel new];
    _priceLa.font=SmallFont(self.scale);
    _priceLa.textColor=grayTextColor;
    [self.contentView addSubview:_priceLa];
    
    _price_yuan = [UILabel new];
    _price_yuan.font = [UIFont systemFontOfSize:10*self.scale];
    _price_yuan.textColor = grayTextColor;
    [self.contentView addSubview:_price_yuan];
    
    _lin = [[UILabel alloc]init];
    _lin.backgroundColor=grayTextColor;
    [_price_yuan addSubview:_lin];
    _desLa=[UILabel new];
    _desLa.font=SmallFont(self.scale);
    _desLa.textColor=grayTextColor;
    [self.contentView addSubview:_desLa];
    _ShopName = [UILabel new];
    _ShopName.font =Small10Font(self.scale);
    _ShopName.textColor = grayTextColor;
    [self.contentView addSubview:_ShopName];
    _noMiaoShuShopName = [UILabel new];
    _noMiaoShuShopName.font =Small10Font(self.scale);
    _noMiaoShuShopName.textColor = grayTextColor;
    [self.contentView addSubview:_noMiaoShuShopName];
    _line=[UIImageView new];
    _line.backgroundColor=blackLineColore;
    [self.contentView addSubview:_line];
    
    _jiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_jiaBtn setImage:[UIImage imageNamed:@"na2"] forState:UIControlStateNormal];
    [self.contentView  addSubview:_jiaBtn];
    
    _numLb = [[UILabel alloc]init];
    _numLb.font=SmallFont(self.scale);
    _numLb.textColor=grayTextColor;
    _numLb.textAlignment=NSTextAlignmentCenter;
    _numLb.text=@"0";
    [self.contentView addSubview:_numLb];
    _jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_jianBtn setImage:[UIImage imageNamed:@"na1"] forState:UIControlStateNormal];
    [self.contentView  addSubview:_jianBtn];
}

-(void)layoutSubviews{
    _headImg.frame=CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 75*self.scale);
    _titleLa.frame=CGRectMake(_headImg.right+10*self.scale, 10*self.scale, self.contentView.width-_headImg.right-20*self.scale, 15*self.scale);
    _priceLa.frame=CGRectMake(_headImg.right+10*self.scale, _titleLa.bottom+10*self.scale, _titleLa.width, 10*self.scale);
    [_priceLa sizeToFit];
    _priceLa.height=10*self.scale;
    _price_yuan.frame=CGRectMake(_priceLa.right+5*self.scale, _priceLa.top, 0, 15*self.scale);
    [_price_yuan sizeToFit];
    _price_yuan.height=15*self.scale;
    _lin.frame=CGRectMake(0, _price_yuan.height/2, _price_yuan.width, .5);
    _noMiaoShuShopName.frame = CGRectMake(_headImg.right+10*self.scale, _priceLa.bottom+10*self.scale, _titleLa.width, 10*self.scale);
    _ShopName.frame = CGRectMake(_headImg.right+10*self.scale, _desLa.bottom+10*self.scale, _titleLa.width, 10*self.scale);
    
    _salesLa.frame=CGRectMake(_headImg.right+10*self.scale, _noMiaoShuShopName.bottom+10*self.scale, _titleLa.width, 10*self.scale);
    _jiaBtn.frame=CGRectMake(SCREEN_WIDTH-40, _noMiaoShuShopName.bottom+0*self.scale, 32*self.scale, 32*self.scale);
    _numLb.frame=CGRectMake(_jiaBtn.frame.origin.x-25*self.scale, _noMiaoShuShopName.bottom+5*self.scale, 25*self.scale, 22*self.scale);
    _jianBtn.frame=CGRectMake(_numLb.frame.origin.x-32*self.scale, _noMiaoShuShopName.bottom+0*self.scale, 32*self.scale, 32*self.scale);
    _desLa.frame=CGRectMake(_headImg.right+10*self.scale, _salesLa.bottom+10*self.scale, _titleLa.width, 10*self.scale);

    if (_isShort) {
        _line.frame=CGRectMake(10*self.scale, self.contentView.height-.5, self.contentView.width-20*self.scale, .5);
    }else{
        _line.frame=CGRectMake(0, self.contentView.height-.5, self.contentView.width, .5);
    }
    
}
@end
