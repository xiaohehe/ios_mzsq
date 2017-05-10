//
//  MyPageControl.m
//  MuZhiSheQu
//
//  Created by apple on 17/3/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyPageControl.h"

@implementation MyPageControl
-(id) initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    

    
    
    return self;
    
}


//-(void)updateDots
//
//{
//    for (int i=0; i<[self.subviews count]; i++) {
//        
//        UIImageView* dot = (UIImageView *)[self.subviews objectAtIndex:i];
//        
//        CGSize size;
//        
//        size.height = 20;     //自定义圆点的大小
//        
//        size.width = 20;      //自定义圆点的大小
//        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
//        if (i==self.currentPage)
//        {
//            dot.image=activeImage;
//        }
//        
//        else
//        {
//         dot.image=inactiveImage;
//        }
//    }
//    
//}

- (void) setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = (UIImageView *)[self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 7;
        size.width = 7;
        [subview setFrame:CGRectMake(subview.frame.origin.x , subview.frame.origin.y,
                                     size.width,size.height)];
        if (subview)
        {
            for (NSInteger i = 0; i<[subview.subviews count]; i++)
            {
                UIImageView * imageView = [subview.subviews objectAtIndex:i];
                [imageView removeFromSuperview];
            }
            UIImageView * imageview = [[UIImageView alloc]initWithFrame:subview.bounds];
            imageview.clipsToBounds = YES;
            imageview.layer.cornerRadius = imageview.frame.size.width/2;
            [subview addSubview:imageview];
            if (subviewIndex == page)
            {
                //            [subview setImage:[UIImage imageNamed:@"ioc3"]] ;
                imageview.backgroundColor = [UIColor colorWithRed:116/255.0 green:169/255.0 blue:9/255.0 alpha:1];
                
            }
            else
            {
                imageview.backgroundColor = [UIColor grayColor] ;
                
            }
        }
       
//        [subview setImage:[UIImage imageNamed:@"ioc4"]];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
