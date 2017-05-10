//
//  OderQuerenViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/10/28.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "orderSuessViewController.h"
#import "ShouHuoDiZhiListViewController.h"
#import "LingshouSuesccViewController.h"
#import "RCDChatViewController.h"

@interface OderQuerenViewController : SuperViewController
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *shopName,*headImg,*xiatime,*yueyutime,*beizhu1;
@property(nonatomic,strong)NSMutableArray *projectIndex,*project;;

@property(nonatomic,strong)NSMutableDictionary *data;

@property(nonatomic,strong)NSString *songTime;
@property(nonatomic,assign)BOOL isopen;
@end
