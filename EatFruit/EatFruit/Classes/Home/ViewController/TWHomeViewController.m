//
//  TWHomeViewController.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/11.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWHomeViewController.h"
#import "TWReadyStarView.h"
#import "CandyImageView.h"
#import "BabyImageView.h"
#import "Score.h"
#import "TWHomeGameOverController.h"

@interface TWHomeViewController ()<TWReadyStarViewDelegate, CandyImageViewDelegate>
@property (nonatomic, strong) UIView * boundaryView;                    // 约束人物行动的底座
@property (nonatomic, strong) BabyImageView * baby;                     // 人物
@property (nonatomic, copy) NSString * babyName;                        // 人物名称
@property (nonatomic, strong) TWReadyStarView * readyStartView;         // 倒计时视图
@property (nonatomic, assign) BOOL paused;                              // 暂停
@property (nonatomic, strong) UIImageView * headerView;                 // 上面工具栏视图
@property (nonatomic, strong) UIImageView * lifeView;                   // 显示❤️
@property (nonatomic, strong) UILabel * lifeCountLabel;                 // 显示剩余几次❤️
@property (nonatomic, assign) NSInteger lifeCount;                      // 共有几条生命
@property (nonatomic, strong) UIButton * starOrPauseButton;             // 暂停开始
@property (nonatomic, strong) TWStrokeLabel * scoreLabel;               // 显示分数的label
@property (nonatomic, strong) Score * score;                            // 得数

@property (nonatomic, strong) NSMutableArray * foodArray;
@property (nonatomic, strong) NSMutableArray * unfoodArray;

@property (nonatomic, strong) NSMutableArray * allArray;
@property (nonatomic, strong) NSMutableArray * allFoodArray;            // 所有食物
@property (nonatomic, strong) NSMutableArray * allUnfoodArray;          // 所有武器
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) TWHomeGameOverController * gameOverVc;

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

- (NSMutableArray *)allFoodArray{
    if (_allFoodArray == nil) {
        _allFoodArray = [NSMutableArray array];
    }
    return _allFoodArray;
}

- (NSMutableArray *)allUnfoodArray{
    if (_allUnfoodArray == nil) {
        _allUnfoodArray = [NSMutableArray array];
    }
    return _allUnfoodArray;
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
    NSString * charater = [[NSUserDefaults standardUserDefaults] objectForKey:Character];
    if (charater) {
        _babyName = charater;
    } else {
        _babyName = @"baby1";
    }
    self.baby.name = _babyName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _score = [Score initScore];
    _paused = NO;
    _lifeCount = 3;
    _gameOverVc = [[TWHomeGameOverController alloc]init];
    [self initBackgroundImageView];
    [self initBottomView];
    [self initBabyImageView];
    [self initTopView];
}

- (void)dealloc{
    TWLog(@"land页面清除");
    [_timer invalidate];
    _timer = nil;
}

// 移动人物
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.paused){
        UITouch * theTouch = [touches anyObject];
        if([theTouch view] == self.baby && [theTouch locationInView:self.view].x >= BabyHeight * 0.5 && [theTouch locationInView:self.view].x <= TWScreenWidth - BabyHeight * 0.5){
            //抖动imageView
            CABasicAnimation * shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            shake.fromValue = [NSNumber numberWithFloat:-0.2];
            shake.toValue = [NSNumber numberWithFloat:+0.2];
            shake.duration = 0.1;
            shake.autoreverses = YES; //是否重复
            shake.repeatCount = MAXFLOAT;
            [self.baby.layer addAnimation:shake forKey:@"imageView"];
            self.baby.center = CGPointMake([theTouch locationInView:self.view].x, self.baby.center.y);
        }
    }
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
    _lifeCountLabel.text = [NSString stringWithFormat:@"× %ld",_lifeCount];
    _lifeCountLabel.textColor = [UIColor colorWithRed:0.941f green:0.059f blue:0.282f alpha:1.00f];
    _lifeCountLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.headerView addSubview:_lifeCountLabel];
    _lifeCountLabel.tw_centerY = self.lifeView.tw_centerY;
    
    _scoreLabel = [[TWStrokeLabel alloc]initWithFrame:CGRectMake(0, 0, TWScreenWidth, 50)];
    _scoreLabel.text = [NSString stringWithFormat:@"%ld",_score.points];
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
            self.paused = YES;
        } else {
            x.selected = YES;
            [_starOrPauseButton setBackgroundImage:[UIImage imageNamed:@"pause_sprite-sheet0"] forState:UIControlStateNormal];
            self.paused = NO;
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
    CGFloat y = TWScreenHeight - _boundaryView.tw_height - BabyHeight * 0.5;
    CGFloat x = (TWScreenWidth - BabyHeight) * 0.5;
    NSInteger w = (NSInteger)BabyHeight;
    _baby = [BabyImageView initBabyImageViewWithFrame:CGRectMake(x, y, w, w) imageName:_babyName];
    [self.view addSubview:_baby];
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
    [self prepareForGame];
}

#pragma mark --CandyImageViewDelegate
// 当candy到达baby的头顶10px时触发本方法
- (void)checkPosition:(CandyImageView *)candy{
    
    if([self.baby checkIfCaught:candy.frame]){
        candy.caught = YES;
        // 接住的的食物
        if ([self.allFoodArray containsObject:candy]) {
            // 加分
            self.score = [self.score addPoints];
        } else {
            // 减❤️
            _lifeCount --;
            _lifeCountLabel.text = [NSString stringWithFormat:@"× %ld",_lifeCount];
    
            // _lifeCount个数小于0的时候失败
            if (_lifeCount == -1) {
                _lifeCountLabel.text = @"× 0";
                
                [self gameOver];
                
                return;
            }
        }
    }else{
        if ([self.allFoodArray containsObject:candy]) {
            // 减分
            self.score = [self.score fail];
        }
    }
    
    // 显示分数
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", self.score.points];
}

- (void)removeMe:(CandyImageView *)candy{
    [candy removeFromSuperview];
}

- (BOOL)checkGameStatus{
    return self.paused;
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
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(createCandy) userInfo:nil repeats:YES];
    }];
}

// 随机掉落
- (void)createCandy{
    if(!self.paused){
        NSInteger index = arc4random() % self.allArray.count;

        CandyImageView * candy = [CandyImageView initCandyImageViewWithIamegName:self.allArray[index]];
        candy.delegate = self;
        [candy startFalling];
        [self.view insertSubview:candy belowSubview:self.headerView];
        
        // 区分下掉落的是哪种
        if (index < 10) {
            // 食物
            [self.allFoodArray addObject:candy];
        } else {
            // 武器
            [self.allUnfoodArray addObject:candy];
        }
    }
}

// 本轮游戏结束
- (void)gameOver{
    
    // 保存分数，停止掉落，清空
    _paused = YES;
    
    // 跳出页面
    [UIView animateWithDuration:1 animations:^{
        self.headerView.tw_y = -TopImageViewH * 1.2;
        self.lifeView.tw_y = 15 - TopImageViewH * 1.2;
        self.starOrPauseButton.tw_centerY = self.lifeView.tw_centerY;
        self.lifeCountLabel.tw_centerY = self.lifeView.tw_centerY;
        [self.scoreLabel setCenter:self.headerView.center];
    }completion:^(BOOL finished) {
        // 退出视图
        _gameOverVc.score = _score.points;
        [self presentViewController:_gameOverVc animated:YES completion:nil];
    }];
}


-(void)saveScore{
    NSLog(@"Save Score");
//    NSArray *saved = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrScores"];
//    if(saved == nil){
//        saved = [NSMutableArray new];
//    }
//    NSMutableArray *scores = [[NSMutableArray alloc] initWithArray:saved];
//    if(self.score.points > 0)
//        [scores addObject:[NSNumber numberWithInt:self.score.points]];
//    
//    scores = [NSMutableArray arrayWithArray:[scores sortedArrayUsingDescriptors:
//                                             @[[NSSortDescriptor sortDescriptorWithKey:@"intValue"
//                                                                             ascending:NO]]]];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:scores forKey:@"arrScores"];
}



@end
