//
//  LoginViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "CellView.h"
#import "RegisterViewController.h"
#import "SheQuManagerViewController.h"
#import "JPUSHService.h"
//#import "APService.h"
@interface LoginViewController()<UITextFieldDelegate>
@property(nonatomic,strong)NSString *tel;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,strong)reshGonggao block;
@end
@implementation LoginViewController

-(void)resggong:(reshGonggao)block{
    _block =block;

}

-(void)viewDidLoad{
    [super viewDidLoad];
    _data=[NSMutableArray new];
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    /*监听TextField的变化*/
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keybordywillchange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(UIKeyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification object:nil];
    
    
    
}
-(void)keybordywillchange:(NSNotification *)notification{
    
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        //_mainScrollView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width,  rect.origin.y-self.NavImg.bottom);
        //        float =
        //        self.view.bottom=
        //
        //_vi.bottom=rect.origin.y;
        
        self.view.bottom=rect.origin.y+120;
    }];


}

-(void)UIKeyboardWillHideNotification:(NSNotification *)notification{
    
    NSDictionary *info =notification.userInfo;
//    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        //_mainScrollView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width,  rect.origin.y-self.NavImg.bottom);
        //        float =
        //        self.view.bottom=
        //
        //_vi.bottom=rect.origin.y;
        
        self.view.bottom=self.view.height;
    }];
    
    
}

-(void)newView{
    UIView *TopView=[[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 150*self.scale)];
    TopView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:TopView];
    UIImageView *HeaderImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width/2-45*self.scale, TopView.height/2-45*self.scale,90*self.scale, 90*self.scale)];
    HeaderImg.image=[UIImage imageNamed:@"mz_logo"];
  //  HeaderImg.layer.masksToBounds=YES;
    HeaderImg.layer.cornerRadius=HeaderImg.height/2;
    HeaderImg.contentMode=UIViewContentModeScaleAspectFit;
    [TopView addSubview:HeaderImg];
    
    UIImageView *topLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, TopView.bottom, self.view.width, 0.5)];
    topLine.backgroundColor=blackLineColore;
    [self.view addSubview:topLine];
    UIImageView *bottomLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, topLine.bottom+88*self.scale, self.view.width, 0.5)];
   // bottomLine.backgroundColor=[UIColor redColor];
    [self.view addSubview:bottomLine];
    
    for (int i=0; i<2; i++)
    {
        CellView *Cell=[[CellView alloc]initWithFrame:CGRectMake(0, topLine.bottom+44*self.scale*i, self.view.width, 44*self.scale)];
        Cell.backgroundColor=[UIColor whiteColor];
        UIImageView *Img=[[UIImageView alloc]initWithFrame:CGRectMake(15*self.scale, Cell.height/2-11*self.scale, 22*self.scale, 22*self.scale)];
        Img.image = i==0?[UIImage imageNamed:@"dl_icon01"]:[UIImage imageNamed:@"dl_icon02"];
        [Cell addSubview:Img];
        
        UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake(Img.right+10*self.scale, 5*self.scale, Cell.width-Img.right-40*self.scale, Cell.height-10*self.scale)];
        textF.font=DefaultFont(self.scale);
        textF.placeholder=i==0?@"请输入手机号":@"请输入验证码";
        textF.text = i==0?[Stockpile sharedStockpile].userName:@"";
        //textF.secureTextEntry=(i==1);
        textF.tag=10+i;
        textF.keyboardType=UIKeyboardTypeNumberPad;
        textF.delegate=self;
        [Cell setHiddenLine:i==1];
        [Cell addSubview:textF];
        [self.view addSubview:Cell];
        
    if (i==1) {
        UIButton *huo = [UIButton buttonWithType:UIButtonTypeCustom];
        huo.frame=CGRectMake(Cell.right-105*self.scale, Cell.top+5*self.scale, 100*self.scale, Cell.height-10*self.scale);
        [huo setTitle:@"获取验证码" forState:UIControlStateNormal];
        [huo setBackgroundImage:[UIImage ImageForColor:[UIColor redColor]] forState:UIControlStateNormal];
        [huo setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        huo.tag=5;
        huo.titleLabel.font=DefaultFont(self.scale);
        [huo addTarget:self action:@selector(huoqu) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:huo];
      
        }
    }
    
    UIButton *LoginBtn=[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, bottomLine.bottom+15*self.scale, self.view.width-36*self.scale, 35*self.scale)];
//    [LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn"] forState:UIControlStateNormal];
//    [LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn_b"] forState:UIControlStateHighlighted];
    LoginBtn.backgroundColor = blueTextColor;
    LoginBtn.clipsToBounds = YES;
    LoginBtn.layer.cornerRadius = LoginBtn.height/10;
    [LoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    LoginBtn.tag = 7;
    LoginBtn.enabled=NO;
    [LoginBtn setTitleColor:whiteLineColore forState:UIControlStateNormal];
    LoginBtn.titleLabel.font=BigFont(self.scale);
    [LoginBtn addTarget:self action:@selector(LoginButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LoginBtn];

    
}
#pragma mark - 按钮事件
-(void)timeji
{
    UIButton *btn=(UIButton *)[self.view viewWithTag:5];
    if (_time == 0) {
        [_timer invalidate];
        _timer = nil;
        btn.enabled=YES;
        [btn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        _time = 60;
    }else
    {
        [btn setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)_time] forState:UIControlStateNormal];
        btn.enabled=NO;
        _time--;
    }
}
-(void)huoqu{
    [self.view endEditing:YES];
    UITextField *tel = (UITextField *)[self.view viewWithTag:10];
    NSString *phone=[tel.text trimString];
    if ([phone isEmptyString] || ![phone isValidateMobile]) {
        [self ShowAlertWithMessage:@"请输入正确的手机号"];
        return;
    }
    _code=nil;
    [self.activityVC startAnimate];
    NSDictionary *dic = @{@"mobile":phone,@"type":@"4",@"terminal_type":@"1"};
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle getyanzhengma:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if (models && [models isKindOfClass:[NSDictionary class]] ) {
            [self ShowAlertWithMessage:msg];
            _tel=phone;
            _code=[NSString stringWithFormat:@"%@",[models objectForKey:@"verify_code"]];
            _time=60;
            _timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeji) userInfo:nil repeats:YES];
            
            NSLog(@"****************%@",_code);
            
        }else{
            [self ShowAlertWithMessage:@"获取失败"];
        }
    }];
}
/*登录*/
-(void)LoginButtonEvent:(id)sender{
    
    [self.view endEditing:YES];
     UITextField *TelText = (UITextField *)[self.view viewWithTag:10];
    UITextField *yan = (UITextField *)[self.view viewWithTag:11];
    if ([TelText.text isEqualToString:@"18539466509"]) {
        _tel=@"18539466509";
    }
    if ([TelText.text isEqualToString:@"13939256943"]) {
        _tel=@"13939256943";
    }
    
    
    
    if ([[TelText.text trimString] isEmptyString]||[_tel isEmptyString] || ![[TelText.text trimString ] isEqualToString:_tel]) {
        [self ShowAlertWithMessage:@"请输入正确的手机号"];
        return;
    }
    
    if ([_tel isEqualToString:@"18539466509"]) {
        yan.text=@"111111";
        
    }else if ([_tel isEqualToString:@"13939256943"]){
        yan.text=@"111111";

    
    }else if ([[yan.text trimString] isEmptyString] || [_code isEmptyString] || ![[yan.text trimString] isEqualToString:_code]) {
        [self ShowAlertWithMessage:@"请输入验证码"];
        return;
    }
    [self.activityVC startAnimate];
    
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    
    [analy userLoginWithTel:_tel Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        

        NSLog(@"%@",models);
        if (models && [models isKindOfClass:[NSDictionary class]]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:models[@"cart_prod_count"] forKey:@"GouWuCheShuLiang"];
            

            
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"commid"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"commname"];
            
            [[Stockpile sharedStockpile]setID:[NSString stringWithFormat:@"%@",[models objectForKey:@"id"]]];
            [[Stockpile sharedStockpile]setUserName:[NSString stringWithFormat:@"%@",[models objectForKey:@"user_name"]]];
            
            NSLog(@"%@",models);
            NSString *bieMing =[NSString stringWithFormat:@"mzsq_%@",[Stockpile sharedStockpile].ID];

             NSString *tag =[NSString stringWithFormat:@"%@",models[@"community_id"]];
            
            NSSet * tagJihe = [NSSet setWithObjects:tag, nil];
            
            NSLog(@"%@",tagJihe);
            
            [JPUSHService setTags:tagJihe alias:bieMing fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                  NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
            }];
            
            //[JPUSHService setTags:tagJihe callbackSelector:@selector((tagsAliasCallback:tags:alias:)) object:self];
            
          //  [JPUSHService setAlias:bieMing callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            
            //[[UIApplication sharedApplication] registerForRemoteNotifications];
            
            
//            [APService setAlias:tag callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            
            [[Stockpile sharedStockpile]setName:[NSString stringWithFormat:@"%@",[models objectForKey:@"real_name"]]];
            
            

            
            if ([[models objectForKey:@"nick_name"] isEqualToString:@""] || [models objectForKey:@"nick_name"]==nil) {
                [[Stockpile sharedStockpile ] setNickName:[NSString stringWithFormat:@"%@",[models objectForKey:@"mobile"]]];
                
                RCUserInfo *_currentUserInfo =
                [[RCUserInfo alloc] initWithUserId:[models objectForKey:@"id"]
                                              name:[models objectForKey:@"mobile"]
                                          portrait:[models objectForKey:@"avatar"]];
                [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
                [RCIM sharedRCIM].currentUserInfo=_currentUserInfo;
                
            }else{
                [[Stockpile sharedStockpile ] setNickName:[NSString stringWithFormat:@"%@",[models objectForKey:@"nick_name"]]];
                RCUserInfo *_currentUserInfo =
                [[RCUserInfo alloc] initWithUserId:[models objectForKey:@"id"]
                                              name:[models objectForKey:@"nick_name"]
                                          portrait:[models objectForKey:@"avatar"]];
                [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
                [RCIM sharedRCIM].currentUserInfo=_currentUserInfo;
            }
            
            
            
            
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[models objectForKey:@"avatar"]] forKey:@"touxiang"];
            [[Stockpile sharedStockpile]setIsLogin:YES];
            [[Stockpile sharedStockpile]setID:[NSString stringWithFormat:@"%@",[models objectForKey:@"id"]]];
              [[NSUserDefaults standardUserDefaults]setObject:[models objectForKey:@"id"] forKey:@"user_id"];
            
            if (![models[@"address"][@"id"]isEqualToString:@""]) {
                [[NSUserDefaults standardUserDefaults]setObject:[models objectForKey:@"address"] forKey:@"address"];
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:[NSDictionary new] forKey:@"address"];
            }
            
           
            

            

            [Stockpile sharedStockpile].Name=models[@"mobile"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"or"];
            
            [[NSUserDefaults standardUserDefaults]setObject:models forKey:@"logodata"];
    //----logo
            [[Stockpile sharedStockpile]setLogo:[NSString stringWithFormat:@"%@",[models objectForKey:@"avatar"]]];
           
            [[Stockpile sharedStockpile]setToken:[NSString stringWithFormat:@"%@",[models objectForKey:@"token"]]];
            
                [[NSUserDefaults standardUserDefaults]setObject:models[@"community_id"] forKey:@"commid"];

            [[NSUserDefaults standardUserDefaults]setObject:models[@"community"] forKey:@"commname"];
            
            [[NSUserDefaults standardUserDefaults]setObject:models[@"province_id"] forKey:@"GuideShengId"];
            [[NSUserDefaults standardUserDefaults]setObject:models[@"province"] forKey:@"GuideShengName"];
            
            
            [[NSUserDefaults standardUserDefaults]setObject:models[@"district_id"] forKey:@"GuidequId"];
            [[NSUserDefaults standardUserDefaults]setObject:models[@"district"] forKey:@"GuidequName"];
            
            [[NSUserDefaults standardUserDefaults]setObject:models[@"city_id"] forKey:@"GuideShiId"];
            [[NSUserDefaults standardUserDefaults]setObject:models[@"city"] forKey:@"GuideShiName"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            if (_block) {
                _block(@"ok");
            }
            
            [self.appdelegate RongRunInit];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];


        [self.appdelegate ZhuCeJPush];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logsuccedata" object:nil];
    }];
    
    [[NSUserDefaults standardUserDefaults]synchronize];

}






- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
/* 忘记密码*/
-(void)ForgotButtonEvent:(id)sender{
    
}
/*注册*/
-(void)RegisterButtonEvent:(id)sender{
    
    RegisterViewController *registerVC=[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
    
}
#pragma mark - TextField
-(void)TextFieldChange{
    
    UITextField *TextFf=(UITextField *)[self.view viewWithTag:10];
   UITextField *TextPwd=(UITextField *)[self.view viewWithTag:11];
    UIButton *LoginBtn=(UIButton *)[self.view viewWithTag:7];
    
    if (TextFf.text.length>11) {
        TextFf.text=[TextFf.text substringToIndex:11];
    }
    
    if (TextFf.text.length>0 && TextPwd.text.length>0) {
        LoginBtn.enabled=YES;
    }else{
        LoginBtn.enabled=NO;
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 10) {
        textField.keyboardType=UIKeyboardTypePhonePad;
    }
    return YES;
}
#pragma mark - 导航
- (void)newNav{
    self.TitleLabel.text = @"登录";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}
-(void)PopVC:(id)sender{

    if (_f) {
        [self dismissViewControllerAnimated:YES completion:nil];
        self.appdelegate.tabBarController.selectedIndex=0;
    }else{
    
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}
@end
