//
//  DataBase.m
//  FMDBDemo
//
//  Created by Zeno on 16/5/18.
//  Copyright © 2016年 zenoV. All rights reserved.
//

#import "DataBase.h"
#import "FMDB.h"
//#import <FMDB.h>
static DataBase *_DBCtl = nil;

@interface DataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
    
}




@end

@implementation DataBase

+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[DataBase alloc] init];
        
        [_DBCtl initDataBase];
        
    }
    
    return _DBCtl;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [super allocWithZone:zone];
        
    }
    
    return _DBCtl;
    
}

-(id)copy{
    
    return self;
    
}

-(id)mutableCopy{
    
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}

-(void)initDataBase{
    // 获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    // 初始化数据表
    NSString *personSql = @"CREATE TABLE if not exists cart ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'shop_id' VARCHAR(50),'shop_name' VARCHAR(100),'shop_logo' VARCHAR(200),'free_delivery_amount' VARCHAR(50),'delivery_fee' VARCHAR(50),'add_time' INTEGER,'prod_id' VARCHAR(50),'prod_name' VARCHAR(100),'prod_img' VARCHAR(200),'origin_price' VARCHAR(100),'price' VARCHAR(100),'unit' VARCHAR(50),'prod_count' INTEGER) ";
    [_db executeUpdate:personSql];
    [_db close];
}

#pragma mark - 接口
- (void)updateCart:(NSDictionary *)dic withType:(NSInteger) isAdd{
    [_db open];
    if(isAdd==-2){
        NSInteger count=[dic[@"number"] integerValue];
        if(count==0){
            [_db executeUpdate:@"DELETE FROM cart WHERE prod_id =?",dic[@"prod_id"]];
        }else if(count>0){
            [_db executeUpdate:@"UPDATE cart SET prod_count =? , add_time=?  WHERE prod_id = ? ",dic[@"number"],@([self getTime]),dic[@"prod_id"]];
        }
        [_db close];
        return;
    }
    NSInteger num=[self getProdNumByProdId:dic[@"prod_id"]];
    if(num==0){
        if(isAdd==1){//当购物车内没有时，添加一个
           [_db executeUpdate:@"INSERT INTO cart(shop_id,shop_name,shop_logo,free_delivery_amount,delivery_fee,add_time,prod_id,prod_name,prod_img,origin_price,price,unit,prod_count)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)",dic[@"shop_id"],dic[@"shop_name"],dic[@"shop_logo"],dic[@"free_delivery_amount"],dic[@"delivery_fee"],@([self getTime]),dic[@"prod_id"],dic[@"prod_name"],dic[@"img1"],dic[@"origin_price"],dic[@"price"],dic[@"unit"],@(1)];
        }
    }else if(num>0){
        if(isAdd==1){//当购物车已经有时，并且是增加的时候isAdd=1，数量增加一个
            [_db executeUpdate:@"UPDATE cart SET prod_count =? , add_time=?  WHERE prod_id = ? ",@(++num),@([self getTime]),dic[@"prod_id"]];
        }else if(isAdd==0){
            if(num==1){//当购物车已经有时，并且是减少的时候isAdd=0，数量为1时，直接删除
                [_db executeUpdate:@"DELETE FROM cart WHERE prod_id =?",dic[@"prod_id"]];
            }else{//当购物车已经有时，并且是减少的时候isAdd=0，数量大于1时，数量减1
                [_db executeUpdate:@"UPDATE cart SET prod_count =? , add_time=?  WHERE prod_id = ? ",@(--num),@([self getTime]),dic[@"prod_id"]];
            }
        }else if(isAdd==-1){//当购物车已经有时，并且是清除的时候isAdd=-1，直接删除
            [_db executeUpdate:@"DELETE FROM cart WHERE prod_id =?",dic[@"prod_id"]];
        }
    }
    [_db close];
}

- (void)deleteCartWithShopID:(NSString*) shopID{
    [_db open];
    [_db executeUpdate:@"DELETE FROM cart WHERE shop_id=?",shopID];
    [_db close];
}

-(NSInteger)getProdCountByProdId:(NSString*) prodId{
    [_db open];
    FMResultSet *res=[_db executeQuery:@"SELECT prod_count FROM cart where prod_id=?",prodId];
    while ([res next]) {
        NSInteger count=[res intForColumn:@"prod_count"];
        [_db close];
        return count;
    }
    [_db close];
    return 0;
}

-(NSInteger)getProdNumByProdId:(NSString*) prodId{
    FMResultSet *res=[_db executeQuery:@"SELECT prod_count FROM cart where prod_id=?",prodId];
    while ([res next]) {
        return [res intForColumnIndex:0];
    }
    return 0;
}

//购物车价格
- (double)sumCartPrice{
    [_db open];
    FMResultSet *res=[_db executeQuery:@"SELECT SUM(prod_count) FROM cart"];
    double count=[res doubleForColumnIndex:0];
    [_db close];
    return count;
}

//购物车数量
- (NSInteger)sumCartNum{
    [_db open];
    FMResultSet *res=[_db executeQuery:@"SELECT SUM(prod_count) FROM cart"];
    NSInteger count=[res intForColumnIndex:0];
    [_db close];
    return count;
}

//清理插入时间大于两小时的
- (void)clearHistoryCart{
    [_db open];
    FMResultSet *res=[_db executeQuery:@"SELECT COUNT(*) FROM cart"];
    if([res next])
        [_db executeUpdate:@"DELETE FROM cart WHERE add_time<?",@([self getTime]-60*60*2)];
    [_db close];
}

- (void)clearCart{
    [_db open];
    [_db executeUpdate:@"DELETE FROM cart"];
    [_db close];
}

- (NSArray*)getAllFromCart{
    [_db open];
    NSMutableDictionary * shopDic=[NSMutableDictionary dictionary];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM cart"];
    while ([res next]) {
        NSString* shopID=[res stringForColumn:@"shop_id"];
        NSMutableDictionary* dic=[shopDic objectForKey:shopID];
        NSMutableDictionary* prod=[NSMutableDictionary dictionary];
        prod[@"delivery_fee"]=[res stringForColumn:@"delivery_fee"];
        prod[@"free_delivery_amount"] = [res stringForColumn:@"free_delivery_amount"];
        prod[@"prod_count"] = @([res intForColumn:@"prod_count"]);
        prod[@"shop_id"] = @([[res stringForColumn:@"shop_id"] integerValue]);
        prod[@"shop_name"] = [res stringForColumn:@"shop_name"];
        prod[@"prod_count"] = [res stringForColumn:@"prod_count"];
        prod[@"unit"] = [res stringForColumn:@"unit"];
        prod[@"prod_id"] = @([[res stringForColumn:@"prod_id"] integerValue]);
        prod[@"prod_img1"] = [res stringForColumn:@"prod_img"];
        prod[@"prod_name"] = [res stringForColumn:@"prod_name"];
        prod[@"origin_price"] = [res stringForColumn:@"origin_price"];
        prod[@"price"] = [res stringForColumn:@"price"];
        if(dic){
            dic[@"amount"]=[NSString stringWithFormat:@"%.2f",[dic[@"amount"] floatValue]+[prod[@"price"] floatValue]*[prod[@"prod_count"] integerValue]];
            [dic[@"prod_info"] addObject:prod];
        }else{
            dic=[NSMutableDictionary dictionary];
            dic[@"shop_id"] = @([[res stringForColumn:@"shop_id"] integerValue]);
            dic[@"shop_name"] = [res stringForColumn:@"shop_name"];
            dic[@"free_delivery_amount"] = [res stringForColumn:@"free_delivery_amount"];
            dic[@"delivery_fee"] = [res stringForColumn:@"delivery_fee"];
            dic[@"logo"] = [res stringForColumn:@"shop_logo"];
            dic[@"amount"]=[NSString stringWithFormat:@"%.2f",[prod[@"price"] floatValue]*[prod[@"prod_count"] integerValue]];
            dic[@"prod_info"]=[NSMutableArray array];
            [dic[@"prod_info"] addObject:prod];
           // [shopDic setObject:dic forKey:shopID];
        }
        [shopDic setObject:dic forKey:shopID];
     //   person.name = [res stringForColumn:@"person_name"];
     //   person.age = [[res stringForColumn:@"person_age"] integerValue];
     //   person.number = [[res stringForColumn:@"person_number"] integerValue];
    }
    [_db close];
    return [shopDic allValues];
}

-(NSInteger) getTime{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    return (int)a;
}

@end
