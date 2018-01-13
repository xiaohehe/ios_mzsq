//
//  LunBoWebViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"

@interface LunBoWebViewController : SuperViewController<UIWebViewDelegate>
@property(nonatomic,copy) NSString* url;
@end
