//
//  Define.h
//  EatFruit
//
//  Created by 田伟 on 2017/8/11.
//  Copyright © 2017年 田伟. All rights reserved.
//

#ifndef Define_h
#define Define_h

// MARK:- 弱引用
#define WeakSelf __weak typeof(self) weakSelf = self;

// MARK:- 屏幕高宽
#define TWScreenWidth [UIScreen mainScreen].bounds.size.width
#define TWScreenHeight [UIScreen mainScreen].bounds.size.height

// MARK:- 颜色
#define TWRandomColor [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0]
#define TWColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define TWColorRGB(r,g,b) TWColorRGBA(r,g,b,1.0)


#define ViewControllerBgColor TWColorRGB(45, 47, 78)


#define ButtonClickTime 0.3

// MARK:- ID
#define Character @"Character"


// MARK:- 打印
#ifdef DEBUG
#define TWLog(format, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define TWLogFunc TWLog(@"%s",__func__);
#else
#define TWLog(...)
#define TWLogFunc
#endif


// MARK:- 通知
//#define CatagroyRefreshNotification @"CatagroyRefreshNotification"


// MARK:- 全局统一数据
#define TWMargin 10
#define StatusBarHeight 20
#define NavigationBarHeight 64
#define TabBarHeight 49
#define TopImageViewH TWScreenWidth / (400 / 86.0)
#define CandyHeight 40
#define BabyHeight TWScreenWidth * 0.2
#define ImageViewW (TWScreenWidth - TWMargin * 5)
#define ImageViewWH (TWScreenWidth - TWMargin * 20)      // 角色小图
#define PipeHeight TWScreenHeight * 0.6
#define PipeWidth TWScreenWidth * 0.17

#endif /* Define_h */
