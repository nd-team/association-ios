//
//  AFSecuteCertificate.h
//  ISSP
//
//  Created by bjike on 16/12/16.
//  Copyright © 2016年 bjike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFSecuteCertificate : NSObject
+(AFSecurityPolicy *)customSecurityPolicy:(NSString *)name;

@end
