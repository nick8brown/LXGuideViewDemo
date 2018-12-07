//
//  LXGuideViewController.m
//  LXGuideViewDemo
//
//  Created by LX Zeng on 2018/12/7.
//  Copyright © 2018   https://github.com/nick8brown   All rights reserved.
//

#import "LXGuideViewController.h"
#import "TabBarController.h"

#define PAGE 3

@interface LXGuideViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation LXGuideViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化guideView
    [self setupGuideView];
}

#pragma mark - 初始化guideView
- (void)setupGuideView {
    // UIScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.contentSize = CGSizeMake(PAGE*kScreen_WIDTH, 0);
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    // UIImageView
    CGFloat imgViewY = 0;
    CGFloat imgViewW = kScreen_WIDTH;
    CGFloat imgViewH = kScreen_HEIGHT;
    for (int i = 0; i < PAGE; i++) {
        CGFloat imgViewX = i * kScreen_WIDTH;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgViewX, imgViewY, imgViewW, imgViewH)];
        NSString *name = [NSString stringWithFormat:@"walkthrough_%d.jpg", i+1];
        imgView.image = ImageNamed(name);
        [self.scrollView addSubview:imgView];
        
        if (i == PAGE-1) { // 最后一张是否有按钮可点击进入
            // UIButton
            CGFloat btnW = 120;
            CGFloat btnH = 30;
            CGFloat btnX = imgViewX + (kScreen_WIDTH-btnW)*0.5;
            CGFloat btnY = kScreen_HEIGHT - 90;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btn.layer.cornerRadius = 15;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = SYS_White_Color.CGColor;
            [btn setTitle:@"立即进入" forState:UIControlStateNormal];
            [btn setTitleColor:SYS_White_Color forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:btn];
        }
    }

    // UIPageControl
    CGFloat pageControlW = 100;
    CGFloat pageControlH = 30;
    CGFloat pageControlX = (kScreen_WIDTH-pageControlW) * 0.5;
    CGFloat pageControlY = kScreen_HEIGHT - pageControlH;
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH)];
    self.pageControl.numberOfPages = PAGE;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = SYS_White_Color;
    [self.view addSubview:self.pageControl];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.pageControl.currentPage == PAGE-1) {
        TabBarController *tabBarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"TabBarController"];
        [self presentViewController:tabBarVC animated:NO completion:nil];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / kScreen_WIDTH;
}

#pragma mark - 监听按钮点击事件
- (void)btnClick:(UIButton *)sender {
    TabBarController *tabBarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self presentViewController:tabBarVC animated:NO completion:nil];
}

@end
