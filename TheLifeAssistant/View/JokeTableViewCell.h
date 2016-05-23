//
//  JokeTableViewCell.h
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/23.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JokeModelFrame;
@interface JokeTableViewCell : UITableViewCell

@property(nonatomic,strong)JokeModelFrame *jokeModelFrame;

+ (JokeTableViewCell *)returnCellWithTableView:(UITableView *)tableView;

@end
