//
//  CCLocation.h
//  CCLocation
//
//  Created by apple on 15-1-12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#define single_interface(class)  + (class *)shared##class;
typedef void (^CCLLocationBlock)(CLLocationCoordinate2D locationCoordinate2D,NSString * country,NSString * city,NSString *place,NSString *area);
@interface CCLocation : NSObject<CLLocationManagerDelegate>
single_interface(CCLocation);
@property(nonatomic,assign)BOOL realTime;
-(void)getLocation:(CCLLocationBlock) locationBlock;
@end
