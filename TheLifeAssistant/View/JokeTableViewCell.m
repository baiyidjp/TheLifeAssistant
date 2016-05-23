//
//  JokeTableViewCell.m
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/23.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JokeTableViewCell.h"
#import "JokeModel.h"
#import "JokeModelFrame.h"

static NSString *kCellID = @"JokeTableViewCell";

@implementation JokeTableViewCell
{
    UILabel *_contentLabel;
    UIView *_backView;
}
+ (JokeTableViewCell *)returnCellWithTableView:(UITableView *)tableView{
    
    JokeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[JokeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        [self configView];
    }
    return self;
}

- (void)configView{
    
    _backView = [[UIView alloc]init];
    _backView.layer.cornerRadius = 5;
    _backView.layer.borderColor = [UIColor colorWithHexString:@"6ecd29"].CGColor;
    _backView.layer.borderWidth = 1;
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = FONTSIZE(15);
    [_contentLabel setNumberOfLines:0];
    [_backView addSubview:_contentLabel];
    
}

- (void)setJokeModelFrame:(JokeModelFrame *)jokeModelFrame{
    
    _jokeModelFrame = jokeModelFrame;
    
    _contentLabel.frame = jokeModelFrame.contentF;
    _contentLabel.text = jokeModelFrame.model.content;
    
    _backView.frame = jokeModelFrame.backViewF;
}

@end
