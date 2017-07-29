//
//  HuoQuDiTuZuoBiaoViewController.m
//  HuanBaoWeiShi
//
//  Created by mac on 15/7/15.
//  Copyright (c) 2015年 mac. All rights reserved.
//
#import "HuoQuDiTuZuoBiaoViewController.h"
#import <MapKit/MapKit.h>
#import "CLLocation+YCLocation.h"
#import "CCLocation.h"
#import "CustomAnnotation.h"
#import "UmengCollection.h"
@interface HuoQuDiTuZuoBiaoViewController ()<MKMapViewDelegate>

@property(nonatomic,strong) MKMapView *mapView;

@property(nonatomic,strong) HuoQuDiTuZuoBiaoBlock block;
@property(nonatomic,strong) NSDictionary *dic;
@property(nonatomic,strong)CustomAnnotation* annotation;


@end

@implementation HuoQuDiTuZuoBiaoViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}
- (void)getZuoBiaoBlock:(HuoQuDiTuZuoBiaoBlock)block{

    _block = block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self newNav];
 
    [self newMap];
}
- (void)newMap{
        _mapView = [[MKMapView alloc] init];
    _mapView.frame = CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height - self.NavImg.bottom);
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;//标准模式
  //  _mapView.showsUserLocation = YES;//显示自己
    [self.view addSubview:_mapView];
    
    UILabel *TiShiLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 22*self.scale)];
    TiShiLabel.backgroundColor=[UIColor colorWithRed:225/255.0 green:148/255.0 blue:49/255.0 alpha:0.8];
    TiShiLabel.font=SmallFont(self.scale);
    TiShiLabel.text=@"长按获取您选中的经纬度";
    TiShiLabel.textAlignment=NSTextAlignmentCenter;
    TiShiLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:TiShiLabel];
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.3;//按0.5秒响应longPress方法
    lpress.allowableMovement = 10.0;
    //给MKMapView加上长按事件
    [self.mapView addGestureRecognizer:lpress];//mapView是MKMapView的实例
    [[CCLocation sharedCCLocation] getLocation:^(CLLocationCoordinate2D locationCoordinate2D, NSString *country, NSString *city, NSString *place,NSString *area) {
     _dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%f",locationCoordinate2D.latitude],
                                 @"latitude",
                                 [NSString stringWithFormat:@"%f",locationCoordinate2D.longitude],
                                 @"longitude",
                                 city,@"city",
                                 place,@"place",
                                 nil];
       MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(locationCoordinate2D,5000 ,5000);
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
        if (_annotation) {
            [self.mapView removeAnnotation:_annotation];
        }
       _annotation=[[CustomAnnotation alloc]initWithCoordinate:locationCoordinate2D];
        _annotation.title=place;
      [self.mapView addAnnotation:_annotation];
        [_mapView setRegion:adjustedRegion animated:YES];
    }];
}

- (void)longPress:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){  //这个状态判断很重要
        //坐标转换
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        NSLog(@"%f",touchMapCoordinate.latitude);
        NSLog(@"%f",touchMapCoordinate.longitude);
        CLLocation *Location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
        Location = [Location locationBaiduFromMars];
        CLLocation *Fir=[[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:Fir completionHandler:^(NSArray* placemarks,NSError *error)
         {
             if (placemarks.count >0 )
             {
                 CLPlacemark * plmark = [placemarks objectAtIndex:0];
                // NSString * country = plmark.country;
                 NSString * city    = [NSString stringWithFormat:@"%@",plmark.locality];
                 NSString *place=[NSString stringWithFormat:@"%@",plmark.name];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          [NSString stringWithFormat:@"%f",touchMapCoordinate.latitude],
                                          @"latitude",
                                          [NSString stringWithFormat:@"%f",touchMapCoordinate.longitude],
                                          @"longitude",
                                          city,@"city",
                                          place,@"place",
                                          nil];
                     if (_annotation) {
                         [self.mapView removeAnnotation:_annotation];
                     }
                     _annotation=[[CustomAnnotation alloc]initWithCoordinate:touchMapCoordinate];
                     _annotation.title=place;
                     [self.mapView addAnnotation:_annotation];
                   //  _block(dic);
                     _dic=dic;
                 });
             }
         }];
     //   [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)newNav{
    self.TitleLabel.text = @"地图";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton* configue=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-50,self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [configue setTitle:@"确定" forState:UIControlStateNormal];
    [configue setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    configue.titleLabel.font=DefaultFont(self.scale);
    [configue addTarget:self action:@selector(configueClick) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:configue];
}

-(void)configueClick{
    if (_dic) {
        
        if (_block) {
            _block(_dic);

        }
    }
    
 
   [self.navigationController popViewControllerAnimated:YES];
}

- (void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
