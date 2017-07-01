//
//  EducationListController.m
//  CommunityProject
//
//  Created by bjike on 2017/6/19.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "EducationListController.h"
#import "EducationListModel.h"
#import "EducationListCell.h"
#import "PlatformMessageController.h"
#import "UIView+ChatMoreView.h"
#import "MyEducationController.h"
#import "EducationDetailController.h"
#import "SendEducationController.h"
#import "MyLoadListController.h"

#define EducationListURL @"appapi/app/selectVideoList"
@interface EducationListController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)int page;
@property (nonatomic,copy)NSString * userId;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (nonatomic,strong)UIView * moreView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;

@end

@implementation EducationListController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.page = 1;
    if (self.isRef) {
        [self refreshUI];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"EducationListCell" bundle:nil] forCellReuseIdentifier:@"EducationListCell"];
    self.userId = [DEFAULTS objectForKey:@"userId"];
    self.sendBtn.layer.cornerRadius = 30;
    self.sendBtn.layer.masksToBounds = YES;
    WeakSelf;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getEducationListData];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getEducationListData];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
    [self refreshUI];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receive:) name:@"SendEducationOfThree" object:nil];

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)receive:(NSNotification *)nofi{
    NSString * refresh = [nofi object];
    self.isRef = [refresh boolValue];
//    if (self.isRef) {
//        [self refreshUI];
//    }
}
-(void)refreshUI{
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf getEducationListData];
    });
}
-(void)getEducationListData{
    WeakSelf;
    NSDictionary * params = @{@"userId":self.userId,@"page":[NSString stringWithFormat:@"%d",self.page]};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,EducationListURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (error) {
            NSSLog(@"三分钟教学：%@",error);
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
                        EducationListModel * list = [[EducationListModel alloc]initWithDictionary:dic error:nil];
                        [weakSelf.dataArr addObject:list];
                    }
                }
            }else{
                [weakSelf showMessage:@"加载三分钟教学失败，下拉刷新重试！"];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        }
    }];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EducationListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EducationListCell"];
    cell.listModel = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EducationListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Education" bundle:nil];
    EducationDetailController * education = [sb instantiateViewControllerWithIdentifier:@"EducationDetailController"];
    education.userId = self.userId;
    education.firstUrl = model.imageUrl;
    education.videoUrl = model.videoUrl;
    education.nickname = model.nickname;
    education.headUrl = model.userPortraitUrl;
    education.idStr = model.idStr;
    education.topic = model.title;
    education.time = model.time;
    education.content = model.content;
    education.loveNum = model.likes;
    education.commentNum = model.commentNumber;
    education.collNum = model.collectionNumber;
    education.downloadNum = model.downloadNumber;
    education.shareNum = model.shareNumber;
    if (model.likesStatus == 0) {
        education.isLove = NO;
    }else{
        education.isLove = YES;
    }
    if (model.checkCollect == 0) {
        education.isCollect = NO;
    }else{
        education.isCollect = YES;
    }
    [self.navigationController pushViewController:education animated:YES];

}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    self.moreView = [UIView claimMessageViewFrame:CGRectMake(KMainScreenWidth-105.5, 0, 95.5, 101) andArray:@[@"消息",@"我的教学",@"我的下载"] andTarget:self andSel:@selector(moreAction:) andTag:140];
    [self.view addSubview:self.moreView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
-(void)tapClick{
    self.moreView.hidden = YES;
}
-(void)moreAction:(UIButton *)btn{
    [self tapClick];
    if (btn.tag == 140) {
        //消息
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Activity" bundle:nil];
        PlatformMessageController * msg = [sb instantiateViewControllerWithIdentifier:@"PlatformMessageController"];
        msg.type = 9;
        [self.navigationController pushViewController:msg animated:YES];
       
    }else if (btn.tag == 141){
        //我的教学
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Education" bundle:nil];
        MyEducationController * education = [sb instantiateViewControllerWithIdentifier:@"MyEducationController"];
        education.userId = self.userId;
        [self.navigationController pushViewController:education animated:YES];

    }
    else{
        //我的下载
        UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Education" bundle:nil];
        MyLoadListController * load = [sb instantiateViewControllerWithIdentifier:@"MyLoadListController"];
        [self.navigationController pushViewController:load animated:YES];
        
    }
}
//发表教学
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"EducationLine"]) {
        SendEducationController * send = segue.destinationViewController;
        send.userId = self.userId;
        send.delegate = self;
        UIBarButtonItem * backItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;

    }
}
-(void)showMessage:(NSString *)msg{
    UIView * msgView = [UIView showViewTitle:msg];
    [self.view addSubview:msgView];
    [UIView animateWithDuration:1.0 animations:^{
        msgView.frame = CGRectMake(20, KMainScreenHeight-150, KMainScreenWidth-40, 50);
    } completion:^(BOOL finished) {
        //完成之后3秒消失
        [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            msgView.hidden = YES;
        }];
    }];
    
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

@end
