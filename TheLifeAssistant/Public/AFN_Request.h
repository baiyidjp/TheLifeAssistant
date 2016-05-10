//
//  AFN_Request.h
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^successBlock)(id successData);
typedef void(^filedBlock)(NSError *error);

@interface AFN_Request : NSObject

/**
 *  GET 请求
 */
+ (void)GET:(NSString *)url
     params:(id)params
    success:(successBlock)success
      filed:(filedBlock)filed;
/**
 *  POST 请求
 */
+ (void)POST:(NSString *)url
      params:(id)params
     success:(successBlock)success
       filed:(filedBlock)filed;
/**
 *  获取单例对象
 */
+ (AFHTTPSessionManager *)sharedInstance;
/**
 *  取消所有请求
 */
+ (void)cancelAllOperations;
@end
