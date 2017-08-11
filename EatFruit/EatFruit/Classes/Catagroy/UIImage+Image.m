//
//  UIImage+Image.m
//  BuDeJie
//
//  Created by 田伟 on 2017/1/18.
//  Copyright © 2017年 公司. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

+ (instancetype)imageWithStretchableName:(NSString *)imageName{
    UIImage * image = [UIImage imageNamed:imageName];
    //stretchableImageWithLeftCapWidth:topCapHeight:这个函数是UIImage的一个实例函数，它的功能是创建一个内容可拉伸，而边角不拉伸的图片，需要两个参数，第一个是左边不拉伸区域的宽度，第二个参数是上面不拉伸的高度。
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (instancetype)resizedImage:(NSString *)imageName{
    UIImage * image = [UIImage imageNamed:imageName];
    //这个方法只接收一个UIEdgeInsets类型的参数，可以通过设置UIEdgeInsets的left、right、top、bottom来分别指定左端盖宽度、右端盖宽度、顶端盖高度、底端盖高度
    //UIImageResizingMode参数，用来指定拉伸的模式：UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片,UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图片
    UIEdgeInsets insets = UIEdgeInsetsMake(image.size.height*0.5f, image.size.width*0.5f, image.size.height*0.5f, image.size.width*0.5f);
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

// 填充背景图片
+ (instancetype)imageTileWithName:(NSString *)imageName{
    UIImage * image = [UIImage imageNamed:imageName];
    CGFloat top = image.size.height * 0.5;
    CGFloat bottom = image.size.height * 0.5;
    CGFloat left = image.size.width * 0.5;
    CGFloat right = image.size.width * 0.5;
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为平铺模式
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
    return image;
}

+ (instancetype)imageOriginalWithName:(NSString *)imageName{
    UIImage * image = [UIImage imageNamed:imageName];
    // 不需要渲染
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}


/** 将图片变成圆形 */
- (instancetype)tw_circleImage{
    // 开启上下文,size填图片的大小，opaque填NO,表示要透明的——不要不透明的，scale表示比例因素，当前点与像素的比例，比如6p 1点对应3个像素，这里填0，自适应
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 描述剪裁区域--用它来描述一个圆
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    // 设置裁剪区
    [path addClip];
    // 画图片
    [self drawAtPoint:CGPointZero];
    
    // 取出图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();

    return image;
}
+ (instancetype)tw_circleImageNamed:(NSString *)imageName{
    return [[self imageNamed:imageName] tw_circleImage];
}



@end
