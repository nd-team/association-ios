//
//  DiscoverViewController.m
//  CommunityProject
//
//  Created by bjike on 17/4/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "DiscoverViewController.h"
#import "InterestCell.h"
#import "InterestTeamController.h"
#import "InterestModel.h"
#import "AddFriendController.h"
#import "CircleOfListController.h"

#define InterestURL @"appapi/app/hobbyGroupList"
#define UnreadURL @"appapi/app/commentNewsList"

@interface DiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (weak, nonatomic) IBOutlet UILabel *dotLabel;
@property (nonatomic,copy)NSString * userId;
//保存未读消息的数据
@property (nonatomic,strong)NSArray * unreadArr;
@property (nonatomic,copy)NSString * firstHead;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end

@implementation DiscoverViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"InterestCell" bundle:nil] forCellReuseIdentifier:@"InterestCell"];
    self.dotLabel.layer.masksToBounds = YES;
    self.dotLabel.layer.cornerRadius = 3;
    self.dotLabel.hidden = YES;
    self.msgLabel.layer.masksToBounds = YES;
    self.msgLabel.layer.cornerRadius = 10;
    self.msgLabel.hidden = YES;

    self.userId = [DEFAULTS objectForKey:@"userId"];
    //SystemMessage
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(systemMessage) name:@"SystemMessage" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieve) name:@"CircleMessage" object:nil];
    //异步请求两条数据
    [self getAllData];
}
-(void)recieve{
    self.msgLabel.hidden = YES;
}
-(void)systemMessage{
    self.dotLabel.hidden = NO;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CircleMessage" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"SystemMessage" object:nil];

}
//网络获取数据
-(void)getAllData{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    WeakSelf;
    dispatch_group_async(group,queue , ^{
        //请求推荐的兴趣联盟
        [weakSelf getInterestListData:@"1"];
    });
    dispatch_group_async(group,queue , ^{
        //请求未读消息
        [weakSelf postUnreadMessage];
    });

    dispatch_group_notify(group, queue, ^{
        //
        NSSLog(@"请求数据完毕");
        
    });
    
}
#pragma mark-获取数据
-(void)getInterestListData:(NSString *)hobby{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,InterestURL] andParams:@{@"userId":self.userId,@"hobbyId":hobby} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取群组列表失败%@",error);
        }else{
            //保存到数据库里
            if (weakSelf.dataArr.count != 0) {
                //                for (InterestModel * model in weakSelf.rightArr) {
                //
                //                }
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dic in arr) {
                    InterestModel * model = [[InterestModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:model];
                }
                [weakSelf.tableView reloadData];
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
                NSArray * arr = data[@"data"];
                if (arr.count != 0) {
                    weakSelf.unreadArr = data[@"data"];
                    weakSelf.msgLabel.hidden = NO;
                    weakSelf.msgLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)arr.count];
                    int i = 0;
                    for (NSDictionary * dic in arr) {
                        if (i == 0) {
                            weakSelf.firstHead = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dic[@"userPortraitUrl"]]];
                            break;
                        }
                        i++;
                    }
                }else{
                    weakSelf.msgLabel.hidden = YES;
                }
            }
            
        }
        
    }];
}
- (IBAction)friendClick:(id)sender {
    self.dotLabel.hidden = YES;
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"CircleOfFriend" bundle:nil];
    CircleOfListController * list = [sb instantiateViewControllerWithIdentifier:@"CircleOfListController"];
    list.msgArr = self.unreadArr;
    list.firstHead = self.firstHead;
    [self.navigationController pushViewController:list animated:YES];
}
- (IBAction)interestClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"WeChat" bundle:nil];
    InterestTeamController * interest = [sb instantiateViewControllerWithIdentifier:@"InterestTeamController"];
    [self.navigationController pushViewController:interest animated:YES];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InterestCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InterestCell"];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    cell.interestModel = self.dataArr[indexPath.row];
    WeakSelf;
    cell.block = ^(UIViewController *vc){
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InterestModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
    AddFriendController * add = [sb instantiateViewControllerWithIdentifier:@"AddFriendController"];
    add.buttonName = @"申请加群";
    add.groupId = model.groupId;
    [self.navigationController pushViewController:add animated:YES];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
