//
//  CommentsListModel.m
//  CommunityProject
//
//  Created by bjike on 17/5/22.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CommentsListModel.h"

@implementation CommentsListModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
- (CGFloat)height {
    
    CGFloat hei = 0;
    hei += [ImageUrl boundingRectWithString:self.content width:(KMainScreenWidth-63) height:MAXFLOAT font:13].height;
    return hei + 75;
}
@end
