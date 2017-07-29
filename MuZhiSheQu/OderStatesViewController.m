//
//  OderStatesViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "OderStatesViewController.h"
#import "CellView.h"
#import "IntroModel.h"
#import "IntroControll.h"
#import "UmengCollection.h"
@interface OderStatesViewController ()
@property(nonatomic,strong)UIView *bigBtnVi,*bigVi,*UIView ;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)UIScrollView *bigXaingQingVi,*bigStateVi;
@property(nonatomic,strong)UIView *shopCellVi,*dingDanCellVi,*PingJiaCellVi;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)CellView *vig;
@property(nonatomic,strong)IntroControll *IntroCon;
@property(nonatomic,strong)UILabel *la;

@property(nonatomic,assign)float pricel;
@end

@implementation OderStatesViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [UmengCollection intoPage:NSStringFromClass([self class])];
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
    
    //[self statesVi];
   // [self oderXiangQingVi];
    //[self xiangQingCellVi];
    //[self myPingJiaCellVi];
   // [self bottomVi];
       [self topVi];

    [self reshData];
    
    [self returnVi];
}


-(void)reshData{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dic = @{@"user_id":userid,@"order_id":self.orderid,@"sub_order_id":self.smallOder};
    
    
    
    [anle myOrderDetailWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        NSLog(@"myOrderDetailWithDic==%@",models);
        if ([code isEqualToString:@"0"]) {
            [_data addObjectsFromArray:models];
            [self BigVi];

            [self statesVi];
            [self oderXiangQingVi];
            [self xiangQingCellVi];
        }
        [self.activityVC stopAnimate];
    }];

}

#pragma mark-------顶部，  订单状态，，订单详情
-(void)topVi{
    NSArray *daiArr = @[@"订单状态",@"订单详情"];
    
    if (_bigBtnVi) {
        [_bigBtnVi removeFromSuperview];
    }
    
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
      else  if ([_data[0][@"status"] isEqualToString:@"3"]){
        q=2;
    }
      else  if ([_data[0][@"status"] isEqualToString:@"4"]){
        q=3;
    }
      else  if ([_data[0][@"status"] isEqualToString:@"5"]){
            q=4;
      }else{
      
      
      
      }
    
        [muta addObject:_data[0][@"sub_create_time"]];
        [muta addObject:_data[0][@"receive_time"]];
        [muta addObject:_data[0][@"delivery_time"]];
        [muta addObject:_data[0][@"finish_time"]];
        
    }
    
    NSMutableArray *imgarr = [[NSMutableArray alloc]initWithObjects:@"center_dd_ico_01",@"center_dd_ico_03",@"center_dd_ico_02",@"center_dd_ico_03", nil];

    
    
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
        headImg.image = [UIImage imageNamed:imgarr[i]];
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
        

        quping.tag=6666;
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
    pingjia.is_order_on=YES;
    pingjia.lingshou=YES;
    [pingjia reshBlock:^(NSMutableArray *arr) {
        _vig.hidden=YES;
        [self reshData];
        
    }];
    pingjia.order_on = _data[0][@"sub_order_no"];
    pingjia.shopid = _data[0][@"shop_id"];
    [self.navigationController pushViewController:pingjia animated:YES];

}

#pragma mark----订单详情-----
-(void)oderXiangQingVi{
    
    if (_bigXaingQingVi) {
        [_bigXaingQingVi removeFromSuperview];
    }
    
    
    _bigXaingQingVi = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10*self.scale, _bigVi.width, _bigVi.height)];
    _bigXaingQingVi.contentSize = CGSizeMake(self.view.width, 1000);

    
    
    _shopCellVi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    _shopCellVi.backgroundColor = [UIColor whiteColor];
    [_bigXaingQingVi addSubview:_shopCellVi];

    CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    [_bigXaingQingVi addSubview:nameCell];
    
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 7*self.scale, 40*self.scale, 30*self.scale)];
    [headImg setImageWithURL:[NSURL URLWithString:_data[0][@"logo"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
    [nameCell addSubview:headImg];
    nameCell.height=headImg.bottom+10*self.scale;
    
    UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right+5*self.scale, nameCell.height/2-10*self.scale, 0, 20*self.scale)];

    
    nameLa.text = _data[0][@"shop_name"];
    nameLa.font = DefaultFont(self.scale);
    [nameCell addSubview:nameLa];
    [nameLa sizeToFit];
    
    if (nameLa.width>150*self.scale) {
        nameLa.width=150*self.scale;
    }
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
    
    UIImageView *jiantouImg = [[UIImageView alloc]initWithFrame:CGRectMake(teleImg.right+10*self.scale, nameCell.height/2-12.5*self.scale, teleImg.width+5*self.scale, teleImg.height+5*self.scale)];
    jiantouImg.image = [UIImage imageNamed:@"xq_right"];
    [nameCell addSubview:jiantouImg];
    float setY = nameCell.bottom;

    _pricel= [_data[0][@"delivery_fee"] floatValue];
    
    for (int i=0; i<[_data[0][@"prods"] count]; i++) {
        CellView *goodsCell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 44)];
        [_shopCellVi addSubview:goodsCell];

        UIImageView *dianImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, goodsCell.height/2-2.5*self.scale, 5*self.scale, 5*self.scale)];
        dianImg.backgroundColor = grayTextColor;
        dianImg.layer.cornerRadius=2.5f;
        [goodsCell addSubview:dianImg];
        
        
        UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(dianImg.right+5*self.scale, goodsCell.height/2-10*self.scale, 170*self.scale, 20*self.scale)];
        nameLa.text =_data[0][@"prods"][i][@"prod_name"];
        
        nameLa.font = DefaultFont(self.scale);
        [goodsCell addSubview:nameLa];
        
        
        UILabel *numberLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/2+50*self.scale, goodsCell.height/2-10*self.scale, 30*self.scale, 20*self.scale)];
        numberLa.text = [NSString stringWithFormat:@"x%@",_data[0][@"prods"][i][@"prod_count"]];
        numberLa.font = DefaultFont(self.scale);
        [goodsCell addSubview:numberLa];
        
        UILabel *priceLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/2+100*self.scale, goodsCell.height/2-10*self.scale, 70*self.scale, 20*self.scale)];
        priceLa.text = [NSString stringWithFormat:@"￥%@",_data[0][@"prods"][i][@"price"]];
        priceLa.font = DefaultFont(self.scale);
        [goodsCell addSubview:priceLa];
        
        _pricel = [[NSString stringWithFormat:@"%@",_data[0][@"prods"][i][@"amount"]]floatValue ]+_pricel;
        
        NSLog(@"%@",_data[0]);
        
        setY = goodsCell.bottom;
    }

    CellView *heJiCell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 44)];
    
    
    
    
    
    heJiCell.contentLabel.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"合计：￥%.2f",_pricel] redString:[NSString stringWithFormat:@"￥%.2f",_pricel]];

//    heJiCell.contentLabel.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"合计：￥%@",_data[0][@"sub_amount"]] redString:[NSString stringWithFormat:@"￥%@",_data[0][@"sub_amount"]]];

//    heJiCell.contentLabel.text = [NSString stringWithFormat:@"合计：￥%@",_price];
//    heJiCell.contentLabel.textColor = [UIColor redColor];
    heJiCell.contentLabel.textAlignment = NSTextAlignmentRight;
    [_shopCellVi addSubview:heJiCell];
    
    
    CellView *sendTimeCell = [[CellView alloc]initWithFrame:CGRectMake(0, heJiCell.bottom, self.view.width, 44)];
    sendTimeCell.title = @"配送时间";
    sendTimeCell.contentLabel.text = _data[0][@"send_time"];
    sendTimeCell.contentLabel.textColor=grayTextColor;
    [_shopCellVi addSubview:sendTimeCell];
    
    CellView *beiZhuCell = [[CellView alloc]initWithFrame:CGRectMake(0, sendTimeCell.bottom, self.view.width, 44)];
    beiZhuCell.titleLabel.text =@"备注";
    beiZhuCell.titleLabel.textColor = [UIColor redColor];
    beiZhuCell.contentLabel.text = _data[0][@"memo"];
    
    if ([beiZhuCell.contentLabel.text isEmptyString]) {
        beiZhuCell.contentLabel.text=@"";
    }
    
    beiZhuCell.contentLabel.textColor=grayTextColor;
    [_shopCellVi addSubview:beiZhuCell];
    
    [beiZhuCell.contentLabel sizeToFit];
    
  
    
    beiZhuCell.height=beiZhuCell.contentLabel.bottom+10*self.scale;
    
    if (beiZhuCell.height<44*self.scale) {
        beiZhuCell.height=44*self.scale;
    }
    
    _shopCellVi.height = beiZhuCell.bottom;
    
    _bigXaingQingVi.contentSize=CGSizeMake(self.view.width, _shopCellVi.bottom+10*self.scale);
    
    [self xiangQingCellVi];
}
-(void)lianxiMaijia:(UIButton *)sender{

    if (sender.tag==100) {
//聊天
//        if ([_data[0][@"is_open_chat"]isEqualToString:@"2"]) {
//            [self ShowAlertWithMessage:@"该商家暂未开通聊天功能！"];
//            return;
//        }
//       
//        self.hidesBottomBarWhenPushed=YES;
//        RCDChatViewController *chatService = [RCDChatViewController new];
//        chatService.targetId = _data[0][@"shop_user_id"];
//        chatService.conversationType = ConversationType_PRIVATE;
//        chatService.title = _data[0][@"shop_name"];
//        [self.navigationController pushViewController: chatService animated:YES];

        
        
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


#pragma mark------详情；
-(void)xiangQingCellVi{
    _dingDanCellVi = [[UIView alloc]initWithFrame:CGRectMake(0, _shopCellVi.bottom+10*self.scale, self.view.width, 1000)];
    [_bigXaingQingVi addSubview:_dingDanCellVi];
    
    CellView *xiangQingCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    [_dingDanCellVi addSubview:xiangQingCell];

    UIImageView *dingDanImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, xiangQingCell.height/2-7.5*self.scale, 12.5*self.scale, 15*self.scale)];

    dingDanImg.image = [UIImage imageNamed:@"leibie"];
    [xiangQingCell addSubview:dingDanImg];
    
    UILabel *xiangQingLa = [[UILabel alloc]initWithFrame:CGRectMake(dingDanImg.right+5*self.scale, dingDanImg.top, self.view.width-20*self.scale, 15*self.scale)];
    xiangQingLa.text = @"订单详情";
    xiangQingLa.font = DefaultFont(self.scale);
    [xiangQingCell addSubview:xiangQingLa];
    
    CellView *dingDanHaoCell = [[CellView alloc]initWithFrame:CGRectMake(0, xiangQingCell.bottom, self.view.width, 44)];
    dingDanHaoCell.title=@"订单号：";
    dingDanHaoCell.contentLabel.text = self.smallOder;
    [dingDanHaoCell setHidden:NO];
    [_dingDanCellVi addSubview:dingDanHaoCell];
    
    CellView *xiaDanTimeCell = [[CellView alloc]initWithFrame:CGRectMake(0, dingDanHaoCell.bottom, self.view.width, 44)];
    xiaDanTimeCell.title=@"下单时间：";
    xiaDanTimeCell.contentLabel.text = _data[0][@"sub_create_time"];
    [_dingDanCellVi addSubview:xiaDanTimeCell];
    
    CellView *zhiFuTypeCell = [[CellView alloc]initWithFrame:CGRectMake(0, xiaDanTimeCell.bottom, self.view.width, 44)];
    zhiFuTypeCell.title=@"支付方式：";
    
    NSString *type =@"";
    if ([_data[0][@"pay_type"] isEqualToString:@"1"]) {
        type=@"支付宝支付";
    }else if ([_data[0][@"pay_type"] isEqualToString:@"2"]) {
        type=@"微信支付";
    }else if ([_data[0][@"pay_type"] isEqualToString:@"3"]) {
        type=@"货到付款";
    }
    
    zhiFuTypeCell.contentLabel.text = type;
    [_dingDanCellVi addSubview:zhiFuTypeCell];
    
    CellView *teleCell = [[CellView alloc]initWithFrame:CGRectMake(0, zhiFuTypeCell.bottom, self.view.width, 44)];
    teleCell.title=@"手机号码：";
    if ([_data[0][@"delivery_address"] count]>0) {
        teleCell.contentLabel.text = _data[0][@"delivery_address"][@"mobile"];
    }else{
        teleCell.contentLabel.text = @"";
    }
    
    [_dingDanCellVi addSubview:teleCell];
    
    CellView *adressCell = [[CellView alloc]initWithFrame:CGRectMake(0, teleCell.bottom, self.view.width, 44)];
    if ([_data[0][@"delivery_address"] count]>0) {
        
        NSString *ad = _data[0][@"delivery_address"][@"address"];
        
        if (![_data[0][@"delivery_address"][@"house_number"] isEqualToString:@""]) {
            ad = [ad stringByAppendingString:_data[0][@"delivery_address"][@"house_number"]];
        }
        

        
        
        adressCell.contentLabel.text = ad;
    }else{
        adressCell.contentLabel.text = @"";

    }
    [adressCell.contentLabel sizeToFit];
    adressCell.height=adressCell.contentLabel.bottom+10*self.scale;
    adressCell.contentLabel.font = DefaultFont(self.scale);
    adressCell.titleLabel.text = @"收货地址：";
    adressCell.titleLabel.font = DefaultFont(self.scale);
    adressCell.titleLabel.numberOfLines=0;
    [_dingDanCellVi addSubview:adressCell];
    
    
    
    _dingDanCellVi.height = adressCell.bottom;
    _bigXaingQingVi.contentSize=CGSizeMake(self.view.width, _dingDanCellVi.bottom+20*self.scale);

    
    if ([_data[0][@"comment"] count]>0) {
        [self myPingJiaCellVi];
    }else{
        _again = _dingDanCellVi.bottom+10*self.scale;
    
    }
    
    
    
}
#pragma mark----我的评价--r
-(void)myPingJiaCellVi{
    _PingJiaCellVi = [[UIView alloc]initWithFrame:CGRectMake(0, _dingDanCellVi.bottom+10*self.scale, self.view.width, 1000)];
    [_bigXaingQingVi addSubview:_PingJiaCellVi];
    CellView *pingjiaCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    [_PingJiaCellVi addSubview:pingjiaCell];
    UIImageView *dingDanImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, pingjiaCell.height/2-7.5*self.scale, 15*self.scale, 15*self.scale)];
    dingDanImg.image = [UIImage imageNamed:@"pingjia"];
    [pingjiaCell addSubview:dingDanImg];
    UILabel *xiangQingLa = [[UILabel alloc]initWithFrame:CGRectMake(dingDanImg.right+5*self.scale, dingDanImg.top, self.view.width-20*self.scale, 15*self.scale)];
    xiangQingLa.text = @"我的评价";
    xiangQingLa.font = DefaultFont(self.scale);
    [pingjiaCell addSubview:xiangQingLa];
    CellView *contextCell = [[CellView alloc]initWithFrame:CGRectMake(0, pingjiaCell.bottom, self.view.width, 200)];
    [_PingJiaCellVi addSubview:contextCell];
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 50*self.scale, 50*self.scale)];
    [headImg setImageWithURL:[NSURL URLWithString:_data[0][@"comment"][@"avatar"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
    headImg.layer.cornerRadius=25.0f*self.scale;
    headImg.layer.masksToBounds=YES;
    [contextCell addSubview:headImg];
    UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right+5*self.scale, headImg.top, self.view.width-70*self.scale, 20*self.scale)];
    if (![_data[0][@"comment"][@"nick_name"] isKindOfClass:[NSNull class]]) {
        nameLa.text = _data[0][@"comment"][@"nick_name"];
    }
    nameLa.font = DefaultFont(self.scale);
    [contextCell addSubview:nameLa];
    
    
    float setB=0;

    
    UILabel *contextLa = [[UILabel alloc]initWithFrame:CGRectMake(nameLa.left, nameLa.bottom+5*self.scale, nameLa.width, 20*self.scale)];
    contextLa.text = _data[0][@"comment"][@"content"];
    contextLa.textColor=grayTextColor;
    contextLa.font=SmallFont(self.scale);
    contextLa.numberOfLines=0;
    [contextCell addSubview:contextLa];
    
    [contextLa sizeToFit];
    setB=contextLa.bottom+20*self.scale;
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
//    
//    CGSize size = [contextLa.text boundingRectWithSize:CGSizeMake(contextLa.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    
//    CGFloat height =MAX(size.height, 44.0f);
//    contextLa.height = height;
    NSMutableArray *ar = [NSMutableArray new];
    float W = (contextCell.width-40-headImg.right)/3;
    
    for (int i=1; i<10; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i];
        
        NSString *img = _data[0][@"comment"][str];
        
        
        
        NSString *url=@"";
        NSString *cut = img;
        NSLog(@"%@",cut);
        NSString *imagename = [cut lastPathComponent];
        NSString *path = [cut stringByDeletingLastPathComponent];
        NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb320."]];
//        if (cut.length>0) {
//            url = [cut substringToIndex:[cut length] - 4];
//            url = [NSString stringWithFormat:@"%@_thumb320.jpg",url];
//            
//        }
//        
        
        
        if (img!=nil && ![img isEqualToString:@""]) {
            [ar addObject:smallImgUrl];
        }
    }
    
    
    for (int i=0; i<ar.count; i++) {
        
        float x = (W+10*self.scale)*(i%3);
        float y = (W-10*self.scale)*(i/3);
        
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(contextLa.left+x, contextLa.bottom+10*self.scale+y, W, W*0.75)];
        [image1 setImageWithURL:[NSURL URLWithString:ar[i]] placeholderImage:[UIImage imageNamed:@"center_img"]];
        [contextCell addSubview:image1];
        image1.userInteractionEnabled=YES;
        setB = image1.bottom+20*self.scale;
        image1.tag=100000+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBig:)];
        [image1 addGestureRecognizer:tap];
        
//        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(image1.right+5*self.scale, image1.top, 50*self.scale, 50*self.scale)];
//        image2.backgroundColor = [UIColor redColor];
//        [contextCell addSubview:image2];
//        
//        UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(image2.right+5*self.scale, image1.top, 50*self.scale, 50*self.scale)];
//        image3.backgroundColor = [UIColor redColor];
//        [contextCell addSubview:image3];
//        
//        
//        UILabel *tameLa = [[UILabel alloc]initWithFrame:CGRectMake(image1.left, image1.bottom+5*self.scale, nameLa.width, 15*self.scale)];
//        tameLa.text = @"2015-07-09  20:45";
//        tameLa.textColor=grayTextColor;
//        tameLa.font=Small10Font(self.scale);
//        [contextCell addSubview:tameLa];
//        
//        setB = tameLa.bottom;

    }

    contextCell.height = setB+10*self.scale;
    
    _PingJiaCellVi.height=contextCell.bottom;
    
    
    _bigXaingQingVi.contentSize=CGSizeMake(self.view.width, _PingJiaCellVi.bottom+20*self.scale);

    _again = _PingJiaCellVi.bottom+10*self.scale;
    
    
   // [self bottomVi:setB];
    
}


-(void)imgBig:(UITapGestureRecognizer *)tap{

    
    NSMutableArray *ar = [NSMutableArray new];
    
    for (int i=1; i<10; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i];
        
        NSString *img = _data[0][@"comment"][str];
        
        
        
        if (img!=nil && ![img isEqualToString:@""]) {
            [ar addObject:img];
        }
    }
    
    
    
    NSMutableArray *pagesArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < ar.count; i ++) {
        
        IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:[NSString stringWithFormat:@"%@",ar[i]]];
        [pagesArr addObject:model1];
    }
    
    _IntroCon = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:pagesArr];
    //  _intro.delegate=self;
    [_IntroCon index:tap.view.tag-100000];
    self.tabBarController.tabBar.hidden=YES;
    
    
    
    [[[UIApplication sharedApplication].delegate window] addSubview:_IntroCon];

}
#pragma mark----底部  再来一单；；
-(void)bottomVi:(float)fl{
    
    
    UIButton *againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    againBtn.backgroundColor = [UIColor redColor];
    [againBtn setTitle:@"再来一单" forState:UIControlStateNormal];
    againBtn.titleLabel.font = BigFont(self.scale);
    [againBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [againBtn addTarget:self action:@selector(againBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    againBtn.frame = CGRectMake(10*self.scale,_again, self.view.width-20*self.scale, 30*self.scale);
    againBtn.layer.cornerRadius=5.0*self.scale;
    [_bigXaingQingVi addSubview:againBtn];


    _bigXaingQingVi.contentSize = CGSizeMake(self.view.width, againBtn.bottom+20*self.scale);
}
-(void)againBtnEvent:(UIButton *)sender{

    
    
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
    }
}
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
