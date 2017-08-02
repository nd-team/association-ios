//
//  InterestTeamController.m
//  CommunityProject
//
//  Created by bjike on 17/4/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "InterestTeamController.h"
#import "InterestCell.h"
#import "ChooseInterestCell.h"
#import "InterestModel.h"
#import "AddFriendController.h"
#import "ChooseFriendsController.h"

#define InterestURL @"appapi/app/hobbyGroupList"
@interface InterestTeamController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *chessBtn;
@property (weak, nonatomic) IBOutlet UIButton *gameBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UITableView *leftTbView;
@property (weak, nonatomic) IBOutlet UITableView *rightTbView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidthCons;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet UIView *fiveView;
@property (nonatomic,strong)NSArray * leftArr;
@property (nonatomic,strong)NSMutableArray * rightArr;
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong)UIWindow * window;

@end

@implementation InterestTeamController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.window = [[UIApplication sharedApplication].windows objectAtIndex:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBar];
    [self setUI];
    [self netWork];
}
-(void)netWork{
    NSInteger status = [[RCIMClient sharedRCIMClient]getCurrentNetworkStatus];
    if (status == 0) {
        //无网从本地加载数据
        [self showMessage:@"亲，没有连接网络哦！"];
    }else{
       
        [self common:@"1"];
    }
}
-(void)common:(NSString *)type{
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf getInterestListData:type];
    });
}
-(void)setBar{
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 40, 30) andMove:-30 image:@"createInterest" and:self Action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)setUI{
    self.leftWidthCons.constant = 0;
    [self setButtonUI:self.chessBtn];
    [self setButtonUI:self.gameBtn];
    [self setButtonUI:self.cameraBtn];
    [self setButtonUI:self.moreBtn];
    [self setButtonUI:self.moneyBtn];
    self.chessBtn.selected = YES;
    [self.rightTbView registerNib:[UINib nibWithNibName:@"InterestCell" bundle:nil] forCellReuseIdentifier:@"InterestCell"];
    self.twoView.hidden = YES;
    self.threeView.hidden = YES;
    self.fourView.hidden = YES;
    self.fiveView.hidden = YES;

}
#pragma mark-获取数据
-(void)getInterestListData:(NSString *)hobby{
    WeakSelf;
    NSString * userId = [DEFAULTS objectForKey:@"userId"];
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,InterestURL] andParams:@{@"userId":userId,@"hobbyId":hobby} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"获取兴趣联盟列表失败%@",error);
            [weakSelf showMessage:@"加载兴趣联盟失败"];
        }else{
            //保存到数据库里
            if (weakSelf.rightArr.count != 0) {
                [weakSelf.rightArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                for (NSDictionary * dic in arr) {
                    InterestModel * model = [[InterestModel alloc]initWithDictionary:dic error:nil];
                    //未加入状态
                    if ([model.status isEqualToString:@"0"]) {
                        [weakSelf.rightArr addObject:model];
                    }
                }
                
            }else{
                [weakSelf showMessage:@"加载兴趣联盟失败"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.rightTbView reloadData];

            });
        }

    }];
}
-(void)setButtonUI:(UIButton *)btn{
    [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x10db9f) forState:UIControlStateSelected];
}
//创建兴趣联盟
-(void)rightClick{
    NSInteger  checkVIP = [DEFAULTS integerForKey:@"checkVip"];
    if (checkVIP == 1) {
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
        ChooseFriendsController * choose = [sb instantiateViewControllerWithIdentifier:@"ChooseFriendsController"];
        choose.name = @"添加成员";
        choose.dif = 5;
        choose.rightName = @"下一步";
        [self.navigationController pushViewController:choose animated:YES];
    }else{
        WeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showBackViewUI];
        });
    }
}
-(void)showBackViewUI{
    
    self.backView = [UIView sureViewTitle:@"对不起，您还不是VIP不可新建兴趣组" andTag:60 andTarget:self andAction:@selector(buttonAction:)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideViewAction)];
    
    [self.backView addGestureRecognizer:tap];
    
    [self.window addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-64);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(KMainScreenWidth);
        make.height.mas_equalTo(KMainScreenHeight);
    }];
}
-(void)buttonAction:(UIButton *)btn{
    [self hideViewAction];
}
-(void)hideViewAction{
    self.backView.hidden = YES;
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTbView) {
        ChooseInterestCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseInterestCell"];
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.nameLabel.text = self.leftArr[indexPath.row];
        return cell;
    }else{
        
        InterestCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InterestCell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.tableView = self.rightTbView;
        cell.dataArr = self.rightArr;
        cell.interestModel = self.rightArr[indexPath.row];
        WeakSelf;
        cell.block = ^(UIViewController *vc){
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTbView) {
        return self.leftArr.count;
    }
    return self.rightArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTbView) {
        [self common:[NSString stringWithFormat:@"%ld",(long)indexPath.row+5]];
    }else{
        InterestModel * model = self.rightArr[indexPath.row];
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
        AddFriendController * add = [sb instantiateViewControllerWithIdentifier:@"AddFriendController"];
        add.buttonName = @"申请加群";
        add.groupId = model.groupId;
        [self.navigationController pushViewController:add animated:YES];
  
    }
}
- (IBAction)chessClick:(id)sender {
    self.chessBtn.selected = YES;
    self.gameBtn.selected = NO;
    self.cameraBtn.selected = NO;
    self.moneyBtn.selected = NO;
    self.moreBtn.selected = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.oneView.hidden = NO;
        self.twoView.hidden = YES;
        self.threeView.hidden = YES;
        self.fourView.hidden = YES;
        self.fiveView.hidden = YES;
        [UIView animateWithDuration:2 animations:^{
            self.leftWidthCons.constant = 0;
        }];
    });
    [self common:@"1"];

}
- (IBAction)gameClick:(id)sender {
    self.chessBtn.selected = NO;
    self.gameBtn.selected = YES;
    self.cameraBtn.selected = NO;
    self.moneyBtn.selected = NO;
    self.moreBtn.selected = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.oneView.hidden = YES;
        self.twoView.hidden = NO;
        self.threeView.hidden = YES;
        self.fourView.hidden = YES;
        self.fiveView.hidden = YES;
        [UIView animateWithDuration:2 animations:^{
            self.leftWidthCons.constant = 0;
        }];
    });
    [self common:@"2"];

    
}
- (IBAction)cameraClick:(id)sender {
    self.chessBtn.selected = NO;
    self.gameBtn.selected = NO;
    self.cameraBtn.selected = YES;
    self.moneyBtn.selected = NO;
    self.moreBtn.selected = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.oneView.hidden = YES;
        self.twoView.hidden = YES;
        self.threeView.hidden = NO;
        self.fourView.hidden = YES;
        self.fiveView.hidden = YES;
        [UIView animateWithDuration:2 animations:^{
            self.leftWidthCons.constant = 0;
        }];
    });
    
    [self common:@"3"];

    
}
- (IBAction)moneyClick:(id)sender {
    self.chessBtn.selected = NO;
    self.gameBtn.selected = NO;
    self.cameraBtn.selected = NO;
    self.moneyBtn.selected = YES;
    self.moreBtn.selected = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.oneView.hidden = YES;
        self.twoView.hidden = YES;
        self.threeView.hidden = YES;
        self.fourView.hidden = NO;
        self.fiveView.hidden = YES;
        [UIView animateWithDuration:2 animations:^{
            self.leftWidthCons.constant = 0;
        }];
    });
    [self common:@"4"];

    
}
- (IBAction)moreClick:(id)sender {
    self.chessBtn.selected = NO;
    self.gameBtn.selected = NO;
    self.cameraBtn.selected = NO;
    self.moneyBtn.selected = NO;
    self.moreBtn.selected = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.oneView.hidden = YES;
        self.twoView.hidden = YES;
        self.threeView.hidden = YES;
        self.fourView.hidden = YES;
        self.fiveView.hidden = NO;
        //设置左侧tableview默认选择第一行==动画展示
        [UIView animateWithDuration:2 animations:^{
            self.leftWidthCons.constant = 70;
        }];
    });
    
    NSIndexPath * selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.leftTbView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    if ([self.leftTbView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.leftTbView.delegate tableView:self.leftTbView didSelectRowAtIndexPath:selectedPath];
    }

}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}

-(NSArray *)leftArr{
    if (!_leftArr) {
        _leftArr = @[@"动漫",@"音乐",@"舞蹈",@"书法",@"美术",@"魔术",@"汽车",@"运动",@"美食",@"养生",@"旅游",@"钓鱼",@"天文",@"亲子",@"宠物",@"娱乐",@"小说"];
    }
    return _leftArr;
}
-(NSMutableArray *)rightArr{
    if (!_rightArr) {
        _rightArr = [NSMutableArray new];
    }
    return _rightArr;
}
@end
