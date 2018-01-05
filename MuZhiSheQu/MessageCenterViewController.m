//
//  MessageCenterViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageCenterTableViewCell.h"
#import "MessageCenterCollectionViewCell.h"
#import "JSHAREService.h"
#import "ShareView.h"
#import "YiaJianViewController.h"
#import "RCDChatListViewController.h"

@interface MessageCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *collectionDataSourceImg;
@property(nonatomic,strong)NSArray *collectionDataSourceName;
@property(nonatomic,strong)NSArray *tableviewDataSourceImg;
@property(nonatomic,strong)NSArray *tableviewDataSourceTitle;
@property(nonatomic,strong)NSArray *tableviewDataSourceDes;
@property (nonatomic, strong) ShareView * shareView;
@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNav];
    [self newListView];
    [self newHeaderView];
    [self setContent];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)setContent{
    _tableviewDataSourceImg=@[@"system_messages",@"voice_down2",@"copy_print"];
    _tableviewDataSourceTitle=@[@"系统消息",@"语音下单",@"打字复印"];
    _tableviewDataSourceDes=@[@"系统消息",@"语音下单",@"打字复印"];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) newHeaderView{
    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 105*self.scale)];
    _headerView.userInteractionEnabled=YES;
    _headerView.backgroundColor=[UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.00];
     [self newView];
    _tableView.tableHeaderView=_headerView;
}

-(void) newListView{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, _titleLb.bottom, self.view.frame.size.width,self.view.frame.size.height-_titleLb.height)];
    [_tableView registerClass:[MessageCenterTableViewCell class] forCellReuseIdentifier:@"MessageCenterTableViewCell"];
    _tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)newView{
    _collectionDataSourceImg=@[@"invite_friends",@"voice_down",@"suggestions"];
    _collectionDataSourceName=@[@"邀请好友",@"语音下单",@"意见建议"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 85*self.scale) collectionViewLayout:layout];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    //[self.view addSubview:self.collectionView];
    //self.collectionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerClass:[MessageCenterCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([MessageCenterCollectionViewCell class])];
    [_headerView addSubview:self.collectionView];
}

#pragma mark - 导航
-(void)newNav{
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-(self.TitleLabel.height/2-5)-10, self.TitleLabel.top+(self.TitleLabel.height/4)+2.5, self.TitleLabel.height/2-5, self.TitleLabel.height/2-5)];
    [popBtn setImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    self.view.backgroundColor=[UIColor whiteColor];
    _titleLb=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, self.NavImg.bottom, self.view.width, 44)];
    _titleLb.text=@"消息中心";
    _titleLb.font=[UIFont systemFontOfSize:25];
    _titleLb.textColor=[UIColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1.00];
    [self.view addSubview:_titleLb];
}

-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _collectionDataSourceImg.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MessageCenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MessageCenterCollectionViewCell class]) forIndexPath:indexPath];
    [cell.coverIv setImage:[UIImage imageNamed:_collectionDataSourceImg[indexPath.row]]];
    cell.nameLb.text=_collectionDataSourceName[indexPath.row];
    return cell;
}

//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [MessageCenterCollectionViewCell cellSize];
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

//动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self share];
            break;
        case 1:
           [self skipChatView];
            break;
        case 2:
           [self skipSuggestView];
            break;
    }
}

//    RCDChatListViewController *rong = [[RCDChatListViewController alloc]init];
//    rong.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:rong animated:YES];

-(void)skipChatView{
    RCDChatListViewController *rong = [[RCDChatListViewController alloc]init];
    rong.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:rong animated:YES];
}

-(void)skipSuggestView{
    YiaJianViewController *yijian = [YiaJianViewController new];
    [self.navigationController pushViewController:yijian animated:YES];
}

-(void)share{
    [self.shareView showWithContentType:JSHARELink];
}

- (ShareView *)shareView {
    if (!_shareView) {
        _shareView = [ShareView getFactoryShareViewWithCallBack:^(JSHAREPlatform platform, JSHAREMediaType type) {
            JSHAREMessage *message = [JSHAREMessage message];
            message.mediaType = JSHARELink;
            message.url = @"http://fx.mzsq.cc";
            message.text = @"中国最接地气的社区OTO，我们只关注社区服务最后100米！";
            message.title = @"拇指便利";
            message.platform = platform;
            NSString *imageURL = @"http://www.mzsq.com/tpl/simplebootx/Public/mzportal/images/index_iphone_qrcode.png";
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
            message.image = imageData;
            [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
                NSLog(@"分享回调");
            }];
        }];
        [self.view addSubview:self.shareView];
    }
    return _shareView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*self.scale;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tableviewDataSourceImg count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCenterTableViewCell *cell=[MessageCenterTableViewCell cellWithTableView:tableView];
    [cell.headImg setImage:[UIImage imageNamed:_tableviewDataSourceImg[indexPath.row]]];
    cell.titleLa.text=_tableviewDataSourceTitle[indexPath.row];
    cell.desLb.text=_tableviewDataSourceDes[indexPath.row];
    cell.numLb.hidden=YES;
    if((_tableviewDataSourceImg.count-1)==indexPath.row){
        cell.lineView.hidden=YES;
    }else{
        cell.lineView.hidden=NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
           // [self share];
            break;
        case 1:
            [self skipChatView];
            break;
        case 2:
            [self skipChatView];
            break;
    }
}

@end
