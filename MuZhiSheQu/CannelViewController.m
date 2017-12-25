//
//  CannelViewController.m
//  MuZhiSheQu
//
//  Created by lt on 2017/7/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CannelViewController.h"
#import "CellView.h"
#import "UmengCollection.h"
#import "OrderFileViewController.h"
@interface CannelViewController ()
{
    NSMutableArray *biggg;
}
@property(nonatomic,strong)NSMutableArray *priceArr;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)UILabel *la;

@end

@implementation CannelViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden=YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    [self reshData];
    [UmengCollection intoPage:NSStringFromClass([self class])];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengCollection outPage:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _index=0;
    _data = [NSMutableArray new];
    
    [self centerDaiFuKuanOderVi];
    [self returnVi];
}

-(void)reshData{
    [_la removeFromSuperview];
    [self.view addSubview:self.activityVC];
    _index ++;
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    NSDictionary *dic = @{@"user_id":self.user_id,@"status":@"6",@"pindex":index};
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        CGPoint point = _bigScrollView.contentOffset;
        point.y=point.y-5*self.scale;
        if (_index==1) {
            [_data removeAllObjects];
        }
        if ([code isEqualToString:@"0"]) {
            [_data addObjectsFromArray:models];
        }
        [self centerDaiFuKuanOderVi];
        [_bigScrollView setContentOffset:point animated:NO];
        [self.activityVC stopAnimate];
        [_bigScrollView.header endRefreshing];
        [_bigScrollView.footer endRefreshing];
        
        
        if (_data.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
            _la.text=@"暂无订单信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            
            [self.view addSubview:_la];
        }
    }];
}

-(void)sc0h{
    [_la removeFromSuperview];
    
    _index=0;
    [self.view addSubview:self.activityVC];
    if (_index==0) {
        [_data removeAllObjects];
    }
    _index ++;
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    self.user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    
    NSString *index = [NSString stringWithFormat:@"%ld",(long)_index];
    NSDictionary *dic = @{@"user_id":self.user_id,@"status":@"5",@"pindex":index};
    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        
        if ([code isEqualToString:@"0"]) {
            [_data addObjectsFromArray:models];
            
        }
        //        [self centerDaiFuKuanOderVi];
        
        [self.activityVC stopAnimate];
        [_bigScrollView.header endRefreshing];
        [_bigScrollView.footer endRefreshing];
        
        
        if (_data.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, _bigBtnVi.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
            _la.text=@"暂无订单信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            
            [self.view addSubview:_la];
        }
    }];
}

-(void)sc0f{
    
    [self reshData];
}

-(void)talkBtnEvent:(UIButton *)sender{
    
    self.hidesBottomBarWhenPushed=YES;
    
    
    if ([sender.titleLabel.text isEqualToString:@"talk"]) {
        //聊天
        //        RCDChatViewController *chatService = [RCDChatViewController new];
        ////        chatService.userName = _data[sender.tag-5000000][@"order_detail"][0][@"shop_name"];
        //        chatService.targetId = _data[sender.tag-5000000][@"order_detail"][0][@"shop_user_id"];
        //        chatService.conversationType = ConversationType_PRIVATE;
        //        chatService.title = _data[sender.tag-5000000][@"order_detail"][0][@"shop_name"];
        //        [self.navigationController pushViewController: chatService animated:YES];
        
        
        
    }else{
        //电话
        
        [self.view addSubview:self.activityVC];
        [self.activityVC startAnimate];
        AnalyzeObject *anle = [AnalyzeObject new];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%@",_data[sender.tag-6000000][@"order_detail"][0][@"shop_id"]] forKey:@"shop_id"];
        [dic setObject:[NSString stringWithFormat:@"%@",_data[sender.tag-6000000][@"order_detail"][0][@"hotline"]] forKey:@"tel"];
        if ([Stockpile sharedStockpile].isLogin) {
            [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
        }
        
        [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimate];
            if ([code isEqualToString:@"0"]) {
            }
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_data[sender.tag-6000000][@"order_detail"][0][@"hotline"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }];
        
        
        
        
        
        
        
        //        [[[UIAlertView alloc]initWithTitle:@"在线联系卖家电话" message:_data1[sender.tag-2000000][@"order_detail"][0][@"hotline"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil]show ] ;
        
        
    }
    
    
}





#pragma mark---待付款
-(void)centerDaiFuKuanOderVi{
    //[self.activityVC stopAnimate];
    if (_big) {
        [_big removeFromSuperview];
    }
    _priceArr = [NSMutableArray new];
    
    
    _big = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-_bigBtnVi.bottom)];
    [self.view addSubview:_big];
    
    _bigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _big.width, self.view.height-self.NavImg.bottom)];
    [_bigScrollView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(sc0f)];
    [_bigScrollView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(sc0h)];
    _bigScrollView.backgroundColor=[UIColor clearColor];
    [_big addSubview:_bigScrollView];
    
    //    NSMutableArray * mutabArr = [NSMutableArray new];;
    //    for (NSDictionary *dic in _data[i][@"order_detail"]) {
    //
    //        for (NSDictionary *prodic in dic[@"prods"]) {
    //
    //            [mutabArr addObject:prodic];
    //
    //        }
    //    }
    float setY = 10*self.scale;
    float nameCellY=0;
    biggg = [NSMutableArray new];
    for (NSDictionary *dic in _data) {
        if ([dic[@"order_detail"][0][@"status"] isEqualToString:@"1"]) {
            [biggg addObject:dic[@"order_detail"]];
        }else{
            for (NSDictionary *orderDic in dic[@"order_detail"]) {
                [biggg addObject:orderDic];
            }
        }
    }
    for (int i=0; i<biggg.count; i++) {
        UIView *bigvi = [[UIView alloc]initWithFrame:CGRectMake(0,setY , self.view.width, 0)];
        [_bigScrollView addSubview:bigvi];
        //未付款
        if ([biggg[i] isKindOfClass:[NSArray class]]) {
            //            UIView *tline = [[UIView alloc]initWithFrame:CGRectMake(0, 10*self.scale, self.view.width, .5)];
            //            tline.backgroundColor=superBackgroundColor;
            //            [_bigScrollView addSubview:tline];
            //------
            CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
            nameCell.topline.hidden=NO;
            [bigvi addSubview:nameCell];
            UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, nameCell.height/2-10*self.scale, self.view.width, nameCell.height-20*self.scale)];
            nameLa.text =[NSString stringWithFormat:@"订单号：%@",biggg[i][0][@"order_no"]];
            nameLa.font = DefaultFont(self.scale);
            [nameCell addSubview:nameLa];
            UILabel *states = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameCell.height/2-10*self.scale, 70*self.scale, 20*self.scale)];
            if ([biggg[i][0][@"status"] isEqualToString:@"1"]) {
                states.text = @"待付款";
            }else if ([biggg[i][0][@"status"] isEqualToString:@"2"] || [biggg[i][0][@"status"] isEqualToString:@"3"]){
                states.text = @"待发货";
            }else if ([biggg[i][0][@"status"] isEqualToString:@"4"]){
                states.text = @"待收货";
            }else if([biggg[i][0][@"status"] isEqualToString:@"5"]){
                if ([biggg[i][0][@"is_comment"] isEqualToString:@""] || [biggg[i][0][@"is_comment"] isEqualToString:@"1"]){
                    states.text = @"待评价";
                }else{
                    states.text = @"已完成";
                }
            }else{
                states.text = @"已取消";
            }
            states.textAlignment = NSTextAlignmentRight;
            states.textColor = [UIColor redColor];
            states.font = SmallFont(self.scale);
            [nameCell addSubview:states];
            nameCellY=nameCell.bottom;
        }else{
            //            UIView *tline = [[UIView alloc]initWithFrame:CGRectMake(0, 0*self.scale, self.view.width, .5)];
            //            tline.backgroundColor=superBackgroundColor;
            //            [_bigScrollView addSubview:tline];
            CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
            nameCell.topline.hidden=NO;
            nameCell.topline.backgroundColor=blackLineColore;
            [bigvi addSubview:nameCell];
            UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 30*self.scale, 23*self.scale)];
            [headImg setImageWithURL:[NSURL URLWithString:biggg[i][@"logo"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
            [nameCell addSubview:headImg];
            nameCell.height=headImg.bottom+10*self.scale;
            UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right+5*self.scale, nameCell.height/2-10*self.scale, 30, nameCell.height-20*self.scale)];
            nameLa.text =biggg[i][@"shop_name"];
            nameLa.font = SmallFont(self.scale);
            [nameCell addSubview:nameLa];
            CGSize size = [self sizetoFitWithString:nameLa.text];
            nameLa.width = size.width;
            //            UIButton *talkImg = [[UIButton alloc]initWithFrame:CGRectMake(nameLa.right, nameCell.height/2-10*self.scale, 20*self.scale, 20*self.scale)];
            //            [talkImg setBackgroundImage:[UIImage imageNamed:@"ganxi_ico_01"] forState:UIControlStateNormal];
            //            [talkImg addTarget:self action:@selector(talkBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            //     0       [talkImg setTitle:@"talk" forState:UIControlStateNormal];
            //            [talkImg setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            //            talkImg.tag=i+5000000;
            //            [nameCell addSubview:talkImg];
            UIButton *teleImg = [[UIButton alloc]initWithFrame:CGRectMake(nameLa.right, nameCell.height/2-10*self.scale, 20*self.scale, 20*self.scale)];
            [teleImg setBackgroundImage:[UIImage imageNamed:@"ganxi_ico_02"] forState:UIControlStateNormal];
            [teleImg addTarget:self action:@selector(talkBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            teleImg.tag=i+6000000;
            [nameCell addSubview:teleImg];
            UIImageView *jiantouImg = [[UIImageView alloc]initWithFrame:CGRectMake(teleImg.right+10*self.scale, nameCell.height/2-12.5*self.scale, teleImg.width+5*self.scale, teleImg.height+5*self.scale)];
            jiantouImg.image = [UIImage imageNamed:@"xq_right"];
            [nameCell addSubview:jiantouImg];
            UILabel *states = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameCell.height/2-10*self.scale, 70*self.scale, 20*self.scale)];
            if ([biggg[i][@"status"] isEqualToString:@"1"]) {
                states.text = @"待付款";
            }else if ([biggg[i][@"status"] isEqualToString:@"2"] || [biggg[i][@"status"] isEqualToString:@"3"]){
                states.text = @"待发货";
            }else if ([biggg[i][@"status"] isEqualToString:@"4"]){
                states.text = @"待收货";
            }else if([biggg[i][@"status"] isEqualToString:@"5"]){
                if ([biggg[i][@"is_comment"] isEqualToString:@""] || [biggg[i][@"is_comment"] isEqualToString:@"1"]){
                    states.text = @"待评价";
                }else{
                    states.text = @"已完成";
                }
            }else{
                states.text = @"已取消";
            }
            states.textAlignment = NSTextAlignmentRight;
            states.textColor = [UIColor redColor];
            states.font = SmallFont(self.scale);
            [nameCell addSubview:states];
            nameCellY=nameCell.bottom;
        }
        ////---
        NSMutableArray * dataArr = [NSMutableArray new];
        if ([biggg[i] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *smDic in biggg[i]) {
                [dataArr addObjectsFromArray:smDic[@"prods"]];
            }
        }else{
            [dataArr addObjectsFromArray:biggg[i][@"prods"]];
        }
        float line1BotFloat = nameCellY;
        _sum=0;
        _ji=0.0;
        for (int j=0; j<dataArr.count; j++) {
            CellView *contextCell = [[CellView alloc]initWithFrame:CGRectMake(0, line1BotFloat, self.view.width, 175/2.25*self.scale)];
            [bigvi addSubview:contextCell];
            UIImageView *cellHeadImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 65*self.scale, 49*self.scale)];
            cellHeadImg.contentMode=UIViewContentModeScaleAspectFill;
            cellHeadImg.clipsToBounds=YES;
            NSString *url=@"";
            NSString *cut = dataArr[j][@"img1"];
            NSString *imagename = [cut lastPathComponent];
            NSString *path = [cut stringByDeletingLastPathComponent];
            NSString *smallImgUrl=[NSString stringWithFormat:@"%@/%@",path,[imagename stringByReplacingOccurrencesOfString:@"." withString:@"_thumb320."]];
            //            if (cut.length>0) {
            //                url = [cut substringToIndex:[cut length] - 4];
            //            }
            //            [cellHeadImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb640.jpg",url]] placeholderImage:[UIImage imageNamed:@"za"]];
            [cellHeadImg setImageWithURL:[NSURL URLWithString:smallImgUrl] placeholderImage:[UIImage imageNamed:@"za"]];
            [contextCell addSubview:cellHeadImg];
            UILabel *nameLa = [[UILabel alloc]initWithFrame:CGRectMake(cellHeadImg.right+10*self.scale, cellHeadImg.top, 200*self.scale, 20*self.scale)];
            nameLa.text = dataArr[j][@"prod_name"];
            nameLa.textAlignment = NSTextAlignmentLeft;
            nameLa.font = DefaultFont(self.scale);
            [contextCell addSubview:nameLa];
            UILabel *contextLa = [[UILabel alloc]initWithFrame:CGRectMake(nameLa.left, nameLa.bottom+5*self.scale, 170*self.scale, 35*self.scale)];
            contextLa.numberOfLines=0;
            contextLa.text = [NSString stringWithFormat:@"销量%@",dataArr[j][@"sales"]];
            contextLa.textColor = grayTextColor;
            contextLa.font = SmallFont(self.scale);
            //[contextCell addSubview:contextLa];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize size = [contextLa.text boundingRectWithSize:CGSizeMake(contextLa.width, 35*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            contextLa.height = size.height;
            UILabel *priceLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-80*self.scale, nameLa.bottom-10*self.scale, 70*self.scale, 15*self.scale)];
            priceLa.textColor = grayTextColor;
            priceLa.font = SmallFont(self.scale);
            priceLa.textAlignment = NSTextAlignmentRight;
            priceLa.text = [NSString stringWithFormat:@"￥%@",dataArr[j][@"price"]];
            [contextCell addSubview:priceLa];
            UILabel *numberLa = [[UILabel alloc]initWithFrame:CGRectMake(priceLa.left, priceLa.bottom+10*self.scale, priceLa.width, priceLa.height)];
            numberLa.text = [NSString stringWithFormat:@"x%@",dataArr[j][@"prod_count"]];
            numberLa.textAlignment = NSTextAlignmentRight;
            numberLa.textColor = grayTextColor;
            numberLa.font = SmallFont(self.scale);
            [contextCell addSubview:numberLa];
            line1BotFloat = contextCell.bottom;
            UIButton *oderStatesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            oderStatesBtn.frame = CGRectMake(0, 0, contextCell.width, contextCell.height);
            [oderStatesBtn addTarget:self action:@selector(oderStBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            oderStatesBtn.tag=1000000+i;
            [contextCell addSubview:oderStatesBtn];
            //            有问题
            id start = biggg[i];
            int num = [dataArr[j][@"prod_count"] intValue];
            _sum=_sum+num;
            //                float pri = [dataArr[j][@"price"] floatValue];
            //
            //                _ji = _ji+num*pri;
            if ([start isKindOfClass:[NSArray class]]) {
                //                _ji = [dataArr[0][@"total_amount"] floatValue];
                //                _ji = _ji+num*pri;
                if ([biggg[i][0][@"status"] isEqualToString:@"1"]) {
                    _ji = [start[0][@"total_amount"] floatValue];
                }else{
                    _ji = [start[0][@"sub_amount"] floatValue];
                }
            }else{
                if ([biggg[i][@"status"] isEqualToString:@"1"]) {
                    _ji = [start[@"total_amount"] floatValue];
                }else{
                    _ji = [start[@"sub_amount"] floatValue];// + [start[@"delivery_fee"] floatValue]
                }
            }
        }
        [_priceArr addObject:[NSString stringWithFormat:@"%.2f",_ji]];
        id start = biggg[i];
        NSString *starts = [[NSString alloc]init];
        if ([start isKindOfClass:[NSArray class]]) {
            starts = start[0][@"status"];
        }else{
            starts = start[@"status"];
        }
        if ([starts isEqualToString:@"1"]) {
            CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
            [bigvi addSubview:zongJiCell];
            UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, 0, 20*self.scale)];
            shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];
            shopNumberLa.font = DefaultFont(self.scale);
            [zongJiCell addSubview:shopNumberLa];
            //-
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize size1 = [shopNumberLa.text boundingRectWithSize:CGSizeMake(shopNumberLa.width, 20*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            shopNumberLa.width = size1.width;
            UIButton *fuKuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            fuKuanBtn.frame = CGRectMake(self.view.width-120*self.scale, zongJiCell.height/2-12.5*self.scale, 50*self.scale, 25*self.scale);
            fuKuanBtn.layer.borderWidth = .5;
            fuKuanBtn.layer.borderColor = blackLineColore.CGColor;
            [fuKuanBtn setTitle:@"付款" forState:UIControlStateNormal];
            [fuKuanBtn addTarget:self action:@selector(fuAndQUxiAO:) forControlEvents:UIControlEventTouchUpInside];
            fuKuanBtn.titleLabel.font = SmallFont(self.scale);
            [fuKuanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            fuKuanBtn.layer.cornerRadius = 4.0f;
            fuKuanBtn.tag=20000+i;
            [zongJiCell addSubview:fuKuanBtn];
            UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            quiXaioBtn.frame = CGRectMake(self.view.width-60*self.scale, zongJiCell.height/2-12.5*self.scale, 50*self.scale, 25*self.scale);
            quiXaioBtn.layer.borderWidth = .5;
            quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
            [quiXaioBtn setTitle:@"取消" forState:UIControlStateNormal];
            [quiXaioBtn addTarget:self action:@selector(fuAndQUxiAO:) forControlEvents:UIControlEventTouchUpInside];
            quiXaioBtn.titleLabel.font = SmallFont(self.scale);
            [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            quiXaioBtn.backgroundColor = blackLineColore;
            quiXaioBtn.layer.cornerRadius = 4.0f;
            quiXaioBtn.tag=10000+i;
            [zongJiCell addSubview:quiXaioBtn];
            zongJiCell.height=quiXaioBtn.bottom+10*self.scale;
            bigvi.size = CGSizeMake(self.view.width, zongJiCell.bottom);
            setY = bigvi.bottom +10*self.scale;
            _bigScrollView.contentSize = CGSizeMake(self.view.width,setY);
        }else if ([starts isEqualToString:@"2"] || [starts isEqualToString:@"3"]){
            CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
            [bigvi addSubview:zongJiCell];
            UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, self.view.width-70*self.scale, 20*self.scale)];
            shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];
            shopNumberLa.font = DefaultFont(self.scale);
            shopNumberLa.textAlignment = NSTextAlignmentLeft;
            [zongJiCell addSubview:shopNumberLa];
            if ([biggg[i][@"pay_type"]isEqualToString:@"3"]) {
                UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                quiXaioBtn.frame = CGRectMake(self.view.width-70*self.scale, zongJiCell.height/2-12.5*self.scale, 60*self.scale, 25*self.scale);
                quiXaioBtn.layer.borderWidth = .5;
                quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
                [quiXaioBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [quiXaioBtn addTarget:self action:@selector(huodaoQuXiao:) forControlEvents:UIControlEventTouchUpInside];
                quiXaioBtn.titleLabel.font = SmallFont(self.scale);
                [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                quiXaioBtn.backgroundColor = blackLineColore;
                quiXaioBtn.layer.cornerRadius = 4.0f;
                quiXaioBtn.tag=5000+i;
                [zongJiCell addSubview:quiXaioBtn];
            }
            bigvi.size = CGSizeMake(self.view.width, zongJiCell.bottom);
            setY = bigvi.bottom +10*self.scale;
            _bigScrollView.contentSize = CGSizeMake(self.view.width,setY);
        }else if ([starts isEqualToString:@"4"]){
            CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
            [bigvi addSubview:zongJiCell];
            UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, 0, 20*self.scale)];
            shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];
            shopNumberLa.font = DefaultFont(self.scale);
            [zongJiCell addSubview:shopNumberLa];
            //-
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0f], NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize size1 = [shopNumberLa.text boundingRectWithSize:CGSizeMake(300, 20*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            shopNumberLa.width = size1.width;
            UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            quiXaioBtn.frame = CGRectMake(self.view.width-70*self.scale, zongJiCell.height/2-12.5*self.scale, 60*self.scale, 25*self.scale);
            quiXaioBtn.layer.borderWidth = .5;
            quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
            [quiXaioBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [quiXaioBtn addTarget:self action:@selector(querenshouhuo:) forControlEvents:UIControlEventTouchUpInside];
            quiXaioBtn.titleLabel.font = SmallFont(self.scale);
            [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            quiXaioBtn.backgroundColor = blackLineColore;
            quiXaioBtn.layer.cornerRadius = 4.0f;
            quiXaioBtn.tag=100000+i;
            [zongJiCell addSubview:quiXaioBtn];
            bigvi.size = CGSizeMake(self.view.width, zongJiCell.bottom);
            setY = bigvi.bottom +10*self.scale;
            _bigScrollView.contentSize = CGSizeMake(self.view.width,setY);
        }else if([starts isEqualToString:@"5"]){
            CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
            [bigvi addSubview:zongJiCell];
            
            UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, 0, 20*self.scale)];
            shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];
            shopNumberLa.font = DefaultFont(self.scale);
            [zongJiCell addSubview:shopNumberLa];
            //-
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0f], NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize size1 = [shopNumberLa.text boundingRectWithSize:CGSizeMake(300, 20*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            shopNumberLa.width = size1.width;
            
            //       float setYY =self.view.width-70*self.scale;
            
            if ([biggg[i][@"is_comment"] isEqualToString:@""] || [biggg[i][@"is_comment"] isEqualToString:@"1"]) {
                
                UIButton *quiXaioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                quiXaioBtn.frame = CGRectMake(self.view.width-120*self.scale, zongJiCell.height/2-12.5*self.scale, 50*self.scale, 25*self.scale);
                quiXaioBtn.layer.borderWidth = .5;
                quiXaioBtn.layer.borderColor = blackLineColore.CGColor;
                [quiXaioBtn setTitle:@"去评价" forState:UIControlStateNormal];
                [quiXaioBtn addTarget:self action:@selector(shanchu:) forControlEvents:UIControlEventTouchUpInside];
                quiXaioBtn.titleLabel.font = SmallFont(self.scale);
                [quiXaioBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                quiXaioBtn.layer.cornerRadius = 4.0f;
                quiXaioBtn.tag=50000+i;
                [zongJiCell addSubview:quiXaioBtn];
                
                
                
                
            }
            UIButton *shanchu = [UIButton buttonWithType:UIButtonTypeCustom];
            shanchu.frame = CGRectMake(self.view.width-60*self.scale, zongJiCell.height/2-12.5*self.scale, 50*self.scale, 25*self.scale);
            shanchu.layer.borderWidth = .5;
            shanchu.layer.borderColor = blackLineColore.CGColor;
            [shanchu setTitle:@"删除" forState:UIControlStateNormal];
            [shanchu addTarget:self action:@selector(shanchu:) forControlEvents:UIControlEventTouchUpInside];
            shanchu.titleLabel.font = SmallFont(self.scale);
            [shanchu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            shanchu.backgroundColor = blackLineColore;
            shanchu.layer.cornerRadius = 4.0f;
            shanchu.tag=1000+i;
            [zongJiCell addSubview:shanchu];
            
            
            bigvi.size = CGSizeMake(self.view.width, zongJiCell.bottom);
            setY = bigvi.bottom +10*self.scale;
            _bigScrollView.contentSize = CGSizeMake(self.view.width,setY);
            
            
            
            
        }else{
            
            
            CellView * zongJiCell = [[CellView alloc]initWithFrame:CGRectMake(0,line1BotFloat, self.view.width, 44)];
            [bigvi addSubview:zongJiCell];
            
            UILabel *shopNumberLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, zongJiCell.height/2-10*self.scale, self.view.width-20*self.scale, 20*self.scale)];
            
            shopNumberLa.attributedText = [self stringColorAllString:[NSString stringWithFormat:@"共%d件商品 合计:￥%.2f元",_sum,_ji] redString:[NSString stringWithFormat:@"￥%.2f",_ji]];
            
            shopNumberLa.font = DefaultFont(self.scale);
            [zongJiCell addSubview:shopNumberLa];
            //-
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0f], NSParagraphStyleAttributeName:paragraphStyle.copy};
            CGSize size1 = [shopNumberLa.text boundingRectWithSize:CGSizeMake(350, 20*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            //shopNumberLa.width = size1.width;
            bigvi.size = CGSizeMake(self.view.width, zongJiCell.bottom);
            setY = bigvi.bottom +10*self.scale;
            _bigScrollView.contentSize = CGSizeMake(self.view.width,setY);
        }
    }
}

-(void)huodaoQuXiao:(UIButton *)sender{
    
    [self ShowAlertTitle:nil Message:@"确认取消?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            [self.view addSubview:self.activityVC];
            [self.activityVC startAnimate];
            NSDictionary *dic = @{@"user_id":self.user_id,@"sub_order_no":biggg[sender.tag-5000][@"prods"][0][@"sub_order_no"],@"order_no":biggg[sender.tag-5000][@"order_no"]};
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimate];
                
                if ([code isEqualToString:@"0"]) {
                    //  [self ShowAlertWithMessage:msg];
                    _index=0;
                    [self reshData];
                    //                    AnalyzeObject *anle = [AnalyzeObject new];
                    //                    NSDictionary *dic = @{@"user_id":self.user_id,@"status":_zhuang,@"pindex":@"1"};
                    //                    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                    //                        [self.activityVC stopAnimate];
                    //                        [_data1 removeAllObjects];
                    //                        [_data1 addObjectsFromArray:models];
                    //                        if (![code isEqualToString:@"0"]) {
                    //
                    //                            [_data removeAllObjects];
                    //
                    //                        }
                    //                        [self centerDaiShouHuoOderVi];
                    //
                    //
                    //                    }];
                    
                    
                }
            }];
            
        }else{
            [self.activityVC stopAnimate];
            
        }
        
        
    }];
    
    
}


-(void)oderStBtnEvent:(UIButton *)btn{
    self.hidesBottomBarWhenPushed=YES;
    
    
    //  NSString *str = biggg[btn.tag-1000000][@"status"];
    
    
    id start = biggg[btn.tag-1000000];
    NSString *starts = [[NSString alloc]init];
    
    if ([start isKindOfClass:[NSArray class]]) {
        starts = start[0][@"status"];
        
    }else{
        starts = start[@"status"];
    }
    
    
    if (![starts isEqualToString:@"1"]) {
        OderStatesViewController *oder = [OderStatesViewController new];
        
        
        oder.price = _priceArr[btn.tag-1000000];
        oder.orderid =biggg[btn.tag-1000000][@"order_no"];
        oder.smallOder =biggg[btn.tag-1000000][@"prods"][0][@"sub_order_no"];
        [self.navigationController pushViewController:oder animated:YES];
    }else{
        weifukuanViewController *weifu = [weifukuanViewController new];
        weifu.order_id=biggg[btn.tag-1000000][0][@"order_no"];
        [self.navigationController pushViewController:weifu animated:YES];
    }
}

-(void)querenshouhuo:(UIButton *)btn{
    
    long tag = btn.tag-100000;
    [self.view addSubview:self.activityVC];
    [self ShowAlertTitle:nil Message:@"确认收货?" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            [self.activityVC startAnimate];
            NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            
            
            
            
            NSDictionary *dic = @{@"user_id":userid,@"sub_order_no":biggg[tag][@"prods"][0][@"sub_order_no"]};
            
            AnalyzeObject *anle = [AnalyzeObject new];
            [anle finishOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                [_data removeAllObjects];
                if ([code isEqualToString:@"0"]) {
                    
                    AnalyzeObject *anle = [AnalyzeObject new];
                    
                    
                    NSString *index = [NSString stringWithFormat:@"%d",1];
                    NSDictionary *dic = @{@"user_id":userid,@"status":@"5",@"pindex":index};
                    [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                        
                        if ([code isEqualToString:@"0"]) {
                            [_data addObjectsFromArray:models];
                            [self centerDaiFuKuanOderVi];
                            
                        }
                        [self.activityVC stopAnimate];
                        [_bigScrollView.header endRefreshing];
                        [_bigScrollView.footer endRefreshing];
                    }];
                }
                [self.activityVC stopAnimate];
            }];
        }
    }];
}

-(void)fuAndQUxiAO:(UIButton *)sender{
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    if ([sender.titleLabel.text isEqualToString:@"付款"]) {
        //付款
        NSLog(@"%@",biggg);
        
        if ([biggg[sender.tag-20000][0][@"pay_type"] isEqualToString:@"2"]) {
            [self.activityVC stopAnimate];
            float pric = [biggg[sender.tag-20000][0][@"total_amount"] floatValue]*100;
            
            NSLog(@"%@    %@     %@",[NSString stringWithFormat:@"%.0f",pric],biggg[sender.tag-20000][0][@"order_no"],biggg[sender.tag-20000][0][@"order_no"]);
            
            
            [self.appdelegate WXPayPrice:[NSString stringWithFormat:@"%.0f",pric] OrderID:biggg[sender.tag-20000][0][@"order_no"] OrderName:biggg[sender.tag-20000][0][@"order_no"] complete:^(BaseResp *resp) {
                
                if (resp.errCode == WXSuccess) {
                }
            }];
            
        }else if ([biggg[sender.tag-20000][0][@"pay_type"] isEqualToString:@"1"]){
            [self.activityVC stopAnimate];
            
            [self.appdelegate AliPayPrice:[NSString stringWithFormat:@"%@",biggg[sender.tag-20000][0][@"total_amount"]] OrderID:biggg[sender.tag-20000][0][@"order_no"] OrderName:@"拇指社区" OrderDescription:biggg[sender.tag-20000][0][@"order_no"] complete:^(NSDictionary *resp) {
                if ([[resp objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                    
                }else{
                    //                    [self ShowAlertWithMessage:@"支付失败！"];
                    self.hidesBottomBarWhenPushed=YES;
                    OrderFileViewController *file = [OrderFileViewController new];
                    [self.navigationController pushViewController:file animated:YES];
                    
                }
            }];
        }
    }else{
        //取消  _data[sender.tag-300][@"order_detail"][0][@"order_no"]
        [self ShowAlertTitle:nil Message:@"确认取消?" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
                NSDictionary *dic = @{@"user_id":userid,@"order_no":biggg[sender.tag-10000][0][@"order_no"]};
                AnalyzeObject *anle = [AnalyzeObject new];
                [anle cancelOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                    if ([code isEqualToString:@"0"]) {
                        [self ShowAlertWithMessage:msg];
                        
                        [_data removeAllObjects];
                        AnalyzeObject *anle = [AnalyzeObject new];
                        NSString *index = [NSString stringWithFormat:@"%d",1];
                        NSDictionary *dic = @{@"user_id":userid,@"status":@"5",@"pindex":index};
                        [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                            
                            if ([code isEqualToString:@"0"]) {
                                [_data addObjectsFromArray:models];
                                [self centerDaiFuKuanOderVi];
                                
                            }
                            [self.activityVC stopAnimate];
                            [_bigScrollView.header endRefreshing];
                            [_bigScrollView.footer endRefreshing];
                        }];
                    }
                }];
            }else{
                [self.activityVC stopAnimate];
            }
        }];
    }
}

-(void)shanchu:(UIButton *)btn{
    [self.view addSubview:self.activityVC];
    NSString *ID = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    if ([btn.titleLabel.text isEqualToString:@"去评价"]) {
        self.hidesBottomBarWhenPushed=YES;
        XiePingJiaViewController *pingjia= [XiePingJiaViewController new];
        pingjia.is_order_on=YES;
        pingjia.lingshou=YES;
        pingjia.order_on=biggg[btn.tag-50000][@"prods"][0][@"sub_order_no"];
        pingjia.shopid = biggg[btn.tag-50000][@"shop_id"];
        
        [pingjia reshBlock:^(NSMutableArray *arr) {
            [self.view addSubview:self.activityVC];
            [_data removeAllObjects];
            AnalyzeObject *anle = [AnalyzeObject new];
            NSString *index = [NSString stringWithFormat:@"%d",1];
            NSDictionary *dic = @{@"user_id":ID,@"status":@"5",@"pindex":index};
            [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                if ([code isEqualToString:@"0"]) {
                    [_data addObjectsFromArray:models];
                    [self centerDaiFuKuanOderVi];
                }
                [self.activityVC stopAnimate];
                [_bigScrollView.header endRefreshing];
                [_bigScrollView.footer endRefreshing];
            }];
        }];
        [self.navigationController pushViewController:pingjia animated:YES];
    }else{
        [self ShowAlertTitle:nil Message:@"确认删除?" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                [self.activityVC startAnimate];
                NSDictionary *dic = @{@"user_id":ID,@"sub_order_no":biggg[btn.tag-1000][@"prods"][0][@"sub_order_no"]};
                AnalyzeObject *anle = [AnalyzeObject new];
                [anle delOrderWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                    if ([code isEqualToString:@"0"]) {
                        [self.view addSubview:self.activityVC];
                        [_data removeAllObjects];
                        AnalyzeObject *anle = [AnalyzeObject new];
                        NSString *index = [NSString stringWithFormat:@"%d",1];
                        NSDictionary *dic = @{@"user_id":ID,@"status":@"5",@"pindex":index};
                        [anle myOrderListWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
                            if ([code isEqualToString:@"0"]) {
                                [_data addObjectsFromArray:models];
                                [self centerDaiFuKuanOderVi];
                            }
                            [self.activityVC stopAnimate];
                            [_bigScrollView.header endRefreshing];
                            [_bigScrollView.footer endRefreshing];
                        }];
                    }
                }];
            }
        }];
    }
}

#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"已取消订单";
    
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


-(CGSize)sizetoFitWithString:(NSString *)string{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(200, 35*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
