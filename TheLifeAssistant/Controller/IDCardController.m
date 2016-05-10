//
//  IDCardController.m
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "IDCardController.h"
#import "AFNetworking.h"

static CGFloat kTextCornerRadius = 5;
static CGFloat kTextBorderWidth = 1;
static NSString *kBackColor = @"6ecd29";
static CGFloat kTextSize = 15;

@interface IDCardController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *idcardText;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UILabel *sexLabel;
@property(nonatomic,strong)UILabel *brithdayLabel;
@property(nonatomic,strong)UILabel *errerLabel;

@end

@implementation IDCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configView];
}

- (void)configView{

    self.idcardText = [[UITextField alloc]init];
    _idcardText.delegate = self;
    [self.view addSubview:self.idcardText];
    [self.idcardText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.right.equalTo(self.view).with.offset(-KMARGIN);
        make.top.equalTo(self.view).with.offset(NAVHEIGHT+KMARGIN);
        make.height.equalTo(@35);
    }];
    self.idcardText.textAlignment = NSTextAlignmentCenter;
    self.idcardText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.idcardText.returnKeyType = UIReturnKeyDone;
    self.idcardText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.idcardText.layer.borderWidth = kTextBorderWidth;
    self.idcardText.layer.borderColor = [UIColor colorWithHexString:kBackColor].CGColor;
    self.idcardText.layer.cornerRadius = kTextCornerRadius;
    self.idcardText.font = FONTSIZE(kTextSize);
    self.idcardText.placeholder = @"请输入18位中国大陆身份证号码";
    
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idcardText.mas_bottom).with.offset(KMARGIN);
        make.centerX.equalTo(self.idcardText.mas_centerX);
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
    label_1.text = @"地址:";
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
    label_2.text = @"性别:";
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
    label_3.text = @"生日:";
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
    label_4.text = @"错误:";
    label_4.textAlignment = NSTextAlignmentCenter;
    label_4.font = FONTSIZE(kTextSize);
    
    self.addressLabel = [[UILabel alloc]init];
    [self.view addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(label_1.mas_top);
        make.height.equalTo(label_1.mas_height);
    }];
    self.addressLabel.font = FONTSIZE(15);
    
    self.sexLabel = [[UILabel alloc]init];
    [self.view addSubview:self.sexLabel];
    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(label_2.mas_top);
        make.height.equalTo(label_1.mas_height);
    }];
    self.sexLabel.font = FONTSIZE(15);
    
    self.brithdayLabel = [[UILabel alloc]init];
    [self.view addSubview:self.brithdayLabel];
    [self.brithdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(label_3.mas_top);
        make.height.equalTo(label_1.mas_height);
    }];
    self.brithdayLabel.font = FONTSIZE(15);
    
    self.errerLabel = [[UILabel alloc]init];
    [self.view addSubview:self.errerLabel];
    [self.errerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_right).with.offset(KMARGIN/2);
        make.right.offset(-KMARGIN);
        make.top.equalTo(label_4.mas_top);
        make.height.equalTo(label_1.mas_height);
    }];
    self.errerLabel.font = FONTSIZE(15);

}

- (void)clickBtn{
    
    self.addressLabel.text = @"";
    self.sexLabel.text = @"";
    self.brithdayLabel.text = @"";
    self.errerLabel.text = @"";
    MBPROGRESSHUD_SHOWLOADINGWITH(self.view);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.idcardText.text forKey:@"cardno"];
    [params setObject:@"json" forKey:@"dtype"];
    [params setObject:KEY_FIND_IDCARD forKey:@"key"];
        
    [AFN_Request GET:API_FIND_IDCARD params:params success:^(id successData) {
        NSLog(@"success---%@",successData);
        MBPROGRESSHUD_HIDELOADINGWITH(self.view);
        if (REQUESSUCCESS) {
            NSDictionary *result = [successData objectForKey:@"result"];
            self.addressLabel.text = [result objectForKey:@"area"];
            self.sexLabel.text = [result objectForKey:@"sex"];
            self.brithdayLabel.text = [result objectForKey:@"birthday"];
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
