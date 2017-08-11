//
//  UIButton+TWButton.h
//  QQCP30
//
//  Created by 魔曦 on 2017/7/18.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TWButton)

+ (UIButton *)createBttonWithFrame:(CGRect)frame titleText:(NSString *)titleText imageName:(NSString *)imageName textColor:(UIColor *)textColor font:(UIFont *)font;

@end
