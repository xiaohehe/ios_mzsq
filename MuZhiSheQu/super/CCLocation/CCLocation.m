//
//  CCLocation.m
//  CCLocation
//
//  Created by apple on 15-1-12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CCLocation.h"
#import "CLLocation+YCLocation.h"
#define single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}
static CCLLocationBlock _locationBlock;
static CLLocationManager *_locationManager;
@implementation CCLocation
single_implementation(CCLocation);
-(void)getLocation:(CCLLocationBlock) locationBlock{
    _locationBlock=locationBlock;
    [self Location];
}
-(void)Location{
    _locationManager=[[CLLocationManager alloc]init];
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        [_locationManager requestWhenInUseAuthorization];
    }
    _locationManager.delegate=self;
    [_locationManager startUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    if (locations.count<1) {
        return;
    }
    CLLocation *newLocation=(CLLocation *)locations.lastObject ;
    CLLocation *Fir=newLocation;
   newLocation=[newLocation locationMarsFromEarth];
    CLLocationCoordinate2D mylocation = newLocation.coordinate;
   // CLLocation *Fir=[[CLLocation alloc]initWithLatitude:mylocation.latitude longitude:mylocation.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:Fir completionHandler:^(NSArray* placemarks,NSError *error)
     {
         if (placemarks.count >0 )
         {
             CLPlacemark * plmark = [placemarks objectAtIndex:0];
             NSString * country = plmark.country;
             NSString * city    = plmark.locality;
             NSString *area = plmark.subLocality;
             NSString *place=plmark.name;
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (!_realTime)
                 {
                     [_locationManager stopUpdatingLocation];
                 }
                 _locationBlock(mylocation,country,city,place,area);
             });
         }
     }];
}

@end
