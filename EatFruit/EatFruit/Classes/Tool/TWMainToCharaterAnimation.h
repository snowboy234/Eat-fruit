//
//  TWMainToCharaterAnimation.h
//  EatFruit
//
//  Created by 田伟 on 2017/8/15.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWMainToCharaterAnimationDelegate <NSObject>
- (UIImageView *)getLeftScreenImage;
@end

@interface TWMainToCharaterAnimation : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

+ (TWMainToCharaterAnimation *)shareMainToCharaterAnimation;
@property (nonatomic, weak) id <TWMainToCharaterAnimationDelegate> delegate;

@end
