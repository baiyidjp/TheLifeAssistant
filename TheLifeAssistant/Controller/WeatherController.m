//
//  WeatherController.m
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/11.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "WeatherController.h"
#import "WeatherView.h"

@interface WeatherController ()

@end

@implementation WeatherController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self configView];
}


- (void)configView{
    
    WeatherView *weatherView = [WeatherView getWeatherViewWithFrame:CGRectMake(0, NAVHEIGHT, KWIDTH, 191.5) controller:self];
    [self.view addSubview:weatherView];
    
}


@end
