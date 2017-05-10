//
//  RCDLocationViewController.m
//  AdultStore
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RCDLocationViewController.h"
#import "CCLocation.h"
#import "NSString+Helper.h"
#import "Stockpile.h"
#import "AppDelegate.h"

@implementation RCDLocationViewController



-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    _btn = [[UIButton alloc]initWithFrame:CGRectMake(12.5, self.view.width-35, self.view.width-25, 30)];
    _btn.layer.borderColor=blackLineColore.CGColor;
    _btn.layer.borderWidth=.5;
    _btn.layer.cornerRadius=5;
    _btn.layer.masksToBounds=YES;
    [_btn setTitle:@"当前位置" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor blackColor] forState:0];
    _btn.titleLabel.font=DefaultFont(1);
    _btn.backgroundColor=blackLineColore;
    
  // AppDelegate *app  = [UIApplication sharedApplication].delegate ;
    [self.view addSubview:_btn];
    
    
    [_btn addTarget:self action:@selector(bt) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width-25, .5)];
    vi.backgroundColor=blackLineColore;
    [_btn addSubview:vi];
    
    
    [self newNav];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)bt{

    
    
//    NSString *lat1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"lat"];
//    NSString *lon1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"lon"];
//    
//    
//    CLLocationDegrees latt1 = [lat1 doubleValue];
//    CLLocationDegrees lonn1 = [lon1 doubleValue];
//    CLLocationCoordinate2D loc2d1 = CLLocationCoordinate2DMake(latt1, lonn1);
//    
//
//    [self.dataSource setMapViewCenter:loc2d1 animated:YES];
//    
    
    
//    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app ziding];
    app.callbackLocation = ^(NSString *str){
    
        NSString *lat = [[NSUserDefaults standardUserDefaults]objectForKey:@"lat"];
        NSString *lon = [[NSUserDefaults standardUserDefaults]objectForKey:@"lon"];
        
        
        CLLocationDegrees latt = [lat doubleValue];
        CLLocationDegrees lonn = [lon doubleValue];
        CLLocationCoordinate2D loc2d = CLLocationCoordinate2DMake(latt, lonn);
        [self.dataSource setMapViewCenter:loc2d animated:YES];

    };
    
//    [self.dataSource titleOfPlaceMark:@"22"];
    
   // [self setMapViewCenter:loc2d animated:YES];
    
//    [appdelegate dingwei];
    
//    [[CCLocation sharedCCLocation]getLocation:^(CLLocationCoordinate2D locationCoordinate2D, NSString *country, NSString *city, NSString *place) {
//        if([city isChinese] ){
//            NSString *lat = [NSString stringWithFormat:@"%f",locationCoordinate2D.latitude];
//            NSString *lon = [NSString stringWithFormat:@"%f",locationCoordinate2D.longitude];
//            [[Stockpile sharedStockpile]setCity:city];
//            [[NSUserDefaults standardUserDefaults]setObject:lat  forKey:@"latitude"];
//            [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"longitude"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//            
//            
//            CLLocationDegrees latt = [lat doubleValue];
//            CLLocationDegrees lonn = [lon doubleValue];
//            
//            CLLocationCoordinate2D loc2d = CLLocationCoordinate2DMake(latt, lonn);
//        }
//
//    }];



}
//
//
//- (void)locationPicker:(RCLocationPickerViewController *)locationPicker
//     didSelectLocation:(CLLocationCoordinate2D)location
//          locationName:(NSString *)locationName
//         mapScreenShot:(UIImage *)mapScreenShot{
//
//
//}



//
//- (void)setMapViewCenter:(CLLocationCoordinate2D)location animated:(BOOL)animated{
//    
//
//}


-(void)newNav{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
       backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -15, 0, 15);
/*    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_img"]];
    backImg.contentMode=UIViewContentModeScaleAspectFit;
    backImg.frame = CGRectMake(-10, 8, 28, 28);
    [backBtn addSubview:backImg];
    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 11, 65, 22)];
    backText.text = @"返回";
    backText.font = BigFont(1);
    [backText setBackgroundColor:[UIColor clearColor]];
    [backText setTextColor:pinkTextColor];
    [backBtn addSubview:backText];*/
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UIButton *SaveBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 6, 44, 44)];
    [SaveBtn setTitle:@"完成" forState:UIControlStateNormal];
    [SaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SaveBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [SaveBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:SaveBtn];
   [self.navigationItem setRightBarButtonItem:rightButton];
}
- (void)leftBarButtonItemPressed:(id)sender {
    //需要调用super的实现
  [super leftBarButtonItemPressed:sender];
    
    //[self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarButtonItemPressed:(id)sender{

   [super rightBarButtonItemPressed:sender];
    if (_orcancal) {
        [self.navigationController popViewControllerAnimated:YES];
    }

}
@end
