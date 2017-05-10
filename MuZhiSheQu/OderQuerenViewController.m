//
//  OderQuerenViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/10/28.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "OderQuerenViewController.h"
#import "CellView.h"
#import "UmengCollection.h"
@interface OderQuerenViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong)UIControl *topCon;
@property(nonatomic,strong)UIImageView *stripVi,*topArrow;
@property(nonatomic,strong)UILabel *shouHuoer,*shouName,*shouTal,*shouAddressLa,*addressLa;
@property(nonatomic,strong)UIScrollView *bigScrollVi;
@property(nonatomic,assign)float setY;
@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,strong)NSMutableDictionary *ar;
@end

@implementation OderQuerenViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [UmengCollection intoPage:NSStringFromClass([self class])];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arr = @[@"下单时间:",@"服务内容:",@"预约时间:"];
    _ar = [[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
    
    [self topVi];
    [self returnVi];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(topvi:) name:@"shopAddress" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jianpan:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
}


-(void)jianpan:(NSNotification *)notification{
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        //_mainScrollView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width,  rect.origin.y-self.NavImg.bottom);
        //        float =
        //        self.view.bottom=
        //
        //_vi.bottom=rect.origin.y;
        
        self.view.bottom=rect.origin.y;
    }];



}

-(void)topvi:(NSNotification *)not{
    _ar = not.object;
    [self topVi];

}

-(void)jianpanxia{
    [self.view endEditing:YES];

}

-(void)topVi{

    
    
    if (_bigScrollVi) {
        [_bigScrollVi removeFromSuperview];
    }
    _bigScrollVi =[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    [self.view addSubview:_bigScrollVi];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jianpanxia)];
    [_bigScrollVi addGestureRecognizer:tap];
    
    
    
    
    _topCon = [[UIControl alloc]initWithFrame:CGRectMake(0, 7.5*self.scale, self.view.bounds.size.width, 145/2.25*self.scale)];
    _topCon.backgroundColor = [UIColor whiteColor];
    [_bigScrollVi addSubview:_topCon];
    
    
    _stripVi = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5*self.scale)];
    _stripVi.image = [UIImage imageNamed:@"dian_xq_line"];
    [_topCon addSubview:_stripVi];
    
    
    _shouHuoer = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 15*self.scale, 60*self.scale, 15*self.scale)];
    _shouHuoer.text = @"收货人 :";
    _shouHuoer.font = DefaultFont(self.scale);
    [_shouHuoer sizeToFit];
    [_topCon addSubview:_shouHuoer];
    float r = _shouHuoer.right;
    float t = _shouHuoer.top;
    
    
    _shouName = [[UILabel alloc]initWithFrame:CGRectMake(r, t, 50, 15)];
    _shouName.text = _ar[@"real_name"] ;
    _shouName.font = DefaultFont(self.scale);
    [_topCon addSubview:_shouName];
    [_shouName sizeToFit];
    r = _shouName.right;
    
    _shouTal = [[UILabel alloc]initWithFrame:CGRectMake(r+10, t, 130*self.scale, 15)];
    _shouTal.text = _ar[@"mobile"];
    _shouTal.font = DefaultFont(self.scale);
    [_topCon addSubview:_shouTal];
    float b = _shouTal.bottom;
    
    
    
    _shouAddressLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, b+15, 70*self.scale, 35*self.scale)];
    [_shouAddressLa sizeToFit];
    _shouAddressLa.text = @"收货地址 :";
    _shouAddressLa.font =DefaultFont(self.scale);
    [_topCon addSubview:_shouAddressLa];
    r = _shouAddressLa.right;
    
    _addressLa = [[UILabel alloc]initWithFrame:CGRectMake(r, _shouAddressLa.top, self.view.width-_shouAddressLa.right-50*self.scale, 35*self.scale)];
    _addressLa.numberOfLines=0;
    _addressLa.font = DefaultFont(self.scale);
    
    NSString *add = [_ar objectForKey:@"address"];
    if (![[_ar objectForKey:@"house_number"] isEqualToString:@""]) {
        add = [add stringByAppendingString:[_ar objectForKey:@"house_number"]];

    }
    _addressLa.text = add;
    [_topCon addSubview:_addressLa];
    
    
    _topArrow = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-30*self.scale, _shouHuoer.top+5*self.scale, 22.5*self.scale, 22.5*self.scale)];
    _topArrow.image = [UIImage imageNamed:@"dd_right"];
    [_topCon addSubview:_topArrow];
    _topCon.height=_addressLa.bottom+10*self.scale;
    
    //小细线；
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _topCon.height, self.view.bounds.size.width, .5)];
    line.backgroundColor = [UIColor colorWithRed:221/255.0 green:226/255.0 blue:227/255.0 alpha:1];
    [_topCon addSubview:line];
    
    
    UIButton *event = [UIButton buttonWithType:UIButtonTypeSystem];
    event.frame = CGRectMake(0, 10*self.scale, self.view.width, _topCon.bottom-10*self.scale);
    [event addTarget:self action:@selector(topEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_bigScrollVi addSubview:event];
    
    _setY = line.bottom;
    
    
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, _setY+15*self.scale, self.view.width, 200)];
    vi.backgroundColor=[UIColor whiteColor];
    [_bigScrollVi addSubview:vi];
    
    CellView *name = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50*self.scale)];
    [vi addSubview:name];
    
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 35*self.scale, 30*self.scale)];
    [headImg setImageWithURL:[NSURL URLWithString:_data[@"logo"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
    [name addSubview:headImg];
    
    UILabel *namela = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right+5*self.scale, name.height/2-10*self.scale, 100, 20*self.scale)];
    namela.font=DefaultFont(self.scale);
    namela.text=_data[@"shop_name"];
    [name addSubview:namela];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    
    
    CGSize size = [namela.text boundingRectWithSize:CGSizeMake(1000, 35*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

    namela.width = size.width;
    
//    UIButton *talkimg = [[UIButton alloc]initWithFrame:CGRectMake(namela.right+5*self.scale, namela.top, 20*self.scale, 20*self.scale)];
//    [talkimg setBackgroundImage:[UIImage imageNamed:@"dian_ico_01_b"] forState:UIControlStateNormal];
//    [talkimg addTarget:self action:@selector(talk) forControlEvents:UIControlEventTouchUpInside];
//    [name addSubview:talkimg];
    
    UIButton *teleimg = [[UIButton alloc]initWithFrame:CGRectMake(namela.right+5*self.scale, namela.top, 20*self.scale, 20*self.scale)];
    [teleimg setBackgroundImage:[UIImage imageNamed:@"ganxi_ico_02"] forState:UIControlStateNormal];
    [teleimg addTarget:self action:@selector(tele) forControlEvents:UIControlEventTouchUpInside];
    [name addSubview:teleimg];
    
    UIImageView *jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-30*self.scale, name.height/2-10*self.scale, 22.5*self.scale, 22.5*self.scale)];
    [jiantou setImage:[UIImage imageNamed:@"dd_right"]];
    name.height=jiantou.bottom+10*self.scale;
    [name addSubview:jiantou];

    
    CellView *xingqing = [[CellView alloc]initWithFrame:CGRectMake(0, name.bottom, self.view.width, 44*self.scale)];
    xingqing.topline.height=YES;
    [vi addSubview:xingqing];
    
    UIImageView *textimg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, xingqing.height/2-9*self.scale, 15*self.scale, 18*self.scale)];
    [textimg setImage:[UIImage imageNamed:@"leibie"]];
    [xingqing addSubview:textimg];
    
    UILabel *xing = [[UILabel alloc]initWithFrame:CGRectMake(textimg.right+5*self.scale, xingqing.height/2-10*self.scale, 150*self.scale, 20*self.scale)];
    xing.text=@"订单详情";
    xing.font=DefaultFont(self.scale);
    [xingqing addSubview:xing];
    
    CellView *context = [[CellView alloc]initWithFrame:CGRectMake(0, xingqing.bottom, self.view.width, 100*self.scale)];
    context.topline.hidden=YES;
    [vi addSubview:context];
    
    NSMutableArray *itemName = [NSMutableArray new];

    for (NSString *tag in _projectIndex) {
      
        NSLog(@"%@ *******%@",_project,_projectIndex);
        
        
        NSDictionary *dic = [_project objectAtIndex:[tag integerValue]-1];
        [itemName addObject:[dic objectForKey:@"item_name"]];
    }
    
  NSString *string = [itemName componentsJoinedByString:@","];
    
    
    
    NSArray *tim = [self.yueyutime componentsSeparatedByString:@"-"];
    if ([self.yueyutime isEqualToString:@"立即配送"]) {
        self.yueyutime=self.yueyutime;
        
    }else{
    
        self.yueyutime=tim[0];
    }
    
    
    
    NSArray *arr =@[self.xiatime,string,self.yueyutime];
    
    float setY = 10*self.scale;
    for (int i=0; i<3; i++) {
        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, setY+5*self.scale, self.view.width-20*self.scale, 23*self.scale)];
        la.text=[NSString stringWithFormat:@"%@  %@",_arr[i],arr[i]];
        la.font=SmallFont(self.scale);
        la.numberOfLines=0;
        [la sizeToFit];
        la.textColor=grayTextColor;
        [context addSubview:la];
        setY=la.bottom;
    }
    context.height=setY+10*self.scale;
    vi.height=context.bottom;
    
    CellView *beizhu = [[CellView alloc]initWithFrame:CGRectMake(0, vi.bottom+15*self.scale,self.view.width, 44*self.scale)];
    beizhu.backgroundColor=[UIColor whiteColor];
    beizhu.title=@"备注";
    [beizhu.titleLabel sizeToFit];
    [_bigScrollVi addSubview:beizhu];
    

    UITextView *tf = [[UITextView alloc]initWithFrame:CGRectMake(beizhu.titleLabel.right+10*self.scale, 0, self.view.width-beizhu.titleLabel.right-10*self.scale, 35*self.scale)];
    tf.delegate=self;
//    tf.placeholder=@"请输入备注信息";
    tf.font=DefaultFont(self.scale);
    if ([self.beizhu1 isEqualToString:@"" ] || self.beizhu1==nil) {
        
    }else{
        tf.text=self.beizhu1;
    }
    tf.tag=8888888;
    
    beizhu.height=tf.bottom+10*self.scale;
    [beizhu addSubview:tf];
    beizhu.height=tf.bottom+10*self.scale;
    
    
    UILabel *bb = [[UILabel alloc]initWithFrame:CGRectMake(beizhu.titleLabel.right +20*self.scale, 0*self.scale, self.view.width, tf.height)];
    bb.text=@"请输入特殊要求";
    bb.tag=99999999;
    bb.font=DefaultFont(self.scale);
    bb.textColor=blackLineColore;
    [beizhu addSubview:bb];
    if (![self.beizhu1 isEqualToString:@""]) {
        bb.hidden=YES;
    }

    
    
    UIButton *tijiao = [[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, beizhu.bottom+20*self.scale, self.view.width-20*self.scale, 35*self.scale)];
    [tijiao setTitle:@"确认提交" forState:UIControlStateNormal];
    tijiao.layer.cornerRadius=4;
    tijiao.backgroundColor=[UIColor redColor];
    [tijiao addTarget:self action:@selector(tijiao) forControlEvents:UIControlEventTouchUpInside];
    [_bigScrollVi addSubview:tijiao];
    
    
    _bigScrollVi.contentSize=CGSizeMake(self.view.width, tijiao.bottom);

}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:99999999];
        label.hidden=YES;
    }else
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:99999999];
        label.hidden=NO;
    }
    
}

-(void)talk{
    //改电话
    
//    if (!_isopen) {
//        [self ShowAlertWithMessage:@"该商家暂未开通聊天功能！"];
//        return;
//    }
//    RCDChatViewController *rcd = [RCDChatViewController new];
////    rcd.userName=_data[@"shop_name"];
//    
//    
//    
//    rcd.targetId=_data[@"shop_user_id"];
//    rcd.conversationType = ConversationType_PRIVATE;
//    rcd.title = _data[@"shop_name"];
//    [self.navigationController pushViewController: rcd animated:YES];
}

-(void)tele{
    
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%@",_data[@"id"]] forKey:@"shop_id"];
    [dic setObject:[NSString stringWithFormat:@"%@",_data[@"hotline"]] forKey:@"tel"];
    if ([Stockpile sharedStockpile].isLogin) {
        [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
    }
    
    [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
        }
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_data[@"hotline"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];

    
    
    


}

-(void)tijiao{

    
    
    
    if (_ar.count<=0) {
        [self ShowAlertWithMessage:@"请选择地址"];
        return;
    }
    
    
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    NSString *str = @"";
    //NSString * str1 = [str stringByAppendingString:@","];
    AnalyzeObject *anle = [AnalyzeObject new];
    
    for (NSString * tag in _projectIndex) {
        for (int i=0; i<_project.count; i++) {
            if ([tag intValue]-1 == i) {
                NSString * str1 = _project[i][@"item_id"];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",str1]];

            }
            
            
        }
        
        
    }
    
    
//    for (NSDictionary *dic in _project) {
//        
//       NSString * str1 = dic[@"item_id"];
//       str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",str1]];
//
//    }

    UITextField *tf = (UITextField *)[self.view viewWithTag:8888888];
    
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    NSDictionary *dic =@{@"user_id":self.user_id,@"shop_id":self.ID,@"address_id":_ar[@"id"],@"delivery_time":self.songTime,@"memo":tf.text,@"serve_item":str,@"community_id":[self getCommid]};
    [anle serveShopSubmitWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {

            
            
            
                LingshouSuesccViewController *order = [LingshouSuesccViewController new];
                [self.navigationController pushViewController:order animated:YES];
                

        }
        [self.activityVC stopAnimate];

        
    }];


}

-(void)topEvent:(UIButton *)sender{
    [self.view endEditing:YES];
    self.hidesBottomBarWhenPushed=YES;
    ShouHuoDiZhiListViewController *shouhuo = [ShouHuoDiZhiListViewController new];
    shouhuo.orReturn=YES;

    [self.navigationController pushViewController:shouhuo animated:YES];
}


#pragma mark -----返回按钮
-(void)returnVi{
    
   self.TitleLabel.text=@"确认订单";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
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
