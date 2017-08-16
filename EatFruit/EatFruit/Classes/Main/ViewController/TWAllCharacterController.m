//
//  TWAllCharacterController.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/16.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWAllCharacterController.h"

@interface TWAllCharacterController ()
@property (weak, nonatomic) IBOutlet UIButton *buckButton;
@property (weak, nonatomic) IBOutlet UIButton *top_LeftButton;
@property (weak, nonatomic) IBOutlet UIButton *top_RightButton;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIButton *bottom_leftButton;
@property (weak, nonatomic) IBOutlet UIButton *bottom_RightButton;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (nonatomic, assign) NSInteger topIndex;
@property (nonatomic, assign) NSInteger bottomIndex;
@end

@implementation TWAllCharacterController

- (void)viewDidLoad {
    [super viewDidLoad];
    _topIndex = 1;
    _bottomIndex = 1;
    _top_LeftButton.hidden = YES;
    _bottom_leftButton.hidden = YES;
    _top_LeftButton.timeInterval = 0.3;
    _top_RightButton.timeInterval = 0.3;
    _bottom_leftButton.timeInterval = 0.3;
    _bottom_RightButton.timeInterval = 0.3;
}

- (IBAction)top_leftButtonClick:(id)sender {
    _top_RightButton.hidden = NO;
    _topIndex--;
    _topImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ch_%ld",_topIndex]];
    if (_topIndex == 1) {
        _top_LeftButton.hidden = YES;
    }
}

- (IBAction)top_RightButtonClick:(id)sender {
    _top_LeftButton.hidden = NO;
    _topIndex++;
    _topImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ch_%ld",_topIndex]];
    if (_topIndex == 4) {
        _top_RightButton.hidden = YES;
    }
}

- (IBAction)bottom_leftButtonClick:(id)sender {
    _bottom_RightButton.hidden = NO;
    _bottomIndex--;
    _bottomImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bird%ld",_bottomIndex]];
    if (_bottomIndex == 1) {
        _bottom_leftButton.hidden = YES;
    }
}

- (IBAction)bottom_RightButtonClick:(id)sender {
    _bottom_leftButton.hidden = NO;
    _bottomIndex++;
    _bottomImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bird%ld",_bottomIndex]];
    if (_bottomIndex == 4) {
        _bottom_RightButton.hidden = YES;
    }
}

- (IBAction)backButtonClick:(UIButton *)sender {
    // 保存当前的新形象
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"ch_%ld",_topIndex] forKey:TopCharacter];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"bird%ld",_bottomIndex] forKey:BottomCharacter];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
