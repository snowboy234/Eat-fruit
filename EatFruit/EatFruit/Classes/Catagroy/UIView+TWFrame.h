//
//  UIView+TWFrame.h
//  BuDeJie
//
//  Created by 田伟 on 2017/1/18.
//  Copyright © 2017年 公司. All rights reserved.
//  快速拿到控件的宽高和x，y

#import <UIKit/UIKit.h>

@interface UIView (TWFrame)

// 加前缀避免冲突
@property CGFloat tw_width;
@property CGFloat tw_height;
@property CGFloat tw_x;
@property CGFloat tw_y;

@property CGFloat tw_centerX;
@property CGFloat tw_centerY;

@end
