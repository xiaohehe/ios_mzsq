//
//  Plot.h
//  MuZhiSheQu
//
//  Created by lt on 2017/5/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plot : NSObject
@property(nonatomic,copy) NSString* address;
@property(nonatomic,copy) NSString* city;
@property(nonatomic,copy) NSString* city_name;

@property(nonatomic,copy) NSString* distance;

@property(nonatomic,copy) NSString* district;
@property(nonatomic,copy) NSString* district_name;

@property(nonatomic,copy) NSString* pid;
@property(nonatomic,copy) NSString* latitude;
@property(nonatomic,copy) NSString* longitude;
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* province;
@property(nonatomic,copy) NSString* province_name;

@end
