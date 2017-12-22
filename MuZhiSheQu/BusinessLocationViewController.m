//
//  BusinessLocationViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BusinessLocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "MapNavigationManager.h"

@interface BusinessLocationViewController ()<BMKMapViewDelegate>
@property(nonatomic,strong)BMKMapView* mapView;
@property(nonatomic,strong)BMKPointAnnotation* animatedAnnotation;
@property(nonatomic,strong)BMKAnnotationView* annotationView;
@property(nonatomic,strong) UIControl *paopaoBgView;
@end

@implementation BusinessLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNav];
    [self newView];
}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    if (_animatedAnnotation == nil) {
        _animatedAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        CGFloat longitude = [_infoDic[@"longitude"] floatValue];
        CGFloat latitude = [_infoDic[@"latitude"] floatValue];
        NSLog(@"longitude==%f,latitude==%f",longitude,latitude);
        coor.latitude = latitude;
        coor.longitude = longitude;
        _animatedAnnotation.coordinate = coor;
        //_animatedAnnotation.title = @"我是动画Annotation";
    }
    [_mapView addAnnotation:_animatedAnnotation];
}

-(void)newView{
    _mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height - self.NavImg.bottom)];
    CGFloat longitude = [_infoDic[@"longitude"] floatValue];
    CGFloat latitude = [_infoDic[@"latitude"] floatValue];
    _mapView.centerCoordinate= CLLocationCoordinate2DMake(latitude, longitude);
    [self.view addSubview:_mapView];
    [_mapView setZoomLevel:16];
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=_infoDic[@"shopname"];
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    //[popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [popBtn setTitleColor:[UIColor colorWithRed:0.612 green:0.612 blue:0.612 alpha:1.00] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.height-.5, self.view.width, .5)];
    topline.backgroundColor=blackLineColore;
    //[self.NavImg addSubview:topline];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]){
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        _annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (_annotationView == nil){
            _annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:reuseIndetifier];
        }
        _annotationView.image = [UIImage imageNamed:@"map_mark.png"];
        _paopaoBgView = [[UIControl alloc]initWithFrame:CGRectMake(0, -5, 200*self.scale, 60*self.scale)];
        _paopaoBgView.userInteractionEnabled=YES;
        _paopaoBgView.backgroundColor = [UIColor whiteColor];
        //设置圆角边框
        _paopaoBgView.layer.cornerRadius = 5;
        _paopaoBgView.layer.masksToBounds = YES;
        //设置边框及边框颜色
        _paopaoBgView.layer.borderWidth = .5;
        _paopaoBgView.layer.borderColor =[ [UIColor grayColor] CGColor];
//        _paopaoBgView.layer.shadowOpacity = 0.8;// 阴影透明度
//        _paopaoBgView.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
//        _paopaoBgView.layer.shadowRadius = 4;// 阴影扩散的范围控制
//        _paopaoBgView.layer.shadowOffset = CGSizeMake(4, 4);// 阴影的范围

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 140*self.scale, 20*self.scale)];
        label.text =_infoDic[@"shopname"];
        label.textColor=[UIColor colorWithRed:0.157 green:0.153 blue:0.149 alpha:1.00];
        label.font=[UIFont systemFontOfSize:16];
        [_paopaoBgView addSubview:label];
        
        UIImageView *iconImgV = [[UIImageView alloc]initWithFrame:CGRectMake(label.right+10*self.scale, label.top, 30*self.scale, 30*self.scale)];
        iconImgV.image = [UIImage imageNamed:@"navigation"];
        [_paopaoBgView addSubview:iconImgV];
        
        UILabel *addressLb = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, label.bottom+5*self.scale, 180*self.scale, 20*self.scale)];
        addressLb.text =_infoDic[@"address"];
        addressLb.textColor=[UIColor colorWithRed:0.157 green:0.153 blue:0.149 alpha:1.00];
        addressLb.font=[UIFont systemFontOfSize:13];
        [_paopaoBgView addSubview:addressLb];
        BMKActionPaopaoView *paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:_paopaoBgView];
        paopaoView.userInteractionEnabled=YES;
        _annotationView.paopaoView = paopaoView;
        return _annotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
     [_annotationView.paopaoView removeFromSuperview];
}

/**
 * 当选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    
    //_shopCoor = view.annotation.coordinate;
}
/**
 * 选中气泡调用方法
 * @param mapView 地图
 * @param view annotation
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    NSLog(@"annotationViewForBubble");
    CGFloat longitude = [_infoDic[@"longitude"] floatValue];
    CGFloat latitude = [_infoDic[@"latitude"] floatValue];
    [MapNavigationManager showSheetWithCoordinate2D:CLLocationCoordinate2DMake(latitude, longitude) andShopName:_infoDic[@"shopname"]];
}
@end
