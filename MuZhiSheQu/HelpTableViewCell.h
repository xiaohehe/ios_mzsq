//
//  HelpTableViewCell.h
//  AdultStore
//
//  Created by apple on 15/5/30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperTableViewCell.h"

@interface HelpTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *rigthImg;
@property(nonatomic,strong)UIImageView *HeaderImg;
@property(nonatomic,assign)BOOL isRound;
@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)UIImageView *topline;
@property(nonatomic,strong)UIImageView *bottomline;
@property(nonatomic,strong)LineView *lineView;
@end
