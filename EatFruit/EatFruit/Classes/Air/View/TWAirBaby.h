//
//  TWAirBaby.h
//  EatFruit
//
//  Created by 田伟 on 2017/8/16.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWAirBaby : UIImageView
+ (instancetype)initBabyImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;
- (BOOL)checkIfCaught:(CGRect)frame;
@property (nonatomic, copy) NSString * name;
@end
