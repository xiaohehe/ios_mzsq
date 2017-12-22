//
//  PropertyAnnouncementViewController.m
//  MuZhiSheQu
//物业公告
//  Created by lt on 2017/10/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PropertyAnnouncementViewController.h"
#import "ShareTableViewCell.h"
#import "AppUtil.h"

@interface PropertyAnnouncementViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)NSDictionary *infoDic;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *la;
@end

@implementation PropertyAnnouncementViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 切记：纯代码在 viewDidLoad 方法中创建 tableView 时，高度一定要等于 SGPageContentView 的高度 self.view.frame.size.height - 108 或 使用 Masonry 进行 下面一句代码的约束；
    //    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.view);
    //    }];
    // XIB 创建 tableView 时，不会出现这种问题，是因为 XIB 加载完成之后会调用 viewDidLayoutSubviews 这个方法，所以 XIB 中创建 tableVIew 不会出现约束问题
    /// 解决方案三
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _index=0;
    _data = [NSMutableArray new];
    //[self newView];
    [self reshData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiala)  name:@"reshNotice" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor whiteColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[ShareTableViewCell class] forCellReuseIdentifier:@"Cell"];
        [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
        [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    }
    return _tableView;
}

-(void)newView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-65*self.scale*2-20*self.scale-40)];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
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
}

-(void)reshData{
    [self.activityVC startAnimate];
    _index++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    NSDictionary *dic = @{@"userid":self.user_id,@"pindex":index,@"communityid":self.commid};
    [anle getCommunityNoticeList:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        NSLog(@"getCommunityNoticeList==%ld==%@==%@==%@",_index,code,msg,models);

        [self.activityVC stopAnimate];
        if (_index==1) {
            [_data removeAllObjects];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"endRefresh" object:nil];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if ([code isEqualToString:@"0"]) {
            if(_index==1){
                _infoDic=models[@"community_info"];
            }
            NSArray* modArr=models[@"notice_list"];
            [_data addObjectsFromArray:modArr];
            NSLog(@"getNoticeListwallWithDic==%ld",modArr.count);
            NSInteger hunm = [[[NSUserDefaults standardUserDefaults]objectForKey:@"gongnumc"] integerValue];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)hunm] forKey:@"gongnum"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            if(_index>1&&[AppUtil arrayIsEmpty:modArr]){
                _tableView.footer.state=MJRefreshFooterStateNoMoreData;
            }
        }
        if (_la) {
            [_la removeFromSuperview];
            _la=nil;
        }
        if (_data.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-self.NavImg.bottom)];
            _la.text=@"暂无公告信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            [_tableView addSubview:_la];
        }
        [_tableView reloadData];
    }];
}

#pragma mark -  UITableViewDelegate && UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShareTableViewCell *cell=(ShareTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.HeaderImage.hidden=YES;
    [cell.headBtn setTitle:[NSString stringWithFormat:@"%@",_data[indexPath.row][@"title"]] forState:UIControlStateNormal];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liaotian:)];
    [cell.HeaderImage addGestureRecognizer:tap];
    NSMutableArray *a = [NSMutableArray new];
    NSString* imgs=[NSString stringWithFormat:@"%@",_data[indexPath.row][@"imgs"]];
    NSArray *imgArr = [imgs componentsSeparatedByString:@"|"];
    for (int i=0; i<[imgArr count]; i++) {
        if (![AppUtil isBlank:imgArr[i]]) {
            [a addObject:imgArr[i]];
        }
    }
    cell.praiseBtn.hidden=YES;
    cell.commentBtn.hidden=YES;
    cell.ContentLabel.text=[_data [indexPath.row]objectForKey:@"content"];
    cell.ContentLabel.numberOfLines=3;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *time = [NSString stringWithFormat:@"%@",[_data [indexPath.row]objectForKey:@"create_time"]];
    cell.DateLabel.text=[AppUtil postSendTime:time];
    cell.delegate=self;
    cell.indexPath=indexPath;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"heightForRowAtIndexPath==%ld",indexPath.row);
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width-70*self.scale, 20*self.scale)];
    la.numberOfLines=3;
    la.text=[_data [indexPath.row]objectForKey:@"content"];
    la.font=DefaultFont(self.scale);
    [la sizeToFit];
    NSMutableArray *ar = [NSMutableArray new];
    for (int i=0; i<9; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i+1];
        NSString *na = _data[indexPath.row][str];
        if (![AppUtil isBlank:na]) {
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
    NSDictionary *attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:12*self.scale], NSParagraphStyleAttributeName:paragraphStyle1.copy};
    CGSize size1 = [str boundingRectWithSize:CGSizeMake(self.view.width-50*self.scale, 3500*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes1 context:nil].size;
    //    if (praArr.count>0&&[_data[indexPath.row][@"comments"] count]>0) {
    //        zanH=size1.height+10*self.scale;
    //    }else{
    //        zanH=size1.height+15*self.scale;
    //    }
    if (praArr.count<=0) {
        zanH=0;
    }
    NSArray *commitArr = _data[indexPath.row][@"comments"];
    float comH=5*self.scale;
    for (int i=0; i<commitArr.count; i++) {
        UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(5*self.scale, comH, self.view.width-90*self.scale, 2000)];
        la.font=[UIFont systemFontOfSize:12*self.scale];
        la.numberOfLines=0;
        la.text=[NSString stringWithFormat:@"%@：%@",commitArr[i][@"user_name"],commitArr[i][@"content"]];
        NSLog(@"%@",la.text);
        [la sizeToFit];
        comH+=la.height+5*self.scale;
    }
    return imgH+zanH+65*self.scale+la.height;
}

@end
