//
//  CouponsTableViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CouponsTableViewCell.h"

@implementation CouponsTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"CouponsTableViewCell";
    // 1.缓存中取
    CouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CouponsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    self.statusIv = [UIImageView new];
    self.statusIv.contentMode=UIViewContentModeScaleAspectFill;
    self.statusIv.clipsToBounds=YES;
    [self.contentView addSubview:self.statusIv];
    self.priceLa = [UILabel new];
    self.priceLa.font =[UIFont systemFontOfSize:20*self.scale];
    self.priceLa.textColor=[UIColor colorWithRed:0.290 green:0.290 blue:0.290 alpha:1.00];
    self.priceLa.textAlignment=NSTextAlignmentCenter;
    [self.statusIv addSubview:_priceLa];
    self.rightView = [UIView new];
    self.rightView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:self.rightView];
    self.nameLa = [UILabel new];
    self.nameLa.textColor=[UIColor colorWithRed:0.290 green:0.290 blue:0.290 alpha:1.00];
    self.nameLa.font = [UIFont boldSystemFontOfSize:10*self.scale];
    [self.rightView addSubview:_nameLa];
    self.desLb = [UILabel new];
    self.desLb.font = SmallFont(self.scale*0.7);
    self.desLb.textColor=[UIColor colorWithRed:0.663 green:0.663 blue:0.663 alpha:1.00];
    [self.rightView addSubview:_desLb];
    self.dateLb = [UILabel new];
    self.dateLb.font = SmallFont(self.scale*0.7);
    self.dateLb.textColor=[UIColor colorWithRed:0.278 green:0.278 blue:0.278 alpha:1.00];
    [self.rightView addSubview:_dateLb];
    _selectedIv=[[UIImageView alloc]init];
    [self.rightView addSubview:_selectedIv];
}

-(void)layoutSubviews{
    self.statusIv.frame = CGRectMake(10*self.scale, 5*self.scale, 80*self.scale, 60*self.scale);
    self.priceLa.frame = CGRectMake(0, 0, self.statusIv.width, self.statusIv.height);
    self.rightView.frame = CGRectMake(self.statusIv.right, self.statusIv.top, self.contentView.width-100*self.scale, self.statusIv.height);
    self.nameLa.frame = CGRectMake(10*self.scale, 10*self.scale, self.rightView.width-40*self.scale, 15*self.scale);
    self.desLb.frame = CGRectMake(self.nameLa.left, self.nameLa.bottom+5*self.scale, self.rightView.width-40*self.scale, 10*self.scale);
    self.dateLb.frame = CGRectMake(self.nameLa.left, self.desLb.bottom+5*self.scale, self.rightView.width-40*self.scale, 10*self.scale);
    self.selectedIv.frame=CGRectMake(self.rightView.width-25*self.scale, self.rightView.height/2-7.5*self.scale, 15*self.scale, 15*self.scale);
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
