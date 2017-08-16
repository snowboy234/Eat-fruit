//
//  TWAirBaby.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/16.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWAirBaby.h"

@implementation TWAirBaby

- (void)setName:(NSString *)name{
    _name = name;
    self.image = [UIImage imageNamed:name];
}

+ (instancetype)initBabyImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName{
    TWAirBaby * babyImageView = [[TWAirBaby alloc]initWithFrame:frame];
    babyImageView.image = [UIImage imageNamed:imageName];
    babyImageView.userInteractionEnabled = YES;
    return babyImageView;
}

// 检查是否抓住
- (BOOL)checkIfCaught:(CGRect)frame{
    
//    CGRect candyFrame = frame;
    
    int candy1 = frame.origin.y;
    int candy2 = frame.origin.y + frame.size.height;
    
    int netX1 = self.frame.origin.y;
    int netX2 = self.frame.origin.y + self.frame.size.height;
    
    if( 5 + candy1 >= netX1 && candy2 <= netX2 + 5){
        NSLog(@"You did it!");
        return YES;
    }
    NSLog(@"Fail");
    return NO;
}


@end
