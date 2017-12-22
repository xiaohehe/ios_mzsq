//
//  NeighborhoodViewController.m
//  MuZhiSheQu
//  邻里圈
//  Created by lt on 2017/10/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NeighborhoodViewController.h"
#import "MuZhiSheQu-Swift.h"
#import "NeighborhoodGossipViewController.h"
#import "PropertyAnnouncementViewController.h"
#import "AppUtil.h"
#import "MyNeighborhoodViewController.h"
#import "FaBuGongGaoViewController.h"

static const NSUInteger MY_TAG = 10000;

@interface NeighborhoodViewController ()
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIImageView *HeaderImg;
@property(nonatomic,strong)UIButton *myPostView;
@property(nonatomic,strong)UIView *redDotView;
@property(nonatomic,strong)UIButton *myReplyView;
@property(nonatomic,strong)UILabel *myPostNumLb;
@property(nonatomic,strong)UILabel *myReplyNUmLb;
@property(nonatomic,strong)UIButton *noticeBtn;
@property(nonatomic,strong)UILabel *noticeLb;
@property(nonatomic,strong)LPSliderView *sliderView;


@end

@implementation NeighborhoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNav];
    [self newTopView];
    [self listView];
    [self loadData];
}

-(void)newTopView{
    _topView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 140*self.scale)];
    //_topView.backgroundColor=[UIColor colorWithRed:1.000 green:0.792 blue:0.000 alpha:1.00];
    _topView.userInteractionEnabled=YES;
    [self.view addSubview:_topView];
    [self newLogin];
    [self noticeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) listView{
    NeighborhoodGossipViewController* oneController=[[NeighborhoodGossipViewController alloc] init];
    PropertyAnnouncementViewController* twoController=[[PropertyAnnouncementViewController alloc] init];
    [self addChildViewController:oneController];
    [self addChildViewController:twoController];
    CGRect listFrame=CGRectMake(0, _topView.bottom+10*self.scale, self.view.width, self.view.height-_noticeBtn.bottom-10*self.scale);
    NSArray* titles=[NSArray arrayWithObjects:@"邻里杂谈", @"物业公告", nil];
    NSArray* contentViews=[NSArray arrayWithObjects:[oneController view],[twoController view], nil];
    // 初始化方式一：（推荐）
    _sliderView =[[LPSliderView alloc] initWithFrame:listFrame titles:titles contentViews:contentViews ];
    _sliderView.backgroundColor=[UIColor redColor];
    // 初始化方式二：
    // sliderView = LPSliderView()
    // sliderView.frame = frame
    // sliderView.titles = titles
    // sliderView.contentViews = contentViews
    
    _sliderView.titleNormalColor = [UIColor blackColor];
    _sliderView.titleSelectedColor = [UIColor blackColor];
    _sliderView.sliderColor = [UIColor colorWithRed:1.000 green:0.863 blue:0.357 alpha:1.00];
    _sliderView.sliderWidth = 60;
    _sliderView.sliderHeight = 2;
    // 视图切换闭包回调（可选。。。）
    [_sliderView setViewChangeClosure:^(NSInteger index) {
        NSLog(@"视图切换，下标---%ld", index);
    }];
   _sliderView.selectedIndex = 0 ;// 默认选中第2个
    [ self.view addSubview:_sliderView];
}

-(void)noticeView{
    _noticeBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, _HeaderImg.bottom+10*self.scale, self.view.width, 65*self.scale)];
    _noticeBtn.backgroundColor=[UIColor whiteColor];
    [self.topView addSubview:_noticeBtn];
    UILabel* noticeTitle=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 0, 70*self.scale, 20*self.scale)];
    noticeTitle.backgroundColor=[UIColor colorWithRed:1.000 green:0.376 blue:0.000 alpha:1.00];
    noticeTitle.text=@"物业公告";
    noticeTitle.textColor=[UIColor whiteColor];
    noticeTitle.font=[UIFont boldSystemFontOfSize:13*self.scale];
    noticeTitle.textAlignment=NSTextAlignmentCenter;
    [_noticeBtn addSubview:noticeTitle];
    _noticeLb=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale,noticeTitle.bottom+5*self.scale, self.view.width-20*self.scale, 35*self.scale)];
    _noticeLb.font=[UIFont systemFontOfSize:13*self.scale];
    [_noticeBtn addSubview:_noticeLb];
}

-(void)skipMyNeighborhoodViewController:(UIButton *)btn{
    MyNeighborhoodViewController* myNeighborhoodViewController=[[MyNeighborhoodViewController alloc] init];
    if(btn.tag==MY_TAG){
        myNeighborhoodViewController.type=0;
    }else{
        myNeighborhoodViewController.type=1;
    }
    myNeighborhoodViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:myNeighborhoodViewController animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

-(void)newLogin{
    _HeaderImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 65*self.scale)];
    _HeaderImg.backgroundColor=[UIColor colorWithRed:1.000 green:0.792 blue:0.000 alpha:1.00];
    _HeaderImg.userInteractionEnabled=YES;
    [self.topView addSubview:_HeaderImg];
    UIButton *Image=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 40*self.scale, 40*self.scale)];
    Image.layer.masksToBounds=YES;
    Image.layer.cornerRadius=Image.height/2;
    Image.userInteractionEnabled=YES;
    Image.selected=YES;
    [Image setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[Stockpile sharedStockpile].logo] placeholderImage:[UIImage imageNamed:@"not_1"]];
    [Image addTarget:self action:@selector(gozhanghumanager:) forControlEvents:UIControlEventTouchUpInside];
    [_HeaderImg addSubview:Image];
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(60*self.scale, 20*self.scale, (self.view.width)/2-60*self.scale, 20*self.scale)];
    [button setBackgroundImage:[UIImage setImgNameBianShen:@"center_index_btn"] forState:UIControlStateNormal];
    //button.frame=CGRectMake(60*self.scale, 20*self.scale, self.view.width-Image.right-50*self.scale, 20*self.scale);
    [button setTitle:[Stockpile sharedStockpile].nickName forState:UIControlStateNormal];
    [_HeaderImg setImageWithURL:[NSURL URLWithString:[Stockpile sharedStockpile].logo] placeholderImage:[UIImage imageNamed:@"center_img"]];
    button.userInteractionEnabled=NO;
    [button setBackgroundImage:[UIImage setImgNameBianShen:@""] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13*self.scale];
    [_HeaderImg addSubview:button];
    
    UIView* midLine=[[UIView alloc]initWithFrame:CGRectMake(self.view.width/2,Image.top, 1, Image.height)];
    midLine.backgroundColor=[UIColor colorWithRed:0.996 green:0.906 blue:0.286 alpha:1.00];
    [_HeaderImg addSubview:midLine];
    
    UIView* rightLine=[[UIView alloc]initWithFrame:CGRectMake(self.view.width/4*3,Image.top, 1, Image.height)];
    rightLine.backgroundColor=[UIColor colorWithRed:0.996 green:0.906 blue:0.286 alpha:1.00];
    [_HeaderImg addSubview:rightLine];
    //NSLog(@"line==%f==%f",rightLine.left,midLine.right);
    _myPostView=[[UIButton alloc]initWithFrame:CGRectMake(midLine.right,midLine.top, rightLine.left-midLine.right, Image.height)];
    _myPostView.tag=MY_TAG;
    [_myPostView addTarget:self action:@selector(skipMyNeighborhoodViewController:) forControlEvents:UIControlEventTouchUpInside];
    [_HeaderImg addSubview:_myPostView];
    
    UILabel *myPostLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _myPostView.width, _myPostView.height/2)];
    myPostLb.text=@"我的帖子";
    myPostLb.textAlignment = NSTextAlignmentCenter;
    myPostLb.font=[UIFont systemFontOfSize:12*self.scale];
    [_myPostView addSubview:myPostLb];
    _redDotView=[[UIView alloc]initWithFrame:CGRectMake(myPostLb.right-15*self.scale,myPostLb.top, 6, 6)];
    _redDotView.backgroundColor=[UIColor colorWithRed:1.000 green:0.357 blue:0.267 alpha:1.00];
    _redDotView.layer.masksToBounds=YES;
    _redDotView.layer.cornerRadius=_redDotView.height/2;
    [_myPostView addSubview:_redDotView];
    _redDotView.hidden=YES;
    _myPostNumLb=[[UILabel alloc]initWithFrame:CGRectMake(0, myPostLb.bottom, _myPostView.width, _myPostView.height/2)];
    _myPostNumLb.textAlignment = NSTextAlignmentCenter;
    _myPostNumLb.font=[UIFont boldSystemFontOfSize:12*self.scale];
    _myPostNumLb.text=@"0";
    [_myPostView addSubview:_myPostNumLb];
    
    _myReplyView=[[UIButton alloc]initWithFrame:CGRectMake(rightLine.right,midLine.top, self.view.width-rightLine.right, Image.height)];
    _myReplyView.tag=MY_TAG+1;
    [_myReplyView addTarget:self action:@selector(skipMyNeighborhoodViewController:) forControlEvents:UIControlEventTouchUpInside];
    [_HeaderImg addSubview:_myReplyView];
    UILabel *myReplyLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _myReplyView.width, _myReplyView.height/2)];
    myReplyLb.text=@"我的回复";
    myReplyLb.textAlignment = NSTextAlignmentCenter;
    myReplyLb.font=[UIFont systemFontOfSize:12*self.scale];
    [_myReplyView addSubview:myReplyLb];

    _myReplyNUmLb=[[UILabel alloc]initWithFrame:CGRectMake(0, myReplyLb.bottom, _myReplyView.width, _myReplyView.height/2)];
    _myReplyNUmLb.textAlignment = NSTextAlignmentCenter;
    _myReplyNUmLb.font=[UIFont boldSystemFontOfSize:12*self.scale];
    _myReplyNUmLb.text=@"0";
    [_myReplyView addSubview:_myReplyNUmLb];
    
    CAGradientLayer *gradientLayer=[CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:1.000 green:0.925 blue:0.000 alpha:1.00].CGColor, (__bridge id)[UIColor colorWithRed:0.996 green:0.800 blue:0.000 alpha:1.00].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame =CGRectMake(0, 0, self.view.width, 130*self.scale/2);
    // [_HeaderImg.layer addSublayer:gradientLayer];
    [_HeaderImg.layer insertSublayer:gradientLayer atIndex:0];
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.textColor  = [UIColor whiteColor];
    self.NavImg.backgroundColor = [UIColor colorWithRed:1.000 green:0.792 blue:0.000 alpha:1.00];
    UIButton *talkImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [talkImg setImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
    //    [talkImg setImage:[UIImage imageNamed:@"dian_ico_01"] forState:UIControlStateHighlighted];
    talkImg.frame=CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height,self.TitleLabel.height);
    [talkImg addTarget:self action:@selector(fagonggao) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:talkImg];
    self.gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    [self.NavImg.layer insertSublayer:self.gradientLayer atIndex:0];
    UILabel * community=[[UILabel alloc] initWithFrame:CGRectMake(10*self.scale, self.TitleLabel.top+10, self.view.width-talkImg.width-30*self.scale, 20)];
    //community.textAlignment=NSTextAlignmentCenter;
    community.textColor = [UIColor blackColor];
    community.userInteractionEnabled=YES;
    community.font=[UIFont fontWithName:@"Helvetica-Bold" size:13*self.scale];
    //community.font=SmallFont(self.scale*1.1);
    community.attributedText=[self setAddress];
    UITapGestureRecognizer *addressTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PopVC:)];
    [community addGestureRecognizer:addressTapGesture];
    [self.NavImg addSubview:community];
}

-(NSAttributedString*) setAddress{
    NSString* comName=[NSString stringWithFormat:@" 邻里圈(%@)",[[NSUserDefaults standardUserDefaults]objectForKey:@"commname"]] ;
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:comName];
    // 2.添加表情图片
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"left_black"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -4, 11, 20);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];// 插入某个位置
    return attri;
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.227 green:0.227 blue:0.227 alpha:1.00];
    //self.tabBarController.tabBar.hidden=YES;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestNearlyPlot)  name:@"requestNearlyPlot" object:nil];
}

-(void) loadData{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    NSString* commid= [[NSUserDefaults standardUserDefaults] objectForKey:@"commid"];
    NSDictionary *dic = @{@"communityid":commid};
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle getNoticeWall:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        NSString* notice=[NSString stringWithFormat:@"%@",models[@"CommunityNotice"]];
        if([AppUtil isBlank:notice])
            _noticeLb.text=@"暂无公告";
        else
             _noticeLb.text=models[@"CommunityNotice"];
        _myPostNumLb.text=[NSString stringWithFormat:@"%@",models[@"MyNoticeCount"]];
        _myReplyNUmLb.text=[NSString stringWithFormat:@"%@",models[@"ReplyNoticeCount"]];
        NSLog(@"附近==%@ ",models);
    }];
}

-(void)fagonggao{
    self.hidesBottomBarWhenPushed=YES;
    FaBuGongGaoViewController *fabuvc = [FaBuGongGaoViewController new];
    [fabuvc gonggaoResh:^(NSString *str) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reshNeighbourhood" object:nil];
//        _index=0;
//        [self reshData];
    }];
    [self.navigationController pushViewController:fabuvc animated:YES];
}

@end
