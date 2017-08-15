//
//  TWCharacterController.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/15.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWCharacterController.h"

@interface TWCharacterController ()
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;
@end

@implementation TWCharacterController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    [self initImageView];
    [self initToolView];
}

- (void)initToolView{

    UIView * toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, TWScreenWidth, CGRectGetMinY(_imageView.frame))];
    [self.view addSubview:toolView];
    
    // 返回首页按钮
    CGFloat WHProportion = 196 / 87.0;
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100 / WHProportion)];
    backButton.center = toolView.center;
    backButton.timeInterval = ButtonClickTime;
    [backButton setBackgroundImage:[UIImage imageNamed:@"back-sheet0"] forState:UIControlStateNormal];
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        // 保存当前的新形象
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"ch_%ld",_index] forKey:Character];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [toolView addSubview:backButton];
    
    // 左边的按钮
    CGFloat WHProportionB = 89 / 131.0;
    CGFloat h = 45 / WHProportionB;
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.timeInterval = 0.5;
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"arrow_next-sheet1"] forState:UIControlStateNormal];
    [toolView addSubview:_leftButton];
    [[_leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        _rightButton.hidden = NO;
        _index--;
        NSString * imageName = [NSString stringWithFormat:@"ch_%ld",_index];
        NSLog(@"%@",imageName);
        _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ch_%ld",_index]];
        if (_index == 1) {
            _leftButton.hidden = YES;
        }
    }];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(toolView).offset(20);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(h);
        make.centerY.mas_equalTo(backButton.mas_centerY);
    }];
    _leftButton.hidden = YES;
    
    // 右边的按钮
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.timeInterval = 0.5;
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"arrow_next-sheet0"] forState:UIControlStateNormal];
    [toolView addSubview:_rightButton];
    [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        _leftButton.hidden = NO;
        _index++;
        NSString * imageName = [NSString stringWithFormat:@"ch_%ld",_index];
        NSLog(@"%@",imageName);
        _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ch_%ld",_index]];
        if (_index == 4) {
            _rightButton.hidden = YES;
        }
    }];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(toolView).offset(-20);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(h);
        make.centerY.mas_equalTo(backButton.mas_centerY);
    }];
}

- (void)initImageView{
    // 计算宽高比例
    CGFloat WHProportion = 116 / 120.0;
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ImageViewWH, ImageViewWH / WHProportion)];
    _imageView.image = [UIImage imageNamed:@"ch_1"];
    _imageView.center = self.view.center;
    [ self.view addSubview:_imageView];
}


@end
