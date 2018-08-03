//
//  HJSegmentControl.h
//  SampleSegmentControl
//
//  Created by Hozon on 2018/8/2.
//  Copyright © 2018年 Hozon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IndexBlock)(NSInteger index);

@interface HJSegmentControl : UIView

///标题正常Color,默认黑色
@property (nonatomic, strong) UIColor *titleNormalColor;
///标题选中Color,默认红色
@property (nonatomic, strong) UIColor *titleSelectColor;
///默认选中的index=1，即第一个
@property (nonatomic,assign) NSInteger selectIndex;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArr contentViews:(NSArray *)contentViewArr clickIndexBlock:(IndexBlock)indexBlock;

@end
