//
//  BabyImageView.m
//  815
//
//  Created by 田伟 on 2017/8/15.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "BabyImageView.h"

@implementation BabyImageView

- (void)setName:(NSString *)name{
    _name = name;
    self.image = [UIImage imageNamed:name];
}

+ (instancetype)initBabyImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName{
    BabyImageView * babyImageView = [[BabyImageView alloc]initWithFrame:frame];
    babyImageView.image = [UIImage imageNamed:imageName];
    babyImageView.userInteractionEnabled = YES;
    return babyImageView;
}

// 检查是否抓住
- (BOOL)checkIfCaught:(CGRect)frame{
    // 碰撞检测（交集）
    CGRect candyFrame = frame;

    // 判断两个结构体是否有交错
    bool oneRect = CGRectIntersectsRect(candyFrame, self.frame);
    
//    if (oneRect) {
//        NSLog(@"You did it!");
//        return YES;
//    }
//    NSLog(@"Fail");
//    return NO;
    return oneRect;
    
    // 顶部接受
//    int candy1x = frame.origin.x;
//    int candy2x = frame.origin.x + frame.size.width;
//    
//    int netX1x = self.frame.origin.x;
//    int netX2x = self.frame.origin.x + self.frame.size.width;
//    
//    if( 5 + candy1x >= netX1x && candy2x <= netX2x + 5){
//        return YES;
//    }
//    return NO;
}

@end
