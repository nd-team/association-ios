//
//  AddFriendController.m
//  LoveChatProject
//
//  Created by bjike on 17/1/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "AddFriendController.h"
#import "AddFriendCell.h"
#import "SearchFriendModel.h"

#define SearchURL @"http://192.168.0.209:90/appapi/app/addfriends"
@interface AddFriendController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation AddFriendController
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"添加朋友/群组";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 18, 40)];
    self.searchTF.leftView = backView;
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:30 image:@"back.png"  and:self Action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-textField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchData:textField.text];
    [self.searchTF resignFirstResponder];
    return YES;
}

-(void)searchData:(NSString *)phone{
    WeakSelf;
    [AFNetData postDataWithUrl:SearchURL andParams:@{@"userId":phone} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"搜索获取失败%@",error);
//            [weakSelf showMessage:@"获取失败"];
        }else{
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"code"];
            if ([code intValue] == 200) {
                if (weakSelf.dataArr.count != 0) {
                    [weakSelf.dataArr removeAllObjects];
                }
                NSDictionary * msgDic = jsonDic[@"data"];
                SearchFriendModel * search = [[SearchFriendModel alloc]initWithDictionary:msgDic error:nil];
                [weakSelf.dataArr addObject:search];
                [weakSelf.tableView reloadData];
  
            }else if ([code intValue] == 0){
//                [weakSelf showMessage:@"获取失败"];
            }
        }
    }];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendCell"];
    cell.searchModel = self.dataArr[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddDetailController * detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AddDetailController"];
    SearchFriendModel * model = self.dataArr[indexPath.row];
    detail.friendID = model.userId;
    detail.name = model.nickname;
    detail.url = model.userPortraitUrl;
    [self.navigationController pushViewController:detail animated:YES];
}
 */
@end
