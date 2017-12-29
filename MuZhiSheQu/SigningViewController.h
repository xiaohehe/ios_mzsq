//
//  SigningViewController.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperViewController.h"

@interface SigningViewController : SuperViewController<UIWebViewDelegate>
@property(nonatomic,copy) NSString* url;
@property(nonatomic,assign)BOOL isToRoot;
@end
