//
//  NickNameViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NickNameViewController.h"
#import "CellView.h"
#import "UmengCollection.h"
@interface NickNameViewController ()
@property(nonatomic,strong) UIButton *saveBtn;
@end

@implementation NickNameViewController
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
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    
}
-(void)newView{
    CellView *Cell=[[CellView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+15*self.scale, self.view.width, 44*self.scale)];
    Cell.backgroundColor=[UIColor whiteColor];
    Cell.titleLabel.text=@"昵称";
    Cell.titleLabel.font=DefaultFont(self.scale);
     Cell.titleLabel.textColor=[UIColor colorWithRed:0.302 green:0.302 blue:0.302 alpha:1.00];
    [Cell.titleLabel sizeToFit];
    Cell.titleLabel.height=20*self.scale;
    UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake( Cell.titleLabel.right+10*self.scale, 5*self.scale, Cell.width- Cell.titleLabel.right-40*self.scale, Cell.height-10*self.scale)];
    textF.font=DefaultFont(self.scale);
    textF.placeholder=@"请输入2-10个字";
    textF.text=[Stockpile sharedStockpile].nickName;
    textF.tag=10;
    [Cell addSubview:textF];
    Cell.topline.hidden=YES;
    Cell.bottomline.hidden=YES;
    [self.view addSubview:Cell];
    _saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, Cell.bottom+30*self.scale, self.view.width-20*self.scale, (self.view.width-20*self.scale)/702*90)];
    [_saveBtn setImage:[UIImage imageNamed:@"save_btn"] forState:UIControlStateNormal];
    [_saveBtn setImage:[UIImage imageNamed:@"save_btn1"] forState:UIControlStateHighlighted];
    [_saveBtn addTarget:self action:@selector(NextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
    
//    _saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, Cell.bottom+30*self.scale, self.view.width-20*self.scale, (self.view.width-20*self.scale)/702*90)];
//    [_saveBtn setImage:[UIImage imageNamed:@"save_btn"] forState:UIControlStateNormal];
//    [_saveBtn setImage:[UIImage imageNamed:@"save_btn1"] forState:UIControlStateHighlighted];
//    [_saveBtn addTarget:self action:@selector(NextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_saveBtn];
}
-(void)NextButtonEvent:(id)sender{
    [self.view endEditing:YES];
    UITextField *YPwdText=(UITextField *)[self.view viewWithTag:10];
    NSString *ypwd=[YPwdText.text trimString];
    if (ypwd.length<=0) {
        [self ShowAlertWithMessage:@"不能输入空字符"];
        return;
    }
    if (ypwd.length>10||ypwd.length<2) {
        [self ShowAlertWithMessage:@"昵称应为2-10个字"];
        return;
    }
    [self.activityVC startAnimate];
         AnalyzeObject *anle = [AnalyzeObject new];
//    1、user_id(用户 id) 2、nickname(昵称)
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dic = @{@"userid":self.user_id,@"nickname":ypwd};
    [anle modifyNicknameWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
            [Stockpile sharedStockpile].nickName=ypwd;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"nicheng" object:ypwd];
            NSLog(@"%@",[Stockpile sharedStockpile].logo);
            RCUserInfo *_currentUserInfo =
            [[RCUserInfo alloc] initWithUserId:self.user_id
                                          name:ypwd
                                      portrait:[Stockpile sharedStockpile].logo];
            [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
            [RCIM sharedRCIM].currentUserInfo=_currentUserInfo;  
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"设置昵称";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-(self.TitleLabel.height/2-5)-10, self.TitleLabel.top+(self.TitleLabel.height/4)+2.5, self.TitleLabel.height/2-5, self.TitleLabel.height/2-5)];
    [popBtn setImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
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
