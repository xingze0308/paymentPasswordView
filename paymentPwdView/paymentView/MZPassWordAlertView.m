//
//  MZPassWordAlertView.m
//  MZLottery
//
//  Created by xingze on 17/6/29.
//  Copyright © 2017年 mizao. All rights reserved.
//

#import "MZPassWordAlertView.h"
#import "MZPassWordInputView.h"
#import "UIColor+Ex.h"

#define MZColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


@interface  MZPassWordAlertView ()<MZPasswordInputViewDelegate>

@property (nonatomic, assign, readonly) CGFloat screenW;
@property (nonatomic, assign, readonly) CGFloat screenH;
@property (nonatomic, assign, readonly) CGFloat contentW;
@property (nonatomic, assign, readonly) CGFloat contentH;


@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *subTitleStr;
@property (nonatomic, strong) NSString *outputBalanceStr;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIImageView *topLineView;
@property (nonatomic, strong) UILabel *subTitleLB;
@property (nonatomic, strong) UILabel *outputBalanceLB;
@property (nonatomic, strong) UIView  *maskView;
@property (nonatomic, strong) MZPassWordInputView *pwView;

@property (nonatomic, copy) FinishedBlock finish;
@property (nonatomic, copy) CancelBtnOnClickBlock cancel;



@end


@implementation MZPassWordAlertView

static CGFloat const titleLabelTopMargin = 15;
static CGFloat const titleLabelLRMargin  = 20;
static CGFloat const pwInputViewLRMargin = 15;

+ (void)showWithTitle:(NSString *)title subTitle:(NSString *)subTitle money:(NSInteger)outPutBalance finish:(FinishedBlock)finish cancelBtnOnClick:(CancelBtnOnClickBlock)cancel{
    
    MZPassWordAlertView *alertView = [[MZPassWordAlertView alloc] initWithTitle:title subTitleStr:subTitle andOutputBalance:outPutBalance];
    alertView.finish = finish;
    alertView.cancel = cancel;
    [alertView show];
}

- (instancetype)initWithTitle:(NSString *)title subTitleStr:(NSString *)subTitleStr andOutputBalance:(NSInteger)outputBalance{

    self = [super init];
    if (self) {
        self.titleStr = title;
        self.subTitleStr = subTitleStr;
        self.outputBalanceStr = [NSString stringWithFormat:@"￥%.2lf",(float)outputBalance];
        
        self.frame = CGRectMake(0, 0, self.screenW, self.screenH);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAvoiding_keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [self setupCover];
        [self setupContent];
        [self modifyFrame];
    }
    return self;
}





// MARK: - add Views
- (void)setupCover{
    [self addSubview:self.maskView];
}

- (void)setupContent{
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.subTitleLB];
    [self.contentView addSubview:self.outputBalanceLB];
    [self.contentView addSubview:self.pwView];
    
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.6;
        _maskView.frame = self.frame;
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleHeight|
        UIViewAutoresizingFlexibleWidth;
    }
    return _maskView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentW, self.contentH)];
        _contentView.center = self.center;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 3;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}


- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        CGFloat cancelWH = self.titleLB.frame.size.height + titleLabelTopMargin*2 ;
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setFrame:CGRectMake(-5, 0, cancelWH, cancelWH)];
        [_cancelBtn addTarget:self action:@selector(cancelBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    }
    return _cancelBtn;
}



- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.frame = CGRectMake(titleLabelLRMargin, titleLabelTopMargin, self.contentW-titleLabelLRMargin*2, 0);
        _titleLB.numberOfLines = 1;
        _titleLB.textColor = [UIColor colorWithHexString:@"232323"];
        _titleLB.font = [UIFont systemFontOfSize:19];
        _titleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLB;
}

- (UIImageView *)topLineView{
    if (!_topLineView) {
        _topLineView = [self setUpLineView:CGRectMake(0, CGRectGetMaxY(self.titleLB.frame)+titleLabelTopMargin, self.contentW, 0.5) color:[UIColor colorWithHexString:@"e8e8e8"]];
    }
    return _topLineView;
}


- (UILabel *)subTitleLB{
    if (!_subTitleLB) {
        _subTitleLB = [[UILabel alloc] init];
        _subTitleLB.frame = CGRectMake(titleLabelLRMargin, titleLabelTopMargin*2, self.contentW-titleLabelLRMargin*2, 0);
        _subTitleLB.numberOfLines = 1;
        _subTitleLB.textColor = [UIColor colorWithHexString:@"808080"];
        _subTitleLB.font = [UIFont systemFontOfSize:16];
        _subTitleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLB;
}


- (UILabel *)outputBalanceLB{
    if (!_outputBalanceLB) {
        _outputBalanceLB = [[UILabel alloc] init];
        _outputBalanceLB.frame = CGRectMake(titleLabelLRMargin, CGRectGetMaxY(_subTitleLB.frame)+5, self.contentW-titleLabelLRMargin*2, 0);
        _outputBalanceLB.numberOfLines = 1;
        _outputBalanceLB.textColor = [UIColor colorWithHexString:@"232323"];
        _outputBalanceLB.font = [UIFont systemFontOfSize:25];
        _outputBalanceLB.textAlignment = NSTextAlignmentCenter;
    }
    return _outputBalanceLB;
}


- (MZPassWordInputView *)pwView{
    if (!_pwView) {
        CGFloat pwViewWidth = self.contentW - pwInputViewLRMargin*2;
        CGFloat pwViewWH = pwViewWidth/6.0;
        
        MZPassWordInputView *inputView = [[MZPassWordInputView alloc] initWithFrame:CGRectMake(pwInputViewLRMargin, CGRectGetMaxY(self.outputBalanceLB.frame)+15, pwViewWidth, pwViewWH)];
        inputView.delegate = self;
        inputView.backgroundColor = [UIColor whiteColor];
        inputView.passwordLength = 6;
        _pwView = inputView;
        [_pwView becomeFirstResponder];
    }
    return _pwView;
}


- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLB.text = titleStr;
    
    [self.titleLB sizeToFit];
    CGSize size = self.titleLB.frame.size;
    self.titleLB.frame = CGRectMake(titleLabelLRMargin, titleLabelTopMargin, self.contentW-2*titleLabelLRMargin, size.height);
}

- (void)setSubTitleStr:(NSString *)subTitleStr{
    _subTitleStr = subTitleStr;
    
    self.subTitleLB.text = subTitleStr;
    [self.subTitleLB sizeToFit];
    CGSize size = self.subTitleLB.frame.size;
    self.subTitleLB.frame = CGRectMake(titleLabelLRMargin, CGRectGetMaxY(self.titleLB.frame)+titleLabelTopMargin*2, self.contentW-2*titleLabelLRMargin, size.height);
}

- (void)setOutputBalanceStr:(NSString *)outputBalanceStr{
    _outputBalanceStr = outputBalanceStr;
    
    self.outputBalanceLB.text = outputBalanceStr;
    [self.outputBalanceLB sizeToFit];
    CGSize size = self.outputBalanceLB.frame.size;
    self.outputBalanceLB.frame = CGRectMake(titleLabelLRMargin, CGRectGetMaxY(_subTitleLB.frame)+5, self.contentW-2*titleLabelLRMargin, size.height);
}


- (UIImageView *)setUpLineView:(CGRect)rect color:(UIColor *)color{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = [UIColor createImageWithColor:color];
    return imageView;
}


// MARK: - frame

- (void)modifyFrame{
    
    [self setHeight:CGRectGetMaxY(self.pwView.frame)+30 inView:self.contentView];
}


- (CGFloat)contentH{
    return 200;
}

- (CGFloat)contentW{
    return 300;
}

- (CGFloat)screenW{
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)screenH{
    return [UIScreen mainScreen].bounds.size.height;
}

-(void)setHeight:(CGFloat)height inView:(UIView *)view
{
    CGRect changeRect = view.frame;
    changeRect.size.height = height;
    view.frame = changeRect;
}

-(void)setY:(CGFloat)y inView:(UIView *)view
{
    CGRect changeRect = view.frame;
    changeRect.origin.y = y;
    view.frame = changeRect;
}


// MARK: - notification of keyboard

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")
- (void)keyboardAvoiding_keyboardWillShow:(NSNotification *)notification{
    
    CGRect keyboardRect = [self convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect)) {
        return;
    }
    
    CGFloat newY = self.screenH - keyboardRect.size.height - CGRectGetHeight(self.contentView.frame)-50;
    [self setY:newY inView:self.contentView];
    
}


// MARK: - MZPasswordInputViewDelegate
- (void)passwordInputView:(MZPassWordInputView *)inputView willBeginInputWithPassword:(NSString *)password{

}

- (void)passwordInputView:(MZPassWordInputView *)inputView didFinishInputWithPassword:(NSString *)password{
    if (self.finish) {
        self.finish(password);
    }
    
    [inputView resignFirstResponder];
    
    [self dismiss];
}




// MARK: - private method
- (void)show{

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.contentView.alpha = 0.0;
    self.maskView = 0;
    [UIView animateWithDuration:0.34 animations:^{
        self.maskView.alpha = 0.6;
        self.contentView.alpha = 1.0;
    }];
    
}


- (void)dismiss{

    [UIView animateWithDuration:0.25f animations:^{
        self.contentView.alpha = 0;
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}



// MARK: - cancelBtn
- (void)cancelBtnOnClick:(UIButton *)btn{
    if (self.cancel) {
        self.cancel();
    }
    
    [self.pwView resignFirstResponder];
    
    [self dismiss];
}


// MARK: - dealloc

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
