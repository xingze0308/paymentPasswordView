//
//  MZPassWordInputView.h
//  MZLottery
//
//  Created by xingze on 17/6/29.
//  Copyright © 2017年 mizao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZPassWordInputView;

NS_ASSUME_NONNULL_BEGIN

@protocol MZPasswordInputViewDelegate <NSObject>

@optional
- (void)passwordInputView:(MZPassWordInputView *)inputView willBeginInputWithPassword:(NSString *)password;

- (void)passwordInputView:(MZPassWordInputView *)inputView willEndInputWithPassword:(NSString *)password;

- (void)passwordInputView:(MZPassWordInputView *)inputView didChangeInputWithPassword:(NSString *)password;

- (void)passwordInputView:(MZPassWordInputView *)inputView didFinishInputWithPassword:(NSString *)password;

@end

@interface MZPassWordInputView : UIView <UIKeyInput>


/** 密码长度*/
@property (nonatomic, assign) NSInteger passwordLength;
/** 密码字符大小*/
@property (nonatomic, assign) CGFloat passwordWidth;
/** 密码字符颜色*/
@property (nonatomic, strong) UIColor *passwordColor;
/** 密码字符图片*/
@property (nonatomic, strong) UIImage *passwordImage;
/** 显示边框*/
@property (nonatomic, assign) BOOL showBorder;
/** 边框圆角大小*/
@property (nonatomic, assign) CGFloat borderCornerRadius;
/** 边框线宽*/
@property (nonatomic, assign) CGFloat borderWidth;
/** 边框颜色*/
@property (nonatomic, strong) UIColor *borderColor;
/** 键盘类型*/
@property (nonatomic, assign) UIKeyboardType keyboardType;
/** 返回按钮类型*/
@property (nonatomic, assign) UIReturnKeyType returnKeyType;
/** 密码文本*/
@property (nonatomic, copy, nullable) NSString *passwordText;
/** 内边距*/
@property (nonatomic, assign) UIEdgeInsets contentInsets;


@property (nonatomic, weak) id<MZPasswordInputViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
