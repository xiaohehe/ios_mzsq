//
//  CellView.m
//  BaoJiaHuHang
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CellView.h"
#import "DefaultPageSource.h"
#import "LineView.h"
@interface CellView()
@property(nonatomic,assign) float scale;
@property(nonatomic,strong)LineView *blineImg;
@end
@implementation CellView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _scale=1.0;
        if ([[UIScreen mainScreen] bounds].size.height > 480)
        {
            _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
        }
        self.backgroundColor=[UIColor whiteColor];
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, self.height/2-10*self.scale, 85*self.scale, 20*self.scale)];
        _titleLabel.font=DefaultFont(self.scale);
       // _titleLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:_titleLabel];
        _contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.right, _titleLabel.top, self.width - _titleLabel.right-20*self.scale, _titleLabel.height)];
        _contentLabel.font=DefaultFont(self.scale);
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
        
        _RightImg=[[UIImageView alloc]init];
        _RightImg.image=[UIImage imageNamed:@"dian_xq_right"];
        _RightImg.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:_RightImg];
        
        _blineImg=[[LineView alloc]initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        _blineImg.hidden=YES;
        [self addSubview:_blineImg];
        
        _topline=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        _topline.hidden=YES;
        _topline.backgroundColor=blackLineColore;
        [self addSubview:_topline];
        
        _bottomline=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        //_bottomline.hidden=YES;
        _bottomline.backgroundColor=blackLineColore;
        [self addSubview:_bottomline];
        
    }
    return self;
}
-(void)setTitle:(NSString *)title{
    _titleLabel.text =title;
}

-(void)setContent:(NSString *)content{
    _contentLabel.text = content;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:_contentLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize cellsize = [content boundingRectWithSize:CGSizeMake(_contentLabel.width, 10000*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    if (cellsize.height<=20) {
        cellsize.height =20;
    }
    _contentLabel.frame=CGRectMake(_titleLabel.right, 10*self.scale, _contentLabel.width, cellsize.height);
    self.size=CGSizeMake(self.width, cellsize.height+22*self.scale);
}
-(void)layoutSubviews{
    _blineImg.frame=CGRectMake(0, self.height-1, self.width, 1);
    
    _topline.frame=CGRectMake(0, 0, self.width, 0.5);
    _bottomline.frame=CGRectMake(0, self.height-0.5, self.width, 0.5);
}
-(void)setHiddenLine:(BOOL)hidden{
    
    _blineImg.hidden = hidden;
}
-(void)ShowRight:(BOOL)show{
    //_contentLabel.size=CGSizeMake(_contentLabel.width-20*self.scale, _contentLabel.height);
    _RightImg.frame=CGRectMake(self.width-18*self.scale, self.height/2-15*self.scale, 10*self.scale, 30*self.scale);
}
@end
