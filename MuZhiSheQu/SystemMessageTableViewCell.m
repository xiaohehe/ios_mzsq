//
//  SystemMessageTableViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2018/1/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SystemMessageTableViewCell.h"

@implementation SystemMessageTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"SystemMessageTableViewCell";
    // 1.缓存中取
    SystemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[SystemMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    self.timeLb = [UILabel new];
    self.timeLb.font = DefaultFont(self.scale*0.7);
    self.timeLb.textAlignment = NSTextAlignmentCenter;
    self.timeLb.textColor=[UIColor colorWithRed:0.588 green:0.596 blue:0.608 alpha:1.00];
    [self.contentView addSubview:_timeLb];
    self.contentV = [UIView new];
    self.contentV.backgroundColor=[UIColor whiteColor];
    self.contentV.layer.borderColor = [UIColor colorWithRed:0.914 green:0.914 blue:0.918 alpha:1.00].CGColor;
    self.contentV.layer.borderWidth = 0.5;
    [self.contentView addSubview:_contentV];
    self.titleLa = [UILabel new];
    self.titleLa.font = DefaultFont(self.scale*0.8);
    self.titleLa.textColor=[UIColor colorWithRed:0.063 green:0.063 blue:0.063 alpha:1.00];
    [self.contentV addSubview:_titleLa];
    self.contentLb = [UILabel new];
    self.contentLb.font =DefaultFont(self.scale*0.7);
    self.contentLb.textColor=[UIColor colorWithRed:0.592 green:0.592 blue:0.592 alpha:1.00];
    [self.contentV addSubview:_contentLb];
}

-(void)layoutSubviews{
    self.timeLb.frame = CGRectMake(10*self.scale, 10*self.scale, self.contentView.width-20*self.scale, 15*self.scale);
    self.contentV.frame = CGRectMake(10*self.scale,self.timeLb.bottom+5*self.scale, self.contentView.width-20*self.scale, 50*self.scale);
    self.titleLa.frame = CGRectMake(10*self.scale, 10*self.scale, self.contentV.width-20*self.scale, 15*self.scale);
    self.contentLb.frame = CGRectMake(10*self.scale, self.titleLa.bottom+5*self.scale, self.contentV.width-20*self.scale, 10*self.scale);
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
