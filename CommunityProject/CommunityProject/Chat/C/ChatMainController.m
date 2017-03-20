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

@interface ChatMainController ()
@property (nonatomic,strong)UIView * topView;
@end

@implementation ChatMainController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];

}
-(void)setUI{
    //设置需要显示的类型（群组和单聊）
    [self setDisplayConversationTypes:@[@(ConversationType_GROUP),@(ConversationType_PRIVATE)]];
    // 当连接状态变化SDK自动重连时，是否在NavigationBar中显示连接中的提示。
    self.showConnectingStatusOnNavigatorBar = YES;
    self.cellBackgroundColor = [UIColor whiteColor];
    self.topCellBackgroundColor = UIColorFromRGB(0xf6f6f6);
    self.conversationListTableView.separatorColor = UIColorFromRGB(0xeceef0);
    self.conversationListTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.conversationListTableView.rowHeight = 86.5;
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40) image:@".png"  and:self Action:@selector(moreClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
//设置为空的时候的视图
    self.emptyConversationView = [UIView createWhiteView:@"你还没有任何聊天记录哟~" andImageName:@"icon.png" andFont:12 andColor:UIColorFromRGB(0xeceef0)];

}
-(void)moreClick{
    WeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf addView];
    });
}
-(void)addView{
    self.topView = [UIView createViewFrame:CGRectMake(KMainScreenWidth-113-13, 0, 113, 200) andTarget:self andSel:@selector(buttonClick:)];
    [self.view addSubview:self.topView];
}
-(void)buttonClick:(UIButton *)btn{
        switch (btn.tag) {
            case 20:
                
                break;
            case 21:
                
                break;
            case 22:
                
                break;
            case 23:
                
                break;
            case 24:
                
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
    UIImageView * imageView = (UIImageView *)concell.headerImageView;
    imageView.frame = CGRectMake(13.5, 12.5, 61.5, 61.5);
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
}
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    ChatDetailController * chat = [[ChatDetailController alloc]initWithConversationType:model.conversationType targetId:model.targetId];
    chat.conversationType = model.conversationType;
    chat.targetId = model.targetId;
    //会话人备注
    chat.title = model.conversationTitle;
    [self.navigationController pushViewController:chat animated:YES];

}
@end
