//
//  GongGaoSouSuoViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^GongGaoBlock)(NSDictionary *gonggao);
@interface GongGaoSouSuoViewController : SuperViewController

-(void)ShowViewWithBlock:(GongGaoBlock)block;
-(void)HiddenView;
@end
