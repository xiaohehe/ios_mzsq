//
//  SuperTableViewCell.h
//  Wedding
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultPageSource.h"
#import "LineView.h"
@interface SuperTableViewCell : UITableViewCell
@property(nonatomic,assign)float scale;
-(void)ShowAlertWithMessage:(NSString *)message;
#pragma mark -- 根据宽度获取字符串的高和宽
- (CGRect)getStringWithFont:(float)font withString:(NSString *)string withWith:(CGFloat)with;

@end
