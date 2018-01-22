//
//  GongGaoInfoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GongGaoInfoViewController.h"
#import "ShareTableViewCell.h"
#import "IntroControll.h"
#import "UmengCollection.h"
#import "ReportPostVIew.h"
#import "AppUtil.h"
#import "MyCollectionViewCell.h"
#import "PraiseListViewController.h"

@interface GongGaoInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PassValueDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)CellView *bv;
//@property(nonatomic,strong)UITextField *tf;
@property(nonatomic,strong)IntroControll *intro;
@property(nonatomic,strong)UIButton *praiseBtn,*commentBtn;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableDictionary *postDic;
@property(nonatomic,assign)BOOL isPass;
@property(nonatomic,strong) UILabel *praisePn;
//@property(nonatomic,assign)CGFloat dangerAreaHeight;

@end

@implementation GongGaoInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //_dangerAreaHeight=self.isIphoneX?34:0;
    _dataSource=[NSMutableArray new];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keybordWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keybordWillhieeht:) name:UIKeyboardWillHideNotification object:nil];
    [self newNav];
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    [self reshData];
}

-(void) bottomView{
    UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.height-45-self.dangerAreaHeight, self.view.width,1)];
    line.backgroundColor=[UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1.00];
    [self.view addSubview:line];
    _praiseBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,line.bottom, self.view.width/2,44+self.dangerAreaHeight)];
    _praiseBtn.backgroundColor=[UIColor whiteColor];
    [_praiseBtn setTitleColor:[UIColor colorWithRed:0.463 green:0.463 blue:0.463 alpha:1.00] forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:[UIColor colorWithRed:1.000 green:0.503 blue:0.000 alpha:1.00] forState:UIControlStateSelected];
    _praiseBtn.imageEdgeInsets = UIEdgeInsetsMake(15+self.dangerAreaHeight/2, 5, 15+self.dangerAreaHeight/2, 5);
    [_praiseBtn setImage:[UIImage imageNamed:@"praise_normal"] forState:UIControlStateNormal];
    [_praiseBtn setImage:[UIImage imageNamed:@"praise_selected"] forState:UIControlStateSelected];
    _praiseBtn.titleLabel.font= SmallFont(self.scale*0.8);
    _praiseBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_praiseBtn setTitle:@"赞" forState:UIControlStateNormal];
    [_praiseBtn addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
    _praiseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:_praiseBtn];
    UIView* midLine=[[UIView alloc]initWithFrame:CGRectMake(_praiseBtn.right,line.bottom, 1,44+self.dangerAreaHeight)];
    midLine.backgroundColor=[UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1.00];
    [self.view addSubview:midLine];
    _commentBtn=[[UIButton alloc]initWithFrame:CGRectMake(midLine.right,line.bottom, self.view.width-midLine.right,44+self.dangerAreaHeight)];
    _commentBtn.backgroundColor=[UIColor whiteColor];
    [_commentBtn setTitleColor:[UIColor colorWithRed:0.463 green:0.463 blue:0.463 alpha:1.00] forState:UIControlStateNormal];
    _commentBtn.titleLabel.font= SmallFont(self.scale*0.8);;
    [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    _commentBtn.imageEdgeInsets = UIEdgeInsetsMake(15+self.dangerAreaHeight/2, 5, 15+self.dangerAreaHeight/2, 5);
    _commentBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_commentBtn addTarget:self action:@selector(commentOn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commentBtn];
    if ([[NSString stringWithFormat:@"%@",_postDic[@"praise_status"]] isEqualToString:@"1"]) {
        _praiseBtn.selected=YES;
    }else{
       _praiseBtn.selected=NO;
    }
}

-(void)keybordWillChange:(NSNotification *)notification{
    _bv.hidden=NO;
    [_mesay becomeFirstResponder];
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _bv.bottom=rect.origin.y;
    }];
}

-(void)keybordWillhieeht:(NSNotification *)notification{
    _bv.hidden=YES;
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _bv.bottom=rect.origin.y;
    }];
}

-(void)fabiao{
    [self.view endEditing:YES];
    if ([_mesay.text isEqualToString:@""]) {
        [self ShowAlertWithMessage:@"请输入信息"];
        return;
    }
    if (_mesay.text.length>200) {
        [self ShowAlertWithMessage:@"最多只能输入200个字符"];
        return;
    }
    [self.view addSubview:self.activityVC];
    [self .activityVC startAnimate];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    AnalyzeObject *nale = [AnalyzeObject new];
    NSDictionary *dic = @{@"user_id":self.user_id,@"content":_mesay.text,@"notice_id":self.gongID,@"notice_type":self.type};
    [nale NoticeWallcommentWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
          //  [self ShowAlertWithMessage:msg];
            [self.view endEditing:YES];
            //_tf.text=@"";
            _mesay.text=@"";
            [self reshData];
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)reshData{
    [_dataSource removeAllObjects];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"noticeid":self.gongID};//,@"notice_type":self.type};
    [anle noticeDetailWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"noticeDetailWithDic==%@",models);
            _postDic=[models[0] mutableCopy];
            [self newView];
            [self bottomView];
            [_dataSource addObjectsFromArray:_postDic[@"comments"]];
            [self newHeaderView];
        }
    }];
}

-(void) reportPost{
    ReportPostVIew* popUpView=[[ReportPostVIew alloc]initWithFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height) andTitle:@"举报帖子"];
    popUpView.delegate=self;
    popUpView.noticeid=self.gongID;
    [self.view addSubview:popUpView];
    [UIView animateWithDuration:0.5  animations:^{
        popUpView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    } completion:^(BOOL finished) {
        popUpView.backgroundColor =[UIColor  colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
        [popUpView.contentTf becomeFirstResponder];
    }];
}

-(void) commentOn{
    ReportPostVIew* popUpView=[[ReportPostVIew alloc]initWithFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height) andTitle:@"评论"];
    popUpView.delegate=self;
    popUpView.noticeid=self.gongID;
    [self.view addSubview:popUpView];
    [UIView animateWithDuration:0.5  animations:^{
        popUpView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    } completion:^(BOOL finished) {
        popUpView.backgroundColor =[UIColor  colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.6];
        [popUpView.contentTf becomeFirstResponder];
    }];
}

-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, [UIScreen mainScreen].bounds.size.height-self.NavImg.bottom-45-self.dangerAreaHeight)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[XiangQingTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor=superBackgroundColor;
    [self.view addSubview:_tableView];
   //我也说两句
    CellView *bv = [[CellView alloc]initWithFrame:CGRectMake(0, self.view.height-44*self.scale, self.view.width, 44*self.scale)];
    bv.backgroundColor=superBackgroundColor;
    [self.view addSubview:bv];
}

-(void)fabiaovi{
    _bv = [[CellView alloc]initWithFrame:CGRectMake(0, self.view.height-44*self.scale, self.view.width, 80*self.scale)];
    _bv.backgroundColor=superBackgroundColor;
    [self.view addSubview:_bv];
    _bv.hidden=YES;
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(10*self.scale, 7, self.view.width-20*self.scale, 30*self.scale)];
    vi.layer.borderWidth=.5;
    vi.backgroundColor=[UIColor whiteColor];
    vi.layer.borderColor=blackLineColore.CGColor;
    vi.layer.cornerRadius=5;
    [_bv addSubview:vi];
    _mesay = [[UITextField alloc]initWithFrame:CGRectMake(10*self.scale, 0, vi.width-20*self.scale, 30*self.scale)];
    _mesay.layer.borderColor=blackLineColore.CGColor;
    _mesay.layer.cornerRadius=5;
    _mesay.placeholder=@"我也说两句";
    _mesay.font=DefaultFont(self.scale);
    [vi addSubview:_mesay];
    UILabel *xianzhi = [[UILabel alloc]initWithFrame:CGRectMake(_mesay.left, _mesay.bottom+10*self.scale, self.view.width-80*self.scale, 20*self.scale)];
    xianzhi.text=@"最多字符200个";
    xianzhi.font=DefaultFont(self.scale);
    xianzhi.textColor=grayTextColor;
    [_bv addSubview:xianzhi];
    
    UIButton *fa = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-60*self.scale, _mesay.bottom+10*self.scale, 50*self.scale, 30*self.scale)];
    [fa setBackgroundImage:[UIImage ImageForColor:[UIColor colorWithRed:224/255.0 green:234/255.0 blue:238/255.0 alpha:1]]forState:UIControlStateNormal];
    fa.layer.cornerRadius=5;
    fa.layer.borderWidth=.5;
    fa.layer.borderColor=blackLineColore.CGColor;
    fa.titleLabel.font=DefaultFont(self.scale);
    [fa setTitle:@"发表" forState:UIControlStateNormal];
    [fa addTarget:self action:@selector(fabiao) forControlEvents:UIControlEventTouchUpInside];
    [fa setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bv addSubview:fa];
}

-(void)newHeaderView{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 185*self.scale)];
    headerView.backgroundColor=[UIColor whiteColor];
    
    UIImageView* headerIv=[[UIImageView alloc] initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 20*self.scale, 20*self.scale)];
    headerIv.clipsToBounds=YES;
    headerIv.layer.cornerRadius=5;
    [headerIv setImageWithURL:[NSURL URLWithString:_postDic[@"logo"]] placeholderImage:[UIImage imageNamed:@"not_1"]];
    [headerView addSubview:headerIv];
    
    UILabel* nameLb=[[UILabel alloc]initWithFrame:CGRectMake(headerIv.right+10*self.scale, headerIv.top, self.view.width-headerIv.right-10*self.scale, 20*self.scale)];
    nameLb.font=[UIFont systemFontOfSize:11*self.scale];
    nameLb.textColor=[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:1.00];
    nameLb.text=_postDic[@"publisher"];
    [headerView addSubview:nameLb];
    
//    UILabel* titleLb=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, headerIv.bottom+10*self.scale, self.view.width-20*self.scale, 20*self.scale)];
//    titleLb.font=[UIFont boldSystemFontOfSize:13*self.scale];;
//    titleLb.textColor=[UIColor blackColor];
//    titleLb.text=_postDic[@"title"];
//    [headerView addSubview:titleLb];
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, headerIv.bottom+10*self.scale, self.view.width-20*self.scale, 10)];
    la.numberOfLines=0;
    la.font=[UIFont systemFontOfSize:12*self.scale];
    la.textColor=[UIColor colorWithRed:0.004 green:0.004 blue:0.004 alpha:1.00];
    la.text=[NSString stringWithFormat:@"%@",_postDic[@"content"]];
    [la sizeToFit];
    [headerView addSubview:la];
    NSMutableArray *a = [NSMutableArray new];
    NSArray* imgs=_postDic[@"img"];
    if(![AppUtil arrayIsEmpty:imgs]){
        a=[imgs mutableCopy];
    }
    float setY=la.bottom+10*self.scale;
    if (a.count>0) {
        float W=(self.view.width-40*self.scale)/3;
        for (int i=0; i<a.count; i++) {
            float x = (W+10*self.scale)*(i%3);
            float y = (W-15*self.scale)*(i/3);
            UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(x+10*self.scale, y+la.bottom+10*self.scale, W, W*0.75)];
            im.userInteractionEnabled=YES;
            [im setImageWithURL:[NSURL URLWithString:a[i]] placeholderImage:[UIImage imageNamed:@"center_img"]];
            im.tag=100+i;
            [headerView addSubview:im];
            im.contentMode=UIViewContentModeScaleAspectFill;
            im.clipsToBounds=YES;
            UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBig:)];
            [im addGestureRecognizer:tap];
            setY = im.bottom+10*self.scale;
        }
    }
    UILabel* dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, setY, self.view.width-20*self.scale, 15*self.scale)];
    dateLabel.font=SmallFont(self.scale*0.8);
    dateLabel.textColor=[UIColor colorWithRed:0.639 green:0.639 blue:0.639 alpha:1.00];
    dateLabel.backgroundColor=[UIColor clearColor];
    NSString *time = [NSString stringWithFormat:@"%@",[_postDic objectForKey:@"create_time"]];
    dateLabel.text=[AppUtil postSendTime:time];
    [headerView addSubview:dateLabel];
    setY = dateLabel.bottom+10*self.scale;

    CellView *k = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 10*self.scale)];
    k.topline.hidden=NO;
    k.backgroundColor=superBackgroundColor;
    [headerView addSubview:k];
    headerView.height=k.bottom+0*self.scale;
    _tableView.tableHeaderView=headerView;
}

-(void)imgBig:(UITapGestureRecognizer *)tap{
    NSMutableArray *a = [NSMutableArray new];
    //NSString *string = [NSString stringWithFormat:@"%@",_postDic[@"img"][0]];
    NSArray *imgArr = _postDic[@"img"];
    if(![AppUtil arrayIsEmpty:imgArr])
        a=[imgArr mutableCopy];
    NSMutableArray *pagesArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < a.count; i ++) {
        IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:[NSString stringWithFormat:@"%@",a[i]]];
        [pagesArr addObject:model1];
    }
    _intro = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:pagesArr];
    //  _intro.delegate=self;
    [_intro index:tap.view.tag-100];
    self.tabBarController.tabBar.hidden=YES;
    [[[UIApplication sharedApplication].delegate window] addSubview:_intro];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    XiangQingTableViewCell *cell=(XiangQingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (![_dataSource[indexPath.row][@"avatar"] isKindOfClass:[NSNull class]]) {
         [cell.HeaderImage setImageWithURL:[NSURL URLWithString:_dataSource[indexPath.row][@"avatar"]] placeholderImage:[UIImage imageNamed:@"not_1"]];
    }else{
        [cell.HeaderImage setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"not_1"]];
    }
    if (![_dataSource[indexPath.row][@"user_name"] isKindOfClass:[NSNull class]]) {
        cell.NameLabel.text=_dataSource[indexPath.row][@"user_name"];
    }else{
        cell.NameLabel.text=@"";
    }
    cell.ContentLabel.text=_dataSource[indexPath.row][@"content"];
    NSString *time = [NSString stringWithFormat:@"%@",[_dataSource [indexPath.row]objectForKey:@"create_time"]];
    cell.DateLabel.text=[AppUtil postSendTime:time];
    cell.CaoZuoButton.hidden=YES;
    cell.indexPath=indexPath;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(60*self.scale, 0, self.view.width-70*self.scale, 35*self.scale)];
    la.numberOfLines=0;
    la.font=DefaultFont(self.scale);
    la.text=_dataSource[indexPath.row][@"content"];
    [la sizeToFit];
    return 70*self.scale+la.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  90*self.scale;
}

-(void) skipPraiseList{
    self.hidesBottomBarWhenPushed=YES;
    PraiseListViewController *praiseVc=[[PraiseListViewController alloc]init];
    praiseVc.data = [_postDic[@"praisers"] mutableCopy];
    [self.navigationController pushViewController:praiseVc animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 90*self.scale)];
    headerView.backgroundColor=[UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.00];
    UIControl *praiseView=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40*self.scale)];
    [praiseView addTarget:self action:@selector(skipPraiseList) forControlEvents:UIControlEventTouchUpInside];
    praiseView.backgroundColor=[UIColor whiteColor];
    UIView* praiseFlag = [[UIView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 3*self.scale, 20*self.scale)];
    praiseFlag.backgroundColor=[UIColor colorWithRed:1.000 green:0.863 blue:0.357 alpha:1.00];
    [praiseView addSubview:praiseFlag];
    _praisePn = [[UILabel alloc]initWithFrame:CGRectMake(praiseFlag.right+10*self.scale, praiseFlag.top+0*self.scale, 60*self.scale, 20*self.scale)];
    //praisePn.backgroundColor=[UIColor greenColor];
    _praisePn.text=[NSString stringWithFormat:@"点赞 · %ld",[_postDic[@"praisers"] count]];
    _praisePn.textColor=[UIColor blackColor];
    _praisePn.font=[UIFont boldSystemFontOfSize:14];
    [praiseView addSubview:_praisePn];
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(20*self.scale, 20*self.scale);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10*self.scale;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(_praisePn.right, _praisePn.top, self.view.width-_praisePn.right-10*self.scale,20*self.scale) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.scrollsToTop = NO;
        collectionView.backgroundColor=[UIColor clearColor];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:kMyCollectionViewCellID];
        [praiseView addSubview:collectionView];
        collectionView;
    });

    [headerView addSubview:praiseView];
    UIView *commentView=[[UIView alloc]initWithFrame:CGRectMake(0, praiseView.bottom+10*self.scale, self.view.width, 40*self.scale)];
    commentView.backgroundColor=[UIColor whiteColor];
    UIView* flag = [[UIView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 3*self.scale, 20*self.scale)];
    flag.backgroundColor=[UIColor colorWithRed:1.000 green:0.863 blue:0.357 alpha:1.00];
    [commentView addSubview:flag];
    
    UILabel *pn = [[UILabel alloc]initWithFrame:CGRectMake(flag.right+10*self.scale, flag.top+0*self.scale, self.view.width-flag.right, 20*self.scale)];
    pn.text=[NSString stringWithFormat:@"评论 · %ld",[_dataSource count]];
    pn.textColor=[UIColor blackColor];
    pn.font=[UIFont boldSystemFontOfSize:14];
    [commentView addSubview:pn];
    
    UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0,commentView.height-.5, self.view.width,.5)];
    line.backgroundColor=[UIColor colorWithRed:0.918 green:0.918 blue:0.918 alpha:1.00];
    [commentView addSubview:line];
    [headerView addSubview:commentView];
    return headerView;
}

#pragma mark - 导航
-(void)newNav{
    //self.TitleLabel.text=@"公告详情";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];

    UIButton *reportButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.TitleLabel.height*2-10*self.scale, self.TitleLabel.top, self.TitleLabel.height*2, self.TitleLabel.height)];
    [reportButton setTitle:@"举报帖子" forState:UIControlStateNormal];
    [reportButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    reportButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [reportButton addTarget:self action:@selector(reportPost) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:reportButton];
    
//    UIButton *ShareButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.TitleLabel.height-reportButton.width-10*self.scale, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
//    [ShareButton setImage:[UIImage imageNamed:@"gg_top_rightx"] forState:UIControlStateNormal];
//    [ShareButton addTarget:self action:@selector(ShareEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.NavImg addSubview:ShareButton];
    
    UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0,self.NavImg.height-.5, self.view.width,.5)];
    line.backgroundColor=[UIColor colorWithRed:0.918 green:0.918 blue:0.918 alpha:1.00];
    [self.NavImg addSubview:line];
}

-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    if(_isPass){
        [self.delegate passValue: [[NSArray alloc] initWithObjects:@"refresh",[NSNumber numberWithInteger:self.gIndex],_gDic,nil]];
    }
}

-(void)ShareEvent:(id)sender{
//    BOOL wxFlag=NO;
//    BOOL qqFlag=NO;
//    if (![QQApiInterface isQQInstalled] ) {
//        qqFlag=YES;
//    }
//    if (![WXApi isWXAppInstalled] ) {
//        wxFlag=YES;
//    }
//    if (![QQApiInterface isQQInstalled] &&![WXApi isWXAppInstalled]) {
//        [self ShowAlertWithMessage:@"未安装QQ、微信"];
//        return;
//    }
//    UIImage *im = [UIImage imageNamed:@"icon"];
//    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeQQSpace,nil];
//    id<ISSContent> publishContent;
//    if (_dataSource.count>0) {
//        publishContent = [ShareSDK content:@"中国最接地气的社区OTO，我们只关注社区服务最后100米，绿城百合，联盟新城，温哥华山庄服务已开通" defaultContent:@"中国最接地气的社区OTO，我们只关注社区服务最后100米，绿城百合，联盟新城，温哥华山庄服务已开通" image:[ShareSDK jpegImageWithImage:im quality:0.8] title:@"拇指便利" url:@"fx.mzsq.cc" description:@"中国最接地气的社区OTO，我们只关注社区服务最后100米，绿城百合，联盟新城，温哥华山庄服务已开通" mediaType:SSPublishContentMediaTypeNews];
//    }
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:YES
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:nil];
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
//    [ShareSDK showShareActionSheet:container
//                         shareList:shareList
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:authOptions
//                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
//                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
//                                                           qqButtonHidden:qqFlag
//                                                    wxSessionButtonHidden:wxFlag
//                                                   wxTimelineButtonHidden:NO
//                                                     showKeyboardOnAppear:NO
//                                                        shareViewDelegate:nil
//                                                      friendsViewDelegate:nil
//                                                    picViewerViewDelegate:nil]
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                //可以根据回调提示用户。
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    if (state == SSPublishContentStateSuccess)
//                                    {
//                                        NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
//                                    }
//                                }
//                                else if (state == SSResponseStateFail){
//                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                }
//                            }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //NSLog(@"numberOfItemsInSection==%ld",[_postDic[@"praisers"] count]);
    return [_postDic[@"praisers"] count] ;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:kMyCollectionViewCellID forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(MyCollectionViewCell *)cell configureCellWithPostURL:_postDic[@"praisers"][indexPath.row][@"user_avatar"]];
}

//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    [self skipPraiseList];
}

#pragma mark - 赞操作
-(void)praise{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"noticeid":self.gongID};
    [anle NoticeWallAgreeWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            _praiseBtn.selected=!_praiseBtn.selected;
            _isPass=true;
            _postDic[@"praise_status"]=[NSNumber numberWithInt:_praiseBtn.selected?1:0];
            _gDic[@"praise_status"]=[NSNumber numberWithInt:_praiseBtn.selected?1:0];
            int praisenumcount=[_gDic[@"praisenumcount"] intValue];
            _gDic[@"praisenumcount"]=[NSNumber numberWithInt:_praiseBtn.selected?++praisenumcount:--praisenumcount];
            
           // _praisePn.text=[NSString stringWithFormat:@"点赞 · %ld",[_postDic[@"praisers"] count]];
            if(_praiseBtn.selected){//添加点赞信息
                NSMutableDictionary* dic=[NSMutableDictionary dictionary];
                [dic setObject:[AppUtil getCurrentTime2] forKey:@"create_time"];
                [dic setObject:[Stockpile sharedStockpile].logo forKey:@"user_avatar"];
                [dic setObject:[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].nickName] forKey:@"user_name"];
                [dic setObject:[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].ID] forKey:@"user_id"];
                NSMutableArray* praisers=[_postDic[@"praisers"] mutableCopy];
                [praisers addObject:dic];
                _postDic[@"praisers"]=[praisers copy];
            }else{
                NSMutableArray* praisers=[_postDic[@"praisers"] mutableCopy];
                for(int i=0;i<praisers.count;i++){
                    NSString* uid=[NSString stringWithFormat:@"%@",praisers[i][@"user_id"]];
                    if([uid isEqualToString:[Stockpile sharedStockpile].ID]){
                        [praisers removeObjectAtIndex:i];
                        _postDic[@"praisers"]=[praisers copy];
                        break;
                    }
                }
            }
            _praisePn.text=[NSString stringWithFormat:@"点赞 · %ld",[_postDic[@"praisers"] count]];
            [_collectionView reloadData];
        }
    }];
}

-(void) passValue:(NSArray *)arr{
    if(arr.count<=0)
        return;
    if([arr[0] isEqualToString:@"commentOn"]){
        _isPass=true;
        NSDictionary* latestComments=[arr[1] copy];
        NSMutableArray* comments=[_postDic[@"comments"]  mutableCopy];
        [comments insertObject:latestComments atIndex:0];
        _postDic[@"comments"]=[comments copy];
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:_postDic[@"comments"]];
        [_tableView reloadData];
        int commentcount=[_gDic[@"commentcount"] intValue];
        _gDic[@"commentcount"]=[NSNumber numberWithInt:++commentcount];
        [AppUtil showToast:self.view withContent:@"评论成功"];
    }else{
        [AppUtil showToast:self.view withContent:@"举报成功"];
    }
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        NSLog(@"页面pop成功了");
        if(_isPass){
            [self.delegate passValue: [[NSArray alloc] initWithObjects:@"refresh",[NSNumber numberWithInteger:self.gIndex],_gDic,nil]];
        }
    }
}

@end
