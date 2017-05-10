//
//  ChooseQuViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ChooseQuViewController.h"

@interface ChooseQuViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)int type;
@property(nonatomic,strong)GuideBlock block;
@property(nonatomic,strong)UINavigationController *nav;
@end

@implementation ChooseQuViewController



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

    
    
    _type=2;
    _data=[NSMutableArray new];
    self.TitleLabel.text=@"选择服务社区";
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    [self newView];
    [self reshData];

    [self ding];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(blockgo) name:@"go" object:nil];
    
    // Do any additional setup after loading the view.
}
-(void)blockgo{
    _block(YES);
    
}

-(void)ding{

    [[CCLocation sharedCCLocation]getLocation:^(CLLocationCoordinate2D locationCoordinate2D, NSString *country, NSString *city, NSString *place ,NSString *area) {
        
        if([city isChinese] ){
            NSString *lat = [NSString stringWithFormat:@"%f",locationCoordinate2D.latitude];
            NSString *lon = [NSString stringWithFormat:@"%f",locationCoordinate2D.longitude];
            //
            [[Stockpile sharedStockpile]setCity:[NSString stringWithFormat:@"%@",city]];
            [[Stockpile sharedStockpile] setArea:[NSString stringWithFormat:@"%@",area]];
            
            [[NSUserDefaults standardUserDefaults]setObject:lat  forKey:@"lat"];
            [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"lon"];
            
            
            //            [[NSUserDefaults standardUserDefaults]setObject:lat  forKey:@"latitude"];
            //            [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"longitude"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            UIButton *ding = (UIButton *)[self.view viewWithTag:909];
            
            [ding setTitle:[NSString stringWithFormat:@"当前定位城市为：%@%@",[Stockpile sharedStockpile].City,[Stockpile sharedStockpile].area] forState:UIControlStateNormal];

            
            
                    }
        
        
    }];
    

}



-(void)reshData{
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle getProvinceListWithDic:nil Block:^(id models, NSString *code, NSString *msg) {
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


    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40*self.scale)];
    footerView.backgroundColor = [UIColor whiteColor];
    [_tableview setTableHeaderView:footerView];
    
    
    UIButton *ding = [[UIButton alloc]init];
    ding.frame = CGRectMake(0*self.scale, 0, self.view.width - 24*self.scale, 40*self.scale);
    ding.tag=909;
    ding.titleLabel.font=DefaultFont(self.scale);
    [ding setTitle:@"正在定位中" forState:UIControlStateNormal];
    [ding setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [ding addTarget:self action:@selector(dingwei) forControlEvents:UIControlEventTouchUpInside];
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
    la.text=@"如果您所在的社区还未开通拇指社区，请访问下列网址查看拇指社区加盟代理：";
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
-(void)dingwei{

    
    FindeshViewController *find = [FindeshViewController new];
    find.cityName = [Stockpile sharedStockpile].City ;
    [self.navigationController pushViewController:find animated:YES];
    

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
    self.hidesBottomBarWhenPushed=YES;
    CityViewController *city = [CityViewController new];
    city.ID=_data[indexPath.row][@"id"];
    [[NSUserDefaults standardUserDefaults]setObject:_data[indexPath.row][@"name"] forKey:@"GuideShengName"];
     [[NSUserDefaults standardUserDefaults]setObject:_data[indexPath.row][@"id"] forKey:@"GuideShengId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    [self.navigationController pushViewController:city animated:YES];
    
//    if (_type==2) {
//        _type=3;
//        
//        [self reshData1:_data[indexPath.row][@"id"]];
//        [_tableview reloadData];
//    }else if(_type==3){
//        _type=4;
//        [self reshData2:_data[indexPath.row][@"id"]];
//        [_tableview reloadData];
//    
//    }else if(_type==4){
//        
//        _type=0;
//       [self reshData3:_data[indexPath.row][@"id"]];
//        [_tableview reloadData];
//    }else{
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//
//    }
//   
    

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
