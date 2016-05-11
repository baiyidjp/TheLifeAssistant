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
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
}


- (void)configView{
    
    WeatherView *weatherView = [WeatherView getWeatherViewWithFrame:CGRectMake(0, NAVHEIGHT, KWIDTH, KHEIGHT)];
    [self.view addSubview:weatherView];
    
}


@end
