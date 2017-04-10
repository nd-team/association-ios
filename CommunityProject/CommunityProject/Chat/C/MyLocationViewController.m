//
//  MyLocationViewController.m
//  CommunityProject
//
//  Created by bjike on 17/3/24.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyLocationViewController.h"

@interface MyLocationViewController ()

@end

@implementation MyLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"位置";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}
-(void)leftBarButtonItemPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)rightBarButtonItemPressed:(id)sender{
//    if (self.delegate) {
//        [self.delegate locationPicker:self didSelectLocation:[self currentLocationCoordinate2D] locationName:[self currentLocationName] mapScreenShot:[self currentMapScreenShot]];
//    }
//}
//-(CLLocationCoordinate2D)currentLocationCoordinate2D{
//    return [self.dataSource mapViewCenter];
//}
//-(UIImage *)currentMapScreenShot{
//    return [self.dataSource mapViewScreenShot];
//}
//-(NSString *)currentLocationName{
//
////    CLLocationCoordinate2D location = [self currentLocationCoordinate2D];
//    return @"";
////    NSString * longitude = nslocalizastringFromTable
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    //改变选择的view
//    
//}
@end
