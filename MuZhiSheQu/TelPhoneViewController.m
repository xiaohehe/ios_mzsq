
//
//  TelPhoneViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "TelPhoneViewController.h"
#import "CellView.h"

@interface TelPhoneViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableDictionary *data;
@property(nonatomic,strong)NSMutableArray *telData;
@property(nonatomic,strong)UITextField *searchText;
@property(nonatomic,assign)NSInteger typee;
@property(nonatomic,strong)CellView *vi;
@end

@implementation TelPhoneViewController

- (void)viewDidLoad {
    //self.navigationController.hidesBottomBarWhenPushed=NO;
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _index=0;
    _typee=0;
    _data = [NSMutableDictionary new];
    _telData=[NSMutableArray new];
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0,self.NavImg.bottom+44*self.scale, self.view.width, self.view.height-self.NavImg.bottom-75*self.scale)];
    _table.delegate=self;
    _table.dataSource=self;
    _table.backgroundColor=[UIColor clearColor];
    [_table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(foot)];
    [self.view addSubview:_table];
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self topVi];
    [self botVi];
    
    [self.view addSubview:self.activityVC];
    [self.activityVC startAnimate];
    
    [self reshData];
    [self returnVi];
    
}

-(void)topVi{
    UIImageView *SearchBG=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, self.NavImg.bottom+8*self.scale, self.view.width-20*self.scale, 32*self.scale)];
    SearchBG.image=[UIImage setImgNameBianShen:@"gg_pingjia_box"];
    SearchBG.userInteractionEnabled=YES;
    [self.view addSubview:SearchBG];
    
    UIImageView *IconImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SearchBG.height, SearchBG.height)];
    IconImage.image=[UIImage imageNamed:@"search"];
    [SearchBG addSubview:IconImage];
    _searchText=[[UITextField alloc]initWithFrame:CGRectMake(IconImage.right, 0, SearchBG.width-IconImage.right-5 , SearchBG.height)];
    _searchText.font=DefaultFont(self.scale);
    _searchText.placeholder=@"请输入店名/商品";
    //_searchText.delegate=self;
    [SearchBG addSubview:_searchText];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)TextFieldChange{
    if ([_searchText.text isEqualToString:@""]) {
        _typee=0;
    }else{
        _typee=1;
    }
    
    _index=0;
    [self reshData];
    
}


-(void)botVi{

    if (_vi) {
        [_vi removeFromSuperview];
    }
    
    _vi = [[CellView alloc]initWithFrame:CGRectMake(0, self.view.height-44*self.scale, self.view.width, 44*self.scale)];
    _vi.topline.hidden=NO;
    _vi.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_vi];
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.width-80, _vi.height)];
    la.font=[UIFont systemFontOfSize:11*self.scale];
    la.text=@"如果你也想为社区提供服务,点击联系管理员";
    [_vi addSubview:la];
    
    UIButton *lianxi = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-70, _vi.height/2-10*self.scale, 50*self.scale, 20*self.scale)];
    [lianxi setTitle:@"管理员" forState:UIControlStateNormal];
    lianxi.layer.cornerRadius=4;
    lianxi.titleLabel.font=SmallFont(self.scale);
    lianxi.backgroundColor=[UIColor redColor];
    lianxi.layer.masksToBounds=YES;
    [lianxi addTarget:self action:@selector(teltalk) forControlEvents:UIControlEventTouchUpInside];
    [_vi addSubview:lianxi];

}

-(void)teltalk{
    
    
         NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_data[@"platform_tel"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];


}

-(void)foot{

    [self reshData];

}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
-(void)reshData{
    
    _index++;
    
    NSDictionary *dic = @{@"pindex":[NSString stringWithFormat:@"%ld",(long)_index],@"community_id":[self getCommid]};
    
    NSLog(@"%@",_searchText.text);
    if (_typee==1) {
        dic = @{@"pindex":[NSString stringWithFormat:@"%ld",(long)_index],@"keyword":_searchText.text,@"community_id":[self getCommid]};
    }
    
    
    AnalyzeObject *anle =[AnalyzeObject new];
    [anle showCommonTelWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        if (_index==1) {
            [_data removeAllObjects];
            [_telData removeAllObjects];
        }
        
        if ([code isEqualToString:@"0"]) {
            [_data addEntriesFromDictionary:models];
            [_telData addObjectsFromArray:models[@"common_tel"]];
        }
        [_table reloadData];
        [self botVi];
        [self.activityVC stopAnimate];
        [self.table.footer endRefreshing];
    }];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    //[self.view endEditing:YES];
    return [_telData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
  
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    
  
    

    
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, cell.height/2-10*self.scale, 10, 20*self.scale)];
    
    if ( [_telData[indexPath.row][@"shop_name"] isKindOfClass:[NSNull class]]) {
        name.text=@"";
        
   
    }else{
    
        name.text=_telData[indexPath.row][@"shop_name"];
      
    }
    
    

    name.font=DefaultFont(self.scale);
    [cell addSubview:name];
    [name sizeToFit];
    if (name.width>150) {
        name.width=150;
    }
    
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-30*self.scale, cell.height/2-10*self.scale, 20*self.scale, 20*self.scale)];
    img.image=[UIImage imageNamed:@"guan_tel"];
    [cell addSubview:img];

    
    UILabel *tel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/2, cell.height/2-10*self.scale, 10, 20*self.scale)];
    if ( [_telData[indexPath.row][@"hotline"] isEmptyString]) {
        tel.text=@"";
        img.hidden=YES;
        
    }else{
        
        tel.text=_telData[indexPath.row][@"hotline"];
        img.hidden=NO;
        
         }
    
    
    tel.font=DefaultFont(self.scale);
    [cell addSubview:tel];
    [tel sizeToFit];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell.bottom-.5, self.view.width, .5)];
    line.backgroundColor=blackLineColore;
    [cell addSubview:line];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_telData[indexPath.row][@"hotline"] isEqualToString:@""]) {
        return;
    }
    
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_telData[indexPath.row][@"hotline"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}

#pragma mark -----返回按钮
-(void)returnVi{
   //self.NavImg.hidden=YES;
    self.TitleLabel.text = @"常用电话";
    //self.title=@"社区常用电话";
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 44, 44);
//    backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -15, 0, 15);
//    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
//    [backBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
