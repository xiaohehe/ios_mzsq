//
//  ActivityDetailsViewController.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperViewController.h"

@interface ActivityDetailsViewController : SuperViewController
@property(nonatomic,copy) NSString* mid;
@property(nonatomic,copy) NSString* moduleName;
@property(nonatomic) BOOL isConvert;
@property(nonatomic,strong)NSDictionary* dic;
@end
