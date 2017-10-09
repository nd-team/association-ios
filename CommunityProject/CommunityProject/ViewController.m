//
//  ViewController.m
//  搭配时尚
//
//  Created by qf1 on 16/3/2.
//  Copyright © 2016年 gxy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    [self leadNewPage];
    

}
#pragma mark-新手引导页

-(void)leadNewPage{
    
    UIScrollView * leadView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    leadView.contentSize = CGSizeMake(KMainScreenWidth * 3,  KMainScreenHeight);
    
    leadView.pagingEnabled = YES;
    
    leadView.showsHorizontalScrollIndicator = NO;
    
    leadView.tag = 121;
    
    leadView.bounces = NO;
    
    leadView.delegate = self;
    
    NSArray * imageArr = @[@"walkthrough_1",@"walkthrough_2",@"walkthrough_3"];
    
        for (int i = 0; i < 3; i++) {
    
            UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KMainScreenWidth*i, 0, KMainScreenWidth,  self.view.bounds.size.height)];
    
            backImageView.image = [UIImage imageNamed:imageArr[i]];
    
            [leadView addSubview:backImageView];
    
        }

    UIButton * startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(KMainScreenWidth*2+KMainScreenWidth/2-61.5, KMainScreenHeight-70-35, 123, 35);
    [startButton setBackgroundImage:[UIImage imageNamed:@"experience"] forState:UIControlStateNormal];    
    [startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [leadView addSubview:startButton];
    [self.view addSubview:leadView];
    
    [self showPageControl];
    
}
#pragma mark-开启App
-(void)startButtonAction{
    [DEFAULTS setBool:YES forKey:@"isRuning"];
    [DEFAULTS synchronize];
    UIView * view = [self.view viewWithTag:121];
    
    [view removeFromSuperview];
    
    UIPageControl * pageCon = [self.view viewWithTag:120];
    
    [pageCon removeFromSuperview];

    [UIApplication sharedApplication].keyWindow.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
    
    
}
#pragma  mark-初始化pageControl
-(void)showPageControl{
    
    
    UIPageControl * pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, KMainScreenHeight-40, KMainScreenWidth, 20)];
    
    pageControl.numberOfPages = 3;
    
    pageControl.currentPage = 0;
    
    pageControl.tag = 120;
    pageControl.pageIndicatorTintColor = UIColorFromRGB(0xcfeae2);
    pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x1ae2a7);
    [pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:pageControl];
    
}
#pragma mark-pageControl执行方法
-(void)pageControlAction:(UIPageControl *)pageC{
    
    NSLog(@"page:%ld",(long)pageC.currentPage);
    
    UIScrollView * scView = [self.view viewWithTag:121];
    
    [scView setContentOffset:CGPointMake(pageC.currentPage*KMainScreenWidth, 0) animated:YES];
    
    
}
#pragma mark-scrollView代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = scrollView.contentOffset.x/KMainScreenWidth;
    
    UIPageControl * pageCon = [self.view viewWithTag:120];
    
    pageCon.currentPage = page;
    
}


@end
