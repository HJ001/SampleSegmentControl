//
//  ViewController.m
//  SampleSegmentControl
//
//  Created by Hozon on 2018/8/2.
//  Copyright © 2018年 Hozon. All rights reserved.
//

#import "ViewController.h"
#import "HJSegmentControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *colorView = @[[UIColor blueColor],[UIColor blackColor],[UIColor redColor],[UIColor orangeColor],[UIColor cyanColor],[UIColor purpleColor]];
    NSMutableArray *viewArr = [NSMutableArray array];
    for (int i =0; i<colorView.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = colorView[i];
        [viewArr addObject:view];
    }
    HJSegmentControl *seg = [[HJSegmentControl alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) titles:@[@"精选",@"世界杯",@"明日之子",@"电影",@"电视剧",@"NBA"] contentViews:viewArr clickIndexBlock:^(NSInteger index) {
        NSLog(@"当前点击了第%ld",index);
    }];
//    seg.titleNormalColor = [UIColor purpleColor];
//    seg.titleSelectColor = [UIColor yellowColor];
    [self.view addSubview:seg];
}

//// 设备支持方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskAll;
//}
//// 默认方向
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight; // 或者其他值 balabala~
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
