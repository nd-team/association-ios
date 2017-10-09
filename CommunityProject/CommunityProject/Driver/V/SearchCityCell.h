//
//  SearchCityCell.h
//  CommunityProject
//
//  Created by bjike on 2017/8/5.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarBrandModel.h"

@interface SearchCityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *areaNameLabel;

@property (nonatomic,strong)CarBrandModel * brandModel;
@property (nonatomic,strong)SonModel * sonModel;

@end
