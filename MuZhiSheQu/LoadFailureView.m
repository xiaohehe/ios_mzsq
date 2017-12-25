//
//  LoadFailureView.m
//  zk8
//
//  Created by lt on 2017/3/29.
//  Copyright © 2017年 zk8. All rights reserved.
//

#import "LoadFailureView.h"

@implementation LoadFailureView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"LoadFailure" owner:nil options:nil] lastObject];
        self.frame = frame;
        self.reloadBtn.clipsToBounds = YES;
        self.reloadBtn.layer.cornerRadius = 3;
        self.reloadBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.reloadBtn.layer.borderWidth = 1;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
