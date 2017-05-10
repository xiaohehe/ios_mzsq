//
//  CellView.h
//  BaoJiaHuHang
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellView : UIView
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *RightImg;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;

@property(nonatomic,strong)UIImageView *topline;
@property(nonatomic,strong)UIImageView *bottomline;
-(void)ShowRight:(BOOL)show;
-(void)setHiddenLine:(BOOL)hidden;
@end
