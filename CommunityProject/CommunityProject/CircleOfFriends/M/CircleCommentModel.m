//
//  CircleCommentModel.m
//  CommunityProject
//
//  Created by bjike on 17/4/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CircleCommentModel.h"

@implementation CircleAnswerModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end
@implementation CircleCommentModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
- (CGFloat)height {
    
    CGFloat hei = 0;
    for (int i = 0; i < _replyUsers.count; i++) {
        CircleAnswerModel *model = _replyUsers[i];
        hei += [CircleCommentModel boundingRectWithString:[NSString stringWithFormat:@"%@回复%@:%@",model.nickname,model.fromNickname,model.content] width:(KMainScreenWidth-46) height:MAXFLOAT font:13].height;
        
        //暂定每个cell 为 文本高度 加上这个固定高度值
        if (i == _replyUsers.count -1 || i == 0) {
            hei += 15;

        }else{
            hei += 10;

        }
    }
    //内联tableView的高度 加上cell其他内容的高度，这里暂定
    return hei + 93;
}


//动态调节高度
+ (CGSize)boundingRectWithString:(NSString *)textStr width:(CGFloat)width height:(CGFloat)height font:(NSInteger)font{
    CGSize size;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName, nil];
    size = [textStr boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    return size;
}
@end
