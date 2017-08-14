//
//  TWAirViewController.h
//  EatFruit
//
//  Created by 田伟 on 2017/8/11.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^repeatAnimationBlock)();
@interface TWAirViewController : UIViewController
@property(nonatomic, copy) repeatAnimationBlock block;
- (void)showBirdView;
- (void)countDownTime;
@end
