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

@interface TWMainViewController ()<TWMainToHomeAnimationDelegate, TWMainToAirAnimationDelegate>
@property (nonatomic, strong) TWHomeViewController * homeVc;
@property (nonatomic, strong) TWAirViewController * airVc;
@property (nonatomic, strong) TWMainToHomeAnimation * animationToolBottom;
@property (nonatomic, strong) TWMainToAirAnimation * animationToolRight;
@property (nonatomic, strong) UIView * topView;
@end

@implementation TWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _homeVc = [[TWHomeViewController alloc]init];
    _airVc = [[TWAirViewController alloc]init];
    _animationToolBottom = [TWMainToHomeAnimation shareMainToHomeAnimation];
    _animationToolRight = [TWMainToAirAnimation shareMainToAirAnimation];
    self.view.backgroundColor = ViewControllerBgColor;
    [self initBottomView];
    [self initTopView];
}


#define ImageViewW (TWScreenWidth - TWMargin * 5)
#define ButtonClickTime 0.3

#pragma mark --UI搭建
#pragma mark --TopView
- (void)initTopView{
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TWScreenWidth, TWScreenHeight * 0.5)];
    [self.view addSubview:_topView];
    
    // 计算宽高比例
    CGFloat WHProportion = 326 / 166.0;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ImageViewW, ImageViewW / WHProportion)];
    imageView.image = [UIImage imageNamed:@"logo-sheet0"];
    imageView.center = _topView.center;
    [_topView addSubview:imageView];
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
    UIButton * landButton = [[UIButton alloc]initWithFrame:CGRectMake(x, height + TWMargin, width, 0)];
    landButton.timeInterval = ButtonClickTime;
    [landButton setBackgroundImage:[UIImage imageNamed:@"land-sheet0"] forState:UIControlStateNormal];
    [[landButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        _homeVc.transitioningDelegate = _animationToolBottom;
        _animationToolBottom.delegate = self;
        [self presentViewController:_homeVc animated:YES completion:nil];
    }];
    [bottomView addSubview:landButton];
    
    // 子菜单上的air按钮
    UIButton * airButton = [[UIButton alloc]initWithFrame:CGRectMake(TWScreenWidth * 0.5 + TWMargin * 0.5, height + TWMargin, width, 0)];
    airButton.timeInterval = ButtonClickTime;
    [airButton setBackgroundImage:[UIImage imageNamed:@"sky-sheet0"] forState:UIControlStateNormal];
    [[airButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        _airVc.transitioningDelegate = _animationToolRight;
        _animationToolRight.delegate = self;
        [self presentViewController:_airVc animated:YES completion:nil];
    }];
    [bottomView addSubview:airButton];
    
#pragma mark --选择角色按钮
    CGFloat WHProportion_characterButton = 320 / 87.0;
    UIButton * characterButton = [[UIButton alloc]initWithFrame:CGRectMake((TWScreenWidth * 0.5) - width, height + TWMargin, width * 2, (width * 2) / WHProportion_characterButton)];
    characterButton.timeInterval = ButtonClickTime;
    [characterButton setBackgroundImage:[UIImage imageNamed:@"character-sheet0"] forState:UIControlStateNormal];
    [[characterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        TWLogFunc
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
            [UIView animateWithDuration:ButtonClickTime animations:^{
                landButton.tw_height = 0;
                airButton.tw_height = 0;
                characterButton.tw_y = height + TWMargin;
            }];
        } else {
            x.selected = YES;
            // show
            [UIView animateWithDuration:ButtonClickTime animations:^{
                landButton.tw_height = height;
                airButton.tw_height = height;
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

#pragma mark --私有方法
-(UIImage *)getImage{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
