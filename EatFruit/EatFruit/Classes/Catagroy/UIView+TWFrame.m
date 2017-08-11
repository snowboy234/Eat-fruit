//
//  UIView+TWFrame.m
//  BuDeJie
//
//  Created by 田伟 on 2017/1/18.
//  Copyright © 2017年 公司. All rights reserved.
//

#import "UIView+TWFrame.h"

@implementation UIView (TWFrame)

- (void)setTw_width:(CGFloat)tw_width{
    CGRect rect = self.frame;
    rect.size.width = tw_width;
    self.frame = rect;
}

- (CGFloat)tw_width{
    return self.frame.size.width;
}

- (void)setTw_height:(CGFloat)tw_height{
    CGRect rect = self.frame;
    rect.size.height = tw_height;
    self.frame = rect;
}

- (CGFloat)tw_height{
    return self.frame.size.height;
}

- (void)setTw_x:(CGFloat)tw_x{
    CGRect rect = self.frame;
    rect.origin.x = tw_x;
    self.frame = rect;
}

- (CGFloat)tw_x{
    return self.frame.origin.x;
}

- (void)setTw_y:(CGFloat)tw_y{
    CGRect rect = self.frame;
    rect.origin.y = tw_y;
    self.frame = rect;
}

- (CGFloat)tw_y{
    return self.frame.origin.y;
}


- (void)setTw_centerX:(CGFloat)tw_centerX{
    CGPoint center = self.center;
    center.x = tw_centerX;
    self.center = center;
}
- (CGFloat)tw_centerX{
    return self.center.x;
}

- (void)setTw_centerY:(CGFloat)tw_centerY{
    CGPoint center = self.center;
    center.y = tw_centerY;
    self.center = center;
}
- (CGFloat)tw_centerY{
    return self.center.y;
}
@end
