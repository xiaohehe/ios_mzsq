//
//  SuperViewController.h
//  MissAndFound
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultPageSource.h"
#import "NSString+Helper.h"
#import "UIViewAdditions.h"
#import "Stockpile.h"
#import "UIActivityIndicatorView+Helper.h"
#import "AppDelegate.h"

//#import "CustomSearchBar.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "AnalyzeObject.h"
#import "UIView+MJExtension.h"
#import "AFAppDotNetAPIClient.h"
#import "MJRefresh.h"
#import "LineView.h"
#import "UIImage+Helper.h"
#import "LoadFailureView.h"

typedef void(^AlertBlock)(NSInteger index);
typedef void(^dismissBlock)(BOOL isDismiss);
@interface SuperViewController : UIViewController
@property(nonatomic,assign)float scale;
@property(nonatomic,assign)BOOL isIphoneX;
@property(nonatomic,strong)UIImageView *NavImg;
@property(nonatomic,strong)UILabel *TitleLabel;
@property(nonatomic,strong)UIActivityIndicatorView *activityVC;
@property(nonatomic,strong)UIImageView *Navline;
@property(nonatomic,strong)AppDelegate *appdelegate;
@property(nonatomic,strong)NSString *commid,*user_id;
@property(nonatomic,retain)UIImageView * hongDianImageView;
@property(nonatomic,strong)dismissBlock dismissBlock;
@property(nonatomic,strong)CAGradientLayer *gradientLayer;
@property(nonatomic,strong) LoadFailureView* errorView;
@property(nonatomic,assign) CGFloat dangerAreaHeight;

-(void)getdismissBlock:(dismissBlock)dismissBlock;
-(void)gongGaoDian;
-(void)ShowAlertWithMessage:(NSString *)message;
-(void)ShowAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate Block:(AlertBlock)block;
-(void)setName:(NSString *)name;
-(NSString *)getCommid;
-(NSString *)getuserid;
-(NSMutableAttributedString *)stringColorAllString:(NSString *)string redString:(NSString *)redString;
-(id)login;
-(BOOL)getTimeWith:(NSDictionary *)shopInfo;
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
- (CGFloat)folderSizeAtPath:(NSString *)folderPath;
-(void)ClearCache;
- (long long)fileSizeAtPath:(NSString *)filePath;
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

- (CGRect)getStringWithFont:(float)font withString:(NSString *)string withWith:(CGFloat)with;
-(CGFloat)getStartHeight;
-(void) netError:(CGRect)frame;
@end
