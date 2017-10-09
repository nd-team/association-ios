//
//  OutCarController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "OutCarController.h"
#import "CarLocationCustomView.h"
#import "DriverGrobListCell.h"
#import "DriverGrobListModel.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"
#import "MyCarCommentsController.h"
#import "DriverRecordController.h"
#import "DriverReceivableController.h"

static const NSString *RoutePlanningViewControllerStartTitle       = @"起";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终";
static const NSInteger RoutePlanningPaddingEdge                    = 20;
#define LocationURL @"appapi/app/positionInput"
#define DriverGrobListURL @"appapi/app/selectAroundOrder"
#define OrderURL @"appapi/app/driverRobOrder"
#define PickUpURL @"appapi/app/driverTakeUser"
//苹果没做
#define ArriveURL @"appapi/app/driverArriveAddressConfirm"
@interface OutCarController ()<MAMapViewDelegate,AMapLocationManagerDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>
@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *lookPeopleClick;
@property (nonatomic,strong)AMapLocationManager * locationManager;
@property (nonatomic,copy)NSString * userId;
@property (nonatomic,strong)UIView * moreView;
//标记右上角按钮是否弹出框
@property (nonatomic,assign)BOOL isShow;

@property (nonatomic,assign)int count;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
//记录当前位置信息
@property (nonatomic,assign)CLLocationCoordinate2D coordinate;
@property (nonatomic,copy)NSString * address;
//乘客起点终点地址，和电话
@property (nonatomic,copy)NSString * startAddress;
@property (nonatomic,copy)NSString * endAddress;
@property (nonatomic,copy)NSString * phone;

@property (nonatomic,assign)CLLocationCoordinate2D startCoordinate;
@property (nonatomic,assign)CLLocationCoordinate2D endCoordinate;
//搜索
@property (nonatomic,strong)AMapSearchAPI * searchAPI;
@property (nonatomic,strong)AMapDrivingRouteSearchRequest * searchRequest;
//路线
@property (nonatomic, strong) AMapRoute *route;
/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *startAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAreaLabel;
//区分下面按钮状态：查看附近订单0，退出1，接到乘客2，到达目的地3
@property (nonatomic,assign)int btnStatus;
//乘客ID
@property (nonatomic,copy)NSString * orderId;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *kilemileLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//标记table更多数据
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (nonatomic,copy)NSString * headPath;

@property (nonatomic,copy)NSString * allTime;

//轨迹数组
@property (nonatomic,strong)NSMutableArray<MATraceLocation *> *listArr;
@property (nonatomic,assign)    CGFloat distance ;
@property (nonatomic,strong)NSOperation * op;

@end

@implementation OutCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"联盟打车";
    UIBarButtonItem * leftItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:35 image:@"back.png"  and:self Action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem * rightItem = [UIBarButtonItem CreateImageButtonWithFrame:CGRectMake(0, 0, 50, 40)andMove:-35 image:@"topMore.png"  and:self Action:@selector(moreClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.userId = [DEFAULTS objectForKey:@"userId"];
    //关闭指南针
    self.mapView.showsCompass = NO;
    //关闭比例
    self.mapView.showsScale = NO;
    //设置地图缩放比例 值越大显示范围越小
    [self.mapView setZoomLevel:20 animated:NO];
    //显示定位小蓝点
    self.mapView.showsUserLocation = YES;
    //用户跟随模式
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    MAUserLocationRepresentation * r = [MAUserLocationRepresentation new];
    //设置不显示精度圈
    r.showsAccuracyRing = NO;
    //定位蓝点图标
    r.image = [UIImage imageNamed:@"locationGreen.png"];
    [self.mapView updateUserLocationRepresentation:r];
    self.tableView.hidden = YES;
    self.topView.hidden = YES;
    self.bottomView.hidden = YES;
    [self.moreBtn setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    [self.moreBtn setImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateSelected];
    [self.headImageView zy_cornerRadiusRoundingRect];
    self.count = 0;
    self.btnStatus = 0;
    [self.lookPeopleClick setTitle:@"查看附近呼车" forState:UIControlStateNormal];

}
-(void)moreViewUI{
    self.moreView = [UIView claimMessageViewFrame:CGRectMake(KMainScreenWidth-105.5, 0, 95.5, 67) andArray:@[@"我的记录",@"我的评价"] andTarget:self andSel:@selector(moreAction:) andTag:300];
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
    if (btn.tag == 300) {
        //我的记录
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Driver" bundle:nil];
        DriverRecordController * record = [sb instantiateViewControllerWithIdentifier:@"DriverRecordController"];
        [self.navigationController pushViewController:record animated:YES];
        
    }
    else{
        //我的评价
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Driver" bundle:nil];
        MyCarCommentsController * comment = [sb instantiateViewControllerWithIdentifier:@"MyCarCommentsController"];
        comment.type = @"2";
        [self.navigationController pushViewController:comment animated:YES];
        
    }
}
-(void)moreClick{
    self.isShow = !self.isShow;
    if (self.isShow) {
        WeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf moreViewUI];
        });
    }else{
        self.moreView.hidden = YES;
    }
    
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DriverGrobListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DriverGrobListCell"];
    cell.listModel = self.dataArr[indexPath.row];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    
    WeakSelf;
    cell.orderBlock = ^(NSString *startAddress, NSString *endAddress, NSString *phone, CLLocationCoordinate2D startCoor, CLLocationCoordinate2D endCoor,NSString * headUrl,NSString * idStr,NSString * kilemile,NSString * money,NSString * time) {
        self.startAddress = startAddress;
        self.endAddress = endAddress;
        self.phone = phone;
        self.startCoordinate = startCoor;
        self.endCoordinate = endCoor;
        self.orderId = idStr;
        self.kilemileLabel.text = kilemile;
        self.moneyLabel.text = money;
        self.headPath = headUrl;
        self.allTime = time;
        //路线规划，起点和终点
        [weakSelf isHiddenTable:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.topView.hidden = NO;
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:headUrl]]] placeholderImage:[UIImage imageNamed:@"default.png"]];
            self.startAreaLabel.text = startAddress;
            self.endAreaLabel.text = endAddress;
            //司机定位图标变成蓝色圆点
            MAUserLocationRepresentation * r = [MAUserLocationRepresentation new];
            //设置不显示精度圈
            r.showsAccuracyRing = NO;
            //设置蓝点指示方向
            r.showsHeadingIndicator = YES;
            [self.mapView updateUserLocationRepresentation:r];
            //发起路线检索，添加起点终点标注
            [weakSelf addDefaultAnnotations];
            [weakSelf getRoadData:0];
            [weakSelf driverOrder:idStr];
        });
        //司机下订单

    };
    
    return cell;
    
    
}
-(void)driverOrder:(NSString *)orderId{
    NSString * deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSMutableDictionary * params = [NSMutableDictionary new];
    [params setValue:self.userId forKey:@"userId"];
    [params setValue:orderId forKey:@"orderId"];
    [params setValue:deviceID forKey:@"key"];
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,OrderURL] andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"司机下订单失败:%@",error);
            [weakSelf showMessage:@"抢单失败！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                self.btnStatus = 2;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.lookPeopleClick.selected = NO;
                    [self.lookPeopleClick setTitle:@"接到乘客" forState:UIControlStateNormal];
                    [self.lookPeopleClick setBackgroundImage:[UIImage imageNamed:@"endAndApp"] forState:UIControlStateNormal];
                    
                });
            }else{
                [weakSelf showMessage:@"抢单失败！"];
            }
        }
    }];
}
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
    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.endCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    self.destinationAnnotation = destinationAnnotation;
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.moreBtn.selected && self.dataArr.count>5) {
        return 5;
    }else{
        return self.dataArr.count;
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.tabBarController.tabBar.hidden = YES;
    self.mapView.delegate = self;
    //开始定位 持续定位
    [self.locationManager startUpdatingLocation];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.locationManager stopUpdatingLocation];
    self.mapView.delegate = nil;
    [self.op cancel];

}
#pragma mark-路线数据
//路线搜索回调
-(void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{
    if (response.route == nil) {
        return;
    }
    //解析response
    NSSLog(@"response：%ld,%ld",(unsigned long)response.route.paths.count,(long)response.count);
//    for (AMapPath * path in response.route.paths) {
//        NSSLog(@"%@",path.strategy);
//            if ([path.strategy isEqualToString:@"速度最快"]) {
//                
//            }
//            if ([path.strategy isEqualToString:@"距离最短"]) {
//            }
//            
//        //费用最优
//        if ([path.strategy isEqualToString:@"费用最低"]) {
//            
//        }
//        //不堵车
//        if ([path.strategy isEqualToString:@"参考交通信息最快"]) {
//        }
//    }
    
    self.route = response.route;
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    }
}
//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"检索失败：%@",error);
}
/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
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

#pragma mark - AMapLocationManagerDelegate
//定位出错
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    NSSLog(@"定位出错：%@",error);
}
//定位结果
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    self.count++;
//    [self.mapView removeAnnotations:self.mapView.annotations];
    //设置地图中心点
    [self.mapView setCenterCoordinate:location.coordinate];
    self.coordinate = location.coordinate;
    self.address = [NSString stringWithFormat:@"%@%@%@",reGeocode.city,reGeocode.district,reGeocode.street];
//    [self.locationManager stopUpdatingLocation];
    //23.126562===113.387727
//    NSSLog(@"%f===%f",location.coordinate.latitude,location.coordinate.longitude);
    if (self.count == 1) {
        [self addAnnotationWithCooordinate:location.coordinate];
    }

}
-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [self.mapView addAnnotation:annotation];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    
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
            annotationView.centerOffset = CGPointMake(0, -45);
        }
        annotationView.name = @"我在这里";
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
        polylineRenderer.strokeColor = [UIColor redColor];

//        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        //颜色渐变
        polylineRenderer.gradient = YES;
        polylineRenderer.lineDash = YES;

        return polylineRenderer;
    }
    
    return nil;
}
#pragma mark-查看附近打车数据
- (IBAction)lookPassagersClick:(id)sender {
    switch (self.btnStatus) {
            //查看附近订单
        case 0:
        {
            [self isHiddenTable:NO];
            NSMutableDictionary * params = [NSMutableDictionary new];
            [params setValue:self.userId forKey:@"userId"];
            [params setValue:self.address forKey:@"address"];
            [params setValue:[NSString stringWithFormat:@"%f",self.coordinate.longitude] forKey:@"longitude"];
            [params setValue:[NSString stringWithFormat:@"%f",self.coordinate.latitude] forKey:@"latitude"];
            [params setValue:@"1" forKey:@"type"];
            [self sendLocation:[NSString stringWithFormat:NetURL,LocationURL] andParams:params andType:0];
        }
            break;
            //退出订单界面
        case 1:
            [self isHiddenTable:YES];
            break;
            //接乘客
        case 2:
        {
            NSMutableDictionary * params = [NSMutableDictionary new];
            [params setValue:self.userId forKey:@"userId"];
            [params setValue:self.orderId forKey:@"orderId"];
            [self sendLocation:[NSString stringWithFormat:NetURL,PickUpURL] andParams:params andType:2];

        }
            break;
        default:
            //到达目的地
            //进入结算收款界面,计算运动轨迹的时间差
            
        {
            [self tranceList];
           
        }
            break;
    }
    
}
-(void)tranceList{
    MATraceManager *manager = [[MATraceManager alloc] init];
//    WeakSelf;
    self.op = [manager queryProcessedTraceWith:self.listArr type:AMapCoordinateTypeGPS processingCallback:^(int index, NSArray<MATracePoint *> *points) {
        //分段处理
    } finishCallback:^(NSArray<MATracePoint *> *points, double distance) {
        //全部处理
//        weakSelf.distance = distance;
        NSString * startTime = [DEFAULTS objectForKey:@"receivePassagerStartTime"];
        NSString * endTime = [NowDate currentDetailTime];
        //运动时间
        NSString * timeCha = [NowDate dateTimeDifferenceWithStartTime:startTime endTime:endTime];
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Driver" bundle:nil];
        DriverReceivableController * money = [sb instantiateViewControllerWithIdentifier:@"DriverReceivableController"];
        money.headUrl = self.headPath;
        money.startArea = self.startAddress;
        money.endArea = self.endAddress;
        money.phone = self.phone;
        money.money = self.moneyLabel.text;
        money.kilomile = self.kilemileLabel.text;
        money.timeCha = self.allTime;
        money.time = timeCha;
        money.orderId = self.orderId;
        //运动里程计算
        money.motionKilo = [NSString stringWithFormat:@"%.2f",distance];
        [self.navigationController pushViewController:money animated:YES];
    } failedCallback:^(int errorCode, NSString *errorDesc) {
        //失败回调
        NSSLog(@"轨迹纠偏失败：%@",errorDesc);
    }];
}
-(void)isHiddenTable:(BOOL)isHidden{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.hidden = isHidden;
    });
}
-(void)sendLocation:(NSString *)url andParams:(NSMutableDictionary *)params andType:(int)type{
    WeakSelf;
    [AFNetData postDataWithUrl:url andParams:params returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"录入位置信息失败：%@",error);
            [weakSelf infomation:type];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                if (type == 0) {
                    //获取附近订单
                    [weakSelf lookOrderData];
                }else if (type == 2){
                    //保存接到乘客的时间
                    NSString * time = [NowDate currentDetailTime];
                    [DEFAULTS setValue:time forKey:@"receivePassagerStartTime"];
                    [DEFAULTS synchronize];
                    //接到乘客
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //计算出里程数和总金额并显示
                        self.bottomView.hidden = NO;
                        [self.lookPeopleClick setTitle:@"到达目的地" forState:UIControlStateNormal];
                        [self.lookPeopleClick setBackgroundImage:[UIImage imageNamed:@"endAndApp"] forState:UIControlStateNormal];
                    });
                }
               
            }else{
                [weakSelf infomation:type];

            }
        }
    }];

}
-(void)infomation:(int)type{
    if (type == 0) {
        [self showMessage:@"位置信息录入失败！"];
    }else if(type == 2){
        [self showMessage:@"接到乘客失败！"];
    }
}
-(void)lookOrderData{
    WeakSelf;
    [AFNetData postDataWithUrl:[NSString stringWithFormat:NetURL,DriverGrobListURL] andParams:@{@"userId":self.userId} returnBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"获取订单失败：%@",error);
            [weakSelf showMessage:@"附近订单查看失败！"];
        }else{
            NSNumber * code = data[@"code"];
            if ([code intValue] == 200) {
                self.btnStatus = 1;
                [self.lookPeopleClick setTitle:@"退出" forState:UIControlStateNormal];
                NSArray * jsonArr = data[@"data"];
                for (NSDictionary * dict in jsonArr) {
                    DriverGrobListModel * model = [[DriverGrobListModel alloc]initWithDictionary:dict error:nil];
                    [self.dataArr addObject:model];
                }
            }else{
                [weakSelf showMessage:@"附近订单查看失败！"];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];

}
- (IBAction)callPhoneClick:(id)sender {
    NSURL * urlStr = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phone]];
    [[UIApplication sharedApplication]openURL:urlStr];

}
- (IBAction)moreTableClick:(id)sender {
    self.moreBtn.selected = !self.moreBtn.selected;
    if (self.dataArr.count <= 5) {
        //提示没有更多数据
        [self showMessage:@"没有更多订单咯！"];
    }else{
        //展开更多数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}
#pragma mark-轨迹纠偏 改变位置时调用
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    if(updatingLocation){
//        self.currentLocation = userLocation;
        MATraceLocation * location = [[MATraceLocation alloc]init];
        location.loc = userLocation.coordinate;
        [self.listArr addObject:location];
    }
}
-(void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    NSSLog(@"定位失败%@",error);
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
-(AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [AMapLocationManager new];
        _locationManager.delegate = self;
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        //允许后台定位
        [_locationManager setAllowsBackgroundLocationUpdates:YES];
        //定位位置显示 设置精度 10米内 需要最多10秒的时间最少2秒
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [_locationManager setLocatingWithReGeocode:YES];  //设置返回逆地理信息 持续定位
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
-(AMapSearchAPI *)searchAPI{
    if (!_searchAPI) {
        _searchAPI = [AMapSearchAPI new];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}
-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [NSMutableArray new];
    }
    return _listArr;
}
@end
