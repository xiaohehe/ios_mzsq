//
//  ActivityDetailsViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ActivityDetailsViewController.h"
#import "HistoryLogViewController.h"
#import "AppUtil.h"
#import "ShouHuoDiZhiListViewController.h"

@interface ActivityDetailsViewController ()<UIAlertViewDelegate>{
    UIScrollView* sv;
    UIImageView* thumbIv;
    UILabel* markTitleLb;
    UILabel* markLb;
    UILabel* proContentTitleLb;
    UILabel* proContentLb;
    UIButton* comfirmBtn;
    CGFloat bottom;
    NSMutableDictionary *addressDic;

}
@end

@implementation ActivityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNav];
    sv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    sv.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:sv];
    [self.view addSubview:self.activityVC];
    addressDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(topvi:) name:@"shopAddress" object:nil];
    if(_isConvert){
        [self familyExchange];
    }else{
        [self getFamilyProduct];
    }
}

-(void)topvi:(NSNotification *)not{
    addressDic = not.object;
}

-(void)newView{
    thumbIv=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width/2-50*self.scale,20*self.scale, 100*self.scale, 100*self.scale)];
    thumbIv.contentMode=UIViewContentModeScaleAspectFit;
     [thumbIv setImageWithURL:[NSURL URLWithString:_dic[@"ThumbImage"]] placeholderImage:[UIImage imageNamed:@"not_1"]];
    [sv addSubview:thumbIv];
    bottom=thumbIv.bottom+20*self.scale;
    if(![AppUtil isBlank:_dic[@"ProContentTitle"]]){
        proContentTitleLb= [[UILabel alloc] initWithFrame:CGRectMake(10*self.scale, bottom, self.view.width-20*self.scale, 15*self.scale)];
        proContentTitleLb.text=_dic[@"ProContentTitle"];
        proContentTitleLb.font=DefaultFont(self.scale);
        proContentTitleLb.textColor=[UIColor colorWithRed:0.839 green:0.604 blue:0.000 alpha:1.00];
        [sv addSubview:proContentTitleLb];
        
        bottom=proContentTitleLb.bottom+10*self.scale;
        
        proContentLb=[[UILabel alloc]init];
        proContentLb.font=SmallFont(self.scale);
        proContentLb.text=_dic[@"ProContent"];
        proContentLb.numberOfLines = 0;
        proContentLb.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [proContentLb sizeThatFits:CGSizeMake(self.view.width-20*self.scale, MAXFLOAT)];
        NSInteger count = (size.height) / proContentLb.font.lineHeight;
        proContentLb.frame = CGRectMake(10*self.scale, bottom, self.view.width-20*self.scale, size.height+count*6);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_dic[@"ProContent"]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_dic[@"ProContent"] length])];
        proContentLb.attributedText = attributedString;
        [sv addSubview:proContentLb];

        bottom=proContentLb.bottom+10*self.scale;
    }
    markTitleLb= [[UILabel alloc] initWithFrame:CGRectMake(10*self.scale, bottom, self.view.width-20*self.scale, 15*self.scale)];
    markTitleLb.text=_dic[@"MarkTitle"];
    markTitleLb.font=DefaultFont(self.scale);
    markTitleLb.textColor=[UIColor colorWithRed:0.839 green:0.604 blue:0.000 alpha:1.00];
    [sv addSubview:markTitleLb];
    
    bottom=markTitleLb.bottom+10*self.scale;

    markLb=[[UILabel alloc]init];
    markLb.font=SmallFont(self.scale);
    markLb.text=_dic[@"Mark"];
    markLb.numberOfLines = 0;
    markLb.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [markLb sizeThatFits:CGSizeMake(self.view.width-20*self.scale, MAXFLOAT)];
    NSInteger count = (size.height) / markLb.font.lineHeight;
    markLb.frame = CGRectMake(10*self.scale, bottom, self.view.width-20*self.scale, size.height+count*6);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_dic[@"Mark"]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_dic[@"Mark"] length])];
    markLb.attributedText = attributedString;
    [sv addSubview:markLb];
    
    bottom=markLb.bottom+20*self.scale;
    
    comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [comfirmBtn setBackgroundImage:[UIImage imageNamed:@"bg_order_big"] forState:UIControlStateNormal];
    comfirmBtn.frame=CGRectMake(self.view.width/2-75*self.scale, bottom, 150*self.scale,40*self.scale);
    [comfirmBtn setTitle:_dic[@"BtnText"] forState:UIControlStateNormal];
    [comfirmBtn setTitleColor:[UIColor colorWithRed:0.216 green:0.216 blue:0.196 alpha:1.00] forState:UIControlStateNormal];
    [comfirmBtn addTarget:self action:@selector(comfirm) forControlEvents:UIControlEventTouchUpInside];
    [sv addSubview:comfirmBtn];
    bottom=comfirmBtn.bottom+20*self.scale+self.dangerAreaHeight;
    if(bottom<=sv.height){
        sv.contentSize = CGSizeMake(self.view.width,sv.height);
    }else{
        sv.contentSize = CGSizeMake(self.view.width,bottom);
    }
}

-(void)comfirm{
    [self familyOrder];
}

#pragma mark - 导航
-(void)newNav{
    //if(!_isConvert)
    self.TitleLabel.text=_moduleName;
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    //    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton* historyBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-70*self.scale, self.TitleLabel.top, 60*self.scale, self.TitleLabel.height)];
    [historyBtn setTitle:@"历史记录" forState:UIControlStateNormal];
    [historyBtn setTitleColor:grayTextColor forState:(UIControlStateNormal)];
    //    [CarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    historyBtn.titleLabel.font=Big15Font(1);
    [historyBtn addTarget:self action:@selector(skipHistoryView) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:historyBtn];
    UIView *botline = [[UIView alloc]initWithFrame:CGRectMake(0, [self getStartHeight]+44-.5, self.view.width, .5)];
    botline.backgroundColor=blackLineColore;
    [self.NavImg addSubview:botline];
}

-(void)familyOrder{
    if (addressDic.count<=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请先选择地址"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
        return;
    }
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
     NSString *shopid =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"shopid"]];
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setObject:self.mid forKey:@"mid"];
    [dic setObject:shopid forKey:@"shopid"];
    [dic setObject:[NSString stringWithFormat:@"%@",_dic[@"ProID"]] forKey:@"proid"];
    [dic setObject:addressDic[@"id"] forKey:@"addressid"];

    [anle familyOrderWithDic:[dic copy] Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            NSLog(@"familyOrderWithDic==%@",models);
            [self ShowAlertWithMessage:msg];
        }else{
            [self ShowAlertWithMessage:msg];
        }
    }];
}

-(void)getFamilyProduct{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"mid":self.mid};
    [anle getFamilyProductWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            _dic=models;
            NSLog(@"getFamilyProductWithDic==%@",models);
            [self newView];
        }else{
            [self ShowAlertWithMessage:msg];
        }
    }];
}

//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        ShouHuoDiZhiListViewController *shouhuo = [ShouHuoDiZhiListViewController new];
        shouhuo.orReturn=YES;
        shouhuo.hidesBottomBarWhenPushed=YES;
        shouhuo.adressid = addressDic[@"id"];
        [self.navigationController pushViewController:shouhuo animated:YES];
    }
}


-(void)familyExchange{
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle familyExchangeWithDic:nil Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
            _dic=models;
            self.mid=[NSString stringWithFormat:@"%@",_dic[@"ModuleID"]];
            NSLog(@"familyExchangeWithDic==%@",models);
            [self newView];
        }else{
            [self ShowAlertWithMessage:msg];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)skipHistoryView{
    HistoryLogViewController* historyLogViewController=[[HistoryLogViewController alloc] init];
    historyLogViewController.mid=self.mid;
    historyLogViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:historyLogViewController animated:YES];
}
@end

