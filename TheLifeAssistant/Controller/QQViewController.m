//
//  QQViewController.m
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/23.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "QQViewController.h"

static CGFloat kTextCornerRadius = 5;
static CGFloat kTextBorderWidth = 1;
static NSString *kBackColor = @"6ecd29";
static CGFloat kTextSize = 15;

@interface QQViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *QQText;
/**
 *  结论
 */
@property(nonatomic,strong)UILabel *conclusionLabel;
/**
 *  结论分析
 */
@property(nonatomic,strong)UILabel *analysisLabel;
@property(nonatomic,strong)UILabel *label_1;
@property(nonatomic,strong)UILabel *label_2;

@end

@implementation QQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
}

- (void)configView{
    
    self.QQText = [[UITextField alloc]init];
    self.QQText.delegate = self;
    [self.view addSubview:self.QQText];
    [self.QQText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.right.equalTo(self.view).with.offset(-KMARGIN);
        make.top.equalTo(self.view).with.offset(NAVHEIGHT+KMARGIN);
        make.height.equalTo(@35);
    }];
    self.QQText.textAlignment = NSTextAlignmentCenter;
    self.QQText.keyboardType = UIKeyboardTypePhonePad;
    self.QQText.returnKeyType = UIReturnKeyDone;
    self.QQText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.QQText.layer.borderWidth = kTextBorderWidth;
    self.QQText.layer.borderColor = [UIColor colorWithHexString:kBackColor].CGColor;
    self.QQText.layer.cornerRadius = kTextCornerRadius;
    self.QQText.font = FONTSIZE(kTextSize);
    self.QQText.placeholder = @"请输入QQ号码";
    
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QQText.mas_bottom).with.offset(KMARGIN);
        make.centerX.equalTo(self.QQText.mas_centerX);
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
    self.label_1.text = @"查询结果: ";
    self.label_1.textAlignment = NSTextAlignmentCenter;
    self.label_1.font = FONTSIZE(kTextSize);
    self.label_1.textColor = [UIColor purpleColor];
    CGSize labelSize1 = TEXTSIZEWITHFONT(self.label_1.text, FONTSIZE(kTextSize));
    [self.label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(KMARGIN);
        make.top.equalTo(button.mas_bottom).with.offset(KMARGIN);
        make.size.mas_equalTo(labelSize1);
    }];
    
    self.conclusionLabel = [[UILabel alloc]init];
    self.conclusionLabel.font = FONTSIZE(kTextSize);
    [self.conclusionLabel setNumberOfLines:0];
    [self.view addSubview:self.conclusionLabel];
    
    
    self.label_2 = [[UILabel alloc]init];//
    [self.view addSubview:self.label_2];
    self.label_2.text = @"结论分析: ";
    self.label_2.textAlignment = NSTextAlignmentCenter;
    self.label_2.textColor = [UIColor purpleColor];
    self.label_2.font = FONTSIZE(kTextSize);
    
    self.analysisLabel = [[UILabel alloc]init];
    self.analysisLabel.font = FONTSIZE(kTextSize);
    [self.analysisLabel setNumberOfLines:0];
    [self.view addSubview:self.analysisLabel];
    
    [self setViewHiddenWith:YES];
}

- (void)clickBtn{
    
    self.conclusionLabel.text = @"";
    self.analysisLabel.text = @"";
    [self setViewHiddenWith:YES];
    
    MBPROGRESSHUD_SHOWLOADINGWITH(self.view);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.QQText.text forKey:@"qq"];
    [params setObject:KEY_QQ_TEST forKey:@"key"];
    
    [AFN_Request GET:API_QQ_TEST params:params success:^(id successData) {
        NSLog(@"success---%@",successData);
        MBPROGRESSHUD_HIDELOADINGWITH(self.view);
        if ([[successData objectForKey:@"error_code"]intValue] == 0) {
            NSDictionary *result = [successData objectForKey:@"result"];
            NSDictionary *data = [result objectForKey:@"data"];
            [self setViewHiddenWith:NO];
            [self setFrameWithDict:data];
            
        }else{
            [self.view makeToast:[successData objectForKey:@"reason"]];
        }
    } filed:^(NSError *error) {
        NSLog(@"errer---%@",error);
        MBPROGRESSHUD_HIDELOADINGWITH(self.view);
        MBPROGRESSHUD_TIMEOUT;
    }];
}

- (void)setFrameWithDict:(NSDictionary *)data{
    
    CGSize size_1 = CGSizeMake(KWIDTH - 4*KMARGIN, 100);
    CGSize conclusionLabelSize = [[data objectForKey:@"conclusion"] boundingRectWithSize:size_1 options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSMutableDictionary dictionaryWithObject:FONTSIZE(kTextSize+1) forKey:NSFontAttributeName] context:nil].size;
    CGSize analysisLabelSize = [[data objectForKey:@"analysis"] boundingRectWithSize:size_1 options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSMutableDictionary dictionaryWithObject:FONTSIZE(kTextSize+1) forKey:NSFontAttributeName] context:nil].size;
    
    [self.conclusionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label_1.mas_bottom).with.offset(KMARGIN/2);
        make.left.equalTo(self.label_1.mas_left).with.offset(KMARGIN);
        make.width.equalTo(@(size_1.width));
        make.height.equalTo(@(conclusionLabelSize.height));
    }];
    
    [self.label_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.conclusionLabel.mas_bottom).with.offset(KMARGIN);
        make.left.equalTo(self.label_1.mas_left);
        make.width.equalTo(self.label_1.mas_width);
        make.height.equalTo(self.label_1.mas_height);
    }];
    
    [self.analysisLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label_2.mas_bottom).with.offset(KMARGIN/2);
        make.left.equalTo(self.label_2.mas_left).with.offset(KMARGIN);
        make.size.mas_equalTo(analysisLabelSize);
    }];
    
    self.conclusionLabel.text = [data objectForKey:@"conclusion"];
    self.analysisLabel.text = [data objectForKey:@"analysis"];
    
}

#pragma textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)setViewHiddenWith:(BOOL)hidden{

    [self.label_1 setHidden:hidden];
    [self.label_2 setHidden:hidden];
    [self.conclusionLabel setHidden:hidden];
    [self.analysisLabel setHidden:hidden];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
