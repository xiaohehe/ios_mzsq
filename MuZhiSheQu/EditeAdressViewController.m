//
//  EditeAdressViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "EditeAdressViewController.h"
#import "CellView.h"
#import "GetBaiDuMapViewController.h"
#import "UmengCollection.h"
@interface EditeAdressViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UILabel *nameLa;
@property(nonatomic,strong)UIControl *big;
@property(nonatomic,strong)UIImageView *SelectImg;
@property(nonatomic,strong)UIPickerView *TimePickerView;
@property(nonatomic,strong)NSString *shequid;
@property(nonatomic,strong)NSString *jing,*wei;

@end

@implementation EditeAdressViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UmengCollection intoPage:NSStringFromClass([self class])];
     self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _shequid=_xiaoquid;
    self.commData= [NSMutableArray new];
    [self newNav];
    
    [self topView];
    
    
}
-(void)lianxiCha{
    _nameTF.text=@"";
}

-(void)topView{
    
    CellView *infoCell = [[CellView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale, self.view.width, 200)];
    
    [self.view addSubview:infoCell];
    
    UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 60*self.scale, 20*self.scale)];
    nameLa.text = @"联系人";
    nameLa.font=DefaultFont(self.scale);
    [infoCell addSubview:nameLa];
    
    _nameTF = [[UITextField alloc]initWithFrame:CGRectMake(nameLa.right, nameLa.top, self.view.width-nameLa.right-30*self.scale, nameLa.height)];
    _nameTF.text=self.shouRen;
    _nameTF.clearButtonMode=UITextFieldViewModeAlways;
    [infoCell addSubview:_nameTF];
    
//    UIButton *cha = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cha setImage:[UIImage imageNamed:@"fu_no"] forState:UIControlStateNormal];
//    cha.frame=CGRectMake(self.view.width-30*self.scale, nameLa.top, 20*self.scale, 20*self.scale);
//    [cha addTarget:self action:@selector(lianxiCha) forControlEvents:UIControlEventTouchUpInside];
    
//    [infoCell addSubview:cha];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(_nameTF.left, _nameTF.bottom+5*self.scale, self.view.width-_nameTF.left-10*self.scale, .5)];
    line.backgroundColor=blackLineColore;
    [infoCell addSubview:line];
    float setX = _nameTF.left;
    float setY=0;
    NSArray *arr = @[@"先生",@"女士"];
    for (int i =0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"choose_01"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"choose_02"] forState:UIControlStateSelected];
        btn.frame=CGRectMake(setX, line.bottom+10*self.scale, 20*self.scale, 20*self.scale);
        [infoCell addSubview:btn];
        btn.selected=NO;
        btn.tag=i+1;
        [btn addTarget:self action:@selector(selectEvent:) forControlEvents:UIControlEventTouchUpInside];
        setX = line.right-100*self.scale;
        
        
        if ([self.shousex isEqualToString:@"1"]) {
            if (btn.tag==1) {
                btn.selected=YES;
                _sex=@"1";
            }
        }
        
        
        
        UILabel *sex = [[UILabel alloc]initWithFrame:CGRectMake(btn.right, btn.top, 30*self.scale, 20*self.scale)];
        sex.text=arr[i];
        sex.font=DefaultFont(self.scale);
        [infoCell addSubview:sex];
        
        setY = sex.bottom+10*self.scale;
    }
    UIView *botline = [[UIView alloc]initWithFrame:CGRectMake(line.left, setY, line.width, .5)];
    botline.backgroundColor=blackLineColore;
    [infoCell addSubview:botline];
    
    UILabel *xiaoqu = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, botline.bottom+10*self.scale, 70*self.scale, 20*self.scale)];
    xiaoqu.text = @"详细地址";
    xiaoqu.font=DefaultFont(self.scale);
    [infoCell addSubview:xiaoqu];
    [xiaoqu sizeToFit];
    
    _xiaoqux = [[UITextField alloc]initWithFrame:CGRectMake(xiaoqu.right+10*self.scale, xiaoqu.top, self.view.width-xiaoqu.right-50*self.scale, 20*self.scale)];
    _xiaoqux.font=DefaultFont(self.scale);
    _xiaoqux.placeholder=@"请输入详细地址";
    _xiaoqux.text=self.shouaddres;
    [infoCell addSubview:_xiaoqux];
    
    
    UIButton *biao = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-30*self.scale, xiaoqu.top, 20*self.scale, 20*self.scale)];
    [biao setImage:[UIImage imageNamed:@"xq_dibiao"] forState:UIControlStateNormal];
    [biao addTarget:self action:@selector(seleArdess) forControlEvents:UIControlEventTouchUpInside];
    [infoCell addSubview:biao];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, xiaoqu.bottom+10*self.scale, self.view.width, .5)];
    line1.backgroundColor=blackLineColore;
    [infoCell addSubview:line1];
    
    
    UILabel *dizhi = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, line1.bottom+10*self.scale, 70*self.scale, 20*self.scale)];
    dizhi.text = @"门牌号";
    dizhi.font=DefaultFont(self.scale);
    [infoCell addSubview:dizhi];
    
    
    _dizhix = [[UITextField alloc]initWithFrame:CGRectMake(dizhi.right, dizhi.top, self.view.width-dizhi.right-30*self.scale, 20*self.scale)];
    _dizhix.font=DefaultFont(self.scale);
    _dizhix.placeholder=@"请输入门牌号（可选）";
    _dizhix.text=self.menpaihao;
    _dizhix.clearButtonMode=UITextFieldViewModeAlways;
    [infoCell addSubview:_dizhix];
    
    
//    UIImageView *cha1 = [[UIImageView alloc]initWithFrame:CGRectMake(cha.left, dizhi.top, 20*self.scale, 20*self.scale)];
//    cha1.image = [UIImage imageNamed:@"fu_no"];
//    cha1.userInteractionEnabled=YES;
//    [infoCell addSubview:cha1];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dizhicha)];
//    [cha1 addGestureRecognizer:tap];
//    
    
    
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, _dizhix.bottom+10*self.scale, self.view.width, .5)];
    line2.backgroundColor=blackLineColore;
    [infoCell addSubview:line2];
    
    
    
    
    
    
    
    UILabel *shouji = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, line2.bottom+10*self.scale, 70*self.scale, 20*self.scale)];
    shouji.text = @"手机";
    shouji.font=DefaultFont(self.scale);
    [infoCell addSubview:shouji];
    
    _shoujix = [[UITextField alloc]initWithFrame:CGRectMake(shouji.right, shouji.top, self.view.width-80*self.scale, 20*self.scale)];
    _shoujix.font=DefaultFont(self.scale);
    _shoujix.placeholder=@"请输入手机号码";
    _shoujix.text=self.shouTel;
    _shoujix.clearButtonMode=UITextFieldViewModeAlways;
    [infoCell addSubview:_shoujix];
    
//    UIImageView *cha2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-40*self.scale, shouji.top, 20*self.scale, 20*self.scale)];
//    cha1.image = [UIImage imageNamed:@"fu_no"];
//    [infoCell addSubview:cha1];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, _shoujix.bottom+10*self.scale, self.view.width, .5)];
    line3.backgroundColor=blackLineColore;
    [infoCell addSubview:line3];
    
    infoCell.height=line3.bottom;
    
    
    CellView *shanchu = [[CellView alloc]initWithFrame:CGRectMake(0, infoCell.bottom+10*self.scale, self.view.width, 44*self.scale)];
    [self.view addSubview:shanchu];
    
    UIButton *shan = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, shanchu.width, shanchu.height)];
    [shan setTitle:@"删除该地址" forState:UIControlStateNormal];
    [shan setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    shan.titleLabel.font=DefaultFont(self.scale);
    [shan addTarget:self action:@selector(shanc) forControlEvents:UIControlEventTouchUpInside];
    [shanchu addSubview:shan];
    
}


-(void)dizhicha{
    _dizhix.text=@"";
}
-(void)seleArdess{

//    [self.view addSubview:self.activityVC];
//    [self.activityVC startAnimate];
//    
//    AnalyzeObject *anle = [AnalyzeObject new];
//    [anle getCommunityListWithDicWithDic:nil Block:^(id models, NSString *code, NSString *msg) {
//        if ([code isEqualToString:@"0"]) {
//            [_commData addObjectsFromArray:models];
//            [self sa];
//        }else{
//            [self ShowAlertWithMessage:@"获取失败"];
//        }
//        
//        [self.activityVC stopAnimate];
//    }];

    [self.view endEditing:YES];
    
    GetBaiDuMapViewController *baidu = [GetBaiDuMapViewController new];
    [self.navigationController pushViewController:baidu animated:YES];
    [baidu getZuoBiaoBlock:^(NSDictionary *dic) {
        NSString *loca=@"";
        NSArray *ar = [dic[@"address"] componentsSeparatedByString:@"省"];
        
        if (ar.count<=0) {
            ar = [ar[1] componentsSeparatedByString:@"区"];
            loca = [ar[1] stringByAppendingString:@"区"];
        }else{
            if (ar.count<2) {
                loca=ar[0];
            }else{
                loca=ar[1];
            }
        }
        
        _jing = [NSString stringWithFormat:@"%@",dic[@"longitude"]];
        _wei= [NSString stringWithFormat:@"%@",dic[@"latitude"]];
        
        _xiaoqux.text=loca;
        
        
        
        
    }];
}
- (void)locationPicker:(RCLocationPickerViewController *)locationPicker
     didSelectLocation:(CLLocationCoordinate2D)location
          locationName:(NSString *)locationName
         mapScreenShot:(UIImage *)mapScreenShot{
//    NSString *loca=@"";
//    NSArray *ar = [locationName componentsSeparatedByString:@"省"];
//    
//    if (ar.count<=0) {
//        ar = [ar[1] componentsSeparatedByString:@"区"];
//        loca = [ar[1] stringByAppendingString:@"区"];
//    }else{
//        if (ar.count<2) {
//            loca=ar[0];
//        }else{
//        loca=ar[1];
//        }
//    }
//    _jing = [NSString stringWithFormat:@"%f",location.longitude];
//    _wei= [NSString stringWithFormat:@"%f",location.latitude];
//
//    _xiaoqux.text=loca;
    
}


-(void)sa{
    
    
    

    _big = [[UIControl alloc]initWithFrame:self.view.bounds];
    _big.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [self.view addSubview:_big];
    
    _SelectImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height+180*self.scale)];
    _SelectImg.userInteractionEnabled=YES;
    _SelectImg.backgroundColor= [UIColor whiteColor];
    [self.view addSubview:_SelectImg];
    
    [UIView animateWithDuration:.3 animations:^{
        _big.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.6];        _SelectImg.frame=CGRectMake(0, self.view.height-180*self.scale, self.view.width, 180*self.scale);
        
        
        
    }];
    
    
    
    
    
    _TimePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,_SelectImg.height/2-40*self.scale, self.view.width, 120*self.scale)];
    _TimePickerView.delegate = self;
    _TimePickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _TimePickerView.dataSource = self;
    [_SelectImg addSubview:_TimePickerView];
    
    UIButton *canBtn=[[UIButton alloc]initWithFrame:CGRectMake(30*self.scale, _TimePickerView.top-40*self.scale, 60*self.scale, 30*self.scale)];
    [canBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [canBtn addTarget:self action:@selector(actionDone:) forControlEvents:UIControlEventTouchUpInside];
    canBtn.tag=1;
    [canBtn setTitle:@"取消" forState:UIControlStateNormal];
    canBtn.titleLabel.textColor=[UIColor whiteColor];
    canBtn.titleLabel.font=Big16Font(self.scale);
    [_SelectImg addSubview:canBtn];
    
    UIButton *OKBtn=[[UIButton alloc]initWithFrame:CGRectMake(_SelectImg.width-90*self.scale, _TimePickerView.top-40*self.scale, 60*self.scale, 30*self.scale)];
    [OKBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [OKBtn addTarget:self action:@selector(actionDone:) forControlEvents:UIControlEventTouchUpInside];
    OKBtn.titleLabel.font=Big16Font(self.scale);
    
    [OKBtn setTitle:@"确定" forState:UIControlStateNormal];
    OKBtn.titleLabel.textColor=[UIColor whiteColor];
    OKBtn.tag=2;
    [_SelectImg addSubview:OKBtn];
    
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, .5)];
    topline.backgroundColor=blackLineColore;
    [_SelectImg addSubview:topline];



}

-(void)actionDone:(UIButton *)button{
    [self.view endEditing:YES];

    if (button.tag == 1) {
        [UIView animateWithDuration:.5 animations:^{
            _SelectImg.frame=CGRectMake(0, self.view.height, self.view.width, self.view.height+180*self.scale);
            _big.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        }completion:^(BOOL finished) {
            [_big removeFromSuperview];
            
            
        }];
        return;
    }
    
    
    NSString *str =@"";
    str =[NSString stringWithFormat:@"%@",[_commData objectAtIndex:[_TimePickerView selectedRowInComponent:1]][@"name"]];
    
    _xiaoqux.text=str;
    
    for (NSDictionary *dic in _commData) {
        if ([dic[@"name"] isEqualToString:str]) {
            _shequid = dic[@"id"];
        }
    }

   
    
    
    [UIView animateWithDuration:.5 animations:^{
        _SelectImg.frame=CGRectMake(0, self.view.height, self.view.width, self.view.height+180*self.scale);
        _big.alpha=0;
    }completion:^(BOOL finished) {
        
        [_big removeFromSuperview];
        
    }];
    
}


-(void)selectEvent:(UIButton *)sender{
    sender.selected=!sender.selected;
    UIButton *btn = (UIButton *)[self.view viewWithTag:1];
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:2];
    
    if (sender.tag==1) {
        btn1.selected=NO;
        _sex=@"1";
    }else{
        btn.selected=NO;
        _sex=@"2";
    }
    
}

    

    


-(void)shanc{

    if (_data.count==1) {
        
            [self ShowAlertTitle:@"提示" Message:@"只剩一个收货地址了，你确定删除吗？" Delegate:self Block:^(NSInteger index) {
                if (index==1) {
                    [self shandizhi];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"address"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"shopAddress" object:nil];
                }
                
            }];
        
    }else{
    
        [self shandizhi];
        
    }

}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        //            if (row == 0)
        //            {
        //                _DataArr=_TodayArr;
        //            }else
        //            {
        //                _DataArr=_TimeArr;
        //            }
        [_TimePickerView reloadAllComponents];
    }
    else if (component == 1)
    {
        [_TimePickerView reloadAllComponents];
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 1;
    }
    return 10;
}


- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 100, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    if (component == 0)
    {
        pickerLabel.text =  @"选择社区"; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [_commData objectAtIndex:row][@"name"];  // Month
    }
    return pickerLabel;
}
//删除地址
-(void)shandizhi{
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"user_id":self.user_id,@"address_id":self.adressid};
    [anle delAddressWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            [self ShowAlertWithMessage:msg];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];


}
-(void)dizhi:(UIButton *)sender{





}
//
//-(void)selectEvent:(UIButton *)sender{
//    sender.selected=!sender.selected;
//    UIButton *btn = (UIButton *)[self.view viewWithTag:1];
//    UIButton *btn1 = (UIButton *)[self.view viewWithTag:2];
//    
//    if (sender.tag==1) {
//        btn1.selected=NO;
//    }else{
//        btn.selected=NO;
//    }
//
//}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"编辑地址";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton *CarBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [CarBtn setTitle:@"保存" forState:UIControlStateNormal];
    [CarBtn setTitleColor:grayTextColor forState:UIControlStateNormal];
    CarBtn.titleLabel.font=Big15Font(1);
    [CarBtn addTarget:self action:@selector(SaveBtnVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:CarBtn];
}
-(void)SaveBtnVC:(id)sender{
    if ([_nameTF.text isEqualToString:@"" ] || [_xiaoqux.text isEqualToString:@"" ] ||  [_shoujix.text isEqualToString:@""]) {
        [self ShowAlertWithMessage:@"请完善信息后保存"];
        return;
    }
    
    if (![_shoujix.text isValidateMobile]) {
        [self ShowAlertWithMessage:@"请输入正确的手机号"];
        return;
    }
    
    if (_nameTF.text.length>30 || _nameTF.text.length<=0) {
        [self ShowAlertWithMessage:@"联系人姓名应在0-30个字符"];
        return;
    }
    
    
    
    AnalyzeObject *anle = [AnalyzeObject new];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
  //  NSString *adress = [_xiaoqux.text stringByAppendingString:_dizhix.text];
    
    NSDictionary *dic = @{@"user_id":userid,@"real_name":_nameTF.text,@"sex":_sex,@"house_number":_dizhix.text,@"address":_xiaoqux.text,@"mobile":_shoujix.text,@"address_id":self.adressid,@"lng":[NSString stringWithFormat:@"%@",_jing],@"lat":[NSString stringWithFormat:@"%@",_wei]};
    [anle addAddressWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
           // [self ShowAlertWithMessage:msg]
            if (_orfanData) {
              [[NSNotificationCenter defaultCenter]postNotificationName:@"shopAddress" object:models];
            }
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
    
}

-(void)PopVC:(id)sender{
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
