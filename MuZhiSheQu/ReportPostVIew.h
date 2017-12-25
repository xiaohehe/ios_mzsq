//
//  ReportPostVIew.h
//  MuZhiSheQu
//
//  Created by lt on 2017/10/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
#import "MBProgressHUD.h"

@interface ReportPostVIew : UIView<MBProgressHUDDelegate,UITextViewDelegate,PassValueDelegate>
@property (nonatomic,copy) NSString* title;
@property (weak, nonatomic) IBOutlet UITextField *contentTf;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;
@property(nonatomic,strong) MBProgressHUD* hud;
@property(nonatomic,copy) NSString* noticeid;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString*) title;

@end
