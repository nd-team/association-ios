//
//  DataSource.m
//  CommunityProject
//
//  Created by bjike on 17/3/17.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource
-(NSArray *)getApplictionData{
    
    NSDictionary * dic1 = @{@"name":@"干货分享",@"imageName":@"share.png"};
    
    NSDictionary * dic2 = @{@"name":@"灵感贩卖",@"imageName":@"sell.png"};
    
    NSDictionary * dic3 = @{@"name":@"认领中心",@"imageName":@"claimCenter.png"};
    
//    NSDictionary * dic4 = @{@"name":@"直播中心",@"imageName":@"seedCenter.png",@"isHidden":@"0"};
    
//    NSDictionary * dic5 = @{@"name":@"联盟打车",@"imageName":@"taxi.png",@"isHidden":@"0"};
    
//    NSDictionary * dic6 = @{@"name":@"导航",@"imageName":@"navigition.png",@"isHidden":@"0"};
    
    NSDictionary * dic7 = @{@"name":@"三分钟教学",@"imageName":@"education.png"};
    
    
//    NSDictionary * dic9 = @{@"name":@"游戏",@"imageName":@"train.png",@"isHidden":@"0"};
    
    NSDictionary * dic10 = @{@"name":@"求助中心",@"imageName":@"helpCenter.png"};
    
//    NSDictionary * dic11 = @{@"name":@"众筹",@"imageName":@"raise.png",@"isHidden":@"0"};
    NSDictionary * dic12 = @{@"name":@"平台活动",@"imageName":@"activity.png"};
    NSDictionary * dic13 = @{@"name":@"公益活动",@"imageName":@"goodAct.png"};
//    NSDictionary * dic14 = @{@"name":@"联盟司机",@"imageName":@"train.png",@"isHidden":@"0"};
    NSDictionary * dic8 = @{@"name":@"天气中心",@"imageName":@"weatherIcon.png"};

    NSDictionary * dic15 = @{@"name":@"位置点评",@"imageName":@"areaLove.png"};

    NSArray * arr = @[dic1,dic2,dic3,dic7,dic10,dic12,dic13,dic8,dic15];
    return arr;
}
@end
