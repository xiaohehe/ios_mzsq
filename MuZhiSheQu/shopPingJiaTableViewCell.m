//
//  shopPingJiaTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "shopPingJiaTableViewCell.h"

@implementation shopPingJiaTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    self.headImg = [UIImageView new];
   // self.headImg.layer.cornerRadius=30.0f*self.scale;
    self.headImg.layer.masksToBounds=YES;
    [self.contentView addSubview:_headImg];
    
    self.name = [UILabel new];
    self.name.font = DefaultFont(self.scale);
    [self.contentView addSubview:_name];
    
    self.context =[UILabel new];
    self.context.font = SmallFont(self.scale);
    self.context.numberOfLines=0;
    self.context.textColor = grayTextColor;
    [self.contentView addSubview:_context];
    
    
    self.imgVi=[UIView new];
    _imgVi.backgroundColor=blackLineColore;
    [self.contentView addSubview:_imgVi];
    
    
    
    self.image1 = [UIImageView new];
    [self.contentView addSubview:_image1];
    
    self.image2 = [UIImageView new];
    [self.contentView addSubview:_image2];
    
    self.image3 = [UIImageView new];
    [self.contentView addSubview:_image3];
    
    self.image4 = [UIImageView new];
    [self.contentView addSubview:_image4];
    
    self.image5 = [UIImageView new];
    [self.contentView addSubview:_image5];
    
    self.image6 = [UIImageView new];
    [self.contentView addSubview:_image6];
    
    self.time = [UILabel new];
    self.time.font = SmallFont(self.scale);
    self.time.textColor = grayTextColor;
    [self.contentView addSubview:_time];
    
    self.line =[UIView new];
    [self.contentView addSubview:_line];
    
    _scroll = [UIScrollView new];
    _scroll.hidden=YES;
    [self.contentView addSubview:_scroll];
    
}
-(void)layoutSubviews{
  
    
    self.headImg.frame = CGRectMake(10*self.scale, 10*self.scale, 40*self.scale, 40*self.scale);
    self.headImg.layer.cornerRadius=self.headImg.width/2;
    
    self.name.frame = CGRectMake(_headImg.right+10*self.scale, _headImg.top, 200*self.scale, 20*self.scale);
    
    self.context.frame = CGRectMake(self.name.left, self.name.bottom+5*self.scale, self.contentView.width-self.headImg.right-10*self.scale, 0);
    [self.context sizeToFit];
   
    float b=_context.bottom;
 
    
    
    if (_imgVi) {
        [_imgVi removeFromSuperview];
        
        _imgVi = [UIView new];
        //_imgVi.backgroundColor=blackLineColore;
        [self.contentView addSubview:_imgVi];
    }
    
    if (self.imgCount>0) {
        
        _imgVi.frame = CGRectMake(_context.left, _context.bottom+5*self.scale, self.contentView.width-_context.left-10*self.scale, 100);

        
        float W=(_imgVi.width-40*self.scale)/3;
        for (int i=0; i<self.imgCount; i++) {
            
            
            
            float x = (W+10*self.scale)*(i%3);
            float y = (W-10*self.scale)*(i/3);
            
            
           NSString *im1 = _data[_indexPath.row][[NSString stringWithFormat:@"img%d",i+1]];
            
            UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(x+0*self.scale, y+10*self.scale, W, W*0.75)];
            [im setImageWithURL:[NSURL URLWithString:im1] placeholderImage:[UIImage imageNamed:@"center_img"]];
            im.tag=i+1;
            im.userInteractionEnabled=YES;
            [_imgVi addSubview:im];
            im.contentMode=UIViewContentModeScaleAspectFill;
            im.clipsToBounds=YES;
            _imgVi.height=im.bottom+10*self.scale;
            
            UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
            
            [im addGestureRecognizer:tap1];
            
            b=_imgVi.bottom;
            

      }
    }
    
    
       self.time.frame = CGRectMake(self.context.left, b+5*self.scale, self.contentView.width-_context.left, 12);
    
    
    
  

    self.line.frame = CGRectMake(0, self.contentView.bottom-1, self.contentView.width, .5);
    
    
}
-(void)BigImage:(UIGestureRecognizer *)G{
    
    if (_delegect && [_delegect respondsToSelector:@selector(imageChange:imgCount:number:imgData:)]) {
        [_delegect imageChange:_indexPath imgCount:self.imgCount number:G.view.tag-1 imgData:self.imgData];
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
