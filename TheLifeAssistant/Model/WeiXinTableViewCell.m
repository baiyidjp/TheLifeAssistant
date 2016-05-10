//
//  WeiXinTableViewCell.m
//  TheLifeAssistant
//
//  Created by I Smile going on 16/5/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "WeiXinTableViewCell.h"
#import "WeiXinModel.h"
#import "WeiXinModelFrame.h"

static NSString *kCellID = @"WeiXinTableViewCell";

@interface WeiXinTableViewCell ()

@end

@implementation WeiXinTableViewCell
{
    UIImageView *_iconView;
    UILabel *_titleLabel;
    UILabel *_sourceLabel;
    UIView *_backgroundView;
}
+ (WeiXinTableViewCell *)returnCellWithTableView:(UITableView *)tableView{

    WeiXinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[WeiXinTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
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
    
    _iconView = [[UIImageView alloc]init];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = FONTSIZE(13);
    
    _sourceLabel = [[UILabel alloc]init];
    _sourceLabel.textColor = [UIColor colorWithHexString:@"888888"];
    _sourceLabel.font = FONTSIZE(13);
    
    _backgroundView = [[UIView alloc]init];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    
    [_backgroundView addSubview:_iconView];
    [_backgroundView addSubview:_titleLabel];
    [_backgroundView addSubview:_sourceLabel];
    [self.contentView addSubview:_backgroundView];
    
}

- (void)setWeiXinFrame:(WeiXinModelFrame *)weiXinFrame{

    _weiXinFrame = weiXinFrame;
    
    _iconView.frame = weiXinFrame.iconFrame;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:weiXinFrame.weiXinModel.firstImg] placeholderImage:nil];
    
    _titleLabel.frame = weiXinFrame.titleFrame;
    _titleLabel.text = weiXinFrame.weiXinModel.title;
    
    _sourceLabel.frame = weiXinFrame.sourceFrame;
    _sourceLabel.text = weiXinFrame.weiXinModel.source;
    
    _backgroundView.frame = weiXinFrame.backgrounFrame;
}

@end
