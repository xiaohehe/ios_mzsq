//
//  GongGaoInfoViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "CellView.h"
#import "XiangQingTableViewCell.h"
#import "PassValueDelegate.h"
#import "WXApi.h"

@interface GongGaoInfoViewController : SuperViewController
@property(nonatomic,strong)NSString *gongID,*type;
@property(nonatomic,strong)UITextField *mesay;
@property(nonatomic,assign)NSInteger gIndex;
@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;
@property(nonatomic,assign)BOOL bian;
@property(nonatomic,strong)NSMutableDictionary *gDic;
@end
