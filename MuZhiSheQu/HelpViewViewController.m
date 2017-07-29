//
//  HelpViewViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "HelpViewViewController.h"

@interface HelpViewViewController ()
@property(nonatomic,strong)UIWebView *web;
@property(nonatomic,strong)NSMutableDictionary *data;
@end

@implementation HelpViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _data = [NSMutableDictionary new];
    [self newNav];
    [self newView];
    [self reshData];
    [self.view addSubview:self.activityVC];
    
}

-(void)reshData{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle helpInfoWithDic:@{@"terminal_type":@"1"} Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            //NSLog(@"helpinfo1111==%@",models[0]);
            _data=models[0];
            [self newView];
        }
        [self.activityVC stopAnimate];
    }];
}

-(void)newView{
    if (_web) {
        [_web removeFromSuperview];
    }
     _web = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    NSLog(@"help_content==%@",_data);
    [_web loadHTMLString:_data[@"content"] baseURL:nil];
    [self.view addSubview:_web];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}


#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"帮助";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
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
