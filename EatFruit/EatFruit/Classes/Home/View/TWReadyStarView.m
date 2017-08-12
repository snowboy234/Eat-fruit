//
//  TWReadyStarView.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/12.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWReadyStarView.h"
#import "TWStrokeLabel.h"

@interface TWReadyStarView ()
@property (nonatomic,strong) TWStrokeLabel * countdownLabel;  // 显示ready或者star的label
@end

@implementation TWReadyStarView

+ (instancetype)createView{
    TWReadyStarView * readyStarView = [[TWReadyStarView alloc]init];
    return readyStarView;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 当前vie是否不透明
    self.opaque = NO;

    _countdownLabel = [[TWStrokeLabel alloc]init];
    [self.countdownLabel setFont:[UIFont boldSystemFontOfSize:TWScreenWidth * 0.2]];
    [self.countdownLabel setTextColor:[UIColor colorWithRed:0.996f green:0.914f blue:0.859f alpha:1.00f]];
    self.countdownLabel.textAlignment = NSTextAlignmentCenter;
    // opaque属性设置为yes，而对应的alpha不设置为1的话会用不可预料的情况发生
    self.countdownLabel.opaque = YES;
    self.countdownLabel.alpha = 1.0;
    [self addSubview: self.countdownLabel];
    self.countdownLabel.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _countdownLabel.frame = CGRectMake(self.tw_x, self.tw_y, self.tw_width , self.tw_width);
    [_countdownLabel setCenter:self.center];
}

- (void)addTimerForAnimationDownView{
    [self numAction];
    [self setCircleBackView];
}

// 倒计时
- (void)numAction{
    __block NSInteger second = 1;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    /* 创建定时器
     第1个参数：资源的类型
     第2个参数：函数句柄，一般不需要，直接传0
     第3个参数：直接传0
     第4个参数：任务的执行队列，如果是并发队列，这个方法内部会开新线程
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    /*
     设置定时器什么时候开始，每隔多久执行一次
     第2个参数：什么时候开始，dispatch_time_t类型
     第3个参数：每隔多久执行一次，单位是纳秒(1s = 10的9次方ns)
     第4个参数：leewayInSeconds字面意思是回旋的秒数，一般传0就可以了，单位是纳秒
     NSEC_PER_SEC表示1秒所含的纳秒数，在下面关键词解释有说明
    */
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    // 定时器要执行的任务
    dispatch_source_set_event_handler(timer, ^{
        // 回到主线程更改UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >= 0) {
                if (second == 0) {
                    _countdownLabel.text = @"Start";
                } else {
                    _countdownLabel.text = @"Ready";
                }
                [self animationTest];
                second--;
            } else {
                // 关闭定时器，移除本视图
                dispatch_source_cancel(timer);
                if ([_delegate respondsToSelector:@selector(customCountDown:)]) {
                    [_delegate customCountDown:self];
                    [self removeFromSuperview];
                }
            }
        });
    });
    // 启动定时器
    dispatch_resume(timer);
}

- (void)animationTest{
    CABasicAnimation * animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.duration = 0.30;
    animation2.toValue = @(0.2);
    animation2.removedOnCompletion = YES;
    animation2.fillMode = kCAFillModeForwards;
    [_countdownLabel.layer addAnimation:animation2 forKey:@"opacity"];
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4, 1.4, 1.0)]];
    animation.values = values;
    [_countdownLabel.layer addAnimation:animation forKey:@"transform"];
}

- (void)setCircleBackView{
    CGFloat delay = 1.0;
    CGFloat scale = 3;
    NSInteger count = 2;
    for (NSInteger i = 0; i < count; i++) {
        UIView * animationView = [self circleView];
        animationView.backgroundColor = [UIColor clearColor];
        [self insertSubview:animationView atIndex:0];
        [UIView animateWithDuration:1.0 delay:i * delay options:UIViewAnimationOptionCurveLinear animations:^{
            animationView.transform = CGAffineTransformMakeScale(scale, scale);
            animationView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            animationView.alpha = 0;
        } completion:^(BOOL finished) {
            [animationView removeFromSuperview];
        }];
    }
}

- (UIView *)circleView{
    CGFloat width = TWScreenWidth * 0.25;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    view.center = self.center;
//    view.backgroundColor = [UIColor colorWithRed:52 / 255.0 green:143 / 255.0 blue:242 / 255.0 alpha:1.0];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = width * 0.5;
    view.layer.masksToBounds = YES;
    return view;
}

@end
