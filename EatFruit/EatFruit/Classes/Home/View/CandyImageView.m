//
//  CandyImageView.m
//  815
//
//  Created by 田伟 on 2017/8/15.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "CandyImageView.h"

@implementation CandyImageView

+ (instancetype)initCandyImageViewWithIamegName:(NSString *)imageName{
    // 随机x坐标
    NSInteger x = arc4random() % (int)(TWScreenWidth - 40) + 20;
    CandyImageView * imageView = [[CandyImageView alloc]initWithFrame:CGRectMake(x, 0, CandyHeight, CandyHeight)];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.caught = NO;
    return imageView;
}

- (void)startFalling{
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveBall) userInfo:nil repeats:YES];
}

-(void)moveBall{
    BOOL paused = [self.delegate checkGameStatus];
    if(!paused){
        // Y轴累加 造成下落效果
        self.center = CGPointMake(self.center.x, self.center.y + 1);
        // 转成整数
        NSInteger w = (NSInteger)BabyHeight;
        //这是检查用户抓住球的时刻
        //屏幕尺寸 - 球高度 - 净高度
        if(self.center.y == TWScreenHeight - CandyHeight - w){
            [self.delegate checkPosition:self];
        }
        
        // 完成动画
        if(self.caught){
            // 被接住
            if(self.center.y > TWScreenHeight - (CandyHeight + w - 20)){
                [self.myTimer invalidate];
                [self.delegate removeMe:self];
            }
        }else{
            // 掉落到地上
            if(self.center.y > TWScreenHeight){
                [self.myTimer invalidate];
                [self.delegate removeMe:self];
            }
        }
    }
}

- (void)dealloc{
    self.myTimer = nil;
}

@end
