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
#import "AddressTableViewCell.h"
#import "AppUtil.h"

@interface ShouHuoDiZhiListViewController ()<UITableViewDataSource,UITableViewDelegate,DiZhiTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource,*defArry;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *la;
@property(nonatomic,strong)UIButton *addBtn;
@property(nonatomic,strong) UIButton *editBtn;
@property(nonatomic,strong)NSMutableArray *removeList;//勾选时要删除的数据
//@property(nonatomic,assign)CGFloat dangerAreaHeight;
@end

@implementation ShouHuoDiZhiListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    //_dataSource=[NSMutableArray new];
    [self.activityVC startAnimate];
    _index=0;
    self.removeList = [[NSMutableArray alloc]init];
    [self reshData];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _index=0;
    //_dangerAreaHeight=self.isIphoneX?34:0;
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
    //NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    NSDictionary *dic = @{@"pindex":index};//@"user_id":userid,
    [anle getAddressListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            [_dataSource addObjectsFromArray:models];
        }
        NSLog(@"getAddressListWithDic==%@",models);
        if ([AppUtil arrayIsEmpty:_dataSource]) {
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom-49-self.dangerAreaHeight)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    //self.tableView.editing=true;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[DiZhiTableViewCell class] forCellReuseIdentifier:@"Cell"];
    UINib* memberNib=[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil];
    [self.tableView registerNib:memberNib forCellReuseIdentifier:@"address"];
   // [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    self.tableView.editing = NO;
    _addBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, _tableView.bottom, self.view.width, 49+self.dangerAreaHeight)];
    [_addBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    _addBtn.backgroundColor=[UIColor whiteColor];
    [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addBtn];
}

//删除地址
-(void)delAddress:(NSString*) ids{
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"userid":self.user_id,@"addressid":ids};
    [anle delAddressWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            self.tableView.editing=NO;
            self.tableView.allowsMultipleSelectionDuringEditing = NO;
            [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [_addBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
            [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if(self.removeList.count>0){
                [self.removeList removeAllObjects];
            }
            _index=0;
            [self reshData];
        }
    }];
}

-(void) addAddress{
    if(self.tableView.editing){
        if(self.removeList.count==0){
            [AppUtil showToast:self.view withContent:@"至少选择一个地址"];
            return;
        }
        NSMutableString* ids=[NSMutableString string];
        for(int i=0;i<self.removeList.count;i++){
            if(i==0){
                [ids appendString:[_dataSource[i] objectForKey:@"id"]];
            }else{
                [ids appendFormat:@",%@",[_dataSource[i] objectForKey:@"id"]];
            }
        }
        NSLog(@"removelist==%ld==%@",self.removeList.count,ids);
        [self delAddress:ids];
        return;
    }
    self.hidesBottomBarWhenPushed=YES;
    NewAdressViewController *newa =[NewAdressViewController new];
    [self.navigationController pushViewController:newa animated:YES];
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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    id deleteObject = [_dataSource objectAtIndex:row];
    [self.removeList removeObject:deleteObject];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(tableView.editing){
        NSUInteger row = [indexPath row];
        id addObject = [_dataSource objectAtIndex:row];
        [self.removeList addObject:addObject];
        return;
    }
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
    NSDictionary *dic = @{@"addressid":[_dataSource[indexPath.row] objectForKey:@"id"]};//@"user_id":self.user_id,
    [anle setDefaultAddressWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            AddressTableViewCell *cell=[_tableView cellForRowAtIndexPath:indexPath];
            [[NSUserDefaults standardUserDefaults]setObject:models forKey:@"address"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            for (AddressTableViewCell *cell1 in _defArry) {
                if (cell == cell1) {
                    cell1.defIv.hidden=NO;
                }else{
                    cell1.defIv.hidden=YES;
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
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address"];
    cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    NSString *ad = [_dataSource[indexPath.row] objectForKey:@"address"];
    if (![[_dataSource[indexPath.row] objectForKey:@"house_number"] isEqualToString:@""]) {
      ad = [ad stringByAppendingString:[_dataSource[indexPath.row] objectForKey:@"house_number"]];
    }
    cell.addrLb.text=ad;
    cell.nameLb.text=[NSString stringWithFormat:@"%@", [_dataSource[indexPath.row] objectForKey:@"real_name"]];
    cell.mobileLb.text=[NSString stringWithFormat:@"%@", [_dataSource[indexPath.row] objectForKey:@"mobile"]];
    if([[_dataSource[indexPath.row]objectForKey:@"is_default"]isEqualToString:@"0"]) {
        cell.defIv.hidden=YES;
    }else{
        cell.defIv.hidden=NO;
        [[NSUserDefaults standardUserDefaults]setObject:_dataSource[indexPath.row] forKey:@"address"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shopAddress" object:_dataSource[indexPath.row]];
    }
    [_defArry addObject:cell];
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
    //NSLog(@"bianjiAdress");
    self.hidesBottomBarWhenPushed=YES;
    EditeAdressViewController *edite = [EditeAdressViewController new];
    edite.data=_dataSource;
    edite.adressid = _dataSource[sender.tag][@"id"];
    edite.shouRen = _dataSource[sender.tag][@"real_name"];
    edite.shouTel = _dataSource[sender.tag][@"mobile"];
    edite.shouaddres = _dataSource[sender.tag][@"address"];
    edite.shousex = [NSString stringWithFormat:@"%@",_dataSource[sender.tag][@"sex"]];
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
    self.TitleLabel.text=@"选择地址";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    _editBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:grayTextColor forState:(UIControlStateNormal)];
//    [CarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _editBtn.titleLabel.font=Big15Font(1);
    [_editBtn addTarget:self action:@selector(SaveBtnVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:_editBtn];
    UIView *botline = [[UIView alloc]initWithFrame:CGRectMake(0, [self getStartHeight]+44-.5, self.view.width, .5)];
    botline.backgroundColor=blackLineColore;
    [self.NavImg addSubview:botline];
}

-(void)SaveBtnVC:(id)sender{
    if([AppUtil arrayIsEmpty:_dataSource]){
        [AppUtil showToast:self.view withContent:@"当前地址为空"];
        return;
    }
    if(!self.tableView.editing){
        //支持同时选中多行
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        [_editBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_addBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_addBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(self.removeList.count>0){
            [self.removeList removeAllObjects];
        }
    }
    self.tableView.editing=!self.tableView.editing;
}
-(void)PopVC:(id)sender{
     //[[NSNotificationCenter defaultCenter]postNotificationName:@"shopAddress" object:nil];
    [self.navigationController  popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//选择编辑的方式,按照选择的方式对表进行处理
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
        //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        self.hidesBottomBarWhenPushed=YES;
        EditeAdressViewController *edite = [EditeAdressViewController new];
        edite.data=_dataSource;
        edite.adressid = _dataSource[indexPath.row][@"id"];
        edite.shouRen = _dataSource[indexPath.row][@"real_name"];
        edite.shouTel = _dataSource[indexPath.row][@"mobile"];
        edite.shouaddres = _dataSource[indexPath.row][@"address"];
        edite.shousex = _dataSource[indexPath.row][@"sex"];
        edite.shoushequname = _dataSource[indexPath.row][@"community_name"];
        edite.xiaoquid =  _dataSource[indexPath.row][@"community"];
        edite.menpaihao=[_dataSource[indexPath.row] objectForKey:@"house_number"];
        if ([self.adressid isEqualToString:_dataSource[indexPath.row][@"id"]]) {
            edite.orfanData=YES;
        }
        if ([[_dataSource[indexPath.row]objectForKey:@"is_default"]isEqualToString:@"1"]) {
            edite.isdefent=YES;
        }
        [self.navigationController pushViewController:edite animated:YES];
    }];
    
    return @[deleteAction];
    
}
@end
