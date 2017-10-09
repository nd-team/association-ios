//
//  CircleListModel.m
//  CommunityProject
//
//  Created by bjike on 17/4/15.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CircleListModel.h"

@implementation CircleListModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
-(CGFloat)height {
    CGFloat hei = 0;
    hei += [ImageUrl boundingRectWithString:self.content width:(KMainScreenWidth-37) height:MAXFLOAT font:13].height;
    NSInteger count = self.images.count;
    NSInteger shu = count%3;
    if (count == 0) {
        return hei+112;
    }
    if (shu != 0) {
        hei = hei+count/3*103+103;
    }else{
        hei = hei+count/3*103;
    }
    return hei + 112;
}
@end
