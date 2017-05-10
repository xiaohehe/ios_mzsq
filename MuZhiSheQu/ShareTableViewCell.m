//
//  ShareTableViewCell.m
//  Wedding
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShareTableViewCell.h"
#import "DefaultPageSource.h"
@interface ShareTableViewCell()<UIAlertViewDelegate>
//@property(nonatomic,strong)UIButton *ShareBtn;
@property(nonatomic,strong)UIView *BackView;
@property(nonatomic,strong)LineView *lineView;


@end
@implementation ShareTableViewCell
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
    
    _headBtn = [UIButton new];
    _headBtn.titleLabel.font=DefaultFont(self.scale);
    [_headBtn setTitleColor:blueTextColor forState:UIControlStateNormal];
    [_BackView addSubview:_headBtn];
    
//    _NameLabel=[[UILabel alloc]init];
//    _NameLabel.font=DefaultFont(self.scale);
//    _NameLabel.backgroundColor=[UIColor clearColor];
//    _NameLabel.textColor=blackTextColor;
//    [_BackView addSubview:_NameLabel];
    
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
    
    UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
    UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
    UITapGestureRecognizer *tap3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
   // UITapGestureRecognizer *tap4 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
//[_HeaderImage addGestureRecognizer:tap4];
    [_Logo1Image  addGestureRecognizer:tap1];
      [_Logo2Image  addGestureRecognizer:tap2];
      [_Logo3Image  addGestureRecognizer:tap3];
    
    //UILongPressGestureRecognizer *longTap=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ShareEvent:)];
  // [self.contentView addGestureRecognizer:longTap];
    
    
    _imgvi = [UIImageView new];
    [self.contentView addSubview:_imgvi];
    
    
    _zanvi = [UIButton new];
    //_zanvi.userInteractionEnabled=YES;
    [self.contentView addSubview:_zanvi];
    
    
   
    _commitvi=[UIButton new];
    //_commitvi.userInteractionEnabled=YES;
    [self.contentView addSubview:_commitvi];
    
    
    _CaoZuoButton=[[UIButton alloc]init];
    [_CaoZuoButton setImage:[UIImage imageNamed:@"gg_xin"] forState:UIControlStateNormal];
    [_CaoZuoButton addTarget:self action:@selector(CaoZuoButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_CaoZuoButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [self.contentView addSubview:_CaoZuoButton];
    
    
    _chakan = [UILabel new];
    _chakan.text=@"查看全文";
    _chakan.textColor=blueTextColor;
    _chakan.font=SmallFont(self.scale);
   [self.contentView addSubview:_chakan];
    
    
    _ju = [UIButton new];
    [_ju setTitle:@"举报" forState:0];
    [_ju setTitleColor:grayTextColor forState:0];
    _ju.titleLabel.font=SmallFont(self.scale);
    [self.contentView addSubview:_ju];
    
    //评论 赞的父视图
    _zanBigView=[[UIScrollView alloc]init];
    _zanBigView.userInteractionEnabled=YES;
    [self.contentView addSubview:_zanBigView];
    
    //_zanBigView.backgroundColor=[UIColor redColor];
    _zanView=[[UIImageView alloc]init];
    [_zanView setImage:[UIImage imageNamed:@"lj_2"]];
    _zanView.userInteractionEnabled=YES;
    [_zanBigView addSubview:_zanView];
    
    //_zanView.backgroundColor=[UIColor redColor];
    _ZanButton=[[UIButton alloc]init];
    [_ZanButton setImage: [UIImage imageNamed:@"zanlj_3"] forState:UIControlStateNormal];
    [_ZanButton addTarget:self action:@selector(ShareEvent:) forControlEvents:UIControlEventTouchUpInside];
    _ZanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    _ZanButton.imageEdgeInsets=UIEdgeInsetsMake(0, -3, 0, 3);
    _ZanButton.clipsToBounds=YES;
    [_ZanButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    _ZanButton.titleLabel.font=SmallFont(self.scale);
    _ZanButton.userInteractionEnabled=YES;
    [_zanView addSubview:_ZanButton];

    _jianjiao=[UIImageView new];
   
    
    _fengeLine=[UIImageView new];
   
    
    _spaceLine=[UIImageView new];
    _spaceLine.backgroundColor=[UIColor colorWithRed:63/255.0 green:73/255.0 blue:97/255.0 alpha:1.0];
    [_zanView addSubview:_spaceLine];
    _pingLunButton=[[UIButton alloc]init];
    [_pingLunButton setImage: [UIImage imageNamed:@"comlj_4"] forState:UIControlStateNormal];
    [_pingLunButton addTarget:self action:@selector(pingLunEvent:) forControlEvents:UIControlEventTouchUpInside];
    _pingLunButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    _pingLunButton.imageEdgeInsets=UIEdgeInsetsMake(0, -2, 0, 2);
    _pingLunButton.clipsToBounds=YES;
    _pingLunButton.userInteractionEnabled=YES;
    [_pingLunButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    _pingLunButton.titleLabel.font=SmallFont(self.scale);
    [_zanView addSubview:_pingLunButton];
    
//    _pingLunButton.backgroundColor=[UIColor blueColor];
}
//-(void)BigImage:(UIGestureRecognizer *)G{
//  
//    NSLog(@"%d",G.view.tag);
//    
//    UIView *view=[G view];
//        if (_delegate && [_delegate respondsToSelector:@selector(BigImageTableViewCellWith:ImageIndex:)]) {
//            [_delegate BigImageTableViewCellWith:self.indexPath ImageIndex:view.tag-50];
//        }
//}

-(void)tap:(UIButton *)tap{
    
}




-(void)setImgData:(NSMutableArray *)imgData{

    if (_imgvi) {
        [_imgvi removeFromSuperview];
        
        _imgvi = [UIImageView new];
        _imgvi.userInteractionEnabled=YES;
        [self.contentView addSubview:_imgvi];
        
        
    }
    if (self.imgCount>0) {
        //        _imgvi.userInteractionEnabled=YES;
//        _imgvi.frame = CGRectMake(_ContentLabel.left, _ContentLabel.bottom, self.contentView.width-100*self.scale, 100*self.scale);
        
        float W=(self.contentView.width-100*self.scale)/3;
        for (int i=0; i<self.imgCount; i++) {
            
            float x = (W+10*self.scale)*(i%3);
            float y = (W-10*self.scale)*(i/3);
            
            
            UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(x, y+5*self.scale, W, W*0.75)];
            im.contentMode=UIViewContentModeScaleAspectFill;
            im.clipsToBounds=YES;
            NSString *url=@"";
            NSString *cut = imgData[i];
            NSString *imagename = [cut lastPathComponent];
            NSString *path = [cut stringByDeletingLastPathComponent];
            NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb320."]];
//            if (cut.length>0) {
//                url = [cut substringToIndex:[cut length] - 4];
//                
//            }
//            [im setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb320.jpg",url]] placeholderImage:[UIImage imageNamed:@"za"]];
             [im setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
            
            
            im.tag=i+1;
            im.userInteractionEnabled=YES;
            [_imgvi addSubview:im];
            
            UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
            [im addGestureRecognizer:tap1];
            _imgvi.height=im.bottom+0*self.scale;
            //qqY=_imgvi.bottom;
            
            
            
        }
        
        
        
    }




}


-(void)layoutSubviews{
    _BackView.frame=CGRectMake(0, 0, self.width, self.height);
     _HeaderImage.frame=CGRectMake(10*self.scale,10*self.scale,40*self.scale,40*self.scale);
    
    _headBtn.frame=CGRectMake(_HeaderImage.right+10*self.scale, _HeaderImage.top, 0, 25*self.scale);
    [_headBtn sizeToFit];
    _headBtn.height=25*self.scale;
    
    
    
//    _NameLabel.frame=CGRectMake(_headBtn.right+ 0*self.scale, _HeaderImage.top, _BackView.width-_headBtn.right, 25*self.scale);
    _ContentLabel.frame=CGRectMake(_headBtn.left, _headBtn.bottom, self.width-_HeaderImage.right-20*self.scale, 0*self.scale);
    [_ContentLabel sizeToFit];
  
    
    
    
    float qqY = _ContentLabel.bottom;
    
    

    if (self.imgCount>0) {
        _imgvi.frame = CGRectMake(_ContentLabel.left, _ContentLabel.bottom, self.contentView.width-100*self.scale, _imgvi.height);
        qqY=_imgvi.bottom;
    }
//    for (UIView *vi in _imgvi.subviews) {
//        [vi removeFromSuperview];
//    }
//    if (_imgvi) {
//        [_imgvi removeFromSuperview];
//        
//        _imgvi = [UIImageView new];
//        _imgvi.userInteractionEnabled=YES;
//        [self.contentView addSubview:_imgvi];
//        
//
//    }
//    if (self.imgCount>0) {
////        _imgvi.userInteractionEnabled=YES;
//        _imgvi.frame = CGRectMake(_ContentLabel.left, qqY, self.contentView.width-_ContentLabel.left-10*self.scale, 100*self.scale);
//        
//        float W=(_imgvi.width-40*self.scale)/3;
//        for (int i=0; i<self.imgCount; i++) {
//            
//            float x = (W+10*self.scale)*(i%3);
//            float y = (W-10*self.scale)*(i/3);
//            
//            
//            UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(x, y+5*self.scale, W, W*0.75)];
//            im.contentMode=UIViewContentModeScaleAspectFill;
//            im.clipsToBounds=YES;
//            NSString *url=@"";
//            NSString *cut = self.imgData[i];
//            if (cut.length>0) {
//                url = [cut substringToIndex:[cut length] - 4];
//                
//            }
//            [im setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb320.jpg",url]] placeholderImage:[UIImage imageNamed:@"za"]];
//            
//            
//            im.tag=i+1;
//            im.userInteractionEnabled=YES;
//            [_imgvi addSubview:im];
//            
//            UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
//            [im addGestureRecognizer:tap1];
//            _imgvi.height=im.bottom+10*self.scale;
//            qqY=_imgvi.bottom;
//            
//            
//            
//        }
//        
//        
//        
//    }

      _DateLabel.frame=CGRectMake(_ContentLabel.left,qqY+5*self.scale, 200*self.scale, 15*self.scale);
    [_DateLabel sizeToFit];
    
    
    _chakan.frame=CGRectMake(_DateLabel.right+10*self.scale, _DateLabel.top, 60*self.scale, _DateLabel.height);
    
    _ju.frame=CGRectMake(_chakan.right+0*self.scale, _chakan.top, 30*self.scale, _chakan.height);
    
    qqY=_DateLabel.bottom+5*self.scale;
    
    if (_zanvi) {
        [_zanvi removeFromSuperview];
        _zanvi = [UIButton new];
        _zanvi.backgroundColor=superBackgroundColor;
        _zanvi.userInteractionEnabled=YES;
        [self.contentView addSubview:_zanvi];
        
    }
    
    
       if (_zanCount>0) {
           _zanvi.frame = CGRectMake(_ContentLabel.left, qqY+10*self.scale, self.contentView.width-_ContentLabel.left-10*self.scale, 10);

           UIImageView *xin = [[UIImageView alloc]initWithFrame:CGRectMake(5*self.scale, 4*self.scale, 12*self.scale, 12*self.scale)];
           xin.image =[UIImage imageNamed:@"gg_xin_3"];
           //xin.backgroundColor=[UIColor redColor];
           xin.contentMode=UIViewContentModeScaleToFill;
           [_zanvi addSubview:xin];

        NSString *str = @"";
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(5*self.scale, 3*self.scale, _zanvi.width-10*self.scale, 10)];
        name.numberOfLines=0;
            for (NSDictionary *dic in self.zanData) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",dic[@"user_name"]]];
                }
             str = [str substringToIndex:str.length-1];
            qqY = name.bottom;
        str = [@"" stringByAppendingString:[NSString stringWithFormat:@"    %@",str]];
           name.text=str;
           name.textColor=[UIColor colorWithRed:69/255.0 green:83/255.0 blue:114/255.0 alpha:1];
        name.font=[UIFont systemFontOfSize:12*self.scale];
        
           
      
           
           
        
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGSize size = [str boundingRectWithSize:CGSizeMake(_zanvi.width-10*self.scale, 3500*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        name.height=size.height;
        name.backgroundColor=[UIColor clearColor];
        [_zanvi addSubview:name];
        _zanvi.height=name.bottom+3*self.scale;
        [_zanvi addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
           
           
             
               _jianjiao.image=[UIImage imageNamed:@"lj_5"];
               _jianjiao.frame=CGRectMake(25*self.scale, -5*self.scale, 10*self.scale, 5*self.scale);
               [_zanvi addSubview:_jianjiao];
           
           
           
    }
    //_zanvi.backgroundColor=[UIColor redColor];
    if (_commitvi) {
        [_commitvi removeFromSuperview];
        _commitvi = [UIButton new];
        _commitvi.backgroundColor=superBackgroundColor;
        _commitvi.userInteractionEnabled=YES;
        [self.contentView addSubview:_commitvi];
    }
    
    if (_zanvi.height>0) {
        _commitvi.frame=CGRectMake(_ContentLabel.left, _zanvi.bottom, self.contentView.width-_ContentLabel.left-10*self.scale, 0*self.scale);
        
        
        _fengeLine.backgroundColor=blackLineColore;
        _fengeLine.frame=CGRectMake(8*self.scale,0, _zanvi.width-16*self.scale, .5);
       [_commitvi addSubview:_fengeLine];
        
    }else{
        _commitvi.frame=CGRectMake(_ContentLabel.left, qqY+10*self.scale, self.contentView.width-_ContentLabel.left-10*self.scale, 0*self.scale);
        if (_jianjiao) {
            [_jianjiao removeFromSuperview];
            _jianjiao.image=[UIImage imageNamed:@"lj_5"];
            _jianjiao.frame=CGRectMake(25*self.scale, -5*self.scale, 10*self.scale, 5*self.scale);
            [_commitvi addSubview:_jianjiao];
        }

    }
    
    if (_commitCount>0) {
       
        float setY=5*self.scale;
        for (int i=0; i<_commitDic.count; i++) {
            UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(5*self.scale, setY, self.contentView.width-_ContentLabel.left-30*self.scale, 0)];
            la.font=[UIFont systemFontOfSize:12*self.scale];
            la.numberOfLines=0;
            //la.textColor=grayTextColor;
            NSString *string=[NSString stringWithFormat:@"%@：%@",_commitDic[i][@"user_name"],_commitDic[i][@"content"]];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
            
            NSRange range=[string rangeOfString:[NSString stringWithFormat:@"%@：",_commitDic[i][@"user_name"]]];
            
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:69/255.0 green:83/255.0 blue:114/255.0 alpha:1] range:range];
            
            la.attributedText=str;
        
            [la sizeToFit];
            
            [_commitvi addSubview:la];
            setY=la.bottom+5*self.scale;
            _commitvi.height+=(la.height+5*self.scale);
            
        }
        _commitvi.height+=5*self.scale;
        [_commitvi addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        
            }else{
        _commitvi.height=0;
                [_jianjiao removeFromSuperview];
    }
    
    
    _commitvi.backgroundColor=superBackgroundColor;
    
    _CaoZuoButton.frame=CGRectMake(self.width-35*self.scale, _DateLabel.top-3.5*self.scale, 30*self.scale, 30*self.scale);
    //_CaoZuoButton.backgroundColor=[UIColor redColor];
    
    
    
    
    _zanBigView.frame=CGRectMake(_CaoZuoButton.left, _CaoZuoButton.top+0*self.scale, 0, 30*self.scale);
    _zanView.frame=CGRectMake(0, 0, 150*self.scale, 30*self.scale);
    
    
    _lineView.frame=CGRectMake(0, self.height-1, self.width, 1);
}


-(UIImageView *)commitviFrom:(NSDictionary *)data{
    NSLog(@"%@",data);
    
    UIImageView *img=[UIImageView new];
    img.frame=CGRectMake(_ContentLabel.left, _zanvi.bottom, self.contentView.width-_ContentLabel.left-10*self.scale, 0);
    float setY=0;
    for (int i=0; i<data.count; i++) {
        UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, setY, self.contentView.width-_ContentLabel.left-30*self.scale, 0)];
        la.font=SmallFont(self.scale);
        la.numberOfLines=0;
        [img addSubview:la];
        [la sizeToFit];
        la.text=[NSString stringWithFormat:@"%@%@",[data allKeys][i],[data allValues][i]];
        setY=la.bottom;
        img.height=la.height;
        
    }
    img.height=img.height+10*self.scale;
    
    return img;
    
}

-(void)BigImage:(UITapGestureRecognizer *)tap{

    if (_delegate && [_delegate respondsToSelector:@selector(BigImageTableViewCellWith:ImageIndex:)]) {
        [_delegate BigImageTableViewCellWith:_indexPath ImageIndex:tap.view.tag];
    }
}

-(void)ShareEvent:(id)sender{

    _CaoZuoButton.selected=NO;
        if (_delegate && [_delegate respondsToSelector:@selector(ShareTableViewCellWith:)]) {
            [_delegate ShareTableViewCellWith:_indexPath];
        }
}
-(void)pingLunEvent:(id)sender{
    _CaoZuoButton.selected=NO;
    if (_delegate && [_delegate respondsToSelector:@selector(CommitTableViewCellWith:)]) {
        [_delegate CommitTableViewCellWith:_indexPath];
    }

}

-(void)CaoZuoButtonEvent:(UIButton *)button{
    button.selected=!button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(CanZuoTableViewCellWith:Selected:)]) {
        [_delegate CanZuoTableViewCellWith:_indexPath Selected:_CaoZuoButton.selected];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selected"]) {
        if (_CaoZuoButton.selected) {
            [UIView animateWithDuration:.3 animations:^{
                _zanBigView.frame=CGRectMake(_CaoZuoButton.left-75*self.scale*2, _CaoZuoButton.top+0*self.scale, 75*self.scale*2, 30*self.scale);
                  _zanView.frame=CGRectMake(0, 0, 75*self.scale*2, 30*self.scale);
                _ZanButton.frame=CGRectMake(0, 0, 75*self.scale, 30*self.scale);
                _pingLunButton.frame=CGRectMake(75*self.scale, 0, 75*self.scale,30*self.scale);
                _spaceLine.frame=CGRectMake(75*self.scale, 5*self.scale, .5, 20*self.scale);
            }];
          
        }else{
            [UIView animateWithDuration:.3 animations:^{
                
                 _zanBigView.frame=CGRectMake(_CaoZuoButton.left, _CaoZuoButton.top+0*self.scale, 0, 30*self.scale);
                _zanView.frame=CGRectMake(0, 0, 0, 30*self.scale);
                _ZanButton.frame=CGRectMake(0, 0, 0*self.width, _zanView.height);
                _pingLunButton.frame=CGRectMake(75*self.scale, 0, 0*self.scale, _zanView.height);
                _spaceLine.frame=CGRectMake(75*self.scale, _zanView.height/2-5*self.scale, 0, _zanView.height-10*self.scale);
            }];
        }
    }
}
-(void)dealloc{
    [_CaoZuoButton removeObserver:self forKeyPath:@"selected" context:nil];
}
@end
