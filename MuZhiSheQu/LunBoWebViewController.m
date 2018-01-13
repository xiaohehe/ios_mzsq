

//
//  LunBoWebViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LunBoWebViewController.h"
#import "UmengCollection.h"
#import "MBProgressHUD.h"
#import "AppUtil.h"

@interface LunBoWebViewController ()<MBProgressHUDDelegate>
{
    UIWebView *webView;
    MBProgressHUD* hud;
    LoadFailureView* errorView;
    UIToolbar * bottomView ;
}
@end

@implementation LunBoWebViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self returnVi];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,self.NavImg.bottom,self.view.frame.size.width,self.view.frame.size.height-self.NavImg.bottom-self.dangerAreaHeight-40)];
    webView.backgroundColor=[UIColor whiteColor];
    webView.delegate=self;
    bottomView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-104, [UIScreen mainScreen].bounds.size.width, 40)];
    [bottomView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收起" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [bottomView setItems:[self setBottomTools]];
    [self.view addSubview:bottomView];
    [self.view addSubview: webView];
}

-(NSArray*) setBottomTools{
    NSMutableArray* array=[NSMutableArray array];
    NSArray* arrImgs=@[@"previous.png",@"forward.png",@"refresh.png",@"browser.png"];
    UITapGestureRecognizer*previousTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(previous)];
    UITapGestureRecognizer*forwardTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forward)];
    UITapGestureRecognizer*refreshTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refresh)];
    UITapGestureRecognizer*browserTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browser)];
    NSArray* arrActions=[NSArray arrayWithObjects:previousTap,forwardTap,refreshTap,browserTap,nil];
    for(int i=0;i<arrImgs.count;i++){
        UIImageView* iv=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,25,25)];
        UIImage* img=[UIImage imageNamed:arrImgs[i]];
        [iv setImage:img];
        if(i==0)
            [iv setHighlightedImage:[UIImage imageNamed:@"previous_selected.png"]];
        else if(i==1)
            [iv setHighlightedImage:[UIImage imageNamed:@"forward_selected.png"]];
        iv.userInteractionEnabled=true;
        [iv addGestureRecognizer:arrActions[i]];
        UIBarButtonItem* btn=[[UIBarButtonItem alloc] initWithCustomView:iv];
        [array addObject:btn];
        if(i!=arrImgs.count-1){
            UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            [array addObject:btnSpace];
        }
    }
    return [array copy];
}

-(void) previous{
    // NSLog(@"previous");
    if(webView.canGoBack){
        [webView goBack];
        if(errorView)
            [errorView removeFromSuperview];
    }
}
-(void) forward{
    //  NSLog(@"forward");
    if(webView.canGoForward){
        [webView goForward];
        if(errorView)
            [errorView removeFromSuperview];
    }
}
-(void) refresh{
    //  NSLog(@"refresh");
    [webView reload];
    if(errorView)
        [errorView removeFromSuperview];
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
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBarHidden = NO;
    //self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:253.0/255.0 green:98.0/255.0 blue:11.0/255.0 alpha:1];
    if(self.navigationController.navigationBar.hidden)
        self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    NSLog(@"webview_url=%@",self.url);
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.scalesPageToFit = YES;
    webView.opaque=NO;
    [webView loadRequest:request];
    [UmengCollection intoPage:NSStringFromClass([self class])];
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
    if(webView.canGoBack)
        ((UIImageView*)(((UIBarButtonItem*)bottomView.items[0]).customView)).highlighted=true;
    else
        ((UIImageView*)(((UIBarButtonItem*)bottomView.items[0]).customView)).highlighted=false;
    if(webView.canGoForward){
        ((UIImageView*)(((UIBarButtonItem*)bottomView.items[2]).customView)).highlighted=true;
        NSLog(@"forward-selected");
    }else{
        ((UIImageView*)(((UIBarButtonItem*)bottomView.items[2]).customView)).highlighted=false;
        NSLog(@"forward-normal");
    }
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
    if(!errorView){
        errorView=[[LoadFailureView alloc] initWithFrame:self.view.frame];
    }
    errorView.errorIv.image=[UIImage imageNamed:@"error_net.jpg"];
    errorView.errorLb.text=@"网络错误";
    errorView.reloadBtn.hidden=NO;
    [errorView.reloadBtn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    [webView addSubview:errorView];
}

-(void) reloadData{
    //NSLog(@"reloaddata");
    [errorView removeFromSuperview];
    [webView reload];
}
- (void)hudWasHidden:(MBProgressHUD *)h{
    NSLog(@"hudWasHidden");
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    //[hud release];
    hud = nil;
}
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"详情";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
