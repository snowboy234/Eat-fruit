//
//  BabyImageView.m
//  815
//
//  Created by 田伟 on 2017/8/15.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "BabyImageView.h"

@implementation BabyImageView

+ (instancetype)initBabyImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName{
    BabyImageView * babyImageView = [[BabyImageView alloc]initWithFrame:frame];
    babyImageView.image = [UIImage imageNamed:imageName];
    babyImageView.userInteractionEnabled = YES;
    return babyImageView;
}

// 检查是否抓住
- (BOOL)checkIfCaught:(CGRect)frame{

//    CGRect candyFrame = frame;

    int candy1 = frame.origin.x;
    int candy2 = frame.origin.x + frame.size.width;
    
    int netX1 = self.frame.origin.x;
    int netX2 = self.frame.origin.x + self.frame.size.width;
    
    if( 5 + candy1 >= netX1 && candy2 <= netX2 + 5){
//        NSLog(@"You did it!");
        return YES;
    }
//    NSLog(@"Fail");
    return NO;
}

@end
