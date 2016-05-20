//
//  WeatherView.h
//  PRESCHOOL
//
//  Created by tztddong on 16/5/11.
//  Copyright © 2016年 INFORGENCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherView : UIView

/**
 *  @param frame      view的frame
 *  @param controller 当前的控制器
 *
 *  @return WeatherView
 */
+ (WeatherView *)getWeatherViewWithFrame:(CGRect)frame controller:(UIViewController *)controller;

@end
