//
//  SearchCityController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/5.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "SearchCityController.h"
#import "SearchCityCell.h"
#import "LocationAreaCell.h"
#import "BMChineseSort.h"

@interface SearchCityController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * locationArr;

@property (nonatomic,strong) NSMutableArray * hotArr;
@property (nonatomic,strong)AMapLocationManager * locationManager;
//右侧索引
@property (nonatomic,strong)NSMutableArray * sectionArr;
//标记 是否搜索
@property (nonatomic,assign)BOOL isSearch;

@property (nonatomic,strong)NSMutableArray * searchArr;

@property (nonatomic,strong)NSMutableDictionary * dict;

@property (nonatomic,strong)NSMutableArray * cityArr;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchRightCons;

@end

@implementation SearchCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionIndexColor = UIColorFromRGB(0x333333);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 34)];
    UIImageView * leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 18, 20)];
    leftImageView.image = [UIImage imageNamed:@"searchDark.png"];
    [leftView addSubview:leftImageView];
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    self.searchTF.leftView = leftView;
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCityCell" bundle:nil] forCellReuseIdentifier:@"SearchCityCell"];
    [self changeButtonFrame:0 andRight:21];
    [self singleLocation];
    //获取当前城市
    [self getCityData];

}
-(void)changeButtonFrame:(CGFloat)width andRight:(CGFloat)right{
    [UIView animateWithDuration:0.3 animations:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.btnWidthCons.constant = width;
            self.searchRightCons.constant = right;
        });
    }];
}
-(void)singleLocation{
    WeakSelf;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            NSSLog(@"%@",error);
            if (error.code == 4) {
                //失败是否重新回调
                [weakSelf singleLocation];
                return ;
            }
        }
        if (regeocode) {
            [self.locationArr addObject:regeocode.city];
        }
        [weakSelf refreshUI];

    }];
    
    
}
-(void)getCityData{
    //排序
    self.dict = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"]];
    NSMutableArray * mArr = [NSMutableArray new];
    [self.sectionArr addObjectsFromArray:@[@"当前定位城市",@"热门城市"]];
    for (NSArray * arr in [self.dict allValues]) {
        for (NSString * cityName in arr) {
            [mArr addObject:cityName];
        }
    }
    [self.cityArr addObjectsFromArray: [BMChineseSort IndexArray:mArr]];
    [self.sectionArr addObjectsFromArray: self.cityArr];
    [self.dataArr addObjectsFromArray: mArr];
    [self refreshUI];


}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSearch) {
        SearchCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCityCell"];
        cell.areaNameLabel.text = self.searchArr[indexPath.row];
        return cell;
    }else{
        if (indexPath.section == 0) {
            LocationAreaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LocationAreaCell"];
            cell.locationLabel.text = self.locationArr[indexPath.row];
            return cell;
            
        }else{
            SearchCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCityCell"];
            if (indexPath.section == 1) {
                cell.areaNameLabel.text = self.hotArr[indexPath.row];
            }else{
                NSString * key = self.sectionArr[indexPath.section];
                cell.areaNameLabel.text = [[self.dict objectForKey:key]objectAtIndex:indexPath.row];
            }
            return cell;
            
        }
    }
    
}
//每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch) {
        return self.searchArr.count;
    }else{
        if (section == 0) {
            return self.locationArr.count;
        }else if (section == 1){
            return self.hotArr.count;
        }else{
            //返回了所有的数据
            NSString * key = self.sectionArr[section];
            return [self.dict[key] count];
        }  
    }
    
}
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSearch) {
        return 1;
    }
    return self.sectionArr.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isSearch) {
        return nil;
    }else{
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 34)];
        view.backgroundColor = UIColorFromRGB(0xECEEF0);
        UILabel * label = [[UILabel alloc]init];
        if (section != 1) {
            label.frame = CGRectMake(21, 0, 100, 34);
        }else{
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(21, 10, 15, 15)];
            imageView.image = [UIImage imageNamed:@"hotImg.png"];
            [view addSubview:imageView];
            label.frame = CGRectMake(42, 0, 100, 34);
        }
        label.backgroundColor =  UIColorFromRGB(0xECEEF0);
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:15];
        label.text = self.sectionArr[section];
        [view addSubview:label];
        return view;

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isSearch) {
        return 0.001;
    }
    return 34;
}
//右侧的数组
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.isSearch) {
        return nil;
    }
    NSArray * arr = @[@" ",@" "];
    return [arr arrayByAddingObjectsFromArray:self.cityArr];
}
//右侧索引
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (self.isSearch) {
        return 0;
    }
    return index;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSearch) {
        self.delegate.cityStr = self.searchArr[indexPath.row];
    }else{
        if (indexPath.section == 0) {
            self.delegate.cityStr = self.locationArr[indexPath.row];
        }else if (indexPath.section == 1){
            self.delegate.cityStr = self.hotArr[indexPath.row];
        }else{
            NSString * key = self.sectionArr[indexPath.section];
            self.delegate.cityStr = [[self.dict objectForKey:key]objectAtIndex:indexPath.row];
        }
  
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
#pragma mark-发起搜索
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //发起搜索
    self.isSearch = YES;
    [self.searchTF resignFirstResponder];
    [self.searchArr removeAllObjects];
    for (NSString * city in self.dataArr) {
        if ([self.searchTF.text containsString:city]) {
            [self.searchArr addObject:city];
        }
    }
    [self refreshUI];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self changeButtonFrame:61 andRight:0];
    return YES;
}
- (IBAction)cancleSearchClick:(id)sender {
    self.isSearch = NO;
    [self.searchArr removeAllObjects];
    [self changeButtonFrame:0 andRight:21];
    [self refreshUI];

}
-(void)refreshUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(NSMutableArray *)hotArr{
    if (!_hotArr) {
        _hotArr = [NSMutableArray new];
        [_hotArr addObjectsFromArray:@[@"上海",@"北京",@"广州",@"深圳",@"武汉",@"天津",@"西安",@"南京",@"杭州"]];
    }
    return _hotArr;
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray *)locationArr{
    if (!_locationArr) {
        _locationArr = [NSMutableArray new];
    }
    return _locationArr;
}
-(NSMutableArray *)sectionArr{
    if (!_sectionArr) {
        _sectionArr = [NSMutableArray new];
    }
    return _sectionArr;
}
-(NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [NSMutableArray new];
    }
    return _searchArr;
}
-(NSMutableArray *)cityArr{
    if (!_cityArr) {
        _cityArr = [NSMutableArray new];
    }
    return _cityArr;
}
-(AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [AMapLocationManager new];
        _locationManager.delegate = self;
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        //允许后台定位
        //        [_locationManager setAllowsBackgroundLocationUpdates:NO];
        //定位位置显示 设置精度 10米内 需要最多10秒的时间最少2秒
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //定位延时
        _locationManager.locationTimeout = 2;
        //逆地理请求单词的
        _locationManager.reGeocodeTimeout = 2;
        
    }
    return _locationManager;
}
@end
