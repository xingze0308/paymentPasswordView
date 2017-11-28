//
//  ViewController.m
//  paymentPwdView
//
//  Created by xingze on 2017/11/28.
//  Copyright © 2017年 mujiang. All rights reserved.
//

#import "ViewController.h"
#import "MZPassWordAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
  
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [MZPassWordAlertView showWithTitle:@"title" subTitle:@"subtitle" money:100 finish:^(NSString *pwStr) {
        NSLog(@"finished");
    } cancelBtnOnClick:^{
        NSLog(@"click cancel");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
