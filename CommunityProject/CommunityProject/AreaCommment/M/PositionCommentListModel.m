//
//  PositionCommentListModel.m
//  CommunityProject
//
//  Created by bjike on 2017/7/20.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PositionCommentListModel.h"

@implementation PositionCommentListModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"idStr":@"id"}];
}
- (CGFloat)height {
    
    CGFloat hei = 0;
    hei += [ImageUrl boundingRectWithString:self.content width:(KMainScreenWidth-20) height:MAXFLOAT font:13].height;
    NSInteger count = self.images.count;
    NSInteger shu = count%3;
    if (count == 0) {
        return hei+106;
    }
    if (shu != 0) {
        hei = hei+count/3*100+100;
    }else{
        hei = hei+count/3*100;
    }
    return hei + 116;
}
@end
