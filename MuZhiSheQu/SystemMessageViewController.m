//
//  SystemMessageViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2018/1/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SystemMessageViewController.h"

@interface SystemMessageViewController ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) NSMutableArray* dataArray;
@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNav];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)newNav{
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    self.TitleLabel.text=@"系统消息";
    self.TitleLabel.font =[UIFont systemFontOfSize:15*self.scale];
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.height-.5, self.view.width, .5)];
    bottomLine.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [self.NavImg addSubview:bottomLine];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
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
