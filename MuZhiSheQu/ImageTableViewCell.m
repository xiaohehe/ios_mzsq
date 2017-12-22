//
//  ImageTableViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ImageTableViewCell.h"

@implementation ImageTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"ImageTableViewCell";
    // 1.缓存中取
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[ImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    self.advertisingImg = [UIImageView new];
    self.advertisingImg.contentMode=UIViewContentModeScaleAspectFill;
    self.advertisingImg.clipsToBounds=YES;
    self.advertisingImg.layer.cornerRadius=5;
    self.advertisingImg.layer.masksToBounds=YES;
    [self.contentView addSubview:self.advertisingImg];
}


-(void)layoutSubviews{
    self.advertisingImg.frame = self.contentView.frame;
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
