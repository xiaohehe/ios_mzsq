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
       // [_DBCtl initHistoryDataBase];
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
    NSString *personSql = @"CREATE TABLE if not exists cart ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'shop_id' VARCHAR(50),'shop_name' VARCHAR(100),'shop_logo' VARCHAR(200),'free_delivery_amount' VARCHAR(50),'delivery_fee' VARCHAR(50),'add_time' INTEGER,'prod_id' VARCHAR(50),'prod_name' VARCHAR(100),'prod_des' VARCHAR(100),'prod_img' VARCHAR(200),'origin_price' VARCHAR(100),'price' VARCHAR(100),'unit' VARCHAR(50),'prod_count' INTEGER) ";
    [_db executeUpdate:personSql];
    if (![_db columnExists:@"prod_des" inTableWithName:@"cart"]){
        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ VARCHAR(100)",@"cart",@"prod_des"];
        [_db executeUpdate:alertStr];
    }
    // 初始化数据表
    NSString *historySql = @"CREATE TABLE if not exists history ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'keywords' VARCHAR(50),'add_time' INTEGER)";
    [_db executeUpdate:historySql];
    [_db close];
}

-(void)initHistoryDataBase{
    // 获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    // 初始化数据表
    NSString *historySql = @"CREATE TABLE if not exists history ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'keywords' VARCHAR(50),'add_time' INTEGER)";
    [_db executeUpdate:historySql];
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

/**
 *  更改搜索关键字
 *@param isAdd 1 添加购物车数量为1
 *       isAdd 0 购物车内数量-1
 *       isAdd -1 购物车内删除
 */
- (void)updateHistory:(NSString *)keywords{
    [_db open];
    FMResultSet *res=[_db executeQuery:@"SELECT keywords FROM history where keywords=?",keywords];
    if ([res next]) {
         [_db executeUpdate:@"UPDATE history SET add_time=?  WHERE keywords = ? ",@([self getTime]),keywords];
    }else{
         [_db executeUpdate:@"INSERT INTO history(keywords,add_time)VALUES(?,?)",keywords,@([self getTime])];
        [_db executeUpdate:@"DELETE FROM history WHERE keywords NOT IN (SELECT TOP 6 keywords FROM history  order by add_time desc)"];
    }
    [_db close];
}
/**
 *  获取所有搜索关键字数据
 *
 */
- (NSMutableArray*)getAllFromHistory{
    [_db open];
    NSMutableArray * hisArray=[NSMutableArray array];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM history order by add_time desc"];
    while ([res next]) {
        NSString* keywords=[res stringForColumn:@"keywords"];
        [hisArray addObject:keywords];
    }
    [_db close];
    return hisArray;
}

- (void)deleteCartWithProID:(NSMutableString*) proIDs{
    [_db open];
//    NSMutableString *fieldString = [NSMutableString string];
//    [fieldString appendString:@"DELETE FROM cart WHERE prod_id in ("];
//    for (NSString *pid in proIDs) {
//        [fieldString appendString:@"?,"];
//    }
//    [fieldString replaceCharactersInRange:NSMakeRange([fieldString length] -1,1)withString:@")"];
//    NSString *normalString = [NSString stringWithString:fieldString];
//     FMResultSet *ps = [shareDataBase executeQuery:normalString withArgumentsInArray:groups];
    //[_db executeUpdateWithFormat:@"DELETE FROM cart WHERE prod_id in (%@)",proIDs];
    [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM cart WHERE prod_id in (%@)",proIDs]];
    //[_db executeUpdate:@"DELETE FROM cart WHERE prod_id in (?)",proIDs];
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
        prod[@"delivery_free"] = [res stringForColumn:@"free_delivery_amount"];
        prod[@"pro_allnum"] = @([res intForColumn:@"prod_count"]);
        prod[@"shop_id"] = @([[res stringForColumn:@"shop_id"] integerValue]);
        prod[@"shop_name"] = [res stringForColumn:@"shop_name"];
        prod[@"pro_allnum"] = [res stringForColumn:@"prod_count"];
        prod[@"unit"] = [res stringForColumn:@"unit"];
        prod[@"pro_id"] = @([[res stringForColumn:@"prod_id"] integerValue]);
        prod[@"pro_cover"] = [res stringForColumn:@"prod_img"];
        prod[@"pro_name"] = [res stringForColumn:@"prod_name"];
        prod[@"pro_subname"] = [res stringForColumn:@"prod_des"];
        prod[@"pro_actprice"] = [res stringForColumn:@"origin_price"];
        prod[@"pro_price"] = [res stringForColumn:@"price"];
        if(dic){
            dic[@"amount"]=[NSString stringWithFormat:@"%.2f",[dic[@"amount"] floatValue]+[prod[@"pro_price"] floatValue]*[prod[@"pro_allnum"] integerValue]];
            [dic[@"prolist"] addObject:prod];
        }else{
            dic=[NSMutableDictionary dictionary];
            dic[@"shop_id"] = @([[res stringForColumn:@"shop_id"] integerValue]);
            dic[@"shop_name"] = [res stringForColumn:@"shop_name"];
            dic[@"delivery_free"] = [res stringForColumn:@"free_delivery_amount"];
            dic[@"delivery_fee"] = [res stringForColumn:@"delivery_fee"];
            dic[@"shop_icon"] = [res stringForColumn:@"shop_logo"];
            dic[@"amount"]=[NSString stringWithFormat:@"%.2f",[prod[@"pro_price"] floatValue]*[prod[@"pro_allnum"] integerValue]];
            dic[@"prolist"]=[NSMutableArray array];
            [dic[@"prolist"] addObject:prod];
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

- (NSArray*)getAllFromCart:(NSString*) sid{
    [_db open];
    NSMutableDictionary * shopDic=[NSMutableDictionary dictionary];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM cart where shop_id=?",sid];
    while ([res next]) {
        NSString* shopID=[res stringForColumn:@"shop_id"];
        NSMutableDictionary* dic=[shopDic objectForKey:shopID];
        NSMutableDictionary* prod=[NSMutableDictionary dictionary];
        prod[@"delivery_fee"]=[res stringForColumn:@"delivery_fee"];
        prod[@"delivery_free"] = [res stringForColumn:@"free_delivery_amount"];
        prod[@"pro_allnum"] = @([res intForColumn:@"prod_count"]);
        prod[@"shop_id"] = @([[res stringForColumn:@"shop_id"] integerValue]);
        prod[@"shop_name"] = [res stringForColumn:@"shop_name"];
        prod[@"pro_allnum"] = [res stringForColumn:@"prod_count"];
        prod[@"unit"] = [res stringForColumn:@"unit"];
        prod[@"pro_id"] = @([[res stringForColumn:@"prod_id"] integerValue]);
        prod[@"pro_cover"] = [res stringForColumn:@"prod_img"];
        prod[@"pro_name"] = [res stringForColumn:@"prod_name"];
        prod[@"pro_subname"] = [res stringForColumn:@"prod_des"];
        prod[@"pro_actprice"] = [res stringForColumn:@"origin_price"];
        prod[@"pro_price"] = [res stringForColumn:@"price"];
        if(dic){
            dic[@"amount"]=[NSString stringWithFormat:@"%.2f",[dic[@"amount"] floatValue]+[prod[@"pro_price"] floatValue]*[prod[@"pro_allnum"] integerValue]];
            [dic[@"prolist"] addObject:prod];
        }else{
            dic=[NSMutableDictionary dictionary];
            dic[@"shop_id"] = @([[res stringForColumn:@"shop_id"] integerValue]);
            dic[@"shop_name"] = [res stringForColumn:@"shop_name"];
            dic[@"delivery_free"] = [res stringForColumn:@"free_delivery_amount"];
            dic[@"delivery_fee"] = [res stringForColumn:@"delivery_fee"];
            dic[@"shop_icon"] = [res stringForColumn:@"shop_logo"];
            dic[@"amount"]=[NSString stringWithFormat:@"%.2f",[prod[@"pro_price"] floatValue]*[prod[@"pro_allnum"] integerValue]];
            dic[@"prolist"]=[NSMutableArray array];
            [dic[@"prolist"] addObject:prod];
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
