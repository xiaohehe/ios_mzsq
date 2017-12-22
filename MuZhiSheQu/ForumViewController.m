//
//  ForumViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/11/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ForumViewController.h"
#import "SGPagingView.h"
#import "PersonalCenterTableView.h"
#import "NeighborhoodGossipViewController.h"
#import "PropertyAnnouncementViewController.h"
#import "AppUtil.h"
#import "FaBuGongGaoViewController.h"
#import "MyNeighborhoodViewController.h"

static CGFloat const PersonalCenterVCPageTitleViewHeight = 40;
static CGFloat const PersonalCenterVCNavHeight = 64;
static const NSUInteger MY_TAG = 10000;

@interface ForumViewController ()<UITableViewDelegate, UITableViewDataSource, SGPageTitleViewDelegate, SGPageContentViewDelegate, PersonalCenterChildBaseVCDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@property (nonatomic, strong) PersonalCenterTableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIScrollView *childVCScrollView;

@property(nonatomic,strong)UIImageView *HeaderImg;
@property(nonatomic,strong)UIButton *myPostView;
@property(nonatomic,strong)UIView *redDotView;
@property(nonatomic,strong)UIButton *myReplyView;
@property(nonatomic,strong)UILabel *myPostNumLb;
@property(nonatomic,strong)UILabel *myReplyNUmLb;
@property(nonatomic,strong)UIButton *noticeBtn;
@property(nonatomic,strong)UILabel *noticeLb;
@property(nonatomic) NSInteger selectedIndex;
@end

@implementation ForumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNav];
    [self foundTableView];
    [self loadData];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRefresh)  name:@"endRefresh" object:nil];
}

-(void)endRefresh{
    [_tableView.header endRefreshing];
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
    self.gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[self getStartHeight]+44);
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

- (void)foundTableView {
    CGFloat tableViewX = 0;
    CGFloat tableViewY =[self getStartHeight]+44;// PersonalCenterVCNavHeight;
    CGFloat tableViewW = self.view.width;
    CGFloat tableViewH = self.view.height;
    self.tableView = [[PersonalCenterTableView alloc] initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    _tableView.tableHeaderView = self.topView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.sectionHeaderHeight = PersonalCenterVCPageTitleViewHeight;
    _tableView.rowHeight = self.view.frame.size.height - PersonalCenterVCPageTitleViewHeight;
    _tableView.showsVerticalScrollIndicator = NO;
     [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
    [self.view addSubview:_tableView];
}

-(void)pullToRefresh{
    if(_selectedIndex==0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reshNeighbourhood" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reshNotice" object:nil];
    }
}

- (UIView *)topView {
    if (!_topView) {
        _topView=[[UIImageView alloc]initWithFrame:CGRectMake(0, [self getStartHeight]+44, self.view.width, 140*self.scale+10*self.scale)];
        _topView.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];;
        _topView.userInteractionEnabled=YES;
        [self.view addSubview:_topView];
        [self newLogin];
        [self noticeView];
    }
    return _topView;
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

- (SGPageTitleView *)pageTitleView {
    if (!_pageTitleView) {
        NSArray *titleArr = @[@"邻里杂谈", @"物业公告"];
        SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
        /// pageTitleView
        _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, PersonalCenterVCPageTitleViewHeight) delegate:self titleNames:titleArr configure:configure];
        _pageTitleView.backgroundColor = [UIColor whiteColor];
    }
    return _pageTitleView;
}

- (SGPageContentView *)pageContentView {
    if (!_pageContentView) {
        NeighborhoodGossipViewController* oneVC=[[NeighborhoodGossipViewController alloc] init];
        PropertyAnnouncementViewController* twoVC=[[PropertyAnnouncementViewController alloc] init];
        oneVC.delegatePersonalCenterChildBaseVC = self;
        twoVC.delegatePersonalCenterChildBaseVC = self;
        NSArray *childArr = @[oneVC, twoVC];
        /// pageContentView
        CGFloat contentViewHeight = self.view.frame.size.height - ([self getStartHeight]+44) - PersonalCenterVCPageTitleViewHeight;
        _pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
        _pageContentView.delegatePageContentView = self;
    }
    return _pageContentView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.childVCScrollView && _childVCScrollView.contentOffset.y > 0) {
        self.tableView.contentOffset = CGPointMake(0, 149*self.scale);
    }
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY < 149*self.scale) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pageTitleViewToTop" object:nil];
    }
}

- (void)personalCenterChildBaseVCScrollViewDidScroll:(UIScrollView *)scrollView {
    self.childVCScrollView = scrollView;
    if (self.tableView.contentOffset.y < 140*self.scale) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    } else {
        self.tableView.contentOffset = CGPointMake(0, 140*self.scale);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.contentView addSubview:self.pageContentView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.pageTitleView;
}

#pragma mark - - - SGPageTitleViewDelegate - SGPageContentViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    self.selectedIndex=selectedIndex;
    //NSLog(@"selectedIndex==##%d",selectedIndex);
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    self.selectedIndex=targetIndex;
    //NSLog(@"selectedIndex==~~%d",targetIndex);
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
