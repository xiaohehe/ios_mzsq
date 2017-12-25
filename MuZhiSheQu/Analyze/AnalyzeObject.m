//
//  AnalyzeObject.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AnalyzeObject.h"
#import "AFAppDotNetAPIClient.h"
#import "Stockpile.h"
#import "AppDelegate.h"
#import "NSStringMD5.h"

@implementation AnalyzeObject


/*
 *邻里圈(新增)
 *2017-10-24
 新增：GetNoticeWall
 */
-(void)getNoticeWall:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetNoticeWall" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

/*
 *社区公告(新增)
 *2017-10-24
 新增：GetCommunityNoticeList
 */
-(void)getCommunityNoticeList:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetCommunityNoticeList" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

/*
 *获取验证码
 *2017-10-09
 新：getVerifyCode
 老：User/getVerifyCodeV2
 */
-(void)getyanzhengma:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"getVerifyCode" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
    }];
}

-(void)mu_zhi_adwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient] GET:@"Carousel/slider" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"lb_param==%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        //block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
    }];
}
-(void)shouYeFenLei:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Home/getSelectionClass" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"shouYeFenLei_param==%@",[self getParamWithToken:dic]);

        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil,nil,nil);
        
    }];
    
    
}


-(void)getRetailShopList:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    
    
    
//    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=ProfessionClass.getRetailShopListV2" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSNumber *retn = [responseObject objectForKey:@"ret"];
//        NSString *ret = [NSString stringWithFormat:@"%@",retn];
//        
//        if ([ret isEqualToString:@"200"]) {
//            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
//            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
//            if ([code isEqualToString:@"0"]) {
//                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
//            }else{
//                block(nil,code,msg);
//            }
//        }else{
//            block(nil,nil,nil);
//        }
//        
//
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        block(nil,nil,nil);
//
//        
//    }];
    
    
    NSLog(@"param====%@",[self getParamWithToken:dic]);

    
    [[AFAppDotNetAPIClient sharedClient] GET:@"ProfessionClass/getRetailShopListV2" parameters:[self getParamWithToken:dic]  progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        NSLog(@"getRetailShopList====%@",responseObject);

        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,nil,nil);

    }];
    
    /*
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=ProfessionClass.getRetailShopListV2" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }

        
//        
//        NSNumber *retn = [responseObject objectForKey:@"ret"];
//        NSString *ret = [NSString stringWithFormat:@"%@",retn];
//        
//        
//        NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
//        NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
//        if ([code isEqualToString:@"0"]) {
//            block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
//        }else{
//            block(nil,code,msg);
//        }
//
        
      //  block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
    }];
     */

}


-(void)getServShopListwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{

#pragma mark===--v2去掉了
    
    [[AFAppDotNetAPIClient sharedClient]GET:@"ProfessionClass/getServShopList" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }

        
        
        
        
//        NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
//        NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
//        
        
//        block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        

    }];

}

-(void)queryShopByKeyAndProwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]GET:@"Shop/queryShopByKeyAndPro" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
//        NSLog(@"*********%@",responseObject[@"data"][@"msg"]);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        

    }];

}

-(void)getWeiShopListwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]GET:@"ProfessionClass/getWeiShopListV2" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);

        
    }];



}
/*产品分类
 *2017-10-16
 新：GetShopProductCategoryList
 老：Shop/getRetailShopClass
 */
-(void)getRetailShopClasswithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
//    AFAppDotNetAPIClient *af = [AFAppDotNetAPIClient sharedClient];
//    af.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    [af.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    af.requestSerializer.timeoutInterval = 5.f;
//    [af.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    [af POST:@"?service=Shop.getRetailShopClass" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"成功");
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"失败");
//    }];
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetShopProductCategoryList" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        //SLog(@"getProdListByClasswithDic==%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
    }];
}

-(void)getRetailShopClassPushwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    //    AFAppDotNetAPIClient *af = [AFAppDotNetAPIClient sharedClient];
    //    af.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //    [af.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    //    af.requestSerializer.timeoutInterval = 5.f;
    //    [af.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //    [af POST:@"?service=Shop.getRetailShopClass" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
    //        NSLog(@"成功");
    //    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    //        NSLog(@"失败");
    //    }];
    [[AFAppDotNetAPIClient sharedClient]GET:@"Shop/queryShopDetail" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

/*产品分类
 *2017-10-16
 新：GetShopProductList
 老：Shop/getProdListByClass
 */
-(void)getProdListByClasswithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetShopProductList" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
    }];
}

/**
 *逛街(新增)
 *2017-12-01
 */
-(void)windowShopping:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetProShopList" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

-(void)getprodDetailwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Product/prodDetail" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
         NSLog(@"getprodDetailwithDic===%@===%@",[self getParamWithToken:dic],responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);

        
    }];
}

/*商品详情
 *2017-10-13
 新：GetShopProdDetail
 老：Product/prodDetailV2
 */
-(void)getprodDetailPushwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetShopProdDetail" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"getprodDetailPushwithDic%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

-(void)queryShopDetailPushwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
       [[AFAppDotNetAPIClient sharedClient]GET:@"Product/prodDetailV2" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
    }];
}

/*商家详情
 *2017-12-02
 新：GetShopDetail
 老：Shop/queryShopDetail
 */
-(void)queryShopDetailwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetShopDetail" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

-(void)commentListwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Comment/commentList" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
    }];
}

-(void)getNoticeListwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"User/getNoticeList" parameters:[self getParamWithToken:dic]  success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
    }];
}


-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else { 
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } 
    return jsonString; 
}
#pragma mark - --------- 个人中心 ---------
#pragma mark - 用户登录接口
/**
 *用户登录接口
 */
-(void)userLoginWithTel:(NSString *)mobile  Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"User/userLogin" parameters:[NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",@"4",@"type", nil] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"login param==%@==%@",[NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",@"4",@"type", nil],[self DataTOjsonString:responseObject]);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
    }];
}


-(void)userLoginWithTelAndCode:(NSString *)mobile andCode:(NSString*) code Block:(void(^)(id models, NSString *code ,NSString * msg))block{//
    [[AFAppDotNetAPIClient sharedClient]GET:@"User/userLogin" parameters:[NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",code,@"code", nil] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"login param==%@==%@",[NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",@"4",@"type", nil],[self DataTOjsonString:responseObject]);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}
/**
 *用户登录接口
 2017-10-09
 新：Login
 老：User/userLogin
 */
-(void)userLogin:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Login" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"login param==%@",[self DataTOjsonString:responseObject]);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}



-(void)addProdWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Cart/addProd" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
    }];
}

-(void)showCartWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    
    [[AFAppDotNetAPIClient sharedClient]GET:@"Cart/showCart" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"shopingcart==%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        
    }];
}


-(void)getShopClassListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    
    [[AFAppDotNetAPIClient sharedClient]GET:@"ProfessionClass/getShopClassList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        
    }];
}

-(void)queryShopByKeyWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Shop/queryShopByKey" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
    }];

}

-(void)clearCartWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Cart/clearCart" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
                if([code isEqualToString:@"-1"])
                    [self clearUserInfo];
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
    }];
}

/**
 *订单提交(这个没变)
 *2017-11-07
 */
-(void)OrdersubmitWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    NSLog(@"OrdersubmitWithDic==%@",[self getURLWithParam:@"Order/submit"]);
    [[AFAppDotNetAPIClient sharedClient]POST:[self getURLWithParam:@"Order/submit"] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            
            NSLog(@"%@",responseObject);
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];

}

-(void)delProdInCartWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Cart/delProdInCart" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];
}

-(void)serveShopSubmitWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Order/serveShopSubmit" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];
}

/*
 *用户地址
 2017-10-18
 新：GetUserAddressList
 老：User/getAddressList
 */
-(void)getAddressListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetUserAddressList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"getAddressListWithDic==%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/*
 *UserAddressUp 
 2017-10-18
 新：UserAddressUp
 老：User/updAddress
 */
-(void)addAddressWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:[self getURLWithParam:@"UserAddressUp"] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}
/*设置默认收货地址
 2017-10-17
 新：UserAddressSetDefault
 老：User/setDefaultAddress
 */
-(void)setDefaultAddressWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"UserAddressSetDefault" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"setDefaultAddressWithDic==%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

-(void)kucun:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Product/checkProd" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/*常购列表
 2017-10-20
 新：GetUserCollectList
 老：User/getCollectList
 */
-(void)getCollectListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetUserCollectList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

-(void)getNoticeListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"User/getCollectList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];
}


-(void)myOrderListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]GET:@"Order/myOrderList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];

}


-(void)myServeOrderListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Order/myServeOrderList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];
}

/*删除收货地址
 2017-10-19
 新：UserAddressDel
 老：User/delAddress
 */
-(void)delAddressWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"UserAddressDel" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/*
 *邻里杂谈
 *2017-10-25
 新：GetNoticeList
 老：NoticeWall/getNoticeListV2
 */
-(void)getNoticeListwallWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetNoticeList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}
/*
 *邻里杂谈详情
 *2017-10-31
 新：GetNoticeDetail
 老：NoticeWall/noticeDetail
 */
-(void)noticeDetailWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetNoticeDetail" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"noticeDetailWithDic==%@==%@",dic,responseObject);

        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/*
 *评论
 *2017-10-31
 新：NoticeCommentAdd
 老：NoticeWall/comment
 */
-(void)NoticeWallcommentWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"NoticeCommentAdd" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"NoticeWallcommentWithDic==%@==%@",dic,responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];

}

/*
 *点赞/取消点赞
 *2017-11-01
 新：NoticePraise
 老：NoticeWall/praise
 */
-(void)NoticeWallAgreeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"NoticePraise" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"NoticeWallAgreeWithDic==%@==%@",[self getParamWithToken:dic],responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/*举报(新增)
 *2017-11-01
 新：NoticeReport 
 */
-(void)noticeReport :(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:[self getURLWithParam:@"NoticeReport"] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/*
 *我的帖子（新增）
 *2017-11-01
 新：GetUserNoticeList
 */
-(void)getMyNoticeList:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetUserNoticeList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/*
 *我的回复
 *2017-11-01
 新：UserReplyNotice
 */
-(void)getMyReplyList:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:[self getURLWithParam:@"UserReplyNotice"] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}
/*
 *邻里杂谈发布
 *2017-11-01
 新：UserNoticeAdd
 老：User/addNotice
 */
-(void)addNoticeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:[self getURLWithParam:@"UserNoticeAdd"] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

-(void)delNoticeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"User/delNotice" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/*更改头像
 2017-10-19
 新：UserLogoModify
 老：User/modifyLogo
 */
-(void)modifyLogoWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:[self getURLWithParam:@"UserLogoModify"] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"modify==%@==%@",dic,responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/*更改昵称
 2017-10-19
 新：UserNickNameModify
 老：User/modifyNickname
 */
-(void)modifyNicknameWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:[self getURLWithParam:@"UserNickNameModify"] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];
}
/**
 *修改性别（新增）
 2017-12-14
 新：UserSexModify
 */

-(void)modifySexWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:[self getURLWithParam:@"UserSexModify"] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}
/**
 *修改生日（新增）
 2017-12-14
 新：UserBirthdayModify
 */

-(void)modifyBirthdayWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:[self getURLWithParam:@"UserBirthdayModify"] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/**
 *个人中心（新增）
 2017-12-16
 新：MyCentre
 */
-(void)myCentreWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"MyCentre" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"_orderArray==%@",[self getParamWithToken:dic]);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/**
 *创建家庭（新增）
 2017-12-17
 新：FamilyCreate
 */

-(void)createFamilyWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"FamilyCreate" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"_orderArray==%@",[self getParamWithToken:dic]);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/**
 * 获取我的家庭信息(新增）
 2017-12-17
 新：GetMyFamily
 */
-(void)getMyFamilyWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetMyFamily" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/**
 * 获取我的家庭成员(新增）
 2017-12-18
 新：GetFamilyMember
 */

-(void)getFamilyMemberWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetFamilyMember" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/**
 * 签约/邀请(新增）
 2017-12-18
 新：AddFamily
 */

-(void)addFamilyWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"AddFamily" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}
/**
 * 获取家庭模块商品内容(新增）
 2017-12-19
 新：GetFamilyProduct
 */

-(void)getFamilyProductWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetFamilyProduct" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/**
 * 积分兑换(新增）
 2017-12-19
 新：FamilyOrder
 */
-(void)familyOrderWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"FamilyOrder" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/**
 * 历史记录(新增）
 2017-12-19
 新：GetFamilyExchangeLog
 */
-(void)getFamilyExchangeLogWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetFamilyExchangeLog" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/**
 * 去积分兑换(新增）
 2017-12-19
 新：FamilyExchange
 */
-(void)familyExchangeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"FamilyExchange" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

-(void)modifyPayPassWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"User/modifyLoginPass" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

+(void)addCommentWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    //NSDictionary* param=[self getParamWithToken:dic];
    [[AFAppDotNetAPIClient sharedClient]POST:@"Comment/addComment" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];
}
/**
 *获取省
 *2017-10-13
 新：GetAreaProvinceList
 老：Area/getProvinceList
 */
-(void)getProvinceListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]GET:@"GetAreaProvinceList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/**
 *获取市列表
 *2017-10-13
 新：GetAreaCityList
 老：Area/getCityList
 */
-(void)getCityListWithDicWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]GET:@"GetAreaCityList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];
}

/**
 *获取区列表
 *2017-10-13
 新：GetAreaDistrictList
 老：Area/getDistrictList
 */
-(void)getDistrictListDicWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetAreaDistrictList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];

}

/**
 *获取社区列表（同获取附近社区）
 *2017-10-13
 新：GetAreaDistrictList
 老：Area/getCommunityList
 */

-(void)getCommunityListWithDicWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetCommunityList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        NSLog(@"getCommunityList==%@==%@",[self getParamWithToken:dic],responseObject);
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
//                NSLog(@"%@",)
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

/**
 *设置用户社区地址
 *2017-11-02
 新：ModifyCommunityAddress
 老：User/modifyCommunityAddress
 */
-(void)modifyCommunityAddressDicWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"ModifyCommunityAddress" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

-(void)helpInfoWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"User/helpInfo" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"helpinfo==%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];


}

/**
 *添加常购商品
 *2017-10-21
 新：UserCollectAdd
 老：User/addCollect
 */
-(void)addCollectWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"UserCollectAdd" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"addCollectWithDic==%@==%@",responseObject,[self getParamWithToken:dic]);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

-(void)myOrderDetailWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Order/myOrderDetail" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

-(void)cancelOrderWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Order/cancelOrder" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"cancelOrderWithDic==%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];


}


-(void)delOrderWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Order/delOrder" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];


}


-(void)finishOrderWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Order/finishOrder" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];
}

-(void)myServeOrderDetailWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Order/myServeOrderDetail" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];

}

/**
 *删除常购商品
 *2017-10-21
 新：UserCollectDel
 老：User/delCollect
 */
-(void)delCollectWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"UserCollectDel" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"delCollectWithDic==%@==%@",responseObject,[self getParamWithToken:dic]);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

-(void)showCommonTelWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Shop/showCommonTel" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}

-(void)GetNickAndAvatarWithUser_ID:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"User/getNickAndAvatar" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"GetNickAndAvatarWithUser_ID11111==%@==%@",[self getParamWithToken:dic],responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];

}


-(void)feedbackWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"User/feedback" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
         
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];

}


-(void)getPushDetailWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"User/getPushDetail" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
                block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];
    
}


-(void)editNoticeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"User/editNotice" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];

}

-(void)sliderDetailWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{


    [[AFAppDotNetAPIClient sharedClient]GET:@"Carousel/sliderDetail" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];


}
-(void)isCollectWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    
    [[AFAppDotNetAPIClient sharedClient]GET:@"Shop/isCollect" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];
}

-(void)isInServeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    
    [[AFAppDotNetAPIClient sharedClient]GET:@"Shop/isInServe" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];

}


-(void)getGJidWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    NSMutableDictionary* param=[dic mutableCopy];
    [param setObject:@"" forKey:@"usertoken"];
//    if([Stockpile sharedStockpile].isLogin){
//       [param setObject:@ forKey:@"usertoken"]
//    }
    [[AFAppDotNetAPIClient sharedClient]GET:@"User/getGJId" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        NSLog(@"%@",error);
    }];
}


-(void)getShopingCartDataWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]GET:@"Cart/getShopingCartData" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];


}

-(void)zhuandhizi:(NSString *)lat lon:(NSString *)lon Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    NSString *urlStr=[NSString stringWithFormat:@"http://api.map.baidu.com/geocoder?output=json&location=%@,%@&key=37492c0ee6f924cb5e934fa08c6b1676",lat,lon];
    [[AFAppDotNetAPIClient sharedClient]GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        NSNumber *retn = [responseObject objectForKey:@"ret"];
//        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        
//        if ([ret isEqualToString:@"200"]) {
//            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
//            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
//            if ([code isEqualToString:@"0"]) {
//                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
//            }else{
//                block(nil,code,msg);
//            }
//        }else{
//            block(nil,nil,nil);
//        }
        
        block(responseObject[@"result"][@"addressComponent"][@"city"],responseObject[@"result"][@"addressComponent"][@"district"],nil);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];

   
}

-(void)getgjInfo:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    
//    http://app.mzsq.cc/app/Public/mzsq/?service=User.getGJSerInfo
    
    
    [[AFAppDotNetAPIClient sharedClient]GET:@"User/getGJSerInfo" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil,nil,nil);
        
        NSLog(@"%@",error);
    }];
}

-(void)telTongJi:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Shop/telStatis" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

-(void)ADD:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]GET:@"User/showAd" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"add_error%@",error);
        block(nil,nil,nil);
    }];
    
}

-(void)ADDJLu:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"User/clickAd" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        NSLog(@"%@",responseObject[@"msg"]);
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil,nil,nil);
        
    }];
    

}


-(void)GongGaoNum:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]GET:@"User/getAllNoticeCountV2" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        NSLog(@"%@",responseObject[@"msg"]);
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

/*首页搜索接口：
 *2017-10-13
 新：GetShopProductSearch
 老：Shop/getProdListByName
 */
-(void)shouYeSouList:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetShopProductSearch" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"sou_result====:%@",responseObject);

        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

-(void)shouYeGoodsF:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Home/getSelectionProd" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"shouYeGoodsF_param==%@",[self getParamWithToken:dic]);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
        
    }];
    

}

-(void)shenghuoList:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Home/getSelectionProd" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        block(nil,nil,nil);
        
    }];
}

/*社区黄页 服务类别
 *2017-11-24
 新：GetPLifeServiceClass
 老：ProfessionClass/getLifeServiceClass
 */
-(void)leibiaol:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetPLifeServiceClass" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"shfw==%@==%@",dic,responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

/*社区黄页 服务内容
 *2017-11-24
 新：GetPLifeServiceShop
 老：Shop/lifeServiceShopList
 */
-(void)shangjial:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetPLifeServiceShop" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"shangjial==%@==%@",dic,responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

-(void)shangjialPush:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Shop/lifeServiceShopDetail" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSLog(@"%@",code);
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
                if([code isEqualToString:@"-1"])
                    [self clearUserInfo];
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

/**
 *物业中心
 */
- (void)wuyYeZhongxin:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block
{
    [[AFAppDotNetAPIClient sharedClient]GET:@"NoticeWall/communityNoticeList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        NSLog(@"%@",responseObject);
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
                if([code isEqualToString:@"-1"])
                    [self clearUserInfo];
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

//http://mzsq.weiruanmeng.com/app/Public/mzsq/?service=Shop.isCollect
//-(void)queryShopByKeyAndProWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
//    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.queryShopByKeyAndPro" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
//        // NSLog(@"%@",responseObject);
//        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
//        
//        NSNumber *retn = [responseObject objectForKey:@"ret"];
//        NSString *ret = [NSString stringWithFormat:@"%@",retn];
//        
//        if ([ret isEqualToString:@"200"]) {
//            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
//            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
//            if ([code isEqualToString:@"0"]) {
//                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
//            }else{
//                block(nil,code,msg);
//            }
//        }else{
//            block(nil,nil,nil);
//        }
//        
//        
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
             //   block(nil,nil,nil);
//        
//        NSLog(@"%@",error);
//    }];
//}

#pragma mark -- 新增接口
#pragma mark -- 商家信息
-(void)ShopshopInfoWithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block
{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Shop/shopInfo" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSLog(@"%@",code);
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
                if([code isEqualToString:@"-1"])
                    [self clearUserInfo];
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

#pragma mark -- 社区标语
- (void)communitySlogan:(NSDictionary *)dic WithBlock:(void (^)(id, NSString *, NSString *))block
{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Home/communitySlogan" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSLog(@"%@",code);
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
                if([code isEqualToString:@"-1"])
                    [self clearUserInfo];
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

/**
 *附近的社区接口
 2017-10-09
 老：Home/getNearbyCommunity
 新：GetCommunityList
 */
-(void)getNearbyCommunity:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetCommunityList" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"--getNearbyCommunity--%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSLog(@"%@",code);
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
                if([code isEqualToString:@"-1"])
                    [self clearUserInfo];
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

/**
 *重新提交订单（下单后未支付的情况）
 */
-(void)resubmitOrder:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Order/resubmit" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
       // NSLog(@"--res--%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSLog(@"%@",code);
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
                if([code isEqualToString:@"-1"])
                    [self clearUserInfo];
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

/**
 *获取该店铺营业情况
 */
-(void)getShopOnlineTime:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"Shop/GetShopOnlineTime" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        // NSLog(@"--res--%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSLog(@"%@",code);
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
                if([code isEqualToString:@"-1"])
                    [self clearUserInfo];
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}
/*
 *店铺信息
 2017-10-09 新增
 */
-(void)getCommunityShop:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]GET:@"GetCommunityShop" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"--getCommunityShop--%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSLog(@"%@",code);
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
                if([code isEqualToString:@"-1"])
                    [self clearUserInfo];
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

/**
 *登录用户获取购物车(这个没变)
 *2017-11-04
 */
-(void)checkCart:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:[self getURLWithParam:@"Cart/checkCart"] parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
        // NSLog(@"--res--%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSLog(@"%@",code);
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
                if([code isEqualToString:@"-1"])
                    [self clearUserInfo];
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

/**
 *热词(新增)
 *2017-12-06
 */
-(void)getHotSearchKey:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient] GET:@"GetHotSearchKey" parameters:[self getParamWithToken:dic] success:^(NSURLSessionDataTask *task, id responseObject) {
         NSLog(@"GetHotSearchKey==%@",responseObject);
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        if ([ret isEqualToString:@"200"]) {
            NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
            NSLog(@"%@",code);
            NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
            if ([code isEqualToString:@"0"]) {
                block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
            }else{
                block(nil,code,msg);
                if([code isEqualToString:@"-1"])
                    [self clearUserInfo];
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

-(void) clearUserInfo{
    [[Stockpile sharedStockpile] setIsLogin:NO];
    [[Stockpile sharedStockpile]setID:@""];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GouWuCheShuLiang"];
    [((AppDelegate*)[UIApplication sharedApplication].delegate).shopDictionary removeAllObjects];
    [((AppDelegate*)[UIApplication sharedApplication].delegate) outLogin];
}

-(NSString*) getURLWithParam:(NSString*) url{
    NSMutableString* str=[[NSMutableString alloc] initWithString:url];
    if([Stockpile sharedStockpile].isLogin){
        [str appendString:@"?"];
        NSMutableDictionary* p=[NSMutableDictionary dictionary];
        NSString* usertoken= [[NSUserDefaults standardUserDefaults]objectForKey:@"usertoken"];
        if(usertoken==nil||[usertoken isEqualToString:@""]){
            [p setObject:@"" forKey:@"usertoken"];
            [str appendString:@"usertoken="];
            [self clearUserInfo];
        }else{
            [p setObject:usertoken forKey:@"usertoken"];
            [str appendString:@"usertoken="];
            [str appendString:usertoken];
        }
        NSString* tamp=[self getNowTimeTimestamp];
        [p setObject:tamp forKey:@"timestamp"];
        [str appendString:@"&timestamp="];
        [str appendString:tamp];
        NSString* sign=[self getSign:p];
        [str appendString:@"&sign="];
        [str appendString:sign];
        return [str copy];
    }
    return  url;
}

-(NSDictionary*) getParamWithToken:(NSDictionary*) param{
    NSMutableDictionary* p=nil;
    if(param!=nil)
        p=[param mutableCopy];
    else
        p=[NSMutableDictionary dictionary];
    if([Stockpile sharedStockpile].isLogin){
      NSString* usertoken= [[NSUserDefaults standardUserDefaults]objectForKey:@"usertoken"];
        if(usertoken==nil||[usertoken isEqualToString:@""]){
            [p setObject:@"" forKey:@"usertoken"];
            [self clearUserInfo];
        }else{
            [p setObject:usertoken forKey:@"usertoken"];
        }
    }else{
        [p setObject:@"" forKey:@"usertoken"];
    }
    NSString* tamp=[self getNowTimeTimestamp];
    [p setObject:tamp forKey:@"timestamp"];
    [p setObject:[self getSign:p] forKey:@"sign"];
    NSLog(@"sign_param==%@",p);
    return  [p copy];
}

-(NSString *)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%d", (int)a];//转为字符型
    return timeString;
}

-(NSString*) getSign:(NSMutableDictionary*) params{
    NSMutableString* sign=[[NSMutableString alloc]init];
    NSArray* arr = [params allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    for(int i=0;i<arr.count;i++){
        NSString* key=arr[i];
        [sign appendString:[NSString stringWithFormat:@"%@=%@",key,[params objectForKey:key]]];
//        if((i+1)!=arr.count)
//            [sign appendString:@"&"];
    }
//    for(NSString* key in arr){
//        [sign appendString:[NSString stringWithFormat:@"%@=%@",key,[params objectForKey:key]]];
//    }
    NSString* lower=[NSString stringWithFormat:@"%@%@",[sign lowercaseString],@"asdfewASD3d2$2kks"];
    //[sign lowercaseString];
    //[sign appendString:@"asdfewASD3d2$2kks"];
    return [NSStringMD5 stringToMD5:lower];
}


@end
