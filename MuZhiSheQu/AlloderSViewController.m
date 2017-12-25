//
//  AlloderSViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/6.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AlloderSViewController.h"
#import "WeiPeiTableViewCell.h"
#import "XiePingJiaViewController.h"
#import "YiPeiSongTableViewCell.h"
#import "DaiPingJiaTableViewCell.h"
#import "UmengCollection.h"
@interface AlloderSViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)UILabel *la;
@end

@implementation AlloderSViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController .navigationBarHidden=YES;
     [UmengCollection intoPage:NSStringFromClass([self class])];
    [self reshData];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
    _index=0;
    _data = [NSMutableArray new];
    [self tablevi];
}
-(void)reshData{
    [_la removeFromSuperview];
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    _index++;
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    AnalyzeObject *anle = [AnalyzeObject new];
      NSDictionary *dic = @{@"user_id":self.user_id,@"status":@"4",@"pindex":index};
    [anle myServeOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if (_index==1) {
            [_data removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {
            [_data addObjectsFromArray:models];
        }
        [_table reloadData];
        [self.activityVC stopAnimate];
        [_table.header endRefreshing];
        [_table.footer endRefreshing];
        if (_data.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
            _la.text=@"暂无订单信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            
            [self.view addSubview:_la];
        }
    }];
}

-(void)tablevi{
    _table  = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom) style:UITableViewStylePlain];
    _table.delegate=self;
    _table.dataSource=self;
    _table.backgroundColor=superBackgroundColor;
    [_table registerClass:[WeiPeiTableViewCell class] forCellReuseIdentifier:@"cell1"];
    [_table registerClass:[YiPeiSongTableViewCell class] forCellReuseIdentifier:@"cell2"];
    [_table registerClass:[DaiPingJiaTableViewCell class] forCellReuseIdentifier:@"cell3"];
    [_table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(shangla)];
    [_table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
}

-(void)shangla{
    [self reshData];
}

-(void)xiala{
    _index=0;
    [self reshData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
//    if ([_data[indexPath.row][@"status"] isEqualToString:@"6"]) {
////        [_la removeFromSuperview];
////        _la = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
////        _la.text=@"暂无订单信息！";
////        _la.textAlignment=NSTextAlignmentCenter;
////        
////        [self.view addSubview:_la];
//
//        return 0;
//    }
    
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
    if (_data.count<=0) {
        return nil;
    }
    
    NSString *status = _data[indexPath.row][@"status"];
    if ([status isEqualToString:@"2"] || [status isEqualToString:@"3"]) {
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
        cell.quedingshouhuo.tag=indexPath.row;
        [cell.quedingshouhuo addTarget:self action:@selector(quxiao:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cellBtn addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
        cell.cellBtn.tag=indexPath.row+100000;
        
        
        return cell;

    }else if ([status isEqualToString:@"4"]){
    
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
        cell.quedingshouhuo.tag=1000+indexPath.row;
        [cell.quedingshouhuo addTarget:self action:@selector(quedingshouhuo:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cellBtn addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
        cell.cellBtn.tag=indexPath.row+100000;
        
        return cell;

    
    
    
    }else if([status isEqualToString:@"5"]){
    
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
        
        if ([_data[indexPath.row][@"is_comment"] isEqualToString:@"1"]) {
            
             cell.states.text=@"待评价";
            
            
        }else{
         cell.states.text=@"已完成";
        }
        
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
        cell.qupingjia.tag=10000+indexPath.row;
        cell.shanchu.tag=20000+indexPath.row;
        [cell.cellBtn addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
        cell.cellBtn.tag=indexPath.row+100000;
        
        if ([cell.states.text isEqualToString:@"已完成"]) {
            cell.qupingjia.hidden=YES;
            
        }
        return cell;

    
    }else if([status isEqualToString:@"6"]){
    
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
        
        
            cell.states.text=@"已取消";
 
        
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
        
        
        
       // [cell.qupingjia addTarget:self action:@selector(qupingjiaEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shanchu addTarget:self action:@selector(yiquxiaoshan:) forControlEvents:UIControlEventTouchUpInside];
       // cell.qupingjia.tag=10000+indexPath.row;
        cell.shanchu.tag=40000+indexPath.row;
        [cell.cellBtn addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
        cell.cellBtn.tag=indexPath.row+100000;
        
        if ([cell.states.text isEqualToString:@"已取消"]) {
            cell.qupingjia.hidden=YES;
            
        }
        return cell;

    }
    
    return nil;
    

}
-(void)talkAndTel:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
    if ([sender.titleLabel.text isEqualToString:@"talk"]) {
        //聊天
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



-(void)order:(UIButton *)btn{

    self.hidesBottomBarWhenPushed=YES;
    FuWuXiangQingViewController *fuwu = [FuWuXiangQingViewController new];
    fuwu.orderid = _data[btn.tag-100000][@"order_no"];
    fuwu.smallOder=_data[btn.tag-100000][@"sub_order_no"];
    [self.navigationController pushViewController:fuwu animated:YES];


}

-(void)quxiao:(UIButton *)btn{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    
    NSDictionary *dic = @{@"user_id":userid,@"order_no":_data[btn.tag][@"order_no"]};
    
    [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            [self ShowAlertWithMessage:msg];
            _index=0;
            [self reshData];
        }
        [self.activityVC stopAnimate];
    }];
    
    
    
}

-(void)quedingshouhuo:(UIButton *)btn{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":_data[btn.tag-1000][@"sub_order_no"]};
    
    [anle finishOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            _index=0;
            [self reshData];
        }
        [self.activityVC stopAnimate];
    }];
    
    


}


-(void)yiquxiaoshan:(UIButton *)btn{

    AnalyzeObject *anle = [AnalyzeObject new];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    
    NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":_data[btn.tag-40000][@"sub_order_no"]};
    
    [anle delOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if ([code isEqualToString:@"0"]) {
            _index=0;
            [self reshData];
        }
    }];

}

-(void)qupingjiaEvent:(UIButton *)sender{
    
    
    if (![sender.titleLabel.text isEqualToString:@"去评价"]) {
        
        
        AnalyzeObject *anle = [AnalyzeObject new];
        
        NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
        
        NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":_data[sender.tag-20000][@"sub_order_no"]};
        
        [anle delOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"0"]) {
                _index=0;
                [self reshData];
            }
        }];
    }else{
    
    
    self.hidesBottomBarWhenPushed=YES;
    
    XiePingJiaViewController *xie =[XiePingJiaViewController new];
    xie.is_order_on=YES;
    xie.order_on = _data[sender.tag-10000][@"sub_order_no"];
    xie.shopid = _data[sender.tag-10000][@"shop_id"];
        [xie reshBlock:^(NSMutableArray *arr) {
            [self reshData];
            
        }];
        
    [self.navigationController pushViewController:xie animated:YES];
    }
    
}

#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"所有订单";
    
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
