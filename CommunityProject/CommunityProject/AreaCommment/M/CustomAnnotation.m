//
//  CustomAnnotation.m
//  CommunityProject
//
//  Created by bjike on 2017/7/25.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.nearModel.pointX floatValue], [self.nearModel.pointY floatValue]);
}
-(id)initWithNearModel:(NearbyShopListModel *)nearModel{
    if (self = [super init]) {
        self.nearModel = nearModel;
    }
    return self;
}
@end
