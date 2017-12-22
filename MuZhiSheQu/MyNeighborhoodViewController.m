//
//  MyNeighborhoodViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyNeighborhoodViewController.h"
#import "MyReleaseViewController.h"
#import "MyWriteBackViewController.h"

@interface MyNeighborhoodViewController ()
@property (nonatomic, strong) NSMutableArray *allVC;
@property (nonatomic, strong) SMPagerTabView *segmentView;
@end

@implementation MyNeighborhoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _allVC = [NSMutableArray array];
    //NSLog(@"type==%ld",_type);
    [self listView];
    [self newNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 导航
-(void)newNav{
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, [self getStartHeight]+2, 40, 40)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
    
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, [self getStartHeight]+44-.5, self.view.width, .5)];
    topline.backgroundColor=blackLineColore;
    [self.view addSubview:topline];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) listView{
    MyReleaseViewController* myReleaseController=[[MyReleaseViewController alloc] init];
    myReleaseController.title = @"我的帖子";
    myReleaseController.navigationController=self.navigationController;
    [_allVC addObject:myReleaseController];

    MyWriteBackViewController* myWriteBackController=[[MyWriteBackViewController alloc] init];
    myWriteBackController.title = @"我的回复";
    myWriteBackController.navigationController=self.navigationController;
    [_allVC addObject:myWriteBackController];
    self.segmentView.delegate = self;
    //可自定义背景色和tab button的文字颜色等
    //开始构建UI
    [_segmentView buildUI];
    //起始选择一个tab
    [_segmentView selectTabWithIndex:_type animate:NO];
}

#pragma mark - DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    return [_allVC count];
}
- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    return _allVC[number];
}

- (void)whenSelectOnPager:(NSUInteger)number {
    NSLog(@"页面 %lu",(unsigned long)number);
}

- (SMPagerTabView *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[SMPagerTabView alloc]initWithFrame:CGRectMake(0, [self getStartHeight]+4, self.view.width, self.view.height-([self getStartHeight]+4))];
        [self.view addSubview:_segmentView];
    }
    return _segmentView;
}

@end
