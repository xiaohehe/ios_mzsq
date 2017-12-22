//
//  HistoryLogTableViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HistoryLogTableViewCell.h"

@implementation HistoryLogTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"HistoryLogTableViewCell";
    // 1.缓存中取
    HistoryLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[HistoryLogTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    self.nameLb.textColor=[UIColor colorWithRed:0.216 green:0.216 blue:0.216 alpha:1.00];
    [self.contentView addSubview:_nameLb];
    
    self.timeLb = [UILabel new];
    self.timeLb.font = SmallFont(self.scale*0.9);
    self.timeLb.textAlignment=NSTextAlignmentRight;
    self.timeLb.textColor = [UIColor colorWithRed:0.341 green:0.341 blue:0.341 alpha:1.00];
    [self.contentView addSubview:_timeLb];
    _lineView=[[UIImageView alloc]init];
    _lineView.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [self.contentView addSubview:_lineView];
}

-(void)layoutSubviews{
    self.nameLb.frame = CGRectMake(10*self.scale, 10*self.scale, 80*self.scale, 20*self.scale);
    self.timeLb.frame = CGRectMake(90*self.scale, 15*self.scale, self.contentView.width-100*self.scale, 15*self.scale);
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
