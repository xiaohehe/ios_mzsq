//
//  AllorderShopViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/6.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "XiePingJiaViewController.h"
#import "OderStatesViewController.h"
#import "weifukuanViewController.h"
#import "RCDChatViewController.h"

@interface AllorderShopViewController : SuperViewController
@property(nonatomic,strong)UIView *bigBtnVi,*big;
@property(nonatomic,strong)UIScrollView *bigScrollView,*bigScrollView1,*bigScrollView2,*bigScrollView3;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)NSString *zhuang;
@property(nonatomic,strong)NSMutableArray *data,*data1,*data2,*data3;
@property(nonatomic,assign)NSInteger index,index1,index2,index3;
@property(nonatomic,assign)int sum;
@property(nonatomic,assign)float ji;
@end
