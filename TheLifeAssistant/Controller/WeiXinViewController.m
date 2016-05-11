//
//  WeiXinViewController.m
//  TheLifeAssistant
//
//  Created by I Smile going on 16/5/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "WeiXinViewController.h"
#import "WeiXinModelFrame.h"
#import "WeiXinModel.h"
#import "WeiXinTableViewCell.h"
#import "CCWebViewController.h"

static NSInteger kOnePagNum = 20;//一页显示的条数

@interface WeiXinViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation WeiXinViewController
{
    UITableView *_WXTableView;
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

    _WXTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _WXTableView.delegate = self;
    _WXTableView.dataSource = self;
    _WXTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_WXTableView];
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)refreshlist{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewData)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    footer.hidden = YES;
    _WXTableView.mj_header = header;
    _WXTableView.mj_footer = footer;
}

#pragma mark  下拉
- (void)getNewData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KEY_WEIXIN_ARTICLE forKey:@"key"];
    [params setObject:@(kOnePagNum) forKey:@"ps"];
    [params setObject:@1 forKey:@"pno"];
    [self sendNetRequestWithUrl:API_WEIXIN_ARTICLE parameters:params type:1];
}
#pragma mark  上拉
- (void)getMoreData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:KEY_WEIXIN_ARTICLE forKey:@"key"];
    [params setObject:@(kOnePagNum) forKey:@"ps"];
    [params setObject:@(self.dataArray.count/kOnePagNum+1) forKey:@"pno"];
    [self sendNetRequestWithUrl:API_WEIXIN_ARTICLE parameters:params type:2];
}

#pragma mark  请求网络
- (void)sendNetRequestWithUrl:(NSString *)strUrl parameters:(id)params type:(NSInteger)type{
    MBPROGRESSHUD_SHOWLOADINGWITH(self.view);
    [AFN_Request POST:strUrl params:params success:^(id successData) {
        MBPROGRESSHUD_HIDELOADINGWITH(self.view);
        if ([[successData objectForKey:@"error_code"]intValue] == 0) {
            NSDictionary *result = [successData objectForKey:@"result"];
            NSArray *listArr = nil;
            listArr = [WeiXinModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"list"]];
            listArr = [self becomeFrameWithArray:listArr];
            NSInteger totalPage = [[result objectForKey:@"totalPage"] integerValue];//总页数
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
                [_WXTableView.mj_header endRefreshing];
            }else{
                NSLog(@"更多列表->%@",result);
                [self.dataArray addObjectsFromArray:listArr];
                [_WXTableView.mj_footer endRefreshing];
            }
            [_WXTableView reloadData];
            if ([[result objectForKey:@"pno"]integerValue] == totalPage) {
                [_WXTableView.mj_footer endRefreshingWithNoMoreData];
            }
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
    for (WeiXinModel *model in array) {
        WeiXinModelFrame *frame = [[WeiXinModelFrame alloc]init];
        frame.weiXinModel = model;
        [arrayFrame addObject:frame];
    }
    return [arrayFrame copy];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiXinTableViewCell *cell = [WeiXinTableViewCell returnCellWithTableView:tableView];
    
    WeiXinModelFrame *frame = self.dataArray[indexPath.row];
    cell.weiXinFrame = frame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    WeiXinModelFrame *frame = self.dataArray[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiXinModelFrame *frame = self.dataArray[indexPath.row];
    WeiXinModel *model = frame.weiXinModel;
    [CCWebViewController showWithContro:self withUrlStr:model.url withTitle:nil];
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
