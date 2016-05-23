//
//  MainViewController.m
//  TheLifeAssistant
//
//  Created by I Smile going on 16/5/9.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "MainViewController.h"
#import "MainModel.h"
#import "MainTableViewDelegate.h"
#import "IDCardController.h"
#import "PhoneNumController.h"
#import "WeiXinViewController.h"
#import "WeatherController.h"
#import "QQViewController.h"

@interface MainViewController ()

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)MainTableViewDelegate *tableViewDelegate;
@property(nonatomic,strong)UITableView *mainTableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"主页";
    
    [self creatMainTableView];
}

- (NSArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [[NSArray alloc]init];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AssistantList" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
        _dataArray = [MainModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"dataarray"]];
    }
    return _dataArray;
}

- (void)creatMainTableView{

    self.tableViewDelegate = [MainTableViewDelegate createTableViewDelegateWithDataList:self.dataArray selectBlock:^(NSIndexPath *indexPath, NSString *name) {
        [self pushControllerWithName:name IndexPath:indexPath];
    }];
    self.mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.mainTableView.delegate = self.tableViewDelegate;
    self.mainTableView.dataSource = self.tableViewDelegate;
    [self.view addSubview:self.mainTableView];
}

- (void)pushControllerWithName:(NSString *)name IndexPath:(NSIndexPath *)indexPath{

    UIViewController *nextCtrl = nil;
    switch (indexPath.row) {
        case 0://手机号归属地
            nextCtrl = [[PhoneNumController alloc]init];
            break;
        case 1://身份证查询
            nextCtrl = [[IDCardController alloc]init];
            break;
        case 2://天气预报
            nextCtrl = [[WeatherController alloc]init];
            break;
        case 3://星座运势
            [self.view makeToast:@"......"];
            break;
        case 4://笑话大全
            [self.view makeToast:@"......"];
            break;
        case 5://微信精选
            nextCtrl = [[WeiXinViewController alloc]init];
            break;
        case 6://QQ测吉凶
            nextCtrl = [[QQViewController alloc]init];
            break;
        case 7://历史上的今天
            [self.view makeToast:@"......"];
            break;
        case 8://火车时刻表
            [self.view makeToast:@"......"];
            break;
        case 9://IP地址查询
            [self.view makeToast:@"......"];
            break;
        case 10://NBA赛事
            [self.view makeToast:@"......"];
            break;
        case 11://足球联赛
            [self.view makeToast:@"......"];
            break;
        case 12://新华字典
            [self.view makeToast:@"......"];
            break;
        case 13://成语词典
            [self.view makeToast:@"......"];
            break;
        case 14://新闻
            [self.view makeToast:@"......"];
            break;
        case 15://电影票房
            [self.view makeToast:@"......"];
            break;
        case 16://货币汇率
            [self.view makeToast:@"......"];
            break;
        case 17://影视检索
            [self.view makeToast:@"......"];
            break;
        case 18://周公解梦
            [self.view makeToast:@"......"];
            break;
        case 19://周边WIFI
            [self.view makeToast:@"......"];
            break;
        case 20://股票数据
            [self.view makeToast:@"......"];
            break;
        default:
            break;
    }
    nextCtrl.title = name;
    [self.navigationController pushViewController:nextCtrl animated:YES];
}

@end
