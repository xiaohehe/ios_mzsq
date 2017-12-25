//
//  FaBuGongGaoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "FaBuGongGaoViewController.h"
#import "CellView.h"
#import "UmengCollection.h"
#import "ZLPickerViewController.h"
#import "UIView+Extension.h"
#import "ZLPickerBrowserViewController.h"
#import "ZLPickerCommon.h"
#import "ZLAnimationBaseView.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZLCameraViewController.h"
#import "IntroControll.h"
#import "IntroModel.h"
#import "AppUtil.h"

@interface FaBuGongGaoViewController ()<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSInteger ii;
}
@property(nonatomic,strong)UITextField *titleText;
@property(nonatomic,strong)IntroControll *intro;
@property(nonatomic,strong)UILabel *placeLabel;
@property(nonatomic,strong)UIScrollView *scroll,*imgscroll;
@property(nonatomic,strong)UITextView *contentText;
@property(nonatomic,strong)NSMutableArray *imgURR;
@property(nonatomic,assign)NSInteger countt;
@property(nonatomic,strong)CellView *contentCell;
@property(nonatomic,strong)UIView *bigvi;
@property(nonatomic,strong)UIButton *PostBtn;
@property(nonatomic,strong)gonggaoResh block;
@property(nonatomic,strong)UIPageControl *page;
@property(nonatomic,assign)BOOL imgTui;
@end

@implementation FaBuGongGaoViewController
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
-(void)gonggaoResh:(gonggaoResh)block{
    _block=block;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _countt=9;
    _imgTui=NO;
    ii=1;
    _imgURR=[NSMutableArray new];
    _assetss=[NSMutableArray new];
    if (_imgData.count>0) {
        _assetss=_imgData;
    }
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
}
-(void)newView{
    if (_scroll) {
        [_scroll removeFromSuperview];
    }
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _scroll.backgroundColor=superBackgroundColor;
    [self.view addSubview:_scroll];
    
    CellView *titleCell=[[CellView alloc]initWithFrame:CGRectMake(0, 10*self.scale, self.view.width, 44*self.scale)];
    titleCell.topline.hidden=NO;
    _titleText=[[UITextField alloc]initWithFrame:CGRectMake(15*self.scale, 6*self.scale, titleCell.width-30*self.scale, titleCell.height-12*self.scale)];
    _titleText.tag=5;
    _titleText.placeholder=@"请输入标题";
    _titleText.text=self.titlee;
    _titleText.font=DefaultFont(self.scale);
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收起" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [_titleText setInputAccessoryView:topView];
    
    [titleCell addSubview:_titleText];
    [_scroll addSubview:titleCell];
    
    _contentCell=[[CellView alloc]initWithFrame:CGRectMake(0, titleCell.bottom+10*self.scale, self.view.width, 134*self.scale)];
    _contentCell.topline.hidden=NO;
    _placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15*self.scale, 11*self.scale, _contentCell.width-30*self.scale, 20*self.scale)];
    _placeLabel.textColor=[UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
    if (self.conteent==nil || [self.conteent isEqualToString:@""]) {
        _placeLabel.text=@"说点儿什么呢？";//最多输入140个字符
    }
    _placeLabel.tag=12;
    _placeLabel.numberOfLines=0;
    [_placeLabel sizeToFit];
    _placeLabel.font=DefaultFont(self.scale);
    [_contentCell addSubview:_placeLabel];
    _contentText=[[UITextView alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, _contentCell.width-20*self.scale, _contentCell.height-10*self.scale)];
    _contentText.backgroundColor=[UIColor clearColor];
    _contentText.tag=1;
    _contentText.text=self.conteent;
    _contentText.delegate=self;
    [_contentText setInputAccessoryView:topView];

    _contentText.font=DefaultFont(self.scale);
    [_contentCell addSubview:_contentText];
    [self imgView];
}

-(void)dismissKeyBoard
{
    [_titleText resignFirstResponder];
    [_contentText resignFirstResponder];
}

-(void)imgView{
    
    if (_bigvi) {
        [_bigvi removeFromSuperview];
    }
    
    _bigvi = [[UIView alloc]initWithFrame:CGRectMake(0, _contentText.bottom, self.view.width, 100)];
    _bigvi.backgroundColor=[UIColor whiteColor];
    [_contentCell addSubview:_bigvi];
    
    
    NSInteger q=0;
    if (!self.assetss.count<=0) {
        q=_assetss.count;
    }
    float W=(self.view.width-40*self.scale)/3;
    float setY=0;
    for (int i=0; i<q+1; i++) {
        
        float x = (W+10*self.scale)*(i%3);
        float y = (W-15*self.scale)*(i/3);
        
        
        
        if (q-i==0) {
            if (q!=9) {
               
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x+10*self.scale, y, W, W*0.75)];
            [btn setBackgroundImage:[UIImage imageNamed:@"53"]  forState:UIControlStateNormal];
            btn.tag=123;
            [btn addTarget:self action:@selector(addimg) forControlEvents:UIControlEventTouchUpInside];
            [_bigvi addSubview:btn];
            
            
            setY = btn.bottom+10*self.scale;
            _bigvi.height=setY+10*self.scale;
            }

        }else{
            
            UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(x+10*self.scale, y, W, W*0.75)];
            im.tag=1000+i;
            im.backgroundColor=[UIColor redColor];
            im.contentMode=UIViewContentModeScaleAspectFill;
            im.clipsToBounds=YES;
            
            ALAsset *asset = self.assetss[i];
            if ([asset isKindOfClass:[ALAsset class]]) {
                im.image = [UIImage imageWithCGImage:[asset thumbnail]];
            }else if ([asset isKindOfClass:[NSString class]]){
                [im setImageWithURL:[NSURL URLWithString:(NSString *)asset] placeholderImage:[UIImage imageNamed:@"center_img"]];
            }else if([asset isKindOfClass:[UIImage class]]){
                im.image = (UIImage *)asset;
            }
            im.userInteractionEnabled=YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tubian:)];
            [im addGestureRecognizer:tap];
            
            
            [_bigvi addSubview:im];
            
            
            if (self.assetss.count>=9) {
                UIButton *b = (UIButton *)[self.view viewWithTag:123];
                [b removeFromSuperview];
            }
            
            
            
            
            setY = im.bottom+10*self.scale;
            _bigvi.height=setY+10*self.scale;

        }
    }
    _contentCell.height=_bigvi.bottom;
    
    if (_PostBtn) {
        [_PostBtn removeFromSuperview];
    }
    
    _PostBtn=[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, _contentCell.bottom+15*self.scale, self.view.width-36*self.scale, 35*self.scale)];
//    [_PostBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn"] forState:UIControlStateNormal];
//    [_PostBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn_b"] forState:UIControlStateHighlighted];
    _PostBtn.clipsToBounds = YES;
    _PostBtn.layer.cornerRadius = _PostBtn.height/10;
    _PostBtn.backgroundColor = blueTextColor;
    [_PostBtn setTitle:@"立即发布" forState:UIControlStateNormal];
    [_PostBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _PostBtn.titleLabel.font=BigFont(self.scale);
    [_PostBtn addTarget:self action:@selector(PostButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scroll addSubview:_PostBtn];
    
    _scroll.contentSize = CGSizeMake(self.view.width, _PostBtn.bottom+20*self.scale);

    [_scroll addSubview:_contentCell];
   
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    ii = scrollview.contentOffset.x / scrollview.frame.size.width;
//    [_page setCurrentPage:ii];
    self.TitleLabel.text=[NSString stringWithFormat:@"%d/%d",ii+1,_assetss.count];

}


-(void)tubian:(UITapGestureRecognizer *)tap{
    UIView *vi = (UIView *)[self.view viewWithTag:904];
    vi.hidden=NO;
    _imgTui=YES;
    
    if (_imgscroll) {
        [_imgscroll removeFromSuperview];
    }
    _imgscroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _imgscroll.backgroundColor=[UIColor blackColor];
    _imgscroll.userInteractionEnabled=YES;
    _imgscroll.tag=905;
    _imgscroll.delegate=self;
    _imgscroll.pagingEnabled=YES;
    [self.view addSubview:_imgscroll];
    
    _imgscroll.contentSize = CGSizeMake(self.view.width*_assetss.count, self.view.height-self.NavImg.bottom);

    NSInteger num = 0;
    if (!tap) {
        num=[[Stockpile sharedStockpile].YUE integerValue]-1;
 
        if (num==0) {
            num=1;
        }
        
    }else{
        num = tap.view.tag-999;
    }
    
    
    
    [[Stockpile sharedStockpile] setYUE:[NSString stringWithFormat:@"%ld",(long)num]];
    
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _imgscroll.bottom-20*self.scale, self.view.width, 20*self.scale)];
    _page.numberOfPages=_assetss.count;
    _page.currentPage=tap.view.tag-1000;
    _page.currentPageIndicatorTintColor=[UIColor redColor];
    _page.pageIndicatorTintColor=[UIColor grayColor];
    
    
    for (int i = 0; i < _assetss.count; i ++) {
        UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.width, 0, _imgscroll.width, _imgscroll.height)];
        im.contentMode=UIViewContentModeScaleAspectFit;
        im.userInteractionEnabled=YES;
        ALAsset *asset = self.assetss[i];
        if ([asset isKindOfClass:[ALAsset class]]) {
            im.image = [UIImage imageWithCGImage:[asset thumbnail]];
        }else if ([asset isKindOfClass:[NSString class]]){
            [im setImageWithURL:[NSURL URLWithString:(NSString *)asset] placeholderImage:[UIImage imageNamed:@"center_img"]];
        }else if([asset isKindOfClass:[UIImage class]]){
            im.image = (UIImage *)asset;
        }
        
        UITapGestureRecognizer *tui = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tuichu:)];
        [im addGestureRecognizer:tui];

        
        [_imgscroll addSubview:im];
        
        
    }
    self.TitleLabel.text=[NSString stringWithFormat:@"%ld/%lu",(long)num,(unsigned long)_assetss.count];
    if (!tap) {
        if (_assetss.count==1) {
            [_imgscroll setContentOffset:CGPointMake(0 , 0)];
            self.TitleLabel.text=[NSString stringWithFormat:@"%d/%d",1,_assetss.count];
        }else if (_assetss.count==0){
            [self tuichu:nil];
        }else{

            [_imgscroll setContentOffset:CGPointMake(self.view.width*(num-1) , 0)];
        }
    }else{
        _imgscroll.contentOffset=CGPointMake((tap.view.tag-1000)*self.view.width, 0);
    }
    
    

}





-(void)tuichu:(UITapGestureRecognizer *)tap{
    [_imgscroll removeFromSuperview];
    UIView *vi = (UIView *)[self.view viewWithTag:904];
    vi.hidden=YES;
    _imgTui=NO;
    self.TitleLabel.text=@"发布公告";
    [_page removeFromSuperview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            NSLog(@"拍照");
            UIImagePickerControllerSourceType sourceType= UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
//                picker.allowsEditing = YES;
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:nil];
            }else
            {
                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
            }
            break;
        case 1:{
            NSLog(@"从相册选择");
            
            _countt = 9-self.assetss.count;
            
            ZLPickerViewController *pickerVc = [[ZLPickerViewController alloc] init];
            pickerVc.status = PickerViewShowStatusGroup;
            pickerVc.minCount = _countt;
            pickerVc.count=self.assetss.count;
            [pickerVc show];
            
            
            pickerVc.callBack = ^(NSArray *assets){
                
                for (id dd in assets) {
                    
                    ZLPickerBrowserPhoto *bro = [ZLPickerBrowserPhoto photoAnyImageObjWith:dd];
                    [self.assetss addObject:bro.photoImage];
                    
                }
                
                
             
                [self imgView];
            };

            
            }
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    
}




-(void)addimg{
    [self.view endEditing:YES];
    if (self.assetss.count>=9) {
        [self ShowAlertWithMessage:@"最多只能选择9张图片"];
        return;
    }
    
    UIActionSheet *sheet =[[UIActionSheet alloc]initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [sheet showInView:self.view];
    

    
    
    
   

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    
    UIImage *im = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.assetss addObject:im];
    [self imgView];
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark <ZLPickerBrowserViewControllerDelegate>
- (void)photoBrowser:(ZLPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSUInteger)index{
    if (index > self.assetss.count) return;
    [self.assetss removeObjectAtIndex:index];
    //[self.tableView reloadData];
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

-(void)PostButtonEvent:(id)sender{
    NSString *titleStr = [_titleText.text trimString];
    if ([AppUtil isBlank:titleStr]) {
        [self ShowAlertWithMessage:@"标题不能为空"];
        return;
    }
    NSString *str = [_contentText.text trimString];
    if ([str isEmptyString] && self.assetss.count<=0) {
        [self ShowAlertWithMessage:@"内容不能为空"];
        return;
    }
    if (_contentText.text.length>140) {
        [self ShowAlertWithMessage:@"信息应小于140个字符"];
        return;
    }
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSString *type = @"1";
    if (_isershou) {
        type=@"4";
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_titleText.text,@"title",_contentText.text
,@"content", nil];
    float scale = 1.0;
    int i=1;
    for (ALAsset *asset in self.assetss) {
        ZLPickerBrowserPhoto *bor = [ZLPickerBrowserPhoto photoAnyImageObjWith:asset];
        UIImage *image = bor.photoObj;
        NSLog(@"%f",image.size.width);
        if (image.size.width>800) {
            scale = 800/image.size.width;
        }else{
            scale= 1.0;
        }
        UIImage *im = [self scaleImage:image scaleFactor:scale];
        NSData *data = UIImageJPEGRepresentation(im, .6);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [dic setObject:encodedImageStr forKey:[NSString stringWithFormat:@"img%d",i++]];
    }
     NSLog(@"base64====%@",dic);
    NSString* usertoken= [[NSUserDefaults standardUserDefaults]objectForKey:@"usertoken"];
    [dic setObject:usertoken forKey:@"usertoken"];
    if (_bian) {
        [dic setObject:self.gongid forKey:@"notice_id"];
        [anle editNoticeWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
                [self ShowAlertWithMessage:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
    [anle addNoticeWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            //[self ShowAlertWithMessage:@"发布成功"];
            [AppUtil showToast:self.view withContent:@"发布成功"];
            if (_block) {
                _block(@"ok");
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self ShowAlertWithMessage:@"发布失败"];
        }
    }];
    }
}
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:12];
        label.hidden=YES;
    }else{
        UILabel *label=(UILabel *)[self.view viewWithTag:12];
        label.hidden=NO;
    }
    if (textView.text.length>140) {
        textView.text=[textView.text substringToIndex:140];
    }
    //UILabel *zi =(UILabel *)[self.view viewWithTag:20];
   // zi.text=[NSString stringWithFormat:@"您最多还可以输入%lu个字",140-(unsigned long)textView.text.length];
}
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"发布公告";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    UIButton *talkImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [talkImg setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
    talkImg.frame=CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height,self.TitleLabel.height);
    talkImg.hidden=YES;
    talkImg.tag=904;
    [talkImg addTarget:self action:@selector(talk) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:talkImg];
}

-(void)talk{

    [_assetss removeObjectAtIndex:_imgscroll.contentOffset.x/self.view.width];

    [self tuichu:nil];
    [self imgView];
    [self tubian:nil];


}

-(void)PopVC:(id)sender{
    if (_imgTui) {
        [self tuichu:nil];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
