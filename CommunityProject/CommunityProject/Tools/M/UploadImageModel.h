//
//  UploadImageModel.h
//  ISSP
//
//  Created by bjike on 16/8/9.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadImageModel : NSObject

@property (nonatomic,copy) UIImage * image;

@property (nonatomic,assign) BOOL isPlaceHolder;

@property (nonatomic,assign) BOOL isHide;

@end
