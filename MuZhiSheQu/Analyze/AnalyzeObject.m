//
//  AnalyzeObject.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AnalyzeObject.h"
#import "AFAppDotNetAPIClient.h"
@implementation AnalyzeObject
-(void)getyanzhengma:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.getVerifyCodeV2" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {

//        NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
//        NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
//
//
//        
//        if ([code isEqualToString:@"0"]) {
//              block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
//        }else{
//            block(nil,code,msg);
//        }
        
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
    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Carousel.slider" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        NSString *code =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"code"]];
//        NSString *msg =[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"msg"]];
//
//        
//        if ([code isEqualToString:@"0"]) {
//            block([[responseObject objectForKey:@"data"] objectForKey:@"info"],code,msg);
//        }else{
//            block(nil,code,msg);
//        }

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
    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Home.getSelectionClass" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    
    
    
    
    [[AFAppDotNetAPIClient sharedClient] POST:@"?service=ProfessionClass.getRetailShopListV2" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=ProfessionClass.getServShopList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
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

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.queryShopByKeyAndPro" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
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

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=ProfessionClass.getWeiShopListV2" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

-(void)getRetailShopClasswithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{

//    AFAppDotNetAPIClient *af = [AFAppDotNetAPIClient sharedClient];
//    af.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    [af.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    af.requestSerializer.timeoutInterval = 5.f;
//    [af.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//
//    
//    
//    
//    [af POST:@"?service=Shop.getRetailShopClass" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        NSLog(@"成功");
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"失败");
//
//        
//    }];
    
    
    
    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.getRetailShopClass" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
     

        
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
    //
    //
    //
    //
    //    [af POST:@"?service=Shop.getRetailShopClass" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
    //
    //        NSLog(@"成功");
    //
    //    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    //        NSLog(@"失败");
    //
    //
    //    }];
    
    
    
    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.queryShopDetail" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        
        
        
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
-(void)getProdListByClasswithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.getProdListByClass" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Product.prodDetail" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
-(void)getprodDetailPushwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Product.prodDetailV2" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

       [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Product.prodDetailV2" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
           
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
-(void)queryShopDetailwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block{
    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.queryShopDetail" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Comment.commentList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.getNoticeList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.userLogin" parameters:[NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",@"4",@"type", nil] success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"login==%@",[self DataTOjsonString:responseObject]);
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Cart.addProd" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
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

    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Cart.showCart" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
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
    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=ProfessionClass.getShopClassList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.queryShopByKey" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Cart.clearCart" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

-(void)OrdersubmitWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Order.submit" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Cart.delProdInCart" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Order.serveShopSubmit" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
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
-(void)getAddressListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.getAddressList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

-(void)addAddressWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.updAddress" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

-(void)setDefaultAddressWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.setDefaultAddress" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Product.checkProd" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

-(void)getCollectListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.getCollectList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.getCollectList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Order.myOrderList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Order.myServeOrderList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
-(void)delAddressWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.delAddress" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

-(void)getNoticeListwallWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=NoticeWall.getNoticeListV2" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

-(void)noticeDetailWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=NoticeWall.noticeDetail" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
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

-(void)NoticeWallcommentWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=NoticeWall.comment" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

-(void)NoticeWallAgreeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=NoticeWall.praise" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

-(void)addNoticeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.addNotice" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.delNotice" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
-(void)modifyLogoWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.modifyLogo" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

-(void)modifyNicknameWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.modifyNickname" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

+(void)modifyPayPassWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.modifyLoginPass" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Comment.addComment" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

-(void)getProvinceListWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Area.getProvinceList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
 */
-(void)getCityListWithDicWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Area.getCityList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
 */
-(void)getDistrictListDicWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Area.getDistrictList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
 *获取社区列表
 */

-(void)getCommunityListWithDicWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Area.getCommunityList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"ret"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
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

-(void)modifyCommunityAddressDicWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.modifyCommunityAddress" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.helpInfo" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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


-(void)addCollectWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.addCollect" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Order.myOrderDetail" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Order.cancelOrder" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Order.delOrder" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Order.finishOrder" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Order.myServeOrderDetail" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

-(void)delCollectWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.delCollect" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.showCommonTel" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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


    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.getNickAndAvatar" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    
    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.feedback" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.getPushDetail" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.editNotice" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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


    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Carousel.sliderDetail" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.isCollect" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.isInServe" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.getGJId" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Cart.getShopingCartData" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    
    
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.getGJSerInfo" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.telStatis" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
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

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.showAd" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.clickAd" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=User.getAllNoticeCountV2" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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



//首页搜索接口：
-(void)shouYeSouList:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.getProdListByName" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Home.getSelectionProd" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Home.getSelectionProd" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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




-(void)leibiaol:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=ProfessionClass.getLifeServiceClass" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"shfw==%@",responseObject);
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


-(void)shangjial:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.lifeServiceShopList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.lifeServiceShopDetail" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=NoticeWall.communityNoticeList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Shop.shopInfo" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
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
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Home.communitySlogan" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
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
 */
-(void)getNearbyCommunity:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block{
    [[AFAppDotNetAPIClient sharedClient]POST:@"?service=Home.getNearbyCommunity" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"--res--%@",responseObject);
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
            }
        }else{
            block(nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil,nil);
    }];
}

@end
