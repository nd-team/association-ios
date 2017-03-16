//
//  FirstController.m
//  CommunityProject
//
//  Created by bjike on 17/3/13.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "FirstController.h"
#import "TravelCell.h"
#import "ClaimCell.h"
#import "ApplicationCenterCell.h"

@interface FirstController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageCon;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *claimTableView;
//认领数据源
@property (nonatomic,strong)NSMutableArray * claimArr;
//旅游数据源
@property (nonatomic,strong)NSMutableArray * dataArr;
//应用中心数据
@property (nonatomic,strong)NSMutableArray * applicationArr;
@end

@implementation FirstController

- (void)viewDidLoad {
    [super viewDidLoad];


}
- (IBAction)moreClick:(id)sender {
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        TravelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelCell"];
        
        return cell;
    }else{
        ClaimCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ClaimCell"];
        
        return cell;
    }
  
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 10;
//        return self.dataArr.count;
    }else{
        return 3;
//        return self.claimArr.count;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.applicationArr.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ApplicationCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationCenterCell" forIndexPath:indexPath];
    
    return cell;
    
}

@end
