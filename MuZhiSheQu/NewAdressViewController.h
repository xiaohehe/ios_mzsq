//
//  NewAdressViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "HuoQuDiTuZuoBiaoViewController.h"
#import "RCDLocationViewController.h"
@interface NewAdressViewController : SuperViewController<RCLocationPickerViewControllerDelegate,RCLocationPickerViewControllerDataSource>
@property(nonatomic,strong)NSMutableArray *commData;
@property(nonatomic,strong)UIControl *big;
@property(nonatomic,strong)UIImageView *SelectImg;
@property(nonatomic,strong)UIPickerView *TimePickerView;
@end
