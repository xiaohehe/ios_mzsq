//
//  ReportPostVIew.m
//  MuZhiSheQu
//
//  Created by lt on 2017/10/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ReportPostVIew.h"
#import "AppUtil.h"
#import "AnalyzeObject.h"
#import "Stockpile.h"

@implementation ReportPostVIew

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString*) title{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"ReportPostVIew" owner:nil options:nil] lastObject];
        self.frame = frame;
        self.title=title;
        self.contentTf.delegate=(id)self;
        self.backgroundColor =[UIColor clearColor];
        self.titleLb.text=self.title;
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGRect frame = self.contentTf.frame;
    int offset = frame.origin.y + 150 - (self.frame.size.height - height);//iPhone键盘高度216，iPad的为352
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.5f];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.frame = CGRectMake(0.0f, -offset, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    // 获取通知信息字典
    NSDictionary* userInfo = [aNotification userInfo];
    // 获取键盘隐藏动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGRect frame = self.frame;
    frame.origin.y = 0;
    self.frame = frame;
}

- (IBAction)cancel:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //self.backgroundColor =[UIColor clearColor];
    [self.contentTf resignFirstResponder];
    [UIView animateWithDuration:0.5  animations:^{
        self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
    }];
    [self removeFromSuperview];
}

- (IBAction)send:(id)sender {
    if ([_contentTf.text isEqualToString:@""]) {
        [AppUtil showToast:self withContent:@"请输入信息"];
        return;
    }
    if (_contentTf.text.length>200) {
        [AppUtil showToast:self withContent:@"最多只能输入200个字符"];
        return;
    }
    if(self.hud==nil){
        self.hud=[[MBProgressHUD alloc]initWithView:self];
        [AppUtil showProgressDialog:self.hud withContent:@"正在发送"];
        [self addSubview:self.hud];
    }else{
        [self.hud hide:NO];
    }
    if([_title isEqualToString:@"评论"]){
        [self commentOn];
    }else{
        [self reportPost];
    }
}

-(void) reportPost{
    AnalyzeObject *nale = [AnalyzeObject new];
    NSDictionary *dic = @{@"content":_contentTf.text,@"noticeid":self.noticeid};
    [nale noticeReport:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.hud hide:YES];
        if ([code isEqualToString:@"0"]) {
            //
            [self.delegate passValue: [[NSArray alloc] initWithObjects:@"reportPost",dic,nil]];
            [self removeFromSuperview];
        }else{
            [AppUtil showToast:self withContent:msg];
        }
    }];
}

-(void) commentOn{
    AnalyzeObject *nale = [AnalyzeObject new];
    NSDictionary *dic = @{@"content":_contentTf.text,@"noticeid":self.noticeid};
    [nale NoticeWallcommentWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.hud hide:YES];
        if ([code isEqualToString:@"0"]) {
            //[AppUtil showToast:self withContent:msg];
            NSMutableDictionary* dic=[NSMutableDictionary dictionary];
            [dic setObject:_contentTf.text forKey:@"content"];
            [dic setObject:[AppUtil getCurrentTime] forKey:@"create_time"];
            [dic setObject:[Stockpile sharedStockpile].logo forKey:@"avatar"];
            [dic setObject:[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].nickName] forKey:@"user_name"];
            [self.delegate passValue: [[NSArray alloc] initWithObjects:@"commentOn",dic,nil]];
            [self removeFromSuperview];
        }else{
            [AppUtil showToast:self withContent:msg];
        }
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请输入内容，不超过200个字";
        textView.textColor = [UIColor grayColor];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入内容，不超过200个字"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}

@end
