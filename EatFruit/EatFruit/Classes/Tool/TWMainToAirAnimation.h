//
//  TWMainToAirAnimation.h
//  EatFruit
//
//  Created by 田伟 on 2017/8/11.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWMainToAirAnimationDelegate <NSObject>
- (UIImageView *)getRightScreenImage;
@end

@interface TWMainToAirAnimation : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
+ (TWMainToAirAnimation *)shareMainToAirAnimation;
@property (nonatomic, weak) id <TWMainToAirAnimationDelegate> delegate;

@end
