//
//  CircleMessageController.m
//  CommunityProject
//
//  Created by bjike on 17/4/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CircleMessageController.h"
#import "CircleMessageCell.h"
#import "CircleUnreadMessageModel.h"
#import "CircleCommentController.h"

#define ClearMessageURL @"appapi/app/clearMsg"
#define UnreadURL @"appapi/app/commentNewsList"

@interface CircleMessageController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * messageArr;
@property (nonatomic,copy)NSString * userId;

@end

@implementation CircleMessageController
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x121212);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userId = [DEFAULTS objectForKey:@"userId"];
    UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationItem.title = @"消息";
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) titleColor:UIColorFromRGB(0x121212) font:16 andTitle:@"清空" andLeft:15 andTarget:self Action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self getMessageData];
    
}
-(void)getMessageData{
    for (NSDictionary * dic in self.dataArr) {
        CircleUnreadMessageModel * model = [[CircleUnreadMessageModel alloc]initWithDictionary:dic error:nil];
        [self.messageArr addObject:model];
    }
    [self.tableView reloadData];
}
-(void)rightClick{
    NSDictionary * params = @{@"userId":self.userId};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ClearMessageURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"清空消息失败：%@",error);
        }else{
            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                [weakSelf postUnreadMessage];
            }
        }
        
    }];
 
}
-(void)postUnreadMessage{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,UnreadURL] andParams:@{@"userId":self.userId,@"type":@"2"} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取未读消息失败%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                [weakSelf.messageArr removeAllObjects];
                [weakSelf.tableView reloadData];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        }
        
    }];
}

#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleMessageCell"];
    cell.messageModel = self.messageArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //回复评论
    //进入详情
    CircleUnreadMessageModel * model = self.messageArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"CircleOfFriend" bundle:nil];
    CircleCommentController * comment = [sb instantiateViewControllerWithIdentifier:@"CircleCommentController"];
    comment.idStr = model.articleId;
    comment.commentId = [NSString stringWithFormat:@"%ld",(long)model.id];
    comment.placeStr = [NSString stringWithFormat:@"回复%@",model.nickname];
    comment.isMsg = YES;
    [self.navigationController pushViewController: comment animated:YES];

}
-(NSMutableArray *)messageArr{
    if (!_messageArr) {
        _messageArr = [NSMutableArray new];
    }
    return _messageArr;
}
@end
