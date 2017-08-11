//
//  UIView+TWView.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/11.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "UIView+TWView.h"

@implementation UIView (TWView)

+ (UIView *)creactViewWith:(CGRect)frame bgColor:(UIColor *)bgColor{
    UIView * view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = bgColor;
    return view;
}

@end
