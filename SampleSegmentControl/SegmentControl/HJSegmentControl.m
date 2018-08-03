//
//  HJSegmentControl.m
//  SampleSegmentControl
//
//  Created by Hozon on 2018/8/2.
//  Copyright © 2018年 Hozon. All rights reserved.
//

#import "HJSegmentControl.h"

#define kTitleScrollHeight 44.0f
#define kWidth  (self.frame.size.width)
#define kHeight (self.frame.size.height)

@interface HJSegmentControl () <UIScrollViewDelegate>

///标题按钮ScrollView
@property (nonatomic, strong) UIScrollView *titleScrollView;
///展示内容ScrollView
@property (nonatomic, strong) UIScrollView *contentScrollView;
///选中的按钮
@property (nonatomic, strong) UIButton *selectTitleBtn;
///按钮下横线
@property (nonatomic, strong) UIImageView *line;
///存放所有的按钮
@property (nonatomic, strong) NSMutableArray *btnArr;
///当前点击的index
@property (nonatomic, copy) IndexBlock indexBlock;

@end

@implementation HJSegmentControl
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArr contentViews:(NSArray *)contentViewArr clickIndexBlock:(IndexBlock)indexBlock {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        [self addSubview:self.titleScrollView];
        [self addSubview:self.contentScrollView];
        [self configTitleBtn:titleArr];
        [self configContentView:contentViewArr];
        self.indexBlock = indexBlock;
    }
    return self;
}

#pragma mark Method
- (void)configTitleBtn:(NSArray *)titleArr {
    CGFloat titleBtnX = 0;
    for (int i = 0; i<titleArr.count; i++) {
        NSString *title = titleArr[i];
        CGFloat titleBtnWidth = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}].width;
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(titleBtnX, 0, titleBtnWidth+40, kTitleScrollHeight);
        [titleBtn setTitle:title forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.titleNormalColor?:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.titleSelectColor?:[UIColor orangeColor] forState:UIControlStateSelected];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.tag = i+10;
        titleBtnX += titleBtnWidth+40;
        [self.btnArr addObject:titleBtn];
        if (i == 0) {
            _selectTitleBtn = titleBtn;
            titleBtn.selected = YES;
            _selectTitleBtn.transform = CGAffineTransformMakeScale(1.15, 1.15);
            [self lineFrameWith:titleBtn];
        }
        [self.titleScrollView addSubview:self.line];
        [self.titleScrollView addSubview:titleBtn];
    }
    
    self.titleScrollView.contentSize = CGSizeMake(titleBtnX, kTitleScrollHeight);
}

- (void)configContentView:(NSArray *)contentViewArr {
    
    CGFloat ControllerWidth = self.contentScrollView.frame.size.width;
    CGFloat ControllerHeight = self.contentScrollView.frame.size.height;
    self.contentScrollView.contentSize = CGSizeMake(ControllerWidth*contentViewArr.count, ControllerHeight);
    
    for (int i = 0; i<contentViewArr.count; i++) {
        
        UIView *view = contentViewArr[i];
        [view setFrame:CGRectMake(ControllerWidth * i, 0, ControllerWidth, ControllerHeight)];
        [self.contentScrollView addSubview:view];
    }
    
}

- (void)titleBtnClick:(UIButton *)sender {
    if (sender != _selectTitleBtn) {
        sender.selected = YES;
        sender.transform = CGAffineTransformMakeScale(1.15, 1.15);
        _selectTitleBtn.selected = !_selectTitleBtn.selected;
        _selectTitleBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
        _selectTitleBtn = sender;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self lineFrameWith:sender];
    }];
    
    [self setTitleScrollViewContentOffset];
    [self.contentScrollView setContentOffset:CGPointMake(kWidth*(sender.tag-10), 0)];
    self.indexBlock(sender.tag-10);
}

//计算偏移量进行偏移
- (void)setTitleScrollViewContentOffset {
    
    CGFloat selectedWidth = self.selectTitleBtn.frame.size.width;
    CGFloat offsetX = (kWidth - selectedWidth) / 2;
    
    if (self.selectTitleBtn.frame.origin.x <= kWidth / 2) {
        [self.titleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (CGRectGetMaxX(self.selectTitleBtn.frame) >= (self.titleScrollView.contentSize.width - kWidth / 2)) {
        [self.titleScrollView setContentOffset:CGPointMake(self.titleScrollView.contentSize.width - kWidth, 0) animated:YES];
    } else {
        [self.titleScrollView setContentOffset:CGPointMake(CGRectGetMinX(self.selectTitleBtn.frame) - offsetX, 0) animated:YES];
    }

}
- (void)lineFrameWith:(UIButton *)titleBtn {
    self.line.frame = CGRectMake(0, 0, titleBtn.frame.size.width-40, 3);
    CGPoint point = titleBtn.center;
    point.y = titleBtn.center.y + titleBtn.frame.size.height/2 + 3;
    self.line.center = point;
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
    NSInteger page = self.contentScrollView.contentOffset.x/self.contentScrollView.frame.size.width;
    self.selectIndex = page;
    self.indexBlock(page);
    
}

#pragma mark Setter
- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
    _titleNormalColor = titleNormalColor?:[UIColor blackColor];
    for (UIButton *btn in self.btnArr) {
        [btn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
    }
    
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor {
    _titleSelectColor = titleSelectColor?:[UIColor orangeColor];
    for (UIButton *btn in self.btnArr) {
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
    }
    
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    for (UIButton *btn in self.btnArr) {
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [btn setTitleColor:self.titleNormalColor?:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:self.titleSelectColor?:[UIColor orangeColor] forState:UIControlStateSelected];
        if (btn.tag == (selectIndex+10)) {
            btn.selected = YES;
            _selectTitleBtn = btn;
            btn.transform = CGAffineTransformMakeScale(1.15, 1.15);
            [self setTitleScrollViewContentOffset];
            [UIView animateWithDuration:0.3 animations:^{
                [self lineFrameWith:btn];
            }];
        }else {
            btn.selected = NO;
        }
    }
}

#pragma mark LazyInit
- (UIScrollView *)titleScrollView {
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kTitleScrollHeight+10)];
        _titleScrollView.showsVerticalScrollIndicator = NO;
        _titleScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _titleScrollView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTitleScrollHeight+10, kWidth, kHeight-kTitleScrollHeight)];
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        _contentScrollView.delegate = self;
        
    }
    return _contentScrollView;
}

- (UIImageView *)line {
    if (!_line) {
        _line = [[UIImageView alloc] init];
        _line.layer.masksToBounds = YES;
        _line.layer.cornerRadius = 1;
        _line.backgroundColor = [UIColor redColor];
    }
    return _line;
}

- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}
@end
