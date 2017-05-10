//
//  ChooseQuViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "CityViewController.h"


typedef void(^GuideBlock)(BOOL success);
@interface ChooseQuViewController : SuperViewController
-(id)initWithBlock:(GuideBlock)block;
@end
