//
//  BabyImageView.h
//  815
//
//  Created by 田伟 on 2017/8/15.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BabyImageView : UIImageView

+ (instancetype)initBabyImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;
- (BOOL)checkIfCaught:(CGRect)frame;
@property (nonatomic, copy) NSString * name;
@end
