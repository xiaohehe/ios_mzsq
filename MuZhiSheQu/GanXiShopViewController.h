//
//  GanXiShopViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "OderQuerenViewController.h"
#import "RCDChatViewController.h"
typedef void (^reshshocuang)(NSString *str);
@interface GanXiShopViewController : SuperViewController<UIPickerViewDataSource,UIPickerViewDelegate>


@property(nonatomic,strong)UIScrollView *bigScroll;
@property(nonatomic,strong)UIImageView *topImg,*startImg,*SelectImg;
@property(nonatomic,strong)UIView *shopBigVi,*start;
@property(nonatomic,strong)UILabel *nameLa,*scoreLa;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *titlee;
@property(nonatomic,strong)NSString *topSetimg;
@property(nonatomic,strong)NSArray *DayArr;
@property(nonatomic,strong)NSMutableArray *TimeArr,*TodayArr,*DataArr;
@property(nonatomic,strong)NSString *shop_user_id;
@property(nonatomic,strong)UIPickerView *TimePickerView;
@property(nonatomic,strong)UIControl *big;
@property(nonatomic,assign)BOOL issleep,isOpen,isPush;
@property(nonatomic,strong)NSString *songTime,*gonggao;
@property(nonatomic,strong)NSString * shop_id;



@property(nonatomic,strong)NSDictionary *zongshuju;

-(void)reshshoucahng:(reshshocuang)block;
@end
