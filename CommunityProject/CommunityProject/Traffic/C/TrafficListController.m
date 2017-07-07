
//
//  TrafficListController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/6.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "TrafficListController.h"
#import <SDCycleScrollView.h>
#import "UIView+ChatMoreView.h"
#import "PlatformMessageController.h"
#import "TrafficeRecomendCell.h"
#import "TafficListCell.h"
#import "TafficeListModel.h"
#import "MyTrafficListController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "SendTrafficController.h"

#define TafficeListURL @"appapi/app/dealBuyList"
#define AdvertiseURL @"appapi/app/selectAdv"
#define SHAREURL @"appapi/app/updateInfo"

@interface TrafficListController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *recommendTableView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)UIView * moreView;
@property (nonatomic,strong)NSMutableArray * recommendArr;
@property (nonatomic,assign)int page;
@property (nonatomic,copy)NSString * userId;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation TrafficListController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.page = 1;
    if (self.isRef) {
        [self getTafficeListData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendBtn.layer.cornerRadius = 30;
    self.sendBtn.layer.masksToBounds = YES;
    self.scrollView.autoScrollTimeInterval = 1;
    self.scrollView.currentPageDotColor = UIColorFromRGB(0xFED604);
    self.scrollView.pageDotColor = UIColorFromRGB(0x243234);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 376;
    self.userId = [DEFAULTS objectForKey:@"userId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TafficListCell" bundle:nil] forCellReuseIdentifier:@"TafficListCell"];
    [self.recommendTableView registerNib:[UINib nibWithNibName:@"TrafficeRecomendCell" bundle:nil] forCellReuseIdentifier:@"TrafficeRecomendCell"];
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
            [weakSelf getAllData];
        });
        
    }
    
}
//网络获取数据
-(void)getAllData{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    WeakSelf;
    dispatch_group_async(group,queue , ^{
        [weakSelf getTafficeListData];
    });
    dispatch_group_async(group,queue , ^{
        //请求广告
        [weakSelf getAdvertiseData];
    });
    
    dispatch_group_notify(group, queue, ^{
        //
        NSSLog(@"请求数据完毕");
        
    });
    
}
-(void)getAdvertiseData{
    WeakSelf;
    NSSLog(@"%@",self.userId);
    NSDictionary * params = @{@"userId":self.userId,@"type":@"5"};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,AdvertiseURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"灵感贩卖数据请求失败：%@",error);
            weakSelf.scrollView.localizationImageNamesGroup = @[@"banner",@"banner2",@"banner3"];
            
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSArray * arr = data[@"data"];
                if (arr.count == 0) {
                    weakSelf.scrollView.localizationImageNamesGroup = @[@"banner",@"banner2",@"banner3"];
                }else{
                    for (NSDictionary * dict in arr) {
                        [weakSelf.recommendArr addObject:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"images"]]]];
                        
                    }
                    weakSelf.scrollView.imageURLStringsGroup = weakSelf.recommendArr;
                }
            }else{
                weakSelf.scrollView.localizationImageNamesGroup = @[@"banner",@"banner2",@"banner3"];
            }
            
            
        }
    }];
}

-(void)getTafficeListData{
    WeakSelf;
    NSSLog(@"%@",self.userId);
    NSDictionary * params = @{@"userId":self.userId,@"page":[NSString stringWithFormat:@"%d",self.page]};
    NSSLog(@"%@",params);
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,TafficeListURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"灵感贩卖：%@",error);
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
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - tableView-delegate and DataSources
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        TafficeListModel * model = self.dataArr[indexPath.row];
        return model.height;
    }
    return 135;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        TafficListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TafficListCell"];
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
    TrafficeRecomendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TrafficeRecomendCell"];
    
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
    if (tableView == self.tableView) {
        return self.dataArr.count;

    }
//    return self.recommendArr.count;
    return 3;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        
    }
}

- (IBAction)moreClick:(id)sender {
    self.moreBtn.selected = !self.moreBtn.selected;
    if (self.moreBtn.selected) {
        WeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf moreViewUI];
        });
    }else{
        self.moreView.hidden = YES;
    }
}

-(void)moreViewUI{
    self.moreView = [UIView claimMessageViewFrame:CGRectMake(KMainScreenWidth-105.5, 0, 95.5, 67) andArray:@[@"消息",@"我的"] andTarget:self andSel:@selector(moreAction:) andTag:155];
    [self.view addSubview:self.moreView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
-(void)moreAction:(UIButton *)btn{
    [self tapClick];
    if (btn.tag == 155) {
        //消息
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
        PlatformMessageController * msg = [sb instantiateViewControllerWithIdentifier:@"PlatformMessageController"];
        msg.type = 5;
        [self.navigationController pushViewController:msg animated:YES];
        
    }else{
        //我的
        UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"TrafficeOfInsporation" bundle:nil];
        MyTrafficListController * my = [sb instantiateViewControllerWithIdentifier:@"MyTrafficListController"];
        my.userId = self.userId;
        [self.navigationController pushViewController:my animated:YES];
        
    }
}
-(void)tapClick{
    self.moreView.hidden = YES;
}


-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(NSMutableArray *)recommendArr{
    if (!_recommendArr) {
        _recommendArr = [NSMutableArray new];
    }
    return _recommendArr;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Traffice"]) {
        SendTrafficController * send = segue.destinationViewController;
        send.delegate = self;
        send.userId = self.userId;
        UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
    }
}
//手势代理方法
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return NO;
    }
    return YES;
}
-(void)showMessage:(NSString *)msg{
    UIView * msgView = [UIView showViewTitle:msg];
    [self.view addSubview:msgView];
    [UIView animateWithDuration:1.0 animations:^{
        msgView.frame = CGRectMake(20, KMainScreenHeight-150, KMainScreenWidth-40, 50);
    } completion:^(BOOL finished) {
        //完成之后3秒消失
        [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            msgView.hidden = YES;
        }];
    }];
    
}
@end
