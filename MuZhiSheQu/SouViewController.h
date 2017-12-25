//
//  SouViewController.h
//  MuZhiSheQu
//
//  Created by lmy on 2016/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SuperViewController.h"

@interface SouViewController : SuperViewController
@property(nonatomic,strong)NSString *keyword;
@property(nonatomic,strong)NSString * shop_id;
@property(nonatomic,strong)UIImageView *bottomR,*bottomL;
@property(nonatomic,strong)UIView *botROne,*botRTwo;
@property(nonatomic,strong)NSDictionary * shopData;
@end
