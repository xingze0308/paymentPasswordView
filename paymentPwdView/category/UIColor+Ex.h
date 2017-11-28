//
//  UIColor+Ex.h
//  MZLottery
//
//  Created by xingze on 17/6/2.
//  Copyright © 2017年 mizao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Ex)
+ (UIColor *)hexFloatColor:(NSString *)hexStr;


//十六进制字符串获取颜色
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


//根据某个颜色生成图片
+ (UIImage *)createImageWithColor:(UIColor *)color;
@end
