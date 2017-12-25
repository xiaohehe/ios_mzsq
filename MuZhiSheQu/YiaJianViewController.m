
//
//  YiaJianViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/28.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "YiaJianViewController.h"

@interface YiaJianViewController ()<UITextViewDelegate>

@end

@implementation YiaJianViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNav];

    UITextView *tf = [[UITextView alloc]initWithFrame:CGRectMake(10*self.scale, self.NavImg.bottom+10*self.scale, self.view.width-20*self.scale, 100*self.scale) ];
    tf.tag=666;
    tf.delegate=self;
    tf.font=DefaultFont(self.scale);
    [self.view addSubview:tf];

    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(20*self.scale, self.NavImg.bottom+10*self.scale, self.view.width-20*self.scale, 35*self.scale)];
    la.text=@"请输入您宝贵的意见";
    la.font=DefaultFont(self.scale);
    la.textColor=grayTextColor;
    la.tag=123;
    [self.view addSubview:la];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, tf.bottom+20*self.scale, self.view.width-20*self.scale, 35*self.scale)];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage ImageForColor:[UIColor colorWithRed:1.000 green:0.867 blue:0.306 alpha:1.00]] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tijaio) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius=4;
    btn.layer.masksToBounds=YES;
    [self.view addSubview:btn];


}

-(void)tijaio{
    
    
    if ([Stockpile sharedStockpile].isLogin==NO) {
        
        [self ShowAlertWithMessage:@"请登录"];
        return;
    }
    
    
    UITextView *la = (UITextView *)[self.view viewWithTag:666];
    if ([la.text isEqualToString:@""]) {
        [self ShowAlertWithMessage:@"不能输入空字符"];
        return;
    }
    [self.view endEditing:YES];
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    


    AnalyzeObject *anle =[AnalyzeObject new];
    NSDictionary *dic =@{@"user_id":[self getuserid],@"content":la.text,@"terminal_type":@"1"};
    
    
    [anle feedbackWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            [self ShowAlertWithMessage:msg];

                [self.navigationController popViewControllerAnimated:YES];

        }
        [self.activityVC stopAnimate];
    }];


}

- (void)textViewDidChange:(UITextView *)textView{

    UILabel *la = (UILabel *)[self.view viewWithTag:123];
    la.text = @"";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"意见反馈";
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
