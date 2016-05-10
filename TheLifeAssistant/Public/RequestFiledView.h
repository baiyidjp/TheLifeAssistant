//
//  RequestFiledView.h
//  360
//
//  Created by tztddong on 16/4/13.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectBlock)();

@interface RequestFiledView : UIView

/**
 *  使用默认的提示title和图片
 *
 *  @param frame       frame
 *  @param type        1默认代表无内容 2默认代表无网络
 *  @param selectBlock 回调
 */
+ (instancetype)configViewWithFrame:(CGRect)frame
                               Type:(NSInteger)type
                        selectBlock:(selectBlock)selectBlock;

/**
 *  自定义提示title 使用默认图片
 *
 *  @param frame       frame
 *  @param type        1默认代表无内容 2默认代表无网络
 *  @param selectBlock 回调
 */
+ (instancetype)configViewWithFrame:(CGRect)frame
                              Title:(NSString *)title
                               Type:(NSInteger)type
                        selectBlock:(selectBlock)selectBlock;

/**
 *  使用默认title 自定义图片
 *
 *  @param frame       frame
 *  @param type        1默认代表无内容 2默认代表无网络
 *  @param selectBlock 回调
 */
+ (instancetype)configViewWithFrame:(CGRect)frame
                          ImageName:(NSString *)imageName
                               Type:(NSInteger)type
                        selectBlock:(selectBlock)selectBlock;

/**
 *  自定义提示title 自定义图片
 *
 *  @param frame       frame
 *  @param type        1默认代表无内容 2默认代表无网络 可在这个API中自定义
 *  @param selectBlock 回调
 */
+ (instancetype)configViewWithFrame:(CGRect)frame
                              Title:(NSString *)title
                          ImageName:(NSString *)imageName
                               Type:(NSInteger)type
                        selectBlock:(selectBlock)selectBlock;
@end
