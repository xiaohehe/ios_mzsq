//
//  AddressTableViewCell.h
//  MuZhiSheQu
//
//  Created by lt on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface AddressTableViewCell : SuperTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *defIv;
@property (weak, nonatomic) IBOutlet UILabel *addrLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *mobileLb;

@end
