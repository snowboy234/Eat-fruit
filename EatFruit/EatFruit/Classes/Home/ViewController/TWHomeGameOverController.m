//
//  TWHomeGameOverController.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/15.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWHomeGameOverController.h"
#import "TWMainViewController.h"
#import "TWMusicViewController.h"

@interface TWHomeGameOverController ()
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIImageView * titleView;
@property (nonatomic, strong) MyPlayer * soundPlayer;
@property (nonatomic, strong) NSString * showMusic;
@end

@implementation TWHomeGameOverController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTitleImageViewAnimation];

    _showMusic = [[NSUserDefaults standardUserDefaults] objectForKey:MusicShow];
    if ([_showMusic isEqualToString:ON]) {
        [_soundPlayer playMusicWithName:@"gameover.mp3"];
    } else {
        [_soundPlayer stopMusic];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([_showMusic isEqualToString:ON]) {
        [_soundPlayer playOrStopMusic];
    } else {
        [_soundPlayer stopMusic];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _soundPlayer = [MyPlayer shareInstance];
    [self initBackgroundImageView];
    [self setMiddleView];
    [self setTitleView];
    [self initBottomView];
    [self setToolView];
}

#pragma mark --UI设置
#pragma mark --大背景设置
- (void)initBackgroundImageView{
    self.view.backgroundColor = ViewControllerBgColor;
    NSInteger index = arc4random() % 30 + 20;
    for (NSInteger i = 0; i < index; i++) {
        NSInteger x = arc4random() % (int)TWScreenWidth;
        NSInteger y = arc4random() % (int)TWScreenHeight;
        CGFloat w = arc4random() % 25 + 10;
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, w)];
        imageView.image = [UIImage imageNamed:@"star"];
        [self.view addSubview:imageView];
    }
}

- (void)setMiddleView{
    // 计算宽高比例
    CGFloat WHProportion = 320 / 305.0;
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ImageViewW, ImageViewW / WHProportion)];
    _imageView.image = [UIImage imageNamed:@"failed-sheet0"];
    _imageView.center = self.view.center;
    [ self.view addSubview:_imageView];
    
    // 本轮得分
    TWStrokeLabel * scoreLabel = [[TWStrokeLabel alloc]initWithFrame:CGRectMake(0, 0, TWScreenWidth, 50)];
    scoreLabel.center = self.view.center;
    scoreLabel.text = [NSString stringWithFormat:@"%ld",self.score];
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.font = [UIFont systemFontOfSize:50];
    [self.view addSubview:scoreLabel];
}

- (void)setTitleView{
    // 位置参考图
    UIView * top = [[UIView alloc]initWithFrame:CGRectMake(0, 20, TWScreenWidth, CGRectGetMinY(_imageView.frame) - 20)];
    [self.view addSubview:top];
    
    CGFloat WHProportion = 314 / 112.0;
    CGFloat height = ImageViewW / WHProportion;
    _titleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ImageViewW, height)];
    _titleView.center = top.center;
    _titleView.image = [UIImage imageNamed:@"failed_txt-sheet0"];
    [top addSubview:_titleView];
}

#pragma mark --底部背景设置
- (void)initBottomView{
    CGFloat bottomViewH = (TWScreenHeight / 5) / 3 * 2;
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, TWScreenHeight - bottomViewH, TWScreenWidth, bottomViewH)];
    [self.view addSubview:bottomView];
    
    UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TWScreenWidth, bottomViewH)];
    bgImageView.image = [UIImage imageNamed:@"Grassland"];
    [bottomView addSubview:bgImageView];
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
    [_titleView.layer addAnimation:scaleX forKey:@"scaleX"];
    
    CAKeyframeAnimation * scaleY=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.values   = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5,@1.0];
    scaleY.repeatCount = MAXFLOAT;
    scaleY.autoreverses = YES;
    scaleY.duration = 3;
    [_titleView.layer addAnimation:scaleY forKey:@"scaleY"];
}

- (void)setToolView{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame) + TWMargin, TWScreenWidth, TWScreenHeight - CGRectGetMaxY(_imageView.frame) + TWMargin)];
    [self.view addSubview:bottomView];
    
    CGFloat WHProportion_playButton = 196 / 87.0;
    CGFloat width = (ImageViewW - 3 * TWMargin) * 0.5;
//    CGFloat x = (TWScreenWidth * 0.5) - TWMargin * 0.5 - width;
    CGFloat height = width / WHProportion_playButton;
    
    // 返回首页按钮
//    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(x, 20, width, height)];
    
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake((TWScreenWidth - width) * 0.5, 20, width, height)];
    backButton.timeInterval = ButtonClickTime;
    [backButton setBackgroundImage:[UIImage imageNamed:@"back-sheet0"] forState:UIControlStateNormal];
    
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {

        UIViewController *rootVC = self.presentingViewController;
        while (rootVC.presentingViewController) {
            rootVC = rootVC.presentingViewController;
        }
        [rootVC dismissViewControllerAnimated:NO completion:nil];
    }];
    [bottomView addSubview:backButton];
    
    // 其他更多按钮
//    UIButton * voiceButton = [[UIButton alloc]initWithFrame:CGRectMake(TWScreenWidth * 0.5 + TWMargin * 0.5, 20, width, height)];
//    voiceButton.timeInterval = ButtonClickTime;
//    [voiceButton setBackgroundImage:[UIImage imageNamed:@"more-sheet0"] forState:UIControlStateNormal];
//    [[voiceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        TWLogFunc
//    }];
//    [bottomView addSubview:voiceButton];
}


@end
