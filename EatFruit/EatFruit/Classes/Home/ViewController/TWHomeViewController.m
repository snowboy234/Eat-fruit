//
//  TWHomeViewController.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/11.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWHomeViewController.h"

@interface TWHomeViewController ()
@end

@implementation TWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewControllerBgColor;
    [self initBottomView];
}

- (void)initBottomView{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, TWScreenHeight - (TWScreenHeight / 5), TWScreenWidth, TWScreenHeight / 5)];
    [self.view addSubview:bottomView];
    
    UIView * yellowView = [UIView creactViewWith:CGRectMake(0, 0, TWScreenWidth, bottomView.tw_height) bgColor:TWColorRGB(229, 138, 59)];
    [bottomView addSubview:yellowView];
    
    UIView * blueView = [UIView creactViewWith:CGRectMake(0, 0, TWScreenWidth, bottomView.tw_height / 3) bgColor:TWColorRGB(80, 157, 85)];
    [bottomView addSubview:blueView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
