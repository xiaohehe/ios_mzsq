//
//  FuWuXiangQingViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "QuPingJiaViewController.h"
#import "XiePingJiaViewController.h"
#import "RCDChatViewController.h"

@interface FuWuXiangQingViewController : SuperViewController<UIAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray *lines;
@property(nonatomic,strong)NSString *orderid;
@property(nonatomic,strong)NSString *smallOder;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)float bot,botLeft,botTop, setY;
@property(nonatomic,strong)UILabel *shouldPayPrice;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSArray *DayArr;
@property(nonatomic,strong)NSMutableArray *TimeArr,*TodayArr,*DataArr;
@property(nonatomic,strong)UIImageView *SelectImg,*stripVi,*topArrow;
@property(nonatomic,strong)UIPickerView *TimePickerView;
@property(nonatomic,strong)UIControl *big;
@property(nonatomic,strong)UIButton *peisong;
@property(nonatomic,strong)NSMutableDictionary *prodInfo,*shopInfo,*bigDic,*ar;;
@property(nonatomic,strong)NSMutableArray *prodArr,*shopArr;
@property(nonatomic,strong)NSMutableArray *data;


@property(nonatomic,strong)UIControl *topCon;

@property(nonatomic,strong)UILabel *shouHuoer,*shouName,*shouTal,*shouAddressLa,*addressLa;
@end
