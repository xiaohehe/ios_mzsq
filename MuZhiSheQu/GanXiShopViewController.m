//
//  GanXiShopViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GanXiShopViewController.h"
#import "CellView.h"
#import "BusinessInfoViewController.h"
#import "IntroView.h"
#import "IntroControll.h"
#import "UmengCollection.h"
@interface GanXiShopViewController ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UIWebViewDelegate>

{
    int ii;
}

@property(nonatomic,strong)UIScrollView *imgScroll;
@property(nonatomic,strong)UIPageControl *page;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)IntroControll *IntroV;
@property(nonatomic,strong)UIView *bigTopVi;
@property(nonatomic,strong)CellView *beizhuCell,*jianjieCell,*gongGaoCell,*timeCell,*serviceCell,*CellView ,*nameCell;
@property(nonatomic,strong)UITextView *contextLa;
@property(nonatomic,strong)NSDictionary *data;
@property(nonatomic,strong)NSMutableArray *btnArry;
@property(nonatomic,strong)reshshocuang block;

@property(nonatomic,assign)BOOL isHaveItem;
@end


@implementation GanXiShopViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    self.navigationController.navigationBarHidden=YES;
//    [self remind];·
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}
-(void)reshshoucahng:(reshshocuang)block{

    _block=block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _data=[NSMutableDictionary new];
    _btnArry = [NSMutableArray new];
    // Do any additional setup after loading the view.
    ii=1;
    //@"今天",
    _DayArr=[NSArray arrayWithObjects:@"今天", @"明天", nil];
    _TimeArr=[[NSMutableArray alloc]init];
    _TodayArr=[[NSMutableArray alloc]init];
    _DataArr=[[NSMutableArray alloc]init];
    [_TodayArr addObject:@"1小时送达"];
    for(int i=0;i<24;i++)
    {
        NSString *Time=[NSString stringWithFormat:@"%d:00-%d:00",i,i+1];
        [_TimeArr addObject:Time];
    }
    _DataArr=_TimeArr;
    [self BigScrollView];
    [self topImageVi];
    [self BusinessNameAndAdress];
   // [self jianJie];
    [self GongGaoShop];
    [self ServiceProject];
    [self sendTime];
    [self beizhu];
    //[self botVi];
    [self returnVi];
    [self reshData];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keywillchange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keywillhhh:) name:UIKeyboardWillHideNotification object:nil];

    
}
-(void)keywillchange:(NSNotification *)notification{

    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        //_mainScrollView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width,  rect.origin.y-self.NavImg.bottom);
        //        float =
        //        self.view.bottom=
        //
        //_vi.bottom=rect.origin.y;
        
        self.view.bottom=rect.origin.y+49*self.scale;
    }];
    
    


}

-(void)keywillhhh:(NSNotification *)notification{
    
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


-(void)reshData{
//    [self.view addSubview:self.activityVC];
//    [self.activityVC startAnimate];
//    NSDictionary *dic=@{@"shop_id":self.ID};
//    if ([Stockpile sharedStockpile].isLogin) {
//        dic=@{@"shop_id":self.ID,@"user_id":[self getuserid]};
//    }
//    
//    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
//    [analyze queryShopDetailwithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
//        [self.activityVC stopAnimate];
//
//        if ([code isEqualToString:@"0"]) {
    
    
    
    if (_isPush)
    {
         AnalyzeObject *anle = [AnalyzeObject new];
        NSLog(@"%@",[self getCommid]);
        NSDictionary * dict = @{@"community_id":[self getCommid],@"shop_id":self.shop_id};
        
        NSLog(@"%@",dict);
        [anle shangjialPush:dict Block:^(id models, NSString *code, NSString *msg) {
            
            if ([code isEqualToString:@"0"]) {
                
                _data = models[0];
                NSLog(@"reshData====%@",_data);
                self.TitleLabel.text =_data[@"shop_name"];
                 [self BigScrollView];
                
                
            }
        }];
    }
    else
    {
        _data=_zongshuju;
        [self BigScrollView];
    }
    
//            if (_issleep) {
//                [self ShowAlertWithMessage:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"];
//            }
//            [self remind];

//        }
//        
//    }];
    


}

-(void)BigScrollView{
    if (_bigScroll ) {
        [_bigScroll removeFromSuperview];
    }
    
    _bigScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-49-64)];
    _bigScroll.contentSize = CGSizeMake(self.view.width, 1000);
    [self.view addSubview:_bigScroll];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xialuo)];
    [_bigScroll addGestureRecognizer:tap];
    
    
    [self topImageVi];
    
}

-(void)xialuo{
    [self.view endEditing:YES];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}
#pragma mark ------顶部图片
-(void)topImageVi{
    
    NSLog(@"topImageVi==%@",_data);
    _imgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.width, self.view.width*3/4)];
    _imgScroll.pagingEnabled=YES;
    _imgScroll.delegate=self;
    [_bigScroll addSubview:_imgScroll];
    
    NSInteger count=0;
    
    if ([_data[@"shop_zhaopai"] isKindOfClass:[NSArray class]]) {
        count=[_data[@"shop_zhaopai"] count];
    }
    _imgScroll.contentSize=CGSizeMake(self.view.width*count, _imgScroll.height);
    
    for (int i=0; i<count; i++) {
        UIImageView *topImg = [[UIImageView alloc]initWithFrame:CGRectMake(_imgScroll.width*i, 0, self.view.width, self.view.width*3/4)];
        topImg.tag=1000+i;
        NSString *url=@"";
        NSString *cut = [NSString stringWithFormat:@"%@",[_data objectForKey:@"shop_zhaopai"][i]];
        NSString *imagename = [cut lastPathComponent];
        NSString *path = [cut stringByDeletingLastPathComponent];
        NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"."]];
//        NSArray * tuPianarray = [cut componentsSeparatedByString:@"."];
//        if (cut.length>0) {
//            url = [cut substringToIndex:[cut length] - 4];
//            
//            NSLog(@"pingjie%@",tuPianarray[0]);
//            for (int i = 0; i<tuPianarray.count-1; i++)
//            {
//                if (i == 0)
//                {
//                    url = tuPianarray[0];
//                }
//                else
//                {
//                    url = [NSString stringWithFormat:@"%@.%@",url,tuPianarray[i]];
//                }
//                
//            }
//        }

        
//        [topImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb640.%@",url,[tuPianarray lastObject]]] placeholderImage:[UIImage imageNamed:@"za"]];
         [topImg setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
        topImg.contentMode=UIViewContentModeScaleAspectFill;
        topImg.clipsToBounds=YES;
        topImg.userInteractionEnabled=YES;
        [_imgScroll addSubview:topImg];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgbig:)];
        [topImg addGestureRecognizer:tap];
        
        
    }

    if (count==0) {
        UIImageView *topImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(_imgScroll.width*0, 0, self.view.width, self.view.width*3/4)];
        [topImg1 setImage:[UIImage imageNamed:@"za"]];
        [_imgScroll addSubview:topImg1];

    }
    
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _imgScroll.bottom-20*self.scale, _imgScroll.width, 20*self.scale)];
    _page.currentPageIndicatorTintColor=[UIColor redColor];
    _page.pageIndicatorTintColor=[UIColor grayColor];
    _page.numberOfPages=[_data[@"shop_zhaopai"] count];
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

-(void)imgbig:(UITapGestureRecognizer *)tap{

    NSMutableArray *pagesArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <[_data[@"shop_zhaopai"] count]; i ++) {
        
        IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:[NSString stringWithFormat:@"%@",_data[@"shop_zhaopai"][i]]];
        
        [pagesArr addObject:model1];
    }
    
    _IntroV = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:pagesArr];
    
    [_IntroV index:tap.view.tag-1000];
    [self.view addSubview:_IntroV];
    

}

-(void)lunbo{
    if (ii<[_data[@"shop_zhaopai"] count])
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
    
    _nameLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 0*self.scale, 200*self.scale, 50*self.scale)];
    _nameLa.text = [_data objectForKey:@"shop_name"];
    _nameLa.font = DefaultFont(self.scale);
    [_nameCell addSubview:_nameLa];
    
    
    _start = [[UILabel alloc]initWithFrame:CGRectMake(_nameLa.left, _nameLa.bottom+5*self.scale, [[_data objectForKey:@"rating"] intValue]*13*self.scale, 15*self.scale)];
    _start.backgroundColor = [UIColor clearColor];
    [_nameCell addSubview:_start];
    [self setStartNumber:[_data objectForKey:@"rating"]];
    

    
    UIButton *shoucang = [UIButton buttonWithType:UIButtonTypeCustom];
    shoucang.layer.cornerRadius = 4.0f;
    shoucang.layer.borderWidth = .5f;
    shoucang.layer.borderColor = blackLineColore.CGColor;
    shoucang.frame = CGRectMake(self.view.width-190/2.25*self.scale, 15*self.scale, 162/2.25*self.scale, 48/2.25*self.scale);
    [shoucang addTarget:self action:@selector(shouCangEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_nameCell addSubview:shoucang];
    
    _startImg = [[UIImageView alloc]initWithFrame:CGRectMake(5*self.scale, 2.5*self.scale, 15*self.scale, 15*self.scale)];
    _startImg.tag=909;
    _startImg.image = [UIImage imageNamed:@"dian_ico_02"];
    [shoucang addSubview:_startImg];
    shoucang.alpha=0;
    
//    UILabel *titleLa = [[UILabel alloc]initWithFrame:CGRectMake(_startImg.right+5*self.scale, _startImg.top, shoucang.size.width-20, 15*self.scale)];
//    titleLa.text = @"收藏店铺";
//    titleLa.tag=908;
//    
//    titleLa.font = Small10Font(self.scale);
//    [shoucang addSubview:titleLa];
//    
//    if ([_data[@"is_collect"] isEqualToString:@"2"]) {
//        _startImg.image=[UIImage imageNamed:@"12"];
//        titleLa.text=@"取消收藏";
//        titleLa.textColor=blueTextColor;
//    }
    
    
    
    
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
    adressCell.height=adressLa.bottom+10*self.scale;
    
    
    UIView *shuLine = [[UIView alloc]initWithFrame:CGRectMake(shoucang.left-5*self.scale, 10*self.scale, .5, 30*self.scale)];
    shuLine.backgroundColor = blackLineColore;
    [adressCell addSubview:shuLine];
    
    UIImageView *phoneImg = [[UIImageView alloc]initWithFrame:CGRectMake(shuLine.right+30*self.scale, 5*self.scale, 25*self.scale, 25*self.scale)];
    phoneImg.image = [UIImage imageNamed:@"xq_tel"];
    [adressCell addSubview:phoneImg];
    
    UILabel *phoneLa = [[UILabel alloc]initWithFrame:CGRectMake(shuLine.right, phoneImg.bottom, self.view.width-shuLine.centerX, 15*self.scale)];
    phoneLa.textAlignment = NSTextAlignmentCenter;
    phoneLa.text = [_data objectForKey:@"hotline"];
    phoneLa.font = Small10Font(self.scale);
    [adressCell addSubview:phoneLa];
    
    UIButton *phone = [UIButton buttonWithType:UIButtonTypeCustom];
    phone.frame = CGRectMake(shuLine.centerX, 0, self.view.width-shuLine.centerX, adressCell.height);
    [phone addTarget:self action:@selector(phoneEvent:) forControlEvents:UIControlEventTouchUpInside];
    [adressCell addSubview:phone];
    
    [self GongGaoShop];
    
}

-(void)shouCangEvent:(UIButton *)sender{
    if ([Stockpile sharedStockpile].isLogin==NO) {
        
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                [self login];
            }
            
        }];
        
        return;
    }

    
    

    UIImageView *btn = (UIImageView *)[self.view viewWithTag:909];
    UILabel *btn1 = (UILabel *)[self.view viewWithTag:908];
    AnalyzeObject *anle = [AnalyzeObject new];

    
    if ([btn1.text isEqualToString:@"取消收藏"]) {
        
        NSDictionary *dic = @{@"user_id":[self getuserid],@"collect_type":@"2",@"collect_id":self.ID};
        [anle delCollectWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"0"]) {
                //[self ShowAlertWithMessage:@"收藏成功"];
                btn.image=[UIImage imageNamed:@"dian_ico_02"];
                btn1.text=@"收藏店铺";
                btn1.textColor=blackTextColor;
                if (_block) {
                    _block(@"ok");
                }
            }
            
        }];

        
        
       
        return;
        
    }
 
    
    
    NSDictionary *dic = @{@"user_id":[self getuserid],@"collect_type":@"2",@"collect_id":self.ID};
    
    
    [anle addCollectWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            [self ShowAlertWithMessage:@"收藏成功"];
            btn.image=[UIImage imageNamed:@"12"];
            btn1.text=@"取消收藏";
            btn1.textColor=blueTextColor;
            if (_block) {
                _block(@"ok");
            }
            
        }
    }];

  
    
   

    

}

//#pragma mark--简介
//-(void)jianJie{
//    _jianjieCell = [[CellView alloc]initWithFrame:CGRectMake(0, _shopBigVi.bottom+10*self.scale, self.view.width, 100*self.scale)];
//    [_bigScroll addSubview:_jianjieCell];
//    
//    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _jianjieCell.width, .5)];
//    topLine.backgroundColor=blackLineColore;
//    [_jianjieCell addSubview:topLine];
//    
//    UILabel *jianJieLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
//    jianJieLa.textAlignment = NSTextAlignmentLeft;
//    jianJieLa.text = @"商家简介";
//    jianJieLa.font=DefaultFont(self.scale);
//    [_jianjieCell addSubview:jianJieLa];
//    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(jianJieLa.left, jianJieLa.bottom+10*self.scale, self.view.width-20*self.scale, .5)];
//    line.backgroundColor = blackLineColore;
//    [_jianjieCell addSubview:line];
//    
//    
//    UILabel *contextLa = [[UILabel alloc]initWithFrame:CGRectMake(jianJieLa.left, line.bottom+10*self.scale, line.width, 0)];
//    contextLa.textAlignment = NSTextAlignmentLeft;
//    contextLa.text = [_data objectForKey:@"summary"];
//    contextLa.numberOfLines = 0;
//    contextLa.font=DefaultFont(self.scale);
//    contextLa.textColor = grayTextColor;
//    [_jianjieCell addSubview:contextLa];
//    [contextLa sizeToFit];
//    
////    CGSize size = [self sizetoFitWithString:contextLa.text];
////    contextLa.height = size.height;
//    _jianjieCell.height = contextLa.bottom+10*self.scale;
////    [self GongGaoShop];
//    
//}


#pragma mark -------提示下单事件的view
-(float)remind{
    
    if (_bigTopVi) {
        [_bigTopVi removeFromSuperview];
    }
    
    _bigTopVi = [[UIView alloc]initWithFrame:CGRectMake(0,self.NavImg.bottom, self.view.bounds.size.width, 70/2.25*self.scale)];
    [_bigTopVi setBackgroundColor:[UIColor colorWithRed:250/255.0 green:255/255.0 blue:182/255.0 alpha:1]];
    [self.view addSubview:_bigTopVi];
    
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30*self.scale, _bigTopVi.height)];
    bg.backgroundColor=[UIColor colorWithRed:250/255.0 green:255/255.0 blue:182/255.0 alpha:1];
    [_bigTopVi addSubview:bg];
    
    
    UIButton *gbImg = [[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, _bigTopVi.height/2-6*self.scale, 12*self.scale, 12*self.scale)];
    gbImg.backgroundColor=[UIColor colorWithRed:250/255.0 green:255/255.0 blue:182/255.0 alpha:1];
    [gbImg setImage:[UIImage imageNamed:@"dian_xiaoxi"] forState:0];
    [bg addSubview:gbImg];
    
    
    UILabel *remLa = [[UILabel alloc]initWithFrame:CGRectMake(30*self.scale,gbImg.top-0*self.scale,self.view.bounds.size.width-25*self.scale,70/2.25*self.scale)];
    remLa.font = [UIFont systemFontOfSize:10];
    remLa.textAlignment = NSTextAlignmentCenter;
    remLa.textColor = grayTextColor;
    remLa.tag=654;
    if (self.gonggao==nil || [self.gonggao isEqualToString:@""]) {
        remLa.text= @"暂无公告";
    }else{
        
        remLa.text= self.gonggao;
    }
    
    if (_issleep) {
        remLa.text=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
        remLa.textColor=[UIColor redColor];
    }
    
    remLa.textAlignment=NSTextAlignmentLeft;
    [remLa sizeToFit];
    _bigTopVi.height=remLa.bottom+10*self.scale;
    [_bigTopVi addSubview:remLa];
    
    if (remLa.width>self.view.width-22*self.scale) {
        CGRect frame = remLa.frame;
        frame.origin.x = self.view.width;
        remLa.frame = frame;
        
        [UIView beginAnimations:@"testAnimation" context:NULL];
        [UIView setAnimationDuration:20];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationRepeatCount:999999];
        
        frame = remLa.frame;
        frame.origin.x = -frame.size.width;
        remLa.frame = frame;
        [UIView commitAnimations];
        
        

    }
    [_bigTopVi addSubview:bg];
    bg.height=_bigTopVi.height;

    
    
    
    return _bigTopVi.height;
    
}

#pragma mark------本店公告
-(void)GongGaoShop{
//    _gongGaoCell = [[CellView alloc]initWithFrame:CGRectMake(0, _jianjieCell.bottom+10*self.scale, self.view.width, 100*self.scale)];
//    [_bigScroll addSubview:_gongGaoCell];
//    
//    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _jianjieCell.width, .5)];
//    topLine.backgroundColor=blackLineColore;
//    [_gongGaoCell addSubview:topLine];
//    
//    UILabel *jianJieLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
//    jianJieLa.textAlignment = NSTextAlignmentLeft;
//    jianJieLa.text = @"本店公告";
//    jianJieLa.font=DefaultFont(self.scale);
//    [_gongGaoCell addSubview:jianJieLa];
//    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(jianJieLa.left, jianJieLa.bottom+10*self.scale, self.view.width-20*self.scale, .5)];
//    line.backgroundColor = blackLineColore;
//    [_gongGaoCell addSubview:line];
//
//    
//    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(jianJieLa.left, line.bottom+10*self.scale, line.width,150*self.scale)];
//    la.font=DefaultFont(self.scale);
//    la.textColor=grayTextColor;
//        [_gongGaoCell addSubview:la];
//   
//    NSString *str =[_data objectForKey:@"notice"];
//    if ([str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]) {
//        str=@"暂无公告";
//    }
//    la.text=str;
//     [la sizeToFit];
//    
//    _gongGaoCell.height = la.bottom+10*self.scale;
    if (_data) {
        NSLog(@"%@",_data);
    }
    
    if ([_data[@"serve_item"] count]==0) {
        _isHaveItem=NO;
        [self jianJie];
    }else{
        _isHaveItem=YES;
        if (_jianjieCell) {
            [_jianjieCell removeFromSuperview];
        }
         [self ServiceProject];
        
    }
   
}



#pragma mark----服务项目;
-(void)ServiceProject{
    _serviceCell = [[CellView alloc]initWithFrame:CGRectMake(0, _shopBigVi.bottom+10*self.scale, self.view.width, 215/2.25*self.scale)];
    _serviceCell.topline.hidden=NO;
    [_bigScroll addSubview:_serviceCell];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _jianjieCell.width, .5)];
    topLine.backgroundColor=blackLineColore;
    [_serviceCell addSubview:topLine];
    
    UILabel *serviceLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, self.view.width, 20*self.scale)];
    serviceLa.text = @"服务项目";
    serviceLa.textColor=blueTextColor;
    serviceLa.font=[UIFont fontWithName:@"Helvetica-Bold" size:14*self.scale];
    [_serviceCell addSubview:serviceLa];
    [serviceLa sizeToFit];
    
    UILabel *xuanze = [[UILabel alloc]initWithFrame:CGRectMake(serviceLa.right, serviceLa.top, 0, 20*self.scale)];
    xuanze.text=@"（请选择）";
    xuanze.textColor=blueTextColor;

    xuanze.font=DefaultFont(self.scale);
    [xuanze sizeToFit];
    [_serviceCell addSubview:xuanze];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(serviceLa.left, serviceLa.bottom+10*self.scale, self.view.width-20*self.scale, .5)];
    line.backgroundColor = blackLineColore;
    [_serviceCell addSubview:line];
    

    
    UIView *bigProjectVi = [[UIView alloc]initWithFrame:CGRectMake(line.left, line.bottom, self.view.width-20*self.scale, 137/2.25*self.scale)];
    _serviceCell.height = bigProjectVi.bottom;
    [_serviceCell addSubview:bigProjectVi];

    
    float W=(self.view.width-40*self.scale)/2;
    

    
    for (int i =0; i<[[_data objectForKey:@"serve_item"] count];  i++) {
        float x = (W+20*self.scale)*(i%2);
        float y = (W-105*self.scale)*(i/2);

        
            UIButton *serviceImg = [[UIButton alloc]initWithFrame:CGRectMake(x+0*self.scale, y+10*self.scale, W-0*self.scale, 27.5*self.scale)];
            serviceImg.tag=101+i;
        [serviceImg setTitle:[[_data objectForKey:@"serve_item"][i] objectForKey:@"item_name"] forState:0];
        serviceImg.titleLabel.font=SmallFont(self.scale);
        [serviceImg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [serviceImg setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [serviceImg setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
            [serviceImg setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateSelected];
            [bigProjectVi addSubview:serviceImg];
            [_btnArry addObject:serviceImg];
        [serviceImg addTarget:self action:@selector(selerEvent:) forControlEvents:UIControlEventTouchUpInside];
        bigProjectVi.height=serviceImg.bottom+10*self.scale;

        
        _serviceCell.height=bigProjectVi.bottom+5*self.scale;
        
        }
    
    
    
    
    [self sendTime];
}




-(void)selerEvent:(UIButton *)sender{
    sender.selected=!sender.selected;

    
    

    
//    UIButton *btn = (UIButton *)[self.view viewWithTag:sender.tag-100];
//    btn.selected=!btn.selected;
    
    
}

#pragma mark-------配送时间;
-(void)sendTime{
    _timeCell = [[CellView alloc]initWithFrame:CGRectMake(0, _serviceCell.bottom+10*self.scale, self.view.width, 44*self.scale)];
    _timeCell.tag=999;
    _timeCell.title = @"预约时间";
    [_timeCell ShowRight:YES];
    
    _timeCell.contentLabel.text = @"立即上门";
    _timeCell.contentLabel.height=30*self.scale;
    _timeCell.contentLabel.centerY=_timeCell.height/2;
    _songTime=@"1";
    _timeCell.contentLabel.textAlignment = NSTextAlignmentRight;
    _timeCell.contentLabel.textColor = grayTextColor;
    [_bigScroll addSubview:_timeCell];

    
//    UIImageView *jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-40*self.scale, _timeCell.height/2-10*self.scale, 10*self.scale, 20*self.scale)];
//    jiantou.image = [UIImage imageNamed:@"dd_right"];
//    [_timeCell addSubview:jiantou];
    
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _jianjieCell.width, .5)];
    topLine.backgroundColor=blackLineColore;
    [_timeCell addSubview:topLine];
    
    UIButton *peiTime = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _timeCell.width, _timeCell.height)];
    [peiTime addTarget:self action:@selector(timeEvent) forControlEvents:UIControlEventTouchUpInside];
    [_timeCell addSubview:peiTime];
    
    [self beizhu];

}

-(void)timeEvent{
    [self.view endEditing:YES];
    _big = [[UIControl alloc]initWithFrame:self.view.bounds];
    _big.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [self.view addSubview:_big];
    
    _SelectImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height+180*self.scale)];
    _SelectImg.userInteractionEnabled=YES;
    _SelectImg.backgroundColor= [UIColor whiteColor];
    [self.view addSubview:_SelectImg];
    
    [UIView animateWithDuration:.3 animations:^{
        _big.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.6];        _SelectImg.frame=CGRectMake(0, self.view.height-180*self.scale, self.view.width, 180*self.scale);
        
        
        
    }];
 
    
    
    _TimePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,_SelectImg.height/2-40*self.scale, self.view.width, 120*self.scale)];
    _TimePickerView.delegate = self;
    _TimePickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _TimePickerView.dataSource = self;
    [_SelectImg addSubview:_TimePickerView];
    
    UIButton *canBtn=[[UIButton alloc]initWithFrame:CGRectMake(30*self.scale, _TimePickerView.top-40*self.scale, 60*self.scale, 30*self.scale)];
    [canBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [canBtn addTarget:self action:@selector(actionDone:) forControlEvents:UIControlEventTouchUpInside];
    canBtn.tag=1;
    [canBtn setTitle:@"取消" forState:UIControlStateNormal];
    canBtn.titleLabel.textColor=[UIColor whiteColor];
    canBtn.titleLabel.font=Big16Font(self.scale);
    [_SelectImg addSubview:canBtn];
    
    UIButton *OKBtn=[[UIButton alloc]initWithFrame:CGRectMake(_SelectImg.width-90*self.scale, _TimePickerView.top-40*self.scale, 60*self.scale, 30*self.scale)];
    [OKBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [OKBtn addTarget:self action:@selector(actionDone:) forControlEvents:UIControlEventTouchUpInside];
    OKBtn.titleLabel.font=Big16Font(self.scale);
    
    [OKBtn setTitle:@"确定" forState:UIControlStateNormal];
    OKBtn.titleLabel.textColor=[UIColor whiteColor];
    OKBtn.tag=2;
    [_SelectImg addSubview:OKBtn];
    
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, .5)];
    topline.backgroundColor=blackLineColore;
    [_SelectImg addSubview:topline];

}

-(void)actionDone:(UIButton *)button{
    
    if (button.tag == 1) {
        [UIView animateWithDuration:.5 animations:^{
            _SelectImg.frame=CGRectMake(0, self.view.height, self.view.width, self.view.height+180*self.scale);
            _big.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        }completion:^(BOOL finished) {
            [_big removeFromSuperview];
            
            
        }];
        return;
    }
    
    NSString *str =@"";
    str =[NSString stringWithFormat:@"%@ %@",[_DayArr objectAtIndex:[_TimePickerView selectedRowInComponent:0]],[_DataArr objectAtIndex:[_TimePickerView selectedRowInComponent:1]]];
   
    CellView *btn = (CellView *)[self.view viewWithTag:999];
    
    btn.contentLabel.text=str;
    
    
    NSArray *dateArr = [str componentsSeparatedByString:@" "];
    
    NSString *fen = dateArr[1];
    //用户选择的几点几分 fenarr[0]；
    NSArray *fenarr = [fen componentsSeparatedByString:@"-"];
    
    
    if ([dateArr[0] isEqualToString:@"今天"]) {
        
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd "];
        NSString *string = [formatter stringFromDate:date];
        
        str = [string stringByAppendingString:fenarr[0]];
        
        
    }else{
        NSDate *date = [NSDate date];
        NSDate *newDate = [date dateByAddingTimeInterval:60 * 60 * 24 * 1];
        
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd "];
        NSString *string = [formatter stringFromDate:newDate];
        
        str = [string stringByAppendingString:fenarr[0]];
        
        
    }
    
    _songTime=str;

    
    
    [UIView animateWithDuration:.5 animations:^{
        _SelectImg.frame=CGRectMake(0, self.view.height, self.view.width, self.view.height+180*self.scale);
        _big.alpha=0;
    }completion:^(BOOL finished) {
        
        [_big removeFromSuperview];
        
    }];
    
}




#pragma mark-----备注信息；

-(void)beizhu{
    _beizhuCell = [[CellView alloc]initWithFrame:CGRectMake(0, _timeCell.bottom+10*self.scale, self.view.width, 100*self.scale)];
    [_bigScroll addSubview:_beizhuCell];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _jianjieCell.width, .5)];
    topLine.backgroundColor=blackLineColore;
    [_beizhuCell addSubview:topLine];
    
    UILabel *beizhuLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
    beizhuLa.textAlignment = NSTextAlignmentLeft;
    beizhuLa.text = @"备注";
    beizhuLa.font=DefaultFont(self.scale);
    [_beizhuCell addSubview:beizhuLa];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(beizhuLa.left, beizhuLa.bottom+10*self.scale, self.view.width-20*self.scale, .5)];
    line.backgroundColor = blackLineColore;
    [_beizhuCell addSubview:line];
    
    
    _contextLa = [[UITextView alloc]initWithFrame:CGRectMake(beizhuLa.left, line.bottom+10*self.scale, line.width, 35*self.scale)];
//    _contextLa.placeholder=@"请输入备注信息";
    _contextLa.delegate=self;
    _contextLa.font=DefaultFont(self.scale);
    [_beizhuCell addSubview:_contextLa];

    
    UILabel *bb = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 0*self.scale, self.view.width, _contextLa.height)];
    bb.text=@"请输入备注信息";
    bb.tag=99999999;
    bb.font=DefaultFont(self.scale);
    bb.textColor=blackLineColore;
    [_contextLa addSubview:bb];
    
//    CGSize size = [self sizetoFitWithString:_contextLa.text];
//    _contextLa.height = size.height;
    _beizhuCell.height = _contextLa.bottom+10*self.scale;
    _bigScroll.backgroundColor=superBackgroundColor;
    [self jianJie];
   
}
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:99999999];
        label.hidden=YES;
    }else
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:99999999];
        label.hidden=NO;
    }
    
}
#pragma mark--简介
-(void)jianJie{
    
    if (_isHaveItem) {
        _jianjieCell = [[CellView alloc]initWithFrame:CGRectMake(0, _beizhuCell.bottom+10*self.scale, self.view.width, 100*self.scale)];
    }else{
         _jianjieCell = [[CellView alloc]initWithFrame:CGRectMake(0, _shopBigVi.bottom+10*self.scale, self.view.width, 100*self.scale)];
    }
   
    [_bigScroll addSubview:_jianjieCell];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _jianjieCell.width, .5)];
    topLine.backgroundColor=blackLineColore;
    [_jianjieCell addSubview:topLine];
    
    UILabel *jianJieLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
    jianJieLa.textAlignment = NSTextAlignmentLeft;
    jianJieLa.text = @"商家简介";
    jianJieLa.font=DefaultFont(self.scale);
    [_jianjieCell addSubview:jianJieLa];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(jianJieLa.left, jianJieLa.bottom+10*self.scale, self.view.width-20*self.scale, .5)];
    line.backgroundColor = blackLineColore;
    [_jianjieCell addSubview:line];
    
    
    
    
    
//    UIWebView *contextLa = [[UIWebView alloc]initWithFrame:CGRectMake(jianJieLa.left, line.bottom+10*self.scale, line.width, 0)];
////    contextLa.text = [_data objectForKey:@"detail"];
//    [_jianjieCell addSubview:contextLa];
//    NSString *webContent =[NSString stringWithFormat:@"<!doctype html><html>\n<meta charset=\"utf-8\"><style type=\"text/css\">body{padding:0; margin:0;}\n.view_h1{ width:90%%;display:block; overflow:hidden; margin:0 auto; font-size:1.3em; color:#333; padding:1em 0; line-height:1.2em; text-align:center;}\n.view_time{ width:90%%; display:block; text-align:center;overflow:hidden; margin:0 auto; font-size:1em; color:#999;}\n.con{width:90%%; margin:0 auto; color:#fff; color:#333; padding:0.5em 0; overflow:hidden; display:block; font-size:0.92em; line-height:1.8em;}\n.con h1,h2,h3,h4,h5,h6{ font-size:1em;}\n .con img{width: auto; max-width: 100%%;height: auto;margin:0 auto;}\n</style>\n<body style=\"padding:0; margin:0; \"><div class=\"con\">%@</div></body></html>",[_data objectForKey:@"detail"]];
//    contextLa.delegate=self;
//    contextLa.scrollView.bounces = NO;
//    contextLa.scrollView.showsHorizontalScrollIndicator = NO;
//    contextLa.scrollView.scrollEnabled = NO;
//
//    [contextLa loadHTMLString:webContent baseURL:nil];
    
    
    
    UILabel *contextLa = [[UILabel alloc]initWithFrame:CGRectMake(jianJieLa.left, line.bottom+10*self.scale, line.width, 0)];
    contextLa.textAlignment = NSTextAlignmentLeft;
    contextLa.text = [_data objectForKey:@"detail"];
    contextLa.numberOfLines = 0;
    contextLa.font=DefaultFont(self.scale);
    contextLa.textColor = grayTextColor;
    [_jianjieCell addSubview:contextLa];
    [contextLa sizeToFit];
    
    _jianjieCell.height = contextLa.bottom+10*self.scale;
    //    [self GongGaoShop];
    _bigScroll.contentSize = CGSizeMake(self.view.width, _jianjieCell.bottom+10*self.scale);
    [self botVi];

    //    CGSize size = [self sizetoFitWithString:contextLa.text];
    //    contextLa.height = size.height;
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    
//    
//    CGFloat webViewHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
//    
//    CGRect newFrame = webView.frame;
//    
//    newFrame.size.height= webViewHeight;
//    
//    webView.frame= newFrame;
//
//    _jianjieCell.height = webView.bottom+10*self.scale;
//    //    [self GongGaoShop];
//    _bigScroll.contentSize = CGSizeMake(self.view.width, _jianjieCell.bottom+10*self.scale);
//    [self botVi];
//
//    
//}






- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self.view endEditing:YES];


    return YES;

}

-(void)botVi{

    UIView *bigVi = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-49*self.scale,self.view.width, 49*self.scale)];
    bigVi.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bigVi];

    UIView *leftVi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160/2.25*self.scale, bigVi.height)];
    leftVi.backgroundColor = [UIColor colorWithRed:14/255.0 green:120/255.0 blue:255/255.0 alpha:1];
    [bigVi addSubview:leftVi];
   
    
    
//在线咨询
    UIImageView *talkImg = [[UIImageView alloc]initWithFrame:CGRectMake(leftVi.width/2-10*self.scale, leftVi.top+5*self.scale, 20*self.scale, 20*self.scale)];
    talkImg.image = [UIImage imageNamed:@"index_xiaoxi"];
    [bigVi addSubview:talkImg];
    
    UILabel *talkLa = [[UILabel alloc]initWithFrame:CGRectMake(leftVi.width/2-25*self.scale, talkImg.bottom+5*self.scale, 50*self.scale, 15*self.scale)];
    talkLa.text = @"在线咨询";
    talkLa.textAlignment = NSTextAlignmentCenter;
    talkLa.font = BoldSmallFont(self.scale);
    talkLa.textColor = [UIColor whiteColor];
    [bigVi addSubview:talkLa];
    
    
    UIButton *talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    talkBtn.frame = CGRectMake(0, 0, leftVi.width, leftVi.height);
    [talkBtn addTarget:self action:@selector(onLineZiXun:) forControlEvents:UIControlEventTouchUpInside];
    [leftVi addSubview:talkBtn];
    
    
    
    
    UIView *rightVi = [[UIView alloc]initWithFrame:CGRectMake(leftVi.right, leftVi.top, bigVi.width-leftVi.width, bigVi.height)];
//    if (!_isHaveItem) {
        leftVi.hidden=YES;
        rightVi.left=0;
        rightVi.width=bigVi.width;
//    }else{
//        leftVi.hidden=NO;
//        rightVi.left=leftVi.right;
//        rightVi.width=bigVi.width-leftVi.width;
//    }
    
    [rightVi setBackgroundColor:[UIColor redColor]];
    [bigVi addSubview:rightVi];
    
    UILabel *subOrder = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rightVi.width, rightVi.height)];
    subOrder.textColor = [UIColor whiteColor];
    subOrder.textAlignment = NSTextAlignmentCenter;
    subOrder.font = BigFont(self.scale);
    if (_isHaveItem) {
        subOrder.text = @"提交订单";
    }else{
        subOrder.text = @"拨打电话";
    }
    [rightVi addSubview:subOrder];
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = subOrder.frame;
    [submit addTarget:self action:@selector(submintOder:) forControlEvents:UIControlEventTouchUpInside];
    [rightVi addSubview:submit];
}

//提交订单；
-(void)submintOder:(UIButton *)sender{
    if (_isHaveItem) {
        if ([Stockpile sharedStockpile].isLogin==NO) {
            [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
                if (index==1) {
                    [self login];
                }
            }];
            return;
        }
        NSMutableArray *projectIndex = [NSMutableArray new];
        BOOL project = NO;
        for (UIButton *btn in _btnArry) {
            if (btn.selected==YES) {
                project=YES;
                NSString *str = [NSString stringWithFormat:@"%ld",(long)btn.tag];
                NSString *tag = [str substringFromIndex:str.length-1];
                //           NSString *ID = [_data objectForKey:@"serve_item"][btn.tag][@"item_id"];
                [projectIndex addObject:tag];
            }
        }
        if (!project) {
            [self ShowAlertWithMessage:@"至少选择一个服务项目"];
            return;
        }
        //下单时间
        NSDate *date = [NSDate date];
        NSDateFormatter *fo = [[NSDateFormatter alloc]init];
        [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *time = [fo stringFromDate:date];
        
        //预约时间
        CellView *btn = (CellView *)[self.view viewWithTag:999];
        self.hidesBottomBarWhenPushed=YES;
        OderQuerenViewController *oder = [OderQuerenViewController new];
        oder.isopen=_isOpen;
        oder.ID=self.ID;
        oder.projectIndex=projectIndex;
        oder.project=[_data objectForKey:@"serve_item"];
        oder.xiatime=time;
        oder.yueyutime=btn.contentLabel.text;
        oder.songTime=_songTime;
        oder.data=_data;
        oder.beizhu1=_contextLa.text;
        [self.navigationController pushViewController:oder animated:YES];

    }else{
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (_isPush)
        {
            [dic setObject:self.shop_id forKey:@"shop_id"];
        }
        else
        {
           [dic setObject:self.ID forKey:@"shop_id"];
        }
        
        [dic setObject:[NSString stringWithFormat:@"%@",[_data objectForKey:@"hotline"]] forKey:@"tel"];
        if ([Stockpile sharedStockpile].isLogin) {
            [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
        }
        
        [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
            }
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[_data objectForKey:@"hotline"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        

    }
    
    
    
}


//在线咨询按钮
-(void)onLineZiXun:(UIButton *)sender{
    
    if ([Stockpile sharedStockpile].isLogin==NO) {
        
        [self ShowAlertTitle:nil Message:@"请先登录" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                [self login];
            }
            
        }];
        
        return;
    }
//    这个地方不需要电话了
//    if (!_isOpen) {
//        [self ShowAlertWithMessage:@"该商家暂未开通聊天功能！"];
//        return;
//    }
//    self.hidesBottomBarWhenPushed=YES;
//    RCDChatViewController *chatService = [RCDChatViewController new];
////    chatService.userName = [_data objectForKey:@"shop_name"];
//    chatService.targetId = [_data objectForKey:@"shop_user_id"];
//    chatService.conversationType = ConversationType_PRIVATE;
//    chatService.title = [_data objectForKey:@"shop_name"];
//
//    [self.navigationController pushViewController:chatService animated:YES];
}
//点击电话的事件

-(void)phoneEvent:(UIButton *)sender{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_isPush){
         [dic setObject:self.shop_id forKey:@"shop_id"];
    }else{
       [dic setObject:self.ID forKey:@"shop_id"];
    }
    [dic setObject:[NSString stringWithFormat:@"%@",[_data objectForKey:@"hotline"]] forKey:@"tel"];
    if ([Stockpile sharedStockpile].isLogin) {
        [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
    }
    [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
        }
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[_data objectForKey:@"hotline"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
}

#pragma mark -----返回按钮
-(void)returnVi{
    self.TitleLabel.text=_titlee;
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
//    UIButton *xiangqing = [UIButton buttonWithType:UIButtonTypeCustom];
//    [xiangqing setTitle:@"商家详情" forState:UIControlStateNormal];
//    xiangqing.titleLabel.font=DefaultFont(self.scale);
//    xiangqing.frame=CGRectMake(self.view.width-70*self.scale, self.TitleLabel.top, 60*self.scale, self.TitleLabel.height);
//    [xiangqing addTarget:self action:@selector(xiangqingBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.NavImg addSubview:xiangqing];
}

-(void)xiangqingBtn{
    self.hidesBottomBarWhenPushed=YES;
    BusinessInfoViewController *shopInfo = [BusinessInfoViewController new];
    [shopInfo reshShopList:^(NSString *str) {
        
        
        if (_block) {
            _block(@"ok");
        }
        [self reshData];
        
    }];
    shopInfo.shop_id=self.ID;
    [self.navigationController pushViewController:shopInfo animated:YES];
    
    
}

    

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    if (_isPush)
    {
//        [self dismissViewControllerAnimated:YES completion:nil];
         self.dismissBlock(YES);
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



-(CGSize)sizetoFitWithString:(NSString *)string{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [[NSString stringWithFormat:@"%@",string] boundingRectWithSize:CGSizeMake(200, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

    return size;
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
    _start=[[UIView alloc]initWithFrame:CGRectMake(_nameLa.left, _nameLa.bottom+5*self.scale, 70*self.scale, 15*self.scale)];
    [_nameCell addSubview:_start];
    
    int num=(int)star;
    float setX = 0;
    for (int i=0; i<num; i++)
    {
        UIImageView *starImg=[[UIImageView alloc]initWithFrame:CGRectMake(setX, 0, 10*self.scale, 10*self.scale)];
        starImg.image=[UIImage imageNamed:@"xq_star01"];
        setX = starImg.right +3*self.scale;
        [_start addSubview:starImg];
        _start.width=starImg.right;
        
    }
    
    UILabel *fen =[[UILabel alloc]initWithFrame:CGRectMake(_start.right+5*self.scale, _start.top-2*self.scale, 50*self.scale, 15*self.scale)];
    fen.text=[NSString stringWithFormat:@"%@分",[_data objectForKey:@"rating"]];
    fen.font=SmallFont(self.scale);
    fen.textColor = [UIColor redColor];
    [_nameCell addSubview:fen];
    
    if ([[_data objectForKey:@"rating"] isEqualToString:@""] || [[_data objectForKey:@"rating"] isKindOfClass:[NSNull class]] || [[_data objectForKey:@"rating"] isEqualToString:@"0"]) {
        fen.text=@"";
    }
    
    if (star>num)
    {
        UIImageView *starImg=[[UIImageView alloc]initWithFrame:CGRectMake(setX, 0, 10*self.scale, 10*self.scale)];
        starImg.image=[UIImage imageNamed:@"xq_star02"];
        [_start addSubview:starImg];
    }
   // self.scoreLa.text=[NSString stringWithFormat:@"%@分",StartNumber];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        //            if (row == 0)
        //            {
        //                _DataArr=_TodayArr;
        //            }else
        //            {
        //                _DataArr=_TimeArr;
        //            }
        [_TimePickerView reloadAllComponents];
    }
    else if (component == 1)
    {
        [_TimePickerView reloadAllComponents];
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _DayArr.count;
    }
    return _DataArr.count;
}
#pragma mark - UIPickerViewDatasource
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 100, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    if (component == 0)
    {
        pickerLabel.text =  [_DayArr objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [_DataArr objectAtIndex:row];  // Month
    }
    return pickerLabel;
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
