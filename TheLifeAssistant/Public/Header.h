//
//  Header.h
//  TheLifeAssistant
//
//  Created by tztddong on 16/5/10.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//


#ifndef Header_h
#define Header_h

#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Extension.h"
#import "UIView+XL.h"
#import "AFN_Request.h"
#import "Masonry.h"
#import "MBProgressHUD+Extension.h"

#define FONTSIZE(x)  [UIFont systemFontOfSize:x]//设置字体大小
#define KWIDTH  [UIScreen mainScreen].bounds.size.width//屏幕的宽
#define KHEIGHT [UIScreen mainScreen].bounds.size.height//屏幕的高
#define KMARGIN 10//默认间距
#define NAVHEIGHT 64 //导航栏的高度
#define CELLHEIGHT 44
#define TEXTSIZEWITHFONT(text,font) [text sizeWithAttributes:[NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName]]//根据文本及其字号返回size
#define REQUESSUCCESS [[successData objectForKey:@"resultcode"] isEqualToString:@"200"]

#endif /* Header_h */
