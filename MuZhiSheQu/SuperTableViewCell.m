//
//  SuperTableViewCell.m
//  Wedding
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
#import "LoginViewController.h"

@implementation SuperTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _scale = 1.0;
        if ([[UIScreen mainScreen] bounds].size.height > 480)
        {
            _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
        }
    }
    return self;
}

-(void)ShowAlertWithMessage:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

#pragma mark -- 根据宽度获取字符串的高和宽
- (CGRect)getStringWithFont:(float)font withString:(NSString *)string withWith:(CGFloat)with
{
    CGRect stringRect = [string boundingRectWithSize:CGSizeMake(with, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return stringRect;
}


@end
