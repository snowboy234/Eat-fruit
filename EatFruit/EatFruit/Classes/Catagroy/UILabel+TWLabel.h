//
//  UILabel+TWLabel.h
//  QQCP30
//
//  Created by 魔曦 on 2017/7/18.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TWLabel)

+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text numberOfLines:(NSInteger)numberOfLines textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;

// 根据字体大小计算文本的高度
+ (CGFloat)calculateHeight:(NSString *)string withMaxSize:(CGSize)size withFont:(UIFont *)font;

@end
