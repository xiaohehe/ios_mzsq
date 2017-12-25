//
//  ZhangHuGuanLiViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ZhangHuGuanLiViewController.h"
#import "HelpTableViewCell.h"
#import <RongIMKit/RongIMKit.h>
#import "NickNameViewController.h"
#import "ResetPwdViewController.h"
#import "UmengCollection.h"
#import "PGDatePicker.h"
#import "AppUtil.h"

@interface ZhangHuGuanLiViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,RCIMUserInfoDataSource,PGDatePickerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)NSArray *TitleArr;
@end

@implementation ZhangHuGuanLiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.activityVC];
    [self newNav];
    [self newView];
   // [self heardView];
    [self.view addSubview:self.activityVC];
    self.navigationController.navigationBar.backgroundColor=[UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nicheng:) name:@"nicheng" object:nil];
}

-(void)newView{
    UILabel* titleLb=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, self.NavImg.bottom, self.view.width, 44)];
    titleLb.text=@"账户管理";
    titleLb.font=[UIFont systemFontOfSize:25];
    titleLb.textColor=[UIColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1.00];
    [self.view addSubview:titleLb];
    _TitleArr=@[@[@"头像"],@[@"昵称"],@[@"性别"],@[@"生日"]];
    _dataSource=@[@[@""],@[@"快起个帅气的名字吧"],@[@"小哥哥还是小姐姐"],@[@"我想给你准备礼物"]];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, titleLb.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[HelpTableViewCell class] forCellReuseIdentifier:@"ZiLiao"];
    [_tableView registerClass:[HelpTableViewCell class] forCellReuseIdentifier:@"FIRST"];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _TitleArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [[_TitleArr objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        HelpTableViewCell *cell=(HelpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FIRST" forIndexPath:indexPath];
        cell.title=[NSString stringWithFormat:@"%@",_TitleArr[indexPath.section][indexPath.row]];
        [cell.HeaderImg setImageWithURL:[NSURL URLWithString:[Stockpile sharedStockpile].logo] placeholderImage:[UIImage imageNamed:@"center_img"]];
        cell.isRound=YES;
        cell.HeaderImg.tag=123;
        cell.lineView.hidden=YES;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;//设置cell点击效果
        return cell;
    }
    HelpTableViewCell *cell=(HelpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ZiLiao" forIndexPath:indexPath];
    cell.title=[NSString stringWithFormat:@"%@",_TitleArr[indexPath.section][indexPath.row]];
    cell.HeaderImg.hidden=YES;
    if (indexPath.section==1 && indexPath.row==0) {
        cell.nameLabel.text=[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].nickName];
    }else if (indexPath.section==2 && indexPath.row==0) {
        NSString* sex=[Stockpile sharedStockpile].sex;
        if([sex isEqualToString:@"0"]){
            sex=@"保密";
        }else if([sex isEqualToString:@"1"]){
            sex=@"女";
        }else if([sex isEqualToString:@"2"]){
            sex=@"男";
        }else{
            sex=_dataSource[2][0];
        }
        cell.nameLabel.text=[NSString stringWithFormat:@"%@",sex];
    }else if (indexPath.section==3 && indexPath.row==0) {
        NSString* birthday=[Stockpile sharedStockpile].birthday;
        if([AppUtil isBlank:birthday]){
            cell.nameLabel.text=[NSString stringWithFormat:@"%@",_dataSource[3][0]];
        }else{
            cell.nameLabel.text=birthday;
        }
    }
    cell.nameLabel.tag=indexPath.row+indexPath.section;
    cell.topline.hidden=YES;
    cell.bottomline.hidden=YES;
    cell.lineView.hidden=YES;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//设置cell点击效果
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=self.view.backgroundColor;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35*self.scale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed=YES;
    if (indexPath.row==0 && indexPath.section==0) {
        UIActionSheet *sheey = [[UIActionSheet alloc]initWithTitle:@"头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
        sheey.tag=1000;
        [sheey showInView:self.view];
    }else  if (indexPath.row==0 && indexPath.section==1) {
        NickNameViewController *nicknameVC=[[NickNameViewController alloc]init];
        [self.navigationController pushViewController:nicknameVC animated:YES];
    }else  if (indexPath.row==0 && indexPath.section==2) {
        UIActionSheet *sheey = [[UIActionSheet alloc]initWithTitle:@"小哥哥还是小姐姐" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保密" otherButtonTitles:@"女",@"男", nil];
        sheey.tag=1001;
        [sheey showInView:self.view];
    }else  if (indexPath.row==0 && indexPath.section==3){
        NSString* birthday=[Stockpile sharedStockpile].birthday;
        NSLog(@"birthday == %@", birthday);

        if(![AppUtil isBlank:birthday]){
            [self ShowAlertWithMessage:@"您的生日已经设置"];
            return;
        }
        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
        datePicker.delegate = self;
        [datePicker show];
        datePicker.titleLabel.text=@"设置后不可更改";
        datePicker.datePickerType = PGPickerViewType2;
        datePicker.isHiddenMiddleText = false;
        datePicker.datePickerMode = PGDatePickerModeDate;
        
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        NSInteger year = [dateComponent year];
        NSInteger month = [dateComponent month];
        NSInteger day = [dateComponent day];
        datePicker.minimumDate = [NSDate setYear:year-100 month:month day:day];
        datePicker.maximumDate = [NSDate setYear:year-16 month:month day:day];
    }
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    NSString *birthdayNew=[NSString stringWithFormat:@"%@-%@",[AppUtil getTimeWith0:month],[AppUtil getTimeWith0:day]];
    NSLog(@"birthdayNew==%@", birthdayNew);

    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    NSDictionary* param=[NSDictionary dictionaryWithObjectsAndKeys:birthdayNew,@"birthday", nil];
    [self.activityVC startAnimate];
    [analy modifyBirthdayWithDic:param Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if([code isEqualToString:@"0"]){
            [[Stockpile sharedStockpile]setBirthday:birthdayNew];
            UILabel *birthdayLb=[_tableView viewWithTag:3 ];
            birthdayLb.text=birthdayNew;
        }else{
            [self ShowAlertWithMessage:msg];
        }
        NSLog(@"sex==%@==%@",code,models);
    }];
}

#pragma mark - 拍照片
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag==1001){
        NSString* sex=[Stockpile sharedStockpile].sex;
        if([sex integerValue]==buttonIndex)
            return;
        AnalyzeObject *analy=[[AnalyzeObject alloc]init];
        NSDictionary* param=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",buttonIndex],@"sex", nil];
         [self.activityVC startAnimate];
        [analy modifySexWithDic:param Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if([code isEqualToString:@"0"]){
                 [[Stockpile sharedStockpile]setSex:[NSString stringWithFormat:@"%d",buttonIndex]];
                 UILabel *sexLb=[_tableView viewWithTag:2 ];
                if(buttonIndex==0){
                    sexLb.text=@"保密";
                }else if(buttonIndex==1){
                    sexLb.text=@"女";
                }else if(buttonIndex==2){
                    sexLb.text=@"男";
                }else{
                    sexLb.text=_dataSource[2][0];
                }
            }else{
                [self ShowAlertWithMessage:msg];
            }
            NSLog(@"sex==%@==%@",code,models);
        }];
        return;
    }
    if (buttonIndex == 1) {
        NSLog(@"相册");
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.navigationController.navigationBar.tintColor=[UIColor redColor];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = actionSheet.tag == 0;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }else if (buttonIndex == 0) {
        NSLog(@"拍照");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = actionSheet.tag=2;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }else if(buttonIndex == 2) {
        NSLog(@"取消");
        
    }
}
-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}

- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *newImg=[self imageWithImageSimple:image scaledToSize:CGSizeMake(300, 300)];
    HelpTableViewCell *cell=(HelpTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.HeaderImg.image=newImg;
    float scale=1;
    if (image.size.width>800) {
        scale = 800/image.size.width;
    }
    UIImage *Img = [self scaleImage:image scaleFactor:scale];
    NSData *mydata=UIImageJPEGRepresentation(Img, .5);
    NSString *base64img=[mydata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength ];
   // 1、user_id(用户 id) 2、logo(头像)
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSString* usertoken= [[NSUserDefaults standardUserDefaults]objectForKey:@"usertoken"];
    NSDictionary *dic = @{@"userid":self.user_id,@"logo":base64img};//,@"usertoken":usertoken
    [anle modifyLogoWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        //NSLog(@"modify_success====%@",models);
        if([code isEqualToString:@"0"]){
            [self ShowAlertWithMessage:msg];
            [[NSUserDefaults standardUserDefaults]setObject:models[@"avatar"] forKey:@"touxiang"];
            [[Stockpile sharedStockpile]setLogo:models[@"avatar"]];
            [[NSUserDefaults standardUserDefaults]synchronize];
            RCUserInfo *_currentUserInfo = [[RCUserInfo alloc]initWithUserId:[self getuserid] name:[Stockpile sharedStockpile].nickName portrait:[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].logo]];
            [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
        }else{
            [self ShowAlertWithMessage:@"上传失败"];
        }
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *) scaleImage: (UIImage *)image scaleFactor:(float)scaleBy{
    CGSize size = CGSizeMake(image.size.width * scaleBy, image.size.height * scaleBy);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, scaleBy, scaleBy);
    CGContextConcatCTM(context, transform);
    // Draw the image into the transformed context and return the image
    [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

#pragma mark - 导航
-(void)newNav{
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top+5, 34, 34)];
    [popBtn setImage:[UIImage imageNamed:@"left_back"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_back"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}

-(void)PopVC:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"logsuccedata" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nicheng:(NSNotification *)not{
    NSString *str = not.object;
    UILabel *la = (UILabel *)[self.view viewWithTag:1];
    la.text=str;
    [_tableView reloadData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
