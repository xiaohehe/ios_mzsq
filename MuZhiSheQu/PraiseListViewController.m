//
//  PraiseListViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PraiseListViewController.h"
#import "PraiseTableViewCell.h"
#import "AppUtil.h"

@interface PraiseListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation PraiseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self newNav];
    [self listView];
}

-(void) listView{
    [_tableView registerClass:[PraiseTableViewCell class] forCellReuseIdentifier:@"PraiseTableViewCell"];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom,self.view.width, self.view.height-self.NavImg.bottom)];
    [self.view addSubview:_tableView];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.textColor  = [UIColor whiteColor];
    self.NavImg.backgroundColor = [UIColor whiteColor];
    UILabel * community=[[UILabel alloc] initWithFrame:CGRectMake(10*self.scale, self.TitleLabel.top+10, 100*self.scale, 20)];
    //community.textAlignment=NSTextAlignmentCenter;
    community.textColor = [UIColor blackColor];
    community.userInteractionEnabled=YES;
    community.font=[UIFont fontWithName:@"Helvetica-Bold" size:13*self.scale];
    //community.font=SmallFont(self.scale*1.1);
    community.attributedText=[self setPopContent];
    UITapGestureRecognizer *addressTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PopVC:)];
    [community addGestureRecognizer:addressTapGesture];
    [self.NavImg addSubview:community];
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0,[self getStartHeight]+44-.5, self.view.width, .5)];
    topline.backgroundColor=blackLineColore;
    [self.NavImg addSubview:topline];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSAttributedString*) setPopContent{
    NSString* comName=[NSString stringWithFormat:@" 点赞·%ld",[_data count]] ;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*self.scale;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PraiseTableViewCell *cell=[PraiseTableViewCell cellWithTableView:tableView];
    NSDictionary* dic=self.data[indexPath.row];
    cell.nameLa.text=dic[@"user_name"];
    [cell.headImg setImageWithURL:[NSURL URLWithString:dic[@"user_avatar"]] placeholderImage:[UIImage imageNamed:@"za"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString* create_time=[dic[@"create_time"] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSLog(@"create_time==%@",create_time);
    cell.dateLa.text=[AppUtil postSendTime2:dic[@"create_time"]];
    return cell;
}

@end
