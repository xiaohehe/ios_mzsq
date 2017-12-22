//
//  MerchantTableViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MerchantTableViewCell.h"

@implementation MerchantTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"MerchantTableViewCell";
    // 1.缓存中取
    MerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[MerchantTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    self.nameLa.textColor=[UIColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1.00];
    [self.contentView addSubview:_nameLa];
    self.summaryLb = [UILabel new];
    self.summaryLb.font = SmallFont(self.scale*0.8);
    self.summaryLb.textColor = [UIColor colorWithRed:1.000 green:0.584 blue:0.192 alpha:1.00];
    [self.contentView addSubview:_summaryLb];
    self.addressLa = [UILabel new];
    self.addressLa.font = SmallFont(self.scale*0.8);
    self.addressLa.textColor =[UIColor colorWithRed:0.431 green:0.431 blue:0.431 alpha:1.00];
    [self.contentView addSubview:_addressLa];
    self.noticeLb = [UILabel new];
    self.noticeLb.font = SmallFont(self.scale*0.8);
    self.noticeLb.textColor=[UIColor colorWithRed:0.212 green:0.675 blue:1.000 alpha:1.00];
    [self.contentView addSubview:_noticeLb];
    _lineView=[[UIView alloc]init];
    _lineView.backgroundColor=[UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1.00];
    [self.contentView addSubview:_lineView];
}

-(void)layoutSubviews{
    self.headImg.frame = CGRectMake(10*self.scale, 10*self.scale, 60*self.scale, 60*self.scale);
    float r = self.headImg.right;
    float t = self.headImg.top;
    self.nameLa.frame = CGRectMake(r+10*self.scale, t, self.contentView.width-90*self.scale, 15*self.scale);
    float b = self.nameLa.bottom;
    float l = self.nameLa.left;
    self.summaryLb.frame = CGRectMake(l, b+5*self.scale, self.contentView.width-90*self.scale, 15*self.scale);
    b = self.summaryLb.bottom;
    self.addressLa.frame = CGRectMake(l, b+5*self.scale, self.contentView.width-90*self.scale, 15*self.scale);
    b = self.addressLa.bottom;
    self.noticeLb.frame = CGRectMake(l, b+15*self.scale, self.contentView.width-90*self.scale, 15
                                     *self.scale);
    b = self.noticeLb.bottom;
    _lineView.frame = CGRectMake(0, b+5*self.scale-.5, self.contentView.width, .5);
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
