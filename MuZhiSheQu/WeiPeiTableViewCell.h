//
//  WeiPeiTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
#import "CellView.h"

@interface WeiPeiTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *headImg,*jiantouImg;
@property(nonatomic,strong)UILabel *nameLa,*states,*fuwuXiangMu,*xiaDanShiJian,*beizhu,*yuyueshijian,*fuwudizhi;
@property(nonatomic,strong)UIView *topLine,*botLine,*line;
@property(nonatomic,strong)UIButton *quedingshouhuo,*talkImg,*teleImg;
@property(nonatomic,strong)CellView *cell1,*cell2,*cell3;
@property(nonatomic,assign)float setY;

@property(nonatomic,strong)UIButton *cellBtn;
@end
