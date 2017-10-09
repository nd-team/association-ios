//
//  CarShapeController.m
//  CommunityProject
//
//  Created by bjike on 2017/8/7.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CarShapeController.h"
#import "SearchCityCell.h"
#import "CarColorCell.h"
#import "BMChineseSort.h"
#import "CarBrandModel.h"

//1e33fd00667a6
#define CarBrandURL @"http://apicloud.mob.com/car/brand/query?key=1e33fd00667a6"
@interface CarShapeController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *shapeTableView;
@property (weak, nonatomic) IBOutlet UITableView *colorTableView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
//标记 是否搜索
@property (nonatomic,assign)BOOL isSearch;

@property (nonatomic,strong)NSMutableArray * searchArr;
//车型
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * nameArr;
@property (nonatomic,strong)NSMutableArray * colorArr;
//索引
@property (nonatomic,strong)NSMutableArray * indexArr;
@property (nonatomic,strong)NSMutableArray * hotArr;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchRightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidthCons;
@property (nonatomic,strong)NSMutableString * shape;
//detailTable上一次的选择
@property (nonatomic,strong)NSIndexPath * lastPath;

@end

@implementation CarShapeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shapeTableView.sectionIndexColor = UIColorFromRGB(0x333333);
    self.shapeTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 34)];
    UIImageView * leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 18, 20)];
    leftImageView.image = [UIImage imageNamed:@"searchDark.png"];
    [leftView addSubview:leftImageView];
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    self.searchTF.leftView = leftView;
    [self.shapeTableView registerNib:[UINib nibWithNibName:@"SearchCityCell" bundle:nil] forCellReuseIdentifier:@"CarShapeCell"];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"SearchCityCell" bundle:nil] forCellReuseIdentifier:@"CarDetailCell"];
    self.detailTableView.hidden = YES;
    self.colorTableView.hidden = YES;
    [self changeButtonFrame:0 andRight:21];
    self.lastPath = nil;
    WeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [weakSelf getCarShapeData];
    });
    

}
-(void)getCarShapeData{
    WeakSelf;
    [GetCommonNet getDataWithUrl:CarBrandURL andParams:nil getBlock:^(NSURLResponse *response, NSError *error, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
        if (error) {
            NSSLog(@"车型查询失败:%@",error);
            [weakSelf showMessage:@"查询车型失败！"];
        }else{
            if (weakSelf.dataArr.count != 0) {
                [weakSelf.dataArr removeAllObjects];
            }
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber * code = jsonDic[@"retCode"];
            NSMutableArray * arr = [NSMutableArray new];
            if ([code intValue] == 200) {
                NSArray * jsonArr = jsonDic[@"result"];
                for (NSDictionary * dict in jsonArr) {
                    CarBrandModel * model = [[CarBrandModel alloc]initWithDictionary:dict error:nil];
                    if ([model.name containsString:@"大众"]||[model.name containsString:@"丰田"]||[model.name containsString:@"奔驰"]||[model.name containsString:@"宝马"]||[model.name containsString:@"现代"]||[model.name isEqualToString:@"东风"]) {
                        [self.hotArr addObject:model];
                    }
                    [arr addObject:model];
                }
                //字母排序
                NSArray * sortArr = [BMChineseSort IndexWithArray:arr Key:@"name"];
                [self.indexArr addObjectsFromArray:sortArr];
                [self.dataArr addObjectsFromArray:[BMChineseSort sortObjectArray:arr Key:@"name"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.shapeTableView reloadData];
            });
        }
    }];
}
#pragma mark - tableView-delegate and DataSources
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (tableView == self.colorTableView) {
        CarColorCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CarColorCell"];
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xffeca9);
        [cell showView:self.colorArr[indexPath.row]];
        return cell;
        
    }else{
        
        if (tableView == self.shapeTableView) {
            SearchCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CarShapeCell"];
            cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xffeca9);
            if (self.isSearch) {
                cell.brandModel = [self.searchArr objectAtIndex:indexPath.row];
            
            }else{
                if (indexPath.section == 0) {
                    //热门车型
                    cell.brandModel = self.hotArr[indexPath.row];
                }else{
                    //A,B,C...分组
                    cell.brandModel = [[self.dataArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row];
                }
            }
            return cell;
            
        }else{
            SearchCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CarDetailCell"];
            cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xffeca9);
            //车型类型
            cell.sonModel = self.nameArr[indexPath.row];
            return cell;
            
        }
        
    }
}
//每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.detailTableView) {
        return self.nameArr.count;
    }else if (tableView == self.colorTableView){
        return self.colorArr.count;
    }else{
        if (self.isSearch) {
            return self.searchArr.count;
        }else{
            //返回了所有的数据
            if (section == 0) {
                return self.hotArr.count;
            }else{
                //数组越界了
                return [self.dataArr[section-1] count];
            }
        }
    }
    
    
}
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSearch) {
        return 1;
    }
    if (tableView == self.shapeTableView) {
        return self.indexArr.count+1;
    }else{
        return 1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isSearch) {
        return nil;
    }else{
        if (tableView == self.shapeTableView) {
            
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 34)];
            view.backgroundColor = UIColorFromRGB(0xECEEF0);
            UILabel * label = [[UILabel alloc]init];
            if (section != 0) {
                label.frame = CGRectMake(21, 0, 100, 34);
                label.text = self.indexArr[section-1];

            }
            else{
                UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(21, 10, 15, 15)];
                imageView.image = [UIImage imageNamed:@"hotImg.png"];
                [view addSubview:imageView];
                label.frame = CGRectMake(42, 0, 100, 34);
                label.text = @"热门车型";
            }
            label.backgroundColor =  UIColorFromRGB(0xECEEF0);
            label.textColor = UIColorFromRGB(0x666666);
            label.font = [UIFont systemFontOfSize:15];
            [view addSubview:label];
            return view;
        }else{
            return nil;
        }
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isSearch) {
        return 0.001;
    }
    if (tableView == self.shapeTableView) {
        return 34;
    }else{
        return 0.001;
    }
}
//右侧的数组
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.isSearch) {
        return nil;
    }
    if (tableView == self.shapeTableView) {
        NSArray * arr = @[@"↑"];
        return [arr arrayByAddingObjectsFromArray:self.indexArr];
    }else{
        return nil;
    }
  
}
//右侧索引
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (self.isSearch) {
        return 0;
    }
    if (tableView == self.shapeTableView) {
        return index;
    }else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.shapeTableView) {
        [self.nameArr removeAllObjects];
        self.shape = [NSMutableString new];
        self.detailTableView.hidden = YES;
        self.colorTableView.hidden = YES;
        //nameArr数据源
        if (self.isSearch) {
            CarBrandModel * brand = self.searchArr[indexPath.row];
            [self.shape appendString: brand.name];
            NSArray * array = brand.son;
            for (SonModel * son in array) {
                [self.nameArr addObject:son];
            }
        }else{
            if (indexPath.section == 0) {
                CarBrandModel * model = self.hotArr[indexPath.row];
                [self.shape appendString: model.name];
                NSArray * arr = model.son;
                for (SonModel * son in arr) {
                    [self.nameArr addObject:son];
                }
            }else{
                CarBrandModel * model = self.dataArr[indexPath.section-1][indexPath.row];
                [self.shape appendString: model.name];
                NSArray * arr = model.son;
                for (SonModel * son in arr) {
                    [self.nameArr addObject:son];
                }
            }
           
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.detailTableView.hidden = NO;
            [self.detailTableView reloadData];
        });
        
    }else if (tableView == self.detailTableView){
        SonModel * son = self.nameArr[indexPath.row];
        if (self.lastPath != nil) {
            SonModel * last = self.nameArr[self.lastPath.row];
            NSRange  range = [self.shape rangeOfString:last.type];
            [self.shape replaceCharactersInRange:range withString:son.type];
        }else{
            [self.shape appendFormat:@" %@ ",son.type];
        }
        self.lastPath = indexPath;
        //多次选择清空上次选的再拼接这次的
        dispatch_async(dispatch_get_main_queue(), ^{
            self.colorTableView.hidden = NO;
            [self.colorTableView reloadData];
        });
        
    }else{
        [self.shape appendString:self.colorArr[indexPath.row]];
        self.delegate.shapeStr = self.shape;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
    
    
    
}
#pragma mark-发起搜索
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //发起搜索
    self.isSearch = YES;
    [self.searchTF resignFirstResponder];
    [self.searchArr removeAllObjects];
    for (NSArray * arr in self.dataArr) {
        for (CarBrandModel * model in arr) {
            if ([self.searchTF.text containsString:model.name]) {
                [self.searchArr addObject:model];
            }
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
        [self.shapeTableView reloadData];
    });
}
-(void)changeButtonFrame:(CGFloat)width andRight:(CGFloat)right{
    [UIView animateWithDuration:0.3 animations:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.btnWidthCons.constant = width;
            self.searchRightCons.constant = right;
        });
    }];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
-(NSMutableArray *)nameArr{
    if (!_nameArr) {
        _nameArr = [NSMutableArray new];
    }
    return _nameArr;
}
-(NSMutableArray *)colorArr{
    if (!_colorArr) {
        _colorArr = [NSMutableArray new];
        [_colorArr addObjectsFromArray:@[@"黑",@"白",@"银",@"红",@"橙",@"黄",@"绿",@"蓝",@"靛",@"紫",@"棕",@"粉"]];
    }
    return _colorArr;
}
-(NSMutableArray *)indexArr{
    if (!_indexArr) {
        _indexArr = [NSMutableArray new];
    }
    return _indexArr;
}
-(NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [NSMutableArray new];
    }
    return _searchArr;
}
-(NSMutableArray *)hotArr{
    if (!_hotArr) {
        _hotArr = [NSMutableArray new];
    }
    return _hotArr;
}
-(void)showMessage:(NSString *)msg{
    [self.navigationController.view makeToast:msg];
}
@end
