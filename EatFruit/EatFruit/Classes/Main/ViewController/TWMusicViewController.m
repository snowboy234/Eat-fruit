//
//  TWMusicViewController.m
//  EatFruit
//
//  Created by 田伟 on 2017/8/16.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "TWMusicViewController.h"

@interface TWMusicViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *musicSwitch;
@end

@implementation TWMusicViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString * show = [[NSUserDefaults standardUserDefaults] objectForKey:MusicShow];
    if ([show isEqualToString:ON]) {
        [self.musicSwitch setOn:YES];
    } else {
        [self.musicSwitch setOn:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)musicSwitchChanged:(UISwitch *)sender {
    BOOL isButtonOn = [sender isOn];
    if (isButtonOn) {
        NSLog(@"开");
        [[NSUserDefaults standardUserDefaults] setObject:ON forKey:MusicShow];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 音乐想起来
        
    }else {
        NSLog(@"关");
        [[NSUserDefaults standardUserDefaults] setObject:OFF forKey:MusicShow];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 关闭
        
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
