//
//  BreakInfoCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BreakInfoTableViewCell.h"
#import "SuperViewController.h"
#import "ShopModel.h"


@implementation BreakInfoCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self newView];
    }
    return self;

}
-(void)newView{
    self.selectBtn=[UIButton new];
    self.selectBtn.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:self.selectBtn];
    
    self.descriptionLab=[UILabel  new];
    self.descriptionLab.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:self.descriptionLab];
    
    self.headImg = [UIImageView new];
    self.headImg.contentMode=UIViewContentModeScaleAspectFill;
    self.headImg.clipsToBounds=YES;

    [self.contentView addSubview:_headImg];
    
    self.titleLa = [UILabel new];
    self.titleLa.font = DefaultFont(self.scale);
    self.titleLa.numberOfLines=0;
    [self.contentView addSubview:_titleLa];
    
    self.salesLa = [UILabel new];
    self.salesLa.font = SmallFont(self.scale);
    self.salesLa.textColor = grayTextColor;
    [self.contentView addSubview:_salesLa];
    
    self.numberLa = [UILabel new];
//    self.numberLa.layer.borderWidth=.5;
    self.numberLa.textAlignment = NSTextAlignmentCenter;
    self.numberLa.font = SmallFont(self.scale);
//    self.numberLa.layer.borderColor = [UIColor colorWithRed:204/255.0 green:205/255.0 blue:206/255.0 alpha:1].CGColor;
//    self.numberLa.text = @"1";
    self.numberLa.textColor = grayTextColor;
    [self.contentView addSubview:_numberLa];
    
    
   
    
    self.addBt = [UIButton new];
     self.addBt.titleLabel.font = SmallFont(self.scale);
    self.addBt.tag = 1000;
       [self.contentView addSubview:_addBt];
   
    self.jianBt = [UIButton new];
    self.jianBt.tag = 1001;
    self.jianBt.titleLabel.font = SmallFont(self.scale);
        [self.contentView addSubview:_jianBt];
    
    
    self.priceLa = [UILabel new];
    self.priceLa.font = SmallFont(self.scale);
    self.priceLa.textColor = [UIColor redColor];
    [self.contentView addSubview:_priceLa];
    
    _price_yuan = [UILabel new];
    _price_yuan.font = [UIFont systemFontOfSize:10*self.scale];
    _price_yuan.textColor = grayTextColor;
    [self.contentView addSubview:_price_yuan];

    _lin = [[UILabel alloc]init];
    _lin.backgroundColor=grayTextColor;
    [_price_yuan addSubview:_lin];

    
    self.SolidLine = [UIView new];
    self.SolidLine.backgroundColor = [UIColor colorWithRed:204/255.0 green:205/255.0 blue:206/255.0 alpha:1];
    [self.contentView addSubview:_SolidLine];
    
    [self.jianBt addTarget:self action:@selector(shopNumberClinck:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBt addTarget:self action:@selector(shopNumberClinck:) forControlEvents:UIControlEventTouchUpInside];
    

}


-(void)shopNumberClinck:(UIButton *)sender{
    if ([Stockpile sharedStockpile].isLogin==NO) {
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(BreakInfoCellChangeNumber:IndexPath:jiaAndJian:)]) {
            [_delegate BreakInfoCellChangeNumber:[NSNumber numberWithInt:0] IndexPath:_indexpath jiaAndJian:NO];
        }
       
        return;
    }

    BOOL starts = '\0';
    _shopModel.virtuale=_shopModel.selectNum;
    switch (sender.tag) {
        case 1000:
            //加加加
            starts=YES;
            _shopModel.selectNum ++;
            _shopModel.virtuale++;
            break;
        case 1001:
            //减减减
            starts=NO;
            _shopModel.selectNum --;
            _shopModel.virtuale--;

        default:
            break;
    }
    
    if (_shopModel.selectNum < 0) {
        _shopModel.selectNum = 0;
        _shopModel.virtuale=0;
    }
    
    if (_shopModel.selectNum==0 ) {
        self.jianBt.hidden=YES;
        self.numberLa.hidden=YES;
    }
    
//    self.shopModel = self.shopModel;

        if (_delegate && [_delegate respondsToSelector:@selector(BreakInfoCellChangeNumber:IndexPath:jiaAndJian:)]) {
            [_delegate BreakInfoCellChangeNumber:[NSNumber numberWithInt:_shopModel.selectNum] IndexPath:_indexpath jiaAndJian:starts];
        }
   
}

-(void)layoutSubviews{
    self.headImg.frame = CGRectMake(10*self.scale, 10*self.scale, 70*self.scale, 52*self.scale);
    float r = self.headImg.right;
    float t = self.headImg.top;
    
    self.titleLa.frame = CGRectMake(r+10, t, self.contentView.width-100*self.scale, 15*self.scale);
    [self.titleLa sizeToFit];
    float b = self.titleLa.bottom;
    float l = self.titleLa.left;
    
    self.salesLa.frame = CGRectMake(l, b+5*self.scale, 70*self.scale, 15*self.scale);
    b = self.salesLa.bottom;
    
    self.priceLa.frame = CGRectMake(l, b+5*self.scale, 100*self.scale, 15*self.scale);
    r = self.numberLa.right;
    [_priceLa sizeToFit];
    _priceLa.height=15*self.scale;
    
    
    _price_yuan.frame=CGRectMake(_priceLa.right+5*self.scale, _priceLa.top, 0, 15*self.scale);
    [_price_yuan sizeToFit];
    _price_yuan.height=15*self.scale;
    
    
    _lin.frame=CGRectMake(0, _price_yuan.height/2, _price_yuan.width, .5);
    
    
    self.jianBt.frame = CGRectMake(self.contentView.bounds.size.width-200/2.25*self.scale, _titleLa.bottom+1*self.scale, 22*self.scale, 22*self.scale);
    r = self.jianBt.right;
    t = self.jianBt.top;
    self.descriptionLab.font=SmallFont(self.scale);
    self.descriptionLab.numberOfLines=1;
    self.descriptionLab.textColor=grayTextColor;
    self.descriptionLab.frame=CGRectMake(self.headImg.left, self.priceLa.bottom+10*self.scale, self.contentView.width-10*self.scale, 15*self.scale);
    
    self.selectBtn.frame=CGRectMake(0, 0, self.width, self.height);
    
    
    self.numberLa.frame = CGRectMake(r+4*self.scale, t+3*self.scale, 30*self.scale, 17*self.scale);
    r = self.numberLa.right;
    
    self.addBt.frame = CGRectMake(r+4*self.scale, t, 22*self.scale, 22*self.scale);

    self.SolidLine.frame = CGRectMake(10*self.scale, self.contentView.bottom-.5, self.contentView.width-20*self.scale, .5);
    
}

- (void)setShopModel:(ShopModel *)shopModel
{
    _shopModel = shopModel;
    
    _numberLa.text  = [NSString stringWithFormat:@"%d", _shopModel.selectNum];
    if (shopModel.selectNum>0) {
        _jianBt.hidden=NO;
        _numberLa.hidden=NO;
    }else{
        _jianBt.hidden=YES;
        _numberLa.hidden=YES;

    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
