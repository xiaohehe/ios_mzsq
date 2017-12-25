//
//  Goods.h
//  MuZhiSheQu
//
//  Created by lt on 2017/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goods : NSObject
//{"id":"11921","shopid":"650","categoryid":"1246","prodname":"鸡蛋香松包","price":"1.00","unit":null,"description":null,"inventory":"100","salecount":"0","imgs":["http://img.mz.com//UpRes/AppRes/Product/20170927/603322ed8e046cc2f70e62b85e55f836.jpg"],"activityid":null,"isjoinact":null,"actmark":null,"actmaxbuy":null,"actmaxstock":null,"actmaxdaystock":null,"acticon":null}
@property(nonatomic,copy) NSString* gid;
@property(nonatomic,copy) NSString* shopid;
@property(nonatomic,copy) NSString* categoryid;
@property(nonatomic,copy) NSString* prodname;
@property(nonatomic,copy) NSString* price;
@property(nonatomic,copy) NSString* unit;
@property(nonatomic,copy) NSString* des;
@property(nonatomic,copy) NSString* inventory;
@property(nonatomic,copy) NSString* salecount;
@property(nonatomic,strong) NSMutableArray* imgs;
@property(nonatomic,copy) NSString* activityid;
@property(nonatomic,copy) NSString* isjoinact;
@property(nonatomic,copy) NSString* actmark;
@property(nonatomic,copy) NSString* actmaxbuy;
@property(nonatomic,copy) NSString* actmaxstock;
@property(nonatomic,copy) NSString* actmaxdaystock;
@property(nonatomic,copy) NSString* acticon;

@end
