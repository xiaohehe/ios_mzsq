//
//  GetBaiDuMapViewController.h
//  MZSQShop
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import <MapKit/MapKit.h>
typedef void(^GetBaiDuMapBlock)(NSDictionary *dic);
@interface BaiDuPlace : NSObject<MKAnnotation>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@end
@interface GetBaiDuMapViewController : SuperViewController
- (void)getZuoBiaoBlock:(GetBaiDuMapBlock)block;
@end
