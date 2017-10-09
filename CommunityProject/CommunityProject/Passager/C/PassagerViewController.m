//
//  PassagerViewController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/15.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PassagerViewController.h"
#import "PassagerAreaCell.h"
#import "CarLocationCustomView.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"
#import "MyCarCommentsController.h"
#import "PassagerRoadController.h"

#define CarListURL @"appapi/app/aroundCar"
#define LocationURL @"appapi/app/positionInput"

static const NSString *RoutePlanningViewControllerStartTitle       = @"起";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终";
static const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface PassagerViewController ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate,AMapSearchDelegate,MAMapViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *startAreaTF;
@property (weak, nonatomic) IBOutlet UITextField *endAreaTF;
@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *narBarView;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)AMapSearchAPI * searchAPI;
//发起周边检索，使用经纬度发起的检索
@property (nonatomic,strong)AMapPOIAroundSearchRequest *request;
//输入提示发起检索
@property (nonatomic,strong)AMapInputTipsSearchRequest * tips;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//定位
@property (nonatomic,strong)AMapLocationManager * locationManager;

@property (nonatomic,strong)AMapDrivingRouteSearchRequest * searchRequest;
//路线
@property (nonatomic, strong) AMapRoute *route;
/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

//@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
//@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;
//发起搜索的经纬度
@property (nonatomic,assign)CGFloat longutide;
@property (nonatomic,assign)CGFloat latidute;
@property (nonatomic,strong)UIView * moreView;
//是否是提示搜索
@property (nonatomic,assign)BOOL isTips;
//区分起点终点
@property (nonatomic,assign)BOOL isStart;

@property (weak, nonatomic) IBOutlet UIButton *callCarBtn;

@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *moneyView;
//记录起点终点经纬度
@property (nonatomic,assign)CLLocationCoordinate2D startCoordinate;
@property (nonatomic,assign)CLLocationCoordinate2D endCoordinate;
//用户起点位置
@property (nonatomic,copy)NSString * area;

@property (nonatomic,copy)NSString * userId;

@end

@implementation PassagerViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.tabBarController.tabBar.hidden = YES;
    self.mapView.delegate = self;
    //开始定位 持续定位
    [self.locationManager startUpdatingLocation];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.mapView.delegate = nil;
    //停止定位
    [self.locationManager stopUpdatingLocation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 44)];
    leftView.backgroundColor = UIColorFromRGB(0xeceef0);
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    self.searchTF.leftView = leftView;
    self.searchTF.layer.cornerRadius = 2.5;
    self.searchTF.layer.masksToBounds = YES;
    self.searchView.hidden = YES;
    self.tableView.hidden = YES;
    self.callCarBtn.hidden = YES;
    self.moneyView.hidden = YES;
    self.userId = [DEFAULTS objectForKey:@"userId"];
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
    r.image = [UIImage imageNamed:@"locationGreen.png"];

    [self.mapView updateUserLocationRepresentation:r];
}
//根据经纬度发起的检索
-(void)searchAround:(CGFloat)latitude andLongitude:(CGFloat)longitude{
    _request = [AMapPOIAroundSearchRequest new];
    _request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    //距离排序
    _request.sortrule = 0;
    AMapDistrictSearchRequest * poi = [AMapDistrictSearchRequest new];
    poi.showBusinessArea = YES;
    [self.searchAPI AMapDistrictSearch:poi];
    [self.searchAPI AMapPOIAroundSearch:_request];
    
}
#pragma mark - texyFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.searchTF) {
        self.isTips = YES;
        //根据提示发起检索
        [self searchTipsWithKey:textField.text];

    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.startAreaTF || textField == self.endAreaTF) {
        self.isTips = NO;
        [self hiddenView:NO];
        if (textField == self.startAreaTF) {
            self.isStart = YES;
            //起点发起定位的周边检索
            [self searchAround:self.latidute andLongitude:self.longutide];

        }else{
            //终点好像是最火的位置
            self.isStart = NO;
            
        }
       

        return NO;
    }else{
        self.isTips = YES;
        return YES;
    }
}
-(void)hiddenView:(BOOL)isHidden{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.searchView.hidden = isHidden;
        self.narBarView.hidden = !isHidden;
        if (self.narBarView.hidden) {
            [self.searchTF becomeFirstResponder];
            self.moreView.hidden = YES;
        }else{
            [self.searchTF resignFirstResponder];

        }
        self.tableView.hidden = isHidden;
    });
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
    [self.locationBtn setTitle:reGeocode.city forState:UIControlStateNormal];
    self.startAreaTF.text = reGeocode.street;
    self.longutide = location.coordinate.longitude;
    self.latidute = location.coordinate.latitude;
    self.startCoordinate = location.coordinate;
    self.area = [NSString stringWithFormat:@"%@%@%@%@",reGeocode.city,reGeocode.district,reGeocode.street,reGeocode.POIName];
//    NSSLog(@"兴趣点名称：%@",reGeocode.POIName);
    
}
#pragma mark - MAMapViewDelegate
//自定义标注图标
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"carCustomIndetifier";
        CarLocationCustomView *annotationView = (CarLocationCustomView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CarLocationCustomView alloc] initWithAnnotation:annotation
                                                               reuseIdentifier:reuseIndetifier];
            annotationView.centerOffset = CGPointMake(0, 0);
        }
        annotationView.name = @"从这里出发";
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            //            switch (((MANaviAnnotation*)annotation).type)
            //            {
            //                case MANaviAnnotationTypeBus:
            //                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
            //                    break;
            //
            //                case MANaviAnnotationTypeDrive:
            //                    poiAnnotationView.image = [UIImage imageNamed:@"car1"];
            //                    break;
            //
            //                case MANaviAnnotationTypeWalking:
            //                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
            //                    break;
            //
            //                default:
            //                    break;
            //            }
        }
        else
        {
            NSSLog(@"%@",[annotation title]);
            /* 起点. */
            if ([[annotation title] containsString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                annotationView.image = [UIImage imageNamed:@"startAddress.png"];
            }
            /* 终点. */
            else if([[annotation title] containsString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                annotationView.image = [UIImage imageNamed:@"endAddress.png"];
            }
            
        }
        
        return annotationView;
    }else if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    return nil;
}
#pragma mark - MAMapViewDelegate起点和终点

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.lineDash = YES;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 4;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:(MAMultiPolyline *)overlay];
        
        polylineRenderer.lineWidth = 4;
        polylineRenderer.lineDash = YES;
        polylineRenderer.strokeColor = [UIColor redColor];

//        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        //颜色渐变
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate
//周边搜索回调数据
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
        
    });
}
//根据输入提示搜索
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    //    NSSLog(@"返回信息:%@",response);
    if (response.tips.count == 0) {
        NSSLog(@"对不起，输入的关键字搜索不到信息，请重新输入");
        
        return;
    }
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:response.tips];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
    });
    
}
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
    NSSLog(@"检索失败原因%@",error);
}
-(void)searchTipsWithKey:(NSString *)key{
    
    if (key.length == 0) {
        return;
    }
    _tips = [AMapInputTipsSearchRequest new];
    //关键字
    _tips.keywords = key;
    //    _tips.city = self.cityStr;
    //不限制城市
    _tips.cityLimit = NO;
    [self.searchAPI AMapInputTipsSearch:_tips];
    
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PassagerAreaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PassagerAreaCell"];
    if (self.isTips) {
        AMapTip * tip = self.dataArr[indexPath.row];
        cell.areaLabel.text = tip.name;
    }else{
        AMapPOI * poi = self.dataArr[indexPath.row];
        cell.areaLabel.text = poi.name;
    }
   
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hiddenView:YES];
    //终点点击完毕给出最好路线,变成呼车界面
    if (self.isStart) {
        if (self.isTips) {
            AMapTip * tip = self.dataArr[indexPath.row];
            self.searchTF.text = tip.name;
            self.startAreaTF.text = tip.name;
            self.startCoordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
            self.area = [NSString stringWithFormat:@"%@%@%@",tip.district,tip.address,tip.name];
        }else{
            AMapPOI * poi = self.dataArr[indexPath.row];
            self.searchTF.text = poi.name;
            self.startAreaTF.text = poi.name;
            self.startCoordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            self.area = [NSString stringWithFormat:@"%@%@%@",poi.district,poi.address,poi.name];

        }
        NSSLog(@"%@",self.area);
        
    }else{
        AMapTip * tip = self.dataArr[indexPath.row];
        self.searchTF.text = tip.name;
        self.endAreaTF.text = tip.name;
        self.endCoordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
  
    }
    if (![ImageUrl isEmptyStr:self.startAreaTF.text] && ![ImageUrl isEmptyStr:self.endAreaTF.text]) {
        //位置录入
        NSMutableDictionary * params = [NSMutableDictionary new];
        [params setValue:self.userId forKey:@"userId"];
        [params setValue:self.area forKey:@"address"];
        [params setValue:[NSString stringWithFormat:@"%f",self.startCoordinate.longitude] forKey:@"longitude"];
        [params setValue:[NSString stringWithFormat:@"%f",self.startCoordinate.latitude] forKey:@"latitude"];
        [params setValue:@"0" forKey:@"type"];

        [self sendLocation:[NSString stringWithFormat:NetURL,LocationURL] andParams:params];
        //发起驾车路线速度最优
        [self getRoadData:0];
    }
   
    
}
-(void)sendLocation:(NSString *)url andParams:(NSMutableDictionary *)params{
    WeakSelf;
    [AFNetData postDataWithUrl:url andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"录入位置信息失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                
                [weakSelf aroundCarInfo];
            }else{
                [weakSelf showMessage:@"位置录入失败！"];
            }
        }
    }];
    
}
-(void)aroundCarInfo{
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,CarListURL] andParams:@{@"suerId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取附近车辆信息失败:%@",error);
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.callCarBtn.hidden = NO;
                    self.moneyView.hidden = NO;
                    self.titleLabel.text = @"确认呼叫";

                });
                NSArray * arr = data[@"data"];
                self.carNumLabel.text = [NSString stringWithFormat:@"附近约有%zi辆车",arr.count];
                
            }
        }
    }];
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
    self.moreView = [UIView claimMessageViewFrame:CGRectMake(KMainScreenWidth-105.5, 74, 95.5, 67) andArray:@[@"我的记录",@"我的评价"] andTarget:self andSel:@selector(moreAction:) andTag:305];
    [self.view addSubview:self.moreView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
-(void)tapClick{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.moreView.hidden = YES;
    });
}
-(void)moreAction:(UIButton *)btn{
    [self tapClick];
    if (btn.tag == 305) {
        //我的记录
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Passager" bundle:nil];
        PassagerRoadController * record = [sb instantiateViewControllerWithIdentifier:@"PassagerRoadController"];
        [self.navigationController pushViewController:record animated:YES];
        
    }
    else{
        //我的评价
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Driver" bundle:nil];
        MyCarCommentsController * comment = [sb instantiateViewControllerWithIdentifier:@"MyCarCommentsController"];
        comment.type = @"1";
        [self.navigationController pushViewController:comment animated:YES];
        
    }
}
- (IBAction)cancleClick:(id)sender {
    [self hiddenView:YES];

}
//城市搜索界面
- (IBAction)locationClick:(id)sender {
    
}
//叫车
- (IBAction)callCarClick:(id)sender {
}
#pragma mark-驾车路线
//驾车路线
-(void)getRoadData:(int)strate{
    self.searchRequest = [AMapDrivingRouteSearchRequest new];
    //是否返回扩展信息
    self.searchRequest.requireExtension = YES;
    //路线策略设置0 :速度优先 1：不收费的最快2：距离最优4：躲避拥堵 5：速度，距离，费用最优
    self.searchRequest.strategy = strate;
    //起点
    self.searchRequest.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    //目的
    self.searchRequest.destination = [AMapGeoPoint locationWithLatitude:self.endCoordinate.latitude longitude:self.endCoordinate.longitude];
    //发起驾车路线
    [self.searchAPI AMapDrivingRouteSearch:self.searchRequest];
    
}

#pragma mark-在地图上绘制起点和终点的路线
- (void)addDefaultAnnotations
{
    //清空之前的路线
    [self clear];
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
//    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.endCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
//    self.destinationAnnotation = destinationAnnotation;
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}
#pragma mark-路线数据
//路线搜索回调
-(void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{
    if (response.route == nil) {
        return;
    }
    //司机定位图标变成蓝色圆点
    MAUserLocationRepresentation * r = [MAUserLocationRepresentation new];
    //设置不显示精度圈
    r.showsAccuracyRing = NO;
    //设置蓝点指示方向
    r.showsHeadingIndicator = YES;
    [self.mapView updateUserLocationRepresentation:r];

    //解析response
    NSSLog(@"response：%ld,%ld",(unsigned long)response.route.paths.count,(long)response.count);
    //车费赋值
    
        for (AMapPath * path in response.route.paths) {
            NSSLog(@"%@--%.1f",path.strategy,path.tolls);
            NSString * money = [NSString stringWithFormat:@"约%.1f元",path.tolls];
                if ([path.strategy isEqualToString:@"速度最快"]) {
                    self.moneyLabel.attributedText = [ImageUrl messageTextColor:money andFirstString:@"约" andFirstColor:UIColorFromRGB(0xff7417) andFirstFont:[UIFont boldSystemFontOfSize:15] andSecondStr:money andSecondColor:UIColorFromRGB(0xff7417) andSecondFont:[UIFont boldSystemFontOfSize:20] andThirdStr:@"元" andThirdColor:UIColorFromRGB(0xff7417) andThirdFont:[UIFont boldSystemFontOfSize:15]];

                }
            
        }
    
    self.route = response.route;
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    }
}
/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.endCoordinate.latitude longitude:self.endCoordinate.longitude]];
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}
/* 清空地图上已有的路线. */
- (void)clear
{
    [self.naviRoute removeFromMapView];
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}

-(AMapSearchAPI *)searchAPI{
    
    if (!_searchAPI) {
        _searchAPI = [AMapSearchAPI new];
        
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}
-(AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [AMapLocationManager new];
        _locationManager.delegate = self;
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        //允许后台定位
        [_locationManager setAllowsBackgroundLocationUpdates:YES];
        [_locationManager setLocatingWithReGeocode:YES];  //设置返回逆地理信息 持续定位

        //定位位置显示 设置精度 10米内 需要最多10秒的时间最少2秒
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //定位延时
        _locationManager.locationTimeout = 2;
        //逆地理请求单词的
        _locationManager.reGeocodeTimeout = 2;
        
    }
    return _locationManager;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
@end
