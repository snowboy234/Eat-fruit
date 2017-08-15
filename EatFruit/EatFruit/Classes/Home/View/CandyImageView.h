//
//  CandyImageView.h
//  815
//
//  Created by 田伟 on 2017/8/15.
//  Copyright © 2017年 田伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CandyImageView;

@protocol CandyImageViewDelegate <NSObject>
@required
-(void)checkPosition:(CandyImageView *)candy;   // 检查位置
-(void)removeMe:(CandyImageView *)candy;        // 移除
-(BOOL)checkGameStatus;                         // 检查游戏状态
@end

@interface CandyImageView : UIImageView

@property (nonatomic, assign) BOOL caught;          // 是否被抓住
@property (nonatomic, strong) NSTimer * myTimer;
@property (nonatomic, weak) id <CandyImageViewDelegate> delegate;
+ (instancetype)initCandyImageViewWithIamegName:(NSString *)imageName;
- (void)startFalling;
@end
