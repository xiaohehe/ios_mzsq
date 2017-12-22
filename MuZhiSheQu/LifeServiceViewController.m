//
//  LifeServiceViewController.m
//  MuZhiSheQu
//  生活服务
//  Created by lt on 2017/8/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LifeServiceViewController.h"
#import "LiftServiceTypeViewController.h"

@interface LifeServiceViewController ()
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *data;

@end

@implementation LifeServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNav];
    [self setCollectionView];
    _data=[NSMutableArray new];
    [self reshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"社区黄页";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    //    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.height-.5, self.view.width, .5)];
    topline.backgroundColor=blackLineColore;
    [self.NavImg addSubview:topline];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----------右边宫格视图
-(void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, [self getStartHeight]+44, self.view.bounds.size.width, self.view.bounds.size.height-64) collectionViewLayout:layout];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.view addSubview:self.collectionView];
    //self.collectionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
}

#pragma mark -- 初始化数据和刷新数据
-(void)reshData{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"communityid":[self getCommid],@"lng":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]],@"lat":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]]};
    [anle leibiaol:dic Block:^(id models, NSString *code, NSString *msg) {
        [_data removeAllObjects];
        [self.activityVC stopAnimate];
        [_collectionView.header endRefreshing];
        if ([code isEqualToString:@"0"]){
            NSLog(@"leibiaol==%@",models);
            [_data addObjectsFromArray:models];
            if (_data.count>0) {
                [_collectionView reloadData];
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //NSLog(@"numberOfItemsInSection==%ld",_rightData.count);
    if(_data.count%3!=0)
        return _data.count+3-_data.count%3;
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, .5)];
    bottomline.backgroundColor=blackLineColore;
    [cell addSubview:bottomline];
    if(indexPath.row%3!=2){
        UIView *rightline = [[UIView alloc]initWithFrame:CGRectMake(cell.frame.size.height-.5, 0, .5, cell.frame.size.width)];
        rightline.backgroundColor=blackLineColore;
        [cell addSubview:rightline];
    }
    if(indexPath.row>=_data.count)
        return cell;
    NSDictionary* dic=_data[indexPath.row];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    name.textAlignment = NSTextAlignmentCenter;
    name.text=dic[@"class_name"];
    //cell.backgroundColor=[UIColor redColor];
    [cell addSubview:name];
    return cell;
}

//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float w = ([UIScreen mainScreen].bounds.size.width-2)/3;
    return CGSizeMake(w,w);
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

//动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return .5;
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return .5;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row>=_data.count)
        return;
    LiftServiceTypeViewController* typeViewController=[[LiftServiceTypeViewController alloc] init];
    typeViewController.hidesBottomBarWhenPushed=YES;
    typeViewController.type=_data[indexPath.row][@"class_name"];
    typeViewController.typeID=_data[indexPath.row][@"id"];
    [self.navigationController pushViewController:typeViewController animated:YES];
}

@end
