//
//  BusinessInfoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BusinessInfoViewController.h"
#import "CellView.h"
#import "shopPingJiaViewController.h"
#import "IntroModel.h"
#import "IntroControll.h"
#import "IntroView.h"
#import "IntroControll.h"
#import "UmengCollection.h"
#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface BusinessInfoViewController ()<NSXMLParserDelegate,UIScrollViewDelegate>
{
    int ii;
}
@property(nonatomic,strong)IntroControll *IntroV;
@property(nonatomic,strong)UIScrollView *imgScroll;
@property(nonatomic,strong)UIPageControl *page;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIImageView *startImg;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)CellView *nameCell;
@property(nonatomic,strong)NSMutableDictionary *data;
@property(nonatomic,strong)NSMutableString *soapResults;
@property(nonatomic,strong)UIScrollView *scoll;
@property(nonatomic,strong)NSMutableArray *arr,*yuanArr;
@property(nonatomic,strong)NSString *StartNumber;
@property(nonatomic,strong)reshshoplist block;
@property(nonatomic,strong)IntroControll *intro;
@property(nonatomic,strong)UIImageView *img;
@end

@implementation BusinessInfoViewController


-(void)reshShopList:(reshshoplist)block{
    _block = block;




}
- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [NSMutableDictionary new];
    [self.view addSubview:self.activityVC];
    [self ReshData];
    [self returnVi];
    
}
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

#pragma mark - 数据块
-(void)MoreList{
    _index++;
    [self ReshData];
}
-(void)ReshData
{
    [self.activityVC startAnimate];
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    NSDictionary *dic=@{@"shop_id":self.shop_id};
    if ([Stockpile sharedStockpile].isLogin) {
         dic=@{@"shop_id":self.shop_id,@"user_id":[self getuserid]};
        
        
        
    }
    NSLog(@"%@",dic);
    [analyze queryShopDetailwithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            _data=models;
            [self BigScrollView];
        }
        [self.activityVC stopAnimate];

    }];
    
    
    
}



#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"商家详情";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    
    if ([QQApiInterface isQQSupportApi] && [WXApi isWXAppSupportApi]) {
        UIButton *xiangqing = [UIButton buttonWithType:UIButtonTypeCustom];
        [xiangqing setImage:[UIImage imageNamed:@"gg_top_rightx"] forState:UIControlStateNormal];
        xiangqing.frame=CGRectMake(self.view.width-60*self.scale, self.TitleLabel.top, 60*self.scale, self.TitleLabel.height);
        [xiangqing addTarget:self action:@selector(xiangqingBtn) forControlEvents:UIControlEventTouchUpInside];
//        xiangqing.backgroundColor = [UIColor redColor];
        [self.NavImg addSubview:xiangqing];

    }
    
    
    
    
    
    
}
//获取当前屏幕截屏
//- (UIImage*)screenView:(UIView *)view{
//    CGRect rect = view.frame;
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [view.layer renderInContext:context];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
//}

-(void)xiangqingBtn{



    
    
//    NSArray* imageArray = @[[UIImage imageNamed:@"icon"]];
//
//    if (imageArray) {
//        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"中国最接地气的社区OTO，我们只关注社区服务最后100米，绿城百合，联盟新城，温哥华山庄服务已开通"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:@"fx.mzsq.cc"]
//                                          title:@"拇指社区"
//                                           type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];}

    
    
    
    
    UIImage *ping = [UIImage imageNamed:@"icon"];

    
    
    
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeQQSpace,nil];
    
    id<ISSContent> publishContent;
    
    
    
        publishContent = [ShareSDK content:@"中国最接地气的社区OTO，我们只关注社区服务最后100米，绿城百合，联盟新城，温哥华山庄服务已开通" defaultContent:@"中国最接地气的社区OTO，我们只关注社区服务最后100米，绿城百合，联盟新城，温哥华山庄服务已开通" image:[ShareSDK jpegImageWithImage:ping quality:0.8] title:@"拇指社区" url:@"fx.mzsq.cc" description:@"中国最接地气的社区OTO，我们只关注社区服务最后100米，绿城百合，联盟新城，温哥华山庄服务已开通" mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:nil
                                                      friendsViewDelegate:nil
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
                                    if (state == SSPublishContentStateSuccess)
                                    {
                                        NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                    }
                                }
                                else if (state == SSResponseStateFail){
                                
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                
                            }
                            }];
//    



}


#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)BigScrollView{
    if (_bigScroll) {
        [_bigScroll removeFromSuperview];
    }
    
    _bigScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _bigScroll.contentSize = CGSizeMake(self.view.width, 1000);
    [self.view addSubview:_bigScroll];
    [self topImageVi];

}

#pragma mark ------顶部图片
-(void)topImageVi{

//    _img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*3/4)];
//    [_bigScroll addSubview:_img];
//    [_img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_data[@"shop_zhaopai"]]] placeholderImage:[UIImage imageNamed:@"za"]];
//    

    
    
    _imgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*3/4)];
    _imgScroll.pagingEnabled=YES;
    _imgScroll.delegate=self;
    [_bigScroll addSubview:_imgScroll];
    
    NSInteger count = 0;
    if ([_data[@"shop_zhaopai_arr"] isKindOfClass:[NSArray class]]) {
        _imgScroll.contentSize=CGSizeMake(self.view.width*[_data[@"shop_zhaopai_arr"] count], _imgScroll.height);

        count=[_data[@"shop_zhaopai_arr"] count];
        
    }
    
    if (count==0) {
        UIImageView *topImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*3/4)];
        [topImg setImage:[UIImage imageNamed:@"za"]];
        [_imgScroll addSubview:topImg];
    }
    
    for (int i=0; i<count; i++) {
        UIImageView *topImg = [[UIImageView alloc]initWithFrame:CGRectMake(_imgScroll.width*i, 0, self.view.width, self.view.width*3/4)];
        topImg.tag=1000+i;
        topImg.userInteractionEnabled=YES;
        
        NSString *url=@"";
        NSString *cut = [_data objectForKey:@"shop_zhaopai_arr"][i];
        NSString *imagename = [cut lastPathComponent];
        NSString *path = [cut stringByDeletingLastPathComponent];
        NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb640."]];
//        if (cut.length>0) {
//            url = [cut substringToIndex:[cut length] - 4];
//            
//        }
        
//        [topImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb640.jpg",url]] placeholderImage:[UIImage imageNamed:@"za"]];
        [topImg setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
        topImg.contentMode =  UIViewContentModeScaleAspectFill;
        topImg.clipsToBounds  = YES;

        [_imgScroll addSubview:topImg];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBing:)];
        [topImg addGestureRecognizer:tap];
    }
    
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _imgScroll.bottom-20*self.scale, _imgScroll.width, 20*self.scale)];
    _page.currentPageIndicatorTintColor=blueTextColor;
    _page.pageIndicatorTintColor=[UIColor whiteColor];
    _page.numberOfPages=count;
    [_bigScroll addSubview:_page];
    
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    if (count>0) {
    
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(lunbo) userInfo:nil repeats:YES];
        

    }
       [self BusinessNameAndAdress];
}

-(void)imgBing:(UITapGestureRecognizer *)tap{

    NSMutableArray *pagesArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <[_data[@"shop_zhaopai_arr"] count]; i ++) {
        
        IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:[NSString stringWithFormat:@"%@",_data[@"shop_zhaopai_arr"][i]]];
        
        [pagesArr addObject:model1];
    }
    
    _IntroV = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:pagesArr];
    
    [_IntroV index:tap.view.tag-1000];
    [self.view addSubview:_IntroV];


}

-(void)lunbo{
    if (ii<[_data[@"shop_zhaopai_arr"] count])
    {
        [_imgScroll setContentOffset:CGPointMake((ii)*_imgScroll.width, 0) animated:YES];
        _page.currentPage = ii;
        ii++;
    }else
    {
        ii=0;
        [_imgScroll setContentOffset:CGPointMake((ii)*_imgScroll.width, 0) animated:NO];
        _page.currentPage = ii;
        ii++;
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    ii = scrollview.contentOffset.x / scrollview.frame.size.width;
    [_page setCurrentPage:ii];
}

#pragma mark ------图片下边两个cell，名字和地址；
-(void)BusinessNameAndAdress{
    _shopBigVi = [[UIView alloc]initWithFrame:CGRectMake(0, _imgScroll.bottom, self.view.width,100*self.scale)];
    [_bigScroll addSubview:_shopBigVi];
//名字的cell
    
    _nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50*self.scale)];
    [_shopBigVi addSubview:_nameCell];

    _nameLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 200*self.scale, 20*self.scale)];
    _nameLa.text = [_data objectForKey:@"shop_name"];
    _nameLa.font = DefaultFont(self.scale);
    [_nameCell addSubview:_nameLa];
//    UILabel *startLa = [[UILabel alloc]initWithFrame:CGRectMake(_nameLa.left, _nameLa.bottom, 100*self.scale, 15*self.scale)];
//    startLa.backgroundColor = [UIColor clearColor];
//    [_nameCell addSubview:startLa];
    [self setStartNumber:[_data objectForKey:@"rating"]];
    UIButton *shoucang = [UIButton buttonWithType:UIButtonTypeCustom];
    shoucang.layer.cornerRadius = 4.0f;
    shoucang.layer.borderWidth = .5f;
    shoucang.layer.borderColor = blackLineColore.CGColor;
    shoucang.frame = CGRectMake(self.view.width-190/2.25*self.scale, 15*self.scale, 162/2.25*self.scale, 48/2.25*self.scale);
    [shoucang addTarget:self action:@selector(shouCangEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_nameCell addSubview:shoucang];
    _startImg = [[UIImageView alloc]initWithFrame:CGRectMake(0*self.scale, 0, shoucang.width, shoucang.height)];
    _startImg.tag=909;
    _startImg.image = [UIImage imageNamed:@"xq_sc"];
    [shoucang addSubview:_startImg];
    
    UILabel *titleLa = [[UILabel alloc]initWithFrame:CGRectMake(20*self.scale+5*self.scale, _startImg.top, shoucang.size.width-20, shoucang.height)];
    titleLa.text = @"收藏店铺";
    titleLa.tag=908;
    titleLa.font = Small10Font(self.scale);
    titleLa.textColor = [UIColor blackColor];
    [shoucang addSubview:titleLa];
    
    if ([_data[@"is_collect"] isEqualToString:@"2"]) {
        _startImg.image=[UIImage imageNamed:@"xq_sc_b_1"];
        titleLa.text=@"取消收藏";
        titleLa.textColor=[UIColor whiteColor];
    }
//地址的cell；
    
    
    CellView *adressCell = [[CellView alloc]initWithFrame:CGRectMake(0, _nameCell.bottom, self.view.width, 50*self.scale)];
    [_shopBigVi addSubview:adressCell];
    
    UIImageView *adressImg = [[UIImageView alloc]initWithFrame:CGRectMake(_nameLa.left, 25/2*self.scale, 25*self.scale, 25*self.scale)];
    adressImg.image = [UIImage imageNamed:@"xq_dibiao"];
    [adressCell addSubview:adressImg];
    
    
    UILabel *adressLa = [[UILabel alloc]initWithFrame:CGRectMake(adressImg.right+5*self.scale, adressImg.top, 180*self.scale, 30*self.scale)];
    adressLa.numberOfLines=0;
    adressLa.font = SmallFont(self.scale);
    adressLa.text = [_data objectForKey:@"address"];
    [adressCell addSubview:adressLa];
    
    UIView *shuLine = [[UIView alloc]initWithFrame:CGRectMake(shoucang.left-5*self.scale, 10*self.scale, .5, 30*self.scale)];
    shuLine.backgroundColor = blackLineColore;
    [adressCell addSubview:shuLine];
    
    UIImageView *phoneImg = [[UIImageView alloc]initWithFrame:CGRectMake(shuLine.right+30*self.scale, 5*self.scale, 25*self.scale, 25*self.scale)];
    phoneImg.image = [UIImage imageNamed:@"xq_tel"];
    [adressCell addSubview:phoneImg];
    
    _phoneLa = [[UILabel alloc]initWithFrame:CGRectMake(shuLine.right, phoneImg.bottom, self.view.width-shuLine.centerX, 15*self.scale)];
    _phoneLa.textAlignment = NSTextAlignmentCenter;
    _phoneLa.text =[_data objectForKey:@"hotline"];
    _phoneLa.font = Small10Font(self.scale);
    [adressCell addSubview:_phoneLa];
    
    UIButton *phone = [UIButton buttonWithType:UIButtonTypeCustom];
    phone.frame = CGRectMake(shuLine.centerX, 0, self.view.width-shuLine.centerX, adressCell.height);
    [phone addTarget:self action:@selector(phoneEvent:) forControlEvents:UIControlEventTouchUpInside];
    [adressCell addSubview:phone];
    
    [self shopJieShao];
    
}
//点击电话的事件

-(void)phoneEvent:(UIButton *)sender{
    
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.shop_id forKey:@"shop_id"];
    [dic setObject:_phoneLa.text forKey:@"tel"];
    if ([Stockpile sharedStockpile].isLogin) {
        [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
    }
    
    [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
        }
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_phoneLa.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    }];
    
    
    
    
    

}

//点击收藏店铺的 事件
-(void)shouCangEvent:(UIButton *)sender{
    if ([Stockpile sharedStockpile].isLogin==NO) {
        
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
               LoginViewController *login = [self login];
                [login resggong:^(NSString *str) {
                    [self ReshData];
                    
                }];
            }
            
        }];
        
        return;
    }
  
    
    UIImageView *btn = (UIImageView *)[self.view viewWithTag:909];
    UILabel *btn1 = (UILabel *)[self.view viewWithTag:908];
    AnalyzeObject *anle = [AnalyzeObject new];

//    btn.image=[UIImage imageNamed:@"dian_ico_02"];
    if ([btn1.text isEqualToString:@"收藏店铺"]) {
        
    
        NSString *useid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
        
        NSDictionary *dic = @{@"user_id":useid,@"collect_type":@"2",@"collect_id":self.shop_id};
        
        
        [anle addCollectWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"0"]) {
                [self ShowAlertWithMessage:@"收藏成功"];
                btn.image=[UIImage imageNamed:@"xq_sc_b_1"];
                btn1.text=@"取消收藏";
                btn1.textColor=[UIColor whiteColor];
                if (_block) {
                    _block(@"ok");
                }
            }
        }];

    }else{
        NSDictionary *dic = @{@"user_id":[self getuserid],@"collect_id":self.shop_id};
        [anle delCollectWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"0"]) {
                btn.image=[UIImage imageNamed:@"xq_sc"];
                btn1.text=@"收藏店铺";
                btn1.textColor=[UIColor blackColor];
                
                if (_block) {
                    _block(@"nook");
                }
            }
        }];
    
    }

    
    
     

}

//#pragma mark--店铺公告
//-(void)shopGongGao{
//    _gongGaoCell = [[CellView alloc]initWithFrame:CGRectMake(0, _shopBigVi.bottom+10*self.scale, self.view.width, 100*self.scale)];
//    _gongGaoCell.topline.hidden=NO;
//    [_bigScroll addSubview:_gongGaoCell];
//    
//    UILabel *gonggaoLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
//    gonggaoLa.textAlignment = NSTextAlignmentLeft;
//    gonggaoLa.text = @"店铺公告";
//    gonggaoLa.font=DefaultFont(self.scale);
//    [_gongGaoCell addSubview:gonggaoLa];
//    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(gonggaoLa.left, gonggaoLa.bottom+10*self.scale, self.view.width-20*self.scale, .5)];
//    line.backgroundColor = blackLineColore;
//    [_gongGaoCell addSubview:line];
//    NSString *str = [_data objectForKey:@"notice"];
//    if ([str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]) {
//        str=@"暂无公告";
//    }
//    UILabel *contextLa = [[UILabel alloc]initWithFrame:CGRectMake(gonggaoLa.left, line.bottom+10*self.scale, line.width, 35*self.scale)];
//    contextLa.numberOfLines = 0;
//    contextLa.font=DefaultFont(self.scale);
//    contextLa.text =str;
//    contextLa.textAlignment = NSTextAlignmentLeft;
//    contextLa.textColor = grayTextColor;
//    [_gongGaoCell addSubview:contextLa];
//    [contextLa sizeToFit];
//    
//    _gongGaoCell.height=contextLa.bottom+10*self.scale;
//    
//    [self shopJieShao];
//}

#pragma mark-----店铺介绍
-(void)shopJieShao{

    _jieShaoCell = [[CellView alloc]initWithFrame:CGRectMake(0, _shopBigVi.bottom+10*self.scale, self.view.width, 100*self.scale)];
    _jieShaoCell.topline.hidden=NO;
    [_bigScroll addSubview:_jieShaoCell];
    
    UILabel *jieShaoLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
    jieShaoLa.textAlignment = NSTextAlignmentLeft;
    jieShaoLa.text = @"商家简介";
    jieShaoLa.font=DefaultFont(self.scale);
    [_jieShaoCell addSubview:jieShaoLa];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(jieShaoLa.left, jieShaoLa.bottom+10*self.scale, self.view.width-20*self.scale, .5)];
    line.backgroundColor = blackLineColore;
    [_jieShaoCell addSubview:line];
    
    UILabel *vi = [[UILabel alloc]initWithFrame:CGRectMake(jieShaoLa.left, line.bottom+10*self.scale, line.width, 0*self.scale)];
    vi.font=DefaultFont(self.scale);
    vi.text=[_data objectForKey:@"summary"];
    if ([vi.text isEqualToString:@""]) {
        vi.text=@"暂无简介";
    }
    vi.numberOfLines=0;
    vi.textColor=grayTextColor;
    [_jieShaoCell addSubview:vi];
    [vi sizeToFit];
    _jieShaoCell.height=vi.bottom+10*self.scale;
    [vi sizeToFit];
    [self shopPingJia];
}

#pragma mark--店铺评价
-(void)shopPingJia{

    _pingJiaCell = [[CellView alloc]initWithFrame:CGRectMake(0, _jieShaoCell.bottom+10*self.scale, self.view.width, 44*self.scale)];
    _pingJiaCell.topline.hidden=NO;
    [_bigScroll addSubview:_pingJiaCell];
    
    UILabel *pingJiaLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
    pingJiaLa.textAlignment = NSTextAlignmentLeft;
    pingJiaLa.text = @"店铺评价";
    pingJiaLa.font = DefaultFont(self.scale);
    [_pingJiaCell addSubview:pingJiaLa];
    
    
    UIImageView *jianTouImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-30*self.scale, 8*self.scale, 30*self.scale, 30*self.scale)];
    jianTouImg.image = [UIImage imageNamed:@"xq_right"];
    [_pingJiaCell addSubview:jianTouImg];
    
    UIButton *pingjiaBt = [UIButton buttonWithType:UIButtonTypeCustom];
    pingjiaBt.frame = CGRectMake(0, 0, self.view.width, _pingJiaCell.height);
    [pingjiaBt addTarget:self action:@selector(pingJiaEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_pingJiaCell addSubview:pingjiaBt];
    [self shopXiangQing];

}
-(void)pingJiaEvent:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    shopPingJiaViewController *shopPingJia = [shopPingJiaViewController new];
    shopPingJia.shop_id=self.shop_id;
    [self.navigationController pushViewController:shopPingJia animated:YES];


}


#pragma mark-----店铺详情
-(void)shopXiangQing{

//    float sety=0;
//    
    CellView *xiangQingCell = [[CellView alloc]init];
    xiangQingCell.frame = CGRectMake(0, _pingJiaCell.bottom+10*self.scale, self.view.width,44*self.scale);
    xiangQingCell.topline.hidden=NO;
    [_bigScroll addSubview:xiangQingCell];

    UILabel *xiangQingLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
    xiangQingLa.textAlignment = NSTextAlignmentLeft;
    xiangQingLa.text = @"店铺详情";
    xiangQingLa.font = DefaultFont(self.scale);
    [xiangQingCell addSubview:xiangQingLa];
    [xiangQingLa sizeToFit];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(xiangQingLa.left, xiangQingLa.bottom+10*self.scale, self.view.width-20*self.scale, .5)];
    line.backgroundColor = blackLineColore;
    [xiangQingCell addSubview:line];
    
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, line.bottom+10*self.scale, self.view.width-20*self.scale, 0)];
    la.text=_data[@"detail"];
    [xiangQingCell addSubview:la];
    la.numberOfLines=0;
    la.font=DefaultFont(self.scale);
    [la sizeToFit];
    
    
    xiangQingCell.height=la.bottom+10*self.scale;
    

    
    _arr = [NSMutableArray new];
    _yuanArr = [NSMutableArray new];
    
    
    
    for (int i=0; i<9; i++) {
        NSString *is = _data[[NSString stringWithFormat:@"img%d",i+1]];
        
        
        if (is!=nil && ![is isEqualToString:@""]) {
            
            NSString *url=@"";
            NSString *cut = is;
            [_yuanArr addObject:is];
//            if (cut.length>0) {
//                url = [cut substringToIndex:[cut length] - 4];
//                url = [NSString stringWithFormat:@"%@_thumb320.jpg",url];
//                
//            }
            NSString *imagename = [cut lastPathComponent];
            NSString *path = [cut stringByDeletingLastPathComponent];
            NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb320."]];

            [_arr addObject:smallImgUrl];
        }
    }
    
    float scrollBottomY = 0.0;
    
    if (_arr.count<=0 && [la.text isEqualToString:@""]) {
        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, line.bottom+10*self.scale, self.view.width, 20*self.scale)];
        la.text=@"暂无详情";
        la.font=DefaultFont(self.scale);
        la.textColor=grayTextColor;
        [xiangQingCell addSubview:la];
        scrollBottomY=la.bottom+0*self.scale;
        xiangQingCell.height=scrollBottomY+10*self.scale;

    }else
    {
        scrollBottomY=la.bottom+0*self.scale;
        xiangQingCell.height=scrollBottomY+10*self.scale;

    
    }
    

    
    
    float W=(self.view.width-40*self.scale)/3;
    for (int i=0; i<_arr.count; i++) {
        
        float x = (W+10*self.scale)*(i%3);
        float y = (W-10*self.scale)*(i/3);
        
        
        NSString *im1 = _arr[i];
        
        UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(x+10*self.scale, la.bottom+y+10*self.scale, W, W*0.75)];
        [im setImageWithURL:[NSURL URLWithString:im1] placeholderImage:[UIImage imageNamed:@"center_img"]];
        im.tag=i+1;

        im.contentMode =  UIViewContentModeScaleAspectFill;
        im.clipsToBounds  = YES;
        
        im.userInteractionEnabled=YES;
        [xiangQingCell addSubview:im];
        
        scrollBottomY = im.bottom;
        
        UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
        
        [im addGestureRecognizer:tap1];
        xiangQingCell.height=scrollBottomY+10*self.scale;

    }

  
//    sety=xiangQingCell.bottom+10*self.scale;
    _bigScroll.contentSize = CGSizeMake(self.view.width, xiangQingCell.bottom+10*self.scale);
    
    

    
}




-(void)BigImage:(UITapGestureRecognizer *)tap{
//    NSMutableArray *a = [NSMutableArray new];
//    
//    
//    for (int i=0; i<9; i++) {
//        NSString *str = [NSString stringWithFormat:@"img%d",i+1];
//        NSString *na = _dataSource[0][str];
//        if (![na isEqualToString:@""]) {
//            [a addObject:na];
//            
//        }
//        
//    }
    
    
    NSMutableArray *pagesArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < _yuanArr.count; i ++) {
        
        IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:[NSString stringWithFormat:@"%@",_yuanArr[i]]];
        [pagesArr addObject:model1];
    }
    
    _intro = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:pagesArr];
    [_intro index:tap.view.tag-1];
    //  _intro.delegate=self;
    self.tabBarController.tabBar.hidden=YES;
    
    
    
    [[[UIApplication sharedApplication].delegate window] addSubview:_intro];
    
    
    
}

//-(void)BigImage{
////    _scoll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
////    _scoll.backgroundColor=[UIColor blackColor];
////    _scoll.contentSize = CGSizeMake(self.view.width*_arr.count, self.view.height);
////    _scoll.pagingEnabled=YES;
////
////    [self.view addSubview:_scoll];
////    float setY=0;
////    for (int i=0; i<_arr.count; i++) {
////        UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(setY, 0, self.view.width, self.view.height)];
////        im.contentMode=UIViewContentModeScaleAspectFit;
////        [im setImageWithURL:[NSURL URLWithString:_arr[i]] placeholderImage:[UIImage imageNamed:@"center_img"]];
////        im.userInteractionEnabled=YES;
////        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(change)];
////        [im addGestureRecognizer:tap];
////        [_scoll addSubview:im];
////        setY=im.right;
////    }
//
//}
//-(void)change{
//    
//    [UIView animateWithDuration:.3 animations:^{
//        _scoll.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//        [_scoll removeFromSuperview];
//    } completion:^(BOOL finished) {
//        
//        
//    }];
//    
//}

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
    _start=[[UIView alloc]initWithFrame:CGRectMake(_nameLa.left, _nameLa.bottom+5*self.scale, [StartNumber intValue]*13*self.scale, 15*self.scale)];
    [_nameCell addSubview:_start];
    
    UILabel *fen = [[UILabel alloc]initWithFrame:CGRectMake(_start.right, _start.top-2*self.scale, 50*self.scale, 15*self.scale)];
    if (StartNumber==nil || [StartNumber isEqualToString:@""]) {
        StartNumber=@"0";
        _StartNumber=StartNumber;
    }
    
    fen.text=[NSString stringWithFormat:@"%@分",StartNumber];
    fen.textColor = [UIColor redColor];
    fen.font=SmallFont(self.scale);
    [_nameCell addSubview:fen];
    
    int num=(int)star;
    float setX = 0;
    for (int i=0; i<num; i++)
    {
        UIImageView *starImg=[[UIImageView alloc]initWithFrame:CGRectMake(setX, 0, 10*self.scale, 10*self.scale)];
        starImg.image=[UIImage imageNamed:@"xq_star01"];
        setX = starImg.right +3*self.scale;
        [_start addSubview:starImg];
    }
    
    if ([[_data objectForKey:@"rating"] isEqualToString:@""] || [[_data objectForKey:@"rating"] isKindOfClass:[NSNull class]] || [[_data objectForKey:@"rating"] isEqualToString:@"0"]) {
        fen.text=@"";
    }
    if (star>num)
    {
        UIImageView *starImg=[[UIImageView alloc]initWithFrame:CGRectMake(setX, 0, 10*self.scale, 10*self.scale)];
        starImg.image=[UIImage imageNamed:@"xq_star02"];
        [_start addSubview:starImg];
    }
  //  self.scoreLa.text=[NSString stringWithFormat:@"%@分",StartNumber];
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
