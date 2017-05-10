//
//  RegisterViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RegisterViewController.h"
#import "CellView.h"
@interface RegisterViewController()<UITextFieldDelegate>
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,strong)NSString *code;
@end
@implementation RegisterViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
   
}
-(void)newView{
    NSArray *ImgArr=@[@"dl_icon01",@"zhuce_icon01",@"dl_icon02"];
    NSArray *PlaceArr=@[@"请输入手机号码",@"请输入验证码",@"请设置登陆密码"];
    
    UIImageView *topLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10*self.scale+self.NavImg.bottom, self.view.width, 0.5)];
    topLine.backgroundColor=blackLineColore;
    [self.view addSubview:topLine];
    float setY=topLine.bottom;
    for (int i=0; i<PlaceArr.count; i++)
    {
        CellView *Cell=[[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 44*self.scale)];
        Cell.backgroundColor=[UIColor whiteColor];
        UIImageView *Img=[[UIImageView alloc]initWithFrame:CGRectMake(15*self.scale, Cell.height/2-11*self.scale, 22*self.scale, 22*self.scale)];
        Img.image = [UIImage imageNamed:ImgArr[i]];
        [Cell addSubview:Img];
        
        UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake(Img.right+10*self.scale, 5*self.scale, Cell.width-Img.right-40*self.scale, Cell.height-10*self.scale)];
        textF.font=DefaultFont(self.scale);
        textF.placeholder=PlaceArr[i];
        textF.secureTextEntry=(i==2);
        textF.delegate=self;
        textF.tag=10+i;
        [Cell setHiddenLine:i==PlaceArr.count-1];
        [Cell addSubview:textF];
        [self.view addSubview:Cell];
        if(i==1)
        {
            UIButton *MSMBtn=[[UIButton alloc]initWithFrame:CGRectMake(Cell.width-110*self.scale, 8*self.scale, 100*self.scale, Cell.height-16*self.scale)];
            
            [MSMBtn setBackgroundImage:[UIImage setImgNameBianShen:@"huoqu_btn"] forState:UIControlStateNormal];
            MSMBtn.titleLabel.font=DefaultFont(self.scale);
            [MSMBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [MSMBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            MSMBtn.tag=5;
            [MSMBtn addTarget:self action:@selector(MSMButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [Cell addSubview:MSMBtn];
            
            textF.frame=CGRectMake(Img.right+10*self.scale, 5*self.scale, MSMBtn.left-Img.right-25*self.scale, Cell.height-10*self.scale);
        }
        setY=Cell.bottom;
    }
    UIImageView *bottomLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 0.5)];
    bottomLine.backgroundColor=blackLineColore;
    [self.view addSubview:bottomLine];
    
    UIButton *RegisterBtn=[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, bottomLine.bottom+15*self.scale, self.view.width-36*self.scale, 35*self.scale)];
    [RegisterBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn"] forState:UIControlStateNormal];
     [RegisterBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn_b"] forState:UIControlStateHighlighted];
    [RegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    [RegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RegisterBtn.titleLabel.font=BigFont(self.scale);
    [RegisterBtn addTarget:self action:@selector(RegisterButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RegisterBtn];

    UIButton *XYButton=[[UIButton alloc]initWithFrame:CGRectMake(RegisterBtn.left+30*self.scale, RegisterBtn.bottom+15*self.scale, 150*self.scale, 20*self.scale)];
    [XYButton setTitleColor:blueTextColor forState:UIControlStateNormal];
    [XYButton setTitle:@"《拇指社区用户使用协议》" forState:UIControlStateNormal];
    [XYButton addTarget:self action:@selector(XYButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    XYButton.titleLabel.font=SmallFont(self.scale);
    [self.view addSubview:XYButton];
    UIButton *OKXY=[[UIButton alloc]initWithFrame:CGRectMake(XYButton.left-20*self.scale, XYButton.top, 18*self.scale, 18*self.scale)];
    [OKXY setImage:[UIImage imageNamed:@"address_no"] forState:UIControlStateNormal];
    [OKXY setImage:[UIImage imageNamed:@"address_yes"] forState:UIControlStateSelected];
    [OKXY addTarget:self action:@selector(OKXYEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OKXY];
}
#pragma mark - 按钮事件
/*获取验证码*/
-(void)MSMButtonEvent:(id)sender{
    UITextField *telText=(UITextField *)[self.view viewWithTag:10];
    NSString *tel=[telText.text trimString];
    if ( ![tel isValidateMobile])
    {
        [self ShowAlertWithMessage:@"请输入有效的手机号码"];
        return;
    }
    [self.activityVC startAnimate];
}
/*注册事件*/
-(void)RegisterButtonEvent:(id)sender{
    
    
    
}
/*是否同意协议*/
-(void)OKXYEvent:(UIButton *)button{
    button.selected=!button.selected;
}
/*协议*/
-(void)XYButtonEvent:(id)sneder{
    
}
#pragma mark - TextField
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 13) {
        [self.view endEditing:YES];
        return NO;
    }else if (textField.tag == 10){
        textField.keyboardType=UIKeyboardTypePhonePad;
    }else if (textField.tag == 11){
        textField.keyboardType=UIKeyboardTypeNumberPad;
    }
    return YES;
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
    self.TitleLabel.text=@"注册";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
}
@end
