//
//  FindeshViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^GuideBlock)(BOOL success);


@interface FindeshViewController : SuperViewController
@property(nonatomic,strong)NSString *ID;
-(id)initWithBlock:(GuideBlock)block;

@property(nonatomic,strong)NSString *cityName;
@end
