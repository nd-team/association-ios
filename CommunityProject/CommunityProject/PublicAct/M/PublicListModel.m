//
//  PublicListModel.m
//  CommunityProject
//
//  Created by bjike on 17/5/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PublicListModel.h"

@implementation PublicListModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
- (CGFloat)height {
    
    CGFloat hei = 0;
    hei += [ImageUrl boundingRectWithString:self.content width:(KMainScreenWidth-20) height:MAXFLOAT font:12].height;
    return hei + 354;
}
@end
