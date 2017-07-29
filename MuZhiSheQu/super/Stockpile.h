//
//  Stockpile.h
//  CenterFo
//
//  Created by apple on 14-7-11.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Helper.h"

#define single_interface(class)  + (class *)shared##class;

@interface Stockpile : NSObject

single_interface(Stockpile);

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *Name;
@property (nonatomic,strong) NSString *password;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *logo;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *usertoken;
@property(nonatomic,strong)NSString *City,*area;
@property(nonatomic,strong)NSString *Sheng;
@property(nonatomic,strong)NSString *Role;
@property(nonatomic,strong)NSString *Account;
@property(nonatomic,strong)NSString *AccountType;
@property(nonatomic,strong)NSString *YUE;
@property(nonatomic,strong)NSString *ONLine;


@property(nonatomic,assign)BOOL isLogin;
@property(nonatomic,assign)BOOL isSave;
@property(nonatomic,assign)BOOL Secret,tuiS;
@property(nonatomic,strong)NSString *LogPwd;
@end
