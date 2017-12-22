//
//  OrderTableViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/11/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "OrderTableViewCell.h"


@implementation OrderTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"OrderTableViewCell";
    // 1.缓存中取
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    self.backgroundColor=[UIColor whiteColor];
    self.titleLa = [UILabel new];
    self.titleLa.font = DefaultFont(self.scale*0.8);
    self.titleLa.textAlignment = NSTextAlignmentCenter;
    self.titleLa.textColor=[UIColor colorWithRed:0.455 green:0.455 blue:0.455 alpha:1.00];
    [self.contentView addSubview:_titleLa];
    self.numLb = [UILabel new];
    self.numLb.textAlignment = NSTextAlignmentRight;
    self.numLb.font = SmallFont(self.scale);
    self.numLb.textColor=[UIColor colorWithRed:0.455 green:0.455 blue:0.455 alpha:1.00];
    [self.contentView addSubview:_numLb];
}

-(void)layoutSubviews{
    self.titleLa.frame = CGRectMake(68*self.scale, 7.5*self.scale, self.contentView.width-68*self.scale-60*self.scale, 15*self.scale);
    [self.titleLa sizeToFit];
    self.numLb.frame = CGRectMake(self.contentView.width-50*self.scale, self.titleLa.top, 40*self.scale, 15*self.scale);
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
