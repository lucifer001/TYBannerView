//
//  XBanner.m
//  ProjectX
//
//  Created by PEND_Q on 2019/11/7.
//  Copyright © 2019 轻舔指尖. All rights reserved.
//

#import "TYBannerView.h"
#import "UIImageView+WebCache.h"
#import "TAPageControl.h"
#import "TYGCDTimer.h"
#import "Masonry.h"

#define HCDW CGRectGetWidth([UIScreen mainScreen].bounds) // 屏幕宽
#define HCDH CGRectGetHeight([UIScreen mainScreen].bounds) // 屏幕高

@interface TYBannerView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) TAPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray <UIImageView *>*imgViews;

@property (strong, nonatomic) NSMutableArray *dataAry;

@property (assign, nonatomic) CGFloat currentOffsetX;
@property (assign, nonatomic) NSInteger currentIndex;

@end

static NSString *const BANNER_AUTO_KEY = @"BANNER_AUTO_KEY";

@implementation TYBannerView

+ (void)addRadius:(CGFloat)radius
             view:(UIView *)view
        willHiden:(BOOL)willHiden
{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    view.layer.opaque = !willHiden;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(HCDW * 3, 145);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.backgroundColor = UIColor.whiteColor;
    }
    return _scrollView;
}

- (NSMutableArray <UIImageView *>*)imgViews
{
    if (!_imgViews) {
        _imgViews = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 3; i++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [[self class] addRadius:5 view:imgView willHiden:YES];
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImg)];
            [imgView addGestureRecognizer:touch];
            
            [_imgViews addObject:imgView];
        }
    }
    return _imgViews;
}

- (void)clickImg
{
    self.clickIndexBlock ? self.clickIndexBlock(self.currentIndex) : nil;
}

- (NSMutableArray *)dataAry
{
    if (!_dataAry) {
        _dataAry = [[NSMutableArray alloc] init];
    }
    return _dataAry;
}

- (TAPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[TAPageControl alloc] init];
        _pageControl.dotImage = [UIImage imageNamed:@"page_dot"];
        _pageControl.currentDotImage = [UIImage imageNamed:@"page_current_dot"];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (void)drawRect:(CGRect)rect
{
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self);
    }];

    for (NSInteger i = 0; i < self.imgViews.count; i++) {
        UIImageView *imgView = self.imgViews[i];
        [self.scrollView addSubview:imgView];
        CGFloat imgW = HCDW - 30;
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scrollView).mas_offset(15);
            make.width.mas_offset(imgW);
            make.height.mas_offset(115);
            make.left.mas_equalTo(self.scrollView).mas_offset((i * HCDW) + 15);
        }];
    }
    
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).mas_offset(-20);
    }];
}

- (void)updateWithAry:(NSArray *)ary
{
    if (!ary || ary.count <= 0) {
        return;
    }
    
    if (self.dataAry.count > 0) {
        [self.dataAry removeAllObjects];
    }
    [self.dataAry addObjectsFromArray:ary];
    
    self.pageControl.numberOfPages = self.dataAry.count;
    self.pageControl.hidden = !(self.dataAry.count > 1);
    self.scrollView.scrollEnabled = self.dataAry.count > 1;
    
    self.currentIndex = 0;
    [self scrollIndex];
    
    [TYGCDTimer stopTimer:BANNER_AUTO_KEY];
    if (self.dataAry.count > 1) {
        [self doTimer];
    }
}

- (void)doTimer
{
    [TYGCDTimer scheduledTimer:BANNER_AUTO_KEY start:6 interval:6 repeats:YES async:NO task:^{
        [UIScrollView beginAnimations:@"scrollAnimation" context:nil];
        [UIScrollView setAnimationDuration:0.3];
        self.scrollView.contentOffset = CGPointMake(HCDW * 2, 0);
        [UIScrollView commitAnimations];
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

- (void)scrollIndex
{
    NSInteger maxIndex = self.dataAry.count - 1;
    UIImageView *before = self.imgViews[0];
    [before sd_setImageWithURL:[NSURL URLWithString:self.dataAry[self.currentIndex - 1 >= 0 ? self.currentIndex - 1 : maxIndex]]];
    UIImageView *current = self.imgViews[1];
    [current sd_setImageWithURL:[NSURL URLWithString:self.dataAry[self.currentIndex]]];
    UIImageView *after = self.imgViews[2];
    [after sd_setImageWithURL:[NSURL URLWithString:self.dataAry[self.currentIndex + 1 > maxIndex ? 0 : self.currentIndex + 1]]];
    self.scrollView.contentOffset = CGPointMake(HCDW, 0);
    self.currentOffsetX = HCDW;
    self.pageControl.currentPage = self.currentIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [TYGCDTimer stopTimer:BANNER_AUTO_KEY];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self doTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < self.currentOffsetX) {
        // 往前滑
        --self.currentIndex;
        if (self.currentIndex < 0) {
            self.currentIndex = self.dataAry.count - 1;
        }
        [self scrollIndex];
        
    } else if (scrollView.contentOffset.x > self.currentOffsetX) {
        // 往后滑
        ++self.currentIndex;
        if (self.currentIndex > self.dataAry.count - 1) {
            self.currentIndex = 0;
        }
        [self scrollIndex];
    }
}

- (void)dealloc
{
    [TYGCDTimer stopTimer:BANNER_AUTO_KEY];
    NSLog(@"%s", __func__);
}

@end
