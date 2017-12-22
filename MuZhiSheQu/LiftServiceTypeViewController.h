//
//  LiftServiceTypeViewController.h
//  MuZhiSheQu
//
//  Created by lt on 2017/8/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "ShangJiaTableViewCell.h"

@interface LiftServiceTypeViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate,ShangJiaTableViewCellDelegate>
@property(nonatomic,copy) NSString* type;
@property(nonatomic,copy) NSString* typeID;
@property (nonatomic,strong)NSMutableArray * dataArray;//记录数据用的数组
@property (nonatomic,assign)NSInteger index;//记录加载的页数
@property (nonatomic,retain)UILabel * showNothingLab;
@property(nonatomic,copy)void(^selectIndexRow)(NSDictionary *dic);

@end
