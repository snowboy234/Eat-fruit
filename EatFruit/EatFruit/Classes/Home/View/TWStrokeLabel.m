//
//  TWStrokeLabel.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/12.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWStrokeLabel.h"

@implementation TWStrokeLabel

- (void)drawTextInRect:(CGRect)rect{
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    // 设置描边的宽度
    CGContextSetLineWidth(c, 10);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    // 设置描边的颜色
    self.textColor = [UIColor colorWithRed:0.992f green:0.627f blue:0.494f alpha:1.00f];
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

@end
