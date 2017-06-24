//
//  ManagerDownloadController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ManagerDownloadController.h"

@interface ManagerDownloadController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *projessLabel;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@end

@implementation ManagerDownloadController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.topic;
    self.navigationItem.title = @"管理下载";
    //暂停下载的状态
    [self.downBtn setImage:[UIImage imageNamed:@"startLoad"] forState:UIControlStateNormal];
     //下载状态
    [self.downBtn setImage:[UIImage imageNamed:@"stopLoad"] forState:UIControlStateSelected];
    self.downBtn.selected = YES;
    
}

- (IBAction)downloadClick:(id)sender {
    self.downBtn.selected = !self.downBtn.selected;
    if (self.downBtn.selected) {
        //下载中 保存到沙盒
        [self.downloadTask resume];
        self.progressView.progressTintColor = UIColorFromRGB(0x10db9f);
        self.projessLabel.textColor = UIColorFromRGB(0x0fbb88);

    }else{
        //暂停下载
        [self.downloadTask suspend];
        self.progressView.progressTintColor = UIColorFromRGB(0xafafaf);
        self.projessLabel.textColor = UIColorFromRGB(0xc1c1c1);
    }
}


@end
