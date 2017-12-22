//
//  FamilyViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FamilyViewController.h"
#import "EquityTableViewCell.h"
#import "HomeManageViewController.h"
#import "ActivityDetailsViewController.h"

@interface FamilyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIImageView *headerBg;
@property(nonatomic,strong)UIImageView *headerImg;
@property(nonatomic,strong)UILabel *nameLb;
@property(nonatomic,strong)UILabel *homeNameLb;

@property(nonatomic,strong)UILabel *integralTitleLb;
@property(nonatomic,strong)UILabel *integralLb;
@property(nonatomic,strong)UILabel *integralHintLb;
@property(nonatomic,strong)UILabel *memberTitleLb;
@property(nonatomic,strong)UILabel *memberLb;
@property(nonatomic,strong)UILabel *memberHintLb;
@property(nonatomic,strong)UIButton *convertBtn;
@property(nonatomic,strong)UIButton *addBtn;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) NSMutableArray* dataArray;//
@property(nonatomic,strong) NSDictionary* dic;//
@end

@implementation FamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[[NSMutableArray alloc]init];
    [self newNav];
    [self newListView];
    [self newHeaderView];
    [self.view addSubview:self.activityVC];
    [self reshData];
}

-(void) newHeaderView{
    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 180*self.scale+20)];
    _headerView.userInteractionEnabled=YES;
    _headerBg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, _headerView.width-20, _headerView.height-20)];
    _headerBg.backgroundColor=[UIColor colorWithRed:0.180 green:0.196 blue:0.271 alpha:1.00];
    _headerBg.layer.cornerRadius = 10;
    _headerBg.layer.masksToBounds = YES;
    _headerBg.userInteractionEnabled=YES;
    [_headerView addSubview:_headerBg];
    
    _headerImg=[[UIImageView alloc]initWithFrame:CGRectMake(15*self.scale, 15*self.scale, 35*self.scale, 35*self.scale)];
    [_headerImg setImageWithURL:[NSURL URLWithString:[Stockpile sharedStockpile].logo] placeholderImage:[UIImage imageNamed:@"round_edge"]];
    _headerImg.userInteractionEnabled=YES;
    _headerImg.layer.masksToBounds=YES;
    _headerImg.layer.cornerRadius=_headerImg.height/2;
    [_headerBg addSubview:_headerImg];
    
    _nameLb=[[UILabel alloc]initWithFrame:CGRectMake(_headerImg.right+10*self.scale, _headerImg.top, _headerView.width-_headerImg.right-30*self.scale, 20*self.scale)];
    _nameLb.textColor=[UIColor whiteColor];
    _nameLb.text=[Stockpile sharedStockpile].nickName;
    _nameLb.font=SmallFont(self.scale);
    [_headerBg addSubview:_nameLb];
    _homeNameLb=[[UILabel alloc]initWithFrame:CGRectMake(_headerImg.right+10*self.scale, _nameLb.bottom+5*self.scale, _headerView.width-_headerImg.right-30*self.scale, 15*self.scale)];
    _homeNameLb.textColor=[UIColor colorWithRed:0.898 green:0.761 blue:0.435 alpha:1.00];
    _homeNameLb.font=SmallFont(self.scale*0.9);
    [_headerBg addSubview:_homeNameLb];
    
    _integralTitleLb=[[UILabel alloc]initWithFrame:CGRectMake(0, _headerImg.bottom+15*self.scale, _headerBg.width/2, 20*self.scale)];
    _integralTitleLb.textColor=[UIColor whiteColor];
    _integralTitleLb.text=@"家庭积分";
    _integralTitleLb.textAlignment = NSTextAlignmentCenter;
    _integralTitleLb.font=SmallFont(self.scale);
    [_headerBg addSubview:_integralTitleLb];
    
    _integralLb=[[UILabel alloc]initWithFrame:CGRectMake(0, _integralTitleLb.bottom+5*self.scale, _headerBg.width/2, 20*self.scale)];
    _integralLb.textColor=[UIColor whiteColor];
    _integralLb.textAlignment = NSTextAlignmentCenter;
    _integralLb.font=[UIFont boldSystemFontOfSize:16];
    [_headerBg addSubview:_integralLb];
    
    _integralHintLb=[[UILabel alloc]initWithFrame:CGRectMake(0, _integralLb.bottom+5*self.scale, _headerBg.width/2, 20*self.scale)];
    _integralHintLb.textColor=[UIColor colorWithRed:0.588 green:0.596 blue:0.631 alpha:1.00];
    _integralHintLb.text=@"购物1元返1积分";
    _integralHintLb.font=SmallFont(self.scale*0.9);
    _integralHintLb.textAlignment = NSTextAlignmentCenter;
    [_headerBg addSubview:_integralHintLb];
    
    
    _memberTitleLb=[[UILabel alloc]initWithFrame:CGRectMake(_headerBg.width/2, _headerImg.bottom+15*self.scale, _headerBg.width/2, 20*self.scale)];
    _memberTitleLb.textColor=[UIColor whiteColor];
    _memberTitleLb.text=@"家庭成员";
    _memberTitleLb.textAlignment = NSTextAlignmentCenter;
    _memberTitleLb.font=SmallFont(self.scale);
    [_headerBg addSubview:_memberTitleLb];
    
    _memberLb=[[UILabel alloc]initWithFrame:CGRectMake(_headerBg.width/2, _memberTitleLb.bottom+5*self.scale, _headerBg.width/2, 20*self.scale)];
    _memberLb.textAlignment = NSTextAlignmentCenter;
    _memberLb.textColor=[UIColor whiteColor];
    _memberLb.font=[UIFont boldSystemFontOfSize:16];
    [_headerBg addSubview:_memberLb];
    
    _memberHintLb=[[UILabel alloc]initWithFrame:CGRectMake(_headerBg.width/2, _memberLb.bottom+5*self.scale, _headerBg.width/2, 20*self.scale)];
    _memberHintLb.textAlignment = NSTextAlignmentCenter;
    _memberHintLb.font=SmallFont(self.scale*0.9);
    _memberHintLb.textColor=[UIColor colorWithRed:0.588 green:0.596 blue:0.631 alpha:1.00];
    [_headerBg addSubview:_memberHintLb];
    
    _convertBtn=[[UIButton alloc]initWithFrame:CGRectMake(_headerBg.width/4-30*self.scale, _integralHintLb.bottom+10*self.scale, 60*self.scale, 20*self.scale)];
    [_convertBtn setTitle:@"去兑换" forState:UIControlStateNormal];
    [_convertBtn setTitleColor:[UIColor colorWithRed:0.176 green:0.196 blue:0.278 alpha:1.00] forState:UIControlStateNormal];
    _convertBtn.backgroundColor=[UIColor whiteColor];
    _convertBtn.layer.cornerRadius = _convertBtn.height/2;
    _convertBtn.layer.masksToBounds = YES;
    _convertBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [_convertBtn addTarget:self action:@selector(skipCovertView) forControlEvents:UIControlEventTouchUpInside];
    [_headerBg addSubview:_convertBtn];
    
    _addBtn=[[UIButton alloc]initWithFrame:CGRectMake(_headerBg.width/4*3-30*self.scale, _integralHintLb.bottom+10*self.scale, 60*self.scale, 20*self.scale)];
    [_addBtn setTitle:@"去添加" forState:UIControlStateNormal];
    [_addBtn setTitleColor:[UIColor colorWithRed:0.176 green:0.196 blue:0.278 alpha:1.00] forState:UIControlStateNormal];
    _addBtn.backgroundColor=[UIColor whiteColor];
    _addBtn.layer.cornerRadius = _convertBtn.height/2;
    _addBtn.layer.masksToBounds = YES;
    _addBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [_addBtn addTarget:self action:@selector(skipAddView) forControlEvents:UIControlEventTouchUpInside];
    [_headerBg addSubview:_addBtn];

    _tableView.tableHeaderView=_headerView;
}

-(void) newListView{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.frame.size.width,self.view.height-self.NavImg.height) style:UITableViewStyleGrouped];
    [_tableView registerClass:[EquityTableViewCell class] forCellReuseIdentifier:@"EquityTableViewCell"];
    //_tableView.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    _tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)setHomeInfo{
    _homeNameLb.text=_dic[@"HomeLeveName"];
    _integralLb.text=[NSString stringWithFormat:@"%@",_dic[@"Integral"]];
    _memberLb.text=[NSString stringWithFormat:@"%@",_dic[@"PCount"]];
    _memberHintLb.text=[NSString stringWithFormat:@"最多可添加%@人",_dic[@"SurplusCount"]];;

}

-(void)setFamilyInfo{
    NSString* fid=[Stockpile sharedStockpile].fID;
    NSLog(@"fid==%@",fid);
    if([fid isEqualToString:@"0"]){
         [[Stockpile sharedStockpile]setFID:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"ID"]]];
        [[Stockpile sharedStockpile]setIntegral:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"Integral"]]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"creatFamily" object:nil];

    }
}

-(void)reshData{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle getMyFamilyWithDic:nil Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"getMyFamilyWithDic==%@",models);
            [_dataArray removeAllObjects];
            _dic=models[@"Family"];
            [self setHomeInfo];
            //[self setFamilyInfo];
            [_dataArray addObjectsFromArray:models[@"Module"]];
            [_tableView reloadData];
        }else{
            [self ShowAlertWithMessage:msg];
        }
    }];
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"拇指家庭";
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
    if(_isToRoot){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    EquityTableViewCell *cell=[EquityTableViewCell cellWithTableView:tableView];
    [cell.iconIv setImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row][@"ModuleIcon"]] placeholderImage:[UIImage imageNamed:@"head_sculpture"]];
    cell.titleLb.text=_dataArray[indexPath.row][@"ModuleName"];
    cell.desLb.text=_dataArray[indexPath.row][@"ModuleTitle"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityDetailsViewController* activityDetailsViewController=[[ActivityDetailsViewController alloc] init];
    activityDetailsViewController.mid=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"ID"]];
    activityDetailsViewController.moduleName=[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"ModuleName"]];
    activityDetailsViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:activityDetailsViewController animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40*self.scale;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40*self.scale)];
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, self.view.width-20*self.scale, 20*self.scale)];
    titleLb.text =[NSString stringWithFormat:@"您已签约拇指家庭 享受%lu大权益",[_dataArray count]];
    titleLb.font = DefaultFont(self.scale*0.9);
    titleLb.textColor=[UIColor colorWithRed:0.839 green:0.604 blue:0.000 alpha:1.00];
    [headerView addSubview:titleLb];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10*self.scale,headerView.height-.5, self.view.width-20*self.scale, .5)];
    line.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [headerView addSubview:line];
    return headerView;
}

-(void) skipCovertView{
    ActivityDetailsViewController* activityDetailsViewController=[[ActivityDetailsViewController alloc] init];
    activityDetailsViewController.isConvert=YES;
    activityDetailsViewController.moduleName=@"积分兑换";
    activityDetailsViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:activityDetailsViewController animated:YES];
}

-(void) skipAddView{
    HomeManageViewController* homeManageViewController=[[HomeManageViewController alloc] init];
    homeManageViewController.fid=[NSString stringWithFormat:@"%@",_dic[@"ID"]];
    homeManageViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:homeManageViewController animated:YES];
}
@end
