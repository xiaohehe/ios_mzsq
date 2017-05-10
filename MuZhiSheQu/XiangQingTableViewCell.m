//
//  XiangQingTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "XiangQingTableViewCell.h"

@implementation XiangQingTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self newView];
    }
    return self;
}
-(void)newView{
    self.backgroundColor=[UIColor clearColor];
    
    _BackView=[[UIView alloc]init];
    _BackView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:_BackView];
    
    _HeaderImage=[[UIImageView alloc]init];
    //  _HeaderImage.contentMode=UIViewContentModeScaleAspectFill;
    _HeaderImage.userInteractionEnabled=YES;
    _HeaderImage.tag=49;
    [_BackView addSubview:_HeaderImage];
    
    _NameLabel=[[UILabel alloc]init];
    _NameLabel.font=DefaultFont(self.scale);
    _NameLabel.backgroundColor=[UIColor clearColor];
    _NameLabel.textColor=blueTextColor;
    [_BackView addSubview:_NameLabel];
    
    _ContentLabel=[[UILabel alloc]init];
    _ContentLabel.font=DefaultFont(self.scale);
    _ContentLabel.numberOfLines=0;
    [_BackView addSubview:_ContentLabel];
    
    
    _Logo1Image=[[UIImageView alloc]init];
    _Logo1Image.userInteractionEnabled=YES;
    //_Logo1Image.contentMode=UIViewContentModeScaleAspectFit;
    _Logo1Image.tag=50;
    [_BackView addSubview:_Logo1Image];
    
    _Logo2Image=[[UIImageView alloc]init];
    _Logo2Image.userInteractionEnabled=YES;
    //_Logo2Image.contentMode=UIViewContentModeScaleAspectFit;
    _Logo2Image.tag=51;
    [_BackView addSubview:_Logo2Image];
    
    _Logo3Image=[[UIImageView alloc]init];
    _Logo3Image.userInteractionEnabled=YES;
    // _Logo3Image.contentMode=UIViewContentModeScaleAspectFit;
    _Logo3Image.tag=52;
    [_BackView addSubview:_Logo3Image];
    
    _DateLabel=[[UILabel alloc]init];
    _DateLabel.font=SmallFont(self.scale);
    // _DateLabel.textAlignment=NSTextAlignmentRight;
    _DateLabel.textColor=grayTextColor;
    _DateLabel.backgroundColor=[UIColor clearColor];
    
    _lineView=[[LineView alloc]init];
    [_BackView addSubview:_lineView];
    
    [_BackView addSubview:_DateLabel];
    
//    UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
//    UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
//    UITapGestureRecognizer *tap3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
//    UITapGestureRecognizer *tap4 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
//    [_HeaderImage addGestureRecognizer:tap4];
//    [_Logo1Image  addGestureRecognizer:tap1];
//    [_Logo2Image  addGestureRecognizer:tap2];
//    [_Logo3Image  addGestureRecognizer:tap3];
    
    //UILongPressGestureRecognizer *longTap=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ShareEvent:)];
    // [self.contentView addGestureRecognizer:longTap];
    
    
    _imgvi = [UIImageView new];
    [self.contentView addSubview:_imgvi];
    
    _CaoZuoButton=[[UIButton alloc]init];
    [_CaoZuoButton setImage:[UIImage imageNamed:@"gg_xin"] forState:UIControlStateNormal];
//    [_CaoZuoButton addTarget:self action:@selector(CaoZuoButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_CaoZuoButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [self.contentView addSubview:_CaoZuoButton];
    
    _ZanButton=[[UIButton alloc]init];
    [_ZanButton setBackgroundImage: [UIImage imageNamed:@"gg_zan_b"] forState:UIControlStateNormal];
//    [_ZanButton addTarget:self action:@selector(ShareEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_ZanButton setTitle:@"赞" forState:UIControlStateNormal];
    _ZanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    _ZanButton.clipsToBounds=YES;
    [_ZanButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    _ZanButton.titleLabel.font=SmallFont(self.scale);
    [self.contentView addSubview:_ZanButton];
    
}
//-(void)BigImage:(UIGestureRecognizer *)G{
//    
//    UIView *view=[G view];
//    if (_delegate && [_delegate respondsToSelector:@selector(BigImageTableViewCellWith:ImageIndex:)]) {
//        [_delegate BigImageTableViewCellWith:self.indexPath ImageIndex:view.tag-50];
//    }
//}
-(void)layoutSubviews{
    _BackView.frame=CGRectMake(0, 0, self.width, self.height);
    _HeaderImage.frame=CGRectMake(10*self.scale,10*self.scale,40*self.scale,40*self.scale);
    _NameLabel.frame=CGRectMake(_HeaderImage.right+ 10*self.scale, _HeaderImage.top, _BackView.width-20*self.scale-_HeaderImage.right, 25*self.scale);
    _ContentLabel.frame=CGRectMake(_NameLabel.left, _NameLabel.bottom, _NameLabel.width, 35*self.scale);
    [_ContentLabel sizeToFit];
 
    
    _DateLabel.frame=CGRectMake(_ContentLabel.left,_ContentLabel.bottom+10*self.scale, 200*self.scale, 15*self.scale);
    
    
    if (_imgvi) {
        [_imgvi removeFromSuperview];
        
        _imgvi = [UIImageView new];
        //_imgVi.backgroundColor=blackLineColore;
        [self.contentView addSubview:_imgvi];
        
    }
    
    
    
    
    // float setY =_ContentLabel.bottom+10*self.scale;
    
    if (self.imgCount>0) {
        
        _imgvi.frame = CGRectMake(_ContentLabel.left, _DateLabel.bottom+5*self.scale, self.contentView.width-_ContentLabel.left-10*self.scale, 100*self.scale);
        
        
        float W=(_imgvi.width-40*self.scale)/3;
        for (int i=0; i<self.imgCount; i++) {
            
            float x = (W+10*self.scale)*(i%3);
            float y = (W-10*self.scale)*(i/3);
            
            
            
            UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(x, y+5*self.scale, W, W*0.75)];
            
            NSString *url=@"";
            NSString *cut = self.imgData[i];
            NSString *imagename = [cut lastPathComponent];
            NSString *path = [cut stringByDeletingLastPathComponent];
            NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb320."]];
//            if (cut.length>0) {
//                url = [cut substringToIndex:[cut length] - 4];
//                
//            }
//            [im setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb320.jpg",url]] placeholderImage:[UIImage imageNamed:@"not_1"]];
            [im setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"not_1"]];
                
            im.tag=i+1;
            im.userInteractionEnabled=YES;
            im.backgroundColor=[UIColor redColor];
            [_imgvi addSubview:im];
            
            _imgvi.height=im.bottom+10*self.scale;
            UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
            
            [im addGestureRecognizer:tap1];
            
            _imgvi.height=im.bottom+10*self.scale;
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    _CaoZuoButton.frame=CGRectMake(self.width-35*self.scale, _DateLabel.top+3*self.scale, 25*self.scale, 15*self.scale);
    _ZanButton.frame=CGRectMake(_CaoZuoButton.left, _CaoZuoButton.top-5*self.scale, 0, 22*self.scale);
    
    
    
    _lineView.frame=CGRectMake(0, self.height-1, self.width, 1);
}

-(void)BigImage:(UITapGestureRecognizer *)tap{
    
    
    NSLog(@"%d",tap.view.tag);
    
    if (_delegate && [_delegate respondsToSelector:@selector(BigImageTableViewCellWith:ImageIndex:)]) {
        [_delegate BigImageTableViewCellWith:_indexPath ImageIndex:tap.view.tag-1];
    }
    
    
}

//-(void)ShareEvent:(id)sender{
//    
//    _CaoZuoButton.selected=NO;
//    if (_delegate && [_delegate respondsToSelector:@selector(ShareTableViewCellWith:)]) {
//        [_delegate ShareTableViewCellWith:_indexPath];
//    }
//}
//-(void)CaoZuoButtonEvent:(UIButton *)button{
//    button.selected=!button.selected;
//    if (_delegate && [_delegate respondsToSelector:@selector(CanZuoTableViewCellWith:Selected:)]) {
//        [_delegate CanZuoTableViewCellWith:_indexPath Selected:_CaoZuoButton.selected];
//    }
//}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selected"]) {
        if (_CaoZuoButton.selected) {
            [UIView animateWithDuration:.3 animations:^{
                _ZanButton.frame=CGRectMake(_CaoZuoButton.left-55*self.scale, _CaoZuoButton.top-5*self.scale, 48*self.scale, 22*self.scale);
            }];
            
        }else{
            [UIView animateWithDuration:.3 animations:^{
                _ZanButton.frame=CGRectMake(_CaoZuoButton.left, _CaoZuoButton.top-5*self.scale, 0, 22*self.scale);
            }];
        }
    }
}
-(void)dealloc{
    [_CaoZuoButton removeObserver:self forKeyPath:@"selected" context:nil];
}

@end
