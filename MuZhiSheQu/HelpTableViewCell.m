//
//  HelpTableViewCell.m
//  AdultStore
//
//  Created by apple on 15/5/30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "HelpTableViewCell.h"
#import "DefaultPageSource.h"

@interface HelpTableViewCell()


@end
@implementation HelpTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
   
        [self newView];
    }
    return self;
}
-(void)newView{
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20*self.scale, 0, self.width-40*self.scale, self.height)];
    _titleLabel.font=DefaultFont(self.scale);
    _titleLabel.numberOfLines=0;
    [self.contentView addSubview:_titleLabel];
  
    _nameLabel=[[UILabel alloc]init];
    _nameLabel.font=DefaultFont(self.scale);
    [self.contentView addSubview:_nameLabel];
    
    _HeaderImg=[[UIImageView alloc]init];
    _HeaderImg.backgroundColor=[UIColor clearColor];
    _HeaderImg.layer.masksToBounds=YES;
    [self.contentView addSubview:_HeaderImg];
    
    _rigthImg=[[UIImageView alloc]init];
    _rigthImg.image=[UIImage imageNamed:@"nr_icon_r"];
    [self.contentView addSubview:_rigthImg];
    
    _lineView = [[LineView alloc]init];
    [self.contentView addSubview:_lineView];
    
    _topline=[[UIImageView alloc]init];
    _topline.backgroundColor=blackLineColore;
    _topline.hidden=YES;
    [self.contentView addSubview:_topline];
    
    _bottomline=[[UIImageView alloc]init];
    _bottomline.hidden=YES;
    _bottomline.backgroundColor=blackLineColore;
    [self.contentView addSubview:_bottomline];
}
-(void)layoutSubviews{
   
    if (_title) {
         _titleLabel.frame = CGRectMake(10*self.scale, self.height/2-_titleLabel.height/2, self.width-20*self.scale, _titleLabel.height);
    }else{
        _titleLabel.frame=CGRectMake(10*self.scale, 0, self.width-20*self.scale, self.height);
    }
    _rigthImg.frame=CGRectMake(self.width-20*self.scale, self.height/2-9*self.scale, 10*self.scale, 18*self.scale);
    
    if (_isRound) {
        _HeaderImg.frame=CGRectMake(_rigthImg.left-self.height+5*self.scale, 10*self.scale, 60*self.scale, 60*self.scale);
        _HeaderImg.layer.cornerRadius=_HeaderImg.height/2;
    }else{
        _HeaderImg.frame=CGRectMake(_rigthImg.left-(self.height-20*self.scale)*self.width/179-5*self.scale, 10*self.scale, (self.height-20*self.scale)*self.width/179, self.height-20*self.scale);
    }
    _nameLabel.frame=CGRectMake(self.width/2, 0, self.width/2-30*self.scale, self.height);
    
    _lineView.frame=CGRectMake(0, self.height-1, self.width, 1);
    _topline.frame=CGRectMake(0, 0, self.width, 0.5);
    _bottomline.frame=CGRectMake(0, self.height-0.5, self.width, 0.5);
}
-(void)setTitle:(NSString *)title{
    _title=title;
    _titleLabel.text=title;
 //   [_titleLabel sizeToFit];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:_titleLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    _titleLabel.size = [title boundingRectWithSize:CGSizeMake(self.width-20*self.scale, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}
@end
