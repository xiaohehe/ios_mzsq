//
//  WoYaoKaiWiDianViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/12/30.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "WoYaoKaiWiDianViewController.h"
#import "UmengCollection.h"
@interface WoYaoKaiWiDianViewController ()

@end

@implementation WoYaoKaiWiDianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
    
    [self.view addSubview:self.activityVC];
//    [self.activityVC startAnimate];
    [self webView];
    [self reshData];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}


-(void)reshData{
    
    
    
    
    
}

-(void)reshWeb{
    UIWebView *webview = (UIWebView *)[self.view viewWithTag:666];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://fx.mzsq.cc/share/ruzhu.html"]];
    [webview loadRequest:request];
    
    
}


-(void)webView{
    
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom )];
    webview.tag=666;
    [self.view addSubview:webview];
    [self reshWeb];
    
    
}

#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"我要开网店";
    if (_dian) {
        self.TitleLabel.text=@"我要开店";
    }
    
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
