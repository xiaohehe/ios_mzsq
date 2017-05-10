



//
//  FuWuXiangQingViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "FuWuXiangQingViewController.h"
#import "CellView.h"
#import "UmengCollection.h"
@interface FuWuXiangQingViewController ()
@property(nonatomic,strong)UIView *bigBtnVi,*bigVi,*UIView ;

@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)UIScrollView *bigXaingQingVi,*bigStateVi;
@property(nonatomic,strong)UIView *shopCellVi,*dingDanCellVi,*PingJiaCellVi;
@property(nonatomic,strong)CellView *vig;

@end

@implementation FuWuXiangQingViewController


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
    _lines = [NSMutableArray new];
    _data =[NSMutableArray new];
   // [self topVi];
    //[self statesVi];
    // [self oderXiangQingVi];
   // [self topvi];
    [self topVi];
   // [self myPingJiaCellVi];
  // [self bottomVi];
    [self reshData];

    
    [self returnVi];
}


-(void)reshData{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dic = @{@"user_id":userid,@"order_id":self.orderid,@"sub_order_id":self.smallOder};
    
    [anle myServeOrderDetailWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            [_data addObjectsFromArray:models];
            [self BigVi];
            [self topvi];
            [self statesVi];

        }
        [self.activityVC stopAnimate];
    }];
    
}

#pragma mark-------顶部，  订单状态，，订单详情
-(void)topVi{

    
    NSArray *daiArr = @[@"订单状态",@"订单详情"];
    _bigBtnVi = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 90/2.25*self.scale)];
    _bigBtnVi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bigBtnVi];
    for (int i=0; i<2; i++) {
        UIButton *daiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [daiBtn setTitle:daiArr[i] forState:UIControlStateNormal];
        daiBtn.titleLabel.font=DefaultFont(self.scale);
        [daiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        daiBtn.selected=(i==0);
        if (daiBtn.selected) {
            _selectedBtn=daiBtn;
        }
        [daiBtn setTitleColor:blueTextColor forState:UIControlStateSelected];
        daiBtn.frame = CGRectMake(i*self.view.width/2, 0, self.view.width/2, _bigBtnVi.height);
        daiBtn.tag=1+i;
        [daiBtn addTarget:self action:@selector(DaiButtonEvent1:) forControlEvents:UIControlEventTouchUpInside];
        [_bigBtnVi addSubview:daiBtn];
        if (i!=3) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(daiBtn.right,_bigBtnVi.height/2-7*self.scale, .5, 14*self.scale)];
            line.backgroundColor = blackLineColore;
            [_bigBtnVi addSubview:line];
        }
    }
    UIView *endLine = [[UIView alloc]initWithFrame:CGRectMake(0, _bigBtnVi.height-.5, self.view.width, .5)];
    endLine.backgroundColor = blackLineColore;
    [_bigBtnVi addSubview:endLine];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, endLine.top, self.view.width/2, endLine.height)];
    line.backgroundColor=blueTextColor;
    line.tag=666;
    [_bigBtnVi addSubview:line];
    
}

-(void)DaiButtonEvent1:(UIButton *)sender{
    if (_selectedBtn) {
        _selectedBtn.selected=NO;
    }
    _selectedBtn=sender;
    sender.selected=YES;
    
    [UIView animateWithDuration:.3 animations:^{
        UIView *line=[self.view viewWithTag:666];
        float W=self.view.width/2;
        line.frame=CGRectMake((sender.tag-1)*W, _bigBtnVi.height-.5, W, .5);
        
    }];
    
    switch (sender.tag) {
        case 1:{
            for (UIView *vi in [_bigVi subviews]) {
                [vi removeFromSuperview];
            }
            
            if ([_data[0][@"is_comment"] isEqualToString:@"2"]) {
                _vig.hidden=YES;
            }else{
                
                _vig.hidden=NO;
            }

            [_bigVi addSubview:_bigStateVi];
        }
            break;
            
        case 2:{
            for (UIView *vi in [_bigVi subviews]) {
                [vi removeFromSuperview];
            }
//            if ([_data[0][@"is_comment"] isEqualToString:@"2"]) {
//                _vig.hidden=YES;
//            }
            _vig.hidden=YES;
            [_bigVi addSubview:_bigXaingQingVi];
        }
            break;
            
        default:
            break;
    }
    
}

-(void)BigVi{
    if (_bigVi) {
        [_bigVi removeFromSuperview];
    }
    
    _bigVi = [[UIView alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
    _bigVi.backgroundColor = superBackgroundColor;
    [self.view addSubview:_bigVi];
    
    
    
}

#pragma mark--------状态；
-(void)statesVi{
    
    NSMutableArray *muta = [NSMutableArray new];
    NSArray *arr = @[@"订单提交成功",@"商家已经确认订单",@"订单已配送",@"订单已完成"];
    if (_bigStateVi) {
        [_bigStateVi removeFromSuperview];
    }
    
    _bigStateVi = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _bigVi.width, _bigVi.height)];
    [_bigVi addSubview:_bigStateVi];
    
    int q=0;
    if (_data.count>0) {
        
        if ([_data[0][@"status"] isEqualToString:@"2"]) {
            q=1;
        }
        if ([_data[0][@"status"] isEqualToString:@"3"]){
            q=2;
        }
        if ([_data[0][@"status"] isEqualToString:@"4"]){
            q=3;
        }
        if ([_data[0][@"status"] isEqualToString:@"5"]){
            q=4;
        }
        
        [muta addObject:_data[0][@"sub_create_time"]];
        [muta addObject:_data[0][@"receive_time"]];
        [muta addObject:_data[0][@"delivery_time"]];
        [muta addObject:_data[0][@"finish_time"]];
        
    }
    
    for (int i=0; i<q; i++) {
        
        UIImageView *statesImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-270*self.scale, 20*self.scale+i*200/2.25*self.scale, 570/2.25*self.scale, 170/2.25*self.scale)];
        statesImg.image = [UIImage imageNamed:@"box"];
        [_bigStateVi addSubview:statesImg];
        
        UILabel *timer = [[UILabel alloc]initWithFrame:CGRectMake(statesImg.width-130*self.scale, 10*self.scale, 120*self.scale, 30*self.scale)];
        timer.text=muta[i];
        timer.textAlignment=NSTextAlignmentRight;
        timer.font=SmallFont(self.scale);
        [statesImg addSubview:timer];
        
        
        
        if (i==0) {
            UILabel *statesLa = [[UILabel alloc]initWithFrame:CGRectMake(20*self.scale, 10*self.scale, statesImg.width-60*self.scale, 30*self.scale)];
            statesLa.text = arr[i];
            statesLa.font=DefaultFont(self.scale);
            [statesImg addSubview:statesLa];
            
            UILabel *infoLa = [[UILabel alloc]initWithFrame:CGRectMake(statesLa.left, statesLa.bottom, statesImg.width-20*self.scale, statesLa.height)];
            infoLa.text = [NSString stringWithFormat:@"订单号：%@,请耐心等待",self.smallOder];
            infoLa.font = SmallFont(self.scale);
            infoLa.numberOfLines=0;
            [statesImg addSubview:infoLa];
            
            
            
        }else{
            UILabel *statesLa = [[UILabel alloc]initWithFrame:CGRectMake(20*self.scale, 10*self.scale, statesImg.width-60*self.scale, 30*self.scale)];
            statesLa.text = arr[i];
            statesLa.font=DefaultFont(self.scale);
            [statesImg addSubview:statesLa];
            
            
            if (i==2) {
                float sty = statesLa.bottom;
                NSString *ren = [NSString stringWithFormat:@"%@ 电话：%@,已经在前去服务的路上",_data[0][@"delivery_staff_info"][@"name"],_data[0][@"delivery_staff_info"][@"mobile"]];
                NSMutableArray *arj = [NSMutableArray arrayWithObjects:ren, nil];
                
                
                for (int j=0; j<1; j++) {
                    UILabel *peisongren = [[UILabel alloc]initWithFrame:CGRectMake(statesLa.left, sty, statesImg.width-25*self.scale, 35*self.scale)];
                    peisongren.text=arj[j];
                    peisongren.numberOfLines=0;
                    peisongren.font=SmallFont(self.scale);
                    [statesImg addSubview:peisongren];
                    
                    sty = peisongren.bottom;
                }
            }
        }
        
        //UIImageView *sele = nil;
        
        UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, statesImg.bottom-statesImg.height/2-15*self.scale, 30*self.scale, 30*self.scale)];
        headImg.image = [UIImage imageNamed:@"center_dd_ico_01"];
        headImg.tag = 10+i;
        [_bigStateVi addSubview:headImg];
        
        [_lines addObject:[NSString stringWithFormat:@"%ld",(long)headImg.tag]];
        
        
        
    }
    
    if (_lines.count==1) {
        UIImageView *head = (UIImageView *)[self.view viewWithTag:[_lines[0] intValue]];
        
        UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(head.centerX, head.bottom, 1, self.view.height-head.centerY)];
        lin.backgroundColor=blackLineColore;
        [_bigStateVi addSubview:lin];
        
    }
    
    if (_lines.count==2) {
        UIImageView *head = (UIImageView *)[self.view viewWithTag:[_lines[0] intValue]];
        UIImageView *head2 = (UIImageView *)[self.view viewWithTag:[_lines[1] intValue]];
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(head.centerX, head.centerY+5*self.scale, 1, head2.bottom-head.bottom-20*self.scale)];
        line.backgroundColor=[UIColor redColor];
        [_bigStateVi addSubview:line];
        
        UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(head2.centerX, head2.bottom, 1, self.view.height-head2.centerY)];
        lin.backgroundColor=blackLineColore;
        [_bigStateVi addSubview:lin];
    }
    
    if (_lines.count==3) {
        UIImageView *head = (UIImageView *)[self.view viewWithTag:[_lines[0] intValue]];
        UIImageView *head2 = (UIImageView *)[self.view viewWithTag:[_lines[1] intValue]];
        UIImageView *head3 = (UIImageView *)[self.view viewWithTag:[_lines[2] intValue]];
        
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(head.centerX, head.centerY+5*self.scale, 1, head2.bottom-head.bottom-20*self.scale)];
        line.backgroundColor=[UIColor redColor];
        [_bigStateVi addSubview:line];
        
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(head2.centerX, head2.centerY+5*self.scale, 1, head3.bottom-head2.bottom-20*self.scale)];
        line1.backgroundColor=[UIColor redColor];
        [_bigStateVi addSubview:line1];
        
        UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(head3.centerX, head3.bottom, 1, self.view.height-head3.bottom)];
        lin.backgroundColor=blackLineColore;
        [_bigStateVi addSubview:lin];
        
        
        //        CellView *vig = [[CellView alloc]initWithFrame:CGRectMake(0, _bigStateVi.height-44*self.scale, self.view.width, 44*self.scale)];
        //        vig.backgroundColor=[UIColor whiteColor];
        //        [_bigStateVi addSubview:vig];
        //
        //        UIImageView *dui = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 25*self.scale, 25*self.scale)];
        //        dui.image=[UIImage imageNamed:@"center_dd_ok"];
        //        [vig addSubview:dui];
        //
        //        UIButton *quping = [[UIButton alloc]initWithFrame:CGRectMake(dui.right+10*self.scale, 7*self.scale, self.view.width-dui.right-20*self.scale, 30*self.scale)];
        //        quping.layer.cornerRadius=4;
        //        quping.layer.masksToBounds=YES;
        //        [quping setBackgroundImage:[UIImage ImageForColor:[UIColor orangeColor]] forState:UIControlStateNormal];
        //        [quping setTitle:@"去评价" forState:UIControlStateNormal];
        //        quping.titleLabel.font=DefaultFont(self.scale);
        //        [quping addTarget:self action:@selector(qupingjia) forControlEvents:UIControlEventTouchUpInside];
        //        [vig addSubview:quping];
        
        
    }
    if (_lines.count==4) {
        UIImageView *head = (UIImageView *)[self.view viewWithTag:[_lines[0] intValue]];
        UIImageView *head2 = (UIImageView *)[self.view viewWithTag:[_lines[1] intValue]];
        UIImageView *head3 = (UIImageView *)[self.view viewWithTag:[_lines[2] intValue]];
        UIImageView *head4 = (UIImageView *)[self.view viewWithTag:[_lines[3] intValue]];
        
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(head.centerX, head.centerY+5*self.scale, 1, head2.bottom-head.bottom-20*self.scale)];
        line.backgroundColor=[UIColor redColor];
        [_bigStateVi addSubview:line];
        
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(head2.centerX, head2.centerY+5*self.scale, 1, head3.bottom-head2.bottom-20*self.scale)];
        line1.backgroundColor=[UIColor redColor];
        [_bigStateVi addSubview:line1];
        
        UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(head3.centerX, head3.bottom, 1, head4.bottom-head3.bottom-20*self.scale)];
        lin.backgroundColor=[UIColor redColor];
        [_bigStateVi addSubview:lin];
        
        UIView *lin2 = [[UIView alloc]initWithFrame:CGRectMake(head4.centerX, head4.bottom, 1, self.view.height-head4.bottom)];
        lin2.backgroundColor=blackLineColore;
        [_bigStateVi addSubview:lin2];
        
        
        
        _vig = [[CellView alloc]initWithFrame:CGRectMake(0, self.view.height-44*self.scale, self.view.width, 44*self.scale)];
        _vig.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_vig];
        
        UIImageView *dui = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 25*self.scale, 25*self.scale)];
        dui.image=[UIImage imageNamed:@"center_dd_ok"];
        [_vig addSubview:dui];
        
        UIButton *quping = [[UIButton alloc]initWithFrame:CGRectMake(dui.right+10*self.scale, 7*self.scale, self.view.width-dui.right-20*self.scale, 30*self.scale)];
        quping.layer.cornerRadius=4;
        quping.layer.masksToBounds=YES;
        [quping setBackgroundImage:[UIImage ImageForColor:[UIColor redColor]] forState:UIControlStateNormal];
        [quping setTitle:@"去评价" forState:UIControlStateNormal];
        quping.titleLabel.font=DefaultFont(self.scale);
        [quping addTarget:self action:@selector(qupingjia) forControlEvents:UIControlEventTouchUpInside];
        [_vig addSubview:quping];
        
        if ([_data[0][@"is_comment"] isEqualToString:@"2"]) {
            _vig.hidden=YES;
        }
        _bigStateVi.contentSize=CGSizeMake(self.view.width, _vig.top+0*self.scale);
        
        
    }
    
    
}


-(void)qupingjia{
    self.hidesBottomBarWhenPushed=YES;
    XiePingJiaViewController *pingjia =[XiePingJiaViewController new];
    pingjia.lingshou=YES;
    [pingjia reshBlock:^(NSMutableArray *arr) {
        //        UIButton *btn = (UIButton *)[self.view viewWithTag:6666];
        _vig.hidden=YES;
        [self reshData];
        
    }];
    pingjia.is_order_on=YES;
    pingjia.order_on = _data[0][@"sub_order_no"];
    pingjia.shopid=_data[0][@"shop_id"];
    [self.navigationController pushViewController:pingjia animated:YES];
    
}



#pragma mark------详情；
-(void)topvi{
//    if (_bigXaingQingVi) {
//        [_bigXaingQingVi removeFromSuperview];
//    }
    
    _bigXaingQingVi = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10*self.scale, _bigVi.width, _bigVi.height)];
    _bigXaingQingVi.contentSize = CGSizeMake(self.view.width, 1000);
    
    _topCon = [[UIControl alloc]initWithFrame:CGRectMake(0, 7.5*self.scale, self.view.bounds.size.width, 145/2.25*self.scale)];
    _topCon.backgroundColor = [UIColor whiteColor];
    [_bigXaingQingVi addSubview:_topCon];
    
    
    _stripVi = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5*self.scale)];
    _stripVi.image = [UIImage imageNamed:@"dian_xq_line"];
    [_bigXaingQingVi addSubview:_stripVi];
    
    
    _shouHuoer = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 15*self.scale, 60*self.scale, 15*self.scale)];
    _shouHuoer.text = @"收货人 :";
    _shouHuoer.font = DefaultFont(self.scale);
    [_topCon addSubview:_shouHuoer];
    float r = _shouHuoer.right;
    float t = _shouHuoer.top;
    
    
    _shouName = [[UILabel alloc]initWithFrame:CGRectMake(r, t, 60*self.scale, 15)];
    _shouName.text = _data[0][@"delivery_address"][@"real_name"];
    _shouName.font = DefaultFont(self.scale);
    [_topCon addSubview:_shouName];
    r = _shouName.right;
    
    _shouTal = [[UILabel alloc]initWithFrame:CGRectMake(r+10, t, 130*self.scale, 15)];
    _shouTal.text = _data[0][@"delivery_address"][@"mobile"];
    _shouTal.font = DefaultFont(self.scale);
    [_topCon addSubview:_shouTal];
    float b = _shouTal.bottom;
    
    
    
    _shouAddressLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, b+10*self.scale, 70*self.scale, 35*self.scale)];
    _shouAddressLa.text = @"收货地址 :";
    _shouAddressLa.font =DefaultFont(self.scale);
    [_topCon addSubview:_shouAddressLa];
    r = _shouAddressLa.right;
    
    _addressLa = [[UILabel alloc]initWithFrame:CGRectMake(r, _shouAddressLa.top, self.view.width-_shouAddressLa.right-50*self.scale, 35*self.scale)];
    _addressLa.numberOfLines=0;
    _addressLa.font = DefaultFont(self.scale);
    _addressLa.text = _data[0][@"delivery_address"][@"address"];
    [_topCon addSubview:_addressLa];
    
    
//    _topArrow = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-30*self.scale, _shouHuoer.top+5*self.scale, 22.5*self.scale, 22.5*self.scale)];
//    _topArrow.image = [UIImage imageNamed:@"dd_right"];
//    [_topCon addSubview:_topArrow];
    _topCon.height=_addressLa.bottom+10*self.scale;
    
    //小细线；
    
    
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, .5)];
    topline.backgroundColor = blackLineColore;
    [_topCon addSubview:topline];

    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _topCon.height, self.view.bounds.size.width, .5)];
    line.backgroundColor = blackLineColore;
    [_topCon addSubview:line];
    
    
    
    
     _setY = _topCon.bottom+10*self.scale;
    
    [self oderXiangQingVi];
}









#pragma mark----订单详情-----
-(void)oderXiangQingVi{


    
    
    _shopCellVi = [[UIView alloc]initWithFrame:CGRectMake(0, _setY, self.view.width, 0)];
   // _shopCellVi.backgroundColor=[UIColor orangeColor];
    _shopCellVi.backgroundColor = [UIColor whiteColor];
    [_bigXaingQingVi addSubview:_shopCellVi];
    
    
    
    
    
    
    
    UIView *botline = [[UIView alloc]initWithFrame:CGRectMake(0, _shopCellVi.height, self.view.width, .5)];
    botline.backgroundColor=blackLineColore;
    [_shopCellVi addSubview:botline];

    CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, _shopCellVi.bottom, self.view.width, 44)];
    nameCell.topline.hidden=NO;
    [_bigXaingQingVi addSubview:nameCell];
    
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 7*self.scale, 40*self.scale, 30*self.scale)];
    [headImg setImageWithURL:[NSURL URLWithString:_data[0][@"logo"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
    [nameCell addSubview:headImg];
    nameCell.height=headImg.bottom+10*self.scale;
    
    UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right+5*self.scale, nameCell.height/2-10*self.scale, 0, 20*self.scale)];
    nameLa.text = _data[0][@"shop_name"];
    nameLa.font = DefaultFont(self.scale);
    [nameLa sizeToFit];
    [nameCell addSubview:nameLa];
    
    
//    UIButton *talkImg = [[UIButton alloc]initWithFrame:CGRectMake(nameLa.right+5*self.scale, nameCell.height/2-10*self.scale, 20*self.scale, 20*self.scale)];
//    [talkImg setBackgroundImage:[UIImage imageNamed:@"ganxi_ico_01"] forState:UIControlStateNormal];
//    [talkImg addTarget:self action:@selector(lianxiMaijia:) forControlEvents:UIControlEventTouchUpInside];
//    talkImg.tag=100;
//    [nameCell addSubview:talkImg];
    
    UIButton *teleImg = [[UIButton alloc]initWithFrame:CGRectMake(nameLa.right+5*self.scale, nameCell.height/2-10*self.scale, 20*self.scale, 20*self.scale)];
    [teleImg setBackgroundImage:[UIImage imageNamed:@"ganxi_ico_02"] forState:UIControlStateNormal];
    [teleImg addTarget:self action:@selector(lianxiMaijia:) forControlEvents:UIControlEventTouchUpInside];
    teleImg.tag=101;
    [nameCell addSubview:teleImg];
    
    UIImageView *jiantouImg = [[UIImageView alloc]initWithFrame:CGRectMake(teleImg.right+10*self.scale, nameCell.height/2-10*self.scale, teleImg.width+5*self.scale, teleImg.height+5*self.scale)];
    jiantouImg.image = [UIImage imageNamed:@"xq_right"];
    [nameCell addSubview:jiantouImg];
    float setY = nameCell.height+7*self.scale;
    
    NSArray *a = @[@"服务项目：",@"下单时间： ",@"预约时间：",@"备  注："];
    NSString *contextt =[[NSString alloc]init];
    NSMutableArray *items = [[NSMutableArray alloc]init];
    if (![_data[0][@"items"] isKindOfClass:[NSString class]]) {
        items = _data[0][@"items"];
        
        
        for (NSDictionary *dic in items) {
            contextt = [contextt stringByAppendingString:[NSString stringWithFormat:@"%@,",dic[@"item_name"]]];
        }
    }
    
    
    NSArray *context = @[contextt,_data[0][@"sub_create_time"],_data[0][@"send_time"],_data[0][@"memo"]];
    
    
    for (int i=0; i<4; i++) {
//        CellView *goodsCell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 20*self.scale)];
//        
//        goodsCell.titleLabel.font=SmallFont(self.scale);
//        goodsCell.titleLabel.textColor=grayTextColor;
//        goodsCell.contentLabel.font=SmallFont(self.scale);
//        goodsCell.contentLabel.textColor=grayTextColor;
//        goodsCell.contentLabel.text=context[i];
//        [goodsCell.contentLabel sizeToFit];
//        goodsCell.titleLabel.height=20*self.scale;
//        if (goodsCell.contentLabel.height<20*self.scale) {
//            goodsCell.contentLabel.height=20*self.scale;
//        }
//
//        
//        
//
//        goodsCell.topline.hidden=YES;
//        goodsCell.bottomline.hidden=YES;
//        goodsCell.title=a[i];
//        
//        
//        [_shopCellVi addSubview:goodsCell];
//        
//        if (i==0 || i==3) {
//            [goodsCell.contentLabel sizeToFit];
//            goodsCell.height=goodsCell.contentLabel.height;
//        }
//        
//
//        
//        setY = goodsCell.bottom+0*self.scale;
        
        CellView *goodsCell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 20*self.scale)];
        goodsCell.titleLabel.font=SmallFont(self.scale);
        goodsCell.titleLabel.textColor=grayTextColor;
        goodsCell.contentLabel.font=SmallFont(self.scale);
        goodsCell.contentLabel.textColor=grayTextColor;
        goodsCell.contentLabel.text=context[i];
        [goodsCell.contentLabel sizeToFit];
        goodsCell.titleLabel.height=20*self.scale;
        if (goodsCell.contentLabel.height<20*self.scale) {
            goodsCell.contentLabel.height=20*self.scale;
        }
        goodsCell.topline.hidden=YES;
        goodsCell.bottomline.hidden=YES;
        goodsCell.title=a[i];
        
        
        goodsCell.height=goodsCell.contentLabel.bottom+10*self.scale;
        [_shopCellVi addSubview:goodsCell];
        
        
        
        setY = goodsCell.bottom;

    }
    

     _shopCellVi.height = setY+10*self.scale;
    UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(0, _shopCellVi.height-.5, self.view.width, .5)];
    lin.backgroundColor=blackLineColore;
    [_shopCellVi addSubview:lin];
   

    
    
    
    CellView *info = [[CellView alloc]initWithFrame:CGRectMake(0, _shopCellVi.bottom+10*self.scale, self.view.width, 200*self.scale)];
    info.topline.hidden=NO;
    info.bottomline.hidden=NO;
    info.backgroundColor=[UIColor whiteColor];
    [_bigXaingQingVi addSubview:info];
    
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, self.view.width, 20*self.scale)];
    la.text=@"订单信息";
    la.textColor=grayTextColor;
    la.font=SmallFont(self.scale);
    [info addSubview:la];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10*self.scale, la.bottom+10*self.scale, self.view.width-20*self.scale, .5)];
    line.backgroundColor=blackLineColore;
    [info addSubview:line];
    
    
    float y = line.bottom;

    NSArray *ar = @[@"订单编号：",@"下单时间：",@"完成时间："];
    NSArray *con = @[_data[0][@"sub_order_no"],_data[0][@"sub_create_time"],_data[0][@"finish_time"]];
    for (int i=0; i<3; i++) {
        CellView *goodsCell = [[CellView alloc]initWithFrame:CGRectMake(0, y, self.view.width, 20*self.scale)];
        goodsCell.titleLabel.font=SmallFont(self.scale);
        goodsCell.titleLabel.textColor=grayTextColor;
        goodsCell.contentLabel.font=SmallFont(self.scale);
        goodsCell.contentLabel.textColor=grayTextColor;
        goodsCell.contentLabel.text=con[i];
        [goodsCell.contentLabel sizeToFit];
        goodsCell.titleLabel.height=20*self.scale;
        if (goodsCell.contentLabel.height<20*self.scale) {
            goodsCell.contentLabel.height=20*self.scale;
        }
        goodsCell.topline.hidden=YES;
        goodsCell.bottomline.hidden=YES;
        goodsCell.title=ar[i];
        
        
        [info addSubview:goodsCell];
        
        
        
        y = goodsCell.bottom;
    }
    
    info.height=y+10*self.scale;
    
    //_shopCellVi.height = info.bottom;
    
    _bigXaingQingVi.contentSize=CGSizeMake(self.view.width, info.bottom+20*self.scale);
    
    
    
    
    
}
-(void)lianxiMaijia:(UIButton *)sender{
    
    if (sender.tag==100) {
        //聊天
        //改电话
//        if ([_data[0][@"is_open_chat"]isEqualToString:@"2"]) {
//            [self ShowAlertWithMessage:@"该商家暂未开通聊天功能！"];
//            return;
//        }
//        
//        RCDChatViewController *rcd = [RCDChatViewController new];
////        rcd.userName=_data[0][@"shop_name"];
//        rcd.targetId=_data[0][@"shop_user_id"];
//        rcd.conversationType = ConversationType_PRIVATE;
//        rcd.title = _data[0][@"shop_name"];
//        [self.navigationController pushViewController: rcd animated:YES];

        
        
    }else{
        //电话
        
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%@",_data[0][@"shop_id"]] forKey:@"shop_id"];
        [dic setObject:[NSString stringWithFormat:@"%@",_data[0][@"hotline"]] forKey:@"tel"];
        if ([Stockpile sharedStockpile].isLogin) {
            [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
        }
        
        [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
            }
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_data[0][@"hotline"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];

        
        
       

        
        
    }
}



#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"订单";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    if (_isPush) {
//        [self dismissViewControllerAnimated:YES completion:nil];
         self.dismissBlock(YES);
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }}
-(CGSize)sizetoFitWithString:(NSString *)string{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(200, 35*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return size;
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
