//
//  MyLocationViewController.m
//  CommunityProject
//
//  Created by bjike on 17/3/24.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyLocationViewController.h"

@interface MyLocationViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField * searchTF;

@end

@implementation MyLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"位置";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateBackButtonWithFrame:CGRectMake(0, 0,50, 40) andTitle:@"返回" andTarget:self Action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self setSearchTextField];
    
}
-(void)setSearchTextField{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(KMainScreenWidth);
        make.height.mas_equalTo(50);
    }];
    [view addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(5);
        make.left.equalTo(view).offset(10);
        make.width.mas_equalTo(KMainScreenWidth-20);
        make.height.mas_equalTo(40);
    }];
    
}
-(void)leftBarButtonItemPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBarButtonItemPressed:(id)sender{
    if (self.isAct) {
        self.actDelegate.area = @"广州天河区棠东";
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [super rightBarButtonItemPressed:sender];
    }
//    if (self.delegate) {
//        [self.delegate locationPicker:self didSelectLocation:[self currentLocationCoordinate2D] locationName:[self currentLocationName] mapScreenShot:[self currentMapScreenShot]];
//    }
}
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTF resignFirstResponder];
    //发起POI搜索
    [self.dataSource setOnPoiSearchResult:^(NSArray *pois, BOOL clearPreviousResult, BOOL hasMore, NSError *error) {
        NSSLog(@"%@==%@",error,pois);
        if (error) {
            NSSLog(@"POI搜索失败：%@",error);
        }else{
            NSSLog(@"%@",pois);
        }
    }];
    return YES;
}
-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [UITextField new];
        _searchTF.delegate = self;
        _searchTF.borderStyle = UITextBorderStyleNone;
        _searchTF.textColor = UIColorFromRGB(0x999999);
        _searchTF.font = [UIFont systemFontOfSize:14];
        _searchTF.backgroundColor = [UIColor whiteColor];
        _searchTF.placeholder = @"搜索具体位置";
        _searchTF.returnKeyType = UIReturnKeySearch;
        UILabel * placeHolderLabel = [self.searchTF valueForKey:@"_placeholderLabel"];
        placeHolderLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _searchTF;
}
@end
