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
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    
}
-(void)newView{
    
    UIImageView *topLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+15*self.scale, self.view.width, 0.5)];
    topLine.backgroundColor=blackLineColore;
    [self.view addSubview:topLine];
    CellView *Cell=[[CellView alloc]initWithFrame:CGRectMake(0, topLine.bottom, self.view.width, 44*self.scale)];
    Cell.backgroundColor=[UIColor whiteColor];
    Cell.titleLabel.text=@"昵称：";
    Cell.titleLabel.font=DefaultFont(self.scale);
        // Cell.titleLabel.size=CGSizeMake(50*self.scale, Cell.titleLabel.height);
    [Cell.titleLabel sizeToFit];
    Cell.titleLabel.height=20*self.scale;
    
    UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake( Cell.titleLabel.right+10*self.scale, 5*self.scale, Cell.width- Cell.titleLabel.right-40*self.scale, Cell.height-10*self.scale)];
    textF.font=DefaultFont(self.scale);
    textF.placeholder=@"输入昵称";
    textF.text=[Stockpile sharedStockpile].nickName;
    textF.tag=10;
    [Cell addSubview:textF];
    [self.view addSubview:Cell];
    
    UILabel *tishi=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, Cell.bottom+5*self.scale, self.view.width-10*self.scale, 15*self.scale)];
    tishi.text=@"好的名字可以让好友更好的记住你";
    tishi.backgroundColor=[UIColor clearColor];
    tishi.textColor=grayTextColor;
    tishi.font=SmallFont(self.scale);
    [self.view addSubview:tishi];
  
    
    /*UIButton *LoginBtn=[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, bottomLine.bottom+15*self.scale, self.view.width-36*self.scale, 35*self.scale)];
     [LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"center_btn"] forState:UIControlStateNormal];
     [LoginBtn setTitle:@"修改" forState:UIControlStateNormal];
     [LoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     LoginBtn.titleLabel.font=BigFont(self.scale);
     [LoginBtn addTarget:self action:@selector(NextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:LoginBtn];*/
}
-(void)NextButtonEvent:(id)sender{
    [self.view endEditing:YES];
    UITextField *YPwdText=(UITextField *)[self.view viewWithTag:10];
    NSString *ypwd=[YPwdText.text trimString];

    if (ypwd.length>30) {
        [self ShowAlertWithMessage:@"昵称应小于30个字符"];
        return;
    }
    if (ypwd.length<=0) {
        [self ShowAlertWithMessage:@"不能输入空字符"];
        return;
    }
    
    [self.activityVC startAnimate];
         AnalyzeObject *anle = [AnalyzeObject new];
//    1、user_id(用户 id) 2、nickname(昵称)
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    NSDictionary *dic = @{@"user_id":self.user_id,@"nickname":ypwd};
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
    self.TitleLabel.text=@"修改昵称";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton *SaveButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [SaveButton setTitle:@"保存" forState:UIControlStateNormal];
    SaveButton.titleLabel.font=DefaultFont(self.scale);
    [SaveButton addTarget:self action:@selector(NextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:SaveButton];
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
