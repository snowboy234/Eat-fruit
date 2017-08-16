//
//  TWMainToMusicAnimation.h
//  EatFruit
//
//  Created by 田伟 on 2017/8/16.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWMainToMusicAnimationDelegate <NSObject>
- (UIImageView *)getBottomScreenImage;
@end

@interface TWMainToMusicAnimation : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

+ (TWMainToMusicAnimation *)shareMainToMusicAnimation;
@property (nonatomic, weak) id <TWMainToMusicAnimationDelegate> delegate;

@end
