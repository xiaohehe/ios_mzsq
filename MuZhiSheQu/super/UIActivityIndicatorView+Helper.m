//
//  UIActivityIndicatorView+Helper.m
//  HuanXin
//
//  Created by apple on 14-12-26.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "UIActivityIndicatorView+Helper.h"

@implementation UIActivityIndicatorView (Helper)

-(id)initWithView:(UIView *)view{
    self=[super init];
    if (self)
    {
        self.frame=view.frame;
//        self.backgroundColor
        //self.backgroundColor=[UIColor blackColor];
       // self.alpha=0.6;
        self.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    }
    return self;
}
-(void)startAnimate
{
    [self startAnimating];
}

-(void)stopAnimate{
    [self stopAnimating];
    //UIWindow *window = [[UIApplication sharedApplication].delegate window];
   // window.userInteractionEnabled=YES;
}
@end
