//
//  TodayView.m
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/25.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "TodayView.h"

static NSString *kTextColor = @"888888";
static CGFloat kTextSize = 13;

@implementation TodayView
{
    NSDictionary *_data;
    UILabel *_allLabel;//综合指数
    UILabel *_colorLabel;//幸运色
    UILabel *_healthLabel;//健康指数
    UILabel *_loveLabel;//恋爱指数
    UILabel *_moneyLabel;//财运指数
    UILabel *_numberLabel;//幸运数字
    UILabel *_qfriendLabel;//速配星座
    UILabel *_workLabel;//工作指数
    UILabel *_summaryLabel;//运势总结
}
+ (TodayView *)getTodayViewWithFrame:(CGRect)frame data:(NSDictionary *)data{
    
    return [[[self class]alloc]initWithFrame:frame data:data];
}

- (instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)data{

    self = [super init];
    if (self) {
        self.frame = frame;
        _data = data;
        [self configView];
    }
    return self;
}

- (void)configView{

    _allLabel = [[UILabel alloc]init];
    [self setLabel:_allLabel];
    _allLabel.text = [NSString stringWithFormat:@"综合指数: %@",[_data objectForKey:@"all"]];
    [self addSubview:_allLabel];
    [_allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(KMARGIN);
        make.width.equalTo(@(self.width - 2*KMARGIN));
        make.height.equalTo(@25);
    }];
    
    _workLabel = [[UILabel alloc]init];
    [self setLabel:_workLabel];
    _workLabel.text = [NSString stringWithFormat:@"工作指数: %@",[_data objectForKey:@"work"]];
    [self addSubview:_workLabel];
    [_workLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_allLabel.mas_bottom);
        make.left.equalTo(_allLabel.mas_left);
        make.width.equalTo(_allLabel.mas_width);
        make.height.equalTo(_allLabel.mas_height);
    }];
   
    
    _healthLabel = [[UILabel alloc]init];
    [self setLabel:_healthLabel];
    _healthLabel.text = [NSString stringWithFormat:@"健康指数: %@",[_data objectForKey:@"health"]];
    [self addSubview:_healthLabel];
    [_healthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_workLabel.mas_bottom);
        make.left.equalTo(_allLabel.mas_left);
        make.width.equalTo(_allLabel.mas_width);
        make.height.equalTo(_allLabel.mas_height);
    }];
    
    _loveLabel = [[UILabel alloc]init];
    [self setLabel:_loveLabel];
    _loveLabel.text = [NSString stringWithFormat:@"恋爱指数: %@",[_data objectForKey:@"love"]];
    [self addSubview:_loveLabel];
    [_loveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_healthLabel.mas_bottom);
        make.left.equalTo(_allLabel.mas_left);
        make.width.equalTo(_allLabel.mas_width);
        make.height.equalTo(_allLabel.mas_height);
    }];
    
    _moneyLabel = [[UILabel alloc]init];
    [self setLabel:_moneyLabel];
    _moneyLabel.text = [NSString stringWithFormat:@"财运指数: %@",[_data objectForKey:@"money"]];
    [self addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loveLabel.mas_bottom);
        make.left.equalTo(_allLabel.mas_left);
        make.width.equalTo(_allLabel.mas_width);
        make.height.equalTo(_allLabel.mas_height);
    }];
    
    _numberLabel = [[UILabel alloc]init];
    [self setLabel:_numberLabel];
    _numberLabel.text = [NSString stringWithFormat:@"幸运数字: %@",[_data objectForKey:@"number"]];
    [self addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyLabel.mas_bottom);
        make.left.equalTo(_allLabel.mas_left);
        make.width.equalTo(_allLabel.mas_width);
        make.height.equalTo(_allLabel.mas_height);
    }];
    
    _qfriendLabel = [[UILabel alloc]init];
    [self setLabel:_qfriendLabel];
    _qfriendLabel.text = [NSString stringWithFormat:@"速配星座: %@",[_data objectForKey:@"QFriend"]];
    [self addSubview:_qfriendLabel];
    [_qfriendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numberLabel.mas_bottom);
        make.left.equalTo(_allLabel.mas_left);
        make.width.equalTo(_allLabel.mas_width);
        make.height.equalTo(_allLabel.mas_height);
    }];
    
    _colorLabel = [[UILabel alloc]init];
    [self setLabel:_colorLabel];
    _colorLabel.text = [NSString stringWithFormat:@"幸运颜色: %@",[_data objectForKey:@"color"]];
    [self addSubview:_colorLabel];
    [_colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_qfriendLabel.mas_bottom);
        make.left.equalTo(_allLabel.mas_left);
        make.width.equalTo(_allLabel.mas_width);
        make.height.equalTo(_allLabel.mas_height);
    }];
    
    _summaryLabel = [[UILabel alloc]init];
    [self setLabel:_summaryLabel];
    _summaryLabel.text = [NSString stringWithFormat:@"综合运势: %@",[_data objectForKey:@"summary"]];
    _summaryLabel.numberOfLines = 0;
    CGSize size_1 = CGSizeMake(KWIDTH - 2*KMARGIN, 100);
    CGSize summaryLabelSize = [_summaryLabel.text boundingRectWithSize:size_1 options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSMutableDictionary dictionaryWithObject:FONTSIZE(kTextSize+1) forKey:NSFontAttributeName] context:nil].size;
    [self addSubview:_summaryLabel];
    [_summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_colorLabel.mas_bottom);
        make.left.equalTo(_allLabel.mas_left);
        make.width.equalTo(_allLabel.mas_width);
        make.height.equalTo(@(summaryLabelSize.height));
    }];
}

- (void)setLabel:(UILabel *)label{

    label.textColor = [UIColor colorWithHexString:kTextColor];
    label.font = FONTSIZE(kTextSize);
}

@end
