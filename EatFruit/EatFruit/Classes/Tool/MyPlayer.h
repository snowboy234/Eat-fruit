//
//  MyPlayer.h
//  MyConcentration
//
//  Created by ljie on 2017/8/10.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MyPlayer : AVAudioPlayer

@property (nonatomic, strong) AVAudioPlayer *player;

+ (instancetype)shareInstance;

//播放
- (void)playMusicWithName:(NSString *)name;
//暂停或播放
- (void)playOrStopMusic;

@end
