
//
//  SendEducationController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SendEducationController.h"
#import "AuthorityController.h"
#import "EducationDetailController.h"

#define SendURL @"appapi/app/releaseVideo"

@interface SendEducationController ()

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property (weak, nonatomic) IBOutlet UITextField *titleTF;

@property (weak, nonatomic) IBOutlet UITextView *contentTF;
@property (weak, nonatomic) IBOutlet UILabel *isPublicLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;

@end

@implementation SendEducationController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (self.authStr.length != 0) {
        self.isPublicLabel.text = self.authStr;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10DB9F);

}
//解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
}
//发布
- (IBAction)sendClick:(id)sender {
    
}
//预览
- (IBAction)lookClick:(id)sender {
    /*
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Education" bundle:nil];
    EducationDetailController * education = [sb instantiateViewControllerWithIdentifier:@"EducationDetailController"];
    education.userId = self.userId;
    education.firstUrl = model.imageUrl;
    education.videoUrl = model.videoUrl;
    education.nickname = model.nickname;
    education.headUrl = model.userPortraitUrl;
    education.idStr = model.idStr;
    education.topic = model.title;
    education.time = model.time;
    education.content = model.content;
    education.loveNum = model.likes;
    education.commentNum = model.commentNumber;
    education.collNum = model.collectionNumber;
    education.downloadNum = model.downloadNumber;
    education.shareNum = model.shareNumber;
    if (model.likesStatus == 0) {
        education.isLove = NO;
    }else{
        education.isLove = YES;
    }
    if (model.checkCollect == 0) {
        education.isCollect = NO;
    }else{
        education.isCollect = YES;
    }
    education.isLook = YES;
    [self.navigationController pushViewController:education animated:YES];
 */
}


- (IBAction)authClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"CircleOfFriend" bundle:nil];
    AuthorityController * auth = [sb instantiateViewControllerWithIdentifier:@"AuthorityController"];
    auth.sendDelegate = self;
    auth.type = 2;
    [self.navigationController pushViewController:auth animated:YES];

}

@end
