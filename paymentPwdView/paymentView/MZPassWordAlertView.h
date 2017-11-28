//
//  MZPassWordAlertView.h
//  MZLottery
//
//  Created by xingze on 17/6/29.
//  Copyright © 2017年 mizao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishedBlock)(NSString *pwStr);
typedef void (^CancelBtnOnClickBlock)();

@interface MZPassWordAlertView : UIView


+ (void)showWithTitle:(NSString *)title subTitle:(NSString *)subTitle money:(NSInteger)outPutBalance finish:(FinishedBlock)finish cancelBtnOnClick:(CancelBtnOnClickBlock)cancel;


@end
