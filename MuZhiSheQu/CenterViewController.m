//
//  CenterViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CenterViewController.h"

#import "TelPhoneViewController.h"
#import "LoginViewController.h"

#import "UIActivityIndicatorView+AFNetworking.h"


@interface CenterViewController()<UIAlertViewDelegate>
//@property(nonatomic,strong)NSString *ID,*token,*user_name;
@property(nonatomic,strong)UIView *vi;
@property(nonatomic,strong)UIActivityIndicatorView *activityVC;
@property(nonatomic,strong)NSString *str;
@end
@implementation CenterViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self newNav];
    [self reshData];
    [self.pluginBoardView removeItemAtIndex:1];
   
    _activityVC=[[UIActivityIndicatorView alloc]initWithView:self.view];
    _activityVC.color=[UIColor blackColor];
    [self.view addSubview:self.activityVC];

 
    self.conversationMessageCollectionView.top = 64+30;
    self.conversationMessageCollectionView.bottom=self.view.height-40;

    
    
}
-(NSString *)getCommid{
    NSString *com = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    return com;
}
-(void)reshData{

    [self.activityVC startAnimating];
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle getgjInfo:@{@"community_id":[self getCommid]} Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if ([code isEqualToString:@"0"]) {
            _str = (NSString *)models;

            UILabel *la = (UILabel *)[self.view viewWithTag:900];
            la.textAlignment=NSTextAlignmentLeft;

            if (la) {
                la.text=[NSString stringWithFormat:@"   %@",_str];
            }
            [la sizeToFit];
            la.left=10;

        }
        
        
    }];



}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    

    [RCIM sharedRCIM].disableMessageAlertSound=YES;

//    [[RCIM sharedRCIM]setUserInfoDataSource:self];
    if (_vi) {
        [_vi removeFromSuperview];
        _vi=nil;
    }

    
    _vi = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 30)];
    _vi.backgroundColor=[UIColor colorWithRed:250/255.0 green:255/255.0 blue:182/255.0 alpha:1];
    [self.view addSubview:_vi];
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width-20, _vi.height)];
    la.font=SmallFont(1);
    la.text=[NSString stringWithFormat:@"   %@",_str];
    [_vi addSubview:la];
    la.height=20;
    la.tag=900;
    _vi.height=la.bottom;
    la.textAlignment=NSTextAlignmentLeft;
    if ([la.text isEmptyString]) {
        la.text=@"无";
    }
    [la sizeToFit];
    la.left=10;
    _vi.height=la.bottom;
    if (la.width>self.view.width) {
        CGRect frame = la.frame;
        frame.origin.x = self.view.width;
        la.frame = frame;
        [UIView beginAnimations:@"testAnimation" context:NULL];
        [UIView setAnimationDuration:20];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationRepeatCount:999999];
        frame = la.frame;
        frame.origin.x = -frame.size.width;
        la.frame = frame;
        [UIView commitAnimations];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
            self.hidesBottomBarWhenPushed=YES;
            LoginViewController *login = [LoginViewController new];
            login.f=NO;
            [self presentViewController:login animated:YES completion:nil];
    }else{
        self.tabBarController.selectedIndex=0;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
//{
//    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
//    conversationVC.conversationType =model.conversationType;
//    conversationVC.targetId = model.targetId;
//    conversationVC.userName =model.conversationTitle;
//    conversationVC.title = model.conversationTitle;
//    [self.navigationController pushViewController:conversationVC animated:YES];
//}


//-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
////    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
////        completion([RCIMClient sharedRCIMClient].currentUserInfo);
////    }else{
//        AnalyzeObject *analy=[[AnalyzeObject alloc]init];
//        
//        
//        [analy GetNickAndAvatarWithUser_ID:@{@"user_id":userId} Block:^(id models, NSString *code, NSString *msg) {
//            NSArray *Arr=models;
//            if (Arr && Arr.firstObject && [code isEqualToString:@"0"]) {
//                NSDictionary *dic = Arr.firstObject;
//                RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@",dic[@"id"]] name:[NSString stringWithFormat:@"%@",dic[@"nick_name"]] portrait:[NSString stringWithFormat:@"%@",dic[@"avatar"]]];
//                completion(info);
//            }
//            
//        }];
////    }
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}
#pragma mark - 导航
-(void)newNav{
   // self.navigationController.title=@"小区管家";
    self.navigationController.navigationBar.barTintColor=blueTextColor;
    
    UILabel *tit = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    tit.text = @"小区管家";
    tit.font=Big16Font(1);
    tit.textAlignment = NSTextAlignmentCenter;
    tit.textColor = [UIColor whiteColor];
    [tit sizeToFit];
    
    self.navigationItem.titleView=tit;
    
    

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    // backBtn.backgroundColor=[UIColor redColor];
    backBtn.frame=CGRectMake(0, 0, 50, 50);
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left"]];
    backImg.frame = CGRectMake(-15, 10, 30, 30);
    [backBtn addSubview:backImg];
    //
    
//    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(backImg.right-5, 15, 40, 22)];
//    //backText.text = @"退出";
//    backBtn.titleLabel.font=[UIFont systemFontOfSize:20];
//    backText.font = Big16Font(1);
//    [backText setBackgroundColor:[UIColor clearColor]];
//    [backText setTextColor:[UIColor whiteColor]];
//    
//    [backBtn addSubview:backText];
//    
    
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
        self.navigationItem.leftBarButtonItem=left;



    
    
    
    UILabel *tel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 0, 0)];
    tel.text=@"社区常用电话";
    tel.font=DefaultFont(1);
    [tel sizeToFit];
    tel.userInteractionEnabled=YES;
    tel.textColor=[UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightbtn:)];
    [tel addGestureRecognizer:tap];
    
    
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc]initWithCustomView:tel];
    self.navigationItem.rightBarButtonItem=rightbtn;
    
    
    
}

-(void)rightbtn:(UIButton *)sender{
    TelPhoneViewController *tel = [TelPhoneViewController new];
    [self.navigationController pushViewController:tel animated:YES];
    
    
    

}
-(void)PopVC:(id)sender{
    if (_isPush) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
