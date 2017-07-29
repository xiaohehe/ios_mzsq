//
//  IMViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/6/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "IMViewController.h"
#import "UIImage+Helper.h"
@interface IMViewController ()

@end

@implementation IMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor greenColor]];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage ImageForColor:[UIColor greenColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    //self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [RCIM sharedRCIM].globalNavigationBarTintColor=[UIColor blackColor];
}

@end
