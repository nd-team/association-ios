//
//  WeatherListController.m
//  CommunityProject
//
//  Created by bjike on 2017/7/14.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "WeatherListController.h"
#import "WeekWeatherCell.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "WeatherListModel.h"
#import "ChooseAreaController.h"

#define WeatherListURL @"http://www.freedt.cn/api/onebox/weather/query"

@interface WeatherListController ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *disLabel;
@property (weak, nonatomic) IBOutlet UILabel *roadLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
//定位
@property (nonatomic,strong)AMapLocationManager * locationManager;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation WeatherListController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.tabBarController.tabBar.hidden = YES;
    if (self.city.length != 0) {
        self.cityLabel.text = self.city;
        [self addData];
    }
}
-(void)addData{
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf getWeatherData];
    });
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeLabel.text = [NowDate getCurrentDetailTime];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.headerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.26];
    self.timeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
    self.roadLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
    self.updateTimeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
    self.viewHeightCons.constant = 0;
    [self singleLocation];
    //上滑手势弹出7天天气预报
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeClick)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipe];
    //下滑不显示一周天气
    UISwipeGestureRecognizer * downSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downSwipeClick)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:downSwipe];
    
}
-(void)swipeClick{
    [UIView animateWithDuration:2 animations:^{
        self.viewHeightCons.constant = 356;
    }];
}
-(void)downSwipeClick{
    [UIView animateWithDuration:2 animations:^{
        self.viewHeightCons.constant = 0;
    }];
}
-(void)singleLocation{
    WeakSelf;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            NSSLog(@"%@",error);
            if (error.code == AMapLocationErrorLocateFailed) {
                //失败是否重新回调
                [weakSelf singleLocation];
//                [weakSelf showMessage:@"定位失败"];
                return ;
            }
        }
        if (regeocode) {
            //定位数据发起周边检索给数据源然后刷新列表
            self.cityLabel.text = regeocode.city;
            self.disLabel.text = regeocode.district;
            self.roadLabel.text = [NSString stringWithFormat:@"%@%@",regeocode.street,regeocode.number];
//            NSSLog(@"%@=%@=%@=%@",regeocode.POIName,regeocode.AOIName,regeocode.street,regeocode.number);
//            定位成功发起天气查询
            [weakSelf addData];
        }
    }];
    

}
-(void)getWeatherData{
    WeakSelf;
    NSMutableDictionary * mDic = [NSMutableDictionary new];
    [mDic setValue:self.cityLabel.text forKey:@"cityname"];
    [mDic setValue:@"59697aadfee76f7803ee44f5" forKey:@"call_key"];
    [GetCommonNet getDataWithUrl:WeatherListURL andParams:mDic getBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
        if (error) {
            NSSLog(@"天气查询失败:%@",error);
        }else{
            if (weakSelf.dataArr.count != 0) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSSLog(@"%@",jsonDic);
            NSNumber * code = jsonDic[@"error_code"];
            if ([code intValue] == 0) {
                NSDictionary * realTime = jsonDic[@"result"][@"data"][@"realtime"];
                //更新时间
                weakSelf.updateTimeLabel.text = [NSString stringWithFormat:@"%@",realTime[@"time"]];
                //实时天气
                NSDictionary * currentDic = realTime[@"weather"];
                //当前温度
                weakSelf.currentLabel.text = [NSString stringWithFormat:@"%@",currentDic[@"temperature"]];
                //当前状况（雨，雪，等）
                NSString * climate = currentDic[@"info"];
                if ([climate containsString:@"多云"]) {
                    [weakSelf commonBack:@"cloudy" andSmallImg:@"cloudySmall"];
                }else if ([climate containsString:@"雾"]){
                    [weakSelf commonBack:@"smogMor" andSmallImg:@"fog"];
                }else if ([climate containsString:@"雪"]){
                    [weakSelf commonBack:@"snowMor" andSmallImg:@"snowSmall"];
                    
                }else if ([climate containsString:@"雨"]){
                    [weakSelf commonBack:@"rainMor" andSmallImg:@"rainSmall"];
                    
                }else if ([climate containsString:@"冰雹"]){
                    [weakSelf commonBack:@"hail" andSmallImg:@"hailSmall"];
                    
                }else if ([climate containsString:@"风暴"]){
                    [weakSelf commonBack:@"morStorm" andSmallImg:@"stormSmall"];
                }else if ([climate containsString:@"浮沉"]){
                    [weakSelf commonBack:@"dust" andSmallImg:@"upSmall"];
                    
                }else if ([climate containsString:@"雷阵雨"]){
                    [weakSelf commonBack:@"thunderShower" andSmallImg:@"thunSnow"];
                    
                }else if ([climate containsString:@"龙卷风"]){
                    [weakSelf commonBack:@"thunderShower" andSmallImg:@"tornado"];
                    
                }else if ([climate containsString:@"晴"]){
                    [weakSelf commonBack:@"sunshineMor" andSmallImg:@"sun"];
                    
                }else if ([climate containsString:@"台风"]){
                    [weakSelf commonBack:@"typhoonBack" andSmallImg:@"typhoon"];
                    
                }else if ([climate containsString:@"霜冻"]){
                    [weakSelf commonBack:@"frost" andSmallImg:@"frostSmall"];
                    
                }else if ([climate containsString:@"阴"]){
                    [weakSelf commonBack:@"overcast" andSmallImg:@"overcastSmall"];
                    
                }else{
                    [weakSelf commonBack:@"sunshineMor" andSmallImg:@"sun"];
                    
                }
                NSArray * futureWeather = jsonDic[@"result"][@"data"][@"weather"];
                //取出第一个数组
                NSDictionary * info = futureWeather[0][@"info"];
                //当天最低和最高温度
                NSString * lowest = info[@"night"][2];
                NSString * hight = info[@"day"][2];
                weakSelf.todayLabel.text = [NSString stringWithFormat:@"%@~%@°C",lowest,hight];
                for (NSDictionary * dict in futureWeather) {
                    WeatherListModel * model = [[WeatherListModel alloc]initWithDictionary:dict error:nil];
                    [weakSelf.dataArr addObject:model];
                }
            }else{
                [weakSelf showMessage:@"查询天气失败"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
-(void)commonBack:(NSString *)backImg andSmallImg:(NSString *)img{
    self.backImageView.image = [UIImage imageNamed:backImg];
    self.weatherImage.image = [UIImage imageNamed:img];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeekWeatherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WeekWeatherCell"];
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    cell.model = self.dataArr[indexPath.row];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

- (IBAction)changeAreaClick:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Weather" bundle:nil];
    ChooseAreaController * area = [sb instantiateViewControllerWithIdentifier:@"ChooseAreaController"];
    area.delegate = self;
    area.area = self.cityLabel.text;
    [self.navigationController pushViewController:area animated:YES];

}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
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
        //定位延时
        _locationManager.locationTimeout = 2;
        //逆地理请求单词的
        _locationManager.reGeocodeTimeout = 2;
        
    }
    return _locationManager;
}

@end
