//
//  SheQuManagerViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "PassValueDelegate.h"

@interface SheQuManagerViewController : SuperViewController
@property(nonatomic,assign)BOOL xuanshequ;
@property(nonatomic,assign)BOOL nojiantou;
@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;
@end
