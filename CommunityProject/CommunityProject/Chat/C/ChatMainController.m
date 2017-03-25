//
//  ChatMainController.m
//  CommunityProject
//
//  Created by bjike on 17/3/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ChatMainController.h"
#import "ChatDetailController.h"
#import "UIView+ChatWhiteView.h"
#import "UIView+ChatMoreView.h"
#import "AddressListController.h"
#import "GroupListController.h"

@interface ChatMainController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)UIView * topView;
@end

@implementation ChatMainController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.topView.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];

}
-(void)setUI{
    //加个表头
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, 2)];
    lineView.backgroundColor = UIColorFromRGB(0xECEEF0);
    self.conversationListTableView.tableHeaderView = lineView;
    //设置需要显示的类型（群组和单聊）
    [self setDisplayConversationTypes:@[@(ConversationType_GROUP),@(ConversationType_PRIVATE)]];
    // 当连接状态变化SDK自动重连时，是否在NavigationBar中显示连接中的提示。
    self.showConnectingStatusOnNavigatorBar = YES;    
    self.cellBackgroundColor = [UIColor whiteColor];
    self.topCellBackgroundColor = UIColorFromRGB(0xf6f6f6);
    self.conversationListTableView.separatorColor = UIColorFromRGB(0xeceef0);
    self.conversationListTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40) andMove:-30 image:@"topMore.png"  and:self Action:@selector(moreClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
//设置为空的时候的视图
    self.emptyConversationView = [UIView createWhiteView:@"你还没有任何聊天记录哟~" andImageName:@"icon.png" andFont:12 andColor:UIColorFromRGB(0x10DB9F)];
//手势隐藏view
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    [self.conversationListTableView addGestureRecognizer:tap];
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf addView];
    });
}
-(void)tapClick{
    self.topView.hidden = YES;
}
-(void)moreClick{
    self.topView.hidden = !self.topView.hidden;
}
-(void)addView{
    self.topView = [UIView createViewFrame:CGRectZero andTarget:self andSel:@selector(buttonClick:)];
    self.topView.hidden = YES;
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(231);
        make.width.mas_equalTo(113);
        make.top.equalTo(self.view).offset(64);
        make.right.equalTo(self.view).offset(-13);
    }];
}
-(void)buttonClick:(UIButton *)btn{
        switch (btn.tag) {
            case 20:
                
                break;
            case 21:
            {
                    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
                    AddressListController * address = [sb instantiateViewControllerWithIdentifier:@"AddressListController"];
                    [self.navigationController pushViewController:address animated:YES];
            }
                break;
            case 22:
                
                break;
            case 23:
                
                break;
            case 24:
                
                break;
            case 25:
            {
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
                GroupListController * list = [sb instantiateViewControllerWithIdentifier:@"GroupListController"];
                [self.navigationController pushViewController:list animated:YES];
            }
                break;
            default:
                
                break;
        }
}
-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    RCConversationCell * concell = (RCConversationCell *)cell;
    concell.conversationTitle.textColor = UIColorFromRGB(0x333333);
    concell.conversationTitle.font = [UIFont systemFontOfSize:16];
    concell.messageContentLabel.textColor = UIColorFromRGB(0x666666);
    concell.messageContentLabel.font = [UIFont systemFontOfSize:12];
    concell.messageCreatedTimeLabel.textColor = UIColorFromRGB(0x666666);
    concell.messageCreatedTimeLabel.font = [UIFont systemFontOfSize:9];
}
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    ChatDetailController * chat = [[ChatDetailController alloc]initWithConversationType:model.conversationType targetId:model.targetId];
    chat.conversationType = model.conversationType;
    chat.targetId = model.targetId;
    //会话人备注
    chat.title = model.conversationTitle;
    [self.navigationController pushViewController:chat animated:YES];

}
//手势代理方法
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
//    if ([touch.view isKindOfClass:[UITableView class]]) {
//        return NO;
//    }
//    if ([touch.view isKindOfClass:[UITableViewCell class]]) {
//        return NO;
//    }
    return YES;
}
@end
