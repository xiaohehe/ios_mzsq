//
//  FindeshViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "FindeshViewController.h"
#import "UITabBar+badge.h"
#import "JPUSHService.h"
@interface FindeshViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *data;


@property(nonatomic,strong)GuideBlock block;
@end

@implementation FindeshViewController


-(id)initWithBlock:(GuideBlock)block
{
    self=[super init];
    if (self) {
        _block=block;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNav];
    
    _data=[NSMutableArray new];
    self.TitleLabel.text=@"选择您的小区";
    [self newView];
    
    [self reshData];
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    
    // Do any additional rrrrrrrrewwaa after loading the view.
}




-(void)reshData{
    [_data removeAllObjects];
    
    AnalyzeObject *anle = [AnalyzeObject new];
    
    NSDictionary *dic=nil;
        if (self.cityName.length>0) {
            dic = @{@"city_name":[Stockpile sharedStockpile].City,@"district_name":[Stockpile sharedStockpile].area};
        }else {
            dic = @{@"district_id":self.ID};

        }

    [anle getCommunityListWithDicWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            [_data addObjectsFromArray:models];
            [_tableview reloadData];
        }
    }];


}


-(void)newView{
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom) style:UITableViewStylePlain];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.rowHeight=44*self.scale;
    _tableview.backgroundColor=superBackgroundColor;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    
//表头试图
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40*self.scale)];
    footerView.backgroundColor = [UIColor whiteColor];
    [_tableview setTableHeaderView:footerView];
    
    
    UIButton *ding = [[UIButton alloc]init];
    ding.frame = CGRectMake(0*self.scale, 0, self.view.width - 24*self.scale, 40*self.scale);
    
    ding.titleLabel.font=DefaultFont(self.scale);
    [ding setTitle:[NSString stringWithFormat:@"当前定位城市为：%@%@",[Stockpile sharedStockpile].City,[Stockpile sharedStockpile].area] forState:UIControlStateNormal];
    [ding setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  //  [ding addTarget:self action:@selector(dingwei) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:ding];
    
    
    UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-50*self.scale, footerView.height/2-10*self.scale, 20*self.scale, 20*self.scale)];
    im.image=[UIImage imageNamed:@"mai_center_dw"];
    [footerView addSubview:im];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,footerView.bottom-.5, self.view.width, .5)];
    line.backgroundColor=blackLineColore;
    [footerView addSubview:line];
    
    
//表尾视图
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80*self.scale)];
    headerView.backgroundColor = [UIColor whiteColor];
    [_tableview setTableFooterView:headerView];
    
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, self.view.width-20*self.scale, 30*self.scale)];
    la.text=@"如果您所在的社区还未开通拇指便利，请访问下列网址查看拇指便利加盟代理：";
    la.numberOfLines=0;
    la.textAlignment=NSTextAlignmentCenter;
    la.font=Small10Font(self.scale);
    la.textColor=grayTextColor;
    [headerView addSubview:la];
    
    
    UILabel *wangzhi = [[UILabel alloc]initWithFrame:CGRectMake(0, la.bottom+20*self.scale, 0, 0)];
    wangzhi.text=@"www.mzsq.com(长按复制)";
    wangzhi.font=SmallFont(self.scale);
    [headerView addSubview:wangzhi];
    [wangzhi sizeToFit];
    wangzhi.userInteractionEnabled=YES;
    wangzhi.centerX=self.view.centerX;
    
    _tableview.tableFooterView.height=wangzhi.bottom+10*self.scale;
    
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(fuzhi:)];
    [wangzhi addGestureRecognizer:tap];

    
    
}



-(void)fuzhi:(UILongPressGestureRecognizer*)gesture{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"http://jm.mzsq.com";
        [self ShowAlertWithMessage:@"复制成功"];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
    
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 44*self.scale-.5, self.view.width, .5)];
        line.backgroundColor=blackLineColore;
        [cell addSubview:line];
        
        
    }
    cell.textLabel.font=Big15Font(self.scale);
    cell.textLabel.text=_data[indexPath.row][@"name"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _tableview.userInteractionEnabled=NO;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"go" object:nil];
    [[NSUserDefaults standardUserDefaults]setObject:_data[indexPath.row][@"id"] forKey:@"commid"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"GuideKey"];
    [[NSUserDefaults standardUserDefaults]setObject:_data[indexPath.row][@"name"] forKey:@"commname"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString *tag =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"commid"]];
    
    NSSet * tagJihe = [NSSet setWithObjects:tag, nil];
    
    [JPUSHService setTags:tagJihe callbackSelector:@selector((tagsAliasCallback:tags:alias:)) object:self];
    
    [self gongGaoDian];
    
    
    
        AnalyzeObject *nale = [AnalyzeObject new];
    
        [nale getGJidWithDic:@{@"community_id":_data[indexPath.row][@"id"]} Block:^(id models, NSString *code, NSString *msg) {
            if ([models isKindOfClass:[NSDictionary class]]) {
                [[NSUserDefaults standardUserDefaults]setObject:models[@"id"] forKey:@"tarid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        }];
        
        
        

    
    
    
}

#pragma mark------对比用户公告是否有小红点

-(void)gongGaoDian{
    
//    AnalyzeObject *anle = [AnalyzeObject new];
//    [anle GongGaoNum:@{@"community_id":[self getCommid]} Block:^(id models, NSString *code, NSString *msg) {
//        self.tabBarController.tabBar
        
    
//    }];
    
//    [self.tabBarController.tabBar showBadgeOnItemIndex:5];
    
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
    vi.backgroundColor=[UIColor redColor];
    [self.tabBarController.tabBar addSubview:vi];
}



#pragma mark - 导航
-(void)newNav{
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
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
