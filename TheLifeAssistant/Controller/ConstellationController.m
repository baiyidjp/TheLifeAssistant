//
//  ConstellationController.m
//  TheLifeAssistant
//
//  Created by I Smile going on 16/5/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ConstellationController.h"
#import "ListView.h"
#import "TodayView.h"

@interface ConstellationController ()

@property(nonatomic,strong)UIButton *constellationBtn;//选择星座
@property(nonatomic,strong)UIButton *timeBtn;//选择时间
@property(nonatomic,strong)UIButton *queryBtn;//查询
@property(nonatomic,strong)UIView *infoView;
@property(nonatomic,strong)NSArray *contellationArray;
@property(nonatomic,strong)NSArray *timeArray;
@end

@implementation ConstellationController
{
    ListView *_listView;
    NSString *_time;
    UIView *_currentInfoView;
}

- (NSArray *)contellationArray{

    if (!_contellationArray) {
        _contellationArray = [[NSArray alloc]init];
        _contellationArray = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
    }
    return _contellationArray;
}

- (NSArray *)timeArray{
    
    if (!_timeArray) {
        _timeArray = [[NSArray alloc]init];
        _timeArray = @[@"今天",@"本周",@"本月",@"今年"];
    }
    return _timeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
}

- (void)configView{
    
    self.constellationBtn = [[UIButton alloc]init];
    [self.constellationBtn setTitle:@"请选择星座" forState:UIControlStateNormal];
    [self setBtnWithBtn:self.constellationBtn];
    [self.view addSubview:self.constellationBtn];
    [self.constellationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(KMARGIN+NAVHEIGHT);
        make.left.offset(KMARGIN);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    [self.constellationBtn addTarget:self action:@selector(chooseContellation:) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeBtn = [[UIButton alloc]init];
    [self.timeBtn setTitle:@"请选择时间" forState:UIControlStateNormal];
    _time = @"today";
    [self setBtnWithBtn:self.timeBtn];
    [self.view addSubview:self.timeBtn];
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(KMARGIN+NAVHEIGHT);
        make.left.equalTo(self.constellationBtn.mas_right).with.offset(KMARGIN);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    [self.timeBtn addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
    
    self.queryBtn = [[UIButton alloc]init];
    [self.queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [self setBtnWithBtn:self.queryBtn];
    [self.view addSubview:self.queryBtn];
    [self.queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(KMARGIN+NAVHEIGHT);
        make.left.equalTo(self.timeBtn.mas_right).with.offset(KMARGIN);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    [self.queryBtn addTarget:self action:@selector(queryInfo) forControlEvents:UIControlEventTouchUpInside];
    
    self.infoView = [[UIView alloc]init];
    [self.view addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.top.equalTo(self.constellationBtn.mas_bottom).with.offset(KMARGIN);
    }];
}

- (void)setBtnWithBtn:(UIButton *)button{

    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:FONTSIZE(15)];
    [button.layer setCornerRadius:5];
    [button.layer setBorderWidth:1];
    [button.layer setBorderColor:[UIColor greenColor].CGColor];
}

- (void)chooseContellation:(UIButton *)button{
    
    button.selected = !button.selected;
    [self creatClassViewWithSelected:button.selected type:1];

}

- (void)chooseTime:(UIButton *)button{

    button.selected = !button.selected;
    [self creatClassViewWithSelected:button.selected type:2];

}

- (void)creatClassViewWithSelected:(BOOL)selected type:(NSInteger)type{
    
    UIButton *button = nil;
    NSArray *dataArray = nil;
    if (type == 1) {
        button = self.constellationBtn;
        dataArray = self.contellationArray;
    }else{
        button = self.timeBtn;
        dataArray = self.timeArray;
    }
    
    if (selected) {
        if (!_listView) {
            _listView = [ListView creatListViewWithTopView:button dataArray:dataArray selectBlock:^(NSString *name) {
                if (name) {
                    [button setTitle:name forState:UIControlStateNormal];
                    [self setTime:name];
                }
                if (type == 1) {
                    [self chooseContellation:button];
                }else{
                    [self chooseTime:button];
                }
            }];
            _listView.frame = CGRectMake(0, -self.view.height, self.view.width, self.view.height);
            [UIView animateWithDuration:0.1 animations:^{
                _listView.y = 0;
            }];
            [self.view addSubview:_listView];
        }
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _listView.alpha = 0.0;
            _listView.y = -self.view.height;
        } completion:^(BOOL finished) {
            if (_listView) {
                
                [_listView removeFromSuperview];
                _listView = nil;
            }
        }];
    }
}

- (void)setTime:(NSString *)name{
    
    if ([name isEqualToString:@"今天"]) {
        _time = @"today";
    }
    if ([name isEqualToString:@"本周"]) {
        _time = @"week";
    }
    if ([name isEqualToString:@"本月"]) {
        _time = @"month";
    }
    if ([name isEqualToString:@"今年"]) {
        _time = @"year";
    }
}

- (void)queryInfo{
    
    if (_currentInfoView) {
        [_currentInfoView removeFromSuperview];
        _currentInfoView = nil;
    }
    
    MBPROGRESSHUD_SHOWLOADINGWITH(self.view);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.constellationBtn.titleLabel.text forKey:@"consName"];
    [params setObject:_time forKey:@"type"];
    [params setObject:KEY_CONSTELLATION_FORTUNE forKey:@"key"];
    
    [AFN_Request GET:API_CONSTELLATION_FORTUNE params:params success:^(id successData) {
        NSLog(@"success---%@",successData);
        MBPROGRESSHUD_HIDELOADINGWITH(self.view);
        if (REQUESSUCCESS) {
            [self getViewWith:successData];
        }else{
            [self.view makeToast:[successData objectForKey:@"reason"]];
        }
    } filed:^(NSError *error) {
        NSLog(@"errer---%@",error);
        MBPROGRESSHUD_HIDELOADINGWITH(self.view);
        MBPROGRESSHUD_TIMEOUT;
    }];

}

- (void)getViewWith:(NSDictionary *)data{

    if ([_time isEqualToString:@"today"]) {
        
        TodayView *todayView = [TodayView getTodayViewWithFrame:self.infoView.bounds data:data];
        [self.infoView addSubview:todayView];
        _currentInfoView = todayView;
    }
}

@end
