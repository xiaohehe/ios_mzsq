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
#import "DataBase.h"

@interface LoginViewController()<UITextFieldDelegate>
@property(nonatomic,strong)NSString *tel;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,strong)reshGonggao block;
@property(nonatomic,strong)UIButton *rightBtn;//右按钮
@property(nonatomic,strong)UIImageView *logoIv;//login
@end
@implementation LoginViewController

-(void)resggong:(reshGonggao)block{
    _block =block;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
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
    }];
}

-(void)UIKeyboardWillHideNotification:(NSNotification *)notification{
    NSDictionary *info =notification.userInfo;
//    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.bottom=self.view.height;
    }];
}

-(void)newView{
    _logoIv=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width/2-40*self.scale, self.NavImg.bottom+40*self.scale, 80*self.scale, 80*self.scale)];
    [_logoIv setImage:[UIImage imageNamed:@"icon_login"]];
    [self.view addSubview:_logoIv];
    CGFloat bottom=_logoIv.bottom;
    for (int i=0; i<2; i++){
        CellView *Cell=[[CellView alloc]initWithFrame:CGRectMake(0, _logoIv.bottom+0.5+44*self.scale*(i+1), self.view.width, 44*self.scale)];
        //        Cell.backgroundColor=[UIColor whiteColor];
        //        UIImageView *Img=[[UIImageView alloc]initWithFrame:CGRectMake(15*self.scale, Cell.height/2-11*self.scale, 22*self.scale, 22*self.scale)];
        //        Img.image = i==0?[UIImage imageNamed:@"dl_icon01"]:[UIImage imageNamed:@"dl_icon02"];
        //[Cell addSubview:Img];
        Cell.titleLabel.hidden=YES;
        UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, Cell.width-80*self.scale, Cell.height-10*self.scale)];
        textF.font=DefaultFont(self.scale);
        textF.placeholder=i==0?@"请输入手机号":@"请输入验证码";
        textF.text = i==0?[Stockpile sharedStockpile].userName:@"";
        textF.tag=10+i;
        textF.keyboardType=UIKeyboardTypeNumberPad;
        textF.delegate=self;
        [Cell addSubview:textF];
        [self.view addSubview:Cell];
        Cell.bottomline.hidden=YES;
        UIImageView* bottomline=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, Cell.height-0.5, self.view.width-20*self.scale, 0.5)];
        bottomline.backgroundColor=blackLineColore;
        [Cell addSubview:bottomline];

        if (i==0) {
            UIView* halvingLine=[[UIImageView alloc]initWithFrame:CGRectMake(Cell.right-130*self.scale, Cell.top+12*self.scale, .5, Cell.height-24*self.scale)];
            halvingLine.backgroundColor=blackLineColore;
            [self.view addSubview:halvingLine];
            
            UIButton *huo = [UIButton buttonWithType:UIButtonTypeCustom];
            huo.frame=CGRectMake(halvingLine.right, Cell.top+10*self.scale, 120*self.scale, Cell.height-20*self.scale);
            [huo setTitle:@"获取验证码" forState:UIControlStateNormal];
            [huo setTitleColor:[UIColor colorWithRed:0.278 green:0.278 blue:0.278 alpha:1.00] forState:UIControlStateNormal];
            huo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            huo.clipsToBounds = YES;
            huo.layer.cornerRadius = huo.height/10;
            huo.tag=5;
            huo.titleLabel.font=DefaultFont(self.scale);
            [huo addTarget:self action:@selector(huoqu) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:huo];
        }
        bottom=Cell.bottom;
    }
    UIButton *LoginBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, bottom+20*self.scale, self.view.width-20*self.scale, (self.view.width-20*self.scale)/71*12)];
    [LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"login_btn"] forState:UIControlStateNormal];
    [LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"login_btn2"] forState:UIControlStateHighlighted];
    LoginBtn.tag = 7;
    LoginBtn.enabled=NO;
    [LoginBtn addTarget:self action:@selector(LoginButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LoginBtn];
}

#pragma mark - 按钮事件
-(void)timeji{
    UIButton *btn=(UIButton *)[self.view viewWithTag:5];
    if (_time == 0) {
        [_timer invalidate];
        _timer = nil;
        btn.enabled=YES;
        [btn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        _time = 60;
    }else{
        [btn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)_time] forState:UIControlStateNormal];
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
    [self.activityVC startAnimate];//,@"terminal_type":@"1"
    NSDictionary *dic = @{@"mobile":phone,@"type":@"4"};
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle getyanzhengma:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if (models && [models isKindOfClass:[NSDictionary class]] ) {
            [self ShowAlertWithMessage:msg];
            _tel=phone;
            _code=[NSString stringWithFormat:@"%@",[models objectForKey:@"verify_code"]];
            NSLog(@"code==%@",_code);
            _time=60;
            _timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeji) userInfo:nil repeats:YES];
        }else{
            [self ShowAlertWithMessage:@"获取失败"];
        }
    }];
}

/*登录
 */
-(void)LoginButtonEvent:(id)sender{
    [self.view endEditing:YES];
    UITextField *TelText = (UITextField *)[self.view viewWithTag:10];
    UITextField *yan = (UITextField *)[self.view viewWithTag:11];
    if ([[TelText.text trimString] isEmptyString]||[_tel isEmptyString] ) {//|| ![[TelText.text trimString ] isEqualToString:_tel]
        [self ShowAlertWithMessage:@"请输入正确的手机号"];
        return;
    }
    if ([[yan.text trimString] isEmptyString] || [_code isEmptyString] ) {//|| ![[yan.text trimString] isEqualToString:_code]
        [self ShowAlertWithMessage:@"请输入验证码"];
        return;
    }
    [self.activityVC startAnimate];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    NSString *commid =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"commid"]];
    
    NSDictionary* param=[NSDictionary dictionaryWithObjectsAndKeys:TelText.text,@"mobile",yan.text,@"code",commid,@"comid", nil];//,@"4",@"type"
    [analy userLogin:param Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        NSLog(@"login====%@",models);
        if (models && [models isKindOfClass:[NSDictionary class]]) {
            NSInteger count= [[DataBase sharedDataBase] sumCartNum];
            //[[NSUserDefaults standardUserDefaults] setObject:models[@"cart_prod_count"] forKey:@"GouWuCheShuLiang"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:count] forKey:@"GouWuCheShuLiang"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"commid"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"commname"];
            [[Stockpile sharedStockpile]setID:[NSString stringWithFormat:@"%@",[models[@"userInfo"] objectForKey:@"id"]]];
            [[Stockpile sharedStockpile]setUserName:[NSString stringWithFormat:@"%@",[models[@"userInfo"] objectForKey:@"userName"]]];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage" object:nil];
            //NSLog(@"%@",models);
            NSString *bieMing =[NSString stringWithFormat:@"mzsq_%@",[Stockpile sharedStockpile].ID];
            NSString *tag =[NSString stringWithFormat:@"%@",models[@"userCommunity"][@"ID"]];
            NSSet * tagJihe = [NSSet setWithObjects:tag, nil];
            //NSLog(@"%@",tagJihe);
            [JPUSHService setTags:tagJihe alias:bieMing fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                  NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
            }];
            [[Stockpile sharedStockpile]setName:[NSString stringWithFormat:@"%@",[models[@"userInfo"] objectForKey:@"realName"]]];
            if ([[models[@"userInfo"] objectForKey:@"nickName"] isEqualToString:@""] || [models[@"userInfo"] objectForKey:@"nickName"]==nil) {
                [[Stockpile sharedStockpile ] setNickName:[NSString stringWithFormat:@"%@",[models[@"userInfo"] objectForKey:@"mobile"]]];
                RCUserInfo *_currentUserInfo =
                [[RCUserInfo alloc] initWithUserId:[models[@"userInfo"] objectForKey:@"id"]
                                              name:[models[@"userInfo"] objectForKey:@"mobile"]
                                          portrait:[models[@"userInfo"] objectForKey:@"userAvatar"]];
                [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
                [RCIM sharedRCIM].currentUserInfo=_currentUserInfo;
            }else{
                [[Stockpile sharedStockpile ] setNickName:[NSString stringWithFormat:@"%@",[models[@"userInfo"] objectForKey:@"nickName"]]];
                RCUserInfo *_currentUserInfo =
                [[RCUserInfo alloc] initWithUserId:[models[@"userInfo"] objectForKey:@"id"]
                                              name:[models[@"userInfo"] objectForKey:@"nickName"]
                                          portrait:[models[@"userInfo"] objectForKey:@"userAvatar"]];
                [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
                [RCIM sharedRCIM].currentUserInfo=_currentUserInfo;
            }
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[models[@"userInfo"] objectForKey:@"userAvatar"]] forKey:@"touxiang"];
            [[Stockpile sharedStockpile]setIsLogin:YES];
            [[Stockpile sharedStockpile]setID:[NSString stringWithFormat:@"%@",[models[@"userInfo"] objectForKey:@"id"]]];
            [[Stockpile sharedStockpile] setUsertoken:[models[@"userInfo"] objectForKey:@"userToken"]];
              [[NSUserDefaults standardUserDefaults]setObject:[models[@"userInfo"] objectForKey:@"id"] forKey:@"user_id"];
            if (![models[@"userAddress"][@"id"]isEqualToString:@""]) {
                [[NSUserDefaults standardUserDefaults]setObject:[models objectForKey:@"userAddress"] forKey:@"address"];
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:[NSDictionary new] forKey:@"address"];
            }
            [Stockpile sharedStockpile].Name=models[@"userInfo"][@"mobile"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"or"];
            
            [[Stockpile sharedStockpile]setSex:[NSString stringWithFormat:@"%@",[models[@"userInfo"] objectForKey:@"userSex"]]];
            [[Stockpile sharedStockpile]setBirthday:[NSString stringWithFormat:@"%@",[models[@"userInfo"] objectForKey:@"userBirthday"]]];
            //[[NSUserDefaults standardUserDefaults]setObject:models forKey:@"logodata"];
            [[Stockpile sharedStockpile]setLogo:[NSString stringWithFormat:@"%@",[models[@"userInfo"] objectForKey:@"userAvatar"]]];
            [[Stockpile sharedStockpile]setToken:[NSString stringWithFormat:@"%@",[models[@"userInfo"] objectForKey:@"rytoken"]]];
            [[NSUserDefaults standardUserDefaults]setObject:models[@"userCommunity"][@"ID"] forKey:@"commid"];
            [[NSUserDefaults standardUserDefaults]setObject:models[@"userInfo"][@"community"] forKey:@"commname"];
            [[NSUserDefaults standardUserDefaults]setObject:models[@"userInfo"][@"provinceId"] forKey:@"GuideShengId"];
            [[NSUserDefaults standardUserDefaults]setObject:models[@"userInfo"][@"province"] forKey:@"GuideShengName"];
            [[NSUserDefaults standardUserDefaults]setObject:models[@"userInfo"][@"districtId"] forKey:@"GuidequId"];
            [[NSUserDefaults standardUserDefaults]setObject:models[@"userInfo"][@"district"] forKey:@"GuidequName"];
            [[NSUserDefaults standardUserDefaults]setObject:models[@"userInfo"][@"cityId"] forKey:@"GuideShiId"];
            [[NSUserDefaults standardUserDefaults]setObject:models[@"userInfo"][@"city"] forKey:@"GuideShiName"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changeComm"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changeCommShang"];
            [[NSUserDefaults standardUserDefaults]setObject:models[@"userCommunity"][@"ShopID"] forKey:@"shopid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            if (_block) {
                _block(@"ok");
            }
            self.appdelegate.isRefresh=true;
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
    self.TitleLabel.text = @"注册或登录";
    _rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-(self.TitleLabel.height/2-5)-10, self.TitleLabel.top+(self.TitleLabel.height/4)+2.5, self.TitleLabel.height/2-5, self.TitleLabel.height/2-5)];
    [_rightBtn setImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:_rightBtn];
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
