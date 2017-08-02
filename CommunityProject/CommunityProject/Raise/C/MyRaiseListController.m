//
//  MyRaiseListController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyRaiseListController.h"
#import "RaiseListCell.h"
#import "RaiseListModel.h"

#define MyRaiseURL @"appapi/app/selectMyProductCollect"
#define SHAREURL @"appapi/app/updateInfo"

@interface MyRaiseListController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segControll;
@property (nonatomic,strong)NSMutableArray * dataArr;

//@property (nonatomic,assign)int page;

@end

@implementation MyRaiseListController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.page = 1;
    self.userId = [DEFAULTS objectForKey:@"userId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RaiseListCell" bundle:nil] forCellReuseIdentifier:@"MyRaiseListCell"];
    WeakSelf;
    self.tableView.mj_footer.hidden = YES;
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        weakSelf.page ++;
//        if (weakSelf.segControll.selectedSegmentIndex == 0) {
//            [weakSelf getSendData:@"1"];
//        }else{
//            [weakSelf getSendData:@"2"];
//        }
//    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
        if (weakSelf.segControll.selectedSegmentIndex == 0) {
            [weakSelf getSendData:@"1"];
        }else{
            [weakSelf getSendData:@"2"];
        }
    }];
//    self.tableView.mj_footer.automaticallyHidden = YES;
    self.segControll.selectedSegmentIndex = 0;
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [weakSelf getSendData:@"1"];
        });
        
    }
    
}
-(void)getSendData:(NSString *)type{
    WeakSelf;
    NSDictionary * params = @{@"userId":self.userId,@"type":type};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,MyRaiseURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"我的求助：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
            if (weakSelf.tableView.mj_header.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            //            if (weakSelf.tableView.mj_footer.isRefreshing) {
            //                [weakSelf.tableView.mj_footer endRefreshing];
            //            }
        }else{
            if (!weakSelf.tableView.mj_footer.isRefreshing) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                //                if (arr.count == 0) {
                //                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                //                }else{
                for (NSDictionary * dic in arr) {
                    RaiseListModel * list = [[RaiseListModel alloc]initWithDictionary:dic error:nil];
                    [weakSelf.dataArr addObject:list];
                }
                //                }
            }else{
                [weakSelf showMessage:@"加载我的干货失败，下拉刷新重试！"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            });
            
        }
    }];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RaiseListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyRaiseListCell"];
    cell.raiseModel = self.dataArr[indexPath.row];
    cell.dataArr = self.dataArr;
    cell.tableView = self.tableView;
    cell.push = ^(UIViewController *vc) {
        [self.navigationController pushViewController:vc animated:YES];
    };
    WeakSelf;
    cell.block = ^(NSString *imageUrl, NSString *title, NSString *idStr) {
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
                                      title:@"众筹"
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
    NSDictionary * params = @{@"articleId":idStr,@"type":@"1",@"status":@"2"};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,SHAREURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        
        if (error) {
            NSSLog(@"分享失败：%@",error);
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
//    UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backItem;
//    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Goods" bundle:nil];
//    GoodsDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailController"];
//    if (self.segControll.selectedSegmentIndex == 0) {
//        GoodsListModel * model = self.dataArr[indexPath.row];
//        detail.isLook = NO;
//        detail.isLove = [model.likesStatus boolValue];
//        detail.titleStr = model.title;
//        detail.content = model.synopsis;
//        detail.nickname = model.nickname;
//        detail.headUrl = model.userPortraitUrl;
//        detail.backUrl = model.image;
//        detail.idStr = model.idStr;
//        detail.likes = model.likes;
//        detail.commentNum = model.commentNumber;
//        detail.shareNum = model.shareNumber;
//        detail.time = model.time;
//    }else{
//        GoodsListModel * model = self.collectionArr[indexPath.row];
//        detail.isLook = NO;
//        detail.isLove = [model.likesStatus boolValue];
//        detail.titleStr = model.title;
//        detail.content = model.synopsis;
//        detail.nickname = model.nickname;
//        detail.headUrl = model.userPortraitUrl;
//        detail.backUrl = model.image;
//        detail.idStr = model.idStr;
//        detail.likes = model.likes;
//        detail.commentNum = model.commentNumber;
//        detail.shareNum = model.shareNumber;
//        detail.time = model.time;
//        
//    }
//    [self.navigationController pushViewController:detail animated:YES];
    
}


- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)segClick:(id)sender {
    [self.dataArr removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    if (self.segControll.selectedSegmentIndex == 0) {
        //我的众筹
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [weakSelf getSendData:@"1"];
        });
        
    }else{
        //支持的
        WeakSelf;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [weakSelf getSendData:@"2"];
        });
    }
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

@end
