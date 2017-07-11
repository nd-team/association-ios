//
//  GoodsListModel.m
//  CommunityProject
//
//  Created by bjike on 2017/7/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "GoodsListModel.h"

@implementation GoodsListModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"idStr":@"id"}];
}
-(CGFloat)height {
    
    CGFloat hei = 0;
    hei += [ImageUrl boundingRectWithString:self.synopsis width:(KMainScreenWidth-20) height:MAXFLOAT font:13].height;
    return hei + 373;
}
@end
