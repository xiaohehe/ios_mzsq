//
//  CannelViewController.h
//  MuZhiSheQu
//
//  Created by lt on 2017/7/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "XiePingJiaViewController.h"
#import "OderStatesViewController.h"
#import "weifukuanViewController.h"
#import "RCDChatViewController.h"

@interface CannelViewController : SuperViewController
@property(nonatomic,strong)UIView *bigBtnVi,*big;
@property(nonatomic,strong)UIScrollView *bigScrollView,*bigScrollView1,*bigScrollView2,*bigScrollView3;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)NSString *zhuang;
@property(nonatomic,strong)NSMutableArray *data,*data1,*data2,*data3;
@property(nonatomic,assign)NSInteger index,index1,index2,index3;
@property(nonatomic,assign)int sum;
@property(nonatomic,assign)float ji;
@end
