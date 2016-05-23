//
//  JokeModelFrame.h
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/23.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JokeModel;
@interface JokeModelFrame : NSObject

@property(nonatomic,strong)JokeModel *model;

@property(nonatomic,assign)CGRect backViewF;
@property(nonatomic,assign)CGRect contentF;

@property(nonatomic,assign)CGFloat cellH;
@end
