//
//  TWRootViewController.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/15.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWRootViewController.h"

@interface TWRootViewController ()

@end

@implementation TWRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackgroundImageView];
    [self initBottomView];
}

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
}


@end
