//
//  AppDelegate.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "payRequsestHandler.h"

typedef void(^WXPayBlock)(BaseResp * resp);
typedef void(^ApiPayBlock)(NSDictionary *resp);

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)UITabBarController *tabBarController;
@property(nonatomic,strong)UINavigationController *presonNav;
@property(nonatomic,strong) NSMutableDictionary* shopDictionary;//购物车商品及数量字典
@property(nonatomic,strong) NSMutableDictionary* shopInfoDic;//商铺信息
@property(nonatomic,copy) NSDictionary* shopUserInfo;//聊天用户信息
@property(nonatomic) BOOL isRefresh;//是否需要刷新
@property(nonatomic) BOOL isRefuse;//是否拒绝领券
@property(nonatomic) BOOL isNewShop;//是否新店

@property(nonatomic,strong)void (^callbackLocation)(NSString *str);
-(void)outLogin;
-(void)newTabBarViewController:(BOOL)orgen;
-(void)ZhuCeJPush;
-(int)ReshData;
-(void)RongRunInit;
-(void)dingwei;
-(int)appNum;
-(void)ziding;
-(void)WXPayNewWithNonceStr:(NSString *)nonceStr OrderID:(NSString *)orderId Timestamp:(NSString *)timestamp sign:(NSString *)sign complete:(WXPayBlock)complete;
/**
 *微信支付   价格price单位是分  并且不能有小数点
 *orderId  订单号
 *orderName  商品的名称
 *返回   resp.errCode == WXSuccess: @"支付结果：成功！";
 */
-(void)WXPayPrice:(NSString *)price OrderID:(NSString *)orderId OrderName:(NSString *)orderName complete:(WXPayBlock)complete;
/**
 *支付宝支付   价格price
 *orderId  订单号
 *orderName  商品的名称
 *description  商品的描述
 *返回参数  [resp objectForKey:@"resultStatus"] == @“9000”  支付成功;
 */
-(void)AliPayPrice:(NSString *)price OrderID:(NSString *)orderId OrderName:(NSString *)orderName OrderDescription:(NSString *)description  complete:(ApiPayBlock)complete;
-(void)AliPayNewPrice:(NSString *)price OrderID:(NSString *)orderId OrderName:(NSString *)orderName Sign:(NSString*)sign OrderDescription:(NSString *)description  complete:(ApiPayBlock)complete;
@end

