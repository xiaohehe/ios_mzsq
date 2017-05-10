//
//  LiuYanTableViewCell.m
//  BaoJiaHuHang
//
//  Created by apple on 15-1-19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LiuYanTableViewCell.h"
#import "UIViewAdditions.h"
#import "LineView.h"
@interface LiuYanTableViewCell()
@property(nonatomic,strong)LineView *blineImg;
@property(nonatomic,strong)UIImageView *rightImg;

@end
@implementation LiuYanTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, self.width-30*self.scale, self.height/2-2*self.scale)];
        _titleLabel.backgroundColor=[UIColor clearColor];
        _titleLabel.font=DefaultFont(self.scale);
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel=[[UILabel alloc]init];
        _contentLabel.backgroundColor=[UIColor clearColor];
        _contentLabel.font=SmallFont(self.scale);
        _contentLabel.textColor=grayTextColor;
        [self.contentView addSubview:_contentLabel];
        
        _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom, _titleLabel.width, _titleLabel.height-1)];
        _dateLabel.backgroundColor=[UIColor clearColor];
        _dateLabel.font=SmallFont(self.scale);
        _dateLabel.textColor=grayTextColor;
        [self.contentView addSubview:_dateLabel];
        
        _bianji = [UIButton new];
        [_bianji setTitle:@"编辑" forState:UIControlStateNormal];
        _bianji.titleLabel.font=SmallFont(self.scale);
        [_bianji setTitleColor:blueTextColor forState:UIControlStateNormal];
        //[self.contentView addSubview:_bianji];
        
        _rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.width-20*self.scale, self.height/2-9*self.scale, 10*self.scale, 18*self.scale)];
        _rightImg.image=[UIImage imageNamed:@"nr_icon_r"];
        //_rightImg.hidden=YES;
        [self.contentView addSubview:_rightImg];
        
        _StateImage=[[UIImageView alloc]init];
        _StateImage.image=[UIImage imageNamed:@"new_img"];
        _StateImage.hidden=YES;
        [self.contentView addSubview:_StateImage];
        
        
        _blineImg=[[LineView alloc]initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        [self.contentView addSubview:_blineImg];
}
    
    return self;
}
-(void)layoutSubviews
{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:_titleLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [_titleLabel.text boundingRectWithSize:CGSizeMake(self.width-90*self.scale, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    _titleLabel.frame=CGRectMake(10*self.scale, 9*self.scale,size.width, 20*self.scale);

    _dateLabel.frame=CGRectMake(self.width-80*self.scale, _titleLabel.top, 70*self.scale, 20*self.scale);
    _bianji.frame=CGRectMake(self.contentView.width-50*self.scale, self.contentView.bottom-30*self.scale, 40*self.scale, 20*self.scale);
    _StateImage.frame =CGRectMake(_titleLabel.right+10*self.scale, _titleLabel.top, 30*self.scale, 12*self.scale);
    
    _contentLabel.frame=CGRectMake(_titleLabel.left, _titleLabel.bottom+5*self.scale, self.width-90*self.scale, 13*self.scale);
      _rightImg.frame=CGRectMake(self.width-20*self.scale, self.height/2-9*self.scale, 10*self.scale, 18*self.scale);
    _blineImg.frame=CGRectMake(0, self.height-1, self.width, 1);

}
-(void)setIndexPath:(NSIndexPath *)indexPath{
//    _indexPath = indexPath;
//    if (indexPath.row == 0) {
//        _blineImg.hidden = YES;
//        _wlineImg.hidden = YES;
//    }else
//    {
//        _blineImg.hidden = NO;
//        _wlineImg.hidden = NO;
//    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
