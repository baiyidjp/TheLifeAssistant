//
//  JokeModelFrame.m
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/23.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "JokeModelFrame.h"
#import "JokeModel.h"

@implementation JokeModelFrame

- (void)setModel:(JokeModel *)model{

    _model = model;
    
    CGSize size_1 =  CGSizeMake(KWIDTH-2*KMARGIN, MAXFLOAT);
    CGSize titleSize = [model.content boundingRectWithSize:size_1 options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSMutableDictionary dictionaryWithObject:FONTSIZE(16) forKey:NSFontAttributeName] context:nil].size;
    self.contentF = CGRectMake(KMARGIN/2, KMARGIN/2, size_1.width, titleSize.height);
    
    self.backViewF = CGRectMake(KMARGIN/2, KMARGIN/2, KWIDTH-KMARGIN, titleSize.height+KMARGIN);
    
    self.cellH = CGRectGetMaxY(self.backViewF);
}

@end
