//
//  GouWuCheTableViewCell.m
//  LunTai
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "GouWuCheTableViewCell.h"
#import "UIViewAdditions.h"
#define DefaultFont(__scale) [UIFont systemFontOfSize:13*__scale];
#define SmallFont(__scale) [UIFont systemFontOfSize:11*__scale];
#define grayTextColor [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1]

@interface GouWuCheTableViewCell()
@property(nonatomic,assign)float ZSY;
@property(nonatomic,strong)UIView *detailView;
//@property(nonatomic,strong)UILabel *SumLabel;
@property(nonatomic,strong)UIImageView *SumBG;
@property(nonatomic,strong)UIImageView *lingView;


@end
@implementation GouWuCheTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _ZSY = 1;
        if ([[UIScreen mainScreen] bounds].size.height!= 480) {
            _ZSY = [[UIScreen mainScreen] bounds].size.height / 568;
        }
        [self newView];
    }
    return self;
}
-(void)newView{
    _SelectedBtn=[[UIButton alloc]init];
    [_SelectedBtn setBackgroundImage:[UIImage imageNamed:@"na3"] forState:UIControlStateNormal];
    [_SelectedBtn setBackgroundImage:[UIImage imageNamed:@"green"] forState:UIControlStateSelected];
    [_SelectedBtn addTarget:self action:@selector(SelectedEvent:) forControlEvents:UIControlEventTouchUpInside];
    

    [self.contentView addSubview:_SelectedBtn];
    
    _GoodsImg=[[UIImageView alloc]init];
    _GoodsImg.clipsToBounds=YES;
    _GoodsImg.contentMode=UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_GoodsImg];
    
    
    
    _detailView=[[UIView alloc]init];
    [self.contentView addSubview:_detailView];
    

    [self DetailView];
    [self addViewDetail];
    
    _lingView=[[UIImageView alloc]initWithFrame:CGRectZero];
      _lingView.backgroundColor  = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self.contentView addSubview:_lingView];
 
}
-(void)DetailView{
    _GoodsName=[[UILabel alloc]init];
    _GoodsName.font=DefaultFont(self.ZSY);
    _GoodsName.numberOfLines=2;
    [_detailView addSubview:_GoodsName];
    
    
    _xiaoliangLa = [UILabel new];
    _xiaoliangLa.font=DefaultFont(self.ZSY);
    [_detailView addSubview:_xiaoliangLa];
    
    
    _GoodsPrice=[[UILabel alloc]init];
    _GoodsPrice.font=DefaultFont(self.ZSY);
    //_GoodsPrice.textAlignment=NSTextAlignmentRight;
    _GoodsPrice.textColor=[UIColor redColor];
    [_detailView addSubview:_GoodsPrice];
    
    _yuanJiaLab = [[UILabel alloc]init];
    _yuanJiaLab.font = SmallFont(self.ZSY);
    _yuanJiaLab.textColor = [UIColor grayColor];
    [_detailView addSubview:_yuanJiaLab];
    
    _lin = [[UILabel alloc]init];
    _lin.backgroundColor = [UIColor grayColor];
    [_yuanJiaLab addSubview:_lin];
    
}
-(void)addViewDetail{
    
    UIButton *subBtn=[[UIButton alloc]init];
    subBtn.tag = 5;
    [subBtn setBackgroundImage:[UIImage imageNamed:@"na1"] forState:UIControlStateNormal];
    [subBtn addTarget:self action:@selector(ShuLiangEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:subBtn];
    _SumBG=[[UIImageView alloc]init];
//    _SumBG.layer.borderWidth=0.5;
//    _SumBG.layer.borderColor=[UIColor grayColor].CGColor;
    [self.contentView addSubview:_SumBG];
    _SumLabel=[[UILabel alloc]initWithFrame:CGRectMake(subBtn.right, subBtn.top,subBtn.width+2*self.ZSY, subBtn.height)];
    _SumLabel.font=DefaultFont(self.ZSY);
    _SumLabel.layer.borderColor = [UIColor clearColor].CGColor;
    _SumLabel.textAlignment=NSTextAlignmentCenter;
    _SumLabel.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_SumLabel];
    UIButton *addBtn=[[UIButton alloc]init];
    addBtn.tag = 6;
    [addBtn setBackgroundImage:[UIImage imageNamed:@"na2"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(ShuLiangEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addBtn];
}
-(void)ShuLiangEvent:(UIButton *)button{
    UIButton *jian = (UIButton *)[self.contentView viewWithTag:5];
  //  UIButton *jia = (UIButton *)[self.contentView viewWithTag:6];
    NSInteger ma=[_gnumber integerValue];
    if (button.tag == 5) {
        
        if (ma==0) {
            return;
        }else {
            ma--;
        }
       
    }else{
      
        ma++;
    }
    
    _gnumber = [NSString stringWithFormat:@"%ld",(long)ma];
    
    
    if (ma==0 ) {
        jian.hidden=YES;
        _SumLabel.hidden=YES;
        _SumBG.hidden=YES;
    }else{
        jian.hidden=NO;
        _SumLabel.hidden=NO;
        _SumBG.hidden=NO;

    }

    _gnumber=[NSString stringWithFormat:@"%ld",(long)ma];
    if (_delegate && [_delegate respondsToSelector:@selector(GouWuCheTableViewCellNumber:indexPath:)]) {
        [_delegate GouWuCheTableViewCellNumber:_gnumber indexPath:_indexPath];
    }
//    _SumLabel.text=_gnumber;
}
-(void)SelectedEvent:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(GouWuCheTableViewCellSelected:indexPath:)]) {
        [_delegate GouWuCheTableViewCellSelected:sender.selected indexPath:_indexPath];
    }
}
-(void)Selected:(UIButton *)sedner{
    sedner.selected = !sedner.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(GouWuCheTableViewCellIndexpath:)]) {
        [_delegate GouWuCheTableViewCellIndexpath:_indexPath];
    }

}

-(void)setHiddenBtn:(BOOL)hiddenBtn{
    _SelectedBtn.hidden=hiddenBtn;
    _hiddenBtn=hiddenBtn;
}
-(void)setGnumber:(NSString *)gnumber{
    _gnumber=gnumber;
    _SumLabel.text=_gnumber;
}
-(void)layoutSubviews{
     _SelectedBtn.frame=CGRectMake(10*self.ZSY, self.height/2-10*self.ZSY,20*self.ZSY, 20*self.ZSY);
     _GoodsImg.frame=CGRectMake(_SelectedBtn.right+10*self.ZSY, 10*self.ZSY, 70*self.ZSY, 52*self.ZSY);
    _detailView.frame=CGRectMake(_GoodsImg.right+10*self.ZSY, _GoodsImg.top, self.width-_GoodsImg.right-100*self.ZSY,_GoodsImg.height);
    _GoodsName.frame=CGRectMake(0, 0, _detailView.width, 40*self.ZSY);
//    _xiaoliangLa.frame=CGRectMake(0, _GoodsName.bottom, _detailView.width, 20*self.ZSY);
//     _GoodsPrice.frame=CGRectMake(0, _GoodsName.bottom, _GoodsName.width,20*self.ZSY);
//    _yuanJiaLab.frame = CGRectMake(_GoodsPrice.right, _GoodsPrice.top, _GoodsPrice.width, _GoodsPrice.height);
//    
//    _lin.frame = CGRectMake(0, _yuanJiaLab.height/2, _yuanJiaLab.width, 0.5);
    
   
    UIButton *subBtn=(UIButton *)[self.contentView viewWithTag:5];
    subBtn.frame=CGRectMake(self.width-100*self.ZSY, self.height/2-12*self.ZSY, 22*self.ZSY, 22*self.ZSY);
    _SumLabel.frame=CGRectMake(subBtn.right+5*self.ZSY, subBtn.top,subBtn.width+13*self.ZSY, subBtn.height);
    _SumBG.frame=_SumLabel.frame;
    UIButton *addBtn=(UIButton *)[self.contentView viewWithTag:6];
    addBtn.frame=CGRectMake(_SumLabel.right+5*self.ZSY, subBtn.top, subBtn.width, subBtn.height);
   
    _lingView.frame=CGRectMake(0, self.height-.5, self.width, .5);
}
@end
