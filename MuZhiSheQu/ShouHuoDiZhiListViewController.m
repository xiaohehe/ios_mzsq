//
//  ShouHuoDiZhiListViewController.m
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShouHuoDiZhiListViewController.h"
#import "DiZhiTableViewCell.h"
#import "EditeAdressViewController.h"
#import "NewAdressViewController.h"
#import "UmengCollection.h"
@interface ShouHuoDiZhiListViewController ()<UITableViewDataSource,UITableViewDelegate,DiZhiTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource,*defArry;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *la;
@end

@implementation ShouHuoDiZhiListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    //_dataSource=[NSMutableArray new];
    [self.activityVC startAnimate];
    _index=0;
    [self reshData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _index=0;
    _dataSource=[NSMutableArray new];
    _defArry=[NSMutableArray new];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
}


-(void)reshData{
    if (_index==0) {
        [_dataSource removeAllObjects];
    }
    
    if (_la) {
        [_la removeFromSuperview];
    }
    _index++;
    AnalyzeObject *anle = [AnalyzeObject new];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    NSDictionary *dic = @{@"user_id":userid,@"pindex":index};
    
    [anle getAddressListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            [_dataSource addObjectsFromArray:models];
           
        }
        
        if (_dataSource.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
            _la.text=@"收货地址是空的，你可以添加新的收货地址";
            _la.textAlignment=NSTextAlignmentCenter;
            _la.font=DefaultFont(self.scale);
            _la.alpha=.6;
            [self.view addSubview:_la];
        }
        
         [_tableView reloadData];
    }];

}
-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[DiZhiTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 10;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *Fview=[[UIView alloc]init];
    Fview.backgroundColor=superBackgroundColor;
    return Fview;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *Hview=[[UIView alloc]init];
    Hview.backgroundColor=superBackgroundColor;
    return Hview;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *ui = [[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
    if (ui.count<=0) {
        [[NSUserDefaults standardUserDefaults]setObject:_dataSource[indexPath.row] forKey:@"address"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
   
    if (_orReturn) {
 [[NSNotificationCenter defaultCenter]postNotificationName:@"shopAddress" object:_dataSource[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];

        return;
    }
    
    
    [self.activityVC startAnimate];
    self.hidesBottomBarWhenPushed=YES;
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    
    NSDictionary *dic = @{@"user_id":self.user_id,@"address_id":[_dataSource[indexPath.row] objectForKey:@"id"]};
    
    [anle setDefaultAddressWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            DiZhiTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            cell.isDefault=YES;
            [[NSUserDefaults standardUserDefaults]setObject:models forKey:@"address"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            for (DiZhiTableViewCell *cell1 in _defArry) {
                if (cell == cell1) {
                    
                }else{
                    cell1.isDefault=NO;
                    
                }
            }
            
             [[NSNotificationCenter defaultCenter]postNotificationName:@"shopAddress" object:_dataSource[indexPath.row]];
            if (_orReturn) {
                [self.navigationController popViewControllerAnimated:YES];

            }
           
            
            
        }
    }];
    
    
    
    self.hidesBottomBarWhenPushed=NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiZhiTableViewCell *cell=(DiZhiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
   
    
    NSString *ad = [_dataSource[indexPath.row] objectForKey:@"address"];
    
    if (![[_dataSource[indexPath.row] objectForKey:@"house_number"] isEqualToString:@""]) {
        ad = [ad stringByAppendingString:[_dataSource[indexPath.row] objectForKey:@"house_number"]];
        
    }
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"address"]);
    
    
    cell.AdressLabel.text=[NSString stringWithFormat:@"收货地址：%@",ad];
    
    
   if([[_dataSource[indexPath.row]objectForKey:@"is_default"]isEqualToString:@"0"]) {
        cell.isDefault=NO;
    }else{
        cell.isDefault=YES;
        [[NSUserDefaults standardUserDefaults]setObject:_dataSource[indexPath.row] forKey:@"address"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shopAddress" object:_dataSource[indexPath.row]];

    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [_defArry addObject:cell];
    
    cell.NameLabel.text=[NSString stringWithFormat:@"收货人：%@      %@", [_dataSource[indexPath.row] objectForKey:@"real_name"],[_dataSource[indexPath.row] objectForKey:@"mobile"]];
    
    
    
  
    cell.delegate=self;
    [cell.EditButton addTarget:self action:@selector(bianjiAdress:) forControlEvents:UIControlEventTouchUpInside];
    cell.EditButton.tag=indexPath.row;
    cell.indexPath=indexPath;
    
    
    
    if (_dataSource.count==1) {
        [[NSUserDefaults standardUserDefaults]setObject:_dataSource[0] forKey:@"address"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*self.scale;
}
#pragma mark - 
-(void)DiZhiTableViewCellCaoZuo:(BOOL)isEdit IndexPath:(NSIndexPath *)indexPath{
    
}
-(void)DiZhiTableViewCellSetDefault:(BOOL)isDefault IndexPath:(NSIndexPath *)indexPath{
    
}

-(void)bianjiAdress:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
    EditeAdressViewController *edite = [EditeAdressViewController new];
    edite.data=_dataSource;
    edite.adressid = _dataSource[sender.tag][@"id"];
    edite.shouRen = _dataSource[sender.tag][@"real_name"];
    edite.shouTel = _dataSource[sender.tag][@"mobile"];
    edite.shouaddres = _dataSource[sender.tag][@"address"];
    edite.shousex = _dataSource[sender.tag][@"sex"];
    edite.shoushequname = _dataSource[sender.tag][@"community_name"];
    edite.xiaoquid =  _dataSource[sender.tag][@"community"];
    edite.menpaihao=[_dataSource[sender.tag] objectForKey:@"house_number"];
    if ([self.adressid isEqualToString:_dataSource[sender.tag][@"id"]]) {
        edite.orfanData=YES;
    }
    
    if ([[_dataSource[sender.tag]objectForKey:@"is_default"]isEqualToString:@"1"]) {
        edite.isdefent=YES;
    }
    
        [self.navigationController pushViewController:edite animated:YES];
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"我的收货地址";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton *CarBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [CarBtn setTitle:@"新增" forState:UIControlStateNormal];
    [CarBtn setTitleColor:grayTextColor forState:(UIControlStateNormal)];
//    [CarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CarBtn.titleLabel.font=Big15Font(1);
    [CarBtn addTarget:self action:@selector(SaveBtnVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:CarBtn];
}
-(void)SaveBtnVC:(id)sender{
    self.hidesBottomBarWhenPushed=YES;
    NewAdressViewController *newa =[NewAdressViewController new];
    [self.navigationController pushViewController:newa animated:YES];
}
-(void)PopVC:(id)sender{
     //[[NSNotificationCenter defaultCenter]postNotificationName:@"shopAddress" object:nil];
    [self.navigationController  popViewControllerAnimated:YES];
}
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
