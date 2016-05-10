//
//  WeiXinModelFrame.m
//  TheLifeAssistant
//
//  Created by I Smile going on 16/5/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "WeiXinModelFrame.h"
#import "WeiXinModel.h"

static CGFloat kIconWidth_Height = 80.0;

@implementation WeiXinModelFrame

- (void)setWeiXinModel:(WeiXinModel *)weiXinModel{

    _weiXinModel = weiXinModel;
    
    self.iconFrame = CGRectMake(KMARGIN, 0, kIconWidth_Height, kIconWidth_Height);
    
    CGFloat titleX = CGRectGetMaxX(self.iconFrame)+KMARGIN;
    CGSize size =  CGSizeMake(KWIDTH-KMARGIN-titleX, 50);
    CGSize titleSize = TEXTSIZEWITHSIZEANDFONT(weiXinModel.title,size, FONTSIZE(13));
    self.titleFrame = CGRectMake(titleX, KMARGIN/2, titleSize.width, titleSize.height);
    
    CGSize sourceSize = TEXTSIZEWITHFONT(weiXinModel.source, FONTSIZE(13));
    self.sourceFrame = CGRectMake(titleX, CGRectGetMaxY(self.iconFrame)-sourceSize.height-KMARGIN/2, sourceSize.width, sourceSize.height);
    
    
    self.backgrounFrame = CGRectMake(0, KMARGIN, KWIDTH, kIconWidth_Height);
    self.cellHeight = CGRectGetMaxY(self.backgrounFrame);
}

@end
