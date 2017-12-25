//
//  WoDeGongGaoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WoDeGongGaoViewController.h"
#import "FaBuGongGaoViewController.h"
#import "LiuYanTableViewCell.h"
#import "GongGaoQiangViewController.h"
#import "GongGaoSouSuoViewController.h"
#import "GongGaoInfoViewController.h"
#import "IntroControll.h"
#import "ShareTableViewCell.h"
#import "UmengCollection.h"

@interface WoDeGongGaoViewController ()<UITableViewDataSource,UITableViewDelegate,ShareTableViewCellDelegate,introlDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//@property(nonatomic,strong)NSMutableArray *dataSource;
//@property(nonatomic,strong)UITableView *tableView;
//@property(nonatomic,assign)NSInteger index;
//@property(nonatomic,strong)UILabel *la;





@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,strong)NSIndexPath *selectedIndex;
@property(nonatomic,strong)GongGaoSouSuoViewController *souSuoVC;
@property(nonatomic,assign)BOOL  selected;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSString *typeg;
@property(nonatomic,strong)UILabel *la;
@property(nonatomic,strong)IntroControll *IntroV;



@end

@implementation WoDeGongGaoViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [UmengCollection intoPage:NSStringFromClass([self class])];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}



-(void)viewDidLoad{
    [super viewDidLoad];
    [self newNav];
    
    
    _index=0;
    _typeg=@"5";
    _data = [NSMutableArray new];
    
    [self newView];
    [self newSearch];
    if ([Stockpile sharedStockpile].isLogin) {
        [self reshData];
    }
    [self.view addSubview:self.activityVC];
    
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    
////    if ([Stockpile sharedStockpile].isLogin==NO) {
////        LoginViewController *login = [LoginViewController new];
////        //让tabbar的select等于0
////        login.f=YES;
////        [login resggong:^(NSString *str) {
////            
////            [self reshData];
////            
////        }];
////        [self presentViewController:login animated:YES completion:nil];
////        return;
////    }
////    
//    
////    NSString *commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
////    
////    if ([commid isEqualToString:@"0"] && [Stockpile sharedStockpile].isLogin==YES) {
////        
////        
////        self.hidesBottomBarWhenPushed=YES;
////        SheQuManagerViewController *shequ = [SheQuManagerViewController new];
////        shequ.nojiantou=NO;
////        [self.navigationController pushViewController:shequ animated:NO];
////        self.hidesBottomBarWhenPushed=NO;
////        
////    }
//    
//    
//    
//}






-(void)reshData{
    
    [_la removeFromSuperview];
    _index++;
    AnalyzeObject *anle = [AnalyzeObject new];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSString *type = @"1";
    if (_isErShou) {
        type=@"4";
    }
    
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    NSDictionary *dic = @{@"user_id":userid,@"pindex":index,@"notice_type":type};
    [anle getNoticeListwithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if (_index==1) {
            [_data removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {
            
            [_data addObjectsFromArray:models];
        }
        [_tableView reloadData];
        
        if (_data.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
            _la.text=@"暂无公告信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:_la];
        }
        
        
    }];
}




//-(void)reshData{
//    [_la removeFromSuperview];
//    [self.activityVC startAnimate];
//    
//    _index++;
//    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
//    AnalyzeObject *anle = [AnalyzeObject new];
//    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
//    self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
//    
//    NSLog(@"%@   %@",self.user_id,self.commid);
//    
//    NSDictionary *dic = @{@"user_id":self.user_id,@"pindex":index,@"notice_type":_typeg,@"community_id":self.commid};
//    [anle getNoticeListwallWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
//        [self.activityVC stopAnimate];
//        if (_index==1) {
//            [_data removeAllObjects];
//        }
//        if ([code isEqualToString:@"0"]) {
//            
//            [_data addObjectsFromArray:models];
//            
//        }
//        if (_data.count<=0) {
//            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-self.NavImg.bottom)];
//            _la.text=@"暂无公告信息！";
//            _la.textAlignment=NSTextAlignmentCenter;
//            [_tableView addSubview:_la];
//        }
//        [_tableView reloadData];
//        [_tableView.header endRefreshing];
//        [_tableView.footer endRefreshing];
//        
//    }];
//}
-(void)newSearch{
    _souSuoVC=[[GongGaoSouSuoViewController alloc]init];
    _souSuoVC.view.frame=CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom);
    [self.view addSubview:_souSuoVC.view];
}
-(void)newView{
    
    
    
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, [UIScreen mainScreen].bounds.size.height-self.NavImg.bottom)];
    }
    
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[ShareTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    [self.view addSubview:_tableView];
}

-(void)shangla{
    
    [self reshData];
}
-(void)xiala{
    
    _index=0;
    [self reshData];
    
    //    AnalyzeObject *anle = [AnalyzeObject new];
    //    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    //    self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    //    NSDictionary *dic = @{@"user_id":self.user_id,@"pindex":@"1",@"notice_type":_typeg,@"community_id":self.commid};
    //    [anle getNoticeListwallWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
    //        [self.activityVC stopAnimate];
    //        [_tableView.header endRefreshing];
    //        [_tableView.footer endRefreshing];
    //        if ([code isEqualToString:@"0"]) {
    //            [_data removeAllObjects];
    //            [_data addObjectsFromArray:models];
    //            [_tableView reloadData];
    //        }
    //
    //
    //
    //    }];
    //    NSLog(@"%@",_data);
    
}
#pragma mark -  UITableViewDelegate && UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}


-(void)nameTalk:(UIButton *)btn{
    
//    if ([_data[btn.tag-1000][@"user_id"]isEqualToString:@""]) {
//        [self ShowAlertWithMessage:@"该商家暂未开通聊天功能！"];
//        return;
//    }
//    
//    
//    self.hidesBottomBarWhenPushed=YES;
//    RCDChatViewController *chatService = [RCDChatViewController new];
//    //  chatService.userName = _data[btn.tag-1000][@"publisher"];
//    chatService.targetId = _data[btn.tag-1000][@"user_id"];
//    chatService.conversationType = ConversationType_PRIVATE;
//    chatService.title = _data[btn.tag-1000][@"publisher"];
//    [self.navigationController pushViewController: chatService animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
//    
    
    
}

-(void)liaotian:(UIGestureRecognizer *)view{
    
//    self.hidesBottomBarWhenPushed=YES;
//    RCDChatViewController *chatService = [RCDChatViewController new];
//    //  chatService.userName = _data[view.view.tag][@"publisher"];
//    chatService.targetId = _data[view.view.tag][@"user_id"];
//    chatService.conversationType = ConversationType_PRIVATE;
//    chatService.title = _data[view.view.tag][@"publisher"];
//    [self.navigationController pushViewController: chatService animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
//    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShareTableViewCell *cell=(ShareTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.HeaderImage.tag=indexPath.row;
    cell.HeaderImage.userInteractionEnabled=YES;
    [cell.headBtn setTitle:[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].nickName] forState:UIControlStateNormal];
    [cell.headBtn addTarget:self action:@selector(nameTalk:) forControlEvents:UIControlEventTouchUpInside];
    cell.headBtn.tag=indexPath.row+1000;
    [cell.HeaderImage setImageWithURL:[NSURL URLWithString:_data[indexPath.row][@"logo"]] placeholderImage:[UIImage imageNamed:@"not_1"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liaotian:)];
    [cell.HeaderImage addGestureRecognizer:tap];
    
    NSMutableArray *a = [NSMutableArray new];
    for (int i=0; i<9; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i+1];
        NSString *na = _data[indexPath.row][str];
        if (![na isEqualToString:@""]) {
            [a addObject:na];
        }
    }
    
    
    if ([[NSString stringWithFormat:@"%@",_data[indexPath.row][@"praise_status"]] isEqualToString:@"1"]) {
        [cell.ZanButton setTitle:@"取消" forState:UIControlStateNormal];
        
    }else{
        [cell.ZanButton setTitle:@"赞" forState:UIControlStateNormal];
    }
    cell.zanCount = [_data[indexPath.row][@"praisers"] count];
    cell.zanData = _data[indexPath.row][@"praisers"];
    //[cell.CaoZuoButton removeFromSuperview];
    cell.imgCount=a.count;
    cell.imgData=a;
    
//    cell.zanCount = [_data[indexPath.row][@"praisers"] count];
    cell.delegate=self;
    //    cell.NameLabel.text=[_data [indexPath.row]objectForKey:@"title"];
    cell.ContentLabel.text=[_data [indexPath.row]objectForKey:@"content"];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *time = [NSString stringWithFormat:@"%@",[_data [indexPath.row]objectForKey:@"create_time"]];
    
    NSDate *date = [formatter dateFromString:time];
    
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"MM-dd HH:mm"];
    
    time = [formatter1 stringFromDate:date];
    
    
    
    cell.DateLabel.text=time;
    
    
    
    cell.delegate=self;
    cell.indexPath=indexPath;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // return 300*self.scale;
    //   NSLog(@"%@",_data);
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width-70*self.scale, 20*self.scale)];
    la.numberOfLines=0;
        la.text=[_data [indexPath.row]objectForKey:@"content"];
    la.font=DefaultFont(self.scale);
    [la sizeToFit];
    
    
    
    
    
    NSMutableArray *ar = [NSMutableArray new];
    for (int i=0; i<9; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i+1];
        NSString *na = _data[indexPath.row][str];
        if (![na isEqualToString:@""]) {
            [ar addObject:na];
        }
    }
    float imgH = 0;
    if (ar.count<=0) {
        imgH = 0;
    }
    
    if (ar.count<4 && ar.count>0) {
        imgH = 63*self.scale;
    }else if (ar.count<7 && ar.count>0){
        imgH=128*self.scale;
    }else if (ar.count<10 && ar.count>0){
        imgH=190*self.scale;
    }
    
    
    NSArray *praArr = _data[indexPath.row][@"praisers"];
    float zanH=0;
    
    
    
    NSString *str = @"";
    
    for (NSDictionary *dic in praArr) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",dic[@"user_name"]]];
        
        
        str = [str substringToIndex:str.length-1];
        
        
    }
    
    
    
    
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle1.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:13*self.scale], NSParagraphStyleAttributeName:paragraphStyle1.copy};
    CGSize size1 = [str boundingRectWithSize:CGSizeMake(self.view.width-50*self.scale, 3500*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes1 context:nil].size;
    
    zanH=size1.height+15*self.scale;
    
    if (praArr.count<=0) {
        zanH=0;
    }
    
    
    
    
    
    
    return imgH+zanH+60*self.scale+la.height;
    
    
    
    
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed=YES;
    GongGaoInfoViewController *infoVC=[[GongGaoInfoViewController alloc]init];
    infoVC.gongID = _data[indexPath.row][@"id"];
    infoVC.type=@"1";
    if (_isErShou) {
        infoVC.type=@"4";
    }
    
    [self.navigationController pushViewController:infoVC animated:YES];
}
#pragma mark - 赞操作
-(void)ShareTableViewCellWith:(NSIndexPath *)indexPath{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    
    NSDictionary *dic = @{@"user_id":self.user_id,@"notice_id":_data[indexPath.row][@"id"]};
    [anle NoticeWallAgreeWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            _index=0;
            [self reshData];
            
            //            ShareTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            //            cell.CaoZuoButton.selected=YES;
            
        }
    }];
    
    
}
#pragma mark - 操作
-(void)CanZuoTableViewCellWith:(NSIndexPath *)indexPath Selected:(BOOL)selected{
    if (_selectedIndex && _selectedIndex!=indexPath) {
        ShareTableViewCell *cell=(ShareTableViewCell *)[_tableView cellForRowAtIndexPath:_selectedIndex];
       // cell.CaoZuoButton.selected=NO;
        _selectedIndex=nil;
    }
    _selectedIndex=indexPath;
}
#pragma mark - 大图
-(void)BigImageTableViewCellWith:(NSIndexPath *)indexPath ImageIndex:(NSInteger)index{
    NSMutableArray *a = [NSMutableArray new];
    
    NSLog(@"%d",index);
    
    for (int i=0; i<9; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i+1];
        NSString *na = _data[indexPath.row][str];
        if (![na isEqualToString:@""]) {
            [a addObject:na];
        }
    }
    
    
    NSMutableArray *pagesArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <a.count; i ++) {
        
        IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:[NSString stringWithFormat:@"%@",a[i]]];
        [pagesArr addObject:model1];
    }
    
    _IntroV = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:pagesArr];
    _IntroV.delegate=self;
    [_IntroV index:index-1];
    
    [self.appdelegate.window addSubview:_IntroV];
    
}
-(void)tabaryes{
    
//    self.tabBarController.tabBar.hidden=NO;
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_selectedIndex) {
        ShareTableViewCell *cell=(ShareTableViewCell *)[_tableView cellForRowAtIndexPath:_selectedIndex];
       // cell.CaoZuoButton.selected=NO;
        _selectedIndex=nil;
    }
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"我的公告";
    
    if (_isErShou) {
        self.TitleLabel.text=@"二手闲置";
    }
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton *SaveButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.NavImg.height, self.TitleLabel.top, self.NavImg.height, self.TitleLabel.height)];
    [SaveButton setTitle:@"发公告" forState:UIControlStateNormal];
    [SaveButton setTitleColor:grayTextColor forState:(UIControlStateNormal)];
    SaveButton.titleLabel.font=DefaultFont(self.scale);
    [SaveButton addTarget:self action:@selector(NextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:SaveButton];
}
-(void)PopVC:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
}
-(void)NextButtonEvent:(id)sender{
    self.hidesBottomBarWhenPushed=YES;
    FaBuGongGaoViewController *fabuVC=[[FaBuGongGaoViewController alloc]init];
    [fabuVC gonggaoResh:^(NSString *str) {
        
        _index=0;
        [self reshData];
        
    }];
    fabuVC.bian=NO;
    if (_isErShou) {
        fabuVC.isershou=YES;
    }
    [self.navigationController pushViewController:fabuVC animated:YES];
}




//- (void)viewDidLoad {
//    [super viewDidLoad];
//    _index=0;
//    _dataSource = [NSMutableArray new];
//    // Do any additional setup after loading the view.
//    [self newNav];
//    [self newView];
//    [self.view addSubview:self.activityVC];
//    [self.activityVC startAnimate];
//    //[self reshData];
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    _index=0;
//    [self reshData];
//    
//    
//}
//
//-(void)reshData{
//    
//    [_la removeFromSuperview];
//    _index++;
//    AnalyzeObject *anle = [AnalyzeObject new];
//    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
//    NSString *type = @"1";
//    if (_isErShou) {
//        type=@"4";
//    }
//    
//    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
//    NSDictionary *dic = @{@"user_id":userid,@"pindex":index,@"notice_type":type};
//    [anle getNoticeListwithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
//        [self.activityVC stopAnimate];
//        [_tableView.header endRefreshing];
//        [_tableView.footer endRefreshing];
//        if (_index==1) {
//            [_dataSource removeAllObjects];
//        }
//        if ([code isEqualToString:@"0"]) {
//            
//                [_dataSource addObjectsFromArray:models];
//        }
//            [_tableView reloadData];
//            
//        if (_dataSource.count<=0) {
//            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
//            _la.text=@"暂无公告信息！";
//            _la.textAlignment=NSTextAlignmentCenter;
//            [self.view addSubview:_la];
//        }
//
//        
//    }];
//}
//-(void)newView{
//    _tableView=[[UITableView  alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
//    _tableView.delegate=self;
//    _tableView.dataSource=self;
//    _tableView.backgroundColor=[UIColor clearColor];
//    [_tableView registerClass:[LiuYanTableViewCell class] forCellReuseIdentifier:@"Cell"];
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footr)];
//    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headr)];
//
//    [self.view addSubview:_tableView];
//}
//
//-(void)footr{
//    
//    [self reshData];
//}
//
//-(void)headr{
//    _index=0;
//    
//    [self reshData];
//    
//}
//
//
//#pragma mark - 左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _dataSource.count;
//}
//
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view addSubview:self.activityVC];
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

        NSDictionary *dic = @{@"user_id":self.user_id,@"notice_id":_data[indexPath.row][@"id"]};
        
        [anle delNoticeWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"0"]) {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                _index=0;
                [self reshData];
            }
            [self.activityVC stopAnimate];
        }];
    }




}
//
//-(void)bianij:(UIButton *)btn{
//  //  NSMutableArray *data = [NSMutableArray new];
//    self.hidesBottomBarWhenPushed=YES;
//    FaBuGongGaoViewController *fabu = [FaBuGongGaoViewController new];
//    fabu.conteent = _dataSource[btn.tag-1][@"content"];
//    fabu.titlee = _dataSource[btn.tag-1][@"title"];
////    for (int i=0; i<9; i++) {
////        NSString *name = [NSString stringWithFormat:@"img%d",i+1];
////        NSString *tit = _dataSource[btn.tag-1][name];
////        
////        if (tit==nil || [tit isEqualToString:@""]) {
////            
////        }else{
////            [data addObject:tit];
////        }
////        
////    }
//    fabu.gongid = _dataSource[btn.tag-1][@"id"];
//    fabu.bian=YES;
//  //  fabu.imgData=data;
//    [self.navigationController pushViewController:fabu animated:YES];
//    
//    
//
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    LiuYanTableViewCell *cell=(LiuYanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell.titleLabel.text=_dataSource[indexPath.row][@"title"];
//    cell.contentLabel.text=_dataSource[indexPath.row][@"content"];
//    
//  NSString *s = _dataSource[indexPath.row][@"create_time"];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSDate *date = [formatter dateFromString:s];
//    
//    
//    
//    
//    
//    
//    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
//    [formatter1 setDateFormat:@"MM-dd HH:MM"];
//    
//    s = [formatter1 stringFromDate:date];
//    
//    
//    cell.dateLabel.text=s;
//    cell.StateImage.hidden=NO;
//    cell.bianji.tag=indexPath.row+1;
//    [cell.bianji addTarget:self action:@selector(bianij:) forControlEvents:UIControlEventTouchUpInside];
//    
//    return cell;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 64*self.scale;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
////去编辑公告
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.hidesBottomBarWhenPushed=YES;
//    GongGaoInfoViewController *gonggao = [GongGaoInfoViewController new];
//    gonggao.type=@"1";
//    if (_isErShou) {
//        gonggao.type=@"4";
//    }
//    gonggao.gongID = _dataSource[indexPath.row][@"id"];
//    [self.navigationController pushViewController:gonggao animated:YES];
//    
//    
//    
//}
//
//
//
//#pragma mark - 导航
//-(void)newNav{
//    self.TitleLabel.text=@"我的公告";
//    
//    if (_isErShou) {
//        self.TitleLabel.text=@"二手闲置";
//    }
//    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
//    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
//    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
//    [self.NavImg addSubview:popBtn];
//    
//    UIButton *SaveButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.NavImg.height, self.TitleLabel.top, self.NavImg.height, self.TitleLabel.height)];
//    [SaveButton setTitle:@"发公告" forState:UIControlStateNormal];
//    SaveButton.titleLabel.font=DefaultFont(self.scale);
//    [SaveButton addTarget:self action:@selector(NextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.NavImg addSubview:SaveButton];
//}
//-(void)PopVC:(id)sender{
//    [self.navigationController  popViewControllerAnimated:YES];
//}
//-(void)NextButtonEvent:(id)sender{
//    self.hidesBottomBarWhenPushed=YES;
//    FaBuGongGaoViewController *fabuVC=[[FaBuGongGaoViewController alloc]init];
//
//    fabuVC.bian=NO;
//    if (_isErShou) {
//        fabuVC.isershou=YES;
//    }
//    [self.navigationController pushViewController:fabuVC animated:YES];
//}
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
