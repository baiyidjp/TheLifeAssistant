//
//  WeatherView.m
//  PRESCHOOL
//
//  Created by tztddong on 16/5/11.
//  Copyright © 2016年 INFORGENCE. All rights reserved.
//

#import "WeatherView.h"
#import <CoreLocation/CoreLocation.h>
#import "ChooseCityView.h"
#import "CBAutoScrollLabel.h"

static CGFloat kPadding = 15.0;
static CGFloat kTextFont_1 = 30;//当前温度的字号
static CGFloat kTextFont_2 = 13;//明天内容字号
static CGFloat kTextFont_3 = 15;//PM 风 字号
static NSString *kTextColor = @"ffffff";
static CGFloat kIconWH = 60.0;//图片的宽高
static NSString *kBtnColor = @"b6e5f4";


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
@property(nonatomic,strong)CBAutoScrollLabel *otherinfo;//生活指数
@property(nonatomic,strong)UILabel *otherinfoAni;//生活指数
@property(nonatomic,strong)UIImageView *backImage;//底图
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIButton *refreshBtn;
@property(nonatomic,strong)UIViewController *superCtrl;

@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLGeocoder *geoC;
@property(nonatomic,strong)ChooseCityView *chooseCityView;

@end

@implementation WeatherView

+ (WeatherView *)getWeatherViewWithFrame:(CGRect)frame controller:(UIViewController *)controller{
    
    return [[[self class] alloc]initWithFrame:frame controller:controller];
}

- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.superCtrl = controller;
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
    self.cityNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseCity:)];
    [self.cityNameLabel addGestureRecognizer:tap];
    self.cityNameLabel.text = @"定位中";
    
    
    self.cityNameBtn = [[UIButton alloc]init];
    [self.backImage addSubview:self.cityNameBtn];
    [self.cityNameBtn setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
    [self.cityNameBtn addTarget:self action:@selector(clickLocation) forControlEvents:UIControlEventTouchUpInside];
    
    self.refreshBtn = [[UIButton alloc]init];
    [self.backImage addSubview:self.refreshBtn];
    [self.refreshBtn setImage:[UIImage imageNamed:@"weather_refresh"] forState:UIControlStateNormal];
    [self.refreshBtn addTarget:self action:@selector(refreshWeather) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-kPadding);
        make.top.offset(kPadding);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    
    self.weatherIcon = [[UIImageView alloc]init];
    [self.backImage addSubview:self.weatherIcon];
    [self.weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityNameLabel.mas_bottom).with.offset(-kPadding/2);
        make.left.offset(kPadding);
        make.width.and.height.equalTo(@(kIconWH));
    }];
    self.weatherIcon.backgroundColor = [UIColor clearColor];
    
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
    [self.tomorrow setAlpha:0.5];
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
    self.lineView.alpha = 0.5;
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
    
    self.otherinfo = [[CBAutoScrollLabel alloc]init];
    [paomaView addSubview:self.otherinfo];
    self.otherinfo.textColor = [UIColor colorWithHexString:kTextColor];
    self.otherinfo.font = FONTSIZE(kTextFont_3);
    
    self.otherinfoAni = [[UILabel alloc]init];
    [paomaView addSubview:self.otherinfoAni];
    self.otherinfoAni.textColor = [UIColor colorWithHexString:kTextColor];
    self.otherinfoAni.font = FONTSIZE(kTextFont_3);
}

#pragma mark 重新定位
- (void)clickLocation{
    NSLog(@"定位");
    [self locationMyCity];
}

#pragma mark 刷新天气
- (void)refreshWeather{
    MBPROGRESSHUD_SHOWLOADINGWITH(self);
    [self requestData];
}

#pragma mark 选择城市
- (void)chooseCity:(UITapGestureRecognizer *)tap{
    
    self.chooseCityView = [ChooseCityView getChooseCityViewWithFrame:CGRectMake(0, KHEIGHT, KWIDTH, KHEIGHT) cityBlock:^(NSString *cityName) {
        
        self.superCtrl.navigationController.navigationBarHidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.chooseCityView.y = KHEIGHT;
        }];
        if (cityName) {
            MBPROGRESSHUD_SHOWLOADINGWITH(self);
            self.cityNameLabel.text = cityName;
            [self requestData];
        }
    }];
    [self.superCtrl.view addSubview:self.chooseCityView];
    [UIView animateWithDuration:0.3 animations:^{
        self.chooseCityView.y = 0;
    } completion:^(BOOL finished) {
        self.superCtrl.navigationController.navigationBarHidden = YES;
    }];

}

#pragma mark 请求天气
- (void)requestData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KEY_GET_WEATHER forKey:@"key"];
    [params setObject:self.cityNameLabel.text forKey:@"cityname"];
    [params setObject:@"json" forKey:@"dtype"];
    
    [AFN_Request GET:API_GET_WEATHER params:params success:^(id successData) {
        MBPROGRESSHUD_HIDELOADINGWITH(self);
        if ([[successData objectForKey:@"error_code"] intValue] == 0) {
            [self setCityNameFrame];
            NSDictionary *result = [successData objectForKey:@"result"];
            NSDictionary *data = [result objectForKey:@"data"];//数据集合
            NSDictionary *realtime = [data objectForKey:@"realtime"];//当前温度情况
            
            [self setWindDataWithDict:[realtime objectForKey:@"wind"]];//设置风
            
            NSDictionary *pmDict = [data objectForKey:@"pm25"];
            [self setPMDataWithDict:[pmDict objectForKey:@"pm25"]];//设置PM
            [self setWeekDataWithArray:[data objectForKey:@"weather"] andNowWeatherDict:[realtime objectForKey:@"weather"]];//设置week 和 当前天气
            
            NSDictionary *life = [data objectForKey:@"life"];
            [self setLifeDataWithDict:[life objectForKey:@"info"]];//设置生活指数
            [self setNeedsUpdateConstraints];
        }else{
            [self makeToast:[NSString stringWithFormat:@"%@,%@",[successData objectForKey:@"reason"],@"切换为默认城市"]];
            self.cityNameLabel.text = @"北京市";
            [self requestData];
        }

    } filed:^(NSError *error) {
        MBPROGRESSHUD_TIMEOUT;
        MBPROGRESSHUD_HIDELOADINGWITH(self);

    }];
    
}

- (void)setCityNameFrame{
    
    CGSize cityLaeblSize = TEXTSIZEWITHFONT(self.cityNameLabel.text,self.cityNameLabel.font);
    [self.cityNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kPadding);
        make.right.equalTo(self.refreshBtn.mas_left).with.offset(-kPadding/3);
        make.size.mas_equalTo(cityLaeblSize);
    }];
    [self.cityNameBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityNameLabel.mas_top);
        make.bottom.equalTo(self.cityNameLabel.mas_bottom);
        make.right.equalTo(self.cityNameLabel.mas_left).with.offset(-kPadding/5);
        make.width.equalTo(@(cityLaeblSize.height));
    }];
    
}

//风 数据
- (void)setWindDataWithDict:(NSDictionary *)dict{
    
    self.windInfo.text = [NSString stringWithFormat:@"%@ %@ ",[dict objectForKey:@"direct"],[dict objectForKey:@"power"]];
    CGSize windInfoSize = TEXTSIZEWITHFONT(self.windInfo.text, self.windInfo.font);
    [self.windInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weatherInfo.mas_left);
        make.top.equalTo(self.weatherInfo.mas_bottom).with.offset(5);
        make.size.mas_equalTo(windInfoSize);
    }];
}

//PM数据
- (void)setPMDataWithDict:(NSDictionary *)dict{
    
    self.PMLabel.text = [NSString stringWithFormat:@"空气质量 %@ ",[dict objectForKey:@"quality"]];
    CGSize PMLabelSize = TEXTSIZEWITHFONT(self.PMLabel.text, self.PMLabel.font);
    [self.PMLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weatherInfo.mas_left);
        make.top.equalTo(self.windInfo.mas_bottom).with.offset(5);
        make.size.mas_equalTo(PMLabelSize);
    }];
}

//星期和温度区间  当前天气情况
- (void)setWeekDataWithArray:(NSArray *)array andNowWeatherDict:(NSDictionary *)dict{
    
    NSDictionary *todayDict = array[0];//当天天气情况
    self.weekLabel.text = [NSString stringWithFormat:@"周%@",[todayDict objectForKey:@"week"]];
    CGSize weekSize = TEXTSIZEWITHFONT(self.weekLabel.text, self.weekLabel.font);
    [self.weekLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.temperatureLabel.mas_left);
        make.bottom.equalTo(self.weatherIcon.mas_bottom);
        make.size.mas_equalTo(weekSize);
    }];
    NSDictionary *todayInfo = [todayDict objectForKey:@"info"];
    self.dayTemperature.text = [NSString stringWithFormat:@"%@°/%@° ",[todayInfo objectForKey:@"night"][2],[todayInfo objectForKey:@"day"][2]];
    CGSize dayTemperatureSize = TEXTSIZEWITHFONT(self.dayTemperature.text, self.dayTemperature.font);
    [self.dayTemperature mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel.mas_right).with.offset(kPadding/2);
        make.bottom.equalTo(self.weatherIcon.mas_bottom);
        make.size.mas_equalTo(dayTemperatureSize);
    }];
    
    NSDictionary *tomorrowDict = array[1];//明天天气情况
    self.tomorrowWeek.text = [NSString stringWithFormat:@"周%@",[tomorrowDict objectForKey:@"week"]];
    CGSize tomorrowWeekSize = TEXTSIZEWITHFONT(self.tomorrowWeek.text, self.tomorrowWeek.font);
    [self.tomorrowWeek mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tomorrow.mas_right).with.offset(kPadding/2);
        make.centerY.equalTo(self.tomorrow.mas_centerY);
        make.size.mas_equalTo(tomorrowWeekSize);
    }];
    NSDictionary *tomorrowInfo = [tomorrowDict objectForKey:@"info"];
    self.tomorrowTemperature.text = [NSString stringWithFormat:@"%@°/%@° ",[tomorrowInfo objectForKey:@"night"][2],[tomorrowInfo objectForKey:@"day"][2]];
    CGSize tomorrowTemperatureSize = TEXTSIZEWITHFONT(self.tomorrowTemperature.text, self.tomorrowTemperature.font);
    [self.tomorrowTemperature mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tomorrowWeek.mas_right).with.offset(kPadding/2);
        make.centerY.equalTo(self.tomorrow.mas_centerY);
        make.size.mas_equalTo(tomorrowTemperatureSize);
    }];
    if ([[tomorrowInfo objectForKey:@"day"][1] isEqualToString:[tomorrowInfo objectForKey:@"night"][1]]) {
        self.tomorrowWeatherInfo.text = [tomorrowInfo objectForKey:@"day"][1];
    }else{
        self.tomorrowWeatherInfo.text = [NSString stringWithFormat:@"%@转%@ ",[tomorrowInfo objectForKey:@"day"][1],[tomorrowInfo objectForKey:@"night"][1]];
    }
    CGSize tomorrowWeatherInfoSize = TEXTSIZEWITHFONT(self.tomorrowWeatherInfo.text, self.tomorrowWeatherInfo.font);
    [self.tomorrowWeatherInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PMLabel.mas_left);
        make.centerY.equalTo(self.tomorrow.mas_centerY);
        make.size.mas_equalTo(tomorrowWeatherInfoSize);
    }];
    
    self.temperatureLabel.text = [NSString stringWithFormat:@"%@° ",[dict objectForKey:@"temperature"]];
    CGSize temLabelSize = TEXTSIZEWITHFONT(self.temperatureLabel.text, self.temperatureLabel.font);
    [self.temperatureLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weatherIcon.mas_top);
        make.left.equalTo(self.weatherIcon.mas_right).with.offset(kPadding/2);
        make.size.mas_equalTo(temLabelSize);
    }];
    
    self.weatherInfo.text = [NSString stringWithFormat:@"%@ ",[dict objectForKey:@"info"]];
    CGSize weatherInfoSize = TEXTSIZEWITHFONT(self.weatherInfo.text, self.weatherInfo.font);
    [self.weatherInfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayTemperature.mas_right).with.offset(kPadding);
        make.top.equalTo(self.weatherIcon.mas_top);
        make.size.mas_equalTo(weatherInfoSize);
    }];
    
    NSString *dayOrNight = [self isBetweenFromTime:[todayInfo objectForKey:@"day"][5] toTime:[todayInfo objectForKey:@"night"][5]];
    NSString *imageName = nil;
    if ([dayOrNight isEqualToString:@"night"]) {
        self.backImage.image = [UIImage imageNamed:@"weather_back_night"];
        imageName = [NSString stringWithFormat:@"%@%@",dayOrNight,[dict objectForKey:@"img"]];
    }else{
        self.backImage.image = [UIImage imageNamed:@"faxian_ditu"];
        imageName = [NSString stringWithFormat:@"%@%@",dayOrNight,[dict objectForKey:@"img"]];
    }
    
    self.weatherIcon.image = [UIImage imageNamed:imageName];
}
/**
 *  判断当前时间是白天还是晚上 根据给定的时间段
 *
 *  @param fromTime 起始时间段
 *  @param toTime   结束时间段
 *
 *  @return 白天或夜晚
 */
- (NSString *)isBetweenFromTime:(NSString *)fromTime  toTime:(NSString *)toTime{

    NSString *fromHour = [[fromTime componentsSeparatedByString:@":"] firstObject];
    NSString *fromMin = [[fromTime componentsSeparatedByString:@":"] lastObject];
    NSString *toHour = [[toTime componentsSeparatedByString:@":"] firstObject];
    NSString *toMin = [[toTime componentsSeparatedByString:@":"] lastObject];
    
    NSDate *date8 = [self getCustomDateWithHour:[fromHour integerValue] andMinute:[fromMin integerValue]];
    NSDate *date23 = [self getCustomDateWithHour:[toHour integerValue] andMinute:[toMin integerValue]];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:date8]== NSOrderedDescending && [currentDate compare:date23]== NSOrderedAscending){
        NSLog(@"该时间在 %@-%@ 之间！", fromTime, toTime);
        return @"day";
    }
    return @"night";
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
- (NSDate *)getCustomDateWithHour:(NSInteger)hour andMinute:(NSInteger)minute
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}

//跑马灯lifeinfo
- (void)setLifeDataWithDict:(NSDictionary *)dict{
    
    self.otherinfo.text = [NSString stringWithFormat:@"%@%@%@ ",[dict objectForKey:@"chuanyi"][1],[dict objectForKey:@"ganmao"][1],[dict objectForKey:@"yundong"][1]];
    [self.otherinfo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kPadding);
        make.left.and.right.offset(0);
        make.bottom.offset(-kPadding);
    }];
    [self addAnimation];
}
//设置跑马灯的属性
- (void)addAnimation{

    self.otherinfo.labelSpacing = 30; // distance between start and end labels
    self.otherinfo.pauseInterval = 0.5; // seconds of pause before scrolling starts again
    self.otherinfo.scrollSpeed = 30; // pixels per second
    self.otherinfo.fadeLength = 12.f;
    self.otherinfo.textAlignment = NSTextAlignmentCenter;
    self.otherinfo.scrollDirection = CBAutoScrollDirectionLeft;
    [self.otherinfo observeApplicationNotifications];
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
    MBPROGRESSHUD_SHOWLOADINGWITH(self);
    
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
                if (self.cityNameLabel.text.length == 0) {
                    [self.superview makeToast:@"定位失败,切换为北京市"];
                    self.cityNameLabel.text = @"北京市";
                }
                [self requestData];
            }else{
                [self.superview makeToast:@"位置不可用,切换为北京市"];
                self.cityNameLabel.text = @"北京市";
                [self requestData];
            }
            
        }];
        
    }
    // 如果只需要获取一次位置, 那么在此处停止获取用户位置
    [manager stopUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.superview makeToast:@"定位失败,切换为北京市"];
    self.cityNameLabel.text = @"北京市";
    [self requestData];
}

@end
