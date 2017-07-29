//
//  XiePingJiaViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "XiePingJiaViewController.h"
#import "CellView.h"
#import "ZLPicker.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "IntroModel.h"
#import "IntroControll.h"
#import "ZLPickerBrowserPhoto.h"
#import "UmengCollection.h"
@interface XiePingJiaViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewAccessibilityDelegate,ZLPickerViewControllerDelegate>
{
    NSInteger ii;
}
@property(nonatomic,strong)UIView *start,*start1,*bigvi;
@property(nonatomic,strong)UILabel *fuwuLa,*labeltext,*fuwuLa1;
@property(nonatomic,strong)CellView *fuwu,*fuwu1;
@property(nonatomic,strong)UIScrollView *scroll,*imgscroll;
@property(nonatomic,strong)CellView *Img;
@property(nonatomic,assign)float setY;
@property(nonatomic,assign)NSInteger countt;
@property(nonatomic,assign)int num;
@property(nonatomic,strong)UITextView *tv;
@property(nonatomic,strong)IntroControll *intro;
@property(nonatomic,strong)reshdalock block;
@property(nonatomic,strong)UIPageControl *page;
@property(nonatomic,assign)BOOL imgTui;
@end

@implementation XiePingJiaViewController

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

-(void)reshBlock:(reshdalock)block{
    _block=block;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
    _num=0;
    ii=1;
    _imgTui=NO;
    _assetss = [NSMutableArray new];
    self.view.backgroundColor=superBackgroundColor;
    
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _scroll.backgroundColor=superBackgroundColor;
    [self.view addSubview:_scroll];
    
    
    
    _fuwu = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44*self.scale)];
    [_scroll addSubview:_fuwu];
    
    _fuwuLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, _fuwu.height/2-10*self.scale, 70*self.scale, 20*self.scale)];
    _fuwuLa.text = @"评价";
    _fuwuLa.font=DefaultFont(self.scale);
    [_fuwu addSubview:_fuwuLa];
    [self setStartNumber1:@"5"];
   // [self setStartNumber:@"3"];
    
    
    CellView *taidu = [[CellView alloc]initWithFrame:CGRectMake(0, _fuwu.bottom+10*self.scale, self.view.width, 160*self.scale)];
    [_scroll addSubview:taidu];
    
    _tv = [[UITextView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, self.view.width-20*self.scale, taidu.height-10*self.scale)];
    _tv.delegate=self;
    _tv.font=DefaultFont(self.scale);
    [taidu addSubview:_tv];
    
    _labeltext = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 0, _tv.width, 30*self.scale)];
    _labeltext.backgroundColor = [UIColor clearColor];
    _labeltext.textColor=grayTextColor;
    _labeltext.font = DefaultFont(self.scale);
    _labeltext.text = @"说点什么吧";
    [_tv addSubview:_labeltext];
    
    _setY = taidu.bottom;
   
    [self imgView];
    
    [self.view addSubview:self.activityVC];
}

-(void)imgView{
    if (_Img) {
        [_Img removeFromSuperview];
    }
    
    _Img = [[CellView alloc]initWithFrame:CGRectMake(0, _setY+10*self.scale, self.view.width, 60*self.scale)];
    [_scroll addSubview:_Img];


    NSInteger q=0;
    if (!self.assetss.count<=0) {
        q=_assetss.count;
    }

    float W=(self.view.width-40*self.scale)/3;
    float setY=10;
    for (int i=0; i<q+1; i++) {
        
        float x = (W+10*self.scale)*(i%3);
        float y = (W-15*self.scale)*(i/3);
       
        
        
        if (q-i==0) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x+10*self.scale, y+10*self.scale, W, W*0.75)];
            [btn setImage:[UIImage imageNamed:@"53"]  forState:UIControlStateNormal];
            btn.tag=123;
            [btn addTarget:self action:@selector(addTuPian) forControlEvents:UIControlEventTouchUpInside];
            [_Img addSubview:btn];
            if (q==9) {
                [btn removeFromSuperview];
            }
            setY = btn.bottom+10*self.scale;
        }else{
            
            
            
            UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(x+10*self.scale, y+10*self.scale, W, W*0.75)];
            im.backgroundColor=[UIColor redColor];
            im.contentMode=UIViewContentModeScaleAspectFill;
            im.clipsToBounds=YES;
            im.tag=200+i;
            im.userInteractionEnabled=YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBing:)];
            [im addGestureRecognizer:tap];
            
            ALAsset *asset = self.assetss[i];
            if ([asset isKindOfClass:[ALAsset class]]) {
                im.image = [UIImage imageWithCGImage:[asset thumbnail]];
            }else if ([asset isKindOfClass:[NSString class]]){
                [im setImageWithURL:[NSURL URLWithString:(NSString *)asset] placeholderImage:[UIImage imageNamed:@"center_img"]];
            }else if([asset isKindOfClass:[UIImage class]]){
                im.image = (UIImage *)asset;
            }
            
            
            
            [_Img addSubview:im];
            
            
            if (self.assetss.count>=9) {
                UIButton *b = (UIButton *)[self.view viewWithTag:123];
                [b removeFromSuperview];
            }
            
            
            
            
            setY = im.bottom+10*self.scale;
        }
    }
   
    _Img.height=setY;
    
    
    
    _scroll.contentSize = CGSizeMake(self.view.width, _Img.bottom+20*self.scale);
    
    
}

-(void)imgBing:(UITapGestureRecognizer *)tap{


    _imgTui=YES;
    
    UIView *vi = (UIView *)[self.view viewWithTag:904];
    vi.hidden=NO;
    UIView *vi1 = (UIView *)[self.view viewWithTag:903];
    vi1.hidden=YES;

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
        num=[[[NSUserDefaults standardUserDefaults]objectForKey:@"tag" ] integerValue]-1;
        NSLog(@"%d",num);
        if (num==0) {
            num=1;
        }
        
        NSLog(@"%f",self.view.width*(num-1));
    }else{
        num = tap.view.tag-199;
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",num] forKey:@"tag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _imgscroll.bottom-20*self.scale, self.view.width, 20*self.scale)];
    _page.numberOfPages=_assetss.count;
    _page.currentPage=tap.view.tag-200;
    _page.currentPageIndicatorTintColor=[UIColor redColor];
    _page.pageIndicatorTintColor=[UIColor grayColor];
   // [self.view addSubview:_page ];
    
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
//        ZLPickerBrowserPhoto *pho = [ZLPickerBrowserPhoto photoAnyImageObjWith:self.assetss[i]];
//        im.image=pho.photoImage;
        UITapGestureRecognizer *tui = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tuichu:)];
        [im addGestureRecognizer:tui];
        
        _imgscroll.userInteractionEnabled=YES;
        [_imgscroll addSubview:im];
        
        
    }
    
    
    self.TitleLabel.text=[NSString stringWithFormat:@"%d/%d",num,_assetss.count];
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
        _imgscroll.contentOffset=CGPointMake((tap.view.tag-200)*self.view.width, 0);
    }
}


-(void)tuichu:(UITapGestureRecognizer *)tap{
    [_imgscroll removeFromSuperview];
    _imgTui=NO;
    UIView *vi = (UIView *)[self.view viewWithTag:904];
    vi.hidden=YES;
    UIView *vi1 = (UIView *)[self.view viewWithTag:903];
    vi1.hidden=NO;

    self.TitleLabel.text=@"写评价";
    [_page removeFromSuperview];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    ii = scrollview.contentOffset.x / scrollview.frame.size.width;
    self.TitleLabel.text=[NSString stringWithFormat:@"%d/%d",ii+1,_assetss.count];
//    [_page setCurrentPage:ii];
}

-(void)addTuPian{
    [self.view endEditing:YES];
    if (self.assetss.count>=9) {
        [self ShowAlertWithMessage:@"最多只能选择9张图片"];
        return;
    }

    UIActionSheet *sheet =[[UIActionSheet alloc]initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [sheet showInView:self.view];


}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.view endEditing:YES];
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
            
            [self addimgs];
            
        }
            
          
            
            
        }
            break;
            
            
        default:
            break;
    }



}
    
    
    
    
    
-(void)addimgs{
    
        _countt = 9-self.assetss.count;
        
        ZLPickerViewController *pickerVc = [[ZLPickerViewController alloc] init];
        // 默认显示相册里面的内容SavePhotos
        pickerVc.status = PickerViewShowStatusGroup;
        // 选择图片的最大数
        pickerVc.minCount = _countt;
        pickerVc.count=self.assetss.count;
       // pickerVc.delegate = self;
    
    [self presentViewController:pickerVc animated:YES completion:nil];
    
        pickerVc.callBack = ^(NSArray *assets){
//            NSMutableArray *a = [NSMutableArray arrayWithArray:assets];
//            
//            ZLPickerBrowserPhoto *phonto = [ZLPickerBrowserPhoto photoAnyImageObjWith:<#(id)#>];
//            
//            [self.assetss addObjectsFromArray:a];
//            [self imgView];
//            
            
            for (id dd in assets) {
                
                ZLPickerBrowserPhoto *bro = [ZLPickerBrowserPhoto photoAnyImageObjWith:dd];
                [self.assetss addObject:bro.photoImage];
                
            }
            [self imgView];
            
        };
        
        
    }


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *im = [info objectForKey:UIImagePickerControllerOriginalImage];

    [_assetss addObject:im];
    [self imgView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (textView.text.length==0){
        if ([text isEqualToString:@""]) {
            _labeltext.hidden=NO;
        }else{
            _labeltext.hidden=YES;
        }
    }else{
        if (textView.text.length==1){
            if ([text isEqualToString:@""]) {
                _labeltext.hidden=NO;
            }else{
                _labeltext.hidden=YES;
            }
        }else{
            _labeltext.hidden=YES;
        }
    }
    return YES;
} 

#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"写评价";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"发表" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = BigFont(self.scale);
    [rightBtn setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    rightBtn.frame = CGRectMake(self.view.right-80*self.scale,self.TitleLabel.top,80*self.scale,self.TitleLabel.height);
    [rightBtn addTarget:self action:@selector(allOder) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag=903;
    [self.NavImg addSubview:rightBtn];
    
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
    [self imgBing:nil];
}

-(void)allOder{
    [self.view endEditing:YES];
    
    if (_num==0 || [_tv.text isEqualToString:@""] || _tv.text==nil) {
        [self ShowAlertWithMessage:@"请完善信息后提交"];
        return;
    }
    [self.activityVC startAnimate];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

     NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.user_id,@"user_id",_tv.text,@"content",[NSString stringWithFormat:@"%d",_num],@"rating",@"1",@"comment_type",self.shopid,@"shop_id", nil];
    if (self.is_order_on) {
        [dic setObject:self.order_on forKey:@"sub_order_no"];
    }
    int i=1;
    float scale = 1.0;
    for (ALAsset *asset in self.assetss) {
        ZLPickerBrowserPhoto *zlp = [ZLPickerBrowserPhoto photoAnyImageObjWith:asset];
        UIImage *image = zlp.photoImage;
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
    NSString* usertoken= [[NSUserDefaults standardUserDefaults]objectForKey:@"usertoken"];
    [dic setObject:usertoken forKey:@"usertoken"];
    [AnalyzeObject addCommentWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityVC stopAnimate];
                [self.navigationController popViewControllerAnimated:YES];
                if (_lingshou) {
                    if (_block) {
                        _block(nil);
                    }
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"pingjiresh" object:nil];
            });
        }
    }];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    if (_imgTui) {
        [self tuichu:nil];
    }else{
    
    [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setStartNumber:(NSString *)StartNumber
{
    float star=[StartNumber floatValue];
    if (star>5) {
        star=5;
    }
    if (_start) {
        [_start removeFromSuperview];
        _start=nil;
    }
    _start=[[UIView alloc]initWithFrame:CGRectMake(_fuwuLa.right, _fuwuLa.top+3*self.scale, 15*self.scale, 15*self.scale)];
   // _start.backgroundColor=[UIColor redColor];
    [_fuwu addSubview:_start];
    
    _num=(int)star;
    float setX = 0;
    for (int i=0; i<_num; i++)
    {
        UIButton *starImg=[[UIButton alloc]initWithFrame:CGRectMake(setX, 0, 15*self.scale, 15*self.scale)];
       [starImg setBackgroundImage:[UIImage imageNamed:@"xq_star01"] forState:UIControlStateNormal];
        starImg.tag=i+11;
        [starImg addTarget:self action:@selector(setStart:) forControlEvents:UIControlEventTouchUpInside];
        setX = starImg.right +5*self.scale;
        [_start addSubview:starImg];
        
        _start.width=starImg.right;
    }

    
}


-(void)setStartNumber1:(NSString *)StartNumber
{
    float star=[StartNumber floatValue];
    if (star>5) {
        star=5;
    }
    if (_start1) {
        [_start1 removeFromSuperview];
        _start1=nil;
    }
    _start1=[[UIView alloc]initWithFrame:CGRectMake(_fuwuLa.right, _fuwuLa.top+3*self.scale, 100*self.scale, 15*self.scale)];
    _start1.userInteractionEnabled=YES;
    [_fuwu addSubview:_start1];
    
    int num=(int)star;
    float setX = 0;
    for (int i=0; i<num; i++)
    {
        UIButton *starImg=[[UIButton alloc]initWithFrame:CGRectMake(setX, 0, 15*self.scale, 15*self.scale)];
        [starImg setBackgroundImage:[UIImage imageNamed:@"xq_star03"] forState:UIControlStateNormal];
        starImg.tag=i+1;
        [starImg addTarget:self action:@selector(setStarthui:) forControlEvents:UIControlEventTouchUpInside];
        setX = starImg.right +5*self.scale;
        [_start1 addSubview:starImg];
    }

    
}
-(void)setStarthui:(UIButton *)sender{
    [self setStartNumber:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
}


-(void)setStart:(UIButton *)sender{

    [self setStartNumber:[NSString stringWithFormat:@"%ld",(long)sender.tag-10]];
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
