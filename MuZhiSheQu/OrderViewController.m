//
//  OrderViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/10/30.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "OrderViewController.h"
#import "DataBase.h"
#import "AppUtil.h"

@interface OrderViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate>
{
    NSMutableArray *dataSouse;
}
@property(nonatomic,assign)float bot,botLeft,botTop, setY;
@property(nonatomic,strong)UILabel *shouldPayPrice;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSArray *DayArr;
@property(nonatomic,strong)NSMutableArray *TimeArr,*TodayArr,*DataArr;
@property(nonatomic,strong)UIImageView *SelectImg;
@property(nonatomic,strong)UIPickerView *TimePickerView;
@property(nonatomic,strong)UIControl *big;
@property(nonatomic,strong)UIButton *peisong;
@property(nonatomic,strong)NSMutableDictionary *prodInfo,*bigDic;
@property(nonatomic,strong)NSMutableArray *shopArr;
@property(nonatomic,strong)NSMutableDictionary *ar;
@property(nonatomic,strong)UITextView *beizhuTF;
@property(nonatomic,strong)NSMutableDictionary *data;
@property(nonatomic,strong)NSString *shopID;

@end

@implementation OrderViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    [self.activityVC stopAnimate];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _shopArr = [NSMutableArray new];
    _prodInfo= [NSMutableDictionary new];
    _bigDic=[NSMutableDictionary new];
    //NSLog(@"%@",_bigbigArr);
     _ar = [[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
    _botPrice=0;
    _data = _bigbigArr;
    [self bigScrollView];
    [self orderInfo];
    [self returnVi];
    [self MoreList];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(topvi:) name:@"shopAddress" object:nil];
}

-(void)topvi:(NSNotification *)not{
    _ar = not.object;
    [self topVi];
}

#pragma mark - 数据块
-(void)MoreList{
    _index++;
    [self ReshData];
}
-(void)ReshData
{
    
    
    [self.activityVC stopAnimate];
    
    [self ReshView];
    
}
-(void)ReshView{
    
}

-(void)bigScrollView{
      if (_bigScrollVi) {
        [_bigScrollVi removeFromSuperview];
    }
    _bigScrollVi = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-49*self.scale)];
    _bigScrollVi.backgroundColor = superBackgroundColor;
    [self.view addSubview:_bigScrollVi];
    
    [self topVi];
    
}

#pragma mark ---顶部收货人信息
-(void)topVi{
    _topCon = [[UIControl alloc]initWithFrame:CGRectMake(0, 7.5*self.scale, self.view.bounds.size.width, 145/2.25*self.scale)];
    _topCon.backgroundColor = [UIColor whiteColor];
    [_bigScrollVi addSubview:_topCon];
    _stripVi = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5*self.scale)];
    _stripVi.image = [UIImage imageNamed:@"dian_xq_line"];
    [_topCon addSubview:_stripVi];
    _shouHuoer = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 15*self.scale, 60*self.scale, 15*self.scale)];
    _shouHuoer.text = @"收货人 :";
    _shouHuoer.font = DefaultFont(self.scale);
    [_topCon addSubview:_shouHuoer];
    float r = _shouHuoer.right;
    float t = _shouHuoer.top;
    _shouName = [[UILabel alloc]initWithFrame:CGRectMake(r, t,100*self.scale, 15)];
    _shouName.text = [_ar objectForKey:@"real_name"];
    _shouName.font = DefaultFont(self.scale);
    [_topCon addSubview:_shouName];
    r = _shouName.right;
    _shouTal = [[UILabel alloc]initWithFrame:CGRectMake(r+10, t, 130*self.scale, 15)];
    _shouTal.text = [_ar objectForKey:@"mobile"];
    _shouTal.font = DefaultFont(self.scale);
    [_topCon addSubview:_shouTal];
    float b = _shouTal.bottom;
    _shouAddressLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, b+15, 70*self.scale, 35*self.scale)];
    _shouAddressLa.text = @"收货地址 :";
    _shouAddressLa.font =DefaultFont(self.scale);
    [_topCon addSubview:_shouAddressLa];
    r = _shouAddressLa.right;
    _addressLa = [[UILabel alloc]initWithFrame:CGRectMake(r, _shouAddressLa.top, self.view.width-_shouAddressLa.right-50*self.scale, 35*self.scale)];
    _addressLa.numberOfLines=0;
    _addressLa.font = DefaultFont(self.scale);
    _addressLa.text = [_ar objectForKey:@"address"];
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
    
    _setY = _topCon.bottom+10*self.scale;
    
    
}

-(void)topEvent:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
    ShouHuoDiZhiListViewController *shouhuo = [ShouHuoDiZhiListViewController new];
    shouhuo.orReturn=YES;
    shouhuo.adressid = _ar[@"id"];
    [self.navigationController pushViewController:shouhuo animated:YES];
}

#pragma mark ----订单信息
-(void)orderInfo{
    NSMutableArray *keys = [NSMutableArray new];
    for (NSString *key in [_data allKeys]) {
        NSString *shopid = [_data objectForKey:key][@"shop_id"];
        _shopID=shopid;
        [keys addObject:shopid];
    }
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (NSString *key in keys) {
        
        [dict setObject:key forKey:key];
        
    }
    dataSouse=[NSMutableArray new];
    for (NSString *key in [dict allValues]) {
        NSMutableArray *ar = [NSMutableArray new];
        for (NSString *k in [_data allKeys]) {
            NSString *shopid = [_data objectForKey:k][@"shop_id"];
//NSLog(@"shopid==%@   key==%@",shopid,key);
            if ([shopid intValue]==[key intValue]) {
               // if ([shopid isEqualToString:key]) {
                [ar addObject:[_data objectForKey:k]];
            }
            
        }
        [dataSouse addObject:ar];
        
    }

    for (int i=0; i<dataSouse.count; i++) {
        NSMutableArray *prodArr = [NSMutableArray new];
        NSMutableDictionary *shopInfo = [NSMutableDictionary new];

        _bigCenterCon = [[UIControl alloc]initWithFrame:CGRectMake(0, _setY, self.view.bounds.size.width,0)];
        _bigCenterCon.backgroundColor = [UIColor colorWithRed:254/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        [_bigScrollVi addSubview:_bigCenterCon];
        
        if(i==0){
            UIView *firstLine = [[UIView alloc]initWithFrame:CGRectMake(0, -1, self.view.bounds.size.width, .5)];
            firstLine.backgroundColor = [UIColor colorWithRed:221/255.0 green:226/255.0 blue:227/255.0 alpha:1];
            [_bigCenterCon addSubview:firstLine];
        }
        
        UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(15*self.scale, 7.5*self.scale, 40*self.scale, 30*self.scale)];
       // NSLog(@"%@",[dic[i][aa[i]]objectForKey:@"logo"] );
        
        
        
        
         [headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataSouse[i][0][@"logo"]] ]placeholderImage:[UIImage imageNamed:@"center_img"]];
        [_bigCenterCon addSubview:headImg];
        float r = headImg.right;
        float t = headImg.top;
        
        
        
        
        UILabel *ShopName = [[UILabel alloc]initWithFrame:CGRectMake(r+5*self.scale, t+5*self.scale, 20, 20*self.scale)];
        
        ShopName.text = dataSouse[i][0][@"shop_name"];
        ShopName.font = DefaultFont(self.scale);
        [_bigCenterCon addSubview:ShopName];
        
        
        //计算uilable的动态size
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGSize size = [ShopName.text boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGFloat width =MAX(size.width, 44.0f);
        ShopName.width=width;
        r = ShopName.right;
        t = ShopName.top;
        
        
        UIImageView *jianTouImg = [[UIImageView alloc]initWithFrame:CGRectMake(r+10*self.scale, t+5*self.scale, 10*self.scale, 10*self.scale)];
        jianTouImg.image = [UIImage imageNamed:@"dian_xq_right"];
        [_bigCenterCon addSubview:jianTouImg];
#pragma mark---对话按钮；
        
//        UIButton *talkImg = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80/2.25*self.scale, 12*self.scale, 20*self.scale,20*self.scale)];
//        [talkImg setBackgroundImage:[UIImage imageNamed:@"dian_ico_01"] forState:UIControlStateNormal];
//        talkImg.tag=i+10000;
//        [talkImg addTarget:self action:@selector(talk:) forControlEvents:UIControlEventTouchUpInside];
//        [_bigCenterCon addSubview:talkImg];
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, headImg.bottom+10*self.scale, self.view.bounds.size.width, .5)];
        line.backgroundColor = [UIColor colorWithRed:221/255.0 green:226/255.0 blue:227/255.0 alpha:1];
        [_bigCenterCon addSubview:line];
        
        ////------//商品个数不固定 ；；；；
        float line1BotFloat = line.bottom;
        _sum=0;
        _zongProce=0;
        for (int j=0; j<[dataSouse[i] count]; j++) {
            
            UIView *ViewCell=[[UIView alloc]initWithFrame:CGRectMake(0, line1BotFloat, self.view.width, 80*self.scale)];
            [_bigCenterCon addSubview:ViewCell];
            
            UIImageView *cellHeadImg = [[UIImageView alloc]initWithFrame:CGRectMake(headImg.left,10*self.scale, 80*self.scale, 60*self.scale)];
            cellHeadImg.clipsToBounds=YES;
            cellHeadImg.contentMode=UIViewContentModeScaleAspectFill;
            
            
            
            [cellHeadImg setImageWithURL:[NSURL URLWithString:dataSouse[i][j][@"prod_img1"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
            [ViewCell addSubview:cellHeadImg];
            
            UILabel *cellShopName = [[UILabel alloc]initWithFrame:CGRectMake(cellHeadImg.right+10*self.scale, cellHeadImg.top, 180*self.scale, 20)];
            cellShopName.numberOfLines=0;

            cellShopName.text =dataSouse[i][j][@"prod_name"];
            cellShopName.font = DefaultFont(self.scale);
            [ViewCell addSubview:cellShopName];

            UILabel *sales = [[UILabel alloc]initWithFrame:CGRectMake(cellShopName.left, cellShopName.bottom+5*self.scale, 100, 10)];
            sales.text = [NSString stringWithFormat:@"销量%@",dataSouse[i][j][@"sales"]];
            sales.font = SmallFont(self.scale);
            sales.textColor = grayTextColor;
            //[ViewCell addSubview:sales];
            
            UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-90*self.scale, cellShopName.top, 80*self.scale,20*self.scale)];
            price.textColor = [UIColor redColor];
            price.text = [NSString stringWithFormat:@"￥%@",dataSouse[i][j][@"price"]];
            price.textAlignment=NSTextAlignmentRight;
            price.font = DefaultFont(self.scale);
            [ViewCell addSubview:price];
            cellShopName.width = self.view.width-price.width-100*self.scale;
            [cellShopName sizeToFit];
            sales.top=cellShopName.bottom+5*self.scale;

            
            UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(price.left, price.bottom+10*self.scale, price.width,10*self.scale)];
            number.font = SmallFont(self.scale);
            number.text = [NSString stringWithFormat:@"x%@",dataSouse[i][j][@"prod_count"]];
            number.textAlignment=NSTextAlignmentRight;
            [ViewCell addSubview:number];
            
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, ViewCell.height-.5, self.view.width, .5)];
            line1.backgroundColor = blackLineColore;
            [ViewCell addSubview:line1];
            
            line1BotFloat = ViewCell.bottom;
            

            NSMutableDictionary *prod = [NSMutableDictionary new];
            
            [prod setObject:dataSouse[i][j][@"prod_id"] forKey:@"prod_id"];
                                [prod setObject:dataSouse[i][j][@"prod_count"]  forKey:@"prod_count"];
           
                [prodArr addObject:prod];

       //商品数量;
         int znum = [dataSouse[i][j][@"prod_count"] intValue];
            
            _sum=_sum+znum;
            
            self.num = [NSString stringWithFormat:@"%d",_sum];
            
            
          float pri = [dataSouse[i][j][@"price"] floatValue];
            
            //float pric =  [_data[i][@"prod_info"][j][@"price"] floatValue];
            self.zongProce = self.zongProce+pri*znum;
            
  
        }
        [shopInfo setObject:prodArr forKey:@"prods"];
        
        [shopInfo setObject:dataSouse[i][0][@"shop_id"] forKey:@"shop_id"];
        
        
        [shopInfo setObject:@"1" forKey:@"delivery_time"];//配送时间
        
        //备注
        [shopInfo setObject:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",_beizhuTF.text]] forKey:@"memo"];
        
        [shopInfo setObject:[NSString stringWithFormat:@"%.2f",self.zongProce] forKey:@"amount"];
        
        [_shopArr addObject:shopInfo];
     //-------
        
        CellView *timeCell=[[CellView alloc]initWithFrame:CGRectMake(0, line1BotFloat, self.view.width, 44)];
        timeCell.tag=90;
        timeCell.titleLabel.text=@"配送时间";
        timeCell.titleLabel.font=DefaultFont(self.scale);
        [timeCell ShowRight:YES];
        [_bigCenterCon addSubview:timeCell];
        
        
        UIButton *peisong = [UIButton buttonWithType:UIButtonTypeCustom];
        [peisong setTitle:@"立即配送" forState:UIControlStateNormal];
        [peisong setTitleColor:grayTextColor forState:UIControlStateNormal];
        peisong.tag=800+i;
        peisong.titleLabel.font=DefaultFont(self.scale);
        peisong.frame=CGRectMake(self.view.width-150*self.scale, timeCell.height/2-10*self.scale, 130*self.scale, 20*self.scale);
        [peisong addTarget:self action:@selector(timeselectBtn:) forControlEvents:UIControlEventTouchUpInside];
        peisong.contentHorizontalAlignment=NSTextAlignmentRight;
        [timeCell addSubview:peisong];
        CellView *beizhuCell=[[CellView alloc]initWithFrame:CGRectMake(0, timeCell.bottom, self.view.width, 44)];
        beizhuCell.titleLabel.text=@"备注";
        beizhuCell.titleLabel.font=DefaultFont(self.scale);
        [_bigCenterCon addSubview:beizhuCell];
        
        [beizhuCell.titleLabel sizeToFit];
        _beizhuTF = [[UITextView alloc]initWithFrame:CGRectMake(beizhuCell.titleLabel.right+10*self.scale, beizhuCell.titleLabel.top, self.view.width-beizhuCell.titleLabel.right-10*self.scale, 35*self.scale)];
        _beizhuTF.delegate=self;
        _beizhuTF.tag=i+100000000000;
        //        _beizhuTF.placeholder = @"可以输入特殊要求";
        _beizhuTF.textAlignment=NSTextAlignmentLeft;
        _beizhuTF.returnKeyType=UIReturnKeyDone;
        _beizhuTF.font=DefaultFont(self.scale);
        [beizhuCell addSubview:_beizhuTF];
        beizhuCell.height=_beizhuTF.bottom+10*self.scale;
        UILabel *b = [[UILabel alloc]initWithFrame:CGRectMake(_beizhuTF.left+10*self.scale, 0*self.scale, self.view.width, beizhuCell.height)];
        b.text=@"请输入特殊要求";
        b.tag=i+1000000000000;
        b.font=DefaultFont(self.scale);
        b.textColor=blackLineColore;
        [beizhuCell addSubview:b];

        beizhuCell.titleLabel.top = b.height/2-10*self.scale;

        
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        [topView setBarStyle:UIBarStyleDefault];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收起" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
        [topView setItems:buttonsArray];
        [_beizhuTF setInputAccessoryView:topView];

        
        //@"今天",
        _DayArr=[NSArray arrayWithObjects:@"今天", @"明天", nil];
        _TimeArr=[[NSMutableArray alloc]init];
        _TodayArr=[[NSMutableArray alloc]init];
        _DataArr=[[NSMutableArray alloc]init];
        [_TodayArr addObject:@"1小时送达"];
        for(int l=0;l<24;l++)
        {
            NSString *Time=[NSString stringWithFormat:@"%d:00-%d:00",l,l+1];
            [_TimeArr addObject:Time];
            
        }
        _DataArr=_TimeArr;
//        ----------
        
        UILabel *finishNumber = [[UILabel alloc]initWithFrame:CGRectMake(headImg.left, beizhuCell.bottom+15*self.scale, 100, 15)];
        finishNumber.text = [NSString stringWithFormat:@"共%@件商品",self.num];
        finishNumber.textColor = grayTextColor;
        finishNumber.font = [UIFont systemFontOfSize:12.0f*self.scale];
        [_bigCenterCon addSubview:finishNumber];
        [finishNumber sizeToFit];
        
        UILabel *finishPrice = [[UILabel alloc]initWithFrame:CGRectMake(finishNumber.right+10*self.scale, finishNumber.top, 100, 15)];
        finishPrice.textColor = grayTextColor;
        finishPrice.text = [NSString stringWithFormat:@"配送费%@元",@""];
        finishPrice.font = [UIFont systemFontOfSize:12.0f*self.scale];
        [_bigCenterCon addSubview:finishPrice];
        
        
        
        UILabel *combined = [[UILabel alloc]initWithFrame:CGRectMake(finishPrice.right, finishNumber.top, self.view.width-finishPrice.right-10*self.scale, 15*self.scale)];
        combined.textAlignment=NSTextAlignmentRight;
        combined.font=DefaultFont(self.scale);
        
        [_bigCenterCon addSubview:combined];
        
        _bigCenterCon.size=CGSizeMake(self.view.width, combined.bottom+10*self.scale);
        _setY=_bigCenterCon.bottom+10*self.scale;
        _bot = _bigCenterCon.bottom;
        _botLeft = headImg.left;
 
        //float z = self.zongProce ;
// 运费
        float man = [dataSouse[i][0][@"free_delivery_amount"] floatValue]; // 80
        float y = [dataSouse[i][0][@"delivery_fee"] floatValue];                                 //28
        
        if (self.zongProce>=man) {
            combined.attributedText = [self zstringColorAllString:[NSString stringWithFormat:@"合计￥%.2f元",self.zongProce] redString:self.zongProce];
            [shopInfo setObject:@"0" forKey:@"delivery_fee"];
            y=0;
        }else{
            self.zongProce=[[NSString stringWithFormat:@"%.2f",self.zongProce+y] floatValue];
            //self.zongProce=z+y;
            combined.attributedText = [self zstringColorAllString:[NSString stringWithFormat:@"合计￥%.2f元",self.zongProce] redString:self.zongProce];
            [shopInfo setObject:[NSString stringWithFormat:@"%.2f",y] forKey:@"delivery_fee"];

        }
        _botPrice=_botPrice+self.zongProce;
        
        finishPrice.text = [NSString stringWithFormat:@"配送费%.0f元",y];
      [finishPrice sizeToFit];

    }
    [_bigDic setObject:_shopArr forKey:@"prod_info"];
    
    UILabel *allPrice = [[UILabel alloc]initWithFrame:CGRectMake(_botLeft, _bigCenterCon.height, 100*self.scale, 40*self.scale)];
    allPrice.text = @"应付金额:";
    allPrice.font=DefaultFont(self.scale);
    [_bigCenterCon addSubview:allPrice];
    
    
    UILabel *allPriceNum = [[UILabel alloc]initWithFrame:CGRectMake(allPrice.right, allPrice.top, self.view.width-allPrice.right-10*self.scale, 40*self.scale)];
    allPriceNum.font=DefaultFont(self.scale);
    [_bigCenterCon addSubview:allPriceNum];
    allPriceNum.textAlignment=NSTextAlignmentRight;
    NSMutableAttributedString *allprice = [self zstringColorAllString:[NSString stringWithFormat:@"￥%.2f元",_botPrice] redString:_botPrice];

    
    allPriceNum.attributedText = allprice;//[self zstringColorAllString:[NSString stringWithFormat:@"￥%.2f元",_botPrice] redString:[NSString stringWithFormat:@"￥%.2f",_botPrice]];
    [self payWay];
}

-(void)dismissKeyBoard
{
    [_beizhuTF resignFirstResponder];
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"keyboard changed, keyboard width = %f, height = %f",  kbSize.width, kbSize.height);
    
    // 在这里调整UI位置
    CGPoint pt = [_beizhuTF convertPoint:CGPointMake(0, 0) toView:[UIApplication sharedApplication].keyWindow];
    float txDistanceToBottom = self.view.frame.size.height - pt.y - _beizhuTF.frame.size.height;  // 距离底部多远
    if( txDistanceToBottom >= kbSize.height )  // 键盘不会覆盖
        return;
    
    _bigScrollVi.contentSize = CGSizeMake(_bigScrollVi.contentSize.width, _bigScrollVi.contentSize.height + kbSize.height); //原始滑动距离增加键盘高度
    
    // 差多少
    float offsetY = txDistanceToBottom - kbSize.height - 80;  // 补一些给各种输入法
    [_bigScrollVi setContentOffset:CGPointMake(0, _bigScrollVi.contentOffset.y - offsetY-64) animated:YES];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    // 键盘动画时间
    double duration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}


#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    
    
//    1000000000000
    NSInteger Tag = textView.tag-100000000000;
    
        if (textView.text.length>0)
            {
                UILabel *label=(UILabel *)[self.view viewWithTag:1000000000000+Tag];
                label.hidden=YES;
            }else
            {
                UILabel *label=(UILabel *)[self.view viewWithTag:1000000000000+Tag];
                label.hidden=NO;
            }
    
}

-(void)talk:(UIButton *)btn{
//    self.hidesBottomBarWhenPushed=YES;
//    RCDChatViewController *chatService = [RCDChatViewController new];
////    chatService.userName = dataSouse[btn.tag-10000][0][@"shop_name"];
//    chatService.targetId = dataSouse[btn.tag-10000][0][@"shop_user_id"];
//    chatService.conversationType = ConversationType_PRIVATE;
//    chatService.title = dataSouse[btn.tag-10000][0][@"shop_name"];
//    [self.navigationController pushViewController: chatService animated:YES];

    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:dataSouse[btn.tag-10000][0][@"shop_user_id"] forKey:@"shop_id"];
    //    [dic setObject:[NSString stringWithFormat:@"%@",[_data objectForKey:@"hotline"]] forKey:@"tel"];
    if ([Stockpile sharedStockpile].isLogin) {
        [dic setObject:[Stockpile sharedStockpile].ID forKey:@"user_id"];
    }
    
    [anle telTongJi:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        if ([code isEqualToString:@"0"]) {
        }
        //        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[_data objectForKey:@"hotline"]];
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
}


NSInteger ta1;
-(void)timeselectBtn:(UIButton *)sender{
    [self.view endEditing:YES];
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
    
    
    ta1=sender.tag;
    
    
    
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
    str =[NSString stringWithFormat:@"%@ %@",[_DayArr objectAtIndex:[_TimePickerView selectedRowInComponent:0]],[_DataArr objectAtIndex:[_TimePickerView selectedRowInComponent:1]]];
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:ta1];
    
    [btn setTitle:str forState:UIControlStateNormal];
    
    
    
    
    
    NSArray *dateArr = [str componentsSeparatedByString:@" "];
    
    NSString *fen = dateArr[1];
    //用户选择的几点几分 fenarr[0]；
    NSArray *fenarr = [fen componentsSeparatedByString:@"-"];
    
    
    if ([dateArr[0] isEqualToString:@"今天"]) {
        
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd "];
        NSString *string = [formatter stringFromDate:date];
        
        str = [string stringByAppendingString:fenarr[0]];
        
        
    }else{
        NSDate *date = [NSDate date];
        NSDate *newDate = [date dateByAddingTimeInterval:60 * 60 * 24 * 1];
        
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd "];
        NSString *string = [formatter stringFromDate:newDate];
        
        str = [string stringByAppendingString:fenarr[0]];
        
        
    }
    NSMutableArray *ar = _bigDic[@"prod_info"];
    NSMutableDictionary *d = ar[ta1-800];
    [d setObject:str forKey:@"delivery_time"];
    [ar replaceObjectAtIndex:ta1-800 withObject:d];
    [_bigDic setObject:ar forKey:@"prod_info"];

    
    [UIView animateWithDuration:.5 animations:^{
        _SelectImg.frame=CGRectMake(0, self.view.height, self.view.width, self.view.height+180*self.scale);
        _big.alpha=0;
    }completion:^(BOOL finished) {
        
        [_big removeFromSuperview];
        
    }];
    
}

#pragma mark------底部支付方式选择
-(void)payWay{
    
    _botCon = [[UIControl alloc]initWithFrame:CGRectMake(0, _bot+40*self.scale, self.view.bounds.size.width, 360/2.25*self.scale)];
    
    _botCon.backgroundColor = [UIColor whiteColor];
    [_bigScrollVi addSubview:_botCon];
    
    UIView *toLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, .5)];
    toLine.backgroundColor = [UIColor colorWithRed:221/255.0 green:226/255.0 blue:227/255.0 alpha:1];
    [_botCon addSubview:toLine];
    
    NSArray *payArr = @[@"支付方式",@"微信支付",@"支付宝支付",@"货到付款"];
    
    for (int i=0; i<4; i++) {
        //        if (i>=2) {
        //            break;
        //        }
        UIView *line = [[UILabel alloc]initWithFrame:CGRectMake(0, i*360/2.25*self.scale/4, self.view.bounds.size.width, .5)];
        line.backgroundColor = [UIColor colorWithRed:221/255.0 green:226/255.0 blue:227/255.0 alpha:1];
        [_botCon addSubview:line];
        UILabel *payway = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, line.top+15*self.scale, 100*self.scale, 15)];
        payway.text = payArr[i];
        payway.font = [UIFont systemFontOfSize:12.0f*self.scale];
        [_botCon addSubview:payway];
        _botCon.height=payway.bottom+15*self.scale;
        if (i!=0) {
            UIButton *selectImg = [UIButton buttonWithType:UIButtonTypeCustom];
            selectImg.frame = CGRectMake(self.view.bounds.size.width-35*self.scale, line.top+10*self.scale, 20*self.scale, 20*self.scale);
            [selectImg setBackgroundImage:[UIImage imageNamed:@"fu_yuan_01"] forState:UIControlStateNormal];
            [selectImg setBackgroundImage:[UIImage imageNamed:@"fu_yuan_02"] forState:UIControlStateSelected];
            selectImg.tag = 20+i;
            [selectImg addTarget:self action:@selector(choosePayWay:) forControlEvents:UIControlEventTouchUpInside];
            [_botCon addSubview:selectImg];
            if (i==1) {
                selectImg.selected=YES;
            }
        }
    }
    UIView *boLine = [[UILabel alloc]initWithFrame:CGRectMake(0, _botCon.height, self.view.bounds.size.width, .5)];
    boLine.backgroundColor = [UIColor colorWithRed:221/255.0 green:226/255.0 blue:227/255.0 alpha:1];
    [_botCon addSubview:boLine];
    
    _bigScrollVi.contentSize = CGSizeMake(self.view.bounds.size.width,_botCon.bottom+10*self.scale);
    [self botPayButtonVi];
}

-(void)choosePayWay:(UIButton *)sender{
    UIButton *btn1 = (UIButton *)[_botCon viewWithTag:21];
    UIButton *btn2 = (UIButton *)[_botCon viewWithTag:22];
    UIButton *btn3 = (UIButton *)[_botCon viewWithTag:23];
    switch (sender.tag) {
        case 21:
            btn1.selected=YES;
            btn2.selected=NO;
            btn3.selected=NO;
            break;
            
        case 22:
            btn1.selected=NO;
            btn2.selected=YES;
            btn3.selected=NO;
            break;
            
        case 23:
            btn1.selected=NO;
            btn2.selected=NO;
            btn3.selected=YES;
            break;
            
        default:
            break;
    }
}

-(void)botPayButtonVi{
    UIView *botPayBigVi = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-49*self.scale, self.view.bounds.size.width, 49*self.scale)];
    botPayBigVi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:botPayBigVi];
    _shouldPayPrice = [[UILabel alloc]initWithFrame:CGRectMake(20*self.scale, 10*self.scale, 200*self.scale, 30*self.scale)];
    _shouldPayPrice.textColor = blueTextColor;
    _shouldPayPrice.font = [UIFont systemFontOfSize:16.0f*self.scale];
    _shouldPayPrice.text = [NSString stringWithFormat:@"应付总额：￥%.2f元",_botPrice];
    _shouldPayPrice.font=DefaultFont(self.scale);
    [botPayBigVi addSubview:_shouldPayPrice];
    
    UIButton *shouldPay = [UIButton buttonWithType:UIButtonTypeCustom];
//    shouldPay.frame = CGRectMake(self.view.bounds.size.width-230/2.25*self.scale, 10*self.scale, 200/2.25*self.scale, 70/2.25*self.scale);
    shouldPay.frame = CGRectMake(self.view.bounds.size.width-200/2.25*self.scale, 0, 200/2.25*self.scale, botPayBigVi.height);
    shouldPay.backgroundColor = blueTextColor;
//    shouldPay.layer.cornerRadius = 4.0f;
    [shouldPay setTitle:@"确认下单" forState:UIControlStateNormal];
    shouldPay.titleLabel.font=DefaultFont(self.scale);
    [shouldPay addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [botPayBigVi addSubview:shouldPay];
    UIView *payBotLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, .5)];
    payBotLine.backgroundColor = [UIColor colorWithRed:221/255.0 green:226/255.0 blue:227/255.0 alpha:1];
    [botPayBigVi addSubview:payBotLine];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//**  支付按钮 ****
-(void)pay{
//    [self.view addSubview:self.activityVC];
//    [self.activityVC startAnimate];
    NSMutableArray *btnarr = [NSMutableArray new];
    NSInteger tag = 0;
    for (UIButton *btn in _botCon.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btnarr addObject:btn];
            if (btn.selected==YES) {
                tag=btn.tag;
            }
        }
    }
    //货到付款
    UIButton *btn3 = (UIButton *)[_botCon viewWithTag:23];
    //支付宝
    UIButton *btn1 = (UIButton *)[_botCon viewWithTag:22];
    //微信
    UIButton *btn2 = (UIButton *)[_botCon viewWithTag:21];
    if (!btn1.selected && !btn2.selected && !btn3.selected) {
        [self ShowAlertWithMessage:@"请选择支付方式"];
        return;
    }
    if (_ar.count<=0) {
        [self ShowAlertWithMessage:@"请选择地址"];
        return;
    }
    NSString *type = @"";
    
    if (btn1.selected==YES) {
        type=@"1";
    }else if (btn2.selected==YES){
        type=@"2";
    }else{
        type=@"3";
    }
    if(self.zongProce<0.01&&![type isEqualToString:@"3"]){
        type=@"3";
        btn3.selected=YES;
        btn2.selected=NO;
        btn1.selected=NO;
        [AppUtil showToast:self.view withContent:@"该订单仅支付货到付款"];
    }
    NSMutableArray *ar = _bigDic[@"prod_info"];
    for (int i=0; i<ar.count; i++) {
        UITextField *tf = (UITextField *)[self.view viewWithTag:100000000000+i];
        NSMutableDictionary *d = ar[i];
        [d setObject:[NSString stringWithFormat:@"%@",tf.text] forKey:@"memo"];
         [ar replaceObjectAtIndex:i withObject:d];
    }
    [_bigDic setObject:ar forKey:@"prod_info"];
    NSData *dataStr = [NSJSONSerialization dataWithJSONObject:_bigDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *st = [[NSString alloc]initWithData:dataStr encoding:NSUTF8StringEncoding];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSString *commid=[[NSUserDefaults standardUserDefaults]objectForKey:@"commid"];
    NSDictionary *dic = @{@"user_id":userid,@"address_id":_ar[@"id"],@"pay_type":type,@"total_amount":[NSString stringWithFormat:@"%.2f",_botPrice],@"prod_info":st,@"community_id":commid};
    //NSLog(@"%.2f",_botPrice);
    //NSLog(@"prod_info_param==%@",dic);
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    AnalyzeObject *anle = [AnalyzeObject new];
    [anle OrdersubmitWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimate];
        NSLog(@"prod_info_models==%@==%@==%@",models,code,msg);
        if ([code isEqualToString:@"0"]) {
            //[self.appdelegate.shopDictionary removeAllObjects];
           // [self.appdelegate.shopDictionary setObject:number forKey:@([prodID intValue])];
            for(NSString* key in [_data allKeys]){
                NSNumber* number=[NSNumber numberWithInt:0];
                [self.appdelegate.shopDictionary setObject:number forKey:@([key intValue])];
            }
            self.appdelegate.isRefresh=true;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GouWuCheShuLiang"];
            //[[DataBase sharedDataBase] clearCart];
            [[DataBase sharedDataBase] deleteCartWithShopID:_shopID];
            if (btn1.selected==YES) {
                [self.appdelegate AliPayNewPrice:[NSString stringWithFormat:@"%.2f",_botPrice] OrderID:[NSString stringWithFormat:@"%@",models[@"order_no"]] OrderName:@"拇指社区" Sign:models[@"sign"]  OrderDescription:[NSString stringWithFormat:@"%@",models[@"order_no"]] complete:^(NSDictionary *resp) {
                    [self.activityVC stopAnimate];
                    if ([[resp objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                        [self suessToVi];
                    }
                }];
            }else if (btn2.selected==YES){
                float pric = _botPrice*100;
                if (pric<=0) {
                    return;
                }
                if (![WXApi isWXAppInstalled]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                [self.appdelegate WXPayNewWithNonceStr:models[@"noncestr"] OrderID:models[@"order_no"] Timestamp:models[@"timestamp"] sign:models[@"sign"]complete:^(BaseResp *resp) {
                    [self.activityVC stopAnimate];
                    NSLog(@"wxresult====%d==%@",resp.errCode,resp.errStr);
                    if (resp.errCode == WXSuccess) {
                        [self suessToVi];
                    }else{
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:resp.errStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
                    }
                }];
            }else if (btn3.selected==YES){
                self.hidesBottomBarWhenPushed=YES;
                HuodaoSuessViewController *huodao = [HuodaoSuessViewController new];
                huodao.price=[NSString stringWithFormat:@"%.2f",_botPrice];
                [self.navigationController pushViewController:huodao animated:YES];
            }
        }else if ([code isEqualToString:@"-1"]) {
            [self ShowAlertTitle:@"请先登录" Message:msg Delegate:self Block:^(NSInteger index) {
                if (index==1) {
                    [self login];
                }
            }];
        }else{
            [self ShowAlertWithMessage:msg];
        }
    }];
}

-(void)suessToVi{
    self.hidesBottomBarWhenPushed=YES;
    orderSuessViewController *suecc = [orderSuessViewController new];
    suecc.price = [NSString stringWithFormat:@"%.2f",_zongProce];
    [self.navigationController pushViewController:suecc animated:YES];
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

-(NSMutableAttributedString *)zstringColorAllString:(NSString *)string redString:(float)redfloat{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range=[string rangeOfString:[NSString stringWithFormat:@"￥%.2f",redfloat]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    return str;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0){
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
        return _DayArr.count;
    }
    return _DataArr.count;
}

#pragma mark - UIPickerViewDatasource
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
        pickerLabel.text =  [_DayArr objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [_DataArr objectAtIndex:row];  // Month
    }
    return pickerLabel;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [_beizhuTF resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
@end
