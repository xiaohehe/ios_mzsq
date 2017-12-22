//
//  PraiseTableViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PraiseTableViewCell.h"

@implementation PraiseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"PraiseTableViewCell";
    // 1.缓存中取
    PraiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[PraiseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}

-(void)newView{
    self.backgroundColor=[UIColor clearColor];
    self.headImg = [UIImageView new];
    self.headImg.contentMode=UIViewContentModeScaleAspectFill;
    self.headImg.clipsToBounds=YES;
    self.headImg.layer.cornerRadius=5;
    self.headImg.layer.masksToBounds=YES;
    [self.contentView addSubview:self.headImg];
    
    self.nameLa = [UILabel new];
    self.nameLa.font = DefaultFont(self.scale);
    //self.titleLa.numberOfLines=0;
    [self.contentView addSubview:_nameLa];
    
    self.desLb = [UILabel new];
    self.desLb.font = SmallFont(self.scale*0.9);
    self.desLb.textColor = [UIColor colorWithRed:0.451 green:0.451 blue:0.451 alpha:1.00];
    self.desLb.text=@"赞了该帖子";
    [self.contentView addSubview:_desLb];
    
    self.dateLa = [UILabel new];
    self.dateLa.font = SmallFont(self.scale*0.8);
    self.dateLa.textAlignment = NSTextAlignmentRight;
    self.dateLa.textColor =[UIColor colorWithRed:0.380 green:0.380 blue:0.380 alpha:1.00];
    [self.contentView addSubview:_dateLa];
}

-(void)layoutSubviews{
    self.headImg.frame = CGRectMake(10*self.scale, 10*self.scale, 40*self.scale, 40*self.scale);
    self.nameLa.frame = CGRectMake(self.headImg.right+10*self.scale, self.headImg.top, self.contentView.width-100*self.scale, 20*self.scale);
    [self.nameLa sizeToFit];
    self.desLb.frame = CGRectMake(self.nameLa.left, self.nameLa.bottom+5*self.scale, self.contentView.width-100*self.scale, 15*self.scale);
    self.dateLa.frame = CGRectMake(self.contentView.width-100*self.scale, self.nameLa.top+10*self.scale, 90*self.scale, 15*self.scale);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
@end
