//
//  DataBase.h
//  FMDBDemo
//
//  Created by Zeno on 16/5/18.
//  Copyright © 2016年 zenoV. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Person;
@class Car;



@interface DataBase : NSObject

@property(nonatomic,strong) NSDictionary *dic;


+ (instancetype)sharedDataBase;

#pragma mark - Person
/**
 *  更改购物车
 *@param isAdd 1 添加购物车数量为1
 *       isAdd 0 购物车内数量-1
 *       isAdd -1 购物车内删除
 */
- (void)updateCart:(NSDictionary *)dic withType:(NSInteger) isAdd;
/**
 *  更改搜索关键字
 *@param isAdd 1 添加购物车数量为1
 *       isAdd 0 购物车内数量-1
 *       isAdd -1 购物车内删除
 */
- (void)updateHistory:(NSString *)keywords ;
/**
 *  获取所有搜索关键字数据
 *
 */
- (NSMutableArray*)getAllFromHistory;
/**
 *  获得当前商品的数量
 *@param prodId 商品ID
 */
-(NSInteger)getProdCountByProdId:(NSString*) prodId;
/**
 *  求购物车商品价格
 */
- (double)sumCartPrice;
/**
 *  求购物车商品数量
 */
- (NSInteger)sumCartNum;
/**
 * 清理插入时间大于两小时的
 *
 */
- (void)clearHistoryCart;
/**
 *  下单后购物车清空对应商品的购物车
 *
 */
- (void)deleteCartWithProID:(NSMutableString*) proIDs;
/**
 *  下单后清空该商店的购物车
 *
 */
- (void)deleteCartWithShopID:(NSString*) shopID;
/**
 *  下单后清空购物车
 *
 */
- (void)clearCart;

/**
 *  获取所有数据
 *
 */
- (NSArray*)getAllFromCart;
/**
 *  获取所有数据
 *
 */
- (NSArray*)getAllFromCart:(NSString*) sid;
@end
