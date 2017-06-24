//
//  FixMemoryLeak.h
//  ISSP
//
//  Created by bjike on 16/9/24.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import <Foundation/Foundation.h>

static AFHTTPSessionManager * manager;


@interface FixMemoryLeak : NSObject

+(AFHTTPSessionManager *) sharedHTTPSession;

@end
