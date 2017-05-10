//
//  ScrollViewController.h
//  XiaoYuanJianZhi
//
//  Created by mac on 16/2/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SuperViewController.h"
#import "MRZoomScrollView.h"



@interface ScrollViewController : SuperViewController
<UIScrollViewDelegate>

 
typedef void(^ScrollVBlock)(NSString *str);


@property (nonatomic,assign)int index;

@property (nonatomic,strong)NSArray *imgArr;

@property (nonatomic, retain) UIScrollView      *scrollView;

@property (nonatomic, retain) MRZoomScrollView  *zoomScrollView;

- (void)newScrollV;
- (void)getScrollVBlock:(ScrollVBlock)block;

@end
