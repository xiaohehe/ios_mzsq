//
//  ShopInfoViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "LoginViewController.h"
#import "RCDChatViewController.h"

@protocol shopInfoDelegate <NSObject>

-(void)addNumberindex:(NSInteger)index number:(NSInteger)number  jiaAndJian:(BOOL) isAdd;
-(void)returnNum:(NSInteger)num;
@end

typedef void (^reshChoucang)(NSString *str);
@interface ShopInfoViewController : SuperViewController<NSXMLParserDelegate>
@property(nonatomic,strong)UIImageView *bottomR,*bottomL;
@property(nonatomic,strong)UIView *botROne,*botRTwo;
@property(nonatomic,strong)NSString *shop_id,*prod_id;
@property(nonatomic, strong) NSMutableString *soapResults;
@property(nonatomic,strong)NSString *num,*price,*yunfei;
@property(nonatomic,assign)NSInteger indexNumber;
@property(nonatomic,assign)int numb;
@property(nonatomic,assign)BOOL issleep,islunbo,yes,isopen;
@property(nonatomic,assign)id<shopInfoDelegate>delegate;
//@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *xiaoliang,*shoucang;
@property(nonatomic,strong)NSString *shop_name;
@property(nonatomic,strong)NSString *shop_user_id,*tel;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,assign)NSInteger indexs;
@property(nonatomic,retain)NSString * gongGao;
//是否是从收藏进来的 ，从收藏进来的只让本页面增加
@property(nonatomic,assign)BOOL orshoucang,isgo;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,strong)NSDictionary * pushArray;
@property(nonatomic,strong)NSDictionary * param;
@property(nonatomic,strong)NSString *hotlineLs;
-(void)reshChoucang:(reshChoucang)block;
@end
