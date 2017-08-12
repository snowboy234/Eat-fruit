//
//  TWReadyStarView.h
//  EatFruit
//
//  Created by 田伟 on 2017/8/12.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TWReadyStarView;

@protocol TWReadyStarViewDelegate <NSObject>
// 自定义倒计时
- (void)customCountDown:(TWReadyStarView *)downView;
@end

@interface TWReadyStarView : UIView

+ (instancetype)createView;
@property (nonatomic, assign) NSInteger downNumber;// 倒计时时间
- (void)addTimerForAnimationDownView;
@property (nonatomic, assign) id<TWReadyStarViewDelegate> delegate;

@end
