//
//  GuideViewController.m
//  Wedding
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GuideViewController.h"
#import "ChooseQuViewController.h"
@interface GuideViewController()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *ImgScrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)GuideBlock block;
@end
@implementation GuideViewController
-(id)initWithBlock:(GuideBlock)block
{
    self=[super init];
    if (self) {
        _block=block;
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self newNav];
    [self newView];
}
-(void)newView{
    NSArray *Arr=@[@"1.jpg",@"2.jpg",@"3.jpg"];
    _ImgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _ImgScrollView.backgroundColor=[UIColor clearColor];
    _ImgScrollView.delegate=self;
    _ImgScrollView.pagingEnabled=YES;
    _ImgScrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:_ImgScrollView];
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(self.view.width/2-100*self.scale, self.view.height-49*self.scale, 200*self.scale, 20*self.scale)];
    _pageControl.currentPageIndicatorTintColor=blueTextColor;
    _pageControl.pageIndicatorTintColor=[UIColor whiteColor];
    _pageControl.currentPage=0;
    _pageControl.numberOfPages=Arr.count;
    [_pageControl addTarget:self action:@selector(pageControlDidPageChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    
    for (int i=0; i<Arr.count; i++)
    {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.width, 0, self.view.width, self.view.height)];
        img.image=[UIImage imageNamed:[Arr objectAtIndex:i]];
        img.userInteractionEnabled=YES;
        img.contentMode=UIViewContentModeScaleAspectFill;
        [_ImgScrollView addSubview:img];
        _ImgScrollView.contentSize=CGSizeMake(img.right, self.view.height);
        if (i==Arr.count-1)
        {
            UIButton *EnterButton=[[UIButton alloc]initWithFrame:CGRectMake(40*self.scale,self.view.height-80*self.scale, self.view.width-80*self.scale, 31*self.scale)];
            [EnterButton setBackgroundImage:[UIImage setImgNameBianShen:@"yindao_btn"] forState:UIControlStateNormal];
             [EnterButton setBackgroundImage:[UIImage setImgNameBianShen:@"yindao_btn_b"] forState:UIControlStateHighlighted];
            [EnterButton setTitle:@"立即体验" forState:UIControlStateNormal];
            [EnterButton setTitleColor:[UIColor colorWithRed:225/255.0 green:111/255.0 blue:46/255.0 alpha:1] forState:UIControlStateNormal];
            EnterButton.titleLabel.font=DefaultFont(self.scale);
            [EnterButton addTarget:self action:@selector(EnterButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            if (self.view.height<568)
            {
                _pageControl.frame=CGRectMake(self.view.width/2-100*self.scale, self.view.height-39*self.scale, 200*self.scale, 20*self.scale);
                EnterButton.frame=CGRectMake(self.view.width/2-100*self.scale, self.view.height-75*self.scale, 200*self.scale, 31*self.scale);
            }
            [img addSubview:EnterButton];
        }
    }
    
}
-(void)EnterButtonEvent:(UIButton *)button{
    _block(YES);
//    ChooseQuViewController *choose = [[ChooseQuViewController alloc]initWithBlock:^(BOOL success) {
//        self.appdelegate.window.rootViewController=choose;
//        
//    }];
// 

    
}
#pragma mark - ScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point=[scrollView contentOffset];
    int n=(int)point.x/(scrollView.width);
    _pageControl.currentPage = n;
}
- (void) pageControlDidPageChanged
{
    CGRect frame = _ImgScrollView.frame;
    frame.origin.x = frame.size.width * _pageControl.currentPage;
    frame.origin.y = 0;
    [_ImgScrollView scrollRectToVisible:frame animated:YES];
}
#pragma mark - 导航
-(void)newNav{
    self.NavImg.hidden=YES;
}
@end
