//
//  MyReleaseViewController.m
//  MuZhiSheQu
//我的帖子
//  Created by lt on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyReleaseViewController.h"
#import "AppUtil.h"
#import "PassValueDelegate.h"
#import "ShareTableViewCell.h"
#import "GongGaoInfoViewController.h"
static const NSUInteger PRAISE_TAG = 20000;

@interface MyReleaseViewController ()<UITableViewDataSource,UITableViewDelegate,PassValueDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *la;
@end

@implementation MyReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [NSMutableArray array];
    [self newView];
    [self reshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)newView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
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
}

-(void)reshData{
    [self.activityVC startAnimate];
    _index++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    NSDictionary *dic = @{@"pindex":index,@"communityid":self.commid};
    [anle getMyNoticeList:dic Block:^(id models, NSString *code, NSString *msg) {
//        NSLog(@"getMyNoticeList==%ld==%@==%@==%@==%@",_index,code,msg,models,dic);
        [self.activityVC stopAnimate];
        if (_index==1) {
            [_data removeAllObjects];
        }
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if ([code isEqualToString:@"0"]) {
            NSArray* modArr=models[@"list"];
            [_data addObjectsFromArray:modArr];
            //NSLog(@"getNoticeListwallWithDic==%ld",modArr.count);
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
    cell.HeaderImage.tag=indexPath.row;
    cell.HeaderImage.userInteractionEnabled=YES;
    [cell.headBtn setTitle:[NSString stringWithFormat:@"%@",_data[indexPath.row][@"nickname"]] forState:UIControlStateNormal];
    [cell.headBtn addTarget:self action:@selector(nameTalk:) forControlEvents:UIControlEventTouchUpInside];
    cell.headBtn.tag=indexPath.row+1000;
    [cell.HeaderImage setImageWithURL:[NSURL URLWithString:_data[indexPath.row][@"avatar"]] placeholderImage:[UIImage imageNamed:@"not_1"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liaotian:)];
    [cell.HeaderImage addGestureRecognizer:tap];
    NSMutableArray *a = [NSMutableArray new];
    for (int i=0; i<9; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i+1];
        NSString *na = [NSString stringWithFormat:@"%@",_data[indexPath.row][str]];
        if (![AppUtil isBlank:na]) {
            [a addObject:na];
        }
    }
    if ([[NSString stringWithFormat:@"%@",_data[indexPath.row][@"praise_status"]] isEqualToString:@"1"]) {
        cell.praiseBtn.selected=YES;
    }else{
        cell.praiseBtn.selected=NO;
    }
    NSInteger praiseCount = [_data[indexPath.row][@"praisenumcount"] integerValue];
    NSLog(@"praisenumcount==%@",_data[indexPath.row][@"praisenumcount"]);
    if(praiseCount<99){
        [cell.praiseBtn setTitle:[NSString stringWithFormat:@"赞(%ld)",praiseCount] forState:UIControlStateNormal];
    }else{
        [cell.praiseBtn setTitle:@"赞(99+)" forState:UIControlStateNormal];
    }
    cell.praiseBtn.tag=PRAISE_TAG+indexPath.row;
    [cell.praiseBtn addTarget:self action:@selector(praise:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger commentCount=[_data[indexPath.row][@"commentcount"] integerValue];
    if(commentCount<99){
        [cell.commentBtn setTitle:[NSString stringWithFormat:@"评论(%ld)",commentCount] forState:UIControlStateNormal];
    }else{
        [cell.commentBtn setTitle:@"评论(99+)" forState:UIControlStateNormal];
    }
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

#pragma mark - 赞操作
-(void)praise:(UIButton*) sender{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"noticeid":_data[sender.tag-PRAISE_TAG][@"id"]};
    [anle NoticeWallAgreeWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            sender.selected=!sender.selected;
            NSMutableDictionary* dic=[_data[sender.tag-PRAISE_TAG] mutableCopy];
            dic[@"praise_status"]=[NSNumber numberWithInt:sender.selected?1:0];
            int praisenumcount=[dic[@"praisenumcount"] intValue];
            dic[@"praisenumcount"]=[NSNumber numberWithInt:sender.selected?++praisenumcount:--praisenumcount];
            NSLog(@"praisenumcount==%d==%@",praisenumcount,dic[@"praisenumcount"]);
            if(praisenumcount<99){
                [sender setTitle:[NSString stringWithFormat:@"赞(%d)",praisenumcount] forState:UIControlStateNormal];
            }else{
                [sender setTitle:@"赞(99+)" forState:UIControlStateNormal];
            }
            _data[sender.tag-PRAISE_TAG]=[dic copy];
           // [_data replaceObjectAtIndex:sender.tag-PRAISE_TAG withObject:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reshNeighbourhood" object:nil];
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath==%@",self.navigationController);
    [self.view endEditing:YES];
    self.hidesBottomBarWhenPushed=YES;
    GongGaoInfoViewController *infoVC=[[GongGaoInfoViewController alloc]init];
    infoVC.delegate= self;
    infoVC.gIndex=indexPath.row;
    infoVC.gDic=[_data[indexPath.row] mutableCopy];
    infoVC.gongID = _data[indexPath.row][@"id"];
    infoVC.type = _data[indexPath.row][@"notice_type"];
    [self.navigationController pushViewController:infoVC animated:YES];
    //self.hidesBottomBarWhenPushed=NO;
}

-(void) passValue:(NSArray *)arr{
    if(arr.count<=0)
        return;
    if([arr[0] isEqualToString:@"refresh"]){
        NSInteger gindex=[arr[1] integerValue];
        NSDictionary* dic=arr[2];
        [_data replaceObjectAtIndex:gindex withObject:dic];
        //        _isPass=true;
        //        NSDictionary* latestComments=[arr[1] copy];
        //        NSMutableArray* comments=[_postDic[@"comments"]  mutableCopy];
        //        [comments insertObject:latestComments atIndex:0];
        //        _postDic[@"comments"]=[comments copy];
        //        [_dataSource removeAllObjects];
        //        [_dataSource addObjectsFromArray:_postDic[@"comments"]];
        [_tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reshNeighbourhood" object:nil];
    }
}

@end
