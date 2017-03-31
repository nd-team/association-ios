//
//  ChooseFriendsController.m
//  CommunityProject
//
//  Created by bjike on 17/3/31.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ChooseFriendsController.h"
#import "ChooseCell.h"

//拉人踢人 管理员
#import "MemberListModel.h"
//新建群聊
#import "FriendsListModel.h"
@interface ChooseFriendsController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation ChooseFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.name;
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIButton * rightBtn = [UIButton CreateTitleButtonWithFrame:CGRectMake(0, 0,50, 30) andBackgroundColor:UIColorFromRGB(0xffffff) titleColor:UIColorFromRGB(0x10db9f) font:16 andTitle:@"确定"];
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self setUI];
}
-(void)setUI{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 42, 50)];
    
    UIImageView * leftView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 18, 20)];
    
    leftView.image = [UIImage imageNamed:@"search.png"];
    
    [backView addSubview:leftView];
    
    self.searchTF.leftView = backView;
    
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;

}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemClick{
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseCell"];
    
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}


@end
