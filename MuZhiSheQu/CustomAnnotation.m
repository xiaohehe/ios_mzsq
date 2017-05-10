//
//  CustomAnnotation.m
//  demoForMap
//
//  Created by apple on 15/11/28.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize coordinate, title, subtitle;



-(id) initWithCoordinate:(CLLocationCoordinate2D) coords
{
    if (self = [super init]) {
        coordinate = coords;
    }
    return self;
}



@end
