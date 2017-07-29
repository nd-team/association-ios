//
//  PositionMapController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PositionMapController.h"
#import "PositionCommentListCell.h"
#import "PositionCommentListModel.h"
#import "PositionCommentListController.h"
#import "WriteCommentController.h"
#import "PositionCommentDetailController.h"
#import "NearbyShopListModel.h"
#import "CustomAnnotationView.h"
#import "CustomAnnotation.h"
#import <AMapSearchKit/AMapSearchKit.h>

#define CommentList @"comment/list"
#define ShopURL @"shop/nearby"
#define ScoreURL @"comment/score"
@interface PositionMapController ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet MAMapView *mapView;
//定位
@property (nonatomic,strong)AMapLocationManager * locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;

@property (weak, nonatomic) IBOutlet UIImageView *fourthImage;
@property (weak, nonatomic) IBOutlet UIImageView *fivethImage;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (nonatomic,strong)NSMutableArray * dataArr;
//选中地点的ID
@property (nonatomic,copy)NSString * pointId;
@property (nonatomic,copy)NSString * userId;

@property (nonatomic,strong)AMapSearchAPI * search;
//保存在地图上点击获取的数据
@property (nonatomic,copy)NSString * shopname;
@property (nonatomic,copy)NSString * areaId;
//经度
@property (nonatomic,assign)CGFloat  longitude;
//纬度
@property (nonatomic,assign)CGFloat  latitude;
//地址
@property (nonatomic,copy)NSString * area;

@property (nonatomic,assign)int count;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation PositionMapController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.tabBarController.tabBar.hidden = YES;
    self.mapView.delegate = self;
    self.count = 0;
    //开始定位 持续定位
    [self.locationManager startUpdatingLocation];
    if (self.isRefresh) {
        [self getCommentListData];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userId = [DEFAULTS objectForKey:@"userId"];
    //关闭指南针
    self.mapView.showsCompass = NO;
    //关闭比例
    self.mapView.showsScale = NO;
    //设置地图缩放比例 值越大显示范围越小
    [self.mapView setZoomLevel:20 animated:NO];
    [self.tableView registerNib:[UINib nibWithNibName:@"PositionCommentListCell" bundle:nil] forCellReuseIdentifier:@"PositionCommentListCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 277;
    self.tableView.hidden = YES;
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PositionCommentListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PositionCommentListCell"];
    cell.commentModel = self.dataArr[indexPath.row];
    cell.tableView = self.tableView;
    cell.dataArr = self.dataArr;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PositionCommentListModel * model = self.dataArr[indexPath.row];
    if (model.height != 0) {
        return model.height;
    }
    return 277;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArr.count < 5) {
        return self.dataArr.count;
    }
    return 5;
    
}
//评论详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PositionCommentListCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    PositionCommentListModel * model = self.dataArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Position" bundle:nil];
    PositionCommentDetailController * detail = [sb instantiateViewControllerWithIdentifier:@"PositionCommentDetailController"];
    detail.headUrl = model.headPath;
    detail.nickname = model.nickname;
    detail.time = model.createTime;
    detail.score = model.scoreType;
    detail.comment = model.content;
    [detail.collectArr addObjectsFromArray: model.images];
    detail.isLove = cell.loveBtn.selected;
    detail.commentId = [NSString stringWithFormat:@"%zi",model.idStr];
    [self.navigationController pushViewController:detail animated:YES];
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
//写点评
- (IBAction)writeCommentClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Position" bundle:nil];
    WriteCommentController * write = [sb instantiateViewControllerWithIdentifier:@"WriteCommentController"];
    write.shopname = self.shopname;
    write.areaId = self.areaId;
    write.area = self.area;
    write.longitude = self.longitude;
    write.latitude = self.latitude;
    write.delegate = self;
    [self.navigationController pushViewController:write animated:YES];

}
//关闭评论列表
- (IBAction)closeClick:(id)sender {
    self.tableView.hidden = YES;
}
//查看更多评论
- (IBAction)lookMoreCommentClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Position" bundle:nil];
    PositionCommentListController * comment = [sb instantiateViewControllerWithIdentifier:@"PositionCommentListController"];
    comment.pointId = self.pointId;
    [self.navigationController pushViewController:comment animated:YES];
}

- (IBAction)moreClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Position" bundle:nil];
    PositionCommentListController * comment = [sb instantiateViewControllerWithIdentifier:@"PositionCommentListController"];
    comment.pointId = self.pointId;

    [self.navigationController pushViewController:comment animated:YES];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.mapView.delegate = nil;
    //停止定位
    [self.locationManager stopUpdatingLocation];
}
#pragma mark - MAMapViewDelegate
//自定义标注图标
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CustomAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        CustomAnnotation * anno = (CustomAnnotation *)annotation;
        NearbyShopListModel * model = anno.nearModel;
        annotationView.portrait = [UIImage imageNamed:@"restaurant"];
        annotationView.name = model.name;
        //不足3个评价的处理 没有图片的处理
        if (model.images) {
            annotationView.imageArr = model.images;
        }
        return annotationView;
    }
    return nil;
}
//点击自定义标注
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    [self.mapView deselectAnnotation:view.annotation animated:YES];
    self.tableView.hidden = NO;
    CustomAnnotation * anno = (CustomAnnotation *)view.annotation;
    self.pointId = anno.nearModel.pointId;
    self.shopname = anno.nearModel.name;
    self.areaId = anno.nearModel.pointId;
    self.latitude = [anno.nearModel.pointX floatValue];
    self.longitude = [anno.nearModel.pointY floatValue];
    self.area = anno.nearModel.address;
    //初始化表头
    self.shopNameLabel.text = anno.nearModel.name;
    NSSLog(@"地址%@",anno.nearModel.address);
    if (anno.nearModel.address) {
        self.areaLabel.text = anno.nearModel.address;
    }else{
        self.areaLabel.text = @"";
    }
    [self getAllData];
}
-(void)getAllData{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    WeakSelf;
    dispatch_group_async(group,queue , ^{
        //店铺总评分获取
        [weakSelf getScoreCount];
    });
    dispatch_group_async(group,queue , ^{
        //评论列表获取
        [weakSelf getCommentListData];
    });
    
    dispatch_group_notify(group, queue, ^{
        //
        NSSLog(@"请求数据完毕");
        
    });
    
}
-(void)getScoreCount{
    NSString * url = [NSString stringWithFormat:JAVAURL,ScoreURL];
    WeakSelf;
    [JavaGetNet getDataWithUrl:[NSString stringWithFormat:@"%@/%@",url,self.pointId] andParams:nil andHeader:self.userId getBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"店铺评分失败：%@",error);
        }else{
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"code"];
//            NSSLog(@"%@",jsonDic);
            
            if ([code intValue] == 0) {
                //总评分
                NSString * scoreCount = jsonDic[@"data"];
                if ([scoreCount isEqualToString:@"FIRST"]) {
                    [weakSelf setBackImage:@"starYellow" andSecond:@"starDark" andThird:@"starDark" andFourth:@"starDark" andFifth:@"starDark"];
                }else if ([scoreCount isEqualToString:@"SECOND"]){
                    [weakSelf setBackImage:@"starYellow" andSecond:@"starYellow" andThird:@"starDark" andFourth:@"starDark" andFifth:@"starDark"];

                }else if ([scoreCount isEqualToString:@"THIRD"]){
                    [weakSelf setBackImage:@"starYellow" andSecond:@"starYellow" andThird:@"starYellow" andFourth:@"starDark" andFifth:@"starDark"];

                }else if ([scoreCount isEqualToString:@"FOURTH"]){
                    [weakSelf setBackImage:@"starYellow" andSecond:@"starYellow" andThird:@"starYellow" andFourth:@"starYellow" andFifth:@"starDark"];

                }else if ([scoreCount isEqualToString:@"FIFTH"]){
                    [weakSelf setBackImage:@"starYellow" andSecond:@"starYellow" andThird:@"starYellow" andFourth:@"starYellow" andFifth:@"starYellow"];
  
                }
            }
        }
    }];
}
-(void)getCommentListData{
    WeakSelf;
    [JavaGetNet getDataWithUrl:[NSString stringWithFormat:JAVAURL,CommentList] andParams:@{@"pointId":self.pointId} andHeader:self.userId getBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"评论列表失败%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            if (weakSelf.dataArr.count != 0) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"code"];
            NSSLog(@"%@",jsonDic);
            if ([code intValue] == 0) {
                if ([[jsonDic allKeys] containsObject:@"data"]) {
                    NSArray * arr = jsonDic[@"data"];
                    if (arr.count != 0) {
                        for (NSDictionary * dict in arr) {
                            PositionCommentListModel * model = [[PositionCommentListModel alloc]initWithDictionary:dict error:nil];
                            [weakSelf.dataArr addObject:model];
                        }
                        self.countLabel.text = [NSString stringWithFormat:@"网友点评(%zi)",arr.count];
                    }else{
                       self.countLabel.text = @"网友点评";
                    }
//                    NSSLog(@"%@",arr);
                }
                
            }else{
                [weakSelf showMessage:@"获取评论失败！"];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

-(void)setBackImage:(NSString *)firstName andSecond:(NSString *)secondName andThird:(NSString *)thirdName andFourth:(NSString *)fourthName andFifth:(NSString *)fifthName{
    self.firstImage.image = [UIImage imageNamed:firstName];
    self.secondImage.image = [UIImage imageNamed:secondName];
    self.thirdImage.image = [UIImage imageNamed:thirdName];
    self.fourthImage.image = [UIImage imageNamed:fourthName];
    self.fivethImage.image = [UIImage imageNamed:fifthName];
}
//点击地图跳转点评界面缺少详细地址数据需要使用POI获取
- (void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois{
    for (MATouchPoi * poi in pois) {
        self.shopname = poi.name;
        self.areaId = poi.uid;
        self.longitude = poi.coordinate.longitude;
        self.latitude = poi.coordinate.latitude;
    }
    //发起检索
    [self sendSearch:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
}
-(void)sendSearch:(CLLocationCoordinate2D)coor{
    AMapReGeocodeSearchRequest * regeo = [AMapReGeocodeSearchRequest new];
    //设置中心点坐标
    regeo.location = [AMapGeoPoint locationWithLatitude:coor.latitude longitude:coor.longitude];
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
    
}
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if (response.regeocode != nil) {
        AMapAddressComponent * com = response.regeocode.addressComponent;
        NSString * address = [NSString stringWithFormat:@"%@%@%@%@%@",com.province,com.city,com.district,com.township,com.building];
        NSSLog(@"==%@",address);
        self.area = address;
        if (address.length == 0) {
            return;
        }
        //进入点评界面
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Position" bundle:nil];
        WriteCommentController * write = [sb instantiateViewControllerWithIdentifier:@"WriteCommentController"];
        write.shopname = self.shopname;
        write.areaId = self.areaId;
        write.area = self.area;
        write.longitude = self.longitude;
        write.latitude = self.latitude;
        write.delegate = self;
        [self.navigationController pushViewController:write animated:YES];
    }
}
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    [self showMessage:@"未获取到位置信息"];
    NSSLog(@"检索失败：%@",error);
}

#pragma mark - AMapLocationManagerDelegate
 //定位出错
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    NSSLog(@"定位出错：%@",error);
}
 //定位结果
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    self.count ++;
    //设置地图中心点
    [self.mapView setCenterCoordinate:location.coordinate];
    self.coordinate = location.coordinate;
   // NSSLog(@"定位纬度%f++经度%f",location.coordinate.latitude,location.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];
    if (self.count == 1) {
        [self aroundShop];
    }
}

-(void)aroundShop{
    [self.mapView removeAnnotations:self.mapView.annotations];
    WeakSelf;
    NSDictionary * dict = @{@"pointY":[NSString stringWithFormat:@"%f",self.coordinate.latitude],@"pointX":[NSString stringWithFormat:@"%f",self.coordinate.longitude],@"range":@"500"};
  //  NSSLog(@"%@",dict);
    [JavaGetNet getDataWithUrl:[NSString stringWithFormat:JAVAURL,ShopURL] andParams:dict andHeader:self.userId getBlock:^(NSURLResponse *response, NSError *error, id data) {
        if (error) {
            NSSLog(@"附近店铺失败：%@",error);
            [weakSelf showMessage:@"服务器出错咯！"];
        }else{
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"code"];
            //取得经纬度添加标注
            //添加标注视图
            if ([code intValue] == 0) {
                NSArray * arr = jsonDic[@"data"];
                for (NSDictionary * dict in arr) {
                    NSString * pointX = dict[@"pointX"];
                    NSString * pointY = dict[@"pointY"];
                    NearbyShopListModel * model = [[NearbyShopListModel alloc]initWithDictionary:dict error:nil];
                    CustomAnnotation * cus = [[CustomAnnotation alloc]initWithNearModel:model];
                    //纬度经度
                    cus.coordinate = CLLocationCoordinate2DMake([pointX floatValue], [pointY floatValue]);
//                    NSSLog(@"pointX:%@pointY===%@",pointX,pointY);
                    [self.mapView addAnnotation:cus];
                }
                //显示标注
               [self.mapView showAnnotations:self.mapView.annotations animated:YES];
            }else{
                [weakSelf showMessage:@"查看附近商铺失败！"];
            }
        }
    }];
}
- (IBAction)exitClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        [_locationManager setAllowsBackgroundLocationUpdates:NO];
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
-(AMapSearchAPI *)search{
    if (!_search) {
        _search = [AMapSearchAPI new];
        _search.delegate = self;
    }
    return _search;
}
@end
