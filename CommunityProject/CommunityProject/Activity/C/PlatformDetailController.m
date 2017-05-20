//
//  PlatformDetailController.m
//  CommunityProject
//
//  Created by bjike on 17/5/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PlatformDetailController.h"
#import "JoinUserModel.h"
#import "HeadDetailCell.h"
#import "MemberListController.h"

#define PlatformDetailURL @"appapi/app/platformActivesInfo"
#define ZanURL @"appapi/app/userPraise"

@interface PlatformDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;

@property (nonatomic,strong)NSMutableArray * collectArr;

@property (nonatomic,strong)NSString * userId;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;

@end

@implementation PlatformDetailController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userId = [DEFAULTS objectForKey:@"userId"];
    self.oneView.layer.masksToBounds = YES;
    self.oneView.layer.cornerRadius = 2.2;
    self.twoView.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = 2.2;

    [self.signBtn setBackgroundImage:[UIImage imageNamed:@"voteBtn"] forState:UIControlStateNormal];
    [self.signBtn setBackgroundImage:[UIImage imageNamed:@"voteStop"] forState:UIControlStateDisabled];
    [self.signBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [self.signBtn setTitle:@"已报名" forState:UIControlStateDisabled];
    [self.signBtn setTitleColor:UIColorFromRGB(0x444343) forState:UIControlStateNormal];
    [self.signBtn setTitleColor:UIColorFromRGB(0x444343) forState:UIControlStateDisabled];
    [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateSelected];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeadDetailCell" bundle:nil] forCellWithReuseIdentifier:@"PlatformUsersCell"];
    [self getActivityDetailData];
    
}
-(void)getActivityDetailData{
    NSDictionary * params = @{@"userId":self.userId,@"activesId":self.idStr};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,PlatformDetailURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"平台活动数据请求失败：%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                weakSelf.titleLabel.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
                weakSelf.contentLabel.text = [NSString stringWithFormat:@"%@",dict[@"description"]];
                weakSelf.areaLabel.text = [NSString stringWithFormat:@"%@",dict[@"address"]];
                weakSelf.addressLabel.text = [NSString stringWithFormat:@"活动地点：%@",dict[@"address"]];
                [weakSelf.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"activesImage"]]]] placeholderImage:[UIImage imageNamed:@"banner2"]];
                weakSelf.timeLabel.text = [NSString stringWithFormat:@"活动时间：%@至%@",dict[@"startingTime"],dict[@"endTime"]];
                weakSelf.endTimeLabel.text = [NSString stringWithFormat:@"报名截止：%@",dict[@"deadline"]];
                weakSelf.moneyLabel.text = [NSString stringWithFormat:@"人均费用：¥%@/人",dict[@"costMoney"]];
                weakSelf.detailLabel.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
                NSInteger  status = [dict[@"joinStatus"] integerValue];
                if (status == 0) {
                    weakSelf.signBtn.enabled = YES;
                }else{
                    weakSelf.signBtn.enabled = NO;
                }
                weakSelf.peopleCountLabel.text = [NSString stringWithFormat:@"已报名：（%@）",dict[@"joinUsersNumber"]];
                NSArray * users = dict[@"joinUsers"];
                if (users.count != 0) {
                    for (NSDictionary * subDic in users) {
                        JoinUserModel * user = [[JoinUserModel alloc]initWithDictionary:subDic error:nil];
                        [weakSelf.collectArr addObject:user];
                    }
                    [weakSelf.collectionView reloadData];
                }
            }else{
                NSSLog(@"请求平台活动数据失败");
            }
        }
    }];

}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = (KMainScreenWidth-8)/62;
    if (self.collectArr.count<=count) {
        return self.collectArr.count;
    }else{
        return count;
    }
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HeadDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlatformUsersCell" forIndexPath:indexPath];
    cell.userModel = self.collectArr[indexPath.row];
    return cell;
    
}
//转发 分享需要web
- (IBAction)shareClick:(id)sender {
    
}
//点赞
- (IBAction)zanClick:(id)sender {
    self.loveBtn.selected = !self.loveBtn.selected;
    NSDictionary * params = @{@"userId":self.userId,@"articleId":self.idStr,@"type":@"6",@"status":self.loveBtn.selected?@"1":@"0"};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ZanURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"平台点赞失败：%@",error);
            weakSelf.loveBtn.selected = NO;
        }else{
            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                weakSelf.loveBtn.selected = YES;
            }else if ([code intValue] == 100){
                weakSelf.loveBtn.selected = NO;

            }else if ([code intValue] == 101){
                weakSelf.loveBtn.selected = NO;
            }
        }
        
    }];
 
}
//评论
- (IBAction)commentClick:(id)sender {
    
}
//报名
- (IBAction)signUpClick:(id)sender {
    
}
//更多
- (IBAction)morePeopleClick:(id)sender {
    if (self.collectArr.count != 0) {
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
        MemberListController * mem = [sb instantiateViewControllerWithIdentifier:@"MemberListController"];
        mem.collectArr = self.collectArr;
        mem.name = [NSString stringWithFormat:@"已报名(%ld)",(unsigned long)self.collectArr.count];
        [self.navigationController pushViewController:mem animated:YES];
 
    }
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSMutableArray *)collectArr{
    if (!_collectArr) {
        _collectArr = [NSMutableArray new];
    }
    return _collectArr;
}
@end
