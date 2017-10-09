//
//  MyLocationViewController.m
//  CommunityProject
//
//  Created by bjike on 17/5/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyLocationViewController.h"
#import "SearchAreaViewController.h"
#import "AreaCell.h"
#import "POIAnnotation.h"

@interface MyLocationViewController ()<UITextFieldDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate,MAMapViewDelegate>
@property (nonatomic,strong)UITextField * searchTF;
@property (nonatomic,strong)AMapSearchAPI * searchAPI;
//发起周边检索
@property (nonatomic,strong)AMapPOIAroundSearchRequest *request;
@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//定位
@property (nonatomic,strong)AMapLocationManager * locationManager;

@property (nonatomic,strong)NSMutableArray * dataArr;
//选择的行
@property (nonatomic,assign)NSInteger lastPath;


@end

@implementation MyLocationViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.tabBarController.tabBar.hidden = YES;
    self.mapView.delegate = self;
    //开始定位 持续定位
    [self.locationManager startUpdatingLocation];

    if (self.area.length != 0 && !self.isCancle) {
        //自己输入的时候停止定位
        [self.locationManager stopUpdatingLocation];
        self.searchTF.text = self.area;
        [self searchAround];
    }
   
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.mapView.delegate = nil;
    //停止定位
    [self.locationManager stopUpdatingLocation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"位置";
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x10db9f);
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateTitleButtonWithFrame:CGRectMake(0, 0,40, 40) titleColor:UIColorFromRGB(0x121212) font:15 andTitle:@"发送" andLeft:5 andTarget:self Action:@selector(rightBarButtonItemPressed:)];
        self.navigationItem.rightBarButtonItem = rightItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"AreaCell" bundle:nil] forCellReuseIdentifier:@"LoactionAreaCell"];
   
    [self setSearchTextField];

    //设置定位小蓝点
    self.mapView.showsUserLocation = YES;
    //设置跟随用户移动
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    //关闭指南针
    self.mapView.showsCompass = NO;
    //关闭比例
    self.mapView.showsScale = NO;
    //设置地图缩放比例 值越大显示范围越小
    [self.mapView setZoomLevel:20 animated:NO];
    MAUserLocationRepresentation * r = [MAUserLocationRepresentation new];
    r.showsAccuracyRing = NO;
    [self.mapView updateUserLocationRepresentation:r];
    //单次定位
//    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//        if (error) {
//            NSSLog(@"%@",error);
//            if (error.code == AMapLocationErrorLocateFailed) {
//                return ;
//            }
//        }
//        if (regeocode) {
//            //定位数据发起周边检索给数据源然后刷新列表
//            [self.mapView setCenterCoordinate:location.coordinate];
//            self.latitute = location.coordinate.latitude;
//            self.longitude = location.coordinate.longitude;
////            NSSLog(@"%@=%@",regeocode.POIName,regeocode.AOIName);
//            if (self.isAct) {
//                self.area = [NSString stringWithFormat:@"%@",regeocode.POIName];
//
//            }else{
//                self.area = [NSString stringWithFormat:@"%@%@%@%@",regeocode.city,regeocode.district,regeocode.street,regeocode.number];
//
//            }
//            //发起周边检索
//            [self searchAround];
//
//        }
//    }];
    
}
-(void)searchAround{
    _request = [AMapPOIAroundSearchRequest new];
    _request.location = [AMapGeoPoint locationWithLatitude:self.latitute longitude:self.longitude];
    //距离排序
    _request.sortrule = 0;
    AMapDistrictSearchRequest * poi = [AMapDistrictSearchRequest new];
    poi.showBusinessArea = YES;
    [self.searchAPI AMapDistrictSearch:poi];
    [self.searchAPI AMapPOIAroundSearch:_request];
    
}
#pragma mark - AMapLocationManagerDelegate

//定位出错
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位出错：%@",error);
}
//定位结果
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    //定位数据发起周边检索给数据源然后刷新列表
    [self.mapView setCenterCoordinate:location.coordinate];
    self.latitute = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
    if (self.isAct) {
        self.area = [NSString stringWithFormat:@"%@",reGeocode.POIName];
        
    }else{
        self.area = [NSString stringWithFormat:@"%@%@%@%@",reGeocode.city,reGeocode.district,reGeocode.street,reGeocode.number];
        
    }
    //发起周边检索
    [self searchAround];
    
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    
    return nil;
}

//周边搜索回调数据
#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0) {
        return;
    }
    //解析数据刷新列表
    if (self.dataArr.count != 0) {
        [self.dataArr removeAllObjects];
    }
    [self.dataArr addObjectsFromArray:response.pois];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        if (self.dataArr.count != 0) {
            //设置默认选择第一行
            NSIndexPath * selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
                [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:selectedPath];
            }
        }

    });
   
    
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
        make.top.equalTo(view).mas_offset(5);
        make.left.equalTo(view).mas_offset(10);
        make.width.mas_equalTo(KMainScreenWidth-20);
        make.height.mas_equalTo(40);
    }];
    
}
-(void)rightBarButtonItemPressed:(id)sender{
    //定位发送消息
    if (!self.isAct) {
        if (self.delegate) {
            //不显示定位小蓝点
            self.mapView.showsUserLocation = NO;
            [self.delegate locationDidSelectLocation:[self currentLocationCoordinate2D] locationName:[self currentLocationName] mapScreenShot:[self currentMapScreenShot]];
    }
    }else{
        //创建活动的地址
        self.actDelegate.area = self.area;
        [self.navigationController popViewControllerAnimated:YES];
    }

}
//坐标
-(CLLocationCoordinate2D)currentLocationCoordinate2D{
    return CLLocationCoordinate2DMake(self.latitute, self.longitude);
}
//截图
-(UIImage *)currentMapScreenShot{
    __block UIImage *screenshotImage = nil;
    __block NSInteger resState = 0;
    [self.mapView takeSnapshotInRect:self.mapView.frame withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
        screenshotImage = resultImage;
        resState = state; // state表示地图此时是否完整，0-不完整，1-完整
    }];
    return screenshotImage;
}
//位置
-(NSString *)currentLocationName{
    CLLocationCoordinate2D location = [self currentLocationCoordinate2D];
    if (self.area.length == 0) {
        return [NSString stringWithFormat:@"经度：%lf 纬度：%lf",location.longitude,location.latitude];
    }else{
        return self.area;
    }
}
//进入搜索界面

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    SearchAreaViewController * search = [sb instantiateViewControllerWithIdentifier:@"SearchAreaViewController"];
    search.delegate = self;
    [self.navigationController pushViewController:search animated:YES];
    return NO;
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AreaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LoactionAreaCell"];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        UIImage *image = [UIImage imageNamed:@"redLocation"];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        imageView.image = image;
        cell.accessoryView = imageView;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }
   
    AMapPOI * poi = self.dataArr[indexPath.row];
//    NSSLog(@"%@==%@",poi.address,poi.name);
    //poi.name店名 poi.address位置
    cell.areaLabel.text = poi.name;
    
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //实现单选
    AreaCell * lastcell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastPath inSection:0]];
    lastcell.accessoryType = UITableViewCellAccessoryNone;
    lastcell.accessoryView = nil;
    self.lastPath = indexPath.row;
    AreaCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    UIImage *image = [UIImage imageNamed:@"redLocation"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    cell.accessoryView = imageView;

    AMapPOI * poi = self.dataArr[indexPath.row];
    if (self.isAct) {
        self.area = [NSString stringWithFormat:@"%@",poi.name];
    }else{
        self.area = [NSString stringWithFormat:@"%@%@%@",poi.city,poi.address,poi.name];
    }
    self.longitude = poi.location.longitude;
    self.latitute = poi.location.latitude;
    //显示选中时候的地图的红色标注
//    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    WeakSelf;
        [self.dataArr enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
            if (poi == obj) {
                /* 将结果以annotation的形式加载到地图上. */
                [weakSelf.mapView addAnnotation:[[POIAnnotation alloc] initWithPOI:obj]];

            }
            
        }];
}

//懒加载
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
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
-(AMapSearchAPI *)searchAPI{
    
    if (!_searchAPI) {
        _searchAPI = [AMapSearchAPI new];
        
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}
//        [_locationManager setLocatingWithReGeocode:YES];  //设置返回逆地理信息 持续定位
-(AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [AMapLocationManager new];
        _locationManager.delegate = self;
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        //允许后台定位
        [_locationManager setAllowsBackgroundLocationUpdates:NO];
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
