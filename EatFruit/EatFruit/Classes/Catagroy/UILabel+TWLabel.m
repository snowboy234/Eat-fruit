//
//  UILabel+TWLabel.m
//  QQCP30
//
//  Created by 魔曦 on 2017/7/18.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "UILabel+TWLabel.h"

@implementation UILabel (TWLabel)

+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text numberOfLines:(NSInteger)numberOfLines textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment{
    UILabel * label = [[UILabel alloc]init];
    label.frame = frame;
    label.text = text;
    label.numberOfLines = numberOfLines;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = textAlignment;
    return label;
}

// 根据字体大小计算文本的高度
+ (CGFloat)calculateHeight:(NSString *)string withMaxSize:(CGSize)size withFont:(UIFont *)font{
    // 正文内容的size限制
//    CGSize textMaxSize = CGSizeMake(TWScreenWidth - 2 * TWMargin, MAXFLOAT);
    // 正文内容的高度
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
}

@end
