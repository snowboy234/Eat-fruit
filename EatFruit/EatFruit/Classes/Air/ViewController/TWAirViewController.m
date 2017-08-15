//
//  TWAirViewController.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/11.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWAirViewController.h"
#import "TWStrokeLabel.h"
#import "TWReadyStarView.h"
#import "DataTool.h"

@interface TWAirViewController ()<TWReadyStarViewDelegate>
@property (nonatomic, strong) UIImageView * topView;//顶部图片
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) BOOL isTap;
@property (nonatomic, strong) UIImageView * birdsView;
@property (nonatomic, strong) TWReadyStarView * readyStartView;         // 倒计时视图

@property (nonatomic, strong) UIImageView * headerView;                 // 上面工具栏视图
@property (nonatomic, strong) UIButton * starOrPauseButton;             // 暂停开始
@property (nonatomic, strong) TWStrokeLabel * scoreLabel;               // 显示分数的label
@property (nonatomic, assign) NSInteger score;                          // 得数

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, strong) UIImageView *topPipe;
@property (nonatomic, strong) UIImageView *bottomPipe;
@property (nonatomic, assign) CGRect topPipeFrame;
@property (nonatomic, strong) UILabel *columnLabel;
@property (nonatomic, strong) UIImageView * tapView;

@end

@implementation TWAirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackgroundImageView];
    [self initMiddleView];
    [self initBirdsView];
    [self initTopView];
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

#pragma mark --顶部背景设置
- (void)initTopView{
    _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -TopImageViewH * 1.2, TWScreenWidth, TopImageViewH * 1.2)];
    _headerView.image = [UIImage imageNamed:@"skyplace-sheet0"];
    _headerView.userInteractionEnabled = YES;
    [self.view addSubview:_headerView];
    
    _scoreLabel = [[TWStrokeLabel alloc]initWithFrame:CGRectMake(0, 0, TWScreenWidth, 50)];
    _scoreLabel.text = [NSString stringWithFormat:@"%ld",_score];
    _scoreLabel.textColor = [UIColor whiteColor];
    _scoreLabel.font = [UIFont boldSystemFontOfSize:50];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:_scoreLabel];
    [_scoreLabel setCenter:self.headerView.center];
    
    _starOrPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width = 40;
    _starOrPauseButton.frame = CGRectMake(TWScreenWidth - width - 10, 15 - TopImageViewH * 1.2, width, width);
    [_starOrPauseButton setBackgroundImage:[UIImage imageNamed:@"pause_sprite-sheet0"] forState:UIControlStateNormal];
    [self.headerView addSubview:_starOrPauseButton];
    _starOrPauseButton.timeInterval = ButtonClickTime;
    _starOrPauseButton.selected = YES;
    [[_starOrPauseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (x.selected) {
            x.selected = NO;
            [_starOrPauseButton setBackgroundImage:[UIImage imageNamed:@"pause_sprite-sheet1"] forState:UIControlStateNormal];
            [_timer setFireDate:[NSDate distantFuture]];
        } else {
            x.selected = YES;
            [_starOrPauseButton setBackgroundImage:[UIImage imageNamed:@"pause_sprite-sheet0"] forState:UIControlStateNormal];
            [_timer setFireDate:[NSDate distantPast]];
        }
    }];
}

#pragma mark --游戏界面设置
- (void)initBirdsView{
    _birdsView = [[UIImageView alloc]initWithFrame:CGRectMake(70, -60, 60, 60)];
    _birdsView.image = [UIImage imageNamed:@"bird1"];
    [self.view addSubview:_birdsView];
}

- (void)initGameUI{
    _isTap = NO;
    
    //第一次柱子动画
    [self pipe];
    
    //添加手势(单手单击手势)
    _tapView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TWScreenWidth, TWScreenHeight)];
    _tapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    [_tapView addGestureRecognizer:tap];
    [self.view addSubview:_tapView];
    [self.view insertSubview:_headerView aboveSubview:_tapView];
    
    //物理重力系数
    _number = 0;
    
    //已过柱子计数法及显示
    _columnNumber = 0;
    _columnLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, TWScreenWidth - 40, TWScreenHeight - 100)];
    _columnLabel.text = [NSString stringWithFormat:@"%zi",_columnNumber];
    _columnLabel.textAlignment = NSTextAlignmentCenter;
    _columnLabel.font = [UIFont fontWithName:@"Marker Felt" size:150];
    _columnLabel.textColor = [UIColor colorWithRed:0.6 green:0.5 blue:0.5 alpha:0.5];
    [self.view addSubview:_columnLabel];
    [self.view insertSubview:_columnLabel atIndex:2];
}

- (void)showBirdView{
    [UIView animateWithDuration:1.5 animations:^{
        _birdsView.tw_y = TWScreenHeight * 0.5;
    }];
}

#pragma mark --代理方法--
#pragma mark --TWReadyStarViewDelegate
- (void)customCountDown:(TWReadyStarView *)downView{
    // 准备开始游戏
//    [self initMiddleView];
    [self initGameUI];
    [self prepareForGame];
}

#pragma mark --其他私有方法
#pragma mark 绘制柱子
-(void)pipe {
    //通道高度
    NSInteger tunnelHeight = (NSInteger)(TWScreenHeight * 0.4);
    //柱子图像的位置
    NSInteger tall = arc4random() % (NSInteger)(TWScreenHeight * 0.5);
    
    /*
     450 * 2 = 900 + 200 = 1100;
     1100 - 736 = 364
     
     上面是 100
     
     上面至少露出来的 要大于100px  但是要小于450
                    -350                0
     */
    
    // 高度按比例固定为410
    CGFloat start = TWScreenWidth * 320 / 375.0;        // 起始位置
    _topPipe = [[UIImageView alloc]initWithFrame:CGRectMake(start, tall - TWScreenHeight * 0.5, PipeWidth, PipeHeight)];// 100 - 736 / 2  300 - 736 / 2
    _topPipe.image = [UIImage imageNamed:@"toppipe-sheet0"];
    [self.view insertSubview:_topPipe belowSubview:_headerView];
    
    _bottomPipe = [[UIImageView alloc]initWithFrame:CGRectMake(start, tall + tunnelHeight, PipeWidth, PipeHeight)];
    _bottomPipe.image = [UIImage imageNamed:@"toppipe-sheet0"];
    [self.view addSubview:_bottomPipe];
}

#pragma mark 定时器操作
-(void)onTimer {
    
    //上升
    if (_isTap == NO) {
        CGRect frame = _birdsView.frame;
        frame.origin.y -= 3;
        _number += 3;   // 上升的速度
        _birdsView.frame = frame;
        if (_number >= 60) {
            _isTap = YES;
        }
    }
    
    //下降
    if(_isTap == YES && _birdsView.frame.origin.y < TWScreenHeight){
        CGRect frame = _birdsView.frame;
        frame.origin.y++;
        _number -= 2;
        _birdsView.frame = frame;
        _number = 0;
    }
    
    //柱子移动
    _topPipeFrame = _topPipe.frame;
    CGRect bottomPipeFrame = _bottomPipe.frame;
    _topPipeFrame.origin.x--;
    bottomPipeFrame.origin.x--;
    _topPipe.frame = _topPipeFrame;
    _bottomPipe.frame = bottomPipeFrame;
    if (_topPipeFrame.origin.x < -80) {
        // 绘制柱子
        [self pipe];
    }
    
    //碰撞检测（交集）
    bool topRet = CGRectIntersectsRect(_birdsView.frame, _topPipe.frame);
    bool bottomRet = CGRectIntersectsRect(_birdsView.frame, _bottomPipe.frame);
    if (topRet == true || bottomRet == true) {
        //        [self.soundTool playSoundByFileName:@"punch"];
        [self onStop];
    }
    if (_topPipeFrame.origin.x == (100 + 30 - 70)) {
        //        [self.soundTool playSoundByFileName:@"pipe"];
        [self columnLabelClick];
    }
}

#pragma mark tap手势操作
-(void)onTap {
    _isTap = NO;
}

#pragma mark 更新分数
-(void)columnLabelClick {
    if (_topPipeFrame.origin.x == (100 + 30 - 70)) {
        _columnNumber++;
        _columnLabel.text = [NSString stringWithFormat:@"%zi",_columnNumber];
        _score = _columnNumber;
    }
}

#pragma mark 游戏停止
-(void)onStop {
    //更新分数
    [self updateScore];
    //停止定时器
    [_timer setFireDate:[NSDate distantFuture]];
    //弹出游戏结束操作界面
    [self pullGameOver];
}

#pragma mark 弹出游戏结束操作界面
-(void)pullGameOver {
    //游戏结束操作界面
    NSLog(@"GameOver");
}

#pragma mark 更新分数记录
-(void)updateScore {
    //更新最佳成绩
//    if (_columnNumber > [DataTool integerForKey:kBestScoreKey]) {
//        [DataTool setInteger:_columnNumber forKey:kBestScoreKey];
//    }
//    //更新本局分数
//    [DataTool setInteger:_columnNumber forKey:kCurrentScoreKey];
//    //更新排行榜
//    NSArray *ranks = (NSArray *)[DataTool objectForKey:kRankKey];
//    NSMutableArray *newRanksM = [NSMutableArray array];
//    NSInteger count = ranks.count;
//    BOOL isUpdate = NO;
//    for (NSInteger i = 0; i < count; i++) {
//        NSString *scoreStr = ranks[i];
//        NSInteger score = [scoreStr integerValue];
//        if (score < _columnNumber && isUpdate == NO) {
//            scoreStr = [NSString stringWithFormat:@"%zi", _columnNumber];
//            [newRanksM addObject:scoreStr];
//            isUpdate = YES;
//            i--;
//        } else {
//            scoreStr = [NSString stringWithFormat:@"%zi", score];
//            [newRanksM addObject:scoreStr];
//        }
//    }
//    if (newRanksM.count > count) {
//        [newRanksM removeLastObject];
//    }
//    [DataTool setObject:newRanksM forKey:kRankKey];
}


#pragma mark --准备倒计时设置
- (void)countDownTime{
    [[UIApplication sharedApplication].keyWindow addSubview:self.readyStartView];
    [_readyStartView addTimerForAnimationDownView];
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

- (void)prepareForGame{
    // 界面组装
    [UIView animateWithDuration:0.5 animations:^{
        self.headerView.tw_y = 0;
        self.starOrPauseButton.tw_y = 15;
        [self.starOrPauseButton setBackgroundImage:[UIImage imageNamed:@"pause_sprite-sheet0"] forState:UIControlStateNormal];
        self.starOrPauseButton.selected = YES;
        [self.scoreLabel setCenter:self.headerView.center];
    } completion:^(BOOL finished) {
        [self begeinGame];
    }];
}

- (void)begeinGame{
    
    //计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
}


// 退出视图
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    // 头部视图隐藏
//    [UIView animateWithDuration:0.25 animations:^{
//        self.headerView.tw_y = -TopImageViewH * 1.2;
//        self.starOrPauseButton.tw_y = 15 - TopImageViewH * 1.2;
//        [self.scoreLabel setCenter:self.headerView.center];
//        _birdsView.tw_y = -60;
//    }];
//
//    [self dismissViewControllerAnimated:YES completion:^{
//        if (_block) {
//            _block();
//        }
//    }];
//}


@end
