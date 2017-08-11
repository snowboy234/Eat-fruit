//
//  TWAirViewController.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/11.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWAirViewController.h"

@interface TWAirViewController ()

@end

@implementation TWAirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewControllerBgColor;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
