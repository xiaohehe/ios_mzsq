//
//  BreakInfoCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
#import "ShopModel.h"
#import "SuperViewController.h"
@protocol BreakInfoCellDelegate <NSObject>

//yes是加   no是减
-(void)BreakInfoCellChangeNumber:(NSNumber *)number IndexPath:(NSIndexPath *)index jiaAndJian:(BOOL)jiaAndJian;
@end
@interface BreakInfoCell : SuperTableViewCell<UIAlertViewDelegate>
@property(nonatomic,strong)UIImageView *headImg;
@property(nonatomic,strong)UILabel *titleLa,*salesLa,*priceLa,*numberLa;
@property(nonatomic,strong)UIButton *addBt,*jianBt;
@property (nonatomic,strong) ShopModel *shopModel;
@property(nonatomic,strong)UIView *SolidLine;

@property(nonatomic,strong)UILabel *price_yuan;//原价
@property(nonatomic,strong)UILabel *lin;
@property(nonatomic,strong)UIButton *selectBtn;//点击区域
@property(nonatomic,strong)UILabel *descriptionLab;

@property(nonatomic,strong)NSIndexPath *indexpath;
@property(nonatomic,assign)id<BreakInfoCellDelegate>delegate;

-(void)shopNumberClinck:(UIButton *)sender;
@end

