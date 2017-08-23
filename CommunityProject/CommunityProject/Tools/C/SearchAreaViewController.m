//
//  SearchAreaViewController.m
//  ISSP
//
//  Created by bjike on 16/12/31.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "SearchAreaViewController.h"
#import "AreaCell.h"
#import "HistoryModel.h"
#import "AreaHistrorySingleton.h"

@interface SearchAreaViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AMapSearchDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (nonatomic,strong) NSMutableArray * dataArr;

@property (nonatomic,strong)AMapSearchAPI * searchAPI;
//发起搜索，关键字
//@property (nonatomic,strong)AMapPOIKeywordsSearchRequest * request;
//输入提示发起检索
@property (nonatomic,strong)AMapInputTipsSearchRequest * tips;

@property (nonatomic,assign)int flag;


@end

@implementation SearchAreaViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    //从数据库拿数据
    [self fromDatabaseData];
    
}
-(void)fromDatabaseData{
    
    [self.dataArr addObjectsFromArray:[[AreaHistrorySingleton shareDatabase]searchDatabase]];
    if (self.dataArr.count != 0) {
        self.flag = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];

        });
    }
    
}
-(void)setUI{
    [self.tableView registerNib:[UINib nibWithNibName:@"AreaCell" bundle:nil] forCellReuseIdentifier:@"AreaCell"];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 35)];
    backView.backgroundColor = UIColorFromRGB(0xeceef0);
    self.searchTF.leftView = backView;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    //手势回收键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
-(void)tapClick{
    [self.searchTF resignFirstResponder];
}
#pragma mark-手势影响控件问题
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]]) {
        
        return NO;
    }
    if ([touch.view isKindOfClass:[UITextField class]]) {
        
        return NO;
        
    }
    if ([touch.view isKindOfClass:[UITableView class]]) {
        
        return NO;
    }
    return YES;
}

- (IBAction)backClick:(id)sender {
    self.delegate.isCancle = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AreaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AreaCell"];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    if (self.flag == 2) {
        AMapTip * tip = self.dataArr[indexPath.row];
//        NSSLog(@"%@==%@",tip.name,tip.address);
        cell.areaLabel.text = [NSString stringWithFormat:@"%@%@",tip.name,tip.address];
    }else{
        //历史记录
        HistoryModel * model = self.dataArr[indexPath.row];
        cell.areaLabel.text = model.area;
    }
   
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.flag == 2) {
        AMapTip * poi = self.dataArr[indexPath.row];
//        NSSLog(@"%@=%@=%@",poi.name,poi.district,poi.address);
        self.searchTF.text = [NSString stringWithFormat:@"%@",poi.name];
        //回到上个界面传经纬度过去
        self.delegate.latitute = poi.location.latitude;
        self.delegate.longitude = poi.location.longitude;
        self.delegate.area = self.searchTF.text;
        [self saveHistory:poi.location.longitude andLati:poi.location.latitude];

    }else{
        HistoryModel * model = self.dataArr[indexPath.row];
        self.searchTF.text = [NSString stringWithFormat:@"%@",model.area];
        //回到上个界面传经纬度过去
        self.delegate.latitute = [model.latitude floatValue];
        self.delegate.longitude = [model.longitude floatValue];
        self.delegate.area = self.searchTF.text;
    }
    self.delegate.isCancle = NO;
    //保存搜索记录
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark-textfield的协议
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTF resignFirstResponder];
    self.flag = 2;
    //发起搜索
    [self searchTipsWithKey:textField.text];
    return YES;
}
-(void)saveHistory:(CGFloat)longitude andLati:(CGFloat)latitude{
    NSMutableArray * array = [NSMutableArray new];
    [array addObjectsFromArray:[[AreaHistrorySingleton shareDatabase]searchDatabase]];
    int i = 0;
    for (HistoryModel * model in array) {
        if ([model.area isEqualToString:self.searchTF.text]) {
            i++;
        }
    }
    if (i == 0) {
        NSString * time = [NowDate currentDetailTime];
        NSDictionary * dic = @{@"area":self.searchTF.text,@"longitude":[NSString stringWithFormat:@"%f",longitude],@"latitude":[NSString stringWithFormat:@"%f",latitude],@"time":time};
        HistoryModel * model = [[HistoryModel alloc]initWithDictionary:dic error:nil];
        [[AreaHistrorySingleton shareDatabase]insertDatabase:model];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //动态改变数据源
    //发起搜索
    [self searchTipsWithKey:textField.text];

}
//POI搜索信息返回

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
- (IBAction)cancleClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

@end
