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
    //self.contentView.backgroundColor=[UIColor greenColor];
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.font=DefaultFont(self.scale*0.8);
    _titleLabel.textColor=[UIColor colorWithRed:0.306 green:0.306 blue:0.306 alpha:1.00];
    //_titleLabel.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:_titleLabel];
  
    _nameLabel=[[UILabel alloc]init];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.font=DefaultFont(self.scale*0.8);
    _nameLabel.textColor=[UIColor colorWithRed:0.635 green:0.635 blue:0.635 alpha:1.00];
    //_nameLabel.backgroundColor=[UIColor yellowColor];
    [self.contentView addSubview:_nameLabel];
    
    _HeaderImg=[[UIImageView alloc]init];
    _HeaderImg.backgroundColor=[UIColor clearColor];
    _HeaderImg.layer.masksToBounds=YES;
    [self.contentView addSubview:_HeaderImg];
    
    _rigthImg=[[UIImageView alloc]init];
    _rigthImg.image=[UIImage imageNamed:@"arrows"];
    //_rigthImg.backgroundColor=[UIColor blueColor];
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
         _titleLabel.frame = CGRectMake(10*self.scale, 7.5*self.scale, self.width/4, 20*self.scale);
    }else{
        _titleLabel.frame=CGRectMake(10*self.scale, 0, self.width-20*self.scale, 20*self.scale);
    }
    _rigthImg.frame=CGRectMake(self.width-20*self.scale, 12.75*self.scale, 5*self.scale, 8.5*self.scale);
    if (_isRound) {
        _HeaderImg.frame=CGRectMake(_rigthImg.left-40*self.scale, 2*self.scale, 30*self.scale, 30*self.scale);
        _HeaderImg.layer.cornerRadius=_HeaderImg.height/2;
    }else{
        _HeaderImg.frame=CGRectMake(_rigthImg.left-(self.height-20*self.scale)*self.width/179-5*self.scale, 2*self.scale, (self.height-20*self.scale)*self.width/179, self.height-20*self.scale);
    }
    _nameLabel.frame=CGRectMake(self.width/4, 7.5*self.scale, self.width/4*3-35*self.scale, 20*self.scale);
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
