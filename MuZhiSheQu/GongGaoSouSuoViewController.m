//
//  GongGaoSouSuoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GongGaoSouSuoViewController.h"
#import "CityCell.h"
#import "UmengCollection.h"
@interface GongGaoSouSuoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)GongGaoBlock block;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation GongGaoSouSuoViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    self.view.alpha=0;
    self.view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"]) {
        _tableView.frame=CGRectMake(0, 0, self.view.width, self.view.height);
    }
}
-(void)dealloc{
    [self.view removeObserver:self forKeyPath:@"frame" context:nil];
}
-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[CityCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   NSArray *Arr=@[@"社区公告",@"商家公告",@"用户公告",@"二手闲置",@"所有公告"];
    CityCell *cell=(CityCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.indexPath=indexPath;
    cell.titleLabel.text=Arr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *Arr=@[@"社区公告",@"商家公告",@"用户公告",@"二手闲置",@"所有公告"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)indexPath.row],@"id",Arr[indexPath.row],@"name", nil];
    if (_block) {
        _block(dic);
    }
    [self HiddenView];
}

-(void)ShowViewWithBlock:(GongGaoBlock)block{
  
     _block=block;
    [UIView animateWithDuration:.3 animations:^{
        self.view.alpha=1;
        _tableView.frame=CGRectMake(0, 0, self.view.width, self.view.height);
       
    } completion:^(BOOL finished) {
        
    }];
}
-(void)HiddenView{
    [UIView animateWithDuration:.3 animations:^{
        _tableView.frame=CGRectMake(0, 0, self.view.width, 0);
         self.view.alpha=0;
    } completion:^(BOOL finished) {
       
    }];
}
#pragma mark - 导航
-(void)newNav{
    self.NavImg.hidden=YES;
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
