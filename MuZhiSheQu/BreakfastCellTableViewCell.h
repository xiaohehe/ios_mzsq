//
//  BreakfastCellTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperTableViewCell.h"

@interface BreakfastCellTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *headImg,*addressImg,*addImg,*renZheng;
@property(nonatomic,strong)UILabel *titleLa,*contextLa,*addressLa,*distanceLa,*addLa,*scoreLa;
@property(nonatomic,strong)UIView *start,*SolidLine;
@property(nonatomic,strong)NSString *StartNumber;
@property(nonatomic,assign)BOOL isJin;
@end
