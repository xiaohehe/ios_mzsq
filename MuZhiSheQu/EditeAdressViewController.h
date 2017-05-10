//
//  EditeAdressViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "RCDLocationViewController.h"

@interface EditeAdressViewController : SuperViewController<RCLocationPickerViewControllerDelegate>
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)BOOL shi;
@property(nonatomic,strong)NSString *adressid,*xiaoquid;
@property(nonatomic,strong)NSString *shouRen,*shouTel,*shouaddres,*shousex,*shoushequname;

@property(nonatomic,strong)UITextField *nameTF,*xiaoqux,*dizhix,*shoujix;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSMutableArray *commData;
@property(nonatomic,assign)BOOL isdefent,orfanData;
@property(nonatomic,strong)NSString *menpaihao;
@end
