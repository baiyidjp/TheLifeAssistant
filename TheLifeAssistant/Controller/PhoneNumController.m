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
@property(nonatomic,strong)UILabel *label_1;
@property(nonatomic,strong)UILabel *label_2;
@property(nonatomic,strong)UILabel *label_3;
@property(nonatomic,strong)UILabel *label_4;
@property(nonatomic,strong)UILabel *label_5;
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
    self.phoneText.delegate = self;
    [self.view addSubview:self.phoneText];
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.right.equalTo(self.view).with.offset(-KMARGIN);
        make.top.equalTo(self.view).with.offset(NAVHEIGHT+KMARGIN);
        make.height.equalTo(@35);
    }];
    self.phoneText.textAlignment = NSTextAlignmentCenter;
    self.phoneText.keyboardType = UIKeyboardTypePhonePad;
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
    
    self.label_1 = [[UILabel alloc]init];//
    [self.view addSubview:self.label_1];
    [self.label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.top.equalTo(button.mas_bottom).with.offset(KMARGIN);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    self.label_1.text = @"地区:";
    self.label_1.textAlignment = NSTextAlignmentCenter;
    self.label_1.font = FONTSIZE(kTextSize);
    
    self.label_2 = [[UILabel alloc]init];//
    [self.view addSubview:self.label_2];
    [self.label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.top.equalTo(self.label_1.mas_bottom);
        make.width.equalTo(self.label_1.mas_width);
        make.height.equalTo(self.label_1.mas_height);
    }];
    self.label_2.text = @"区号:";
    self.label_2.textAlignment = NSTextAlignmentCenter;
    self.label_2.font = FONTSIZE(kTextSize);
    
    self.label_3 = [[UILabel alloc]init];//
    [self.view addSubview:self.label_3];
    [self.label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.top.equalTo(self.label_2.mas_bottom);
        make.width.equalTo(self.label_1.mas_width);
        make.height.equalTo(self.label_1.mas_height);
    }];
    self.label_3.text = @"邮编:";
    self.label_3.textAlignment = NSTextAlignmentCenter;
    self.label_3.font = FONTSIZE(kTextSize);
    
    self.label_4 = [[UILabel alloc]init];//
    [self.view addSubview:self.label_4];
    [self.label_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.top.equalTo(self.label_3.mas_bottom);
        make.width.equalTo(self.label_1.mas_width);
        make.height.equalTo(self.label_1.mas_height);
    }];
    self.label_4.text = @"运营商:";
    self.label_4.textAlignment = NSTextAlignmentCenter;
    self.label_4.font = FONTSIZE(kTextSize);
    
    self.label_5 = [[UILabel alloc]init];//
    [self.view addSubview:self.label_5];
    [self.label_5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.top.equalTo(self.label_4.mas_bottom);
        make.width.equalTo(self.label_1.mas_width);
        make.height.equalTo(self.label_1.mas_height);
    }];
    self.label_5.text = @"卡类型:";
    self.label_5.textAlignment = NSTextAlignmentCenter;
    self.label_5.font = FONTSIZE(kTextSize);
    
    self.cityLabel = [[UILabel alloc]init];
    [self.view addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(self.label_1.mas_top);
        make.height.equalTo(self.label_1.mas_height);
    }];
    self.cityLabel.font = FONTSIZE(15);
    
    self.areacodeLabel = [[UILabel alloc]init];
    [self.view addSubview:self.areacodeLabel];
    [self.areacodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(self.label_2.mas_top);
        make.height.equalTo(self.label_1.mas_height);
    }];
    self.areacodeLabel.font = FONTSIZE(15);
    
    self.zipLabel = [[UILabel alloc]init];
    [self.view addSubview:self.zipLabel];
    [self.zipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(self.label_3.mas_top);
        make.height.equalTo(self.label_1.mas_height);
    }];
    self.zipLabel.font = FONTSIZE(15);
    
    self.companyLabel = [[UILabel alloc]init];
    [self.view addSubview:self.companyLabel];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(self.label_4.mas_top);
        make.height.equalTo(self.label_1.mas_height);
    }];
    self.companyLabel.font = FONTSIZE(15);
    
    self.cardLabel = [[UILabel alloc]init];
    [self.view addSubview:self.cardLabel];
    [self.cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(self.label_5.mas_top);
        make.height.equalTo(self.label_1.mas_height);
    }];
    self.cardLabel.font = FONTSIZE(15);

    [self setViewHiddenWith:YES];
}

- (void)clickBtn{
    
    [self setViewHiddenWith:YES];
    
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
            [self setViewHiddenWith:NO];
        }else{
            [self.view makeToast:[successData objectForKey:@"reason"]];
        }
    } filed:^(NSError *error) {
        NSLog(@"errer---%@",error);
        MBPROGRESSHUD_HIDELOADINGWITH(self.view);
        MBPROGRESSHUD_TIMEOUT;
    }];
}

- (void)setViewHiddenWith:(BOOL)hidden{
    
    self.cityLabel.hidden = hidden;
    self.areacodeLabel.hidden = hidden;
    self.zipLabel.hidden = hidden;
    self.companyLabel.hidden = hidden;
    self.cardLabel.hidden = hidden;
    self.label_1.hidden = hidden;
    self.label_2.hidden = hidden;
    self.label_3.hidden = hidden;
    self.label_4.hidden = hidden;
    self.label_5.hidden = hidden;
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
