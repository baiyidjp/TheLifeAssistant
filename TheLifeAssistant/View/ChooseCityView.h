//
//  ChooseCityView.h
//  PRESCHOOL
//
//  Created by tztddong on 16/5/12.
//  Copyright © 2016年 INFORGENCE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CityBlock)(NSString *cityName);

@interface ChooseCityView : UIView

+ (ChooseCityView *)getChooseCityViewWithFrame:(CGRect)frame cityBlock:(CityBlock)cityBlock;

@end
