//
//  JokeViewController.m
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/23.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JokeViewController.h"
#import "JokeModel.h"
#import "JokeModelFrame.h"
#import "JokeTableViewCell.h"

static NSInteger kOnePagNum = 20;//一页显示的条数

@interface JokeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation JokeViewController

{
    UITableView *_JokeTableView;
    RequestFiledView *_requestView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self configView];
    [self refreshlist];
    [self getNewData];
}

- (void)configView{
    
    _JokeTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _JokeTableView.delegate = self;
    _JokeTableView.dataSource = self;
    _JokeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_JokeTableView];
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSString *)returnTime{
    
    NSDate *nowDate = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%d", (int)[nowDate timeIntervalSince1970]];
    return timeSp;
}

- (void)refreshlist{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewData)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    footer.hidden = YES;
    _JokeTableView.mj_header = header;
    _JokeTableView.mj_footer = footer;
}

#pragma mark  下拉
- (void)getNewData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KEY_GET_JOKE forKey:@"key"];
    [params setObject:@(kOnePagNum) forKey:@"pagesize"];
    [params setObject:@1 forKey:@"page"];
    [params setObject:[self returnTime] forKey:@"time"];
    [params setObject:@"desc" forKey:@"sort"];
    [self sendNetRequestWithUrl:API_GET_JOKE parameters:params type:1];
}
#pragma mark  上拉
- (void)getMoreData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KEY_GET_JOKE forKey:@"key"];
    [params setObject:@(kOnePagNum) forKey:@"pagesize"];
    [params setObject:@(self.dataArray.count/kOnePagNum+1) forKey:@"page"];
    [params setObject:[self returnTime] forKey:@"time"];
    [params setObject:@"desc" forKey:@"sort"];
    [self sendNetRequestWithUrl:API_GET_JOKE parameters:params type:2];
}

#pragma mark  请求网络
- (void)sendNetRequestWithUrl:(NSString *)strUrl parameters:(id)params type:(NSInteger)type{
    MBPROGRESSHUD_SHOWLOADINGWITH(self.view);
    [AFN_Request GET:strUrl params:params success:^(id successData) {
        MBPROGRESSHUD_HIDELOADINGWITH(self.view);
        if ([[successData objectForKey:@"error_code"]intValue] == 0) {
            NSDictionary *result = [successData objectForKey:@"result"];
            NSArray *listArr = nil;
            listArr = [JokeModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"data"]];
            listArr = [self becomeFrameWithArray:listArr];
            //1下拉 2上拉
            if (type == 1) {
                NSLog(@"列表->%@",result);
                if (listArr.count) {
                    [self.dataArray removeAllObjects];
                    [self.dataArray addObjectsFromArray:listArr];
                }else{
                    if (!_requestView) {
                        [self creatViewWithType:1];
                    }
                }
                [_JokeTableView.mj_header endRefreshing];
            }else{
                NSLog(@"更多列表->%@",result);
                [self.dataArray addObjectsFromArray:listArr];
                [_JokeTableView.mj_footer endRefreshing];
            }
            [_JokeTableView reloadData];
        }else{
            MBPROGRESSHUD_ERRORDESC;
        }
        
    } filed:^(NSError *error) {
        MBPROGRESSHUD_HIDELOADINGWITH(self.view);
        MBPROGRESSHUD_TIMEOUT;
        if (!_requestView) {
            [self creatViewWithType:2];
        }
        
    }];
    
    
}

- (NSArray *)becomeFrameWithArray:(NSArray *)array{
    
    NSMutableArray *arrayFrame = [NSMutableArray array];
    for (JokeModel *model in array) {
        JokeModelFrame *frame = [[JokeModelFrame alloc]init];
        frame.model = model;
        [arrayFrame addObject:frame];
    }
    return [arrayFrame copy];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JokeTableViewCell *cell = [JokeTableViewCell returnCellWithTableView:tableView];
    
    JokeModelFrame *frame = self.dataArray[indexPath.row];
    cell.jokeModelFrame = frame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JokeModelFrame *frame = self.dataArray[indexPath.row];
    return frame.cellH;
}

//离开此页面 停止菊花转 取消请求
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    MBPROGRESSHUD_HIDELOADINGWITH(self.view);
    [AFN_Request cancelAllOperations];
}

//无网络无内容
- (void)creatViewWithType:(NSInteger)type{
    
    NSString *title = nil;
    title = type == 1 ?@"暂无文章列表":@"请检查网络刷新";
    _requestView = [RequestFiledView configViewWithFrame:self.view.bounds Title:title Type:type selectBlock:^{
        
        if (_requestView) {
            
            [_requestView removeFromSuperview];
            _requestView = nil;
            [self getNewData];
        }
    }];
    
    [self.view addSubview:_requestView];
}

@end
