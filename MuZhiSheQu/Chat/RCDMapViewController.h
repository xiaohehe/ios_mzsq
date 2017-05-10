//
//  MapViewController.h
//  AdultStore
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface RCDPlace : NSObject<MKAnnotation>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@end
@interface RCDMapViewController : SuperViewController
@property(nonatomic,strong)RCLocationMessage *locationMessageContent;
@end
