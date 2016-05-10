//
//  WeiXinModelFrame.h
//  TheLifeAssistant
//
//  Created by I Smile going on 16/5/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeiXinModel;
@interface WeiXinModelFrame : NSObject

@property(nonatomic,strong)WeiXinModel *weiXinModel;

@property(nonatomic,assign)CGRect iconFrame;
@property(nonatomic,assign)CGRect titleFrame;
@property(nonatomic,assign)CGRect sourceFrame;
@property(nonatomic,assign)CGRect backgrounFrame;

@property(nonatomic,assign)CGFloat cellHeight;


@end
