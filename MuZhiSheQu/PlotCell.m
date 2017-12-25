//
//  PlotCell.m
//  MuZhiSheQu
//  Created by lt on 2017/5/17.
//  Copyright © 2017年 apple. All rights reserved.

#import "PlotCell.h"

@implementation PlotCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"PlotCell";
    // 1.缓存中取
    PlotCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[PlotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    self.name=[[UILabel alloc] init];
    self.name.textColor=[UIColor colorWithRed:0.278 green:0.278 blue:0.278 alpha:1.00];
    [self.contentView addSubview:self.name];
    self.distance=[[UILabel alloc] init];
    self.distance.textAlignment = NSTextAlignmentRight;
    self.distance.textColor=[UIColor colorWithRed:0.565 green:0.565 blue:0.565 alpha:1.00];
    self.distance.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.distance];
    self.line=[[UILabel alloc] init];
    self.line.backgroundColor=[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.00];
    [self.contentView addSubview:self.line];
}

-(void)layoutSubviews{
    self.name.frame=CGRectMake(15, 15, 180, 20);
    self.distance.frame=CGRectMake(self.contentView.frame.size.width-120, 15, 105, 20);
    self.line.frame=CGRectMake(10, 49, self.contentView.frame.size.width, 1);
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
