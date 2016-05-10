//
//  MainViewController.m
//  TheLifeAssistant
//
//  Created by I Smile going on 16/5/9.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "MainViewController.h"
#import "MainModel.h"
#import "JPTableViewDelegate.h"
#import "IDCardController.h"

@interface MainViewController ()

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)JPTableViewDelegate *tableViewDelegate;
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

    self.tableViewDelegate = [JPTableViewDelegate createTableViewDelegateWithDataList:self.dataArray selectBlock:^(NSIndexPath *indexPath, NSString *name) {
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
        case 0:
            
            break;
        case 1:
            nextCtrl = [[IDCardController alloc]init];
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 10:
            
            break;
        case 11:
            
            break;
        case 12:
            
            break;
        case 13:
            
            break;
        case 14:
            
            break;
        case 15:
            
            break;
        case 16:
            
            break;
        case 17:
            
            break;
        case 18:
            
            break;
        case 19:
            
            break;
        case 20:
            
            break;
        case 21:
            
            break;
        default:
            break;
    }
    nextCtrl.title = name;
    [self.navigationController pushViewController:nextCtrl animated:YES];
}

@end
