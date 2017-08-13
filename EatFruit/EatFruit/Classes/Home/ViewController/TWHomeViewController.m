//
//  TWHomeViewController.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/11.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWHomeViewController.h"
#import "TWReadyStarView.h"
#import "TWStrokeLabel.h"

#define TopImageViewH TWScreenWidth / (400 / 86.0)

@interface TWHomeViewController ()<TWReadyStarViewDelegate, UICollisionBehaviorDelegate>
@property (nonatomic, strong) UIView * boundaryView;                    // 约束人物行动的底座
@property (nonatomic, strong) UIImageView * baby;                       // 人物
@property (nonatomic, copy) NSString * babyName;                        // 人物名称
@property (nonatomic, strong) TWReadyStarView * readyStartView;         // 倒计时视图

@property (nonatomic, strong) UIImageView * headerView;                 // 上面工具栏视图
@property (nonatomic, strong) UIImageView * lifeView;                   // 显示❤️
@property (nonatomic, strong) UILabel * lifeCountLabel;                 // 显示剩余几次❤️
@property (nonatomic, strong) UIButton * starOrPauseButton;             // 暂停开始
@property (nonatomic, strong) TWStrokeLabel * scoreLabel;               // 显示分数

@property (nonatomic, strong) NSMutableArray * foodArray;
@property (nonatomic, strong) NSMutableArray * unfoodArray;
@property (nonatomic, strong) NSMutableArray * allArray;

@property (nonatomic, strong) NSMutableArray * allImageViewArray;       // 所有掉落的对象

@property (nonatomic, strong) UIDynamicAnimator * dynamicAnimator;
@property (nonatomic, strong) UIGravityBehavior * gravityBehavior;
@property (nonatomic, strong) UICollisionBehavior * collisionBehavior;
@property (nonatomic, strong) NSTimer * timer;
@end

@implementation TWHomeViewController

#pragma mark --懒加载
- (NSMutableArray *)foodArray{
    if (_foodArray == nil) {
        _foodArray = [NSMutableArray array];
        for (NSInteger i = 1; i <= 10; i++) {
            NSString * foodName = [NSString stringWithFormat:@"food%ld",i];
            [_foodArray addObject:foodName];
        }
    }
    return _foodArray;
}

- (NSMutableArray *)unfoodArray{
    if (_unfoodArray == nil) {
        _unfoodArray = [NSMutableArray array];
        for (NSInteger i = 1; i <= 3; i++) {
            NSString * foodName = [NSString stringWithFormat:@"unfood%ld",i];
            [_unfoodArray addObject:foodName];
        }
    }
    return _unfoodArray;
}

- (NSMutableArray *)allArray{
    if (_allArray == nil) {
        _allArray = [NSMutableArray array];
        for (NSInteger i = 0; i < self.foodArray.count; i++) {
            [_allArray addObject:self.foodArray[i]];
        }
        for (NSInteger i = 0; i < self.unfoodArray.count; i++) {
            [_allArray addObject:self.unfoodArray[i]];
        }
    }
    return _allArray;
}

- (NSMutableArray *)allImageViewArray{
    if (_allImageViewArray == nil) {
        _allImageViewArray = [NSMutableArray array];
    }
    return _allImageViewArray;
}

- (TWReadyStarView *)readyStartView{
    if (_readyStartView == nil) {
        _readyStartView = [TWReadyStarView createView];
        _readyStartView.delegate = self;
        _readyStartView.frame = [UIScreen mainScreen].bounds;
        _readyStartView.backgroundColor = [UIColor clearColor];
    }
    return _readyStartView;
}

#pragma mark --系统回调函数
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 先获取选定的人物
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDynamic];
    [self initBackgroundImageView];
    [self initBottomView];
    [self initBabyImageView];
    [self initTopView];
}

- (void)createDynamic{
    _dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    _gravityBehavior = [[UIGravityBehavior alloc]init];
    _collisionBehavior = [[UICollisionBehavior alloc]init];
    _collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    _collisionBehavior.collisionDelegate = self;
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [_dynamicAnimator addBehavior:_gravityBehavior];
    [_dynamicAnimator addBehavior:_collisionBehavior];
}

#pragma mark --UI界面--
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

#pragma mark --顶部背景设置
- (void)initTopView{
    _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -TopImageViewH * 1.2, TWScreenWidth, TopImageViewH * 1.2)];
    _headerView.image = [UIImage imageNamed:@"skyplace-sheet0"];
    _headerView.userInteractionEnabled = YES;
    [self.view addSubview:_headerView];
    
    _lifeView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15 - TopImageViewH * 1.2, 40, 40)];
    _lifeView.image = [UIImage imageNamed:@"life-sheet0"];
    [self.headerView addSubview:_lifeView];
    
    _lifeCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lifeView.frame) + 10, 0, 60, 40)];
    _lifeCountLabel.text = @"× 3";
    _lifeCountLabel.textColor = [UIColor colorWithRed:0.941f green:0.059f blue:0.282f alpha:1.00f];
    _lifeCountLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.headerView addSubview:_lifeCountLabel];
    _lifeCountLabel.tw_centerY = self.lifeView.tw_centerY;
    
    _scoreLabel = [[TWStrokeLabel alloc]initWithFrame:CGRectMake(0, 0, TWScreenWidth, 50)];
    _scoreLabel.text = @"12020";
    _scoreLabel.textColor = [UIColor whiteColor];
    _scoreLabel.font = [UIFont boldSystemFontOfSize:50];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:_scoreLabel];
    [_scoreLabel setCenter:self.headerView.center];
    
    _starOrPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width = 40;
    _starOrPauseButton.frame = CGRectMake(TWScreenWidth - width - 10, 0, width, width);
    [_starOrPauseButton setBackgroundImage:[UIImage imageNamed:@"pause_sprite-sheet0"] forState:UIControlStateNormal];
    _starOrPauseButton.tw_centerY = self.lifeView.tw_centerY;
    [self.headerView addSubview:_starOrPauseButton];
    _starOrPauseButton.timeInterval = ButtonClickTime;
    _starOrPauseButton.selected = YES;
    [[_starOrPauseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (x.selected) {
            x.selected = NO;
            [_starOrPauseButton setBackgroundImage:[UIImage imageNamed:@"pause_sprite-sheet1"] forState:UIControlStateNormal];
            TWLog(@"暂停");
        } else {
            x.selected = YES;
            [_starOrPauseButton setBackgroundImage:[UIImage imageNamed:@"pause_sprite-sheet0"] forState:UIControlStateNormal];
            TWLog(@"开始");
        }
    }];
}

#pragma mark --中间背景设置
- (void)initMiddleView{
    CGFloat width = TWScreenWidth * 0.5;
    CGFloat y1 = TWScreenHeight * 0.5 - width;
    UIImageView * cloud1 = [[UIImageView alloc]initWithFrame:CGRectMake(TWScreenWidth, y1, width, width / (173 / 140.0))];
    cloud1.image = [UIImage imageNamed:@"may_1-sheet0"];
    [self.view addSubview:cloud1];
    CGFloat y2 = TWScreenHeight * 0.5;
    UIImageView * cloud2 = [[UIImageView alloc]initWithFrame:CGRectMake(TWScreenWidth, y2, width, width / (195 / 134.0))];
    cloud2.image = [UIImage imageNamed:@"may_2-sheet0"];
    [self.view addSubview:cloud2];
    
    [UIView animateWithDuration:60 animations:^{
        cloud1.tw_x = -width;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:60 animations:^{
            cloud2.tw_x = -width;
        } completion:^(BOOL finished) {
            [cloud1 removeFromSuperview];
            [cloud2 removeFromSuperview];
        }];
    }];
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
    _baby.userInteractionEnabled = YES;
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(babyImageViewSwipeGestureRecognizer:)];
    [_baby addGestureRecognizer:swipe];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(babyImageViewTapGestureRecognizer:)];
    [_baby addGestureRecognizer:tap];
}

- (void)babyImageViewTapGestureRecognizer:(UITapGestureRecognizer *)tap{
    TWLog(@"点击");
}

- (void)babyImageViewSwipeGestureRecognizer:(UISwipeGestureRecognizer *)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        TWLog(@"向左");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        TWLog(@"向右");
    }
}

#pragma mark --准备倒计时设置
- (void)countDownTime{
    [[UIApplication sharedApplication].keyWindow addSubview:self.readyStartView];
    [_readyStartView addTimerForAnimationDownView];
}


#pragma mark --代理方法--
#pragma mark --TWReadyStarViewDelegate
- (void)customCountDown:(TWReadyStarView *)downView{
    // 准备开始游戏
    [self initMiddleView];
//    [self prepareForGame];
}

#pragma mark --UICollisionBehaviorDelegate
// 开始碰撞时触发的方法
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    
    
    
    // 当碰触到小孩时，需要被吃掉
    
    
    
    
    
    
    // 当没有碰到小孩并且碰撞底边时，需要移除
    if (TWScreenHeight - p.y <= 1) {
        for (NSInteger i = 0; i < self.allImageViewArray.count; i++) {
            if ([item isEqual:self.allImageViewArray[i]]) {
                UIImageView * imageView = self.allImageViewArray[i];
                if ([imageView isEqual:item]) {
                    [_collisionBehavior removeItem:imageView];
                    [_gravityBehavior removeItem:imageView];
                    [self.allImageViewArray removeObject:imageView];
                    [imageView removeFromSuperview];
                }
            }
        }
    }
}

#pragma mark --其他私有方法
- (void)prepareForGame{
    // 界面组装
    [UIView animateWithDuration:0.5 animations:^{
        self.headerView.tw_y = 0;
        self.lifeView.tw_y = 15;
        self.starOrPauseButton.tw_centerY = self.lifeView.tw_centerY;
        [self.starOrPauseButton setBackgroundImage:[UIImage imageNamed:@"pause_sprite-sheet0"] forState:UIControlStateNormal];
        self.starOrPauseButton.selected = YES;
        self.lifeCountLabel.tw_centerY = self.lifeView.tw_centerY;
        [self.scoreLabel setCenter:self.headerView.center];
    } completion:^(BOOL finished) {
        [self begeinGame];
    }];
}

- (void)begeinGame{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dropFruit) userInfo:nil repeats:YES];
    [_timer fire];
}

// 随机掉落
- (void)dropFruit{
    NSInteger x = arc4random() % (int)TWScreenWidth;
    NSInteger size = arc4random() % 5 + 30;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, size, size)];
    imageView.image = [UIImage imageNamed:_allArray[arc4random() % self.allArray.count]];
    [self.view insertSubview:imageView belowSubview:_headerView];
    [self.allImageViewArray addObject:imageView];
    [_gravityBehavior addItem:imageView];
    [_collisionBehavior addItem:imageView];
}

// 模拟返回主页
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    [self pauseFruit];
//    
//    // 头部视图隐藏
//    [UIView animateWithDuration:0.25 animations:^{
//        self.headerView.tw_y = -TopImageViewH * 1.2;
//        self.lifeView.tw_y = 15 - TopImageViewH * 1.2;
//        self.starOrPauseButton.tw_centerY = self.lifeView.tw_centerY;
//        self.lifeCountLabel.tw_centerY = self.lifeView.tw_centerY;
//        [self.scoreLabel setCenter:self.headerView.center];
//    }];
//    
//    // 退出视图
//    [self dismissViewControllerAnimated:YES completion:^{
//        if (_block) {
//            _block();
//        }
//    }];
//}

- (void)pauseFruit{
    // 关闭定时器,移除所有imageView
    [_timer invalidate];
    for (NSInteger i = 0; i < self.allImageViewArray.count; i++) {
        UIImageView * imageView = self.allImageViewArray[i];
        [_collisionBehavior removeItem:imageView];
        [_gravityBehavior removeItem:imageView];
        [imageView removeFromSuperview];
    }
    [self.allImageViewArray removeAllObjects];
}

@end
