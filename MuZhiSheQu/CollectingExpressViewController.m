//
//  CollectingExpressViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2018/1/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CollectingExpressViewController.h"
#import "SMAlert.h"
#import "AppUtil.h"
#import "ShoppingOffViewController.h"

@interface CollectingExpressViewController ()
@property(nonatomic,strong)UIImageView *logoIv;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *desLb;
@property(nonatomic,strong)UILabel *markLb;
@property(nonatomic,strong)UIButton *addBtn;
@property(nonatomic,copy) NSString* pNsStr;
@end

@implementation CollectingExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self newNav];
    [self setNewView];
    [self.view addSubview:self.activityVC];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)newNav{
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    self.TitleLabel.text=@"代取快递";
    self.TitleLabel.font =[UIFont systemFontOfSize:15*self.scale];
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.height-.5, self.view.width, .5)];
    bottomLine.backgroundColor=[UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.00];
    [self.NavImg addSubview:bottomLine];
}

-(void) setNewView{
    _logoIv=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width/2-30*self.scale, self.NavImg.bottom+30*self.scale, 60*self.scale, 60*self.scale)];
    [_logoIv setImage:[UIImage imageNamed:@"express_logo"]];
    [self.view addSubview:_logoIv];
    _titleLb=[[UILabel alloc]initWithFrame:CGRectMake(0, _logoIv.bottom+10*self.scale, self.view.width, 20*self.scale)];
    _titleLb.textColor=[UIColor colorWithRed:0.000 green:0.533 blue:0.961 alpha:1.00];
    _titleLb.text=@"代取快递";
    _titleLb.font=[UIFont boldSystemFontOfSize:15];
    _titleLb.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_titleLb];
    _desLb=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, _titleLb.bottom+10*self.scale, self.view.width-20*self.scale, 0)];
    _desLb.numberOfLines = 0;
    _desLb.text = @"拇指便利提供代取快递服务，复制您的快递收取短信，然后点击导入快递。导入成功后，我们会在您下次购物时，帮您把导入的快递送到您手中。";
    _desLb.textColor=[UIColor colorWithRed:0.247 green:0.247 blue:0.247 alpha:1.00];
    _desLb.font=[UIFont systemFontOfSize:15];
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_desLb.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_desLb.text length])];
    _desLb.attributedText = attributedString;
    [_desLb sizeToFit];
    [self.view addSubview:_desLb];
    _markLb=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, _desLb.bottom+10*self.scale, self.view.width-20*self.scale, 0)];
    _markLb.numberOfLines = 0;
    _markLb.text = [NSString stringWithFormat:@"代取范围：\n%@",_mark];
    _markLb.textColor=[UIColor colorWithRed:0.988 green:0.357 blue:0.000 alpha:1.00];
    _markLb.font=[UIFont systemFontOfSize:15];
    // 调整行间距
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:_markLb.text];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:6];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [_markLb.text length])];
    _markLb.attributedText = attributedString1;
    [_markLb sizeToFit];
    [self.view addSubview:_markLb];
    
    _addBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, _markLb.bottom+35*self.scale, self.view.width-20*self.scale, 35*self.scale)];
    [_addBtn setTitle:@"导入快递" forState:UIControlStateNormal];
    _addBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addBtn.backgroundColor=[UIColor colorWithRed:0.000 green:0.533 blue:0.961 alpha:1.00];
    _addBtn.layer.cornerRadius = 5;
    _addBtn.layer.masksToBounds = YES;
    [_addBtn addTarget:self action:@selector(addExpress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addBtn];
}

-(void)test{
    [SMAlert hide];
    ShoppingOffViewController *vc = [[ShoppingOffViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addExpress{
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIPasteboard* pBoard=[UIPasteboard generalPasteboard];
    if(pBoard!=NULL){
        _pNsStr=pBoard.string;
        if([AppUtil isBlank:_pNsStr]){
            [self ShowAlertWithMessage:@"请先复制快递短信"];
            return;
        }
        //NSLog(@"pBoard==%@",pNsStr);
    }else{
        [self ShowAlertWithMessage:@"请先复制快递短信"];
        return;
    }
    UIFont* font=[UIFont systemFontOfSize:15];
    CGSize labelSize=[_pNsStr boundingRectWithSize:CGSizeMake(self.view.width-60*self.scale, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width-20*self.scale, labelSize.height+85*self.scale)];
    
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(10*self.scale, 0, self.view.width-20*self.scale, labelSize.height+40*self.scale)];
    titleView.backgroundColor=[UIColor whiteColor];
    [customView addSubview:titleView];

    UILabel* nameLb=[[UILabel alloc] initWithFrame:CGRectMake(20*self.scale, 20*self.scale, titleView.width-40*self.scale, labelSize.height)];
    nameLb.numberOfLines=0;
    nameLb.text=_pNsStr;
    nameLb.textColor=[UIColor colorWithRed:0.247 green:0.247 blue:0.247 alpha:1.00];
    nameLb.font=font;
    [titleView addSubview:nameLb];
    
    UIButton* importBtn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, titleView.bottom+10*self.scale, self.view.width-20*self.scale, 35*self.scale)];
    [importBtn setTitle:@"导入" forState:UIControlStateNormal];
    importBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [importBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    importBtn.backgroundColor=[UIColor colorWithRed:0.000 green:0.533 blue:0.961 alpha:1.00];
    importBtn.layer.cornerRadius = 5;
    importBtn.layer.masksToBounds = YES;
    [importBtn addTarget:self action:@selector(importExpress) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:importBtn];
    [SMAlert showCustomView:customView];
}

-(void)importExpress{
    [SMAlert hide];
    NSString *shopid =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"]];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"shopid":shopid,@"content":_pNsStr};
    [self.activityVC startAnimate];
    [anle importExpressWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        //NSLog(@"importExpress==%@==%@==%@",code,dic,models);
        if ([code isEqualToString:@"0"]) {
            ShoppingOffViewController *vc = [[ShoppingOffViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if([AppUtil isBlank:msg])
                [AppUtil showToast:self.view withContent:@"导入失败"];
            else{
                [AppUtil showToast:self.view withContent:msg];
            }
        }
    }];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
