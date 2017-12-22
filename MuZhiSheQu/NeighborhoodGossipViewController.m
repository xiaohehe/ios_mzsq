//
//  NeighborhoodGossipViewController.m
//  MuZhiSheQu
//邻里杂谈
//  Created by lt on 2017/10/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NeighborhoodGossipViewController.h"
#import "ShareTableViewCell.h"
#import "GongGaoInfoViewController.h"
#import "AppUtil.h"
#import "IMViewController.h"
#import "GanXiShopViewController.h"
#import "BreakInfoViewController.h"
#import "PassValueDelegate.h"
static const NSUInteger PRAISE_TAG = 10000;

@interface NeighborhoodGossipViewController ()<UITableViewDataSource,UITableViewDelegate,PassValueDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *la;
@property(nonatomic,strong)UITextField *mesay;
@property(nonatomic,strong)CellView *bv;
@property(nonatomic,strong)NSIndexPath *indexPath;
@end

@implementation NeighborhoodGossipViewController

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
    _data = [NSMutableArray new];
    //[self newView];
    [self reshData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiala)  name:@"reshNeighbourhood" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    NSDictionary *dic = @{@"userid":self.user_id,@"pindex":index,@"communityid":self.commid};
    [anle getNoticeListwallWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        NSLog(@"getNoticeListwallWithDic==%ld==%@==%@==%@",_index,code,msg,models);
        [self.activityVC stopAnimate];
        if (_index==1) {
            [_data removeAllObjects];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"endRefresh" object:nil];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if ([code isEqualToString:@"0"]) {
            NSArray* modArr=models;
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
    cell.HeaderImage.tag=indexPath.row;
    cell.HeaderImage.userInteractionEnabled=YES;
    [cell.headBtn setTitle:[NSString stringWithFormat:@"%@",_data[indexPath.row][@"nickname"]] forState:UIControlStateNormal];
//    [cell.headBtn addTarget:self action:@selector(nameTalk:) forControlEvents:UIControlEventTouchUpInside];
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
            if(praisenumcount<99){
                [sender setTitle:[NSString stringWithFormat:@"赞(%d)",praisenumcount] forState:UIControlStateNormal];
            }else{
                [sender setTitle:@"赞(99+)" forState:UIControlStateNormal];
            }
            [_data replaceObjectAtIndex:sender.tag-PRAISE_TAG withObject:dic];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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

#pragma mark - 赞操作
-(void)ShareTableViewCellWith:(NSIndexPath *)indexPath{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dic = @{@"user_id":self.user_id,@"notice_id":_data[indexPath.row][@"id"]};
    [anle NoticeWallAgreeWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            NSArray *arr=_data[indexPath.row][@"praisers"];
            NSMutableArray *new=[NSMutableArray arrayWithArray:arr];
            NSMutableDictionary *dic=[NSMutableDictionary new];
            NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithDictionary:_data[indexPath.row]];
            [dic setObject:[Stockpile sharedStockpile].nickName forKey:@"user_name"];
            if ([[NSString stringWithFormat:@"%@",_data[indexPath.row][@"praise_status"]] isEqualToString:@"1"]) {
                [new removeObject:dic];
                [dataDic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"praise_status"];
            }else{
                [new addObject:dic];
                [dataDic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"praise_status"];
            }
            [dataDic setObject:new forKey:@"praisers"];
            [_data replaceObjectAtIndex:indexPath.row withObject:dataDic];
            [_tableView reloadData];
        }
    }];
}

#pragma mark - 评论操作
-(void)CommitTableViewCellWith:(NSIndexPath *)indexPath{
    [_mesay becomeFirstResponder];
    _indexPath=indexPath;
}

-(void)liaotian:(UIGestureRecognizer *)view{
    if ([[NSString stringWithFormat:@"%@",_data[view.view.tag][@"notice_type"]] isEqualToString:@"2"]) {
        NSString *add = @"";
        if ([_data[view.view.tag][@"shop_info"][@"status"] isEqualToString:@"3"]) {
            add=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
            //        cell.addLa.textColor=[UIColor redColor];
            
            //        return cell;
        }else{
            NSString *week = [self weekdayStringFromDate:[NSDate date]];
            if ([week isEqualToString:@"周六"]) {
                if ([_data[view.view.tag][@"shop_info"][@"off_on_saturday"] isEqualToString:@"2"]) {
                    add=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
                    //                cell.addLa.textColor=[UIColor redColor];
                    //                return cell;
                }
            }else if ([week isEqualToString:@"周日"]){
                if ([_data[view.view.tag][@"shop_info"][@"off_on_sunday"] isEqualToString:@"2"]) {
                    add=@"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
                    //                cell.addLa.textColor=[UIColor redColor];
                    //                return cell;
                }
            }
        }
        if ([add isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
            [self Liaotiao:YES btn:view];
            return;
        }
        BOOL isSleep1=YES;
        BOOL isSleep2=YES;
        BOOL isSleep3=YES;
        NSArray *timArr  = [_data[view.view.tag][@"shop_info"][@"business_hour"] componentsSeparatedByString:@","];
        NSDate *now = [NSDate date];
        NSDateFormatter *nowFo = [[NSDateFormatter alloc]init];
        [nowFo setDateFormat:@"yyyy-MM-dd"];
        NSString *noewyers = [nowFo stringFromDate:now];
        for (NSString *str in timArr) {
            if ([str isEqualToString:@"1"]) {
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[view.view.tag][@"shop_info"][@"business_start_hour1"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[view.view.tag][@"shop_info"][@"business_end_hour1"]]];
                NSDateFormatter *fo = [[NSDateFormatter alloc]init];
                [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *das = [fo dateFromString:timeStart1];
                NSDate *dad = [fo dateFromString:timeEnd1];
                NSDate *dates = [self getNowDateFromatAnDate:das];
                NSDate *dated = [self getNowDateFromatAnDate:dad];
                NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
                //开始的时间戳
                double times = [dates timeIntervalSince1970];
                //结束的时间戳
                double timed = [dated timeIntervalSince1970];
                //现在的时间戳
                double timen = [daten timeIntervalSince1970];
                if (timen>times && timen<timed) {
                    isSleep1=NO;
                }else{
                    isSleep1=YES;
                }
            } if ([str isEqualToString:@"2"]) {
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[view.view.tag][@"shop_info"][@"business_start_hour2"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[view.view.tag][@"shop_info"][@"business_end_hour2"]]];
                NSDateFormatter *fo = [[NSDateFormatter alloc]init];
                [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *das = [fo dateFromString:timeStart1];
                NSDate *dad = [fo dateFromString:timeEnd1];
                NSDate *dates = [self getNowDateFromatAnDate:das];
                NSDate *dated = [self getNowDateFromatAnDate:dad];
                NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
                //开始的时间戳
                double times = [dates timeIntervalSince1970];
                //结束的时间戳
                double timed = [dated timeIntervalSince1970];
                //现在的时间戳
                double timen = [daten timeIntervalSince1970];
                if (timen>times && timen<timed) {
                    isSleep2=NO;
                }else{
                    isSleep2=YES;
                }
            }else  if ([str isEqualToString:@"3"]) {
                NSString *timeStart1 = [noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[view.view.tag][@"shop_info"][@"business_start_hour3"]]];
                NSString *timeEnd1 =[noewyers stringByAppendingString:[NSString stringWithFormat:@" %@",_data[view.view.tag][@"shop_info"][@"business_end_hour3"]]];
                NSDateFormatter *fo = [[NSDateFormatter alloc]init];
                [fo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *das = [fo dateFromString:timeStart1];
                NSDate *dad = [fo dateFromString:timeEnd1];
                NSDate *dates = [self getNowDateFromatAnDate:das];
                NSDate *dated = [self getNowDateFromatAnDate:dad];
                NSDate *daten = [self getNowDateFromatAnDate:[NSDate date]];
                //开始的时间戳
                double times = [dates timeIntervalSince1970];
                //结束的时间戳
                double timed = [dated timeIntervalSince1970];
                //现在的时间戳
                double timen = [daten timeIntervalSince1970];
                if (timen>times && timen<timed) {
                    isSleep3=NO;
                }else{
                    isSleep3=YES;
                }
            }
        }
        //-----------------
        if (isSleep1==NO || isSleep2==NO || isSleep3==NO) {
        }else{
            add = @"商铺正在休息中，您所提交的订单会在营业后第一时间处理";
        }
        if ([_data[view.view.tag][@"shop_info"][@"business_hour"] isEqualToString:@""]) {
            add=@"";
        }
        //-----------------是否休息判断end
        BOOL issleep;
        if ([add isEqualToString:@"商铺正在休息中，您所提交的订单会在营业后第一时间处理"]) {
            issleep=YES;
        }else{
            issleep=NO;
        }
        [self Liaotiao:issleep btn:view];
        return;
    }
    //self.hidesBottomBarWhenPushed=YES;
    IMViewController *chatService = [IMViewController new];
    chatService.hidesBottomBarWhenPushed=YES;
    chatService.targetId = [NSString stringWithFormat:@"%@",_data[view.view.tag][@"user_id"]];
    chatService.conversationType = ConversationType_PRIVATE;
    chatService.title = _data[view.view.tag][@"publisher"];
    [self.navigationController pushViewController: chatService animated:YES];
    //self.hidesBottomBarWhenPushed=NO;
}

-(void)Liaotiao:(BOOL)issleep btn:(UIGestureRecognizer *)btn{
    //商家
    if ([_data[btn.view.tag][@"shop_info"][@"shop_type"] isEqualToString:@"2"]) {
        //        IMViewController *ganxi = [[IMViewController alloc]init];
        //        ganxi.conversationType = ConversationType_PRIVATE;
        //        ganxi.targetId = _data[btn.view.tag][@"shop_info"][@"shop_user_id"];
        //        // _conversationVC.userName = @"123456";
        //        ganxi.title = _data[btn.view.tag][@"shop_info"][@"shop_name"];
        self.hidesBottomBarWhenPushed=YES;
        GanXiShopViewController *ganxi = [GanXiShopViewController new];
        if ([_data[btn.view.tag][@"shop_info"][@"is_open_chat"]isEqualToString:@"2"]) {
            ganxi.isOpen=NO;
        }else{
            ganxi.isOpen=YES;
        }
        ganxi.issleep=issleep;
        ganxi.ID=_data[btn.view.tag][@"shop_info"][@"id"];
        ganxi.titlee=_data[btn.view.tag][@"shop_info"][@"shop_name"];
        ganxi.topSetimg = _data[btn.view.tag][@"shop_info"][@"logo"];
        ganxi.shop_user_id=_data[btn.view.tag][@"shop_info"][@"user_id"];
        [self.navigationController pushViewController:ganxi animated:YES];
       // self.hidesBottomBarWhenPushed=NO;
    }else{
        self.hidesBottomBarWhenPushed=YES;
        BreakInfoViewController *info = [[BreakInfoViewController alloc]init];
        NSLog(@"_data[btn.view.tag]==%@",_data[btn.view.tag]);
        if ([_data[btn.view.tag][@"shop_info"][@"is_open_chat"]isEqualToString:@"2"]) {
            info.isopen=NO;
        }else{
            info.isopen=YES;
        }
        info.tel = [NSString stringWithFormat:@"%@",_data[btn.view.tag][@"shop_info"][@"hotline"]];
        info.issleep=issleep;
        info.ID=_data[btn.view.tag][@"shop_info"][@"id"];
        info.titlete=_data[btn.view.tag][@"shop_info"][@"shop_name"];
        info.shopImg = _data[btn.view.tag][@"shop_info"][@"logo"];
        info.gonggao = _data[btn.view.tag][@"shop_info"][@"notice"];
        info.yunfei =_data[btn.view.tag][@"shop_info"][@"delivery_fee"];
        info.manduoshaofree=_data[btn.view.tag][@"shop_info"][@"free_delivery_amount"];
        info.shop_user_id=_data[btn.view.tag][@"shop_info"][@"user_id"];
        [self.navigationController pushViewController:info animated:YES];
       // self.hidesBottomBarWhenPushed=NO;
    }
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
    }
}

@end
