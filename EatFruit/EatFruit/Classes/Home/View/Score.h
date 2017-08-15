//
//  Score.h
//  815
//
//  Created by 田伟 on 2017/8/15.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject
@property (nonatomic, assign) NSInteger points;
+ (id)initScore;
- (id)addPoints;
- (id)fail;
@end
