//
//  GetBaiDuMapViewController.m
//  MZSQShop
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GetBaiDuMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "CellView.h"
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
@interface GetBaiDuMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property(nonatomic,strong)BMKMapView* mapView;
@property(nonatomic,strong)BMKLocationService* locService;
@property(nonatomic,strong)BMKGeoCodeSearch* geocodesearch;

@property(nonatomic,strong)NSDictionary *Dic;
@property(nonatomic,strong)CellView *LocationCell;
@property(nonatomic,strong)UIImageView *centerImg;
@property(nonatomic,assign)BOOL isDraw;

@property(nonatomic,strong) GetBaiDuMapBlock block;
@end

@class BMKAddrInfo;

@implementation GetBaiDuMapViewController

//-(void)onGetAddrResult:(BMKAddrInfo*)result{
//    NSLog(@"%@",result);
//    
//}


-(void)getZuoBiaoBlock:(GetBaiDuMapBlock)block{
    _block=block;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
}
-(void)newView{
    _mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, (self.view.height - self.NavImg.bottom)/2)];
    [self.view addSubview:_mapView];
     _locService = [[BMKLocationService alloc]init];
     _geocodesearch = [[BMKGeoCodeSearch alloc]init];
      [_mapView setZoomLevel:16];
    
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onGetAddrResult:) name:@"onGetAddrResult" object:nil];
    
 
    _LocationCell=[[CellView alloc]initWithFrame:CGRectMake(0, _mapView.bottom, _mapView.width, 44*self.scale)];
    _LocationCell.titleLabel.width=self.view.width-20*self.scale;
    _LocationCell.topline.hidden=NO;
    _LocationCell.backgroundColor=[UIColor clearColor];
    _LocationCell.bottomline.hidden=YES;
    [self.view addSubview:_LocationCell];
    
    _centerImg=[[UIImageView alloc]initWithFrame:CGRectMake(_mapView.width/2-14, _mapView.height/2-28, 28, 28)];
    [_mapView addSubview:_centerImg];
    _centerImg.image=[UIImage imageNamed:@"map_annotation"];
    
    UIButton *LoginBtn=[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, _LocationCell.bottom, self.view.width-36*self.scale, 30*self.scale)];
    [LoginBtn setBackgroundImage:[UIImage ImageForColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.6]] forState:UIControlStateNormal];
    //[LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn_b"] forState:UIControlStateHighlighted];
    [LoginBtn setTitle:@"当前位置" forState:UIControlStateNormal];
    [LoginBtn setTitleColor:blackTextColor forState:UIControlStateNormal];
    LoginBtn.titleLabel.font=BigFont(self.scale);
    LoginBtn.layer.cornerRadius=5;
    LoginBtn.layer.masksToBounds=YES;
    [LoginBtn addTarget:self action:@selector(LoginButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LoginBtn];
    
//    NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
//    NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
    
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
//    item.coordinate = CLLocationCoordinate2DMake([[Info objectForKey:@"latitude"] floatValue], [[Info objectForKey:@"longitude"] floatValue]);
    item.title = @"店铺位置";
//    [_mapView addAnnotation:item];
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
 _geocodesearch.delegate = self;
 
}
-(void)viewDidAppear:(BOOL)animated{
   [self StartFollowing];
}
-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
     _locService.delegate = nil;
      _geocodesearch.delegate = nil; // 不用时，置nil
}
-(void)StartFollowing{
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
      [_locService startUserLocationService];
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{

    if (error == 0) {
        _Dic= [[NSDictionary alloc] initWithObjectsAndKeys:
               [NSString stringWithFormat:@"%f",result.location.latitude],
               @"latitude",
               [NSString stringWithFormat:@"%f",result.location.longitude],
               @"longitude",result.address,@"address",
               nil];
         _LocationCell.titleLabel.text=result.address;
        [_locService stopUserLocationService];
    }
}



- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank       %f      %f",coordinate.latitude,coordinate.longitude);
    
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = coordinate;
    item.title = @"店铺位置";
    [_mapView addAnnotation:item];
    _isDraw=NO;
     [self getAddressByCLLocationCoordinate2D:coordinate];
}
#pragma BMKMap
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
  //  NSLog(@"heading is %@",userLocation.heading);
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
  //    [_mapView removeAnnotations:_mapView.annotations];
    _isDraw=YES;
     [self getAddressByCLLocationCoordinate2D:mapView.centerCoordinate];
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    [self getAddressByCLLocationCoordinate2D:userLocation.location.coordinate];
}
-(void)getAddressByCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate {
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"成功");
    }else{
        NSLog(@"失败");
    }
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}
/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}
- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    if (_locService) {
        _locService=nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}

#pragma mark - 导航
- (void)newNav{
    
    self.TitleLabel.text = @"地图";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton * SaveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.TitleLabel.height,self.TitleLabel.top,self.TitleLabel.height, self.TitleLabel.height)];
    [SaveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [SaveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    SaveBtn.titleLabel.font=DefaultFont(self.scale) ;
    [SaveBtn addTarget:self action:@selector(SaveButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:SaveBtn];
    /* UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, 90*self.scale, self.TitleLabel.height)];
     [popBtn setTitle:@"选择当前位置" forState:UIControlStateNormal];
     //[popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
     // [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
     [popBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     popBtn.titleLabel.font=DefaultFont(1) ;
     [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
     [self.NavImg addSubview:popBtn];*/
}
-(void)LoginButtonEvent:(id)sender{
       _isDraw=NO;
    [_mapView removeAnnotations:_mapView.annotations];
    [self StartFollowing];
}
-(void)SaveButtonEvent:(id)sender{
    if (_block && _Dic) {
        _block(_Dic);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
