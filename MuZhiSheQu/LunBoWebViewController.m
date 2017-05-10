

//
//  LunBoWebViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LunBoWebViewController.h"
#import "UmengCollection.h"
@interface LunBoWebViewController ()
@property(nonatomic,strong)UIWebView *web;
@end

@implementation LunBoWebViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self webVi];
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    if (_link.length>0) {
        [self webrsh:_link];
    }else{
        [self resData];
    }

    [self returnVi];
}

-(void)resData{
    NSDictionary *dic =@{@"slider_id":_lunboid};
    
    AnalyzeObject *anle =[AnalyzeObject new];

    [anle sliderDetailWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            [self web:models[@"detail"]];
        }
    }];
}


-(void)web:(NSString *)str{
    [self.activityVC stopAnimate];
    [_web loadHTMLString:str baseURL:nil];
}

-(void)webrsh:(NSString *)url{
    [self.activityVC stopAnimate];
    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_web loadRequest:requset];

}

-(void)webVi{
    _web = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    [self.view addSubview:_web];


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
