//
//  SigningViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SigningViewController.h"
#import "MBProgressHUD.h"
#import "AppUtil.h"
#import "FamilyViewController.h"

@interface SigningViewController ()<MBProgressHUDDelegate>
{
    UIWebView *webView;
    MBProgressHUD* hud;
    UIView *bottomView;
    UIButton *signingBtn;
    //LoadFailureView* errorView;
    //UIToolbar * bottomView ;
}
@end

@implementation SigningViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    self.url=@"http://www.mzsq.com";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,self.NavImg.bottom,self.view.width,self.view.height-self.NavImg.bottom-49-self.dangerAreaHeight)];
    webView.backgroundColor=[UIColor whiteColor];
    webView.delegate=self;
    [self.view addSubview: webView];
    [self bottomView];
    [self.view addSubview:self.activityVC];
}

-(void)bottomView{
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-49-self.dangerAreaHeight, self.view.width, 49+self.dangerAreaHeight)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview: bottomView];
    signingBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 0, self.view.width-20, 39)];
    signingBtn.backgroundColor=[UIColor colorWithRed:0.180 green:0.196 blue:0.267 alpha:1.00];
    signingBtn.layer.cornerRadius = 39/2;
    [signingBtn setTitle:@"立即签约" forState:UIControlStateNormal];
    [signingBtn setTitleColor:[UIColor colorWithRed:0.894 green:0.757 blue:0.459 alpha:1.00]forState:UIControlStateNormal];
    [signingBtn addTarget:self action:@selector(creatFamily) forControlEvents:UIControlEventTouchUpInside];    [bottomView addSubview:signingBtn];
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"拇指家庭";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    //    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    UIView *botline = [[UIView alloc]initWithFrame:CGRectMake(0, [self getStartHeight]+44-.5, self.view.width, .5)];
    botline.backgroundColor=blackLineColore;
    [self.NavImg addSubview:botline];
}

-(void)PopVC:(id)sender{
    if(_isToRoot){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) browser{
    // NSLog(@"browser");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"webview_url=%@",self.url);
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.scalesPageToFit = YES;
    webView.opaque=NO;
    [webView loadRequest:request];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    //开始加载网页调用此方法
    if(!hud){
        hud=[[MBProgressHUD alloc]initWithView:self.view];
        hud.delegate=self;
        [AppUtil showProgressDialog:hud withContent:@"正在加载"];
        [self.view addSubview:hud];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.isLoading) {
        return;
    }
    NSLog(@"webViewDidFinishLoad");
    //网页加载完成调用此方法
    if(![hud isHidden])
        [hud hide:YES];
//    if(webView.canGoBack)
//        ((UIImageView*)(((UIBarButtonItem*)bottomView.items[0]).customView)).highlighted=true;
//    else
//        ((UIImageView*)(((UIBarButtonItem*)bottomView.items[0]).customView)).highlighted=false;
//    if(webView.canGoForward){
//        ((UIImageView*)(((UIBarButtonItem*)bottomView.items[2]).customView)).highlighted=true;
//        NSLog(@"forward-selected");
//    }else{
//        ((UIImageView*)(((UIBarButtonItem*)bottomView.items[2]).customView)).highlighted=false;
//        NSLog(@"forward-normal");
//    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //网页加载失败 调用此方法
    if (webView.isLoading) {
        return;
    }
    NSLog(@"webViewDidFinishLoad");
    [self loadFailure];
}

-(void) loadFailure{
//    if(!errorView){
//        errorView=[[LoadFailureView alloc] initWithFrame:self.view.frame];
//    }
//    errorView.errorIv.image=[UIImage imageNamed:@"error_net.jpg"];
//    errorView.errorLb.text=@"网络错误";
//    errorView.reloadBtn.hidden=NO;
//    [errorView.reloadBtn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
//    [webView addSubview:errorView];
}

-(void) reloadData{
    //NSLog(@"reloaddata");
   // [errorView removeFromSuperview];
    [webView reload];
}
- (void)hudWasHidden:(MBProgressHUD *)h{
    NSLog(@"hudWasHidden");
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    //[hud release];
    hud = nil;
}

-(void)creatFamily{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle createFamilyWithDic:nil Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        NSLog(@"createFamily==%@",models);
        if ([code isEqualToString:@"0"]) {
            FamilyViewController* familyViewController=[[FamilyViewController alloc] init];
            familyViewController.isToRoot=YES;
            familyViewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:familyViewController animated:YES];
        }else{
            [self ShowAlertWithMessage:msg];
        }
    }];
}
@end
