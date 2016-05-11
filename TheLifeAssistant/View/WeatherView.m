//
//  WeatherView.m
//  PRESCHOOL
//
//  Created by tztddong on 16/5/11.
//  Copyright © 2016年 INFORGENCE. All rights reserved.
//
//天气图标 http://www.juhe.cn/data/document/weather_icon.zip
//天气ID https://www.juhe.cn/docs/api/id/39/aid/117

#import "WeatherView.h"
#import <CoreLocation/CoreLocation.h>

static CGFloat kPadding = 15.0;
static CGFloat kTextFont_1 = 30;//当前温度的字号
static CGFloat kTextFont_2 = 13;//明天内容字号
static CGFloat kTextFont_3 = 15;//PM 风 字号
static NSString *kTextColor = @"ffffff";
static CGFloat kIconWH = 60.0;//图片的宽高

static NSString *Weather_KEY = @"82d62158ba7426c75d9a7b099fae6aad";//聚合的key
static NSString *Weather_BASEURL = @"op.juhe.cn";//
static NSString *Weather_URL = @"onebox/weather/query";//请求地址

@interface WeatherView ()<CLLocationManagerDelegate>

@property(nonatomic,strong)UIImageView *weatherIcon;//天气图标
@property(nonatomic,strong)UILabel *temperatureLabel;//当前温度
@property(nonatomic,strong)UILabel *weekLabel;//星期几
@property(nonatomic,strong)UILabel *dayTemperature;//当天温度范围
@property(nonatomic,strong)UILabel *weatherInfo;//天气状况
@property(nonatomic,strong)UILabel *windInfo;//风
@property(nonatomic,strong)UILabel *PMLabel;//空气质量
@property(nonatomic,strong)UIButton *tomorrow;//明天
@property(nonatomic,strong)UILabel *tomorrowWeek;//明天星期几
@property(nonatomic,strong)UILabel *tomorrowTemperature;//明天温度
@property(nonatomic,strong)UILabel *tomorrowWeatherInfo;//明天天气状况
@property(nonatomic,strong)UIButton *cityNameBtn;//定位Btn
@property(nonatomic,strong)UILabel *cityNameLabel;//城市名
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIView *lineView_1;
@property(nonatomic,strong)UILabel *otherinfo;//生活指数
@property(nonatomic,strong)UILabel *otherinfoAni;//生活指数
@property(nonatomic,strong)UIImageView *backImage;//底图

@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLGeocoder *geoC;


@end

@implementation WeatherView

+ (WeatherView *)getWeatherViewWithFrame:(CGRect)frame{
    
    return [[[self class] alloc]initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        kPadding = kPadding*KWIDTH/375.0;
        
        [self configView];
        [self locationMyCity];
    }
    return self;
}

- (void)configView{
    
    self.backImage = [[UIImageView alloc]initWithFrame:self.bounds];
    self.backImage.image = [UIImage imageNamed:@"faxian_ditu"];
    self.backImage.userInteractionEnabled = YES;
    [self addSubview:self.backImage];
    
    self.cityNameLabel = [[UILabel alloc]init];
    [self.backImage addSubview:self.cityNameLabel];
    self.cityNameLabel.font = FONTSIZE(kTextFont_3);
    self.cityNameLabel.textColor = [UIColor colorWithHexString:kTextColor];
    self.cityNameLabel.text = @"北京";
    CGSize cityLaeblSize = TEXTSIZEWITHFONT(self.cityNameLabel.text,self.cityNameLabel.font);
    [self.cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kPadding);
        make.right.offset(-kPadding);
        make.size.mas_equalTo(cityLaeblSize);
    }];
    
    self.cityNameBtn = [[UIButton alloc]init];
    [self.backImage addSubview:self.cityNameBtn];
    [self.cityNameBtn setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
    [self.cityNameBtn addTarget:self action:@selector(clickLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.cityNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityNameLabel.mas_top);
        make.bottom.equalTo(self.cityNameLabel.mas_bottom);
        make.right.equalTo(self.cityNameLabel.mas_left).with.offset(-kPadding/2);
        make.width.equalTo(@(cityLaeblSize.height));
    }];
    
    self.weatherIcon = [[UIImageView alloc]init];
    [self.backImage addSubview:self.weatherIcon];
    [self.weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityNameLabel.mas_bottom).with.offset(-kPadding/2);
        make.left.offset(kPadding);
        make.width.and.height.equalTo(@(kIconWH));
    }];
    self.weatherIcon.backgroundColor = [UIColor redColor];
    
    self.temperatureLabel = [[UILabel alloc]init];
    [self.backImage addSubview:self.temperatureLabel];
    self.temperatureLabel.textColor = [UIColor colorWithHexString:kTextColor];
    self.temperatureLabel.font = FONTSIZE(kTextFont_1);
    
    
    self.weekLabel = [[UILabel alloc]init];
    [self.backImage addSubview:self.weekLabel];
    self.weekLabel.textColor = [UIColor colorWithHexString:kTextColor];
    self.weekLabel.font = FONTSIZE(kTextFont_2);
    
    
    self.dayTemperature = [[UILabel alloc]init];
    [self.backImage addSubview:self.dayTemperature];
    self.dayTemperature.textColor = [UIColor colorWithHexString:kTextColor];
    self.dayTemperature.font = FONTSIZE(kTextFont_2);
    
    
    self.weatherInfo = [[UILabel alloc]init];
    [self.backImage addSubview:self.weatherInfo];
    self.weatherInfo.textColor = [UIColor colorWithHexString:kTextColor];
    self.weatherInfo.font = FONTSIZE(kTextFont_3);
    
    
    self.windInfo = [[UILabel alloc]init];
    [self.backImage addSubview:self.windInfo];
    self.windInfo.textColor = [UIColor colorWithHexString:kTextColor];
    self.windInfo.font = FONTSIZE(kTextFont_2);
    
    
    self.PMLabel = [[UILabel alloc]init];
    [self.backImage addSubview:self.PMLabel];
    self.PMLabel.textColor = [UIColor colorWithHexString:kTextColor];
    self.PMLabel.font = FONTSIZE(kTextFont_2);
    
    
    self.tomorrow = [[UIButton alloc]init];
    [self.backImage addSubview:self.tomorrow];
    [self.tomorrow setBackgroundColor:[UIColor colorWithHexString:kTextColor]];
    [self.tomorrow setTitle:@"明天" forState:UIControlStateNormal];
    [self.tomorrow setTitleColor:[UIColor colorWithHexString:@"6ecd29"] forState:UIControlStateNormal];
    [self.tomorrow.titleLabel setFont:FONTSIZE(kTextFont_3)];
    self.tomorrow.layer.cornerRadius = 5;
    [self.tomorrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weatherIcon.mas_left);
        make.top.equalTo(self.weatherIcon.mas_bottom).with.offset(kPadding);
        make.size.mas_equalTo(CGSizeMake(kIconWH, 30));
    }];
    
    self.tomorrowWeek = [[UILabel alloc]init];
    [self.backImage addSubview:self.tomorrowWeek];
    self.tomorrowWeek.textColor = [UIColor colorWithHexString:kTextColor];
    self.tomorrowWeek.font = FONTSIZE(kTextFont_2);
    
    
    self.tomorrowTemperature = [[UILabel alloc]init];
    [self.backImage addSubview:self.tomorrowTemperature];
    self.tomorrowTemperature.textColor = [UIColor colorWithHexString:kTextColor];
    self.tomorrowTemperature.font = FONTSIZE(kTextFont_2);
    
    
    self.tomorrowWeatherInfo = [[UILabel alloc]init];
    [self.backImage addSubview:self.tomorrowWeatherInfo];
    self.tomorrowWeatherInfo.textColor = [UIColor colorWithHexString:kTextColor];
    self.tomorrowWeatherInfo.font = FONTSIZE(kTextFont_2);
    
    self.lineView = [[UIView alloc]init];
    [self.backImage addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorWithHexString:kTextColor];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.height.equalTo(@1);
        make.top.equalTo(self.tomorrow.mas_bottom).with.offset(kPadding);
    }];
    
    UIView *paomaView = [[UIView alloc]init];
    [self.backImage addSubview:paomaView];
    paomaView.backgroundColor = [UIColor clearColor];
    [paomaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.offset(kPadding);
        make.right.offset(-kPadding);
        make.height.equalTo(@44);
    }];
    
    self.otherinfo = [[UILabel alloc]init];
    [paomaView addSubview:self.otherinfo];
    self.otherinfo.textColor = [UIColor colorWithHexString:kTextColor];
    self.otherinfo.font = FONTSIZE(kTextFont_3);
    
    self.otherinfoAni = [[UILabel alloc]init];
    [paomaView addSubview:self.otherinfoAni];
    self.otherinfoAni.textColor = [UIColor colorWithHexString:kTextColor];
    self.otherinfoAni.font = FONTSIZE(kTextFont_3);
    
    self.lineView_1 = [[UIView alloc]init];
    [self.backImage addSubview:self.lineView_1];
    self.lineView_1.backgroundColor = [UIColor colorWithHexString:kTextColor];
    [self.lineView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.offset(0);
        make.height.equalTo(@1);
        make.top.equalTo(paomaView.mas_bottom);
    }];

}

- (void)clickLocation{
    NSLog(@"定位");
}

#pragma mark 请求天气
- (void)requestData{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KEY_GET_WEATHER forKey:@"key"];
    [params setObject:self.cityNameLabel.text forKey:@"cityname"];
    [params setObject:@"json" forKey:@"dtype"];
    
    MBPROGRESSHUD_SHOWLOADINGWITH(self);
    [AFN_Request GET:API_GET_WEATHER params:params success:^(id successData) {
        NSLog(@"%@",successData);
        MBPROGRESSHUD_HIDELOADINGWITH(self);
        if ([[successData objectForKey:@"error_code"] intValue] == 0) {
            NSDictionary *result = [successData objectForKey:@"result"];
            NSDictionary *data = [result objectForKey:@"data"];//数据集合
            NSDictionary *realtime = [data objectForKey:@"realtime"];//当前温度情况
            [self setWindDataWithDict:[realtime objectForKey:@"wind"]];//设置风
            [self setWeatherDataWithDict:[realtime objectForKey:@"weather"]];//设置当前天气
            NSDictionary *pmDict = [data objectForKey:@"pm25"];
            [self setPMDataWithDict:[pmDict objectForKey:@"pm25"]];//设置PM
            [self setWeekDataWithArray:[data objectForKey:@"weather"]];//设置week
            NSDictionary *life = [data objectForKey:@"life"];
            [self setLifeDataWithDict:[life objectForKey:@"info"]];//设置生活指数
        }else{
            [MBProgressHUD showError:[successData objectForKey:@"reason"]];
        }
    } filed:^(NSError *error) {
        MBPROGRESSHUD_HIDELOADINGWITH(self);
        MBPROGRESSHUD_TIMEOUT;
    }];
    
}

//风 数据
- (void)setWindDataWithDict:(NSDictionary *)dict{
    NSLog(@"1----%@",dict);
    self.windInfo.text = [NSString stringWithFormat:@"%@ %@ ",[dict objectForKey:@"direct"],[dict objectForKey:@"power"]];
    CGSize windInfoSize = TEXTSIZEWITHFONT(self.windInfo.text, self.windInfo.font);
    [self.windInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weatherInfo.mas_left);
        make.top.equalTo(self.weatherInfo.mas_bottom).with.offset(5);
        make.size.mas_equalTo(windInfoSize);
    }];
}

//温度数据
- (void)setWeatherDataWithDict:(NSDictionary *)dict{
    NSLog(@"2----%@",dict);
    self.temperatureLabel.text = [NSString stringWithFormat:@"%@°",[dict objectForKey:@"temperature"]];
    CGSize temLabelSize = TEXTSIZEWITHFONT(self.temperatureLabel.text, self.temperatureLabel.font);
    [self.temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weatherIcon.mas_top);
        make.left.equalTo(self.weatherIcon.mas_right).with.offset(kPadding/2);
        make.size.mas_equalTo(temLabelSize);
    }];
    
    self.weatherInfo.text = [dict objectForKey:@"info"];
    CGSize weatherInfoSize = TEXTSIZEWITHFONT(self.weatherInfo.text, self.weatherInfo.font);
    [self.weatherInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayTemperature.mas_right).with.offset(kPadding);
        make.top.equalTo(self.weatherIcon.mas_top);
        make.size.mas_equalTo(weatherInfoSize);
    }];
}

//PM数据
- (void)setPMDataWithDict:(NSDictionary *)dict{
    NSLog(@"3----%@",dict);
    self.PMLabel.text = [NSString stringWithFormat:@"空气质量 %@ ",[dict objectForKey:@"quality"]];
    CGSize PMLabelSize = TEXTSIZEWITHFONT(self.PMLabel.text, self.PMLabel.font);
    [self.PMLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weatherInfo.mas_left);
        make.top.equalTo(self.windInfo.mas_bottom).with.offset(5);
        make.size.mas_equalTo(PMLabelSize);
    }];
}

//星期和温度区间
- (void)setWeekDataWithArray:(NSArray *)array{
    NSLog(@"4----%@",array);
    NSDictionary *todayDict = array[0];//当天天气情况
    self.weekLabel.text = [NSString stringWithFormat:@"周%@",[todayDict objectForKey:@"week"]];
    CGSize weekSize = TEXTSIZEWITHFONT(self.weekLabel.text, self.weekLabel.font);
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.temperatureLabel.mas_left);
        make.bottom.equalTo(self.weatherIcon.mas_bottom);
        make.size.mas_equalTo(weekSize);
    }];
    NSDictionary *todayInfo = [todayDict objectForKey:@"info"];
    self.dayTemperature.text = [NSString stringWithFormat:@"%@°/%@° ",[todayInfo objectForKey:@"night"][2],[todayInfo objectForKey:@"day"][2]];
    CGSize dayTemperatureSize = TEXTSIZEWITHFONT(self.dayTemperature.text, self.dayTemperature.font);
    [self.dayTemperature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel.mas_right).with.offset(kPadding/2);
        make.bottom.equalTo(self.weatherIcon.mas_bottom);
        make.size.mas_equalTo(dayTemperatureSize);
    }];
    
    NSDictionary *tomorrowDict = array[1];//明天天气情况
    self.tomorrowWeek.text = [NSString stringWithFormat:@"周%@",[tomorrowDict objectForKey:@"week"]];
    CGSize tomorrowWeekSize = TEXTSIZEWITHFONT(self.tomorrowWeek.text, self.tomorrowWeek.font);
    [self.tomorrowWeek mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tomorrow.mas_right).with.offset(kPadding/2);
        make.centerY.equalTo(self.tomorrow.mas_centerY);
        make.size.mas_equalTo(tomorrowWeekSize);
    }];
    NSDictionary *tomorrowInfo = [tomorrowDict objectForKey:@"info"];
    self.tomorrowTemperature.text = [NSString stringWithFormat:@"%@°/%@° ",[tomorrowInfo objectForKey:@"night"][2],[tomorrowInfo objectForKey:@"day"][2]];
    CGSize tomorrowTemperatureSize = TEXTSIZEWITHFONT(self.tomorrowTemperature.text, self.tomorrowTemperature.font);
    [self.tomorrowTemperature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tomorrowWeek.mas_right).with.offset(kPadding/2);
        make.centerY.equalTo(self.tomorrow.mas_centerY);
        make.size.mas_equalTo(tomorrowTemperatureSize);
    }];
    
    self.tomorrowWeatherInfo.text = [NSString stringWithFormat:@"%@转%@ ",[tomorrowInfo objectForKey:@"day"][1],[tomorrowInfo objectForKey:@"night"][1]];
    CGSize tomorrowWeatherInfoSize = TEXTSIZEWITHFONT(self.tomorrowWeatherInfo.text, self.tomorrowWeatherInfo.font);
    [self.tomorrowWeatherInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tomorrowTemperature.mas_right).with.offset(kPadding/2);
        make.centerY.equalTo(self.tomorrow.mas_centerY);
        make.size.mas_equalTo(tomorrowWeatherInfoSize);
    }];
}

//跑马灯lifeinfo
- (void)setLifeDataWithDict:(NSDictionary *)dict{
    NSLog(@"5----%@",dict);
    self.otherinfo.text = [NSString stringWithFormat:@"%@%@%@   ",[dict objectForKey:@"chuanyi"][1],[dict objectForKey:@"ganmao"][1],[dict objectForKey:@"yundong"][1]];
    CGSize otherinfoSize = TEXTSIZEWITHFONT(self.otherinfo.text, self.otherinfo.font);
    [self.otherinfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kPadding);
        make.left.offset(0);
        make.width.equalTo(@(otherinfoSize.width));
        make.bottom.offset(-kPadding);
    }];
    
    self.otherinfoAni.text = self.otherinfo.text;
    [self.otherinfoAni mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.otherinfo.mas_top);
        make.left.equalTo(self.otherinfo.mas_right);
        make.width.equalTo(@(otherinfoSize.width));
        make.bottom.offset(-kPadding);

    }];
    [self addAnimation];
}

- (void)addAnimation{
    
    [UIView animateWithDuration:self.otherinfoAni.text.length/7.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.otherinfo.x = -self.otherinfo.width;
        self.otherinfoAni.x = 0;
    } completion:^(BOOL finished) {
        self.otherinfo.x = 0;
        self.otherinfoAni.x = self.otherinfo.width;
        [self addAnimation];
    }];
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
                self.cityNameLabel.text = [cityInfo objectForKey:@"City"];//[NSString stringWithFormat:@"%@-%@",[cityInfo objectForKey:@"Country"],[cityInfo objectForKey:@"City"]];
                [self requestData];
            }else{
                [self.superview makeToast:@"位置不可用,切换为北京"];
                self.cityNameLabel.text = @"北京";
                [self requestData];
            }
            
        }];
        
    }
    // 如果只需要获取一次位置, 那么在此处停止获取用户位置
    [manager stopUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.superview makeToast:@"定位失败,切换为北京"];
    self.cityNameLabel.text = @"北京";
    [self requestData];
}


@end
