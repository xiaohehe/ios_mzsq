//
//  ShangjiaJinZhuViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/12/30.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ShangjiaJinZhuViewController.h"

@interface ShangjiaJinZhuViewController ()

@end

@implementation ShangjiaJinZhuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
    [self.view addSubview:self.activityVC];
//    [self.activityVC startAnimate];
    [self webView];
    [self reshData];
}

-(void)reshData{
}

-(void)reshWeb{
//    UIWebView *webview = (UIWebView *)[self.view viewWithTag:666];
}

-(void)webView{
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom )];
    webview.tag=666;
    [self.view addSubview:webview];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://fx.mzsq.cc/ruzhu.html"]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"www.baidu.com"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [webview loadRequest:request];
}

#pragma mark -----返回按钮
-(void)returnVi{
    self.TitleLabel.text=@"商家进驻";
    self.NavImg.userInteractionEnabled=YES;
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
//    UIButton *xiangqing = [UIButton buttonWithType:UIButtonTypeCustom];
//    [xiangqing setTitle:@"商家详情" forState:UIControlStateNormal];
//    xiangqing.titleLabel.font=DefaultFont(self.scale);
//    xiangqing.frame=CGRectMake(self.view.width-70*self.scale, self.TitleLabel.top, 60*self.scale, self.TitleLabel.height);
//    [xiangqing addTarget:self action:@selector(xiangqingBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.NavImg addSubview:xiangqing];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
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
