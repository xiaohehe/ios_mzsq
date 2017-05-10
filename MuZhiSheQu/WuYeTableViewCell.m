//
//  WuYeTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 17/3/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "WuYeTableViewCell.h"

@implementation WuYeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _pictureArray = [NSMutableArray new];
//        _contentLab = [[UILabel alloc]init];
//        [self addSubview:_contentLab];
        
        _timeLab = [[UILabel alloc]init];
        _timeLab.textColor = grayTextColor;
        _timeLab.font = [UIFont systemFontOfSize:12*self.scale];
        [self addSubview:_timeLab];
        
        _lin = [[UILabel alloc]init];
        _lin.backgroundColor = grayTextColor;
        [self addSubview:_lin];
        
        
    }
    return self;
}
- (void)setTitleString:(NSString *)titleString
{
    if (_titleLab)
    {
        [_titleLab removeFromSuperview];
    }
    CGRect titlRect = [self getStringWithFont:15*self.scale withString:titleString withWith:2000];
    _titleLab = [[UILabel alloc]init];
    _titleLab.frame  = CGRectMake([UIScreen mainScreen].bounds.size.width/2-titlRect.size.width/2, 10*self.scale, titlRect.size.width, titlRect.size.height);
    _titleLab.textColor = blueTextColor;
    _titleLab.text = titleString;
    _titleLab.font = [UIFont systemFontOfSize:15*self.scale];
    [self addSubview:_titleLab];
}
- (void)setContentString:(NSString *)contentString
{
    if (_contentLab)
    {
        [_contentLab removeFromSuperview];
    }
    CGRect contentRect = [self getStringWithFont:14*self.scale withString:contentString withWith:[UIScreen mainScreen].bounds.size.width - 20*self.scale];
    _contentLab = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, _titleLab.bottom+10*self.scale, [UIScreen mainScreen].bounds.size.width - 20*self.scale, contentRect.size.height)];
    _contentLab.font = [UIFont systemFontOfSize:14*self.scale];
    _contentLab.text = contentString;
//    _contentLab.backgroundColor = [UIColor redColor];
    _contentLab.numberOfLines = 0;
    [self addSubview:_contentLab];
}
- (void)setPictureNumber:(NSInteger)pictureNumber
{
    if (_pictureView)
    {
        [_pictureView removeFromSuperview];
        
    }
    _pictureView = [[UIView alloc]initWithFrame:CGRectMake(0, _contentLab.bottom+10*self.scale, [UIScreen mainScreen].bounds.size.width, 0)];
//    _pictureView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_pictureView];
    for (int i = 0; i < pictureNumber; i++)
    {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale + (i%3*(([UIScreen mainScreen].bounds.size.width-40*self.scale)/3 +10*self.scale)), i/3*(([UIScreen mainScreen].bounds.size.width-40*self.scale)/3*0.75+10*self.scale), ([UIScreen mainScreen].bounds.size.width-40*self.scale)/3, ([UIScreen mainScreen].bounds.size.width-40*self.scale)/3*0.75)];
        NSString *url=@"";
        NSString *cut = self.pictureArray[i];
        NSString *imagename = [cut lastPathComponent];
        NSString *path = [cut stringByDeletingLastPathComponent];
        NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb320."]];
//        if (cut.length>0) {
//            url = [cut substringToIndex:[cut length] - 4];
//            
//        }
//        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb320.jpg",url]] placeholderImage:[UIImage imageNamed:@"not_1"]];
        [imageView setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"not_1"]];
        UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
        imageView.tag = i+1000;
        [imageView addGestureRecognizer:tap1];
        imageView.userInteractionEnabled = YES;
        _pictureView.height = imageView.bottom + 10*self.scale;
        [_pictureView addSubview:imageView];
    }
}
- (void)layoutSubviews
{
//    [_titleLab sizeToFit];

    [_timeLab sizeToFit];
    _timeLab.frame = CGRectMake(10*self.scale, _pictureView.bottom, _timeLab.width, _timeLab.height);
    
    _lin.frame = CGRectMake(5*self.scale, _timeLab.bottom+9.7*self.scale, [UIScreen mainScreen].bounds.size.width-10*self.scale, 0.3*self.scale);
}
-(void)BigImage:(UITapGestureRecognizer *)tap{
    
    
//    NSLog(@"%d",tap.view.tag);
    
    if (_delegate && [_delegate respondsToSelector:@selector(BigImageTableViewCellWith:ImageIndex:)]) {
        [_delegate BigImageTableViewCellWith:_indexPath ImageIndex:tap.view.tag-999];
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
