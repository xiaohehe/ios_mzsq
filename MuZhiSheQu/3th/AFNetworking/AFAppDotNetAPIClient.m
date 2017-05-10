// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFAppDotNetAPIClient.h"


//static NSString * const AFAppDotNetAPIBaseURLString = @"http://api.zzwms.com/";
static NSString * const AFAppDotNetAPIBaseURLString = @"https://app.mzsq.cc";



@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/Public/mzsq/",AFAppDotNetAPIBaseURLString]]];
        
        
        
        
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"YJHhttps" ofType:@"cer"];
//        NSData * certData =[NSData dataWithContentsOfFile:cerPath];
//        NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
//        
//        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey withPinnedCertificates:certSet];
//        //是否允许无效证书  (NO 允许使用无效证书,YES 不允许是用无效证书)
//        _sharedClient.securityPolicy.allowInvalidCertificates=YES;
//        //是否允许校验域名(NO 不允许,YES 允许)
//        _sharedClient.securityPolicy.validatesDomainName=YES;

        
        
        
        
       [_sharedClient.requestSerializer setTimeoutInterval:20];
        
        [_sharedClient. reachabilityManager setReachabilityStatusChangeBlock :^( AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN :
                    NSLog ( @"-------AFNetworkReachabilityStatusReachableViaWWAN------" );
                    break ;
                case AFNetworkReachabilityStatusReachableViaWiFi :
                    NSLog ( @"-------AFNetworkReachabilityStatusReachableViaWiFi------" );
                    break ;
                case AFNetworkReachabilityStatusNotReachable :
                    NSLog ( @"-------AFNetworkReachabilityStatusNotReachable------" );
                    break ;
                default :
                    break ;
            }
        }];
        
        [_sharedClient. reachabilityManager startMonitoring ];
    });
    
    return _sharedClient;
}

@end
