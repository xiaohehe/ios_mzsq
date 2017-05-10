//
//  NSString+Encrypt.h
//  DES
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Encrypt)
+ (NSString *)encryptWithText:(NSString *)sText ForKey:(NSString *)key ForInitIv:(NSString *)initIv;//加密
+ (NSString *)decryptWithText:(NSString *)sText ForKey:(NSString *)key ForInitIv:(NSString *)initIv;//解密
@end
