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
    self.view.backgroundColor=[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    //self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [RCIM sharedRCIM].globalNavigationBarTintColor=[UIColor blackColor];
}

/*!
 即将显示消息Cell的回调
 
 @param cell        消息Cell
 @param indexPath   该Cell对应的消息Cell数据模型在数据源中的索引值
 
 @discussion 您可以在此回调中修改Cell的显示和某些属性。
 */
//- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell
//                   atIndexPath:(NSIndexPath *)indexPath{
//      cell.baseContentView.backgroundColor=[UIColor redColor];
//}

@end
