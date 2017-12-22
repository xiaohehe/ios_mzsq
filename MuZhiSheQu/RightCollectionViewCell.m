//
//  rightCollectionViewCell.m
//  CoCoaLumberjackTest
//
//  Created by wujunyang on 15/10/10.
//  Copyright © 2015年 wujunyang. All rights reserved.
//

#import "RightCollectionViewCell.h"
#import "DefaultPageSource.h"
//#define SmallFont(__scale) [UIFont systemFontOfSize:12*__scale];

@interface RightCollectionViewCell()
@property(nonatomic,assign) float scale;
@end

@implementation RightCollectionViewCell

//这边很关键 CollectionViewCell重用
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scale=1.0;
        if ([[UIScreen mainScreen] bounds].size.height > 480){
            _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
        }
        float w = ([UIScreen mainScreen].bounds.size.width-80-10*3)/2;
        self.backgroundColor=[UIColor clearColor];
        if (self.coverIv==nil) {
            self.coverIv=[[UIImageView alloc] initWithFrame:CGRectMake(15*self.scale, 5*self.scale, w-30*self.scale, w-30*self.scale)];
            self.coverIv.contentMode=UIViewContentModeScaleAspectFill;
            self.coverIv.clipsToBounds=YES;
            self.coverIv.layer.cornerRadius=5;
            self.coverIv.userInteractionEnabled=YES;
            [self.contentView addSubview:self.coverIv];
        }
//        if (self.coverView==nil) {
//            self.coverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.coverIv.frame.size.width,self.coverIv.frame.size.height)];
//            self.coverView.backgroundColor=[UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.4];
//            self.coverView.clipsToBounds=YES;
//            self.coverView.layer.cornerRadius=5;
//            [self.coverIv addSubview:self.coverView];
//            UILabel *addCart = [[UILabel alloc] initWithFrame:CGRectMake(0, self.coverView.frame.size.height/2-10*self.scale, self.coverIv.frame.size.width, 15*self.scale)];
//            addCart.textAlignment=NSTextAlignmentCenter;
//            addCart.textColor = [UIColor whiteColor];
//            addCart.font=SmallFont(self.scale*0.8);
//            // 1.创建一个富文本
//            NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:@"已加入购物车"];
//            // 2.添加表情图片
//            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//            // 表情图片
//            attch.image = [UIImage imageNamed:@"shopping_cart.png"];
//            // 设置图片大小
//            attch.bounds = CGRectMake(0, -self.scale*4, 15*self.scale, 15*self.scale);
//            // 创建带有图片的富文本
//            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
//            [attri insertAttributedString:string atIndex:0];// 插入某个位置
//            // 用label的attributedText属性来使用富文本
//            addCart.attributedText = attri;
//            [self.coverView addSubview:addCart];
//            UILabel* cancel=[[UILabel alloc] initWithFrame:CGRectMake(0,self.coverIv.frame.size.height-25*self.scale,self.coverIv.frame.size.width,10*self.scale)];
//            cancel.textAlignment=NSTextAlignmentCenter;
//            cancel.textColor = [UIColor colorWithRed:0.844 green:0.792 blue:0.791 alpha:1.00];
//            cancel.font=SmallFont(self.scale*0.7);
//            cancel.text=@"点击取消";
//            [self.coverView addSubview:cancel];
//        }
        if (self.goodsNameLb==nil) {
            self.goodsNameLb=[[UILabel alloc]initWithFrame:CGRectMake(15*self.scale, self.coverIv.bottom+5*self.scale, w-30*self.scale,15*self.scale)];
            self.goodsNameLb.numberOfLines=2;
            self.goodsNameLb.textColor=[UIColor blackColor];
            //la.textAlignment = NSTextAlignmentCenter;
            //self.goodsNameLb.alpha=.9;
            self.goodsNameLb.font=SmallFont(self.scale*0.8);
            [self.contentView addSubview:self.goodsNameLb];
        }
        if (self.goodsDescLb==nil) {
            self.goodsDescLb=[[UILabel alloc]initWithFrame:CGRectMake(15*self.scale, self.goodsNameLb.bottom, w-30*self.scale, 15*self.scale)];
            self.goodsDescLb.textColor = grayTextColor;
            self.goodsDescLb.font = Small10Font(self.scale*0.75);
            [self.contentView addSubview:self.goodsDescLb];
        }
        if (self.goodsPriceLb==nil) {
            self.goodsPriceLb=[[UILabel alloc]init];
            self.goodsPriceLb.textColor = [UIColor colorWithRed:1.000 green:0.149 blue:0.149 alpha:1.00];
            self.goodsPriceLb.font = Small10Font(self.scale*0.6);
            [self.contentView addSubview:self.goodsPriceLb];
        }
        if (self.goodsOldPriceLb==nil) {
            self.goodsOldPriceLb=[[UILabel alloc]init];
            self.goodsOldPriceLb.textColor = grayTextColor;
            self.goodsOldPriceLb.font = Small10Font(self.scale*0.75);
            [self.contentView addSubview:self.goodsOldPriceLb];
        }
    }
    return self;
}

+(CGSize)ccellSize{
    CGFloat scale=1.0;
    if ([[UIScreen mainScreen] bounds].size.height > 480){
        scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
    }
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-80-10*3)/2,140*scale);
}
@end
