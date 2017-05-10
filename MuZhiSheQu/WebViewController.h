//
//  WebViewController.h
//  LunTai
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "SuperViewController.h"
typedef enum
{
    WebTypeContent=0,
    WebTypeURL,
    WebTypeID,
} WebViewType;
@interface WebViewController : SuperViewController
@property(nonatomic,assign)WebViewType webType;
@property(nonatomic,strong)NSString *Content;
@property(nonatomic,strong)NSString *NavTitle;
@property(nonatomic,assign)BOOL isPush;
@end
