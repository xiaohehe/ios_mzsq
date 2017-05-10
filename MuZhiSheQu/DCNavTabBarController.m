//
//  ViewController.m
//  父子控制器
//
//  Created by 戴川 on 16/6/3.
//  Copyright © 2016年 戴川. All rights reserved.
//

#import "DCNavTabBarController.h"
#import "UIViewAdditions.h"
#import "UIColor+Hex.h"
#import "DefaultPageSource.h"

#define DCScreenW    [UIScreen mainScreen].bounds.size.width
#define DCScreenH    [UIScreen mainScreen].bounds.size.height

@interface DCNavTabBarController ()<UIScrollViewDelegate>
{
    float scale;
    float btnH;
}
@property (nonatomic, weak) UIButton *oldBtn;
@property(nonatomic,strong)NSArray *VCArr;
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, weak) UIScrollView *topBar;
@property(nonatomic,assign) CGFloat btnW ;
@property(nonatomic,strong)NSMutableArray *btnWArr;
@property (nonatomic, weak) UIView *slider;


@end

@implementation DCNavTabBarController
-(UIColor *)sliderColor
{
    if(_sliderColor == nil)
    {
        _sliderColor = [UIColor colorWithRed:0 green:134/255.0 blue:237/255.0 alpha:1];
    }
    return  _sliderColor;
}
-(UIColor *)btnTextNomalColor
{
    if(_btnTextNomalColor == nil)
    {
        _btnTextNomalColor = [UIColor blackColor];
    }
    return _btnTextNomalColor;
}
-(UIColor *)btnTextSeletedColor
{
    if(_btnTextSeletedColor == nil)
    {
        _btnTextSeletedColor = [UIColor colorWithRed:116/255.0 green:169/255.0 blue:9/255.0 alpha:1];
    }
    return _btnTextSeletedColor;
}
-(UIColor *)topBarColor
{
    if(_topBarColor == nil)
    {
        _topBarColor = [UIColor whiteColor];
    }
    return _topBarColor;
}
-(instancetype)initWithSubViewControllers:(NSArray *)subViewControllers
{
    if(self = [super init])
    {
        _VCArr = subViewControllers;
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    btnH=0;
    _btnWArr = [NSMutableArray new];
    scale=1.0;
    if ([[UIScreen mainScreen] bounds].size.height > 480)
    {
        scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
    }

    //添加上面的导航条
    [self addTopBar];
    
    //添加子控制器
    [self addVCView];
    
    //添加滑块
    [self addSliderView];
    
    


}
-(void)addSliderView
{
    if(self.VCArr.count == 0) return;

    UIView *slider = [[UIView alloc]init];
    slider.backgroundColor = self.btnTextSeletedColor;
    [self.topBar addSubview:slider];
    self.slider = slider;
    UIButton *btn = (UIButton *)[self.view viewWithTag:10000];
//    self.slider.frame=CGRectMake(btn.left+15*scale, 40*scale-2, btn.width , 2);
    self.slider.center = CGPointMake(btn.centerX, 40*scale-1);
    self.slider.bounds = CGRectMake(0, 0, btn.width, 2);
    
    
}
-(void)addTopBar
{
    if(self.VCArr.count == 0) return;
    NSUInteger count = self.VCArr.count;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DCScreenW, 40*scale)];
    scrollView.backgroundColor = [UIColor whiteColor];
//    scrollView.delegate=self;
    self.topBar = scrollView;
//    self.topBar.bounces = NO;
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:self.topBar];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, scrollView.bottom-.5, self.view.width, .5)];
    line.backgroundColor=[UIColor colorWithHexString:@"#E5E5E5"];
    [self.view addSubview:line];
    
//    UILabel * hLab = [[UILabel alloc]initWithFrame:CGRectMake(0, scrollView.bottom - 15, self.view.width, 15)];
//    hLab.backgroundColor =[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
//    [scrollView addSubview:hLab];
    
//    if(count <= 4)
//    {
//         self.btnW = DCScreenW / count;
//    }else
//    {
//
//    }
    self.btnW = DCScreenW / 5.0;
    //添加button
    
    float setX =0*scale;
    
    for (int i=0; i<count; i++)
    {
        UIViewController *vc = self.VCArr[i];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i%count*self.btnW, 0, self.btnW, 35*scale)];
        btn.tag = 10000+i;

        [btn setTitleColor:[UIColor colorWithHexString:@"#9E9E9E"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        btn.titleLabel.font=[UIFont systemFontOfSize:13*scale];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//        btn.backgroundColor = [UIColor redColor];
        
//        [btn sizeToFit];
//        btn.height=35*scale;
////        btn.width=btn.width+20*scale;
//        btn.width = btn.width;
        setX = btn.right;
        
        [_btnWArr addObject:btn];
        
        btnH = btnH+btn.width+20*scale;
        
        [self.topBar addSubview:btn];
        if(i == 0)
        {
            btn.selected = YES;
            //默认one文字放大
//            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.oldBtn = btn;

        }
    }
    self.topBar.contentSize = CGSizeMake(setX+44*scale, -64);
}
-(void)addVCView
{
    
    
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40*scale, DCScreenW, DCScreenH - 40*scale)];
    self.contentView = contentView;
    self.contentView.bounces = NO;
    contentView.delegate = self;
    contentView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:contentView];
    
    NSUInteger count = self.VCArr.count;
    for (int i=0; i<count; i++) {
        UIViewController *vc = self.VCArr[i];
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(i*DCScreenW, 0, DCScreenW, DCScreenH -44*scale);
        [contentView addSubview:vc.view];
    }
    contentView.contentSize = CGSizeMake(count*DCScreenW, DCScreenH-44*scale);
    contentView.pagingEnabled = YES;
}
-(void)click:(UIButton *)sender
{
    if(sender.selected) return;
    self.oldBtn.selected = NO;
    sender.selected = YES;
    self.contentView.contentOffset = CGPointMake((sender.tag - 10000)*DCScreenW, 0);
    [UIView animateWithDuration:0.3 animations:^{
//        sender.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
//        self.oldBtn.transform = CGAffineTransformIdentity;
    }];
    
    self.oldBtn = sender;
    
    CGFloat width = 0;
    NSInteger j=sender.tag - 10000;
    for (int i=1; i<_btnWArr.count - 4; i++)
    {

        if (j == _btnWArr.count - 1)
        {
            j = j - 1;
            
        }
        width = (j+1)/(4+i)*[UIScreen mainScreen].bounds.size.width/5+width;
    }
    float w = self.oldBtn.left-(self.oldBtn.width/2)-60*scale;
    
    float offsetFloat = self.topBar.contentSize.width - self.topBar.bounds.size.width;
    
    if (w<0) {
        w=0;
    }
    if (w>offsetFloat) {
        w = self.topBar.contentSize.width - self.topBar.bounds.size.width;
    }

    [UIView animateWithDuration:0.3 animations:^{
            self.topBar.contentOffset = CGPointMake(width, 0);
    }];

    
    [UIView animateWithDuration:.3 animations:^{
        
//        self.slider.frame = CGRectMake(self.oldBtn.left+15*scale , 40*scale -2, self.oldBtn.width-30*scale, 2);
        self.slider.center = CGPointMake(self.oldBtn.centerX, 40*scale-1);
        self.slider.bounds = CGRectMake(0, 0, self.oldBtn.width, 2);
        
    }];

    
}





-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    滑动导航条
    
//    self.slider.frame=CGRectMake(btn.left+15*scale, 34*scale, btn.width-30*scale, 1);
    
    
//    int pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
//    float pageNumfloat = scrollView.contentOffset.x / scrollView.frame.size.width;
//
//    if (pageNumfloat>pageNum) {
//        pageNum++;
//    }
////    NSLog(@"%f  ---  %d",pageNumfloat,pageNum);
//    
//    UIButton *btn = _btnWArr[pageNum];
//    
//    
//    [UIView animateWithDuration:.3 animations:^{
//        
//        self.slider.frame = CGRectMake(btn.left+15*scale , 34*scale, btn.width-30*scale, 1);
//
//    }];
    
    
    
//    UIButton *btn = (UIButton *)[self.view viewWithTag:<#(NSInteger)#>];
//    
//    self.slider.frame=CGRectMake(btn.left+15*scale, 34*scale, btn.width-30*scale, 1);

}
//判断是否切换导航条按钮的状态
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offX =  scrollView.contentOffset.x;
   int pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (_blockNum) {
        _blockNum(pageNum++);
    }
    
    int tag = (int)(offX /DCScreenW + 0.5) + 10000;
    UIButton *btn = [self.view viewWithTag:tag];
    if(tag != self.oldBtn.tag)
    {
        [self click:btn];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
