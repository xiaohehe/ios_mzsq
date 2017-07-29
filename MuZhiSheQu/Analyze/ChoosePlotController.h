//
//  ChoosePlotController.h
//  MuZhiSheQu
//
//  Created by lt on 2017/5/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "PassValueDelegate.h"
typedef void(^GuideBlock)(BOOL success);

@interface ChoosePlotController : SuperViewController<UITableViewDataSource,UITableViewDelegate,PassValueDelegate>
@property(nonatomic) BOOL* isRoot;//
@property(nonatomic,copy) NSString* plotName;//当前小区名称
@property(nonatomic,strong) NSMutableArray* plotArray;//附近小区数组
@property(nonatomic,strong)GuideBlock block;
-(id)initWithBlock:(GuideBlock)block;
@end
