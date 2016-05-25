//
//  ListView.m
//  customBtn
//
//  Created by tztddong on 16/4/25.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ListView.h"

static CGFloat kTableView_top_padding = 5;//tableView距离topView的底部的距离
static CGFloat kTableView_left_padding = 8;//tableView距离topView的左边的距离
static CGFloat kTableView_width_add = 8;//tableView比topView的宽度多
static CGFloat kTableView_cell_height = 44;//cell的高度
static CGFloat kTableView_cell_textFont = 15;//cell字号

@interface ListView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)selectCell selectBlock;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,assign)CGRect topViewFrame;

@end

@implementation ListView

+ (instancetype)creatListViewWithTopView:(UIView *)topView dataArray:(NSArray *)dataArray selectBlock:(selectCell)selectBlock{

    return [[self alloc]initWithTopView:topView dataArray:dataArray selectBlock:selectBlock];
}


- (instancetype)initWithTopView:(UIView *)topView dataArray:(NSArray *)dataArray selectBlock:(selectCell)selectBlock{

    self = [super init];
    if (self) {
        self.topViewFrame = [topView convertRect:topView.bounds toView:nil];;
        self.dataArray = dataArray;
        self.selectBlock = selectBlock;
        self.backgroundColor = [UIColor clearColor];
        [self configView];
    }
    return self;
}

- (void)configView{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.topViewFrame.origin.x, CGRectGetMaxY(self.topViewFrame), self.topViewFrame.size.width, kTableView_cell_height*self.dataArray.count+kTableView_top_padding*2)];
    // 加载图片
    UIImage *image = [UIImage imageNamed:@"kuang"];
    // 设置端盖的值
    CGFloat top = image.size.height * 0.5;
    CGFloat left = image.size.width * 0.5;
    CGFloat bottom = image.size.height * 0.5;
    CGFloat right = image.size.width * 0.5;
    // 设置端盖的值
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    // 设置拉伸的模式
    UIImageResizingMode mode = UIImageResizingModeStretch;
    // 拉伸图片
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    imageView.image = newImage;
    [self addSubview:imageView];
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(self.topViewFrame.origin.x, CGRectGetMaxY(self.topViewFrame)+kTableView_top_padding*2, self.topViewFrame.size.width, kTableView_cell_height*self.dataArray.count) style:UITableViewStylePlain];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellID = @"listcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
    
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:kTableView_cell_textFont];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
     
    if (indexPath.row < self.dataArray.count-1) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, kTableView_cell_height-1, self.topViewFrame.size.width+kTableView_width_add, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:lineView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectBlock) {
        self.selectBlock(self.dataArray[indexPath.row]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kTableView_cell_height;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (self.selectBlock) {
        self.selectBlock(nil);
    }
}
@end
