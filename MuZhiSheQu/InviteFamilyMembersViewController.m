//
//  InviteFamilyMembersViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "InviteFamilyMembersViewController.h"

@interface InviteFamilyMembersViewController ()
@property(nonatomic,strong)UIView *phoneBgView;
@property(nonatomic,strong)UITextField *phoneTf;
@property(nonatomic,strong)UIButton *inviteBtn;
@end

@implementation InviteFamilyMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self newNav];
    [self newView];
    /*监听TextField的变化*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"邀请家庭成员";
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) newView{
    _phoneBgView=[[UIView alloc]initWithFrame:CGRectMake(10, self.NavImg.bottom+15*self.scale, self.view.width-20, 40*self.scale)];
    _phoneBgView.layer.borderWidth = 1;
    _phoneBgView.layer.borderColor = [[UIColor colorWithRed:0.773 green:0.773 blue:0.773 alpha:1.00] CGColor];
    [self.view addSubview:_phoneBgView];
    
    _phoneTf=[[UITextField alloc]initWithFrame:CGRectMake(10, 10*self.scale, _phoneBgView.width-20, 20*self.scale)];
    _phoneTf.placeholder=@"填写手机号码";
    _phoneTf.keyboardType=UIKeyboardTypeNumberPad;
    _phoneTf.delegate=self;
    [_phoneBgView addSubview:_phoneTf];
    
    _inviteBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2-150*self.scale/2, _phoneBgView.bottom+15*self.scale, 150*self.scale, 40*self.scale)];
    [_inviteBtn setBackgroundImage:[UIImage imageNamed:@"bg_order_big"] forState:UIControlStateNormal];
    [_inviteBtn setTitle:@"邀请" forState:UIControlStateNormal];
    [_inviteBtn setTitleColor:[UIColor colorWithRed:0.224 green:0.220 blue:0.196 alpha:1.00] forState:UIControlStateNormal];
    [_inviteBtn addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
    _inviteBtn.enabled=NO;
    [self.view addSubview:_inviteBtn];
}

#pragma mark - TextField
-(void)TextFieldChange{
    if (_phoneTf.text.length>11) {
        _phoneTf.text=[_phoneTf.text substringToIndex:11];
    }
    if (_phoneTf.text.length==11) {
        _inviteBtn.enabled=YES;
    }else{
        _inviteBtn.enabled=NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)invite{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"fid":self.fid,@"mobile":_phoneTf.text};
    [anle addFamilyWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"addFamilyWithDic==%@",models);
            [_delegate passValue:[[NSArray alloc] initWithObjects:@"refresh",nil]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self ShowAlertWithMessage:msg];
        }
    }];
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
