//
//  UmengCollection.h
//  MuZhiSheQu
//
//  Created by lmy on 16/6/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UmengCollection : NSObject
+ (void)setup;

+ (void)intoPage:(NSString *)pageName;
+ (void)outPage:(NSString *)pageName;

+ (void)event:(NSString *)event
        value:(NSString *)value;
@end
