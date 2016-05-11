//
//  JPTableViewDelegate.m
//  JPTableViewDelegate
//
//  Created by tztddong on 16/3/17.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "MainTableViewDelegate.h"
#import "MainModel.h"

static NSString *cellId = @"tableViewCellID";

@interface MainTableViewDelegate ()

@property (nonatomic, strong) NSArray   *dataList;
@property (nonatomic, copy)  selectCell selectBlock;

@end

@implementation MainTableViewDelegate


+ (instancetype)createTableViewDelegateWithDataList:(NSArray *)dataList selectBlock:(selectCell)selectBlock{
    
    return [[[self class] alloc]initTableViewDelegateWithDataList:dataList selectBlock:selectBlock];
}

- (instancetype)initTableViewDelegateWithDataList:(NSArray *)dataList selectBlock:(selectCell)selectBlock{
    
    self = [super init];
    if (self) {
        self.dataList = dataList;
        self.selectBlock = selectBlock;
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    MainModel *model = self.dataList[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.font = FONTSIZE(15);
    cell.imageView.image = [UIImage imageNamed:model.imagename];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainModel *model = self.dataList[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock(indexPath,model.name);
    }
}

@end
