//
//  TWMainViewController.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/11.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWMainViewController.h"
#import "TWHomeViewController.h"
#import "TWMainToHomeAnimation.h"
#import "TWMainToAirAnimation.h"
#import "TWAirViewController.h"
#import "TWAllCharacterController.h"
#import "TWMainToCharaterAnimation.h"

@interface TWMainViewController ()<TWMainToHomeAnimationDelegate, TWMainToAirAnimationDelegate, TWMainToCharaterAnimationDelegate>
@property (nonatomic, strong) TWMainToHomeAnimation * animationToolBottom;
@property (nonatomic, strong) TWMainToAirAnimation * animationToolRight;
@property (nonatomic, strong) TWMainToCharaterAnimation * animationToolLeft;
@property (nonatomic, strong) TWAllCharacterController * characterVc;
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIImageView * imageView;// 标题视图
@property (nonatomic, strong) UIButton * landButton;  // 模式一按钮
@property (nonatomic, strong) UIButton * airButton;   // 模式二按钮

@end

@implementation TWMainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showAnimation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    TWLog(@"%@",NSHomeDirectory());
    [self initObject];
    [self initBackgroundImageView];
    [self initBottomView];
    [self setLevelButtonAnimation];
    [self initTopView];
    [self setTitleImageViewAnimation];
}

- (void)initObject{
    _characterVc = [[TWAllCharacterController alloc]init];
    _animationToolBottom = [TWMainToHomeAnimation shareMainToHomeAnimation];
    _animationToolRight = [TWMainToAirAnimation shareMainToAirAnimation];
    _animationToolLeft = [TWMainToCharaterAnimation shareMainToCharaterAnimation];
}

#pragma mark --UI搭建
#pragma mark --大背景设置
- (void)initBackgroundImageView{
    self.view.backgroundColor = ViewControllerBgColor;
    NSInteger index = arc4random() % 40 + 20;
        for (NSInteger i = 0; i < index; i++) {
        NSInteger x = arc4random() % (int)TWScreenWidth;
        NSInteger y = arc4random() % (int)TWScreenHeight;
        CGFloat w = arc4random() % 25 + 10;
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, w)];
        imageView.image = [UIImage imageNamed:@"star"];
        [self.view addSubview:imageView];
    }
}

#pragma mark --TopView
- (void)initTopView{
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TWScreenWidth, TWScreenHeight * 0.5)];
    [self.view addSubview:_topView];
    
    // 计算宽高比例
    CGFloat WHProportion = 326 / 166.0;
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ImageViewW, ImageViewW / WHProportion)];
    _imageView.image = [UIImage imageNamed:@"logo-sheet0"];
    _imageView.center = _topView.center;
    [_topView addSubview:_imageView];
}

#pragma mark --BottomView
- (void)initBottomView{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, TWScreenHeight * 0.5, TWScreenWidth, TWScreenHeight * 0.5)];
    [self.view addSubview:bottomView];
    
    // 属性计算
    CGFloat WHProportion_playButton = 196 / 87.0;
    CGFloat width = (ImageViewW - 3 * TWMargin) * 0.5;
    CGFloat x = (TWScreenWidth * 0.5) - TWMargin * 0.5 - width;
    CGFloat height = width / WHProportion_playButton;

#pragma mark --开始按钮的子菜单
    // 子菜单上的land按钮
    _landButton = [[UIButton alloc]initWithFrame:CGRectMake(x, height + TWMargin, width, 0)];
    _landButton.timeInterval = ButtonClickTime;
    [_landButton setBackgroundImage:[UIImage imageNamed:@"land-sheet0"] forState:UIControlStateNormal];
    [[_landButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        TWHomeViewController * homeVc = [[TWHomeViewController alloc]init];
        homeVc.transitioningDelegate = _animationToolBottom;
        _animationToolBottom.delegate = self;
        WeakSelf
        homeVc.block = ^{
            [weakSelf setTitleImageViewAnimation];
            [weakSelf setLevelButtonAnimation];
        };
        // 进入页面后开启定时器
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [homeVc countDownTime];
        });
        [self presentViewController:homeVc animated:YES completion:nil];
    }];
    [bottomView addSubview:_landButton];
    
    // 子菜单上的air按钮
    _airButton = [[UIButton alloc]initWithFrame:CGRectMake(TWScreenWidth * 0.5 + TWMargin * 0.5, height + TWMargin, width, 0)];
    _airButton.timeInterval = ButtonClickTime;
    [_airButton setBackgroundImage:[UIImage imageNamed:@"sky-sheet0"] forState:UIControlStateNormal];
    [[_airButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        TWAirViewController * airVc = [[TWAirViewController alloc]init];
        airVc.transitioningDelegate = _animationToolRight;
        _animationToolRight.delegate = self;
        WeakSelf
        airVc.block = ^{
            [weakSelf setTitleImageViewAnimation];
            [weakSelf setLevelButtonAnimation];
        };
        // 进入页面后开启定时器
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [airVc countDownTime];
            [airVc showBirdView];
        });
        [self presentViewController:airVc animated:YES completion:nil];
    }];
    [bottomView addSubview:_airButton];
    
#pragma mark --选择角色按钮
    CGFloat WHProportion_characterButton = 320 / 87.0;
    UIButton * characterButton = [[UIButton alloc]initWithFrame:CGRectMake((TWScreenWidth * 0.5) - width, height + TWMargin, width * 2, (width * 2) / WHProportion_characterButton)];
    characterButton.timeInterval = ButtonClickTime;
    [characterButton setBackgroundImage:[UIImage imageNamed:@"character-sheet0"] forState:UIControlStateNormal];
    [[characterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        _characterVc.transitioningDelegate = _animationToolLeft;
        _animationToolLeft.delegate = self;
        [self presentViewController:_characterVc animated:YES completion:nil];
    }];
    [bottomView addSubview:characterButton];
    
#pragma mark --开始按钮
    // 开始按钮
    UIButton * playButton = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, width, height)];
    playButton.timeInterval = ButtonClickTime;
    [playButton setBackgroundImage:[UIImage imageNamed:@"play-sheet0"] forState:UIControlStateNormal];
    [[playButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (x.selected) {
            x.selected = NO;
            // hidden
            [UIView animateWithDuration:ButtonClickTime animations:^{
                _landButton.tw_height = 0;
                _airButton.tw_height = 0;
                characterButton.tw_y = height + TWMargin;
            }];
        } else {
            x.selected = YES;
            // show
            [UIView animateWithDuration:ButtonClickTime animations:^{
                _landButton.tw_height = height;
                _airButton.tw_height = height;
                characterButton.tw_y = height * 2 + TWMargin * 2;
            }];
        }
    }];
    [bottomView addSubview:playButton];
    
    
#pragma mark --声音按钮
    // 更多按钮（声音按钮）
    UIButton * voiceButton = [[UIButton alloc]initWithFrame:CGRectMake(TWScreenWidth * 0.5 + TWMargin * 0.5, 0, width, height)];
    voiceButton.timeInterval = ButtonClickTime;
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"more-sheet0"] forState:UIControlStateNormal];
    [[voiceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        TWLogFunc
    }];
    [bottomView addSubview:voiceButton];
}

#pragma mark --TWMainToHomeAnimationDelegate
- (UIImageView *)getTopScreenImage{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [self getImage];
    return imageView;
}

#pragma mark --TWMainToAirAnimationDelegate
- (UIImageView *)getRightScreenImage{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [self getImage];
    return imageView;
}

#pragma mark --TWMainToCharaterAnimationDelegate
- (UIImageView *)getLeftScreenImage{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [self getImage];
    return imageView;
}

#pragma mark --其他私有方法
-(UIImage *)getImage{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setTitleImageViewAnimation{
    CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.repeatCount = MAXFLOAT;
    pathAnimation.autoreverses=YES;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration=2.5;
    
    UIBezierPath *path=[UIBezierPath bezierPathWithOvalInRect:CGRectInset(_imageView.frame, _imageView.tw_width / 2 - 5, _imageView.tw_width / 2 - 5)];
    pathAnimation.path=path.CGPath;
    [_imageView.layer addAnimation:pathAnimation forKey:@"pathAnimation"];
    
    CAKeyframeAnimation * scaleX=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.values   = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5,@1.0];
    scaleX.repeatCount = MAXFLOAT;
    scaleX.autoreverses = YES;
    scaleX.duration = 2;
    [_imageView.layer addAnimation:scaleX forKey:@"scaleX"];
    
    CAKeyframeAnimation * scaleY=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.values   = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5,@1.0];
    scaleY.repeatCount = MAXFLOAT;
    scaleY.autoreverses = YES;
    scaleY.duration = 3;
    [_imageView.layer addAnimation:scaleY forKey:@"scaleY"];
}

- (void)setLevelButtonAnimation{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"buttonAnimation"];
    anim.keyPath = @"transform.scale";
    anim.toValue = @0.9;
    anim.repeatCount = MAXFLOAT;
    anim.duration = 0.5;
    anim.autoreverses = YES;
    
    //添加动画
    [_landButton.layer addAnimation:anim forKey:@"buttonAnimation"];
    [_airButton.layer addAnimation:anim forKey:@"buttonAnimation"];
}

- (void)showAnimation{
    [self setLevelButtonAnimation];
    [self setTitleImageViewAnimation];
}

@end
