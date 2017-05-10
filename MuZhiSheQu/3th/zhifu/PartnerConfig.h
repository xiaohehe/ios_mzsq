//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h
#import "WXApi.h"
#import <QuartzCore/QuartzCore.h>
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088121118421690"
//收款支付宝账号
#define SellerID  @"mzsq2015@gmail.com"
//安全校验码（MD5）密钥，以数字和字母组成的32位字符
//jz980njaoohyb7n174kdvnb4i1saitmg
#define MD5_KEY @"ej9519j7oj1yij88gstlrafkpdo0sgpi"
//回调网址
#define CallBackWeb @"https://app.mzsq.cc/PayAli/notify_url.php"
//商户私钥，自助生成
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOwkQTkLStPeSLWlGQfz9caeSr4WqHNU1XcOJJY2dbNf6uOEfPeX7EnfUbvpwCYQ9CmoTEUYtw/+2/qRj115mtc23IlCE0q02VyVO166yc7iPZNdHsrWHRK35BuoC6kyBckjIs3fjCJsHF3yFhSt+gcNNYpGEa1EuxX3XAX1dq0xAgMBAAECgYA+dDQ/1wm6UT7fs8OUA+TL3A+eiLWSkyxF6Zqpk8u7XjHsbJz0ity2iPbAAUmNh8xbvCQ33hqEg35AngDR0xitMrA2WyEHwlw4TaOTumFaN7NngIt6vFaMXPrmbGYGWQGmTCf55BrUOZfiVQacat9SFmkd449Yq+x8bAzJWhNgBQJBAP+9VZk8gGg2m2KAH3jQ8oqJok46PjS5iOqzNZH7OdeFLnyFWpMvCe8qDmGXqw3eHSPqIVwenABHVTFnE4xrT+MCQQDsYc/IdHESKd8FGGwsJD6lz0bqA3j5kspWJRPDjhkGdr+T1sUqHgZjoUWFwdf54cvYNAZ3Dc/GftM2ZOEO5TLbAkEArChy9UMrVfxcwgRqK1TN0cExh+PheHDl4MlfaLRsjc9UKfNDtA1YbK4tHDmTpzQ8/a5hYrggYHekvCsdl8ut7QJANNrSGSJgPg16vqrtVRltoKmuU5kfLb7y2zxDJRDa66UVxTrar0Yza4eeAgCMCGXCrL9FSs2dzeaB18HKyQfazQJBAINBmQt+/qgYx6Bq6cCYBtgH2Ar26we8KXA6Fw1DWWQLAozM0vcbl48s+MQoa//NDFSwcguXDHER0/jJiiYViGU="

//支付宝公钥  rsaPubKey
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB"

#pragma mark - 微信支付配置
//商户号   ok
#define PARTNER_ID   @"1283807401"
//商户密钥     ok
#define PARTNER_KEY  @"zxcvbnma12345678ASDFGHJKpoiuytre"
 //APPID     ok
#define APPI_ID   @"wxfae2522ed8bf4de8"
  //appsecret   ok
#define APP_SECRET @"d4624c36b6795d1d99dcf0547af5443d"
//回调网站
#define WXNotifiURL @"https://app.mzsq.cc/PayWx/example/notify.php"

#endif
