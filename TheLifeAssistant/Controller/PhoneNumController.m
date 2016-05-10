//
//  PhoneNumController.m
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "PhoneNumController.h"

static CGFloat kTextCornerRadius = 5;
static CGFloat kTextBorderWidth = 1;
static NSString *kBackColor = @"6ecd29";
static CGFloat kTextSize = 15;

@interface PhoneNumController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *phoneText;
@property(nonatomic,strong)UILabel *cityLabel;//城市
@property(nonatomic,strong)UILabel *areacodeLabel;//区号
@property(nonatomic,strong)UILabel *zipLabel;//邮编
@property(nonatomic,strong)UILabel *companyLabel;//运营商
@property(nonatomic,strong)UILabel *cardLabel;//手机卡类型
@property(nonatomic,strong)UILabel *errerLabel;

@end
@implementation PhoneNumController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configView];
}

- (void)configView{
    
    self.phoneText = [[UITextField alloc]init];
    _phoneText.delegate = self;
    [self.view addSubview:self.phoneText];
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.right.equalTo(self.view).with.offset(-KMARGIN);
        make.top.equalTo(self.view).with.offset(NAVHEIGHT+KMARGIN);
        make.height.equalTo(@35);
    }];
    self.phoneText.textAlignment = NSTextAlignmentCenter;
    self.phoneText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.phoneText.returnKeyType = UIReturnKeyDone;
    self.phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneText.layer.borderWidth = kTextBorderWidth;
    self.phoneText.layer.borderColor = [UIColor colorWithHexString:kBackColor].CGColor;
    self.phoneText.layer.cornerRadius = kTextCornerRadius;
    self.phoneText.font = FONTSIZE(kTextSize);
    self.phoneText.placeholder = @"请输入手机号码";
    
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneText.mas_bottom).with.offset(KMARGIN);
        make.centerX.equalTo(self.phoneText.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    button.backgroundColor = [UIColor colorWithHexString:@"2598f9"];
    [button setTitle:@"查询" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:FONTSIZE(15)];
    [button.layer setCornerRadius:5];
    [button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label_1 = [[UILabel alloc]init];//
    [self.view addSubview:label_1];
    [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.top.equalTo(button.mas_bottom).with.offset(KMARGIN);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    label_1.text = @"地区:";
    label_1.textAlignment = NSTextAlignmentCenter;
    label_1.font = FONTSIZE(kTextSize);
    
    UILabel *label_2 = [[UILabel alloc]init];//
    [self.view addSubview:label_2];
    [label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.top.equalTo(label_1.mas_bottom);
        make.width.equalTo(label_1.mas_width);
        make.height.equalTo(label_1.mas_height);
    }];
    label_2.text = @"区号:";
    label_2.textAlignment = NSTextAlignmentCenter;
    label_2.font = FONTSIZE(kTextSize);
    
    UILabel *label_3 = [[UILabel alloc]init];//
    [self.view addSubview:label_3];
    [label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.top.equalTo(label_2.mas_bottom);
        make.width.equalTo(label_1.mas_width);
        make.height.equalTo(label_1.mas_height);
    }];
    label_3.text = @"邮编:";
    label_3.textAlignment = NSTextAlignmentCenter;
    label_3.font = FONTSIZE(kTextSize);
    
    UILabel *label_4 = [[UILabel alloc]init];//
    [self.view addSubview:label_4];
    [label_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.top.equalTo(label_3.mas_bottom);
        make.width.equalTo(label_1.mas_width);
        make.height.equalTo(label_1.mas_height);
    }];
    label_4.text = @"运营商:";
    label_4.textAlignment = NSTextAlignmentCenter;
    label_4.font = FONTSIZE(kTextSize);
    
    UILabel *label_5 = [[UILabel alloc]init];//
    [self.view addSubview:label_5];
    [label_5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.top.equalTo(label_4.mas_bottom);
        make.width.equalTo(label_1.mas_width);
        make.height.equalTo(label_1.mas_height);
    }];
    label_5.text = @"卡类型:";
    label_5.textAlignment = NSTextAlignmentCenter;
    label_5.font = FONTSIZE(kTextSize);
    
    UILabel *label_6 = [[UILabel alloc]init];//
    [self.view addSubview:label_6];
    [label_6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.top.equalTo(label_5.mas_bottom);
        make.width.equalTo(label_1.mas_width);
        make.height.equalTo(label_1.mas_height);
    }];
    label_6.text = @"错误码:";
    label_6.textAlignment = NSTextAlignmentCenter;
    label_6.font = FONTSIZE(kTextSize);
    
    self.cityLabel = [[UILabel alloc]init];
    [self.view addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(label_1.mas_top);
        make.height.equalTo(label_1.mas_height);
    }];
    self.cityLabel.font = FONTSIZE(15);
    
    self.areacodeLabel = [[UILabel alloc]init];
    [self.view addSubview:self.areacodeLabel];
    [self.areacodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(label_2.mas_top);
        make.height.equalTo(label_1.mas_height);
    }];
    self.areacodeLabel.font = FONTSIZE(15);
    
    self.zipLabel = [[UILabel alloc]init];
    [self.view addSubview:self.zipLabel];
    [self.zipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(label_3.mas_top);
        make.height.equalTo(label_1.mas_height);
    }];
    self.zipLabel.font = FONTSIZE(15);
    
    self.companyLabel = [[UILabel alloc]init];
    [self.view addSubview:self.companyLabel];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(label_4.mas_top);
        make.height.equalTo(label_1.mas_height);
    }];
    self.companyLabel.font = FONTSIZE(15);
    
    self.cardLabel = [[UILabel alloc]init];
    [self.view addSubview:self.cardLabel];
    [self.cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(label_5.mas_top);
        make.height.equalTo(label_1.mas_height);
    }];
    self.cardLabel.font = FONTSIZE(15);
    
    self.errerLabel = [[UILabel alloc]init];
    [self.view addSubview:self.errerLabel];
    [self.errerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(label_6.mas_top);
        make.height.equalTo(label_1.mas_height);
    }];
    self.errerLabel.font = FONTSIZE(15);
    
}

- (void)clickBtn{
    
    self.cityLabel.text = @"";
    self.areacodeLabel.text = @"";
    self.zipLabel.text = @"";
    self.companyLabel.text = @"";
    self.cardLabel.text = @"";
    self.errerLabel.text = @"";
    MBPROGRESSHUD_SHOWLOADINGWITH(self.view);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneText.text forKey:@"phone"];
    [params setObject:@"json" forKey:@"dtype"];
    [params setObject:KEY_PHONENUM_ADDRESS forKey:@"key"];
    
    [AFN_Request GET:API_PHONENUM_ADDRESS params:params success:^(id successData) {
        NSLog(@"success---%@",successData);
        MBPROGRESSHUD_HIDELOADINGWITH(self.view);
        if (REQUESSUCCESS) {
            NSDictionary *result = [successData objectForKey:@"result"];
            self.cityLabel.text = [NSString stringWithFormat:@"%@-%@",[result objectForKey:@"province"],[result objectForKey:@"city"]];
            self.areacodeLabel.text = [result objectForKey:@"areacode"];
            self.zipLabel.text = [result objectForKey:@"zip"];
            self.companyLabel.text = [result objectForKey:@"company"];
            self.cardLabel.text = [result objectForKey:@"card"];
        }else{
            self.errerLabel.text = [successData objectForKey:@"reason"];
        }
    } filed:^(NSError *error) {
        NSLog(@"errer---%@",error);
        MBPROGRESSHUD_HIDELOADINGWITH(self.view);
        MBPROGRESSHUD_TIMEOUT;
    }];
}

#pragma textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
