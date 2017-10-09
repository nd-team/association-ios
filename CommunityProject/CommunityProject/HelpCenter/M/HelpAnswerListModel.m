
//
//  HelpAnswerListModel.m
//  CommunityProject
//
//  Created by bjike on 2017/7/3.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "HelpAnswerListModel.h"

@implementation HelpAnswerListModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"idStr":@"id"}];
}
- (CGFloat)height {
    
    CGFloat hei = 0;
    hei += [ImageUrl boundingRectWithString:self.content width:(KMainScreenWidth-20) height:MAXFLOAT font:13].height;
    return hei + 98;
}
@end
