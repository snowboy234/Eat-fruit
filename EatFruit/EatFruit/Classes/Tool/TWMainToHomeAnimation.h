//
//  TWMainToHomeAnimation.h
//  EatFruit
//
//  Created by 田伟 on 2017/8/11.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TWMainToHomeAnimationDelegate <NSObject>
- (UIImageView *)getTopScreenImage;
@end

@interface TWMainToHomeAnimation : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
+ (TWMainToHomeAnimation *)shareMainToHomeAnimation;
@property (nonatomic, weak) id <TWMainToHomeAnimationDelegate> delegate;
@end
