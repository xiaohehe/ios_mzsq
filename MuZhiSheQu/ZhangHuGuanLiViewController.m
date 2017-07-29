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
@interface ZhangHuGuanLiViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,RCIMUserInfoDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)NSArray *TitleArr;
@end

@implementation ZhangHuGuanLiViewController
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
    [self newNav];
    [self newView];
   // [self heardView];
    [self.view addSubview:self.activityVC];
    self.navigationController.navigationBar.backgroundColor=[UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nicheng:) name:@"nicheng" object:nil];
    
    
}
-(void)newView{
    _TitleArr=@[@[@"头像"],@[@"昵称"]];
    _dataSource=@[@[@""],@[@"昵称"]];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[HelpTableViewCell class] forCellReuseIdentifier:@"ZiLiao"];
    [_tableView registerClass:[HelpTableViewCell class] forCellReuseIdentifier:@"FIRST"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
        //cell.HeaderImg.backgroundColor=[UIColor redColor];
        return cell;
    }
    HelpTableViewCell *cell=(HelpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ZiLiao" forIndexPath:indexPath];
    cell.title=[NSString stringWithFormat:@"%@",_TitleArr[indexPath.section][indexPath.row]];
    cell.HeaderImg.hidden=YES;
    
    if (indexPath.section==1 && indexPath.row==0) {
        cell.nameLabel.text=[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].nickName];
    }else{
        cell.nameLabel.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"]];

    }
    
    cell.nameLabel.tag=indexPath.row+indexPath.section;
    cell.nameLabel.textColor=grayTextColor;
    cell.nameLabel.textAlignment=NSTextAlignmentRight;
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.rigthImg.hidden=YES;
    }else{
        cell.rigthImg.hidden=NO;
    }
    if (indexPath.row == 0) {
        cell.topline.hidden=NO;
    }else{
        cell.topline.hidden=YES;
    }
    if (indexPath.row == [_dataSource[indexPath.section] count]-1) {
        cell.bottomline.hidden=NO;
    }else{
        cell.bottomline.hidden=YES;
    }
    
    cell.nameLabel.textAlignment=NSTextAlignmentRight;
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
    if (indexPath.section == 0 && indexPath.row <= 1){
        return 80*self.scale;
    }else
        return 44*self.scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed=YES;
    if (indexPath.row==0 && indexPath.section==0) {
        UIActionSheet *sheey = [[UIActionSheet alloc]initWithTitle:@"头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
        [sheey showInView:self.view];
    }
    
    
    if (indexPath.row==0 && indexPath.section==1) {
        NickNameViewController *nicknameVC=[[NickNameViewController alloc]init];
        [self.navigationController pushViewController:nicknameVC animated:YES];
    }

}

#pragma mark - 拍照片
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{   
    
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

    NSDictionary *dic = @{@"user_id":self.user_id,@"logo":base64img,@"usertoken":usertoken};
    [anle modifyLogoWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        NSLog(@"modify_success====%@",models);

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

-(UIImage *) scaleImage: (UIImage *)image scaleFactor:(float)scaleBy
{
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
    self.TitleLabel.text=@"账户管理";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
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
