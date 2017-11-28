//
//  MZPassWordInputView.m
//  MZLottery
//
//  Created by xingze on 17/6/29.
//  Copyright © 2017年 mizao. All rights reserved.
//

#import "MZPassWordInputView.h"
#import "UIColor+Ex.h"

@interface MZPassWordInputView ()

@property (nonatomic, strong) NSMutableString *passwordStrong;

@end

@implementation MZPassWordInputView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    _passwordLength = 6;
    _passwordWidth = 17;
    _passwordColor = [UIColor blackColor];
    _showBorder = YES;
    _borderCornerRadius = 0;
    _borderWidth = 0.5;
    _borderColor = [UIColor colorWithHexString:@"d0d0d1"];
    _keyboardType = UIKeyboardTypeNumberPad;
    _returnKeyType = UIReturnKeyDefault;
    _passwordStrong = [NSMutableString string];
    self.backgroundColor = [UIColor whiteColor];
}

// MARK: - Override

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)drawRect:(CGRect)rect{
    //UIEdgeInsetsInsetRect表示在原来的rect基础上根据变远距离内切一个rect
    CGRect drawRect = UIEdgeInsetsInsetRect(rect, self.contentInsets);
    CGFloat drawRectX = drawRect.origin.x;
    CGFloat drawRectY = drawRect.origin.y;
    CGFloat charRectWidth = drawRect.size.width / self.passwordLength;
    CGFloat charRectHeight = drawRect.size.height;
    CGFloat charNumber = self.passwordLength;
    
    UIImage *drawImage = self.passwordImage ? :[self createImageWithColor:self.passwordColor radius:self.passwordWidth * 0.5];
    
    if (self.showBorder) {
        
        UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:self.borderCornerRadius];
        
        for (int i = 1; i<charNumber; i++) {
            [borderPath moveToPoint:CGPointMake(drawRectX + charRectWidth * i, drawRectY)];
            [borderPath addLineToPoint:CGPointMake(drawRectX + charRectWidth * i, drawRectY+ charRectHeight)];
        }
        
        borderPath.lineWidth = self.borderWidth;
        
        [self.borderColor setStroke];
        [borderPath stroke];
    }
    
    CGFloat pcX = drawRectX + charRectWidth * 0.5 - self.passwordWidth * 0.5;
    CGFloat pcY = drawRectY + charRectHeight * 0.5 - self.passwordWidth * 0.5;
    CGFloat pcW = self.passwordWidth;
    CGFloat pcH = self.passwordWidth;
    CGRect passwordCharRect = CGRectMake(pcX, pcY, pcW, pcH);
    
    passwordCharRect.origin.x -= charRectWidth;
    for (int i = 0; i<self.passwordStrong.length; i++) {
        passwordCharRect.origin.x += charRectWidth;
        [drawImage drawInRect:passwordCharRect];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.isFirstResponder) {
        [self becomeFirstResponder];
    }
}

- (BOOL)becomeFirstResponder{
    [self callDelegateWhenInputWillBegin];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{

    [self callDelegateWhenInputWillEnd];
    return  [super resignFirstResponder];
}

// MARK: - delegate method
- (void)callDelegateWhenInputWillBegin{
    if (self.delegate && [self.delegate respondsToSelector:@selector(passwordInputView:willBeginInputWithPassword:)]) {
        [self.delegate passwordInputView:self willBeginInputWithPassword:self.passwordText];
    }
}

- (void)callDelegateWhenInputWillEnd{
    if (self.delegate && [self.delegate respondsToSelector:@selector(passwordInputView:willEndInputWithPassword:)]) {
        [self.delegate passwordInputView:self willEndInputWithPassword:self.passwordText];
    }
}

- (void)callDelegateWhenInputChange{
    if (self.delegate && [self.delegate respondsToSelector:@selector(passwordInputView:didChangeInputWithPassword:)]) {
        [self.delegate passwordInputView:self didChangeInputWithPassword:self.passwordText];
    }
}

- (void)callDelegateWhenInputFinshed{
    if (self.delegate && [self.delegate respondsToSelector:@selector(passwordInputView:didFinishInputWithPassword:)]) {
        [self.delegate passwordInputView:self didFinishInputWithPassword:self.passwordText];
    }
}

// MARK: - UIKeyInput
- (void)insertText:(NSString *)text{
    if (self.passwordStrong.length >= self.passwordLength) {
        return;
    }
    
    [self.passwordStrong appendString:text];
    
    [self setNeedsDisplay];
    
    [self callDelegateWhenInputChange];
    
    if (self.passwordStrong.length >= self.passwordLength) {
        [self callDelegateWhenInputFinshed];
    }
}


- (void)deleteBackward{
    if (self.passwordStrong.length <= 0) {
        return;
    }
    
    [self.passwordStrong deleteCharactersInRange:NSMakeRange(self.passwordStrong.length-1, 1)];
    [self setNeedsDisplay];
    [self callDelegateWhenInputChange];
}

- (BOOL)hasText{
    return self.passwordStrong.length;
}

// MARK: - Setter & Getter
- (void)setPasswordColor:(UIColor *)passwordColor{
    _passwordColor = passwordColor;
    [self setNeedsDisplay];
}

- (void)setPasswordImage:(UIImage *)passwordImage{
    _passwordImage = passwordImage;
    [self setNeedsDisplay];
}

- (void)setPasswordWidth:(CGFloat)passwordWidth{
    _passwordWidth = passwordWidth;
    [self setNeedsDisplay];
}

- (void)setPasswordLength:(NSInteger)passwordLength{
    _passwordLength = passwordLength;
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (void)setBorderCornerRadius:(CGFloat)borderCornerRadius{
    _borderCornerRadius = borderCornerRadius;
    [self setNeedsDisplay];
}

- (void)setShowBorder:(BOOL)showBorder{
    _showBorder = showBorder;
    [self setNeedsDisplay];
}

- (void)setPasswordText:(NSString *)passwordText{
    if (passwordText.length > self.passwordLength) {
        self.passwordStrong = [[passwordText substringToIndex:self.passwordLength] mutableCopy];
    }
    else{
        self.passwordStrong = [passwordText mutableCopy];
    }
    [self setNeedsDisplay];
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets{
    _contentInsets = contentInsets;
    [self setNeedsDisplay];
}

- (NSString *)passwordText{
    return [self.passwordStrong copy];
}


// MARK: - create Image
- (UIImage *)createImageWithColor:(UIColor *)color radius:(CGFloat)radius{
    CGSize size = CGSizeMake(radius*2, radius*2);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    [color set];
    [path fill];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
