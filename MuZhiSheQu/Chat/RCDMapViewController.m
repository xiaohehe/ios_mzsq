//
//  MapViewController.m
//  AdultStore
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RCDMapViewController.h"
#import "CLLocation+YCLocation.h"

@implementation RCDPlace
@end
@interface RCDMapViewController()<MKMapViewDelegate>
@property(nonatomic,strong)MKMapView *mapView;
@end
@implementation RCDMapViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self newNav];
    [self newView];
}
-(void)newView{
    _mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    
    //float longitude=_locationMessageContent.location.longitude;
    //float latitude=_locationMessageContent.location.latitude;
   // CLLocation *Fir=[[[CLLocation alloc]initWithLatitude:latitude longitude:longitude] locationMarsFromBaidu];
    
    /*添加大头针*/
    RCDPlace *myPlace=[[RCDPlace alloc] init];
   myPlace.title=_locationMessageContent.locationName;
    //myPlace.subtitle=_locationMessageContent.locationName;
    myPlace.coordinate=_locationMessageContent.location;
    [_mapView addAnnotation:myPlace];
    
    /*显示区域*/
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(_locationMessageContent.location,4000 ,4000);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
    [_mapView setRegion:adjustedRegion animated:YES];
}
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text =@"位置信息";
    self.navigationController.navigationBar.backgroundColor=[UIColor redColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:backBtn];
}
-(void)PopVC:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}
@end
