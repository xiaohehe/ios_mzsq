//
//  HomeManageViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HomeManageViewController.h"
#import "HomeManagerTableViewCell.h"
#import "InviteFamilyMembersViewController.h"
#import "PassValueDelegate.h"
#import "AppUtil.h"

@interface HomeManageViewController ()<UITableViewDataSource,UITableViewDelegate,PassValueDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) NSMutableArray* dataArray;//
@property(nonatomic,strong)UIButton *addBtn;

@end

@implementation HomeManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[[NSMutableArray alloc]init];
    [self newNav];
    [self newListView];
    [self.view addSubview:self.activityVC];
    [self reshData];
    [self newBottomView];
}

-(void)newBottomView{
    _addBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height-49-self.dangerAreaHeight, self.view.width, 49+self.dangerAreaHeight)];
    _addBtn.backgroundColor=[UIColor colorWithRed:1.000 green:0.933 blue:0.000 alpha:1.00];
    [_addBtn setTitle:@"添加新成员" forState:UIControlStateNormal];
    [_addBtn setTitleColor:[UIColor colorWithRed:0.224 green:0.220 blue:0.196 alpha:1.00] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(skipInviteFamilyMembersView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addBtn];
}

-(void)reshData{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle getFamilyMemberWithDic:nil Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"getFamilyMemberWithDic==%@",models);
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:models];
            [_tableView reloadData];
        }else{
            [self ShowAlertWithMessage:msg];
        }
    }];
}

-(void) newListView{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.frame.size.width,self.view.height-self.NavImg.height-(49+self.dangerAreaHeight))];
    [_tableView registerClass:[HomeManagerTableViewCell class] forCellReuseIdentifier:@"HomeManagerTableViewCell"];
    _tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"管理家庭成员";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    //    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    UIView *botline = [[UIView alloc]initWithFrame:CGRectMake(0, [self getStartHeight]+44-.5, self.view.width, .5)];
    botline.backgroundColor=blackLineColore;
    [self.NavImg addSubview:botline];
}

-(void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*self.scale;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

#pragma mark -数据源方法
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeManagerTableViewCell *cell=[HomeManagerTableViewCell cellWithTableView:tableView];
    NSString* status=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"Status"]];
    NSString* title=@"";
    NSString* name=_dataArray[indexPath.row][@"NickName"];
    if([AppUtil isBlank:name])
        name=_dataArray[indexPath.row][@"Mobile"];
    NSString* time=_dataArray[indexPath.row][@"AddTime"];
    if([status isEqualToString:@"1"]){
        title=[NSString stringWithFormat:@"%@ 加入时间 %@",name,time];
    }else{
        title=[NSString stringWithFormat:@"%@ 已邀请，未加入",name];
    }
    NSMutableAttributedString * titleAttributeString = [[NSMutableAttributedString alloc]initWithString:title];
    [titleAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15*self.scale] range:NSMakeRange(0, name.length)];
    [titleAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.00] range:NSMakeRange(0, name.length)];
    cell.nameLb.attributedText=titleAttributeString;
    cell.phoneLb.text=_dataArray[indexPath.row][@"Mobile"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) skipInviteFamilyMembersView{
    InviteFamilyMembersViewController* inviteFamilyMembersViewController=[[InviteFamilyMembersViewController alloc] init];
    inviteFamilyMembersViewController.delegate= self;
    inviteFamilyMembersViewController.fid=self.fid;
    inviteFamilyMembersViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:inviteFamilyMembersViewController animated:YES];
}

-(void) passValue:(NSArray *)arr{
    if(arr.count<=0)
        return;
    if([arr[0] isEqualToString:@"refresh"]){
        [self reshData];
    }
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
