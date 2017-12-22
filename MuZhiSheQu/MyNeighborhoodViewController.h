//
//  MyNeighborhoodViewController.h
//  MuZhiSheQu
//
//  Created by lt on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "SMPagerTabView.h"

@interface MyNeighborhoodViewController : SuperViewController<SMPagerTabViewDelegate>
@property(nonatomic,assign)NSInteger type;

@end
