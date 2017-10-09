//
//  HistoryModel.h
//  ISSP
//
//  Created by bjike on 17/2/11.
//  Copyright © 2017年 bjike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryModel : JSONModel

@property (nonatomic,copy)NSString * area;

@property (nonatomic,copy)NSString * longitude;

@property (nonatomic,copy)NSString * latitude;

@property (nonatomic,copy)NSString * time;

@end
