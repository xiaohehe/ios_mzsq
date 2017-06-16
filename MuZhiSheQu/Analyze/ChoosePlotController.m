//
//  ChoosePlotController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/5/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChoosePlotController.h"
#import "WXUtil.h"
#import "NSStringMD5.h"
#import "Plot.h"
#import "PlotCell.h"
#import "SheQuManagerViewController.h"
#import "JPUSHService.h"
#import "ChooseQuViewController.h"

@interface ChoosePlotController (){
    //UITextField *searchTf;
    UIView* currentPlotView;
    UIImageView* locationIv,*refreshIv;
    UILabel* plotNameLb;
    UIView* nearbyView;
    UILabel* nearbyLb;
    UITableView* plotTv;
    UIButton* chooseBtn;
    Plot* currentPlot;//当前社区，默认为第一个（最近的）
}
@end

@implementation ChoosePlotController

-(id)initWithBlock:(GuideBlock)block
{
    self=[super init];
    if (self) {
        _isRoot=true;
        _block=block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.plotArray=[[NSMutableArray alloc]init];
    [plotTv registerClass:[PlotCell class] forCellReuseIdentifier:@"PlotCell"];
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:18],
    NSForegroundColorAttributeName:[UIColor colorWithRed:0.035 green:0.035 blue:0.035 alpha:1.00]}];
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.926 blue:0.925 alpha:1.00];
    self.title=@"选择当前位置";
    //searchTf = [[UITextField alloc]initWithFrame:CGRectMake(15, 10, self.view.frame.size.width-30, 35)];
    //searchTf.borderStyle = UITextBorderStyleRoundedRect;
    //searchTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入小区名称" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.635 green:0.635 blue:0.635 alpha:1.00]}];
   // searchTf.placeholder=@"请输入小区名称";
    //searchTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //searchTf.layer.borderColor = [[UIColor colorWithRed:0.890 green:0.890 blue:0.890 alpha:1.00] CGColor];
    //searchTf.layer.borderWidth = 1.0;
    //searchTf.layer.cornerRadius=5.0f;
    //searchTf.backgroundColor=[UIColor redColor];
    //[self.view addSubview:searchTf];
    
    currentPlotView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    currentPlotView.backgroundColor=[UIColor whiteColor];
    if(!self.isRoot){
        [self.view addSubview:currentPlotView];
    }
    locationIv=[[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 16, 20)];
    [locationIv setImage:[UIImage imageNamed:@"location"]];
    [currentPlotView addSubview:locationIv];
    plotNameLb=[[UILabel alloc] initWithFrame:CGRectMake(50, 15, self.view.frame.size.width-120, 20)];
    plotNameLb.textColor=[UIColor colorWithRed:0.149 green:0.149 blue:0.149 alpha:1.00];
    plotNameLb.userInteractionEnabled=YES;
    UITapGestureRecognizer*tapGestureSkip = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipMain)];
    [plotNameLb addGestureRecognizer:tapGestureSkip];

    if(!self.isRoot){
        plotNameLb.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"commname"];
    }
    [currentPlotView addSubview:plotNameLb];
    refreshIv=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40, 16, 20, 18)];
    
     refreshIv.userInteractionEnabled=YES;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reposition)];
    [refreshIv addGestureRecognizer:tapGesture];
    
    [refreshIv setImage:[UIImage imageNamed:@"refresh"]];
    [currentPlotView addSubview:refreshIv];
    
    NSInteger y=0;
    if(!self.isRoot){
        y=currentPlotView.bottom;
    }
    nearbyView=[[UIView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 40)];
    nearbyView.backgroundColor=[UIColor colorWithRed:0.925 green:0.926 blue:0.925 alpha:1.00];
    [self.view addSubview:nearbyView];
    nearbyLb=[[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    nearbyLb.textColor=[UIColor colorWithRed:0.671 green:0.671 blue:0.671 alpha:1.00];
    nearbyLb.text=@"附近小区";
    nearbyLb.font = [UIFont systemFontOfSize:13];
    [nearbyView addSubview:nearbyLb];
    plotTv=[[UITableView alloc] initWithFrame:CGRectMake(0, nearbyView.bottom, self.view.frame.size.width,self.view.frame.size.height-nearbyView.bottom-64 )];
    plotTv.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:plotTv];
    
    [self requestNearlyPlot];
    plotTv.delegate=self;
    plotTv.dataSource=self;
    plotTv.separatorStyle = UITableViewCellSeparatorStyleNone;
    chooseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    chooseBtn.frame = CGRectMake(0, 0, 80.0f, 30.0f);
    [chooseBtn setTitle:@"手动选择" forState:normal];
    [chooseBtn addTarget:self action:@selector(skipChooseManually) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:chooseBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(blockgo) name:@"go" object:nil];
}

-(void)blockgo{
    _block(YES);
}

-(void) skipMain{
    if(!self.isRoot){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if(currentPlot==nil){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示" // 指定标题
                              message:@"请手动选择"  // 指定消息
                              delegate:nil
                              cancelButtonTitle:@"确定" // 为底部的取消按钮设置标题
                              // 不设置其他按钮
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"go" object:nil];
    [[NSUserDefaults standardUserDefaults]setObject:currentPlot.pid forKey:@"commid"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"GuideKey"];
    [[NSUserDefaults standardUserDefaults]setObject:currentPlot.name forKey:@"commname"];
    [[NSUserDefaults standardUserDefaults]setObject:currentPlot.province forKey:@"GuideShengId"];
    [[NSUserDefaults standardUserDefaults]setObject:currentPlot.province_name forKey:@"GuideShengName"];
    [[NSUserDefaults standardUserDefaults]setObject:currentPlot.district forKey:@"GuidequId"];
    [[NSUserDefaults standardUserDefaults]setObject:currentPlot.district_name forKey:@"GuidequName"];
    [[NSUserDefaults standardUserDefaults]setObject:currentPlot.city forKey:@"GuideShiId"];
    [[NSUserDefaults standardUserDefaults]setObject:currentPlot.city_name forKey:@"GuideShiName"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changeComm"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changeCommShang"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *tag =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"commid"]];
    NSSet * tagJihe = [NSSet setWithObjects:tag, nil];
    [JPUSHService setTags:tagJihe callbackSelector:@selector((tagsAliasCallback:tags:alias:)) object:self];
    [self gongGaoDian];
    AnalyzeObject *nale = [AnalyzeObject new];
    [nale getGJidWithDic:@{@"community_id":currentPlot.pid} Block:^(id models, NSString *code, NSString *msg) {
        if ([models isKindOfClass:[NSDictionary class]]) {
            [[NSUserDefaults standardUserDefaults]setObject:models[@"id"] forKey:@"tarid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];

}

/*重新定位*/
-(void) reposition{
    [self.appdelegate dingwei];
}

-(void)skipChooseManually{
    if(self.isRoot){
        ChooseQuViewController *ch = [[ChooseQuViewController alloc]initWithBlock:^(BOOL success) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"GuideKey"];
            //self.window.rootViewController=_tabBarController;
        }];
        [self.navigationController pushViewController:ch animated:YES];
        return;
    }
    SheQuManagerViewController * shequMVC = [[SheQuManagerViewController alloc]init];
    shequMVC.nojiantou = YES;
    shequMVC.delegate=self;
    shequMVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shequMVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.227 green:0.227 blue:0.227 alpha:1.00];
    self.tabBarController.tabBar.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestNearlyPlot)  name:@"requestNearlyPlot" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"requestNearlyPlot" object:nil];
}

-(void) requestNearlyPlot{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    NSString* lat= [[NSUserDefaults standardUserDefaults] objectForKey:@"lat"];
    NSString* lon=[[NSUserDefaults standardUserDefaults] objectForKey:@"lon"];
    NSLog(@"正在定位==%@  code==%@",lat,lon);
    if(([lat intValue]<1&&[lat intValue]>-1)||([lon intValue]<1&&[lon intValue]>-1)){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示" // 指定标题
                              message:@"定位失败，请手动选择"  // 指定消息
                              delegate:nil
                              cancelButtonTitle:@"确定" // 为底部的取消按钮设置标题
                              // 不设置其他按钮
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString* time=[self getTime];
    NSDictionary *dic = @{@"lng":lon,@"lat":lat,@"time":time,@"token":[self getMD5String:time]};
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle getNearbyCommunity:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        NSLog(@"附近==%@ ",models);
        [self.plotArray removeAllObjects];
        NSArray* arr=models;
        for(NSDictionary* obj in arr){
            Plot* plot=[[Plot alloc]init];
            plot.address=[obj objectForKey:@"address"];
            plot.city=[obj objectForKey:@"city"];
            plot.city_name=[obj objectForKey:@"city_name"];
            plot.distance=[obj objectForKey:@"distance"];
            plot.district=[obj objectForKey:@"district"];
            plot.district_name=[obj objectForKey:@"district_name"];
            plot.pid=[obj objectForKey:@"id"];
            plot.latitude=[obj objectForKey:@"latitude"];
            plot.longitude=[obj objectForKey:@"longitude"];
            plot.name=[obj objectForKey:@"name"];
            plot.province=[obj objectForKey:@"province"];
            plot.province_name=[obj objectForKey:@"province_name"];
            [self.plotArray addObject:plot];
        }
        if(self.plotArray.count>0&&_isRoot){
            currentPlot=self.plotArray[0];
            plotNameLb.text=currentPlot.name;
        }
        [plotTv reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*1.salt为：wVHOPgfEUm4RVVdz
2.hash为：fJn41RbkHY89JurR
 */
-(NSString*) getMD5String:(NSString*)time{
    return [NSStringMD5 stringToMD5:[NSString stringWithFormat:@"wVHOPgfEUm4RVVdz%@fJn41RbkHY89JurR",time]];
}

//获取时间戳
-(NSString*) getTime{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%d", (int)a];//转为字符型
    return timeString;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.plotArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlotCell *cell=[PlotCell cellWithTableView:tableView];
    Plot* plot=self.plotArray[indexPath.row];
    cell.name.text=plot.name;
    CGFloat dis=[plot.distance floatValue]/1000;
    if(dis<1){
        cell.distance.text=[NSString stringWithFormat:@"%@米",plot.distance];
    }else if(dis<10){
        cell.distance.text=[NSString stringWithFormat:@"%.2f千米",dis];
    }else{
        cell.distance.text=[NSString stringWithFormat:@"%.0f千米",dis];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.activityVC startAnimate];
    Plot* plot=self.plotArray[indexPath.row];
    AnalyzeObject *nale = [AnalyzeObject new];
    if(self.isRoot){
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        plotTv.userInteractionEnabled=NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"go" object:nil];
        [[NSUserDefaults standardUserDefaults]setObject:plot.pid forKey:@"commid"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"GuideKey"];
        [[NSUserDefaults standardUserDefaults]setObject:plot.name forKey:@"commname"];
        [[NSUserDefaults standardUserDefaults]setObject:plot.province forKey:@"GuideShengId"];
        [[NSUserDefaults standardUserDefaults]setObject:plot.province_name forKey:@"GuideShengName"];
        [[NSUserDefaults standardUserDefaults]setObject:plot.district forKey:@"GuidequId"];
        [[NSUserDefaults standardUserDefaults]setObject:plot.district_name forKey:@"GuidequName"];
        [[NSUserDefaults standardUserDefaults]setObject:plot.city forKey:@"GuideShiId"];
        [[NSUserDefaults standardUserDefaults]setObject:plot.city_name forKey:@"GuideShiName"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changeComm"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changeCommShang"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSString *tag =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"commid"]];
        NSSet * tagJihe = [NSSet setWithObjects:tag, nil];
        [JPUSHService setTags:tagJihe callbackSelector:@selector((tagsAliasCallback:tags:alias:)) object:self];
        [self gongGaoDian];
        [nale getGJidWithDic:@{@"community_id":plot.pid} Block:^(id models, NSString *code, NSString *msg) {
            if ([models isKindOfClass:[NSDictionary class]]) {
                [[NSUserDefaults standardUserDefaults]setObject:models[@"id"] forKey:@"tarid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
        return;
    }
    //  self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:userid forKey:@"user_id"];
    [dic setObject:plot.province forKey:@"province_id"];
    [dic setObject:plot.city forKey:@"city_id"];
    [dic setObject:plot.district forKey:@"district_id"];
    [dic setObject:plot.pid forKey:@"community_id"];
    [nale modifyCommunityAddressDicWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            [[NSUserDefaults standardUserDefaults]setObject:plot.pid forKey:@"commid"];
            [[NSUserDefaults standardUserDefaults]setObject:plot.name forKey:@"commname"];
            [[NSUserDefaults standardUserDefaults]setObject:plot.province forKey:@"GuideShengId"];
            [[NSUserDefaults standardUserDefaults]setObject:plot.province_name forKey:@"GuideShengName"];
            [[NSUserDefaults standardUserDefaults]setObject:plot.district forKey:@"GuidequId"];
            [[NSUserDefaults standardUserDefaults]setObject:plot.district_name forKey:@"GuidequName"];
            [[NSUserDefaults standardUserDefaults]setObject:plot.city forKey:@"GuideShiId"];
            [[NSUserDefaults standardUserDefaults]setObject:plot.city_name forKey:@"GuideShiName"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changeComm"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changeCommShang"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString *tag =[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"commid"]];
            NSSet * tagJihe = [NSSet setWithObjects:tag, nil];
            NSLog(@"%@",tagJihe);
            [JPUSHService setTags:tagJihe callbackSelector:@selector((tagsAliasCallback:tags:alias:)) object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadNearby" object:nil];
            //if (_xuanshequ==YES) {
            //    _xuanshequ=NO;
            //    self.tabBarController.selectedIndex=3;
            //    return;
            //}
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

-(void) passValue:(NSArray *)arr{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
