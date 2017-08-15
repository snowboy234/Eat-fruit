//
//  Score.m
//  815
//
//  Created by 田伟 on 2017/8/15.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import "Score.h"

@implementation Score
+(id)initScore{
    Score *score = [Score new];
    score.points = 0;
    return score;
}

-(id)addPoints{
    self.points += 50;
    return self;
}

-(id)fail{
    self.points -= 100;
    if(self.points < 0)
        self.points = 0;
    return self;
}

@end
