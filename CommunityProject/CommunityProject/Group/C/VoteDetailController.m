//
//  VoteDetailController.m
//  LoveChatProject
//
//  Created by bjike on 17/3/8.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "VoteDetailController.h"
#import "VoteTitleCell.h"
#import "HeadDetailCell.h"
#import "JoinUserModel.h"
#import "VoteListModel.h"

#define VoteDetailURL @"appapi/app/voteDetails"
#define VoteURL @"appapi/app/voteCollect"
@interface VoteDetailController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *createUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *singleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (nonatomic,copy)NSString * userID;
@property (nonatomic,strong)NSMutableArray * titleArr;
@property (nonatomic,strong)NSMutableArray * joinArr;
@property (weak, nonatomic) IBOutlet UIView *voteView;
//是否单选
@property (nonatomic,assign)BOOL isSingle;
//暂存投票ID
@property (nonatomic,strong)NSMutableArray * voteIdArr;
//单选
@property (nonatomic,strong)NSString * idStr;
@property (nonatomic,strong)NSIndexPath * selectPath;
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *votePersonCountLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation VoteDetailController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
//    WeakSelf;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,0.001*NSEC_PER_SEC),dispatch_get_main_queue(), ^{
//        [HUDTool showLoadView:[UIApplication sharedApplication].keyWindow withText:@"正在加载..." andHudBlock:^{
            [self getVoteDetailData];
//        }];
//    });
    
}
-(void)setUI{
    self.navigationItem.title = @"群投票";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeadDetailCell" bundle:nil] forCellWithReuseIdentifier:@"HeadDetailCell"];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 20;
    self.userID = [DEFAULTS objectForKey:@"userId"];
    self.startTimeLabel.text = self.createTime;
    self.statusLabel.text = self.statusStr;
    self.titleLabel.text = self.topic;
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.topicUrl]]]];
    self.endTimeLabel.text = [NSString stringWithFormat:@"投票截止时间：%@",self.endTime];
    if ([self.statusStr isEqualToString:@"活动结束"]||self.isVote) {
        self.voteView.hidden = YES;
    }else{
        self.voteView.hidden = NO;
    }
    //投票才可查看已投票人
    if (self.isVote) {
        self.bottomView.hidden = NO;
    }else{
        self.bottomView.hidden = YES;
    }
    self.selectPath = nil;
}
-(void)getVoteDetailData{
    WeakSelf;
    NSDictionary * params = @{@"groupId":self.groupID,@"voteId":self.voteID,@"userId":self.userID};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,VoteDetailURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取投票详情失败%@",error);
        }else{

            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                weakSelf.createUserLabel.text = dict[@"nickname"];
                [weakSelf.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"userPortraitUrl"]]]]];
                NSNumber * mode = dict[@"mode"];
                if ([mode integerValue] == 0) {
                    weakSelf.singleLabel.text = @"单选";
                    weakSelf.isSingle = YES;
                }else if([mode integerValue] == 1){
                    weakSelf.singleLabel.text = @"多选";
                    weakSelf.isSingle = NO;
                }
                if ([dict[@"joinUsers"] isKindOfClass:[NSArray class]]) {
                    NSArray * arr2 = dict[@"joinUsers"];
                    for (NSDictionary * subDic in arr2) {
                        JoinUserModel * join = [[JoinUserModel alloc]initWithDictionary:subDic error:nil];
                        [weakSelf.joinArr addObject:join];
                    }
                    [weakSelf.collectionView reloadData];
                }
                self.votePersonCountLabel.text = [NSString stringWithFormat:@"已投票(%@)",dict[@"joinUsersNumber"]];

                NSArray *arr1 = dict[@"option"];
                for (NSDictionary * dic in arr1) {
                    OptionModel * model = [[OptionModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.titleArr addObject:model];
                }
                [weakSelf.tableView reloadData];
            }
        }
    }];

}

#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoteTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VoteTitleCell"];
    if (self.isVote||[self.statusStr isEqualToString:@"活动结束"]) {
        cell.chooseBtn.enabled = NO;
    }else{
        cell.chooseBtn.enabled = YES;
    }
    cell.optionModel = self.titleArr[indexPath.row];
    cell.tableView = self.tableView;
    cell.dataArr = self.titleArr;
    cell.isSingle = self.isSingle;
    WeakSelf;
    cell.block = ^(NSString * idStr,BOOL isSingle,BOOL isRemove){
        if (isSingle) {
            weakSelf.idStr = idStr;
        }else{
            [weakSelf.voteIdArr addObject:idStr];
            if (isRemove) {
                for (NSString * str  in weakSelf.voteIdArr) {
                    if ([str isEqualToString:idStr]) {
                        [weakSelf.voteIdArr removeObject:str];
                        break;
                    }
                }
            }
        }
    };
    //单选UI
    cell.selectBlock = ^(NSIndexPath * selectPath){
        weakSelf.selectPath = selectPath;
        [weakSelf.tableView reloadData];
    };
    if (self.selectPath == nil) {
        cell.chooseBtn.selected = NO;
    } else if (self.selectPath.row == indexPath.row) {
        cell.chooseBtn.selected = YES;
    }else{
        cell.chooseBtn.selected = NO;
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArr.count;
    
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.joinArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HeadDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeadDetailCell" forIndexPath:indexPath];
    cell.userModel = self.joinArr[indexPath.row];
    return cell;
    
}
- (IBAction)voteClick:(id)sender {
    //多选
    if (self.voteIdArr.count == 0 && !self.isSingle) {
        NSSLog(@"没有选中");
        return;
    }
    //单选
    if (self.idStr == nil && self.isSingle) {
        NSSLog(@"没有选中");
        return;
    }
    NSSLog(@"%@==%@",self.voteIdArr,self.idStr);
    NSMutableDictionary * dics = [NSMutableDictionary new];
    NSDictionary * params = @{@"groupId":self.groupID,@"voteId":self.voteID,@"userId":self.userID};
    [dics setValuesForKeysWithDictionary:params];
    if (self.isSingle) {
        NSArray * arr = @[self.idStr];
        NSData * data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [dics setValue:str forKey:@"voteOption"];
    }else{
        NSData * data = [NSJSONSerialization dataWithJSONObject:self.voteIdArr options:NSJSONWritingPrettyPrinted error:nil];
        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [dics setValue:str forKey:@"voteOption"];
    }
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,VoteURL] andParams:dics returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"投票失败%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                weakSelf.delegate.isRef = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else if ([code intValue] == 0) {
                NSSLog(@"未知失败");
            }else if ([code intValue] == 101) {
                NSSLog(@"投票时间已结束");
            }else if ([code intValue] == 102) {
                NSSLog(@"已投票，请勿重复提交");
            }else if ([code intValue] == 103) {
                NSSLog(@"投票已失效/已关闭");

            }
        }
    }];

}

-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray new];
    }
    return _titleArr;
}
-(NSMutableArray *)joinArr{
    if (!_joinArr) {
        _joinArr = [NSMutableArray new];
    }
    return _joinArr;
}
-(NSMutableArray *)voteIdArr{
    if (!_voteIdArr) {
        _voteIdArr = [NSMutableArray new];
    }
    return _voteIdArr;
}

@end
