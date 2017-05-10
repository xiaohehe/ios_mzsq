//
//  FuWuLeiDingDanViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "FuWuLeiDingDanViewController.h"
#import "WeiPeiTableViewCell.h"
#import "YiPeiSongTableViewCell.h"
#import "DaiPingJiaTableViewCell.h"
#import "XiePingJiaViewController.h"
#import "AlloderSViewController.h"
#import "UmengCollection.h"
@interface FuWuLeiDingDanViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)UIView *bigBtnVi;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,assign)NSInteger inde,index,index1,index2;
@property(nonatomic,strong)NSString *zhuang;
@property(nonatomic,strong)NSMutableArray *data,*data1,*data2;
@property(nonatomic,assign)NSInteger qu;
@property(nonatomic,strong)UILabel *la;

@end

@implementation FuWuLeiDingDanViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
   // [self reshData];
    [UmengCollection intoPage:NSStringFromClass([self class])];
    if ([_zhuang isEqualToString:@"3"]) {
        _qu=3;
        _zhuang=@"3";
        _inde=0;
        [self reshData];
    }
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _qu=1;
    _zhuang=@"1";
    _inde=0;
    _index=0;
    _index1=0;
    _index2=0;
    _data=[NSMutableArray new];
    _data1=[NSMutableArray new];
    _data2=[NSMutableArray new];
    // Do any additional setup after loading the view.
    
    [self returnVi];
    [self heardView];
    [self oderView:_qu];
    [self.view addSubview:self.activityVC];
    [self reshData];
}
-(void)reshData{
    [_la removeFromSuperview];
    [self.activityVC startAnimate];
        _inde++;
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];

    NSString *index = [NSString stringWithFormat:@"%ld",(long)_inde];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"user_id":self.user_id,@"status":_zhuang,@"pindex":index};
    
    [anle myServeOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        
//        dispatch_sync(dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"-----%@",models);

            
            [self.activityVC stopAnimate];
            [self.table.header endRefreshing];
            [self.table.footer endRefreshing];

            if (_inde==1) {
                [_data removeAllObjects];
            }
            
            if ([code isEqualToString:@"0"]) {
                [_data addObjectsFromArray:models];
            }
            
            
            if (_data.count<=0) {
                _la = [[UILabel alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
                _la.text=@"暂无订单信息！";
                _la.textAlignment=NSTextAlignmentCenter;
                
                [self.view addSubview:_la];
            }
            
            [_table reloadData];

        });
        
        

//        });
        
        
        

            
        
    }];
}

-(void)heardView{
    NSArray *daiArr = @[@"未配送",@"已配送",@"待评价"];
   _bigBtnVi = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 90/2.25*self.scale)];
    _bigBtnVi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bigBtnVi];
    for (int i=0; i<3; i++) {
        UIButton *daiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [daiBtn setTitle:daiArr[i] forState:UIControlStateNormal];
        daiBtn.titleLabel.font=DefaultFont(self.scale);
        [daiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        daiBtn.selected=(i==0);
        if (daiBtn.selected) {
            _selectedBtn=daiBtn;
        }
        [daiBtn setTitleColor:blueTextColor forState:UIControlStateSelected];
        daiBtn.frame = CGRectMake(i*self.view.width/3+1*self.scale, 0, self.view.width/3, _bigBtnVi.height);
        daiBtn.tag=10+i;
        [daiBtn addTarget:self action:@selector(DaiButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_bigBtnVi addSubview:daiBtn];
        if (i!=2) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(daiBtn.right,_bigBtnVi.height/2-7*self.scale, .5, 14*self.scale)];
            line.backgroundColor = blackLineColore;
            [_bigBtnVi addSubview:line];
        }
    }
    UIView *endLine = [[UIView alloc]initWithFrame:CGRectMake(0, _bigBtnVi.height-.5, self.view.width, .5)];
    endLine.backgroundColor = blackLineColore;
    [_bigBtnVi addSubview:endLine];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, endLine.top, self.view.width/3, endLine.height)];
    line.backgroundColor=blueTextColor;
    line.tag=666;
    [_bigBtnVi addSubview:line];
    





}
-(void)DaiButtonEvent:(UIButton *)button{
    
    if (_selectedBtn) {
        _selectedBtn.selected=NO;
    }
    _selectedBtn=button;
    button.selected=YES;
    
    [UIView animateWithDuration:.3 animations:^{
        UIView *line=[self.view viewWithTag:666];
        float W=self.view.width/3;
        line.frame=CGRectMake((button.tag-10)*W, _bigBtnVi.height-.5, W, .5);
        
    }];
    
    switch (button.tag+10) {
        case 20:
            
            _qu=1;
            _zhuang=@"1";
            _inde=0;
            [self reshData];
            break;
            
        case 21:
            _qu=2;
            _zhuang=@"2";
            _inde=0;
            [self reshData];
            break;
            
            
        case 22:
            _qu=3;
            _zhuang=@"3";
            _inde=0;
            [self reshData];
            break;
            
            
        default:
            break;
    }
    
    
}

-(void)oderView:(NSInteger)tang{
    
    
    _table =[[UITableView alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom+0*self.scale, self.view.width, self.view.height- _bigBtnVi.bottom-10*self.scale) ];
    _table.delegate=self;
    _table.dataSource=self;
    _table.tag=tang;
    [_table registerClass:[WeiPeiTableViewCell class] forCellReuseIdentifier:@"cell1"];
    [_table registerClass:[YiPeiSongTableViewCell class] forCellReuseIdentifier:@"cell2"];
    [_table registerClass:[DaiPingJiaTableViewCell class] forCellReuseIdentifier:@"cell3"];
    _table.backgroundColor=superBackgroundColor;
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(foot)];
    [_table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(head)];
    [self.view addSubview:_table];


}

//-(void)rashD{
//    [_la removeFromSuperview];
//    //[self.activityVC startAnimate];
//   
//    _index++;
//    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
//
//    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
//    AnalyzeObject *anle = [AnalyzeObject new];
//    NSDictionary *dic = @{@"user_id":self.user_id,@"status":_zhuang,@"pindex":index};
//    
//    [anle myServeOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
//        [_table.header endRefreshing];
//        [_table.footer endRefreshing];
//        if (_index==1) {
//            [_data removeAllObjects];
//        }
//        if ([code isEqualToString:@"0"]) {
//            
//            [_data addObjectsFromArray:models];
//        }
//        
//        if (_data.count<=0) {
//            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
//            _la.text=@"暂无订单信息！";
//            _la.textAlignment=NSTextAlignmentCenter;
//            
//            [self.view addSubview:_la];
//        }
//
//        [_table reloadData];
//
//        
//    }];
//
//}
//-(void)rashD1{
//    //[self.activityVC startAnimate];
//    [_la removeFromSuperview];
//    _index1++;
//    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
//
//    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index1];
//    AnalyzeObject *anle = [AnalyzeObject new];
//    NSDictionary *dic = @{@"user_id":self.user_id,@"status":_zhuang,@"pindex":index};
//    
//    [anle myServeOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
//        [_table.header endRefreshing];
//        [_table.footer endRefreshing];
//        if (_index1==1) {
//            [_data1 removeAllObjects];
//        }
//        if ([code isEqualToString:@"0"]) {
//            [_data1 addObjectsFromArray:models];
//            
//        }
//        
//        if (_data1.count<=0) {
//            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
//            _la.text=@"暂无订单信息！";
//            _la.textAlignment=NSTextAlignmentCenter;
//            
//            [self.view addSubview:_la];
//        }
//
//        [_table reloadData];
//        
//    }];
//
//}
//-(void)rashD2{
//   //  [self.activityVC startAnimate];
//    [_la removeFromSuperview];
//    _index2++;
//    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
//
//    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index2];
//    AnalyzeObject *anle = [AnalyzeObject new];
//    NSDictionary *dic = @{@"user_id":self.user_id,@"status":_zhuang,@"pindex":index};
//    
//    [anle myServeOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
//        [_table.header endRefreshing];
//        [_table.footer endRefreshing];
//        if (_index2==1) {
//            [_data2 removeAllObjects];
//        }
//        if ([code isEqualToString:@"0"]) {
//            [_data2 addObjectsFromArray:models];
//        }
//        
//        
//        if (_data2.count<=0) {
//            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
//            _la.text=@"暂无订单信息！";
//            _la.textAlignment=NSTextAlignmentCenter;
//            
//            [self.view addSubview:_la];
//        }
//
//        [_table reloadData];
//
//        
//    }];
//
//}


-(void)foot{
//    if ([_zhuang isEqualToString:@"1"]) {
//        
//        [self rashD];
//    }else if([_zhuang isEqualToString:@"2"]){
//        
//        [self rashD1];
//    }else{
//        
//        [self rashD2];
//    }
    [self reshData];
}
-(void)head{
    _inde=0;
    [self reshData];
//    if ([_zhuang isEqualToString:@"1"]) {
//        _index=0;
//        [self rashD];
//    }else if([_zhuang isEqualToString:@"2"]){
//        _index1=0;
//        [self rashD1];
//    }else{
//        _index2=0;
//        [self rashD2];
//    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *ar = _data[indexPath.row][@"items"];
    
    NSString *str = [NSString new];
    for (int i=0; i<ar.count; i++) {
        NSDictionary *dic = ar[i];
        NSString *item = [dic objectForKey:@"item_name"];
        str = [str stringByAppendingString:item];
        if (ar.count-i==1) {
            break;
        }
        
        str = [str stringByAppendingString:@","];
    }
    

    
    UILabel *fuwu = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 0, self.view.width-20*self.scale, 0*self.scale)];
    fuwu.numberOfLines=0;
    fuwu.text=[NSString stringWithFormat:@"服务项目:%@",str];
    fuwu.font=SmallFont(self.scale);
    [fuwu sizeToFit];
    if (fuwu.height<20*self.scale) {
        fuwu.height=20*self.scale;
    }
    
    UILabel *beizhu = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 0, self.view.width-20*self.scale, 0*self.scale)];
    beizhu.numberOfLines=0;
    beizhu.text=_data[indexPath.row][@"memo"];
    beizhu.font=SmallFont(self.scale);
    [beizhu sizeToFit];
    if (beizhu.height<20*self.scale) {
        beizhu.height=20*self.scale;
    }
    
    UILabel *dizhi = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 0, self.view.width-20*self.scale, 0*self.scale)];
    dizhi.numberOfLines=0;
    dizhi.text=_data[indexPath.row][@"delivery_address"][@"address"];
    dizhi.font=SmallFont(self.scale);
    [dizhi sizeToFit];

    if (dizhi.height<20*self.scale) {
        dizhi.height=20*self.scale;
    }
    
    NSLog(@"%f  %f   %f",beizhu.height,+dizhi.height,fuwu.height);

    
    
    return 162.5*self.scale+beizhu.height+dizhi.height+fuwu.height;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _data.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_qu==1) {
        WeiPeiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.headImg setImageWithURL:[NSURL URLWithString:_data[indexPath.row][@"logo"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
        cell.nameLa.text=_data[indexPath.row][@"shop_name"];
        cell.jiantouImg.image=[UIImage imageNamed:@"xq_right"];
        [cell.talkImg setImage:[UIImage imageNamed:@"ganxi_ico_01"] forState:UIControlStateNormal];
        [cell.teleImg setImage:[UIImage imageNamed:@"ganxi_ico_02"] forState:UIControlStateNormal];
        
        
        [cell.teleImg setTitle:@"tel" forState:UIControlStateNormal];
        [cell.talkImg setTitle:@"talk" forState:UIControlStateNormal];
        
        cell.talkImg.tag=indexPath.row+5000000;
        cell.teleImg.tag=indexPath.row+8000000;
        [cell.talkImg addTarget:self action:@selector(talkAndTel:) forControlEvents:UIControlEventTouchUpInside];
        [cell.teleImg addTarget:self action:@selector(talkAndTel:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.states.text=@"未配送";
        
        
        NSArray *ar = _data[indexPath.row][@"items"];

        NSString *str = [NSString new];
        for (int i=0; i<ar.count; i++) {
            NSDictionary *dic = ar[i];
           NSString *item = [dic objectForKey:@"item_name"];
            str = [str stringByAppendingString:item];
            if (ar.count-i==1) {
                break;
            }
            
            str = [str stringByAppendingString:@","];
        }
        
        cell.fuwuXiangMu.text=[NSString stringWithFormat:@"服务项目:%@",str];
        cell.xiaDanShiJian.text=[NSString stringWithFormat:@"下单时间:%@",_data[indexPath.row][@"sub_create_time"]];
        cell.beizhu.text=[NSString stringWithFormat:@"备注:%@",_data[indexPath.row][@"memo"]];
        cell.yuyueshijian.text=[NSString stringWithFormat:@"预约时间:%@",_data[indexPath.row][@"send_time"]];
        cell.fuwudizhi.text=[NSString stringWithFormat:@"服务地址:%@",_data[indexPath.row][@"delivery_address"][@"address"]];
        [cell.quedingshouhuo addTarget:self action:@selector(quxiao:) forControlEvents:UIControlEventTouchUpInside];
        cell.quedingshouhuo.tag=indexPath.row;
        [cell.cellBtn addTarget:self action:@selector(orderXiang:) forControlEvents:UIControlEventTouchUpInside];
        cell.cellBtn.tag=30000+indexPath.row;
       
        
        
        return cell;
    }else if (_qu==2){
    
        YiPeiSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.headImg setImageWithURL:[NSURL URLWithString:_data[indexPath.row][@"logo"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
        cell.nameLa.text=_data[indexPath.row][@"shop_name"];
        cell.jiantouImg.image=[UIImage imageNamed:@"xq_right"];
        [cell.talkImg setImage:[UIImage imageNamed:@"ganxi_ico_01"] forState:UIControlStateNormal];
        [cell.teleImg setImage:[UIImage imageNamed:@"ganxi_ico_02"] forState:UIControlStateNormal];
        
        [cell.teleImg setTitle:@"tel" forState:UIControlStateNormal];
        [cell.talkImg setTitle:@"talk" forState:UIControlStateNormal];
        
        cell.talkImg.tag=indexPath.row+5000000;
        cell.teleImg.tag=indexPath.row+8000000;
        [cell.talkImg addTarget:self action:@selector(talkAndTel:) forControlEvents:UIControlEventTouchUpInside];
        [cell.teleImg addTarget:self action:@selector(talkAndTel:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.states.text=@"已配送";
        
        NSArray *ar = _data[indexPath.row][@"items"];
        NSString *str = [NSString new];
        for (int i=0; i<ar.count; i++) {
            NSDictionary *dic = ar[i];
            NSString *item = [dic objectForKey:@"item_name"];
            str = [str stringByAppendingString:item];
            if (ar.count-i==1) {
                break;
            }
            
            str = [str stringByAppendingString:@","];
        }
        
        cell.fuwuXiangMu.text=[NSString stringWithFormat:@"服务项目:%@",str];
        cell.xiaDanShiJian.text=[NSString stringWithFormat:@"下单时间:%@",_data[indexPath.row][@"sub_create_time"]];
        cell.beizhu.text=[NSString stringWithFormat:@"备注:%@",_data[indexPath.row][@"memo"]];
        cell.yuyueshijian.text=[NSString stringWithFormat:@"预约时间:%@",_data[indexPath.row][@"send_time"]];
        cell.fuwudizhi.text=[NSString stringWithFormat:@"服务地址:%@",_data[indexPath.row][@"delivery_address"][@"address"]];
        [cell.quedingshouhuo addTarget:self action:@selector(qurenshouhuo:) forControlEvents:UIControlEventTouchUpInside];
        cell.quedingshouhuo.tag=indexPath.row+1000;
        cell.cellBtn.tag=40000+indexPath.row;
        [cell.cellBtn addTarget:self action:@selector(oder2:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }else{
    
        
        DaiPingJiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.headImg setImageWithURL:[NSURL URLWithString:_data[indexPath.row][@"logo"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
        cell.nameLa.text=_data[indexPath.row][@"shop_name"];
        cell.jiantouImg.image=[UIImage imageNamed:@"xq_right"];
        [cell.talkImg setImage:[UIImage imageNamed:@"ganxi_ico_01"] forState:UIControlStateNormal];
        [cell.teleImg setImage:[UIImage imageNamed:@"ganxi_ico_02"] forState:UIControlStateNormal];
        [cell.teleImg setTitle:@"tel" forState:UIControlStateNormal];
        [cell.talkImg setTitle:@"talk" forState:UIControlStateNormal];
        
        cell.talkImg.tag=indexPath.row+5000000;
        cell.teleImg.tag=indexPath.row+8000000;
        [cell.talkImg addTarget:self action:@selector(talkAndTel:) forControlEvents:UIControlEventTouchUpInside];
        [cell.teleImg addTarget:self action:@selector(talkAndTel:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.states.text=@"待评价";
        
        NSArray *ar = _data[indexPath.row][@"items"];
        NSString *str = [NSString new];
        for (int i=0; i<ar.count; i++) {
            NSDictionary *dic = ar[i];
            NSString *item = [dic objectForKey:@"item_name"];
            str = [str stringByAppendingString:item];
            if (ar.count-i==1) {
                break;
            }
            
            str = [str stringByAppendingString:@","];
        }
        
        cell.fuwuXiangMu.text=[NSString stringWithFormat:@"服务项目:%@",str];
        cell.xiaDanShiJian.text=[NSString stringWithFormat:@"下单时间:%@",_data[indexPath.row][@"sub_create_time"]];
        cell.beizhu.text=[NSString stringWithFormat:@"备注:%@",_data[indexPath.row][@"memo"]];
        cell.yuyueshijian.text=[NSString stringWithFormat:@"预约时间:%@",_data[indexPath.row][@"send_time"]];
        cell.fuwudizhi.text=[NSString stringWithFormat:@"服务地址:%@",_data[indexPath.row][@"delivery_address"][@"address"]];
        
        [cell.qupingjia addTarget:self action:@selector(qupingjiaEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shanchu addTarget:self action:@selector(qupingjiaEvent:) forControlEvents:UIControlEventTouchUpInside];
        cell.qupingjia.tag=indexPath.row+10000;
        cell.shanchu.tag=indexPath.row+20000;
        cell.cellBtn.tag=50000+indexPath.row;
        [cell.cellBtn addTarget:self action:@selector(oder3:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    
    }
    
  

}
-(void)talkAndTel:(UIButton *)sender{
    
    self.hidesBottomBarWhenPushed=YES;
    
    
    if ([sender.titleLabel.text isEqualToString:@"talk"]) {
        //聊天
        //改电话
//        if ([_data[sender.tag-5000000][@"is_open_chat"]isEqualToString:@"2"]) {
//            [self ShowAlertWithMessage:@"该商家暂未开通聊天功能！"];
//            return;
//        }
//        
//        
//        RCDChatViewController *chatService = [RCDChatViewController new];
////        chatService.userName = _data[sender.tag-5000000][@"shop_name"];
//        chatService.targetId = _data[sender.tag-5000000][@"shop_user_id"];
//        chatService.conversationType = ConversationType_PRIVATE;
//        chatService.title = _data[sender.tag-5000000][@"shop_name"];
//        [self.navigationController pushViewController: chatService animated:YES];
        
        
        
    }else{
        //电话
        
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%@",_data[sender.tag-8000000][@"shop_id"]] forKey:@"shop_id"];
        [dic setObject:[NSString stringWithFormat:@"%@",_data[sender.tag-8000000][@"hotline"]] forKey:@"tel"];
        if ([Stockpile sharedStockpile].isLogin) {
            [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
        }
        
        [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
            }
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_data[sender.tag-8000000][@"hotline"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }];
        
        
        
        
                //        [[[UIAlertView alloc]initWithTitle:@"在线联系卖家电话" message:_data1[sender.tag-2000000][@"order_detail"][0][@"hotline"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil]show ] ;
        
        
    }
    
    
}
-(void)oder3:(UIButton *)btn{
    
    self.hidesBottomBarWhenPushed=YES;
    FuWuXiangQingViewController *fuwu = [FuWuXiangQingViewController new];
    fuwu.orderid = _data[btn.tag-50000][@"order_no"];
    fuwu.smallOder=_data[btn.tag-50000][@"sub_order_no"];
    [self.navigationController pushViewController:fuwu animated:YES];
    
}

-(void)oder2:(UIButton *)btn{

    self.hidesBottomBarWhenPushed=YES;
    FuWuXiangQingViewController *fuwu = [FuWuXiangQingViewController new];
    fuwu.orderid = _data[btn.tag-40000][@"order_no"];
    fuwu.smallOder=_data[btn.tag-40000][@"sub_order_no"];
    [self.navigationController pushViewController:fuwu animated:YES];

}

-(void)orderXiang:(UIButton *)btn{

    
    self.hidesBottomBarWhenPushed=YES;
    FuWuXiangQingViewController *fuwu = [FuWuXiangQingViewController new];
    fuwu.orderid = _data[btn.tag-30000][@"order_no"];
    fuwu.smallOder=_data[btn.tag-30000][@"sub_order_no"];
    [self.navigationController pushViewController:fuwu animated:YES];
}


-(void)quxiao:(UIButton *)btn{
    
    [self ShowAlertTitle:nil Message:@"确认取消？" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            AnalyzeObject *anle = [AnalyzeObject new];
            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            
            NSDictionary *dic = @{@"user_id":userid,@"order_no":_data[btn.tag][@"order_no"]};
            
            [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                if ([code isEqualToString:@"0"]) {
                    [self ShowAlertWithMessage:msg];
                    _qu=1;
                    _zhuang=@"1";
                    _inde=0;
                    [self reshData];
                }
                [self.activityVC stopAnimate];
            }];
            

        }
    }];
    
    
    

}

-(void)qurenshouhuo:(UIButton *)btn{

    [self ShowAlertTitle:nil Message:@"确认收货？" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            AnalyzeObject *anle = [AnalyzeObject new];
            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":_data[btn.tag-1000][@"sub_order_no"]};
            
            [anle finishOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                if ([code isEqualToString:@"0"]) {
                    _inde=0;
                    [self reshData];
                }
                [self.activityVC stopAnimate];
            }];
        }
    }];
    
   
        
    

}

-(void)qupingjiaEvent:(UIButton *)sender{
    
    

    self.hidesBottomBarWhenPushed=YES;
    
    if (![sender.titleLabel.text isEqualToString:@"去评价"]) {
        AnalyzeObject *anle = [AnalyzeObject new];
        
        NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
        
        NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":_data[sender.tag-20000][@"sub_order_no"]};
        
        [self ShowAlertTitle:nil Message:@"确认删除?" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                [anle delOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                    if ([code isEqualToString:@"0"]) {
                        _qu=3;
                        _zhuang=@"3";
                        _inde=0;
                        [self reshData];
                    }
                }];

            }
        }];
        
        
        
        
    }else{

        XiePingJiaViewController *xie =[XiePingJiaViewController new];
        xie.is_order_on=YES;
        xie.order_on = _data[sender.tag-10000][@"sub_order_no"];
        xie.shopid = _data[sender.tag-10000][@"shop_id"];
        xie.lingshou=YES;
        [self.navigationController pushViewController:xie animated:YES];
        
        [xie reshBlock:^(NSMutableArray *arr) {
            
            
                _qu=3;
                _zhuang=@"3";
                _inde=0;
                [self reshData];
            
            
     
            
//
//            _qu=3;
//            _zhuang=@"3";
//            _inde=0;
//            [self reshData];
//            [_table reloadData];
//

            
        }];
    }

}

#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"服务类订单";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"所有订单" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = BigFont(self.scale);
    [rightBtn setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    rightBtn.frame = CGRectMake(self.view.right-80*self.scale,self.TitleLabel.top,80*self.scale,self.TitleLabel.height);
//    [rightBtn setTitleColor:grayTextColor forState:(UIControlStateNormal)];
    [rightBtn addTarget:self action:@selector(allOder) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:rightBtn];

    
}
-(void)allOder{
    self.hidesBottomBarWhenPushed=YES;
    AlloderSViewController *all = [AlloderSViewController new];
    [self.navigationController pushViewController:all animated:YES];

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
