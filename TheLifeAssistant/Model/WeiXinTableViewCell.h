//
//  WeiXinTableViewCell.h
//  TheLifeAssistant
//
//  Created by I Smile going on 16/5/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiXinModelFrame;
@interface WeiXinTableViewCell : UITableViewCell

@property(nonatomic,strong)WeiXinModelFrame *weiXinFrame;

+ (WeiXinTableViewCell *)returnCellWithTableView:(UITableView *)tableView;

@end
