//
//  ReduceImage.m
//  ISSP
//
//  Created by bjike on 16/9/13.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import "ReduceImage.h"

@implementation ReduceImage
//生成缩略图
+(NSData *)base64ImageThumbnaiWith:(UIImage *)image{
    
    UIImage * newImage = nil;
    
    CGSize size = CGSizeMake(100, 100);
    
    if (image == nil) {
        
        newImage = nil;
        
    }else{
        
        UIGraphicsBeginImageContext(size);
        
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    UIImage *baseImage = newImage;
    
    NSData * data = UIImageJPEGRepresentation(baseImage, 0.05);
    
    return data;
}
@end
