//
//  PersonMoreInfoController.m
//  CommunityProject
//
//  Created by bjike on 17/4/27.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PersonMoreInfoController.h"

#define MoreInfoURL @"appapi/app/selectMoreUserInfo"
@interface PersonMoreInfoController ()

@property (nonatomic,copy)NSString * userId;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *QQTF;
@property (weak, nonatomic) IBOutlet UITextField *chatTF;
@property (weak, nonatomic) IBOutlet UITextField *schoolTF;
@property (weak, nonatomic) IBOutlet UITextField *starTF;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *postTF;
@property (weak, nonatomic) IBOutlet UITextField *bloodTF;
@property (weak, nonatomic) IBOutlet UITextField *marryTF;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQBtn;

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

@property (weak, nonatomic) IBOutlet UIButton *hobbyBtn;
@property (weak, nonatomic) IBOutlet UIButton *schoolBtn;
@property (weak, nonatomic) IBOutlet UIButton *starBtn;
@property (weak, nonatomic) IBOutlet UIButton *bloodBtn;
@property (weak, nonatomic) IBOutlet UIButton *companyBtn;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UIButton *marryBtn;

@property (weak, nonatomic) IBOutlet UIButton *danceBtn;

@property (weak, nonatomic) IBOutlet UIButton *singBtn;
@property (weak, nonatomic) IBOutlet UIButton *printBtn;
@property (weak, nonatomic) IBOutlet UIButton *pianoBtn;

@property (weak, nonatomic) IBOutlet UIButton *sleepBtn;
@property (weak, nonatomic) IBOutlet UIButton *movieBtn;
@property (weak, nonatomic) IBOutlet UIButton *hanBtn;
@property (weak, nonatomic) IBOutlet UIButton *artBtn;
@property (weak, nonatomic) IBOutlet UIButton *eatBtn;

@property (weak, nonatomic) IBOutlet UIButton *bookBtn;
@property (weak, nonatomic) IBOutlet UIButton *mountainBtn;
@property (weak, nonatomic) IBOutlet UILabel *seeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeQQLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeChatLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeHobbyLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeStarLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeBloodLabel;


@property (weak, nonatomic) IBOutlet UILabel *seeCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *seePostLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeSchoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeMarryLabel;



@end

@implementation PersonMoreInfoController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 40, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"取消" andLeft:-15 andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 50, 30) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"保存" andLeft:15 andTarget:self Action:@selector(saveInfo)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.userId = [DEFAULTS objectForKey:@"userId"];
    
}
-(void)getMoreInfo{
    WeakSelf;
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MoreInfoURL] andParams:@{@"userId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取用户信息失败%@",error);
        }else{
        
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                
            }
            
        }
        
    }];

}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)saveInfo{
    
}
@end
