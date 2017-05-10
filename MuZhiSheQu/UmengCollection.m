//
//  UmengCollection.m
//  MuZhiSheQu
//
//  Created by lmy on 16/6/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UmengCollection.h"
#import <UMMobClick/MobClick.h>

#define Channel   @"App Store"
#define UMengKey    @"576c94d567e58e868e00182f"
@implementation UmengCollection
+ (void)setup
{
    UMConfigInstance.appKey=UMengKey;
    UMConfigInstance.channelId=Channel;
    UMConfigInstance.eSType=E_UM_NORMAL;
    [MobClick startWithConfigure:UMConfigInstance];
    
}

+ (void)intoPage:(NSString *)pageName
{
    [MobClick beginLogPageView:pageName];
}

+ (void)outPage:(NSString *)pageName
{
    [MobClick endLogPageView:pageName];
}

+ (void)event:(NSString *)event
        value:(NSString *)value
{
    [MobClick event:event label:value];
}
@end
