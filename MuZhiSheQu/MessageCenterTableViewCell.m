//
//  MessageCenterTableViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MessageCenterTableViewCell.h"

@implementation MessageCenterTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"MessageCenterTableViewCell";
    // 1.缓存中取
    MessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[MessageCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
   
    self.titleLa = [UILabel new];
    self.titleLa.font = DefaultFont(self.scale);
    self.titleLa.textColor=[UIColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1.00];
    [self.contentView addSubview:_titleLa];
    
    self.desLb = [UILabel new];
    self.desLb.font = SmallFont(self.scale*0.8);
    self.desLb.textColor=[UIColor colorWithRed:0.690 green:0.690 blue:0.690 alpha:1.00];
    [self.contentView addSubview:_desLb];

    self.numLb = [UILabel new];
    self.numLb.textAlignment = NSTextAlignmentCenter;
    self.numLb.font = SmallFont(self.scale);
    self.numLb.textColor=[UIColor whiteColor];
    self.numLb.clipsToBounds=YES;
    self.numLb.layer.cornerRadius=5*self.scale;
    self.numLb.backgroundColor=[UIColor colorWithRed:0.984 green:0.357 blue:0.000 alpha:1.00];
    [self.contentView addSubview:_numLb];
    
    self.rightImg= [UIImageView new];
    self.rightImg.contentMode=UIViewContentModeScaleAspectFill;
    [_rightImg setImage:[UIImage imageNamed:@"msg_right"]];
    [self.contentView addSubview:self.rightImg];
    
    _lineView=[[UIImageView alloc]init];
    [_lineView setImage:[UIImage imageNamed:@"imaginary_line"]];
    [self.contentView addSubview:_lineView];
}

-(void)layoutSubviews{
    self.headImg.frame = CGRectMake(10*self.scale, 10*self.scale, 30*self.scale, 30*self.scale);
    float r = self.headImg.right;
    float t = self.headImg.top;
    self.titleLa.frame = CGRectMake(r+10*self.scale, t, self.contentView.width-65*self.scale, 15*self.scale);
    float b = self.titleLa.bottom;
    float l = self.titleLa.left;
    self.desLb.frame = CGRectMake(l, b+5*self.scale, self.contentView.width-65*self.scale, 10*self.scale);
    
    self.numLb.frame = CGRectMake(self.contentView.width-55*self.scale, b-5*self.scale, 20*self.scale, 10*self.scale);
    r = self.numLb.right;
    t = self.numLb.top;
    self.rightImg.frame = CGRectMake(r+14*self.scale, t, 6*self.scale, 10*self.scale);
    _lineView.frame=CGRectMake(10*self.scale, self.height-.5, self.width-20*self.scale, .5);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
