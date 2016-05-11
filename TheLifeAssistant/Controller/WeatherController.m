//
//  WeatherController.m
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/11.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "WeatherController.h"
#import <CoreLocation/CoreLocation.h>

@interface WeatherController ()<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLGeocoder *geoC;

@end

@implementation WeatherController
{
    UIButton *_locationBtn;
    UILabel *_cityNameLabel;
    UIActivityIndicatorView *_activityView;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
    [self locationMyCity];
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
    }
    return _locationManager;
}
-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

- (void)configView{

    UIView *lineView_1 = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHEIGHT+CELLHEIGHT, KWIDTH, 1)];
    lineView_1.backgroundColor = [UIColor colorWithHexString:@"2598f9"];
    [self.view addSubview:lineView_1];
    
    
}

- (void)locationMyCity{
    
    //判断当前设备版本大于iOS8以后的话执行里面的方法
    if ([UIDevice currentDevice].systemVersion.floatValue >=8.0) {
        //当用户使用的时候授权
        [self.locationManager requestWhenInUseAuthorization];
    }
    //设置代理
    self.locationManager.delegate=self;
    //设置定位的精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    //设置定位的频率,这里我们设置精度为10,也就是10米定位一次
    CLLocationDistance distance = 1000.0f;
    //给精度赋值
    self.locationManager.distanceFilter = distance;
    //开始启动定位
    [self.locationManager startUpdatingLocation];
//    [self.activityView setHidden:NO];
//    [self.activityView startAnimating];
    
}
//当位置发生改变的时候调用(上面我们设置的是10米,也就是当位置发生>10米的时候该代理方法就会调用)
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //取出第一个位置
    CLLocation *location=[locations firstObject];
    // 判断位置是否可用
    if (location.horizontalAccuracy >= 0) {
        
        [self.geoC reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *  placemarks, NSError *  error) {
            
            if (error == nil) {
                CLPlacemark *pl = [placemarks firstObject];
                //这个字典存储的是位置的具体信息
                NSDictionary *cityInfo = [pl addressDictionary];
//                self.cityNameLabel.text = [cityInfo objectForKey:@"City"];//[NSString stringWithFormat:@"%@-%@",[cityInfo objectForKey:@"Country"],[cityInfo objectForKey:@"City"]];
//                [self.activityView stopAnimating];
//                [self.activityView setHidden:YES];
            }else{
                [self.view makeToast:@"位置不可用,切换为北京"];
//                self.cityNameLabel.text = @"北京市";
            }
            
        }];
        
    }
    // 如果只需要获取一次位置, 那么在此处停止获取用户位置
    [manager stopUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.view makeToast:@"定位失败,切换为北京"];
//    self.cityNameLabel.text = @"北京市";
//    [self.activityView stopAnimating];
//    [self.activityView setHidden:YES];
}

@end
