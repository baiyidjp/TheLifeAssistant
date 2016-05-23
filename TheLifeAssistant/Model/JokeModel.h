//
//  JokeModel.h
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/23.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JokeModel : NSObject

@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *updatetime;
@property(nonatomic,copy)NSString *hashId;
@property(nonatomic,assign)long long unixtime;
@end
