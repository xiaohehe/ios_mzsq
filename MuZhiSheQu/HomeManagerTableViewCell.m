//
//  HomeManagerTableViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HomeManagerTableViewCell.h"

@implementation HomeManagerTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"HomeManagerTableViewCell";
    // 1.缓存中取
    HomeManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[HomeManagerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    self.nameLb = [UILabel new];
    self.nameLb.font = SmallFont(self.scale);
    self.nameLb.textColor=[UIColor colorWithRed:0.565 green:0.565 blue:0.565 alpha:1.00];
    [self.contentView addSubview:_nameLb];

    self.phoneLb = [UILabel new];
    self.phoneLb.font = SmallFont(self.scale*0.9);
    self.phoneLb.textColor = [UIColor colorWithRed:0.247 green:0.247 blue:0.247 alpha:1.00];
    [self.contentView addSubview:_phoneLb];
    _lineView=[[UIImageView alloc]init];
    _lineView.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [self.contentView addSubview:_lineView];
}

-(void)layoutSubviews{
    self.nameLb.frame = CGRectMake(10*self.scale, 10*self.scale, self.contentView.width-20*self.scale, 20*self.scale);
    self.phoneLb.frame = CGRectMake(self.nameLb.left, self.nameLb.bottom+5*self.scale, self.contentView.width, 15*self.scale);
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
