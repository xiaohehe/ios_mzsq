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
#import <ShareSDK/ShareSDK.h>

#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
@interface GongGaoInfoViewController : SuperViewController
@property(nonatomic,strong)NSString *gongID,*type;
@property(nonatomic,strong)UITextField *mesay;
@property(nonatomic,assign)BOOL bian;
@end
