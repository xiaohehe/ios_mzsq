//
//  SheQuManagerViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SheQuManagerViewController.h"
#import "CellView.h"
#import "ShengViewController.h"
#import "ShiViewController.h"
#import "QuuViewController.h"
#import "CommQuViewController.h"
#import "UmengCollection.h"
#import "JPUSHService.h"
@interface SheQuManagerViewController ()
@property(nonatomic,strong)NSMutableDictionary *dic;
@property(nonatomic,strong)NSMutableArray *datad,*idArr,*xuande;
@property(nonatomic,strong)NSDictionary *dc;
@property(nonatomic,strong)NSString *sheng,*shi,*qu,*shequ;
@property(nonatomic,strong)NSString *shengid,*shiid,*quid,*shequid;
@property(nonatomic,strong)NSMutableDictionary *xuanData;
@end

@implementation SheQuManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dc = [[NSUserDefaults standardUserDefaults]objectForKey:@"logodata"];
    _dic = [NSMutableDictionary new];
    _datad = [NSMutableArray new];
    _idArr=[NSMutableArray new];
    _xuande=[NSMutableArray new];
    _xuanData = [NSMutableDictionary new];
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(biansheng:) name:@"sheng" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bianshi:) name:@"shi" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bianqu:) name:@"qu" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(biancommqu:) name:@"commqu" object:nil];
}




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
-(void)newView{
    
    
   // NSArray *ar = @[@"province",@"city",@"community",@"community_name"];
    NSString *sn = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"GuideShengName"]];
    NSString *si = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"GuideShengId"]];

    NSString *shn = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"GuideShiName"]];
    NSString *shi = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"GuideShiId"]];

    NSString *qn = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"GuidequName"]];
    NSString *qi = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"GuidequId"]];
    
    NSString *shen = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"commid"]];
    NSString *shei = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"commname"]];

//    if (sn==nil || [sn isEqualToString:@""]) {
//        shn=@"";
//        qn=@"";
//        shei=@"";
//    }

    
    NSArray *ar = @[sn,shn,qn,shei];
    _sheng=ar[0];
    _shi=ar[1];
    _qu=ar[2];
    _shequ=ar[3];
    _shengid=si;
    _shiid=shi;
    _quid=qi;
    _shequid=shen;
    
    if (_sheng==nil || [_sheng isEqualToString:@""]) {
        _shi=@"";
        _qu=@"";
        _shequ=@"";
    }
    
    
    
    NSArray *arr = @[@"所在省份",@"所在城市",@"所在区域",@"社区名称"];
 //   NSArray *arr1 = @[@"所在省份",@"所在城市",@"所在区域",@"社区名称"];
    
    float setY=self.NavImg.bottom+ 10*self.scale;
    for (int i=0; i<4; i++) {
        
        CellView *sheng = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 44*self.scale)];
        sheng.title=arr[i];
        sheng.tag=i+10;
        
        sheng.content=ar[i];
    
        sheng.contentLabel.textAlignment=NSTextAlignmentRight;
        [self.view addSubview:sheng];
        
        setY = sheng.bottom;
        
        UIImageView *jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-20*self.scale, sheng.contentLabel.top-2*self.scale, 20*self.scale, 25*self.scale)];
        jiantou.image=[UIImage imageNamed:@"xq_right"];
        [sheng addSubview:jiantou];
        
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, sheng.width, sheng.height)];
        btn.tag=i+1;
        [btn addTarget:self action:@selector(xun:) forControlEvents:UIControlEventTouchUpInside];
        [sheng addSubview:btn];
        
        
        
        
    }
    
    UIButton *save = [[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, setY+10*self.scale, self.view.width-20*self.scale, 35*self.scale)];
    save.backgroundColor=blueTextColor;
    [save setTitle:@"保存" forState:UIControlStateNormal];
    save.titleLabel.font=DefaultFont(self.scale);
    save.layer.cornerRadius=5;
    [save addTarget:self action:@selector(saveEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
    
    
    
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, save.bottom+30*self.scale, self.view.width-20*self.scale, 30*self.scale)];
    la.text=@"如果您所在的社区还未开通拇指社区，请访问下列网址查看拇指社区加盟代理：";
    la.numberOfLines=0;
    la.textAlignment=NSTextAlignmentCenter;
    la.font=Small10Font(self.scale);
    la.textColor=grayTextColor;
    [self.view addSubview:la];
    
    
    UILabel *wangzhi = [[UILabel alloc]initWithFrame:CGRectMake(0, la.bottom+30*self.scale, 0, 0)];
    wangzhi.text=@"www.mzsq.com(长按复制)";
    wangzhi.font=SmallFont(self.scale);
    [self.view addSubview:wangzhi];
    [wangzhi sizeToFit];
    wangzhi.userInteractionEnabled=YES;
    wangzhi.centerX=self.view.centerX;
    
    
    
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(fuzhi:)];
    [wangzhi addGestureRecognizer:tap];

    
    

}

-(void)fuzhi:(UILongPressGestureRecognizer *)gesture{

    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"http://www.mzsq.com";
        [self ShowAlertWithMessage:@"复制成功"];
    }


}

-(void)saveEvent{
    
    if ([_sheng isEqualToString:@""] || [_shi isEqualToString:@""] || [_shequ isEqualToString:@""]) {
        [self ShowAlertWithMessage:@"完善信息后保存"];
        return;
    }
    
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    [[NSUserDefaults standardUserDefaults]setObject:_dic forKey:@"commaddress"];
    [[NSUserDefaults standardUserDefaults]setObject:_xuande forKey:@"xuandata"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    AnalyzeObject *nale = [AnalyzeObject new];
  //  self.commid = [[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
     NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:userid forKey:@"user_id"];
    [dic setObject:_shengid forKey:@"province_id"];
    [dic setObject:_shiid forKey:@"city_id"];
    [dic setObject:_quid forKey:@"district_id"];
    [dic setObject:_shequid forKey:@"community_id"];
    
    [nale modifyCommunityAddressDicWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];

        if ([code isEqualToString:@"0"]) {
            [[NSUserDefaults standardUserDefaults]setObject:_shequid forKey:@"commid"];
            [[NSUserDefaults standardUserDefaults]setObject:_shequ forKey:@"commname"];
            
            [[NSUserDefaults standardUserDefaults]setObject:_shengid forKey:@"GuideShengId"];
            [[NSUserDefaults standardUserDefaults]setObject:_sheng forKey:@"GuideShengName"];

            
            [[NSUserDefaults standardUserDefaults]setObject:_quid forKey:@"GuidequId"];
            [[NSUserDefaults standardUserDefaults]setObject:_qu forKey:@"GuidequName"];

            [[NSUserDefaults standardUserDefaults]setObject:_shiid forKey:@"GuideShiId"];
            [[NSUserDefaults standardUserDefaults]setObject:_shi forKey:@"GuideShiName"];

            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changeComm"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changeCommShang"];

            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
           
            NSString *tag =[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"commid"]];
            
            NSSet * tagJihe = [NSSet setWithObjects:tag, nil];
            
            NSLog(@"%@",tagJihe);
            
            
            [JPUSHService setTags:tagJihe callbackSelector:@selector((tagsAliasCallback:tags:alias:)) object:self];
            
            if (_xuanshequ==YES) {
                _xuanshequ=NO;
                
                self.tabBarController.selectedIndex=3;
                return;
            }
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    
    

    

    
    
}

-(void)biansheng:(NSNotification *)not{
    NSString *sheng = not.object[@"name"];
    CellView *btn = (CellView *)[self.view viewWithTag:10];
    btn.contentLabel.text=sheng;
    _sheng=sheng;
    _shengid=not.object[@"id"];
    [_xuanData setObject:not.object[@"id"] forKey:@"sheng"];
    
    CellView *shi = (CellView *)[self.view viewWithTag:11];
    CellView *qu = (CellView *)[self.view viewWithTag:12];
    CellView *shequ = (CellView *)[self.view viewWithTag:13];
    
    shi.contentLabel.text=@"";
    qu.contentLabel.text=@"";
    shequ.contentLabel.text=@"";
    
    _shi=@"";
    _qu=@"";
    _shequ=@"";
    
}

-(void)bianshi:(NSNotification *)not{
    NSString *sheng = not.object[@"name"];
    CellView *btn = (CellView *)[self.view viewWithTag:11];
    btn.contentLabel.text=sheng;
    _shi=sheng;
    _shiid=not.object[@"id"];
    [_xuanData setObject:not.object[@"id"] forKey:@"shi"];
    
    
    CellView *qu = (CellView *)[self.view viewWithTag:12];
    CellView *shequ = (CellView *)[self.view viewWithTag:13];

    qu.contentLabel.text=@"";
    shequ.contentLabel.text=@"";

    _qu=@"";
    _shequ=@"";

}

-(void)bianqu:(NSNotification *)not{
    NSString *sheng = not.object[@"name"];
    CellView *btn = (CellView *)[self.view viewWithTag:12];
    btn.contentLabel.text=sheng;
    _qu=sheng;
    _quid=not.object[@"id"];
    [_xuanData setObject:not.object[@"id"] forKey:@"qu"];
    
    CellView *shequ = (CellView *)[self.view viewWithTag:13];
    
    shequ.contentLabel.text=@"";

    _shequ=@"";

}


-(void)biancommqu:(NSNotification *)not{
    NSString *sheng = not.object[@"name"];
    CellView *btn = (CellView *)[self.view viewWithTag:13];
    btn.contentLabel.text=sheng;
    _shequ=sheng;
    _shequid=not.object[@"id"];
    [_xuanData setObject:not.object[@"id"] forKey:@"shequ"];

}




-(void)xun:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
    

    
    switch (sender.tag) {
        case 1:{
            ShengViewController *sheng = [ShengViewController new];
            [self.navigationController pushViewController:sheng animated:YES];
          

            
        }
            break;
            
        case 2: {
            if (_sheng==nil || [_sheng isEqualToString:@""]) {
                [self ShowAlertWithMessage:@"请先选择省"];
                return;
            }else{
                
                    
                 //_shengid = [_dc objectForKey:@"province_id"];
                    
                ShiViewController *sheng = [ShiViewController new];
                sheng.ID = _shengid;
                [self.navigationController pushViewController:sheng animated:YES];
            }
     
            
        }
            
            break;
            
        case 3:
        {
            

            if (_shi==nil || [_shi isEqualToString:@""]) {
                [self ShowAlertWithMessage:@"请先选择市"];
                return;
            }else{
                
                
                //_shiid = [_dc objectForKey:@"city_id"];
                
                QuuViewController *sheng = [QuuViewController new];
                sheng.ID = _shiid;
                [self.navigationController pushViewController:sheng animated:YES];
            }

        }
            break;
            
        case 4:
        {
            
            if (_qu==nil || [_qu isEqualToString:@""]) {
                [self ShowAlertWithMessage:@"请先选择区"];
                return;
            }else{
    
                CommQuViewController *sheng = [CommQuViewController new];
                sheng.ID = _quid;
                [self.navigationController pushViewController:sheng animated:YES];
            }


        }
            break;
            
            
        default:
            break;
    }



}


#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"选择服务社区";
    
    if (_nojiantou) {
        UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
        [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
        [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
        [self.NavImg addSubview:popBtn];
    }
    
    
    
  }

-(void)PopVC:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
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
