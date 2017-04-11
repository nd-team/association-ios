//
//  ActivityDetailController.m
//  LoveChatProject
//
//  Created by bjike on 17/2/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ActivityDetailController.h"
#import "ActiveUsers.h"
#import "ReDetailImageCell.h"
#import "HeadDetailCell.h"

#define ActivityDetailURL @"appapi/app/infoActives"
#define JoinActURL @"appapi/app/joinActives"

@interface ActivityDetailController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
//活动介绍的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smallViewHeightContraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbHeightCons;
@property (weak, nonatomic) IBOutlet UIView *recomView;
@property (weak, nonatomic) IBOutlet UILabel *createPersonLabel;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightCons;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray * collectionArr;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//获取TB的行高
@property (nonatomic,assign)    CGFloat height;

@end

@implementation ActivityDetailController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    [self getJoinActivityPerson];
}
-(void)setUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeadDetailCell" bundle:nil] forCellWithReuseIdentifier:@"SignUpCell"];
    //表头传参
    NSString * encodeUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.headStr]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]];
    self.titleLabel.text = self.titleStr;
    self.timeLabel.text = self.time;
    self.areaLabel.text = self.area;
    self.recommendLabel.text = self.recomend;
    self.recommendLabel.numberOfLines = 1;
    CGSize size = [self.recommendLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [self noSpread:size.height andTbHeight:0];
    [self.upBtn setTitle:@"收起" forState:UIControlStateSelected];
    [self.downBtn setTitle:@"展开" forState:UIControlStateNormal];
    [self.upBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    [self.downBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [self.signUpBtn setBackgroundImage:[UIImage imageNamed:@"already"] forState:UIControlStateDisabled];
    [self.signUpBtn setBackgroundImage:[UIImage imageNamed:@"smallGreen"] forState:UIControlStateNormal];
    [self.signUpBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [self.signUpBtn setTitleColor:UIColorFromRGB(0x444343) forState:UIControlStateNormal];
    [self.signUpBtn setTitleColor:UIColorFromRGB(0x444343) forState:UIControlStateDisabled];
    [self.signUpBtn setTitle:@"已报名" forState:UIControlStateDisabled];
    self.upBtn.hidden = YES;
    //用户是否报名
    if (!self.isSign) {
        self.signUpBtn.enabled = NO;
    }else{
        self.signUpBtn.enabled = YES;
    }
}
-(void)getJoinActivityPerson{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ActivityDetailURL] andParams:@{@"activesId":self.actives_id} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"群活动详情获取失败%@",error);
//            [self showMessage:@"群活动详情获取失败"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                weakSelf.createPersonLabel.text = [NSString stringWithFormat:@"%@", dict[@"publisher"]];
                weakSelf.recommendLabel.text = [NSString stringWithFormat:@"%@",dict[@"activesContent"]];
                NSArray * imageArr = dict[@"activesImages"];
                for (NSString * img in imageArr) {
                    [weakSelf.dataArr addObject:img];
                }
                [weakSelf.tableView reloadData];
                weakSelf.countLabel.text = [NSString stringWithFormat:@"已报名（%@）",dict[@"joinUserNumber"]];
                NSArray * users = dict[@"joinUsers"];
                for (NSDictionary * subDic in users) {
                    ActiveUsers * user = [[ActiveUsers alloc]initWithDictionary:subDic error:nil];
                    [weakSelf.collectionArr addObject:user];
                }
                [weakSelf.collectionView reloadData];
            }
        }
    }];
}
#pragma mark - tableView-delegate and DataSources--图片
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReDetailImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ReDetailImageCell"];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.dataArr[indexPath.row]]]]];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.dataArr[indexPath.row]]]] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {

    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        weakSelf.height = image.size.height+10;
    }];
    return weakSelf.height;

}
#pragma mark - collectionView的代理方法--报名人
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectionArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HeadDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SignUpCell" forIndexPath:indexPath];
    ActiveUsers * model = self.collectionArr[indexPath.row];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,model.avatarImage]]];
    return cell;
    
}
//展开活动介绍
- (IBAction)spreadOutClick:(id)sender {
    self.downBtn.hidden = YES;
    self.upBtn.hidden = NO;
    self.recommendLabel.numberOfLines = 0;
    CGRect rect = [self.recommendLabel.text boundingRectWithSize:CGSizeMake(KMainScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    [self noSpread:rect.size.height andTbHeight:200];
}
//height高度是TB和label的高度
-(void)noSpread:(CGFloat)height andTbHeight:(CGFloat)tbHeight{
    self.smallViewHeightContraints.constant = 100+height+tbHeight;
    self.viewHeightCons.constant = self.smallViewHeightContraints.constant+692;
}
//报名
- (IBAction)signUpClick:(id)sender {
    WeakSelf;
    [MessageAlertView alertViewWithTitle:@"温馨提示" message:@"确定要报名这个活动吗？" buttonTitle:@[@"取消",@"确定"] Action:^(NSInteger indexpath) {
        if (indexpath == 1) {
            [weakSelf signUpPost];
        }else{
            
            NSLog(@"取消");
        }
    } viewController:self];

}
-(void)signUpPost{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * idStr = [user objectForKey:@"userId"];
    NSDictionary * param = @{@"userId":idStr,@"activesId":self.actives_id};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,JoinActURL] andParams:param returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"加入群活动失败%@",error);
//            [weakSelf showMessage:@"加入失败"];
        }else{
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"code"];
            if ([code intValue] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });

//                [weakSelf showMessage:@"报名成功"];
            }else if([code intValue] == 100){
//                [weakSelf showMessage:@"非群内人员加入活动"];
            }else if([code intValue] == 101){
//                [weakSelf showMessage:@"活动未开始"];
            }else if([code intValue] == 102){
//                [weakSelf showMessage:@"活动结束"];
            }else if([code intValue] == 103){
//                [weakSelf showMessage:@"报名人数满了"];
            }else if([code intValue] == 104){
//                [weakSelf showMessage:@"活动已加入"];
            }else{
//                [weakSelf showMessage:@"加入失败"];
            }
        }
    }];

}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(NSMutableArray *)collectionArr{
    if (!_collectionArr) {
        _collectionArr = [NSMutableArray new];
    }
    return _collectionArr;
}
//收起
- (IBAction)downClick:(id)sender {
    self.downBtn.hidden = NO;
    self.upBtn.hidden = YES;
    self.recommendLabel.numberOfLines = 1;
    CGSize size = [self.recommendLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [self noSpread:size.height andTbHeight:0];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)moreClick:(id)sender {
    
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
    
}
@end
