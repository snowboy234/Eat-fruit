//
//  TWMainToCharaterAnimation.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/15.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWMainToCharaterAnimation.h"

@interface TWMainToCharaterAnimation ()
@property (nonatomic,assign) BOOL isPresented;// 标记是否是弹出
@end

@implementation TWMainToCharaterAnimation


#pragma mark --init
+ (TWMainToCharaterAnimation *)shareMainToCharaterAnimation{
    static TWMainToCharaterAnimation * animation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!animation) {
            animation = [[TWMainToCharaterAnimation alloc]init];
        }
    });
    return animation;
}

#pragma mark --UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    _isPresented = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    _isPresented = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}


#pragma mark --UIViewControllerAnimatedTransitioning
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    if (_isPresented) {
        [self animationForPresentedView:transitionContext];
    } else {
        [self animationForDismissView:transitionContext];
    }
}

- (void)animationForPresentedView:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView * presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:presentedView];
    presentedView.frame = CGRectMake(-TWScreenWidth, 0, TWScreenWidth, TWScreenHeight);
    UIImageView * imageView = [_delegate getLeftScreenImage];
    imageView.frame = CGRectMake(0, 0, TWScreenWidth, TWScreenHeight);
    [transitionContext.containerView addSubview:imageView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        imageView.frame = CGRectMake(TWScreenWidth, 0, TWScreenWidth, TWScreenHeight);
        presentedView.frame = CGRectMake(0, 0, TWScreenWidth, TWScreenHeight);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (void)animationForDismissView:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView * dismissView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    dismissView.frame = CGRectMake(0, 0, TWScreenWidth, TWScreenHeight);
    UIImageView * imageView = [_delegate getLeftScreenImage];
    imageView.frame = CGRectMake(TWScreenWidth, 0, TWScreenWidth, TWScreenHeight);
    [transitionContext.containerView addSubview:imageView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        imageView.frame = CGRectMake(0, 0, TWScreenWidth, TWScreenHeight);
        dismissView.frame = CGRectMake(-TWScreenWidth, 0, TWScreenWidth, TWScreenHeight);
    } completion:^(BOOL finished) {
        [transitionContext.containerView addSubview:dismissView];
        [imageView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}


@end
