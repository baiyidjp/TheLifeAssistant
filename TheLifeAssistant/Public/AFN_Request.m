//
//  AFN_Request.m
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "AFN_Request.h"

@implementation AFN_Request

+ (AFHTTPSessionManager *)sharedInstance{
    
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        //支持https
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
//        // 设置可以接收无效的证书
//        [securityPolicy setAllowInvalidCertificates:YES];
//        manager.securityPolicy = securityPolicy;
        //超时
        manager.requestSerializer.timeoutInterval = 8;
    });
    return manager;
}

+ (void)cancelAllOperations{
    [[self sharedInstance].operationQueue cancelAllOperations];
}

+ (void)GET:(NSString *)url params:(id)params success:(successBlock)success filed:(filedBlock)filed{

    [[self sharedInstance] GET:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (filed) {
            filed(error);
        }
    }];
}

+ (void)POST:(NSString *)url params:(id)params success:(successBlock)success filed:(filedBlock)filed{

    [[self sharedInstance] POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (filed) {
            filed(error);
        }
    }];
}


@end
