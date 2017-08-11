//
//  UIButton+TWButton.m
//  QQCP30
//
//  Created by 魔曦 on 2017/7/18.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "UIButton+TWButton.h"

@implementation UIButton (TWButton)

+ (UIButton *)createBttonWithFrame:(CGRect)frame titleText:(NSString *)titleText imageName:(NSString *)imageName textColor:(UIColor *)textColor font:(UIFont *)font {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:titleText forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    return button;
}

@end
