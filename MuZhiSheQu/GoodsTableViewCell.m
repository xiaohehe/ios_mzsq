//
//  GoodsTableViewCell.m
//  MuZhiSheQu
//
//  Created by lt on 2017/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "GoodsTableViewCell.h"
#import "SuperViewController.h"

@interface GoodsTableViewCell()
@property(nonatomic,assign) float scale;
@end
@implementation GoodsTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"GoodsTableViewCell";
    // 1.缓存中取
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[GoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _scale=1.0;
        if ([[UIScreen mainScreen] bounds].size.height > 480){
            _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
        }
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
    self.activityImg= [UIImageView new];
    self.activityImg.contentMode=UIViewContentModeScaleAspectFill;
    self.activityImg.clipsToBounds=YES;
    [self.contentView addSubview:self.activityImg];
    self.titleLa = [UILabel new];
    self.titleLa.font = DefaultFont(self.scale);
    //self.titleLa.numberOfLines=0;
    [self.contentView addSubview:_titleLa];
    self.desLb = [UILabel new];
    self.desLb.font = SmallFont(self.scale*0.9);
    self.desLb.textColor = [UIColor colorWithRed:0.451 green:0.451 blue:0.451 alpha:1.00];    //self.desLb.numberOfLines=0;
    [self.contentView addSubview:_desLb];
    self.priceLa = [UILabel new];
    self.priceLa.font = SmallFont(self.scale*0.7);
    self.priceLa.textColor = [UIColor colorWithRed:1.000 green:0.373 blue:0.000 alpha:1.00];
    [self.contentView addSubview:_priceLa];
    self.numLb = [UILabel new];
    //    self.numberLa.layer.borderWidth=.5;
    self.numLb.textAlignment = NSTextAlignmentCenter;
    self.numLb.font = SmallFont(self.scale);
    [self.contentView addSubview:_numLb];
    self.addBt = [UIButton new];
    self.addBt.titleLabel.font = SmallFont(self.scale);
    [self.addBt setImage:[UIImage imageNamed:@"na7"]forState:UIControlStateNormal];
    [self.addBt setContentMode:UIViewContentModeCenter];
   // self.addBt.backgroundColor=[UIColor redColor];
    //self.addBt.tag = 1000;
    [self.contentView addSubview:_addBt];
    self.subBtn = [UIButton new];
    //self.subBtn.backgroundColor=[UIColor redColor];
    //self.subBtn.tag = 1001;
    [self.subBtn setImage:[UIImage imageNamed:@"na8"] forState:UIControlStateNormal];
    [self.subBtn setContentMode:UIViewContentModeCenter];
    self.subBtn.titleLabel.font = SmallFont(self.scale);
    [self.contentView addSubview:_subBtn];
    _lineView=[[UIImageView alloc]init];
    [_lineView setImage:[UIImage imageNamed:@"imaginary_line"]];
    [self.contentView addSubview:_lineView];
}

-(void)layoutSubviews{
    self.headImg.frame = CGRectMake(10*self.scale, 10*self.scale, 60*self.scale, 60*self.scale);
    float r = self.headImg.right;
    float t = self.headImg.top;
    self.activityImg.frame = CGRectMake(10*self.scale, 10*self.scale, 20*self.scale, 20*self.scale);
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:self.activityImg.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(5,0)];
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
    maskLayer.frame=self.activityImg.bounds;
    maskLayer.path=maskPath.CGPath;
    self.activityImg.layer.mask=maskLayer;
    self.titleLa.frame = CGRectMake(r+10*self.scale, t, self.contentView.width-90*self.scale, 15*self.scale);
    [self.titleLa sizeToFit];
    float b = self.titleLa.bottom;
    float l = self.titleLa.left;
    self.desLb.frame = CGRectMake(l, b+5*self.scale, self.contentView.width-95*self.scale-75*self.scale, 15*self.scale);//70*self.scale, 15*self.scale);
    b = self.desLb.bottom;
    self.priceLa.frame = CGRectMake(l, b+5*self.scale, 100*self.scale, 15*self.scale);
    r = self.numLb.right;
    [_priceLa sizeToFit];
    _priceLa.height=15*self.scale;
    self.subBtn.frame = CGRectMake(self.desLb.right+5*self.scale-6*self.scale, self.desLb.top-9*self.scale, 28*self.scale, 40*self.scale);
    self.subBtn.contentEdgeInsets = UIEdgeInsetsMake(9*self.scale,3*self.scale, 9*self.scale, 3*self.scale);
    r = self.subBtn.right;
    t = self.subBtn.top;
    self.numLb.frame = CGRectMake(r+4*self.scale-3*self.scale, t+5.5*self.scale+6*self.scale, 25*self.scale, 17*self.scale);
    r = self.numLb.right;
    self.addBt.frame = CGRectMake(r+4*self.scale-6*self.scale, t-0*self.scale, 28*self.scale, 40*self.scale);
    self.addBt.contentEdgeInsets = UIEdgeInsetsMake(9*self.scale,3*self.scale, 9*self.scale, 3*self.scale);
    _lineView.frame=CGRectMake(10*self.scale, self.height-.5, self.width-20*self.scale, .5);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
