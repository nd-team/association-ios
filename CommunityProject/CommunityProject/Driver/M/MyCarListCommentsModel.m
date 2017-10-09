//
//  MyCarListCommentsModel.m
//  CommunityProject
//
//  Created by bjike on 2017/8/12.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "MyCarListCommentsModel.h"

@implementation MyCarListCommentsModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
-(CGFloat)height {
    
    CGFloat hei = 0;
    hei += [ImageUrl boundingRectWithString:self.content width:(KMainScreenWidth-50) height:MAXFLOAT font:13].height;

    return hei + 100;
}
@end
