//
//  GroupMemberInfoController.m
//  CommunityProject
//
//  Created by bjike on 17/3/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "GroupMemberInfoController.h"
#import "MemberListCell.h"
#import "MemberListModel.h"
#import "GroupMessageController.h"
#import "NameViewController.h"
#import "MemberListController.h"
#import "GroupNoticeViewController.h"
#import "ChatMainController.h"

#define MemberURL @"appapi/app/groupMember"
#define DissolveURL @"appapi/app/dissolutionGroup"

@interface GroupMemberInfoController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *publicNoticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *msgBtn;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthContraints;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConraints;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collHeightContraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smallViewHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *hobbyLabel;
@property (weak, nonatomic) IBOutlet UIButton *hobbyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hobbyHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeightCons;

@end

@implementation GroupMemberInfoController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.groupNameLabel.text = self.groupName;
    self.publicNoticeLabel.text = self.publicNotice;
    self.nicknameLabel.text = self.nickname;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"群信息";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self setUI];
    [self getMemberList];
    
}
-(void)setUI{
    [self.collectionView registerNib:[UINib nibWithNibName:@"MemberListCell" bundle:nil] forCellWithReuseIdentifier:@"MemberListCell"];
    self.groupIdLabel.text = self.groupId;
    [self.topBtn setBackgroundImage:[UIImage imageNamed:@"switchOff.png"] forState:UIControlStateNormal];
    [self.topBtn setBackgroundImage:[UIImage imageNamed:@"switchOn.png"] forState:UIControlStateSelected];
    [self.msgBtn setBackgroundImage:[UIImage imageNamed:@"switchOff.png"] forState:UIControlStateNormal];
    [self.msgBtn setBackgroundImage:[UIImage imageNamed:@"switchOn.png"] forState:UIControlStateSelected];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isGroup) {
            self.hobbyBtn.hidden = YES;
            self.hobbyHeightCons.constant = 0;
            self.lineViewHeightCons.constant = 0;
            
        }else{
            self.hobbyBtn.hidden = NO;
            self.hobbyHeightCons.constant = 50;
            self.lineViewHeightCons.constant = 1;
            [self.hobbyBtn setTitle:self.hobby forState:UIControlStateNormal];
        }
    });
    
    self.userId = [DEFAULTS objectForKey:@"userId"];
    RCConversation * currentConversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_GROUP
                                                                                 targetId:self.groupId];
    self.topBtn.selected = currentConversation.isTop;
    //设置按钮状态
    WeakSelf;
    [[RCIMClient sharedRCIMClient]getConversationNotificationStatus:ConversationType_GROUP targetId:self.groupId success:^(RCConversationNotificationStatus nStatus) {
        //免打扰
        if (nStatus == 0) {
            weakSelf.msgBtn.selected = YES;
        }else{
            //消息提醒
            weakSelf.msgBtn.selected = NO;
        }
    } error:^(RCErrorCode status) {
        NSSLog(@"%ld",(long)status);
    }];
    
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getMemberList{
    WeakSelf;
    NSDictionary * dict = @{@"groupId":self.groupId,@"userId":self.userId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MemberURL] andParams:dict returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取群成员失败%@",error);
            [weakSelf showMessage:@"服务器出问题咯！"];
        }else{
            if (self.dataArr.count !=0) {
                [self.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * array = data[@"data"];
                for (NSDictionary * dic in array) {
                    MemberListModel * member = [[MemberListModel alloc]initWithDictionary:dic error:nil];
                    [self.dataArr addObject:member];
                    RCUserInfo * userInfo = [[RCUserInfo alloc]initWithUserId:member.userId name:member.userName portrait:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:member.userPortraitUrl]]];
                    //刷新群组成员的信息
                    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:member.userId];
                }
            }else{
                [weakSelf showMessage:@"加载群成员失败"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });

        }
    }];
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger shu = KMainScreenWidth/85;
    NSInteger row = self.dataArr.count/shu;
    NSInteger remainder = self.dataArr.count%shu;
    if ((row=3 && remainder==0)||(row<3)) {
        return self.dataArr.count;
    }else{
        return shu*3;
    }
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MemberListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemberListCell" forIndexPath:indexPath];
    cell.listModel = self.dataArr[indexPath.row];
    return cell;
}

//群公告
- (IBAction)publicNoticeClick:(id)sender {
    UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    GroupNoticeViewController * notice = [sb instantiateViewControllerWithIdentifier:@"GroupNoticeViewController"];
    notice.publicNotice = self.publicNotice;
    notice.isHost = NO;
    notice.dif = 3;
    notice.name = @"群公告";
    [self.navigationController pushViewController:notice animated:YES];

}
//群昵称
- (IBAction)ninknameClick:(id)sender {
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
    NameViewController * nameVC = [sb instantiateViewControllerWithIdentifier:@"NameViewController"];
    nameVC.memberDelegate = self;
    nameVC.groupId = self.groupId;
    nameVC.name = @"备注";
    nameVC.titleCount = 2;
    nameVC.placeHolder = @"设置备注";
    nameVC.content = self.nickname;
    nameVC.rightStr = @"保存";
    [self.navigationController pushViewController:nameVC animated:YES];
    
}
//消息免打扰
- (IBAction)messageClick:(id)sender {
    self.msgBtn.selected = !self.msgBtn.selected;
    [self setMessage:self.msgBtn.selected];
}
-(void)setMessage:(BOOL)isBlocked{
    WeakSelf;
    [[RCIMClient sharedRCIMClient]setConversationNotificationStatus:ConversationType_GROUP targetId:self.groupId isBlocked:isBlocked success:^(RCConversationNotificationStatus nStatus) {
        //免打扰
        if (nStatus == 0) {
            weakSelf.msgBtn.selected = YES;
        }else{
            //消息提醒
            weakSelf.msgBtn.selected = NO;
        }
    } error:^(RCErrorCode status) {
        NSSLog(@"状态码：%ld",(long)status);
    }];
}
//置顶聊天
- (IBAction)topClick:(id)sender {
    self.topBtn.selected = !self.topBtn.selected;
    [[RCIMClient sharedRCIMClient]setConversationToTop:ConversationType_GROUP targetId:self.groupId isTop:self.topBtn.selected];
}
//更多成员
- (IBAction)moreMemberClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    MemberListController * mem = [sb instantiateViewControllerWithIdentifier:@"MemberListController"];
    mem.groupId = self.groupId;
    mem.userId = self.userId;
    mem.collectArr = self.dataArr;
    mem.isManager = 0;
    mem.name = [NSString stringWithFormat:@"群成员(%ld)",(unsigned long)self.dataArr.count];
    [self.navigationController pushViewController:mem animated:YES];
}
- (IBAction)exitGroupClick:(id)sender {
    WeakSelf;
    [MessageAlertView alertViewWithTitle:@"确定要退出此群吗？" message:nil buttonTitle:@[@"取消",@"确定"] Action:^(NSInteger indexpath) {
        if (indexpath == 1) {
            [weakSelf dismissGroup];
        }
    } viewController:self];
}
-(void)dismissGroup{
    WeakSelf;
    RCGroup * group = [[RCGroup alloc]initWithGroupId:self.groupId groupName:self.groupName portraitUri:self.headUrl];
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,DissolveURL] andParams:@{@"groupId":self.groupId,@"groupUser":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"退群失败%@",error);
            [weakSelf showMessage:@"服务器出问题咯!"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 100) {
                //删除会话列表
                [[RCIMClient sharedRCIMClient]removeConversation:ConversationType_GROUP targetId:weakSelf.groupId];
                //解散群成功 刷新SDK
                [[RCIM sharedRCIM]refreshGroupInfoCache:group withGroupId:weakSelf.groupId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (UIViewController* vc in self.navigationController.viewControllers) {
                        
                        if ([vc isKindOfClass:[ChatMainController class]]) {
                            
                            [weakSelf.navigationController popToViewController:vc animated:YES];
                        }
                    }
                });
                
            }else{
                [weakSelf showMessage:@"操作失败"];
            }
        }
    }];
}



-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
#pragma mark- 解决scrollView的屏幕适配
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.widthContraints.constant = KMainScreenWidth;
    NSInteger width = self.dataArr.count*70;
    int count = width/KMainScreenWidth;
    NSInteger remainder = width%(NSInteger)KMainScreenWidth;
    //一行coll
    if ((count==0 && remainder !=0)|| (count==1 && remainder==0)) {
        self.collHeightContraints.constant = 85;
        self.smallViewHeightCons.constant = 125;
        self.heightConraints.constant = 712;
    }else if ((count==2 && remainder ==0)|| (count==1 && remainder!=0)) {
        //2行
        self.collHeightContraints.constant = 170;
        self.smallViewHeightCons.constant = 210;
        self.heightConraints.constant = 797;
    }else if((count==3)|| (count==2 && remainder!=0)){
        //3行
        self.collHeightContraints.constant = 255;
        self.smallViewHeightCons.constant = 295;
        self.heightConraints.constant = 882;
    }
    if (self.heightConraints.constant<KMainScreenHeight) {
        self.scrollView.scrollEnabled = NO;
    }else{
        self.scrollView.scrollEnabled = YES;
    }
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
    
}
@end
