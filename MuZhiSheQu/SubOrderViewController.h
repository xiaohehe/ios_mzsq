//
//  SubOrderViewController.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperViewController.h"

@interface SubOrderViewController : SuperViewController
@property(nonatomic,copy)NSString *type;

-(id)initWithType:(NSString*)type;
@end
