//
//  SouListCell.h
//  MuZhiSheQu
//
//  Created by lmy on 2016/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface SouListCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *headImg,*line;
@property(nonatomic,strong)UILabel *titleLa,*salesLa,*priceLa,*desLa,*addLa,*noMiaoShuShopName,*ShopName;
@property(nonatomic,assign)BOOL isShort;
@property(nonatomic,strong)UILabel *price_yuan;//原价
@property(nonatomic,strong)UILabel *lin;

@end
