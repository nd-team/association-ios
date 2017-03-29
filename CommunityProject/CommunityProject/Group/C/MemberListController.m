//
//  MemberListController.m
//  CommunityProject
//
//  Created by bjike on 17/3/29.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MemberListController.h"
#import "MemberListCell.h"
#import "MemberListModel.h"

@interface MemberListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation MemberListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"群成员(%ld)",self.collectArr.count];
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self setUI];
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setUI{
    [self.collectionView registerNib:[UINib nibWithNibName:@"MemberListCell" bundle:nil] forCellWithReuseIdentifier:@"MemberListCell"];
    //添加两个多余的 群主和管理员
    if (self.isManager) {
        
    }else{
        //添加一个多余的 成员
  
    }
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MemberListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemberListCell" forIndexPath:indexPath];
    cell.listModel = self.collectArr[indexPath.row];
    return cell;
}

@end
