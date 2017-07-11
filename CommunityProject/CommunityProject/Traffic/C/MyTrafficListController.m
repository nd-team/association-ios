//
//  MyTrafficListController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/6.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyTrafficListController.h"
#import "TafficListCell.h"
#import "TafficeListModel.h"
#import "TrafficDetailController.h"

#define MyListURL @"appapi/app/myDealBuyList"
#define SHAREURL @"appapi/app/updateInfo"

@interface MyTrafficListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)int page;

@end

@implementation MyTrafficListController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的灵感";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    self.page = 1;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 376;
    [self.tableView registerNib:[UINib nibWithNibName:@"TafficListCell" bundle:nil] forCellReuseIdentifier:@"MyTafficListCell"];
    WeakSelf;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getTafficeListData];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getTafficeListData];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
    [self netWork];

}
-(void)netWork{
    NSInteger status = [[RCIMClient sharedRCIMClient]getCurrentNetworkStatus];
    if (status == 0) {
        //无网从本地加载数据
        [self showMessage:@"亲，没有连接网络哦！"];
    }else{
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [weakSelf getTafficeListData];
        });
        
    }
    
}
-(void)getTafficeListData{
    WeakSelf;
    NSDictionary * params = @{@"userId":self.userId,@"page":[NSString stringWithFormat:@"%d",self.page]};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MyListURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"我的灵感贩卖失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            if (weakSelf.tableView.mj_footer.isRefreshing) {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        }else{
            if (!weakSelf.tableView.mj_footer.isRefreshing) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                if (arr.count == 0) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    for (NSDictionary * dic in arr) {
                        TafficeListModel * list = [[TafficeListModel alloc]initWithDictionary:dic error:nil];
                        [weakSelf.dataArr addObject:list];
                    }
                }
            }else{
                [weakSelf showMessage:@"加载灵感贩卖失败，下拉刷新重试！"];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        }
    }];
    
}
#pragma mark - tableView-delegate and DataSources
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TafficeListModel * model = self.dataArr[indexPath.row];
    if (model.height == 0) {
        return 376;
    }
    return model.height;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TafficListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyTafficListCell"];
    cell.listModel = self.dataArr[indexPath.row];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    cell.block = ^(UIViewController *vc) {
        [self.navigationController pushViewController:vc animated:YES];
    };
    WeakSelf;
    cell.share = ^(NSString *imageUrl, NSString *title, NSString *idStr) {
        [weakSelf share:imageUrl andTitle:title andId:idStr];
    };
    return cell;
}
-(void)share:(NSString *)imageUrl andTitle:(NSString *)title andId:(NSString *)idStr{
    //平台活动图片
    NSArray * imageArr = @[imageUrl];
    //平台活动的路径
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:title
                                     images:imageArr
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",idStr]]
                                      title:@"平台活动"
                                       type:SSDKContentTypeAuto];
    //有的平台要客户端分享需要加此方法，例如微博
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetShareFlags:@[@"来自社群联盟平台"]];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    WeakSelf;
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           NSSLog(@"分享成功");
                           [weakSelf download:idStr];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           [weakSelf showMessage:@"分享失败"];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
}
-(void)download:(NSString *)idStr{
    NSDictionary * params = @{@"articleId":idStr,@"type":@"5",@"status":@"2"};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,SHAREURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        
        if (error) {
            NSSLog(@"下载三分钟教学：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                [weakSelf showMessage:@"分享成功"];
                
            }else{
                [weakSelf showMessage:@"分享失败"];
            }
            
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TafficeListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"TrafficeOfInsporation" bundle:nil];
    TrafficDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"TrafficDetailController"];
    detail.isLook = NO;
    detail.isLove = [model.statusLikes boolValue];
    detail.titleStr = model.title;
    detail.content = model.content;
    detail.nickname = model.nickname;
    detail.headUrl = model.userPortraitUrl;
    detail.backUrl = model.image;
    detail.idStr = model.idStr;
    detail.likes = model.likes;
    detail.commentNum = model.commentNumber;
    detail.shareNum = model.shareNumber;
    detail.time = model.time;
    [self.navigationController pushViewController:detail animated:YES];

}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}

@end
