//
//  CustomAnnotation.h
//  CommunityProject
//
//  Created by bjike on 2017/7/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NearbyShopListModel.h"

@interface CustomAnnotation : NSObject<MAAnnotation>

@property (nonatomic,strong)NearbyShopListModel * nearModel;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

-(id)initWithNearModel:(NearbyShopListModel *)nearModel;

@end
