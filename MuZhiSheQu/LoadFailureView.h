//
//  LoadFailureView.h
//  zk8
//
//  Created by lt on 2017/3/29.
//  Copyright © 2017年 zk8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadFailureView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *errorIv;
@property (weak, nonatomic) IBOutlet UIButton *reloadBtn;
@property (weak, nonatomic) IBOutlet UILabel *errorLb;
- (instancetype)initWithFrame:(CGRect)frame ;

@end
