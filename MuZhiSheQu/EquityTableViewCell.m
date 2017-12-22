//
//  EquityTableViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "EquityTableViewCell.h"

@implementation EquityTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"EquityTableViewCell";
    // 1.缓存中取
    EquityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[EquityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    //self.backgroundColor=[UIColor clearColor];
    self.iconIv = [UIImageView new];
    self.iconIv.contentMode=UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.iconIv];
    self.titleLb = [UILabel new];
    self.titleLb.font = DefaultFont(self.scale);
    self.titleLb.textColor=[UIColor colorWithRed:0.180 green:0.196 blue:0.271 alpha:1.00];
    [self.contentView addSubview:_titleLb];
    self.desLb = [UILabel new];
    self.desLb.font = SmallFont(self.scale*0.9);
    self.desLb.textColor = [UIColor colorWithRed:0.663 green:0.663 blue:0.663 alpha:1.00];    //self.desLb.numberOfLines=0;
    [self.contentView addSubview:_desLb];
    _lineView=[[UIImageView alloc]init];
    //[_lineView setImage:[UIImage imageNamed:@"imaginary_line"]];
    _lineView.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [self.contentView addSubview:_lineView];
}

-(void)layoutSubviews{
    self.iconIv.frame = CGRectMake(10*self.scale, 10*self.scale, 15*self.scale, 15*self.scale);
    float r = self.iconIv.right;
    float t = self.iconIv.top;
    self.titleLb.frame = CGRectMake(r+10*self.scale, t, self.contentView.width-45*self.scale, 15*self.scale);
    float b = self.titleLb.bottom;
    float l = self.titleLb.left;
    self.desLb.frame = CGRectMake(l, b+5*self.scale, self.contentView.width-45*self.scale, 15*self.scale);
    _lineView.frame=CGRectMake(10*self.scale, self.height-.5, self.width-20*self.scale, .5);
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
