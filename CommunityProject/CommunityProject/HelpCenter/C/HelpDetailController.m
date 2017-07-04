//
//  HelpDetailController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "HelpDetailController.h"
#import "HelpAnswerListModel.h"
#import "HelpAnswerCell.h"
#import "UILabel+label.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

#define HelpDetailURL @"appapi/app/selectSeekHelpInfo"
#define ZanURL @"appapi/app/userPraise"
#define SHAREURL @"appapi/app/updateInfo"

@interface HelpDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *contributeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//第二组数据
@property (nonatomic,strong)NSMutableArray * dataArr;
//第一组数据
@property (nonatomic,strong)NSMutableArray * bestArr;;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightCons;

@property (weak, nonatomic) IBOutlet UIButton *loveBtn;
@property (nonatomic,copy)NSString * userId;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (nonatomic,copy)NSString * imageUrl;
@property (nonatomic,copy)NSString * likes;
@end

@implementation HelpDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"问题";
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0, 50, 30) titleColor:UIColorFromRGB(0x666666) font:13 andTitle:@"举报" andLeft:15 andTarget:self Action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    
    self.userId = [DEFAULTS objectForKey:@"userId"];
    [self setUI];
}

//举报
-(void)rightClick{
    
}
-(void)setUI{
    self.titleLabel.text = self.titleStr;
    self.timeLabel.text = self.time;
    self.contentLabel.text = self.content;
    self.answerLabel.text = [NSString stringWithFormat:@"回答 %@",self.answerCount];
    self.contributeLabel.text = [NSString stringWithFormat:@"贡献币 %@",self.contributeCount];
    [self.headImageView zy_cornerRadiusRoundingRect];
    [self.loveBtn setImage:[UIImage imageNamed:@"darkHeart"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateSelected];
    self.tableView.estimatedRowHeight = 111;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.imageHeightCons.constant = 0;

    //请求网络
    [self getDetailData];
}
-(void)getDetailData{
    //根据内容计算高度
    CGRect rect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(KMainScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    WeakSelf;
    NSDictionary * params = @{@"seekId":self.iDStr,@"userId":self.userId};
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,HelpDetailURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"求助详情失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯!"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                NSDictionary * dict = data[@"data"];
                self.nameLabel.text = dict[@"nickname"];
                [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"userPortraitUrl"]]]] placeholderImage:[UIImage imageNamed:@"default"]];
                NSInteger isLove = [dict[@"likesStatus"] integerValue];
                if (isLove == 1) {
                    self.loveBtn.selected = YES;
                }else{
                    self.loveBtn.selected = NO;
                }
                self.likes = [NSString stringWithFormat:@"%@",dict[@"likes"]];
                [self.loveBtn setTitle:self.likes forState:UIControlStateNormal];
                [self.shareBtn setTitle:[NSString stringWithFormat:@"%@",dict[@"shareNumber"]] forState:UIControlStateNormal];
                [self.tableView beginUpdates];
                if (![dict[@"file"] isKindOfClass:[NSNull class]]) {
                    self.imageUrl = [NSString stringWithFormat:NetURL,[ImageUrl changeUrl:dict[@"file"]]];
                    [self.topicImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
                    //改变表头高度
                    self.imageHeightCons.constant = 198;
                    self.headerHeightCons.constant = 316+rect.size.height;
            
                }else{
                    self.imageHeightCons.constant = 0;
                    self.headerHeightCons.constant = 108+rect.size.height;
                }
                CGRect frame = self.headView.frame;
                frame.size.height = self.headerHeightCons.constant;
                self.headView.frame = frame;
                self.tableView.tableHeaderView = self.headView;
                [self.headView layoutIfNeeded];
                [self.tableView endUpdates];
                //采纳答案
                NSDictionary * bestDic = dict[@"adopt"];
                HelpAnswerListModel * help = [[HelpAnswerListModel alloc]initWithDictionary:bestDic error:nil];
                [self.bestArr addObject:help];
                NSArray * array = dict[@"answers"];
                for (NSDictionary * subDic in array) {
                    HelpAnswerListModel * help = [[HelpAnswerListModel alloc]initWithDictionary:subDic error:nil];
                    [self.dataArr addObject:help];
                }
            }else{
                [weakSelf showMessage:@"求助详情获取失败！"];
            }
            [self.tableView reloadData];
        }
    }];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpAnswerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HelpAnswerCell"];
    cell.tableView = self.tableView;
    if (indexPath.section == 0) {
        cell.helpModel = self.bestArr[indexPath.row];
        cell.dataArr = self.bestArr;
    }else{
        cell.helpModel = self.dataArr[indexPath.row];
        cell.dataArr = self.dataArr;
    }
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.bestArr.count;
    }else{
        return self.dataArr.count;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HelpAnswerListModel * model = self.bestArr[indexPath.row];
        return model.height;
    }else{
        HelpAnswerListModel * model = self.dataArr[indexPath.row];
        return model.height;
    }
   
}
//分组
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.bestArr.count != 0) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 40)];
        view.backgroundColor = UIColorFromRGB(0xeceef0);
        if (section == 0) {
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12.5, 17, 15)];
            imageView.image = [UIImage imageNamed:@"bestAnswer"];
            [view addSubview:imageView];
            UILabel * label1 = [UILabel initFrame:CGRectMake(33, 0, 100, 40) andTitle:@"最佳回答" andTextColor:UIColorFromRGB(0x121212) andFont:14];
            [view addSubview:label1];
            
        }else{
            UILabel * label2 = [UILabel initFrame:CGRectMake(10, 0, 100, 40) andTitle:@"其他回答" andTextColor:UIColorFromRGB(0x121212) andFont:14];
            [view addSubview:label2];
            
        }
        return view;
    }else{
        if (section == 0) {
            return nil;
        }else{
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 40)];
            view.backgroundColor = UIColorFromRGB(0xeceef0);
            UILabel * label2 = [UILabel initFrame:CGRectMake(10, 0, 100, 40) andTitle:@"最新回答" andTextColor:UIColorFromRGB(0x121212) andFont:14];
            [view addSubview:label2];
            return view;
        }
    }
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//分享
- (IBAction)shareClick:(id)sender {
    [self share];
}
-(void)share{
    //求助中心图片
    NSArray * imageArr = @[self.imageUrl];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.titleLabel.text
                                     images:imageArr
                                        url:[NSURL URLWithString:@""]
                                      title:@"求助中心"
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
                           [weakSelf download:@"4"];
                           
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
-(void)download:(NSString *)type{
    NSDictionary * params = @{@"articleId":self.iDStr,@"type":type,@"status":@"2"};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,SHAREURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        
        if (error) {
            NSSLog(@"分享求助失败：%@",error);
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
//点赞
- (IBAction)loveClick:(id)sender {
    self.loveBtn.selected = !self.loveBtn.selected;
    NSDictionary * params = @{@"userId":self.userId,@"articleId":self.iDStr,@"type":@"8",@"status":self.loveBtn.selected?@"1":@"0"};
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,ZanURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"公益点赞失败：%@",error);
            weakSelf.loveBtn.selected = NO;
            [weakSelf showMessage:@"服务器出错咯"];
        }else{
            
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                if (self.loveBtn.selected) {
                    self.likes = [NSString stringWithFormat:@"%ld",[self.likes integerValue]+1];
                }else{
                    self.likes = [NSString stringWithFormat:@"%ld",[self.likes integerValue]-1];
                }
                [weakSelf.loveBtn setTitle:self.likes forState:UIControlStateNormal];
                
            }else if ([code intValue] == 1029){
                weakSelf.loveBtn.selected = NO;
                [weakSelf showMessage:@"多次点赞失败"];
            }else if ([code intValue] == 1030){
                weakSelf.loveBtn.selected = NO;
                [weakSelf showMessage:@"非朋友点赞失败"];
            }else{
                weakSelf.loveBtn.selected = NO;
                [weakSelf showMessage:@"点赞失败"];
            }
        }
        
    }];
}
//回答问题
- (IBAction)answerClick:(id)sender {
    
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(NSMutableArray *)bestArr{
    if (!_bestArr) {
        _bestArr = [NSMutableArray new];
    }
    return _bestArr;
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
