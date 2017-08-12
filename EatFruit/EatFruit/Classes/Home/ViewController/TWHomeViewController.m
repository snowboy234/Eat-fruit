//
//  TWHomeViewController.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/11.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWHomeViewController.h"

@interface TWHomeViewController ()
@property (nonatomic, strong) UIView * boundaryView;    // 约束人物行动的底座
@property (nonatomic, strong) UIImageView * baby;       // 人物
@property (nonatomic, copy) NSString * babyName;        // 人物名称
@end

@implementation TWHomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 先获取选定的人物
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackgroundImageView];
    [self initBottomView];
    [self initBabyImageView];
    [self initBabyImageView];
}

#pragma mark --UI界面
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

#pragma mark --底部背景设置
- (void)initBottomView{
    CGFloat bottomViewH = (TWScreenHeight / 5) / 3 * 2;
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, TWScreenHeight - bottomViewH, TWScreenWidth, bottomViewH)];
    [self.view addSubview:bottomView];

    UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TWScreenWidth, bottomViewH)];
    bgImageView.image = [UIImage imageNamed:@"Grassland"];
    [bottomView addSubview:bgImageView];
    
    // 底座
    CGFloat boundaryH = bottomViewH * 2 / 3;
    _boundaryView = [UIView creactViewWith:CGRectMake(0, boundaryH, TWScreenWidth, boundaryH) bgColor:TWColorRGB(229, 138, 59)];
    [bottomView addSubview:_boundaryView];
}

- (void)initBabyImageView{
    // baby的大小为屏幕宽度的1/5
    CGFloat w = TWScreenWidth * 0.2;
    CGFloat y = TWScreenHeight - _boundaryView.tw_height - w * 0.5;
    CGFloat x = (TWScreenWidth - w) * 0.5;
    _baby = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, w)];
    _baby.image = [UIImage imageNamed:@"baby1"];
    [self.view addSubview:_baby];
}

#pragma mark --准备倒计时设置
- (void)time{
    
    
    
}





- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:^{
        if (_block) {
            _block();
        }
    }];
}


@end
