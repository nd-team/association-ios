//
//  HobbyController.m
//  CommunityProject
//
//  Created by bjike on 17/4/14.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "HobbyController.h"
#import "HobbyCell.h"
#import "NameViewController.h"

@interface HobbyController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong)NSArray * collectionArr;
//单选
@property (nonatomic,strong)NSIndexPath * selectPath;
@property (nonatomic,copy)NSString * hobbyId;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collHeightCons;

@end

@implementation HobbyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"爱好标签";
    UIButton * rightBtn = [UIButton CreateTitleButtonWithFrame:CGRectMake(0, 0,70, 30) andBackgroundColor:UIColorFromRGB(0xffffff) titleColor:UIColorFromRGB(0x10db9f) font:16 andTitle:@"下一步"];
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    [self.collectionView registerNib:[UINib nibWithNibName:@"HobbyCell" bundle:nil] forCellWithReuseIdentifier:@"HobbyCell"];
    
}
-(void)rightItemClick{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Address" bundle:nil];
    NameViewController * nameVC = [sb instantiateViewControllerWithIdentifier:@"NameViewController"];
    nameVC.name = @"群名称";
    nameVC.titleCount = 6;
    nameVC.placeHolder = @"设置群名称";
    nameVC.isChangeGroupName = NO;
    nameVC.userStr = self.resultStr;
    nameVC.rightStr = @"确认";
    nameVC.hobbyId = self.hobbyId;
    [self.navigationController pushViewController:nameVC animated:YES];
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectionArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HobbyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HobbyCell" forIndexPath:indexPath];
    cell.collectionView = self.collectionView;
    [cell.hobbyBtn setTitle:self.collectionArr[indexPath.row] forState:UIControlStateNormal];
    //实现单选
    WeakSelf;
    cell.block = ^(NSIndexPath * selectPath){
        weakSelf.selectPath = selectPath;
        weakSelf.hobbyId = [NSString stringWithFormat:@"%ld",(unsigned long)selectPath.row+1];
        [weakSelf.collectionView reloadData];
    };
    if (self.selectPath == nil) {
        cell.hobbyBtn.selected = NO;
    } else if (self.selectPath.row == indexPath.row&&self.selectPath.section == indexPath.section) {
        cell.hobbyBtn.selected = YES;
    }else{
        cell.hobbyBtn.selected = NO;
    }
    return cell;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(KMainScreenWidth/4, 52.5);
}
-(NSArray *)collectionArr{
    if (!_collectionArr) {
        _collectionArr = @[@"棋牌",@"游戏",@"数码",@"理财",@"动漫",@"音乐",@"舞蹈",@"书法",@"美术",@"魔术",@"汽车",@"运动",@"美食",@"养生",@"旅游",@"钓鱼",@"天文",@"亲子",@"宠物",@"娱乐",@"小说"];
    }
    return _collectionArr;
}

@end
