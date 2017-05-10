//
//  ShangJiaFenleiViewController.h
//  MuZhiSheQu
//
//  Created by apple on 17/2/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperViewController.h"

@interface ShangJiaFenleiViewController : SuperViewController

@property (nonatomic,strong)NSString * IdString;//记录商家的ID
@property (nonatomic,assign)NSInteger index;//记录加载的页数
@property (nonatomic,strong)NSMutableArray * dataArray;//记录数据用的数组
@property (nonatomic,retain)UITableView * shenghuoTableView;//用来展示商家产品的tableView


@property (nonatomic,retain)UILabel * showNothingLab;

@property(nonatomic,copy)void(^selectIndexRow)(NSDictionary *dic);

- (instancetype)initWithIdString:(NSString *)idStrng;//初始化方法
@end
