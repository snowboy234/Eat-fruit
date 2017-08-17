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
@property (nonatomic, strong) NSString * showMusic;
@property (nonatomic, strong) SoundTool * soundTool;
@property (nonatomic, strong) MyPlayer * soundPlay;
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
    
    _showMusic = [[NSUserDefaults standardUserDefaults] objectForKey:MusicShow];
    if ([_showMusic isEqualToString:ON]) {
        [_soundPlay playOrStopMusic];
    } else {
        [_soundPlay stopMusic];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([_showMusic isEqualToString:ON]) {
        [_soundPlay playOrStopMusic];
    } else {
        [_soundPlay stopMusic];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _soundPlay = [MyPlayer shareInstance];
    _soundTool = [[SoundTool alloc]init];
    [self.view bringSubviewToFront:_musicSwitch];
    _musicSwitch.onTintColor = [UIColor colorWithRed:0.945f green:0.573f blue:0.431f alpha:1.00f];
    _musicSwitch.thumbTintColor = [UIColor colorWithRed:0.984f green:0.890f blue:0.855f alpha:1.00f];
    _musicSwitch.tintColor = [UIColor colorWithRed:0.933f green:0.427f blue:0.255f alpha:1.00f];
}

- (IBAction)musicSwitchChanged:(UISwitch *)sender {
    BOOL isButtonOn = [sender isOn];
    if (isButtonOn) {
        NSLog(@"开");
        [[NSUserDefaults standardUserDefaults] setObject:ON forKey:MusicShow];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_soundPlay playOrStopMusic];
        
    }else {
        NSLog(@"关");
        [[NSUserDefaults standardUserDefaults] setObject:OFF forKey:MusicShow];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_soundPlay stopMusic];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UIViewController *rootVC = self.presentingViewController;
//    while (rootVC.presentingViewController) {
//        rootVC = rootVC.presentingViewController;
//    }
//    [rootVC dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
