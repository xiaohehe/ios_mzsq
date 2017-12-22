//
//  InviteFamilyMembersViewController.h
//  MuZhiSheQu
//
//  Created by lt on 2017/12/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "PassValueDelegate.h"

@interface InviteFamilyMembersViewController : SuperViewController<UITextFieldDelegate>
@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;
@property(nonatomic,copy) NSString* fid;
@end
