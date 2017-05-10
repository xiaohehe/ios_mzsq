//
//  LineView.m
//  AdultStore
//
//  Created by apple on 15/5/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LineView.h"
#include "DefaultPageSource.h"
@interface LineView()
@property(nonatomic,strong)UIImageView *blackLine;
@property(nonatomic,strong)UIImageView *whiteLine;
@end
@implementation LineView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self){
          [self initView];
    }
    return self;
}
-(id)init{
    self=[super init];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{
    _blackLine=[[UIImageView alloc]init];
    _blackLine.backgroundColor=[UIColor clearColor];
    [self addSubview:_blackLine];
    _whiteLine=[[UIImageView alloc]init];
    _whiteLine.backgroundColor=blackLineColore;
    [self addSubview:_whiteLine];
}
-(void)layoutSubviews{
    _blackLine.frame=CGRectMake(10, 0, self.width-20, self.height/2);
    _whiteLine.frame=CGRectMake(_blackLine.left, _blackLine.bottom, _blackLine.width, _blackLine.height);
}
@end
